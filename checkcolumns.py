import sqlite3

conn = sqlite3.connect("retail_project.db")
cursor = conn.cursor()

cursor.execute("PRAGMA table_info(retail_raw);")
columns = cursor.fetchall()

print("Columns in retail_raw:")
for column in columns:
    print(column[1])

conn.close()