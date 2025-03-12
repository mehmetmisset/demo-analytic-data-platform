# Import
import pandas as pd

# Import for Spark, Azure Blob Storage, SQL
from azure.storage.blob import BlobServiceClient
from pyspark.sql        import SparkSession
from sqlalchemy         import create_engine

# Import from IO
from io import StringIO
from io import BytesIO

def blob_csv_to_df(

    # Input Parameteres
    abs_1_csv_nm_account,
    abs_2_csv_tx_sas_token,
    abs_3_csv_nm_container,
    abs_4_csv_tx_folder,
    abs_5_csv_nm_file,
    abs_6_csv_nm_decode,
    abs_7_csv_is_1st_header,

    # Debugging
    is_debugging
):

    # Helper SAS Token URL
    tx_sas_url = "spark.hadoop.fs.azure.sas." + abs_3_csv_nm_container + "." + abs_1_csv_nm_account + ".blob.core.windows.net"
    header        = "true" if (abs_7_csv_is_1st_header == "1") else "false"
    
    # Initialize Spark session
    spark = SparkSession.builder.appName("Load CSV from Blob").getOrCreate()

    # Define the path to the CSV file in the blob container
    tx_blob_container_path =  "wasbs://" + abs_3_csv_nm_container+  "@" + abs_1_csv_nm_account + ".blob.core.windows.net/"
    tx_blob_container_path =+ abs_4_csv_tx_folder + "/" + abs_5_csv_nm_file + ".csv"

    # Load the CSV file into a DataFrame using the SAS token
    df = spark.read.format("csv") \
         .option("header", header) \
         .option("encoding", abs_6_csv_nm_decode) \
         .option(tx_sas_url, abs_2_csv_tx_sas_token) \
         .load(tx_blob_container_path)

    if (is_debugging == "1"): 
        print("abs_1_csv_nm_account    : '" + abs_1_csv_nm_account + "'")
        print("abs_2_csv_tx_sas_token  : '********'")
        print("abs_3_csv_nm_container  : '" + abs_3_csv_nm_container + "'")
        print("abs_4_csv_tx_folder     : '" + abs_4_csv_tx_folder + "'")
        print("abs_5_csv_nm_file       : '" + abs_5_csv_nm_file + "'")
        print("abs_6_csv_nm_decode     : '" + abs_6_csv_nm_decode + "'")
        print("abs_7_csv_is_1st_header : '" + abs_7_csv_is_1st_header + "'")
        print("DataFrame:")
        df.show(10)

    # All done
    return df

def blob_excel_to_df(
        
    # Input Parameters
    abs_1_xls_nm_account,
    abs_2_xls_tx_sas_token,
    abs_3_xls_nm_container,
    abs_4_xls_tx_folder,
    abs_5_xls_nm_file,
    abs_6_xls_nm_decode,
    abs_7_xls_is_1st_header,

    # Debugging
    is_debugging
):

    # Azure Blob Helpers
    tx_blob_name   = abs_4_xls_tx_folder + abs_5_xls_nm_file
    tx_account_url = "https://" + abs_1_xls_nm_account + ".blob.core.windows.net"

    # Create BlobServiceClient
    ob_blob_service_client = BlobServiceClient(account_url=tx_account_url, credential=abs_2_xls_tx_sas_token)

    # Get the blob client
    ob_blob_client = ob_blob_service_client.get_blob_client(container=abs_3_xls_nm_container, blob=tx_blob_name)

    # Download the blob content
    ob_blob_content = ob_blob_client.download_blob().readall()

    # Convert the blob content to a pandas DataFrame
    ob_excel_bytes = BytesIO(ob_blob_content)
    df = pd.read_excel(ob_excel_bytes, engine='openpyxl')

    # Convert the first row to header
    if (abs_7_xls_is_1st_header == "1"): 
        df.columns = df.iloc[0]
        df = df[1:]

    # Initialize Spark session
    spark = SparkSession.builder.appName("BlobExcelToSparkDataFrame").getOrCreate()

    # Return Converted the pandas DataFrame to a Spark DataFrame
    return spark.createDataFrame(df)

def sql_to_df(

    # Input Parameters:
    sql_1_nm_server,
    sql_2_nm_username,
    sql_3_nm_database,
    sql_4_nm_secret,
    sql_5_tx_query,

    # Debugging
    is_debugging
):

    # Initialize Spark session
    spark = SparkSession.builder \
        .appName("ExampleApp") \
        .config("spark.jars", "/path/to/mssql-jdbc.jar") \
        .getOrCreate()

    # Database credentials
    jdbc_url = "jdbc:sqlserver://" + sql_1_nm_server + ";databaseName=" + sql_3_nm_database + ""
    db_properties = {
        "user"     : sql_2_nm_username,
        "password" : sql_4_nm_secret,
        "driver"   : "com.microsoft.sqlserver.jdbc.SQLServerDriver"
    }

    # Run SQL query
    result_df = spark.sql(sql_5_tx_query)

    # Show the result
    result_df.show()    