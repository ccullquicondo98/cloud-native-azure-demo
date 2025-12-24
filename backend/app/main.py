from fastapi import FastAPI, UploadFile, File, HTTPException
from fastapi.responses import StreamingResponse
import mysql.connector
import os

from azure.storage.blob import BlobServiceClient

app = FastAPI(title="Cloud Native Backend API")

# -------------------------
# Configuración MySQL
# -------------------------
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

# -------------------------
# Configuración Blob Storage
# -------------------------
AZURE_STORAGE_CONNECTION_STRING = os.getenv("AZURE_STORAGE_CONNECTION_STRING")
BLOB_CONTAINER_NAME = "objects"

def get_blob_container():
    if not AZURE_STORAGE_CONNECTION_STRING:
        raise RuntimeError("AZURE_STORAGE_CONNECTION_STRING no definido")

    blob_service_client = BlobServiceClient.from_connection_string(
        AZURE_STORAGE_CONNECTION_STRING
    )
    return blob_service_client.get_container_client(BLOB_CONTAINER_NAME)

# -------------------------
# Endpoints existentes
# -------------------------
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

# -------------------------
# NUEVOS ENDPOINTS – Blob Storage
# -------------------------

@app.post("/files/upload")
async def upload_file(file: UploadFile = File(...)):
    try:
        container = get_blob_container()
        blob_client = container.get_blob_client(file.filename)

        data = await file.read()
        blob_client.upload_blob(data, overwrite=True)

        return {
            "message": "Archivo subido correctamente",
            "filename": file.filename
        }

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))


@app.get("/files/download/{filename}")
def download_file(filename: str):
    try:
        container = get_blob_container()
        blob_client = container.get_blob_client(filename)

        if not blob_client.exists():
            raise HTTPException(status_code=404, detail="Archivo no encontrado")

        stream = blob_client.download_blob()

        return StreamingResponse(
            stream.chunks(),
            media_type="application/octet-stream",
            headers={
                "Content-Disposition": f"attachment; filename={filename}"
            }
        )

    except Exception as e:
        raise HTTPException(status_code=500, detail=str(e))
