from modules import credentials as sa
from modules import session     as ss

def get_secret(nm_secret, is_debugging):

    # Database credentials
    ds_jdbc_url = ss.jdbc_url(sa.secret_db)
    nm_username = sa.secret_db['username']
    cd_password = sa.secret_db['password']

    # Build SQL Statement
    tx_query = f"SELECT ds_secret FROM dbo.secrets WHERE nm_secret = '{nm_secret}'"

    # Initialize Spark session
    spark = ss.getSparkSession("GetSecretFunction")
    
    # Run SQL query
    df = spark.read.format("jdbc").option("url", ds_jdbc_url).option("driver", "com.microsoft.sqlserver.jdbc.SQLServerDriver")\
        .option("user", nm_username).option("password", cd_password)\
        .option("query", tx_query).load()

    # Show input Parameter(s)
    if (is_debugging == "1"):
        print("nm_secret : '" + nm_secret + "'")
        
    # Show the result
    return None if df.count() == 0 else df.collect()[0].ds_secret
