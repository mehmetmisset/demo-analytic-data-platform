# Import Custom Modules
from modules import credentials as sa
from modules import session     as ss 




def load_tsl(
    
    # Input Parameters
    df_source_dataset,  # SparkDataFrame containing the data to be loaded
    nm_target_schema,   # Target schema name
    nm_target_table,    # Target table name
    
    # Debugging
    is_debugging = "0"
    
):

    # Truncate Target Table
    ss.truncate_table(sa.target_db, nm_target_schema, nm_target_table)

    # Database credentials
    ds_jdbc_url = ss.jdbc_url(sa.secret_db)
    nm_username = sa.target_db['username']
    cd_password = sa.target_db['password']
    
    # Load Source DataFrame to SQL Schema / Table
    result = df_source_dataset.write.format("jdbc").option("url", ds_jdbc_url).option("driver", "com.microsoft.sqlserver.jdbc.SQLServerDriver")\
        .option("user",     nm_username)\
        .option("password", cd_password)\
        .option("schema",   nm_target_schema) \
        .option("dbtable",  nm_target_table) \
        .mode("append").save()

    # Show Input Parameter(s)
    if (is_debugging == "1"):
        print(f"nm_target_schema : '{nm_target_schema}'")
        print(f"nm_target_table  : '{nm_target_table}'")
        print(f"ni_ingested      : # {str(result)}")
        
    # return the result
    return result
        