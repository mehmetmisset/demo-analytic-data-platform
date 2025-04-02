CREATE PROCEDURE mdm.create_schema
  
  /* Input Parameters */
  @ip_nm_target_schema NVARCHAR(128),

  /* Input Paramters for "Debugging". */
  @ip_is_debugging     BIT = 0,
  @ip_is_testing       BIT = 0


AS DECLARE
  @shm NVARCHAR(128) = '',
  @sql NVARCHAR(MAX) = '';

BEGIN  

  /* Create tsa-schemas */
  DROP TABLE IF EXISTS #schemas; SELECT 
    tmp.nm_schema, 'CREATE SCHEMA ' + tmp.nm_schema AS tx_sql
  INTO #schemas
  FROM (SELECT 'tsl_' + @ip_nm_target_schema AS nm_schema UNION ALL
        SELECT 'tsa_' + @ip_nm_target_schema AS nm_schema UNION ALL
        SELECT          @ip_nm_target_schema AS nm_schema
  ) AS tmp
  LEFT JOIN INFORMATION_SCHEMA.SCHEMATA AS shm 
  ON shm.SCHEMA_NAME = tmp.nm_schema
  WHERE shm.SCHEMA_NAME IS NULL;

  WHILE ((SELECT COUNT(*) FROM #schemas) > 0) BEGIN
    SELECT @shm = nm_schema, @sql = tx_sql FROM (SELECT TOP 1 * FROM #schemas) AS rec;
    DELETE FROM #schemas WHERE nm_schema = @shm;
    EXEC sp_executesql @sql;
  END /* WHILE */

END
RETURN 0
