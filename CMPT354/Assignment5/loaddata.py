import pyodbc
from connect_db import connect_db


def loadRentalPlan(filename, conn):
    """
        Input:
            $filename: "RentalPlan.txt"
            $conn: you can get it by calling connect_db()
        Functionality:
            1. Create a table named "RentalPlan" in the "VideoStore" database on Azure
            2. Read data from "RentalPlan.txt" and insert them into "RentalPlan"
               * Columns are separated by '|'
               * You can use executemany() to insert multiple rows in bulk
    """
    cursor = conn.execute("Create table RentalPlan(pid INT, pname VARCHAR(50), monthly_fee FLOAT, max_movies INT, PRIMARY KEY(pid))")
    f = open(filename,"r")    
    for line in f:
        tuple = line.split('|')
        i = 0
        for tuple[i] in tuple:
            tuple[i] = tuple[i].strip()
            i = i+1 
        conn.execute('Insert into RentalPlan(pid, pname, monthly_fee , max_movies) values(?,?,?,?)', tuple)
    f.close()


def loadCustomer(filename, conn):
    """
        Input:
            $filename: "Customer.txt"
            $conn: you can get it by calling connect_db()
        Functionality:
            1. Create a table named "Customer" in the "VideoStore" database on Azure
            2. Read data from "Customer.txt" and insert them into "Customer".
               * Columns are separated by '|'
               * You can use executemany() to insert multiple rows in bulk
    """
    cursor = conn.execute("Create table Customer(cid INT, pid INT, username VARCHAR(50), password VARCHAR(50),PRIMARY KEY(cid), FOREIGN KEY(pid) REFERENCES RentalPlan ON DELETE CASCADE)")
    f = open(filename,"r")    
    for line in f:
        tuple = line.split('|')
        i = 0
        for tuple[i] in tuple:
            tuple[i] = tuple[i].strip()
            i = i+1 
        conn.execute('Insert into Customer(cid, pid, username, password) values(?,?,?,?)',tuple)
    f.close()



def loadMovie(filename, conn):
    """
        Input:
            $filename: "Movie.txt"
            $conn: you can get it by calling connect_db()
        Functionality:
            1. Create a table named "Movie" in the "VideoStore" database on Azure
            2. Read data from "Movie.txt" and insert them into "Movie".
               * Columns are separated by '|'
               * You can use executemany() to insert multiple rows in bulk
    """
    cursor = conn.execute("Create Table Movie(mid INT, mname VARCHAR(50), year INT, PRIMARY KEY(mid))")
    f = open(filename,"r")    
    for line in f:
        tuple = line.split('|')
        i = 0
        for tuple[i] in tuple:
            tuple[i] = tuple[i].strip()
            i = i+1 
        conn.execute('Insert into Movie(mid, mname, year) values(?,?,?)',tuple)
    f.close()

def loadRental(filename, conn):
    """
        Input:
            $filename: "Rental.txt"
            $conn: you can get it by calling connect_db()
        Functionality:
            1. Create a table named "Rental" in the VideoStore database on Azure
            2. Read data from "Rental.txt" and insert them into "Rental".
               * Columns are separated by '|'
               * You can use executemany() to insert multiple rows in bulk
    """
    cursor = conn.execute("Create Table Rental(cid INT, mid INT, date_and_time DATETIME, status VARCHAR(6), FOREIGN KEY(cid) REFERENCES Customer ON DELETE CASCADE , FOREIGN KEY(mid) REFERENCES Movie ON DELETE CASCADE)")
    f = open(filename,"r")    
    for line in f:
        tuple = line.split('|')
        i = 0
        for tuple[i] in tuple:
            tuple[i] = tuple[i].strip()
            i = i+1 
        conn.execute('Insert into Rental(cid, mid, date_and_time, status) values(?,?,?,?)', tuple)
    f.close()


def dropTables(conn):
    conn.execute("DROP TABLE IF EXISTS Rental")
    conn.execute("DROP TABLE IF EXISTS Customer")
    conn.execute("DROP TABLE IF EXISTS RentalPlan")
    conn.execute("DROP TABLE IF EXISTS Movie")



if __name__ == "__main__":
    conn = connect_db()

    dropTables(conn)

    loadRentalPlan("RentalPlan.txt", conn)
    loadCustomer("Customer.txt", conn)
    loadMovie("Movie.txt", conn)
    loadRental("Rental.txt", conn)


    conn.commit()
    conn.close()






