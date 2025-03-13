# Import Credentials
from modules import credentials as cr

# Import for Spark for session
from pyspark.sql import SparkSession

def getSparkSession(nm_application):
    
    # Initialize Spark session
    spark = SparkSession.builder\
           .appName(nm_application)\
           .config("spark.pyspark.python",        cr.ds_path_to_python) \
           .config("spark.pyspark.driver.python", cr.ds_path_to_python) \
           .config("spark.driver.extraClassPath", cr.ds_path_to_jdbc) \
           .getOrCreate()
           #.config("spark.sql.execution.arrow.pyspark.enabled", "true") \
           
    # Return the Spark session
    return spark

# Test getSparkSession function
#spark = getSparkSession('Test')
