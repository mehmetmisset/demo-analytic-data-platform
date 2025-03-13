# Import Custom Modules
from modules import credentials as sa
from modules import session     as ss 

import pandas as pd
from sqlalchemy import create_engine

def load_tsl(
    
    # Input Parameters
    df_source_dataset,  # DataFrame
    nm_target_schema,   # Target schema name
    nm_target_table,    # Target table name
    
    # Debugging
    is_debugging = "0"
    
):

    # Truncate Target Table
    ss.truncate_table(sa.target_db, nm_target_schema, nm_target_table)

    # Database credentials
    nm_server   = sa.target_db['server']
    nm_database = sa.target_db['database']
    nm_username = sa.target_db['username']
    cd_password = sa.target_db['password'].replace("@", "%40")
    
    # Load Source DataFrame to SQL Schema / Table
    engine = create_engine(f'mssql+pyodbc://{nm_username}:{cd_password}@{nm_server}/{nm_database}?driver=ODBC+Driver+17+for+SQL+Server&Encrypt=no&TrustServerCertificate=no&Connection Timeout=30')
    result = df_source_dataset.to_sql(nm_target_table, con=engine, schema=nm_target_schema, if_exists='replace', index=False)

    # Show Input Parameter(s)
    if (is_debugging == "1"):
        print(f"nm_target_schema : '{nm_target_schema}'")
        print(f"nm_target_table  : '{nm_target_table}'")
        print(f"ni_ingested      : # {str(result)}")
        
    # return the result
    return result
        