import psycopg2

# establishing the connection
conn = psycopg2.connect(
    database="gisdb", user="niva", password="n1v4", host="192.168.1.203", port="25431"
)
# Creating a cursor object using the cursor() method
cursor = conn.cursor()

# Executing an MYSQL function using the execute() method
# cursor.execute("select version()")
cursor.execute("SELECT count(*) from gsaa")

# Fetch a single row using fetchone() method.
data = cursor.fetchone()
print("Connection established to: ", data)
print(data)
# Closing the connection
conn.close()
