from modules import credentials as sa

from sqlalchemy import create_engine, text
from urllib.parse import quote

import pandas as pd
import pyodbc

def get_parameters(id_dataset):

    # Define the query
    tx_query  = f"SELECT pg.cd_parameter_group AS cd_parameter_group,\n"
    tx_query += f"       pv.ni_parameter_value AS ni_parameter_value,\n"
    tx_query += f"       pm.nm_parameter       AS nm_parameter_value,\n"
    tx_query += f"       pv.tx_parameter_value AS tx_parameter_value\n"
    tx_query += f"FROM dta.parameter_value AS pv\n"
    tx_query += f"JOIN dta.dataset         AS ds ON ds.id_dataset         = pv.id_dataset         AND ds.meta_is_active = 1\n"
    tx_query += f"JOIN srd.parameter       AS pm ON pm.id_parameter       = pv.id_parameter       AND pm.meta_is_active = 1\n"
    tx_query += f"JOIN srd.parameter_group AS pg ON pg.id_parameter_group = pm.id_parameter_group AND pg.meta_is_active = 1\n"
    tx_query += f"WHERE pv.id_dataset = '{id_dataset}' AND pv.meta_is_active = 1\n"

# SELECT pg.cd_parameter_group AS cd_parameter_group,
#        pv.ni_parameter_value AS ni_parameter_value,
#        pm.nm_parameter       AS nm_parameter_value,
# 
# 
#        REPLACE(REPLACE(REPLACE(REPLACE(pv.tx_parameter_value, 
# 		'<@dt_previous_stand>', FORMAT(rn.dt_previous_stand, 'yyyy-MM-dd hh:mm:ss')),
# 		'<@dt_current_stand>',  FORMAT(rn.dt_current_stand,  'yyyy-MM-dd hh:mm:ss')),
# 		'<@ni_previous_epoch>', CONVERT(NVARCHAR(10), rn.ni_previous_epoch)),
# 		'<@ni_current_epoch>', CONVERT(NVARCHAR(10), rn.ni_current_epoch)) AS tx_parameter_value
# 
# FROM dta.parameter_value AS pv
# 
# JOIN dta.dataset         AS ds ON ds.id_dataset         = pv.id_dataset         AND ds.meta_is_active = 1
# JOIN srd.parameter       AS pm ON pm.id_parameter       = pv.id_parameter       AND pm.meta_is_active = 1
# JOIN srd.parameter_group AS pg ON pg.id_parameter_group = pm.id_parameter_group AND pg.meta_is_active = 1
# 
# LEFT JOIN rdp.run AS rn on rn.id_dataset = ds.id_dataset AND rn.dt_run_started = (
# 	SELECT MAX(dt_run_started)
# 	FROM rdp.run 
# 	WHERE id_dataset = '07090900040c09010908080200140a03' 
# )
# 
# WHERE pv.id_dataset = '07090900040c09010908080200140a03' 
# AND pv.meta_is_active = 1


    # Load data into a pandas DataFrame
    return query(sa.target_db, tx_query)

def get_param_value(nm_parameter_value, params):
    return params.loc[params['nm_parameter_value'] == nm_parameter_value].values[0][3]

def start(id_dataset):
    params  = []
    params += [["ip_id_dataset_or_dq_control", id_dataset]]
    params += [["ip_ds_external_reference_id", 'n/a']]
   
    return execute_procedure(sa.target_db, 'rdp.run_start', params)

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
def execute_procedure(credentials, nm_procedure, params = []):

    # Build SQL Statement
    tx_sql_statement = f"EXEC {nm_procedure} "
    ni_index = 0
    mx_index = len(params)
    while (ni_index < mx_index):
        tx_sql_statement += ("" if (tx_sql_statement == f"EXEC {nm_procedure} ") else ",") + "\n"
        tx_sql_statement += f"  @{params[ni_index][0]} = '{params[ni_index][0]}'"
        ni_index += 1

    # Execute SQL Statement
    result = execute_sql(credentials, tx_sql_statement)
    
    # Done
    return result
