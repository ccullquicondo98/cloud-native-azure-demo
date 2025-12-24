import os
from azure.storage.blob import BlobServiceClient

CONTAINER_NAME = "objects"

def get_blob_container():
    conn_str = os.getenv("AZURE_STORAGE_CONNECTION_STRING")
    if not conn_str:
        raise RuntimeError("AZURE_STORAGE_CONNECTION_STRING no definido")

    blob_service_client = BlobServiceClient.from_connection_string(conn_str)
    container_client = blob_service_client.get_container_client(CONTAINER_NAME)

    return container_client
