from modules import credentials as sa

from sqlalchemy import create_engine, text
from urllib.parse import quote

import pandas as pd
import pyodbc

def get_parameters(id_dataset):

    # Define the query
    tx_sql_statement  = f"SELECT * FROM rdp.tvf_get_parameters('{id_dataset}')\n"

    # Load data into a pandas DataFrame
    return query(sa.target_db, tx_sql_statement)

def get_param_value(nm_parameter_value, params):
    return params.loc[params['nm_parameter_value'] == nm_parameter_value].values[0][3]

def start(id_dataset, is_debugging):
    
    # Set Parameter for rdp.run_start
    params  = []
    params += [["ip_id_dataset_or_dq_control", id_dataset]]
    params += [["ip_ds_external_reference_id", 'n/a']]
   
    # Execute "rdp.run_start"
    return execute_procedure(sa.target_db, 'rdp.run_start', params, is_debugging)

def truncate_table(credentials_db, nm_schema, nm_table):
    
    # Build SQL Statement
    tx_sql_statement = f"TRUNCATE TABLE {nm_schema}.{nm_table}"
    
    # Execute SQL Statement
    result = execute_sql(credentials_db, tx_sql_statement)

    # Done
    return result        

def connection_string(credentials_db):
    
    # Define the connection string
    return (
        f"DRIVER={{ODBC Driver 17 for SQL Server}};"
        f"TrustServerCertificate=no;"
        f"Encrypt=no;"
        f"SERVER={credentials_db['server']};"
        f"DATABASE={credentials_db['database']};"
        f"UID={credentials_db['username']};"
        f"PWD={credentials_db['password']}"
    )

def query(credentials_db, tx_sql_statement):

    # Define the connection string
    conn_str = connection_string(credentials_db)

    # Establish the connection
    conn = pyodbc.connect(conn_str)

    # Load data into a pandas DataFrame
    df = pd.read_sql(tx_sql_statement, conn)

    # Close the connection
    conn.close()

    return df

def engine(credentials_db):

    driver   = r"ODBC+Driver+17+for+SQL+Server"
    server   = credentials_db['server']
    database = credentials_db['database']
    username = credentials_db['username']
    password = quote(credentials_db['password'])
    encrypt  = "no"
    trustedservercertificate = "no"
    
    conn_str = f"mssql+pyodbc://{username}:{password}@{server}/{database}?driver={driver}&encrypt={encrypt}&trustedservercertificate={trustedservercertificate}"

    return create_engine(conn_str)

# This function "executes" SQL against the "Database"
def execute_sql(credentials_db, tx_sql_statement, is_debugging = "0"):
        
    with engine(credentials_db).connect() as connection:
           
        # Execute the stored procedure
        result = connection.execute(text(tx_sql_statement))
        
        if (is_debugging == "1") : # Show excuted "procedure"
            print(f"SQL Executed : {tx_sql_statement}")

        # Fetch results if the stored procedure returns data
        return result


# Function to execute a stored procedure
def execute_procedure(credentials, nm_procedure, params = [], is_debugging = "0"):

    # Build SQL Statement
    ni_index = 0
    mx_index = len(params)
    tx_sql_statement = f"BEGIN\n  EXEC {nm_procedure} "
    while (ni_index < mx_index):
        tx_sql_statement += ("" if (ni_index == 0) else ",") + "\n"
        #tx_sql_statement += f"  @{params[ni_index][0]} = '{params[ni_index][1]}'"
        tx_sql_statement += f"  '{params[ni_index][1]}'"
        ni_index += 1
    tx_sql_statement += ";\nEND\n"
    
    if (is_debugging=="1"):
        print(f"tx_sql_statement : '{tx_sql_statement}'")

    # Execute SQL Statement
    result = execute_sql(credentials, tx_sql_statement)
    
    # Done
    return result
