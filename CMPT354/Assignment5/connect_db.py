import pyodbc


def connect_db():
    ODBC_STR = "Driver={ODBC Driver 18 for SQL Server};Server=tcp:jashan.database.windows.net,1433;Database=cmpt354-db;Uid=jashan;Pwd={Jasha+1980};Encrypt=yes;TrustServerCertificate=no;Connection Timeout=30;"
    return pyodbc.connect(ODBC_STR)


if __name__ == '__main__':
    print(pyodbc.drivers())
    print(connect_db())
