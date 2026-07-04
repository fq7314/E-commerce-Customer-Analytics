import sqlite3

# Connect to the SQLite database
conn = sqlite3.connect("retail_project.db")
cursor = conn.cursor()

# Show all tables in the database
cursor.execute("SELECT name FROM sqlite_master WHERE type='table';")
tables = cursor.fetchall()

print("Tables in database:")
for table in tables:
    print(table[0])

# Close the connection
conn.close()