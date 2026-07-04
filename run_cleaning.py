import sqlite3

conn = sqlite3.connect("retail_project.db")
cursor = conn.cursor()

with open("sql/01_clean.sql", "r", encoding="utf-8") as file:
    sql_script = file.read()

cursor.executescript(sql_script)

conn.commit()

raw_count = cursor.execute("SELECT COUNT(*) FROM retail_raw;").fetchone()[0]
clean_count = cursor.execute("SELECT COUNT(*) FROM retail_clean;").fetchone()[0]

print("Cleaning complete.")
print(f"Raw rows: {raw_count}")
print(f"Clean rows: {clean_count}")
print(f"Rows removed: {raw_count - clean_count}")

conn.close()