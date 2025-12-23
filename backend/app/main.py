from fastapi import FastAPI
import mysql.connector
import os

app = FastAPI(title="Cloud Native Backend API")

DB_HOST = os.getenv("DB_HOST", "localhost")
DB_USER = os.getenv("DB_USER", "clouduser")
DB_PASSWORD = os.getenv("DB_PASSWORD", "cloudpass")
DB_NAME = os.getenv("DB_NAME", "cloudapp")

def get_connection():
    return mysql.connector.connect(
        host=DB_HOST,
        user=DB_USER,
        password=DB_PASSWORD,
        database=DB_NAME
    )

@app.get("/health")
def health_check():
    return {"status": "ok"}

@app.get("/items")
def get_items():
    conn = get_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT id, name FROM items")
    rows = cursor.fetchall()
    cursor.close()
    conn.close()
    return rows

@app.post("/items")
def create_item(name: str):
    conn = get_connection()
    cursor = conn.cursor()
    cursor.execute(
        "INSERT INTO items (name) VALUES (%s)",
        (name,)
    )
    conn.commit()
    cursor.close()
    conn.close()
    return {"message": "Item created"}
