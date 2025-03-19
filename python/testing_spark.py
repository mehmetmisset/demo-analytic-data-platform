from azure.storage.blob import BlobServiceClient, BlobClient, ContainerClient
import os

# Define the connection string and the blob details
accountname = 'add your account name here'
accesskey = 'add your access key here'
connection_string = f"DefaultEndpointsProtocol=https;AccountName={accountname};AccountKey={accesskey};EndpointSuffix=core.windows.net"
container_name = "yahoo"
blob_name = "statis_data/currency.xlsx"
download_file_path = "C:/temp/currency.xlsx"

# Create the BlobServiceClient object
blob_service_client = BlobServiceClient.from_connection_string(connection_string)

# Create the BlobClient object
blob_client = blob_service_client.get_blob_client(container=container_name, blob=blob_name)

# Download the blob to a local file
with open(download_file_path, "wb") as download_file:
    download_file.write(blob_client.download_blob().readall())

print(f"Downloaded {blob_name} to {download_file_path}")