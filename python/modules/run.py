from modules import credentials as sa

from sqlalchemy import create_engine, text
from urllib.parse import quote

import pandas as pd
import pyodbc

def get_parameters(id_dataset):

    # Define the query
    tx_query  = f"SELECT CONCAT(ds.nm_target_schema, '.usp_', ds.nm_target_table) AS nm_procedure,\n"
    tx_query += f"       CONCAT('tsl_, ds.nm_target_schema)                       AS nm_tsl_schema,\n"
    tx_query += f"       CONCAT('tsl_, ds.nm_target_table)                        AS nm_tsl_table,\n"
    tx_query += f"       ds.is_ingestion                                          AS is_ingestion.\n"
    tx_query += f"       pg.cd_parameter_group                                    AS cd_parameter_group,\n"
    tx_query += f"       pv.ni_parameter_value                                    AS ni_parameter_value,\n"
    tx_query += f"       pm.nm_parameter                                          AS nm_parameter_value,\n"
    tx_query += f"       pv.tx_parameter_value                                    AS tx_parameter_value\n"
    tx_query += f"FROM dta.parameter_value AS pv\n"
    tx_query += f"JOIN dta.dataset         AS ds ON ds.id_dataset         = pv.id_dataset         AND ds.meta_is_active = 1\n"
    tx_query += f"JOIN srd.parameter       AS pm ON pm.id_parameter       = pv.id_parameter       AND pm.meta_is_active = 1\n"
    tx_query += f"JOIN srd.parameter_group AS pg ON pg.id_parameter_group = pm.id_parameter_group AND pg.meta_is_active = 1\n"
    tx_query += f"WHERE pv.id_dataset = '{id_dataset}' AND pv.meta_is_active = 1\n"

    # Load data into a pandas DataFrame
    return query(sa.target_db, tx_query)
def get_param_value(nm_parameter_value, params):
    return params.loc[params['nm_parameter_value'] == nm_parameter_value].values[0][5]

def start(id_dataset):
    params = [("ip_id_dataset_or_dq_control", id_dataset), ("ip_ds_external_reference_id", 'n/a')]
    return execute('rdp.run_start', params)

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

def query(credentials_db, tx_query):

    # Define the connection string
    conn_str = connection_string(credentials_db)

    # Establish the connection
    conn = pyodbc.connect(conn_str)

    # Load data into a pandas DataFrame
    df = pd.read_sql(tx_query, conn)

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

# Function to execute a stored procedure
def execute(nm_procedure, *params):

    with engine(sa.target_db).connect() as connection:
    
        # Construct the stored procedure execution command
        procedure_call = f"EXEC {nm_procedure} {', '.join([':p' + str(i) for i in range(len(params))])}"
        
        # Create a dictionary of parameters
        param_dict = {f"p{i}": param for i, param in enumerate(params)}
        
        # Execute the stored procedure
        result = connection.execute(text(procedure_call), **param_dict)

        # Fetch results if the stored procedure returns data
        return result.fetchall()

