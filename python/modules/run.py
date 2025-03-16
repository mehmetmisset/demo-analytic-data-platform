from modules import credentials as sa
import pandas as pd
import pyodbc

def get_parameters(id_dataset):

    # Define the query
    tx_query  = f"SELECT ds.nm_target_schema   AS nm_target_schema,\n"
    tx_query += f"       ds.nm_target_table    AS nm_target_table,\n"
    tx_query += f"       pg.cd_parameter_group AS cd_parameter_group,\n"
    tx_query += f"       pv.ni_parameter_value AS ni_parameter_value,\n"
    tx_query += f"       pm.nm_parameter       AS nm_parameter_value,\n"
    tx_query += f"       pv.tx_parameter_value AS tx_parameter_value\n"
    tx_query += f"FROM dta.parameter_value AS pv\n"
    tx_query += f"JOIN dta.dataset         AS ds ON ds.id_dataset         = pv.id_dataset         AND ds.meta_is_active = 1\n"
    tx_query += f"JOIN srd.parameter       AS pm ON pm.id_parameter       = pv.id_parameter       AND pm.meta_is_active = 1\n"
    tx_query += f"JOIN srd.parameter_group AS pg ON pg.id_parameter_group = pm.id_parameter_group AND pg.meta_is_active = 1\n"
    tx_query += f"WHERE pv.id_dataset = '{id_dataset}' AND pv.meta_is_active = 1\n"

    # Load data into a pandas DataFrame
    return query(id_dataset, tx_query)

def query(id_dataset, tx_query):

    # Define the connection string
    conn_str = (
        f"DRIVER={{ODBC Driver 17 for SQL Server}};"
        f"TrustServerCertificate=no;"
        f"Encrypt=no;"
        f"SERVER={sa.target_db['server']};"
        f"DATABASE={sa.target_db['database']};"
        f"UID={sa.target_db['username']};"
        f"PWD={sa.target_db['password']}"
    )

    # Establish the connection
    conn = pyodbc.connect(conn_str)

    # Load data into a pandas DataFrame
    df = pd.read_sql(tx_query, conn)

    # Close the connection
    conn.close()

    return df

