# Import Custom Modules
from modules import credentials as sa
from modules import session     as ss
from modules import secret      as sc 

def load_tsl(
    
    # Input Parameters
    source_df,          # SparkDataFrame containing the data to be loaded
    nm_target_schema,   # Target schema name
    nm_target_table,    # Target table name
    
    # Debugging
    is_debugging = "0"
    
):
    
    # Database credentials
    ds_url  = f"jdbc:sqlserver://{sa.target_db.server};"
    ds_url += f"databaseName={sa.target_db.database};"
    ds_url += f"user={sa.target_db.username};"
    ds_url += f"password={sa.target_db.password}"    

    # Truncate Target Table
    spark = ss.getSparkSession("TruncateTableFunction")
    spark.read.format("jdbc").option("url", ds_url) \
        .option("schema",  nm_target_schema) \
        .option("dbtable", nm_target_table) \
        .load().createOrReplaceTempView(f"{nm_target_schema}_{nm_target_table}")
    spark.sql(f"TRUNCATE TABLE {nm_target_schema}.{nm_target_table}")        

    # Load Source DataFrame to SQL Schema / Table
    result = source_df.write.format("jdbc").option("url", ds_url) \
        .option("schema",  nm_target_schema) \
        .option("dbtable", nm_target_table) \
        .mode("append").save()

    # Show Input Parameter(s)
    if (is_debugging == "1"):
        print(f"nm_target_schema : '{nm_target_schema}'")
        print(f"nm_target_table  : '{nm_target_table}'")
        print(f"ni_ingested      : # {str(result)}")
        
    # return the result
    return result
        