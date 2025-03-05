# Import required libraries
import pandas       as pd
import urllib.parse

# from ... Import
from sqlalchemy import create_engine, text



def copy_df_to_sql(# Source DataFrame:
                  ip_df,
             
                  # Target Parameters: 
                  sql_1_nm_server,
                  sql_2_nm_username,
                  sql_3_nm_database,
                  sql_4_nm_schema,
                  sql_5_nm_table,
                  sql_6_nm_secret,
             
                  # Debugging
                  is_debugging):
    
    # If is Debugging then show imput parameters
    if (is_debugging == 1):
        print("sql_1_nm_server   : '" + sql_1_nm_server   + "'")
        print("sql_2_nm_username : '" + sql_2_nm_username + "'")
        print("sql_3_nm_database : '" + sql_3_nm_database + "'")
        print("sql_4_nm_schema   : '" + sql_4_nm_schema   + "'")
        print("sql_5_nm_table    : '" + sql_5_nm_table    + "'")
        print("sql_6_nm_secret   : '" + "********"        + "'")
        
    # Create the connection string
    connection_string = f'mssql+pyodbc://{sql_2_nm_username}:{urllib.parse.quote_plus(sql_6_nm_secret)}@{sql_1_nm_server}/{sql_3_nm_database}?driver=ODBC+Driver+17+for+SQL+Server'
    
    # Create the SQLAlchemy engine
    engine = create_engine(connection_string)
    
    # Set Target schema + table
    nm_target = sql_4_nm_schema + "." + sql_5_nm_table
    
    
    # Truncate the table before loading new data
    sql = text("TRUNCATE TABLE " + nm_target) 
    connection = engine.connect()
    connection.execute(sql)
    connection.close()
    
    if (is_debugging == 1):
        print("Table `" + nm_target + "` trancated successfully")
        
    result = ip_df.to_sql(sql_5_nm_table, schema=sql_4_nm_schema, con=engine, if_exists='append', index=False, )
    if (is_debugging == 1):
        print("ingestion into `" + nm_target + "` successfull")
        print("# ingested : " + str(result))
        