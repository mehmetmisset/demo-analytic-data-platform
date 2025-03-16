# Description: Python module to load data from various sources into a Spark DataFrame.
# - abs_sas_url_csv   : Load a CSV file from Azure Blob Storage into a Spark DataFrame using a SAS token.
# - abs_sas_url_xls   : Load an Excel file from Azure Blob Storage into a Spark DataFrame using a SAS token.
# - sql_user_password : Load data from a SQL Server database into a Spark DataFrame.
# - web_table_anonymous_web : Load a table from a webpage into a Spark DataFrame.

# Import Custom Modules
from modules import session     as ss
from modules import secret      as sc 
from modules import run         as rn

# Import for web_table_anonymous_web
import pandas as pd
import time
from selenium.webdriver.common.by import By as by
from selenium                     import webdriver
from bs4                          import BeautifulSoup
from io                           import StringIO

def abs_sas_url_csv(

    # Input Parameteres
    abs_1_csv_nm_account,           # Account          | Name of Azure Storage Account (abs).
    abs_2_csv_nm_secret,            # Secret           | Name of the Secret in the Azure Key Vault.
    abs_3_csv_nm_container,         # Container        | Name of Container where the "CSV" file can be found.
    abs_4_csv_ds_folderpath,        # Folderpath       | Folderpath to the "CSV"-file in the Container.
    abs_5_csv_ds_filename,          # Has Header       | Filename of the "CSV"-file.
    abs_6_csv_nm_decode,            # Encoding         | Encoding of the file.
    abs_7_csv_is_1st_header,        # Has Header       | Is first record Header.
    abs_8_csv_cd_delimiter_value,   # Delimiter Value  | Character of the Delimiter for Values.
    abs_9_csv_cd_delimter_text,     # Delimter Text    | Character of the Delimiter for Text.

    # Debugging
    is_debugging
):

    # Helper SAS Token URL
    tx_sas_token = sc.get_secret(abs_2_csv_nm_secret, is_debugging)
    tx_sas_url   = "spark.hadoop.fs.azure.sas." + abs_3_csv_nm_container + "." + abs_1_csv_nm_account + ".blob.core.windows.net"
    is_header    = "true" if (abs_7_csv_is_1st_header == "1") else "false"
    
    # Define the path to the CSV file in the blob container
    tx_blob_container_path =  "wasbs://" + abs_3_csv_nm_container+  "@" + abs_1_csv_nm_account + ".blob.core.windows.net/"
    tx_blob_container_path =+ abs_4_csv_ds_folderpath + "/" + abs_5_csv_ds_filename

    # Initialize Spark session
    spark = ss.getSparkSession("Load CSV from Blob")

    # Load the CSV file into a DataFrame using the SAS token
    df = spark.read.format("csv").load(tx_blob_container_path) \
         .option(tx_sas_url,  tx_sas_token) \
         .option("header",    is_header) \
         .option("encoding",  abs_6_csv_nm_decode) \
         .option("delimiter", abs_8_csv_cd_delimiter_value) \
         .option("quote",     abs_9_csv_cd_delimter_text)

    # Show input Parameter(s)
    if (is_debugging == "1"):
        print("abs_1_csv_nm_account         : '" + abs_1_csv_nm_account + "'")
        print("abs_2_csv_nm_secret          : '" + abs_2_csv_nm_secret + "'")
        print("abs_3_csv_nm_container       : '" + abs_3_csv_nm_container + "'")
        print("abs_4_csv_tx_folder          : '" + abs_4_csv_ds_folderpath + "'")
        print("abs_5_csv_nm_file            : '" + abs_5_csv_ds_filename + "'")
        print("abs_6_csv_nm_decode          : '" + abs_6_csv_nm_decode + "'")
        print("abs_7_csv_is_1st_header      : '" + abs_7_csv_is_1st_header + "'")
        print("abs_8_csv_cd_delimiter_value : '" + abs_8_csv_cd_delimiter_value + "'")
        print("abs_9_csv_cd_delimter_text   : '" + abs_9_csv_cd_delimter_text + "'")
        print("DataFrame:")
        df.show(10)

    # All done
    return df

def abs_sas_url_xls(
        
    # Input Parameters
    abs_1_xls_nm_account,             # Account           | Name of Azure Storage Account (abs).
    abs_2_xls_nm_secret,              # Secret            | Name of the Secret in the Azure Key Vault.
    abs_3_xls_nm_container,           # Container         | Name of Container where the "Excel" file can be found.
    abs_4_xls_ds_folderpath,          # Folderpath        | Folderpath where the "Excel" file can be found.
    abs_5_xls_ds_filename,            # Filename          | Filename of the "Excel"-file.
    abs_6_xls_nm_sheet,               # Sheetname         | Sheetname within the "Excel" where the dataset is to be found.
    abs_7_xls_is_first_header,        # Has Header        | Is first record Header.
    abs_8_xls_cd_top_left_cell,       # Top Left Cell     | If provided the cells marked between the "Top Left Cell"  and "Bottom Right Cell"  are set as range.
    abs_9_xls_cd_bottom_right_cell,   # Bottom Right Cell | If provided the cells marked between the "Top Left Cell"  and "Bottom Right Cell"  are set as range.

    # Debugging
    is_debugging
):

    # Helper SAS Token URL
    tx_sas_token    = sc.get_secret(abs_2_xls_nm_secret, is_debugging)
    tx_sas_url      = "spark.hadoop.fs.azure.sas." + abs_3_xls_nm_container + "." + abs_1_xls_nm_account + ".blob.core.windows.net"
    is_header       = "true" if (abs_7_xls_is_first_header == "1") else "false"
    
    # Define the path to the CSV file in the blob container
    tx_blob_container_path =  "wasbs://" + abs_3_xls_nm_container+  "@" + abs_1_xls_nm_account + ".blob.core.windows.net/"
    tx_blob_container_path =+ abs_4_xls_ds_folderpath + "/" + abs_5_xls_ds_filename
    
    # Initialize Spark session
    spark = ss.getSparkSession("BlobExcelToSparkDataFrame")

    # Load the Excel file into a DataFrame using the SAS token
    df = spark.read.format("com.crealytics.spark.excel").load(tx_blob_container_path) \
            .option("treatEmptyValuesAsNulls", "true") \
            .option("inferSchema", "true") \
            .option(tx_sas_url,    tx_sas_token) \
            .option("sheetName",   abs_6_xls_nm_sheet) \
            .option("useHeader",   is_header) \
            .option("dataAddress", abs_8_xls_cd_top_left_cell \
                           + ":" + abs_9_xls_cd_bottom_right_cell)            

    # Show input Parameter(s)
    if (is_debugging == "1"):
        print("abs_1_xls_nm_account           : '" + abs_1_xls_nm_account           + "'")
        print("abs_2_xls_nm_secret            : '" + abs_2_xls_nm_secret            + "'")
        print("abs_3_xls_nm_container         : '" + abs_3_xls_nm_container         + "'")
        print("abs_4_xls_ds_folderpath        : '" + abs_4_xls_ds_folderpath        + "'")
        print("abs_5_xls_ds_filename          : '" + abs_5_xls_ds_filename          + "'")
        print("abs_6_xls_nm_sheet             : '" + abs_6_xls_nm_sheet             + "'")
        print("abs_7_xls_is_first_row_header  : '" + abs_7_xls_is_first_header      + "'")
        print("abs_8_xls_cd_top_left_cell     : '" + abs_8_xls_cd_top_left_cell     + "'")
        print("abs_9_xls_cd_bottom_right_cell : '" + abs_9_xls_cd_bottom_right_cell + "'")
        print("DataFrame:")
        df.show(10)
        
    # Return Converted the pandas DataFrame to a Spark DataFrame
    return df

def sql_user_password(

    # Input Parameters:
    sql_1_nm_server,
    sql_2_nm_username,
    sql_3_nm_secret,
    sql_4_nm_database,
    sql_5_tx_query,

    # Debugging
    is_debugging
):
    
    # Helper SAS Token URL
    sql_6_cd_password = sc.get_secret(sql_3_nm_secret, is_debugging)

    # Database credentials
    credentials_db = {
        "server"   : sql_1_nm_server,
        "database" : sql_3_nm_secret,
        "username" : sql_2_nm_username,
        "password" : sql_6_cd_password
    }

    # Run SQL query
    df = rn.query(credentials_db, sql_5_tx_query)

    # Show input Parameter(s)
    if (is_debugging == "1"):
        print("sql_1_nm_server   : '" + sql_1_nm_server   + "'")
        print("sql_2_nm_username : '" + sql_2_nm_username + "'")
        print("sql_3_nm_secret   : '" + sql_3_nm_secret   + "'")
        print("sql_4_nm_database : '" + sql_4_nm_database + "'")
        print("sql_5_tx_query    : '" + sql_5_tx_query    + "'")
        print("DataFrame:")
        df.head(10)
        
    # Show the result
    return df

def web_table_anonymous_web(
    
        # Input Parameters":
        wtb_1_any_ds_url,
        wtb_2_any_ds_path,
        wtb_3_any_ni_index,
        
        # Debugging
        is_debugging
    ):

    # Initialize the WebDriver (e.g., Chrome)
    driver = webdriver.Chrome()

    # Open the webpage
    driver.get(wtb_1_any_ds_url + wtb_2_any_ds_path)

    # Wait for the page to load (you might need to adjust the sleep time)
    time.sleep(2)

    try: # Find and click the "Accept Cookies" button (adjust the selector as needed)
        accept_button = driver.find_element(by.XPATH, '//button[text()="Alles accepteren"]')
        accept_button.click()

        # Wait for the page to load after accepting cookies
        time.sleep(2)

    except Exception as e:
        # Code to handle any other exceptions
        print(f"An unexpected error occurred: {e}")        

    # Get the page source after accepting cookies
    page_source = driver.page_source

    # Close the browser
    driver.quit()
    
    # Parse the page source with BeautifulSoup
    soup = BeautifulSoup(page_source, 'html.parser')
    
    # Create a StringIO object
    table = StringIO()

    # Find the table in the webpage (you might need to adjust the selector based on the webpage structure)
    table.write(str(soup.find('table')))

    # Read the table into a pandas DataFrame
    pandas_df = pd.read_html(table.getvalue())[int(wtb_3_any_ni_index)]

    # If is Debugging then show imput parameters
    if (is_debugging == 1):
        print("wtb_1_any_ds_url   : '" + wtb_1_any_ds_url + "'")
        print("wtb_2_any_ds_path  : '" + wtb_2_any_ds_path + "'")
        print("wtb_3_any_ni_index : '" + wtb_3_any_ni_index + "'")
        print("DataFrame:")
        pandas_df.head(10)

    # Return the webtable as a DataFrame
    return pandas_df
