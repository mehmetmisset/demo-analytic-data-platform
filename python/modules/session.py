# Import for Spark for session
from pyspark.sql import SparkSession

def getSparkSession(nm_application):

    # Initialize Spark session
    spark = SparkSession.builder.appName(nm_application).getOrCreate()

    # Return the Spark session
    return spark