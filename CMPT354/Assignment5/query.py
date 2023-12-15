from flask import Flask, g, request, jsonify
import pyodbc
from connect_db import connect_db
import sys
import time, datetime


app = Flask(__name__)

@app.route('/')
def hello_world():
    return 'Hello, World!'

def get_db():
    """Opens a new database connection if there is none yet for the
    current application context.
    """
    if not hasattr(g, 'azure_db'):
        g.azure_db = connect_db()
        g.azure_db.autocommit = True
        g.azure_db.set_attr(pyodbc.SQL_ATTR_TXN_ISOLATION, pyodbc.SQL_TXN_SERIALIZABLE)
    return g.azure_db

@app.teardown_appcontext
def close_db(error):
    """Closes the database again at the end of the request."""
    if hasattr(g, 'azure_db'):
        g.azure_db.close()



@app.route('/login')
def login():
    username = request.args.get('username', "")
    password = request.args.get('password', "")
    cid = -1
    #print (username, password)
    conn = get_db()
    #print (conn)
    cursor = conn.execute("SELECT * FROM Customer WHERE username = ? AND password = ?", (username, password))
    records = cursor.fetchall()
    #print records
    if len(records) != 0:
        cid = records[0][0]
    response = {'cid': cid}
    return jsonify(response)




@app.route('/getRenterID')
def getRenterID():
    """
       This HTTP method takes mid as input, and
       returns cid which represents the customer who is renting the movie.
       If this movie is not being rented by anyone, return cid = -1
    """
    mid = int(request.args.get('mid', -1))

    conn = get_db()
    cursor = conn.execute("Select r.cid from Rental r where r.mid = ? and r.status = 'open'",mid)
    records = cursor.fetchone()
    if records == None:
        cid = -1
    elif len(records)!=0:
        cid = records[0]
    response = {'cid': cid}
    return response



@app.route('/getRemainingRentals')
def getRemainingRentals():
    """
        This HTTP method takes cid as input, and returns n which represents
        how many more movies that cid can rent.

        n = 0 means the customer has reached its maximum number of rentals.
    """
    cid = int(request.args.get('cid', -1))
    n = 0 
    conn = get_db()
    # Tell ODBC that you are starting a multi-statement transaction
    conn.autocommit = False
    cursor = conn.execute("Select rp.pname,c.cid from RentalPlan rp , Customer c where c.cid = ? and c.pid = rp.pid", cid)
    records = cursor.fetchone()
    plan = records
    if records == None:
        n = -1
    else:
        cursor = conn.execute("Select count(r.mid) from Rental r where r.cid = ? and r.status = 'open' GROUP BY r.cid,r.mid", cid)
        records1 = cursor.fetchone()
        if records1 == None:
            substraction = 0
        else:
            substraction = int(records1[0])
        #print(records)  
        if n != -1 :
            if records[0] == 'Basic':
                n = 1 - substraction
            elif records[0] == 'Rental Plus':
                n = 3 - substraction
            elif records[0] == 'Super Access':
                n = 5 - substraction
            elif records[0] == 'Ultra Access':
                n = 10 - substraction

   # r = 'blue'
    conn.autocommit = True
   # if records[0] == 'Super Access':
    #    r = 'green'
    response = {"remain ": n}
    return jsonify(response)





def currentTime():
    ts = time.time()
    return datetime.datetime.fromtimestamp(ts).strftime('%Y-%m-%d %H:%M:%S')


@app.route('/rent')
def rent():
    """
        This HTTP method takes cid and mid as input, and returns either "success" or "fail".

        It returns "fail" if C1, C2, or both are violated:
            C1. at any time a movie can be rented to at most one customer.
            C2. at any time a customer can have at most as many movies rented as his/her plan allows.
        Otherwise, it returns "success" and also updates the database accordingly.
    """
    cid = int(request.args.get('cid', -1))
    mid = int(request.args.get('mid', -1))
    result = 0
    n = 0
    conn = get_db()

     # Tell ODBC that you are starting a multi-statement transaction
    conn.autocommit = False
    cursor = conn.execute("Select r.cid from Rental r where r.mid = ? and r.status = 'open'",mid)
    records = cursor.fetchone()
    if records == None:
        cursor = conn.execute("Select rp.pname,c.cid from RentalPlan rp , Customer c where c.cid = ? and c.pid = rp.pid", cid)
        records = cursor.fetchone()
        plan = records
        if records == None:
            n = -1
        else:
            cursor = conn.execute("Select count(r.mid) from Rental r where r.cid = ? and r.status = 'open' GROUP BY r.cid,r.mid", cid)
            records1 = cursor.fetchone()
            if records1 == None:
                substraction = 0
            else:
                substraction = int(records1[0])
            #print(records)  
            if n != -1 :
                if records[0] == 'Basic':
                    n = 1 - substraction
                elif records[0] == 'Rental Plus':
                    n = 3 - substraction
                elif records[0] == 'Super Access':
                    n = 5 - substraction
                elif records[0] == 'Ultra Access':
                    n = 10 - substraction
        if n>0:
            conn.execute("Insert into Rental(cid,mid,date_and_time, status) values(?,?,?,?)",cid,mid,currentTime(),'open')
            result = 1
        else:
            result = -1
    else:
        result = -1

    conn.autocommit = True

    if result == 1:
        response = {"rent": "success"}
    else:
        response = {"rent": "fail"}
    return jsonify(response)

