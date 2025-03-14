CREATE PROCEDURE mdm.create_user_specified_procedure

  /* Input Parameters */
  @ip_nm_target_schema NVARCHAR(128),
  @ip_nm_target_table  NVARCHAR(128),

  /* Input Paramters for "Debugging". */
  @ip_is_debugging     BIT = 0,
  @ip_is_testing       BIT = 0

AS DECLARE /* Local Variables */
  
  @id_dataset           CHAR(32) = (SELECT id_dataset FROM dta.dataset WHERE meta_is_active = 1 AND nm_target_schema = @ip_nm_target_schema AND nm_target_table = @ip_nm_target_table),
  @ni_ordering          INT,
  @nm_target_column     NVARCHAR(128),
  @is_businesskey       BIT,
  @is_ingestion         BIT,
  @nm_ingestion         NVARCHAR(128),
  @tx_query_update      NVARCHAR(MAX) = '',
  @tx_query_insert      NVARCHAR(MAX) = '',
  @tx_query_calculation NVARCHAR(MAX) = '',
  @tx_query_procedure   NVARCHAR(MAX) = '',
  @tx_pk_fields         NVARCHAR(MAX) = '',
  @tx_attributes        NVARCHAR(MAX) = '',
  @tx_message           NVARCHAR(MAX) = '',
  @tx_procedure         NVARCHAR(MAX) = '',
  @tx_sql               NVARCHAR(MAX) = '',

  @nwl NVARCHAR(1)   = CHAR(10),
	@emp NVARCHAR(1)   = '',
  @sql NVARCHAR(MAX) = '',
	
  @src NVARCHAR(MAX),
  @tgt NVARCHAR(MAX),
	@col NVARCHAR(MAX) = '',
	
	@sqt NVARCHAR(1)   = '''',
	@ddl NVARCHAR(MAX) = '',
  @ptp NVARCHAR(MAX) = '',
  @tb1 NVARCHAR(32)  = CHAR(10) + '  ',
  @tb2 NVARCHAR(32)  = CHAR(10) + '    ',
  @tb3 NVARCHAR(32)  = CHAR(10) + '      '

BEGIN

	IF (1=1 /* Extract schema and Table. */) BEGIN
	  
    SELECT @src = '[tsa_' + dst.nm_target_schema + '].[get_' + dst.nm_target_table + ']',
				   @tgt = '[' +     dst.nm_target_schema + '].['     + dst.nm_target_table + ']',
				   @ptp = CASE WHEN dst.is_ingestion = 1 THEN etl.nm_processing_type ELSE 'Incremental' END,
           @is_ingestion = dst.is_ingestion,
           @nm_ingestion = CASE WHEN dst.is_ingestion = 1 THEN 'Ingestion' ELSE 'Transformation' END
	  FROM dta.dataset AS dst LEFT JOIN dta.ingestion_etl AS etl ON etl.meta_is_active = 1 AND etl.id_dataset = dst.id_dataset
	  WHERE dst.meta_is_active = 1 
    AND   dst.id_dataset     = @id_dataset;

  END

  IF (1=1 /* Extract Column information */) BEGIN
  
    /* Extract "temp"-table with Columns of "Target"-table, exclude the "meta-attributes. */
    DROP TABLE IF EXISTS ##columns; 
    SELECT ni_ordering, 
           is_businesskey, 
           nm_target_column
    INTO ##columns 
    FROM dta.attribute
    WHERE meta_is_active = 1 
    AND   id_dataset = @id_dataset 
    ORDER BY ni_ordering ASC;

    /* String all the "Colums" in the "temp"-table together with "s."-alias, after drop the "temp"-table. */
    WHILE ((SELECT COUNT(*) FROM ##columns) > 0) BEGIN 
      SELECT @ni_ordering      = ni_ordering,
             @is_businesskey   = is_businesskey,
             @nm_target_column = nm_target_column
      FROM (SELECT TOP 1 * FROM ##columns ORDER BY ni_ordering ASC) AS rec; 
      DELETE FROM ##columns WHERE ni_ordering = @ni_ordering; 
      SET @tx_attributes += 's.[' + @nm_target_column + '], '; 
      SET @tx_pk_fields  += IIF(@is_businesskey = 1, ', s.[' + @nm_target_column + '], "|"', ''); 
    END /* WHILE */ DROP TABLE IF EXISTS ##columns; 

  END

  IF (1=1 /* Add "SQL" for "Update"-query for "Target processing type is "Fullload". */) BEGIN
    SET @sql  = @emp + 'UPDATE t SET';
    SET @sql += @nwl + '  t.meta_is_active = 0, t.meta_dt_valid_till = ISNULL(s.meta_dt_valid_from, @dt_curr_calculation)';
    SET @sql += @nwl + 'FROM ' + @tgt + ' AS t LEFT JOIN ' + @src + ' AS s ON t.meta_ch_bk = s.meta_ch_bk';
    SET @sql += @nwl + 'WHERE t.meta_is_active = 1 AND t.meta_ch_rh = ISNULL(s.meta_ch_rh,"n/a")';
    SET @sql += @nwl + IIF(@ptp='Incremental', 'AND t.meta_ch_bk IN (SELECT meta_ch_bk FROM ' + @src + ')',''); 
    SET @tx_query_update = REPLACE(@sql, '"', '''');
  END
  
  IF (1=1 /* Add "SQL" for "Insert"-query for "Target processing type is "Fullload". */) BEGIN
    SET @sql  = @emp + 'INSERT INTO ' + @tgt + ' (' + REPLACE(@col, 's.', '') + ' meta_dt_valid_from, meta_dt_valid_till, meta_is_active, meta_ch_rh, meta_ch_bk, meta_ch_pk)';
    SET @sql += @nwl + 'SELECT ' + @col + ' s.meta_dt_valid_from, s.meta_dt_valid_till, s.meta_is_active, s.meta_ch_rh, s.meta_ch_bk, s.meta_ch_pk';
    SET @sql += @nwl + 'FROM ' + @src + ' AS s LEFT JOIN ' + @tgt + ' AS t ON t.meta_is_active = 1 AND t.meta_ch_rh = s.meta_ch_rh';
    SET @sql += @nwl + 'WHERE t.meta_ch_pk IS NULL'
    SET @tx_query_insert = REPLACE(@sql, '"', '''');
  END

  IF (1 = 1 /* All "Ingestion"-datasets are historized. */) BEGIN
            
    /* Build SQL Statement */
    SET @sql  = @emp + '/* The `Target`-dataset(s) ARE historized. */'
    SET @sql += @nwl + 'SELECT @dt_last_calculation = CONVERT(DATETIME2(7), MAX(run.dt_previous_stand))'
    SET @sql += @nwl + '     , @dt_curr_calculation = CONVERT(DATETIME2(7), MAX(run.dt_current_stand))'
    SET @sql += @nwl + 'FROM rdp.run AS run'
    SET @sql += @nwl + 'WHERE run.id_dataset = "' + @id_dataset + '"'
    SET @sql += @nwl + 'AND   run.dt_run_started = ('
    SET @sql += @nwl + '  /* Find the `Previous` run that NOT ended in `Failed`-status. */'
    SET @sql += @nwl + '  SELECT MAX(dt_run_started)'
    SET @sql += @nwl + '  FROM rdp.run'
    SET @sql += @nwl + '  WHERE id_dataset           = "' + @id_dataset + '"'
    SET @sql += @nwl + '  AND   id_processing_status = gnc_commen.id_processing_status("Finished")'
    SET @sql += @nwl + ')'
    SET @sql += @nwl + ''
    SET @sql += @nwl + '/* Set curr "Calculation"-date. */'
    SET @sql += @nwl + 'SELECT @dt_curr_calculation = GETDATE();'

    /* Set SQL Statement for "Calculation"-dates */
    SET @tx_query_calculation = @sql

  END

  IF (1=1 /* Build SQL Statemen for creation of "Stored Procedure" */) BEGIN

    /* Build SQL Statement for drop of "Stored Procedure" */
    SET @tx_message = '-- Dropping procedure if exists "'+ @ip_nm_target_schema +'"."' + @ip_nm_target_table + '"';
    SET @tx_sql     = 'DROP PROCEDURE IF EXISTS [' + @ip_nm_target_schema +'].[usp_' + @ip_nm_target_table + ']'; 
    EXEC gnc_commen.show_and_execute_sql @tx_message, @tx_sql, @ip_is_debugging, @ip_is_testing;

    /* Build SQL Statement for creation of "Stored Procedure" */
    SET @tx_message = '-- Create procedure for updating "Target"-dataset';
    SET @tx_sql  = @emp + 'CREATE PROCEDURE ' + @ip_nm_target_schema +'.usp_' + @ip_nm_target_table + CASE WHEN (@is_ingestion = 1) THEN ' AS' 
      ELSE /* In case of "Transformation" */
        @nwl + '  /* Input Parameter(s) */' +
        @nwl + '  @ip_ds_external_reference_id NVARCHAR(999) = "n/a"' +
        @nwl + '  ' + 
        @nwl + 'AS' 
      END
    SET @tx_sql += @nwl + ''
    SET @tx_sql += @nwl + '/* !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! */'
    SET @tx_sql += @nwl + '/* !!!                                                                            !!! */'
    SET @tx_sql += @nwl + '/* !!! This Stored Procdures has been generated by excuting the procedure of      !!! */'
    SET @tx_sql += @nwl + '/* !!! mdm.create_user_specified_procedure, see example here below.               !!! */'
    SET @tx_sql += @nwl + '/* !!!                                                                            !!! */'
    SET @tx_sql += @nwl + '/* !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! */'
    SET @tx_sql += @nwl + '/* ' 
    SET @tx_sql += @nwl + '-- Example for `Generation of ' + @nm_ingestion + ' Procedure`:'
    SET @tx_sql += @nwl + 'EXEC mdm.create_user_specified_procedure'
    SET @tx_sql += @nwl + '  @ip_nm_target_schema = "' + @ip_nm_target_schema +'", '
    SET @tx_sql += @nwl + '  @ip_nm_target_table  = "' + @ip_nm_target_table + '", '
    SET @tx_sql += @nwl + '  @ip_is_debugging     = 0, '
    SET @tx_sql += @nwl + '  @ip_is_testing       = 0; '
    SET @tx_sql += @nwl + 'GO'
    SET @tx_sql += @nwl + ''
    SET @tx_sql += @nwl + '-- Example for `Executing the ' + @nm_ingestion + ' Procedure`:'
    SET @tx_sql += @nwl + 'EXEC ' + @ip_nm_target_schema +'.usp_' + @ip_nm_target_table +';'
    SET @tx_sql += @nwl + 'GO'
    SET @tx_sql += @nwl + ''
    SET @tx_sql += @nwl + '*/ '
    SET @tx_sql += @nwl + '/* !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! */'
    SET @tx_sql += @nwl + ''
    SET @tx_sql += @nwl + 'DECLARE /* Local Variables */'
    SET @tx_sql += @nwl + '  @id_dataset          CHAR(32)      = "' + @id_dataset + '", ' 
    SET @tx_sql += @nwl + '  @nm_target_schema    NVARCHAR(128) = "' + @ip_nm_target_schema + '", '
    SET @tx_sql += @nwl + '  @nm_target_table     NVARCHAR(128) = "' + @ip_nm_target_table + '", '
    SET @tx_sql += @nwl + '  @tx_error_message    NVARCHAR(MAX),'
    SET @tx_sql += @nwl + '  @dt_last_calculation DATETIME2(7),'
    SET @tx_sql += @nwl + '  @dt_curr_calculation DATETIME2(7),'
    SET @tx_sql += @nwl + '  @id_run              CHAR(32)       = NULL,'
    SET @tx_sql += @nwl + '  @is_transaction      BIT            = 0, -- Helper to keep track if a transaction has been started.'
    SET @tx_sql += @nwl + '  @ni_before           INT            = 0, -- # Record "Before" processing.'
    SET @tx_sql += @nwl + '  @ni_ingested         INT            = 0, -- # Record that were "Ingested".'
    SET @tx_sql += @nwl + '  @ni_inserted         INT            = 0, -- # Record that were "Inserted".'
    SET @tx_sql += @nwl + '  @ni_updated          INT            = 0, -- # Record that were "Updated".'
    SET @tx_sql += @nwl + '  @ni_after            INT            = 0; -- # Record "After" processing.'
    SET @tx_sql += @nwl + ''
    SET @tx_sql += @nwl + 'BEGIN'
    SET @tx_sql += @nwl + '  ' 
    SET @tx_sql += @nwl + '  /* Turn off Effected Row */' 
    SET @tx_sql += @nwl + '  SET NOCOUNT ON;'
    SET @tx_sql += @nwl + '  ' 
    SET @tx_sql += @nwl + '  /* Turn off Warnings */' 
    SET @tx_sql += @nwl + '  SET ANSI_WARNINGS OFF;'
    SET @tx_sql += @nwl + '  ' 
    SET @tx_sql += @nwl + '  IF (1=1 /* Extract `Last` calculation datetime. */) BEGIN'
    SET @tx_sql += @nwl + '      '
    SET @tx_sql += @nwl + '      ' + REPLACE(@tx_query_calculation, @nwl, @tb2)
    SET @tx_sql += @nwl + '      '
    SET @tx_sql += @nwl + '  END' 
    IF (@is_ingestion = 1) BEGIN SET @tx_sql += @emp + ''; END; IF (@is_ingestion = 0) BEGIN /* In case of "Transformation" */
      SET @tx_sql += @nwl + '  /* Start Run */'
      SET @tx_sql += @nwl + '  EXEC rdp.run_start @id_dataset, ip_ds_external_reference_id'
      SET @tx_sql += @nwl + '  '
      SET @tx_sql += @nwl + '  BEGIN TRY'
      SET @tx_sql += @nwl + '  '
      SET @tx_sql += @nwl + '    /* Execute `Transformation`-query and insert result into `Temporal Staging Area`-table. */'
      SET @tx_sql += @nwl + '    '
      SET @tx_sql += @nwl + '    '
      SET @tx_sql += @nwl + '    '
      SET @tx_sql += @nwl + '  END TRY'
      SET @tx_sql += @nwl + '  '
      SET @tx_sql += @nwl + '  BEGIN CATCH'
      SET @tx_sql += @nwl + '    '
      SET @tx_sql += @nwl + '    /* An `Error` occured!, register the `Error` in the Logging. */'
      SET @tx_sql += @nwl + '    EXEC rdp.run_failed @id_dataset'
      SET @tx_sql += @nwl + '    '
      SET @tx_sql += @nwl + '    /* Ended in `Error` ! */'
      SET @tx_sql += @nwl + '    PRINT("Data `Transformation` for Dataset `' + @ip_nm_target_schema + '`.`' + @ip_nm_target_table + '` has ended in `Error`.")'
      SET @tx_sql += @nwl + '    '
      SET @tx_sql += @nwl + '  END CATCH'
    END
    SET @tx_sql += @nwl + '  ' 
    SET @tx_sql += @nwl + '  BEGIN TRY'
    SET @tx_sql += @nwl + '    '
    SET @tx_sql += @nwl + '    /* Check that there is an "Run-Dataset"-process running. */'
    SET @tx_sql += @nwl + '    SET @id_run = rdp.get_id_run(@id_dataset); IF (@id_run IS NULL) BEGIN'
    SET @tx_sql += @nwl + '      ' 
    SET @tx_sql += @nwl + '      /* Raise Error to indicate that the process of `Adding` and "Ending" of records was not logged as started! */'
    SET @tx_sql += @nwl + '      SET @tx_error_message = "ERROR: NO running `process` for dataset `' + @ip_nm_target_schema + '.' + @ip_nm_target_table + '`!"'
    SET @tx_sql += @nwl + '      RAISERROR(@tx_error_message, 18, 1)'
    SET @tx_sql += @nwl + '      ' 
    SET @tx_sql += @nwl + '    END' 
    SET @tx_sql += @nwl + '    ' 
    SET @tx_sql += @nwl + '    /* Calculate # Records "before" Processing. */'
    SET @tx_sql += @nwl + '    SELECT @ni_before = COUNT(1) FROM [' + @ip_nm_target_schema + '].[' + @ip_nm_target_table + '] WHERE [meta_is_active] = 1'
    SET @tx_sql += @nwl + '    ' 
    SET @tx_sql += @nwl + '    /* Calculate # Records "Ingestion" Processing. */'
    SET @tx_sql += @nwl + '    SELECT @ni_ingested = COUNT(1) FROM [tsa_' + @ip_nm_target_schema + '].[tsa_' + @ip_nm_target_table + ']'
    SET @tx_sql += @nwl + '    '
    SET @tx_sql += @nwl + '    /* Start the `Transaction`. */' 
    SET @tx_sql += @nwl + '    BEGIN TRANSACTION; SET @is_transaction = 1;'
    SET @tx_sql += @nwl + '    '
    SET @tx_sql += @nwl + '    IF (1=1 /* `End` records that are nolonger in `Source` and still in `Target`. */) BEGIN'
    SET @tx_sql += @nwl + '      '
    SET @tx_sql += @nwl + '      ' + REPLACE(@tx_query_update, @nwl, @tb3)
    SET @tx_sql += @nwl + '      '
    SET @tx_sql += @nwl + '      /* Set # Ended records. */'
    SET @tx_sql += @nwl + '      SET @ni_updated = @@ROWCOUNT;'
    SET @tx_sql += @nwl + '      '
    SET @tx_sql += @nwl + '    END'
    SET @tx_sql += @nwl + '    '
    SET @tx_sql += @nwl + '    IF (1=1 /* `Add` records that are in the `Source` and NOT in `Target`. */) BEGIN'
    SET @tx_sql += @nwl + '      '
    SET @tx_sql += @nwl + '      ' + REPLACE(@tx_query_insert, @nwl, @tb3)
    SET @tx_sql += @nwl + '      '
    SET @tx_sql += @nwl + '      /* Set # Added records. */'
    SET @tx_sql += @nwl + '      SET @ni_inserted = @@ROWCOUNT;'
    SET @tx_sql += @nwl + '      '
    SET @tx_sql += @nwl + '    END'
    SET @tx_sql += @nwl + '    '
    SET @tx_sql += @nwl + '    /* Calculate # Records `After` Processing. */'
    SET @tx_sql += @nwl + '    SELECT @ni_after = COUNT(1) FROM [' + @ip_nm_target_schema + '].[' + @ip_nm_target_table + '] WHERE [meta_is_active] = 1'
    SET @tx_sql += @nwl + '    '
    SET @tx_sql += @nwl + '    IF (1=1 /* Validate uniqueness of meta_ch_pk, if NOT Unique then Raise ERROR and rollback !!! */) BEGIN'
    SET @tx_sql += @nwl + '      '
    SET @tx_sql += @nwl + '      /* Local Variable for Executing Check(s) */'
    SET @tx_sql += @nwl + '      DECLARE @ni_expected INT, @ni_measured INT;'
    SET @tx_sql += @nwl + '      '
    SET @tx_sql += @nwl + '      /* Execute Check if `meta_ch_pk`-attribute values are unique. */'
    SET @tx_sql += @nwl + '      SELECT @ni_expected = COUNT(1), @ni_measured = COUNT(DISTINCT meta_ch_pk) FROM ' + @ip_nm_target_schema + '.' + @ip_nm_target_table
    SET @tx_sql += @nwl + '      IF (@ni_expected != @ni_measured) BEGIN'
    SET @tx_sql += @nwl + '          SET @tx_error_message = "ERROR: meta_ch_pk NOT unique for ' + @ip_nm_target_schema + '.' + @ip_nm_target_table + '!"'
    SET @tx_sql += @nwl + '          RAISERROR(@tx_error_message, 18, 1)'
    SET @tx_sql += @nwl + '      END'
    SET @tx_sql += @nwl + '      '
    SET @tx_sql += @nwl + '      /* Accuracy only 1 `Active` record per `Primarykey`. */' 
    SET @tx_sql += @nwl + '      SELECT @ni_expected = COUNT(         CONCAT("|"' + @tx_pk_fields + '))'
    SET @tx_sql += @nwl + '           , @ni_measured = COUNT(DISTINCT CONCAT("|"' + @tx_pk_fields + '))'
    SET @tx_sql += @nwl + '      FROM ' + @ip_nm_target_schema + '.' + @ip_nm_target_table + ' AS s'
    SET @tx_sql += @nwl + '      WHERE s.meta_is_active = 1' 
    SET @tx_sql += @nwl + '      IF (@ni_expected != @ni_measured) BEGIN'
    SET @tx_sql += @nwl + '          SET @tx_error_message = "ERROR: There should only be 1 record per `Primarykey(s)` for ' + @ip_nm_target_schema + '.' + @ip_nm_target_table + '!"'
    SET @tx_sql += @nwl + '          RAISERROR(@tx_error_message, 18, 1)'
    SET @tx_sql += @nwl + '      END'
    SET @tx_sql += @nwl + '      '
    SET @tx_sql += @nwl + '    END'
    SET @tx_sql += @nwl + '    '
    SET @tx_sql += @nwl + '    /* Commit the `Transaction`. */'
    SET @tx_sql += @nwl + '    COMMIT TRANSACTION; SET @is_transaction = 0;'
    SET @tx_sql += @nwl + '    '
    SET @tx_sql += @nwl + '    /* Cleanup of the `Temporal (Landing and/or) Staging Area`-table(s). */'
    SET @tx_sql += @nwl + '    TRUNCATE TABLE [tsa_' + @ip_nm_target_schema + '].[tsa_' + @ip_nm_target_table + '];' 
    SET @tx_sql += @nwl + '    '
    SET @tx_sql += @nwl + '    /* Set Run Dataset to Success */'
    SET @tx_sql += @nwl + '    EXEC rdp.run_finish @id_dataset, @ni_before, @ni_ingested, @ni_inserted, @ni_updated, @ni_after'
    SET @tx_sql += @nwl + '    '
    SET @tx_sql += @nwl + '    /* All done */'
    SET @tx_sql += @nwl + '    PRINT("Data Ingestion for Dataset `' + @ip_nm_target_schema + '`.`' + @ip_nm_target_table + '` has been successfull.")'
    SET @tx_sql += @nwl + '    '
    SET @tx_sql += @nwl + '  END TRY'
    SET @tx_sql += @nwl + '  '
    SET @tx_sql += @nwl + '  BEGIN CATCH'
    SET @tx_sql += @nwl + '    '
    SET @tx_sql += @nwl + '    /* An `Error` occured`, rollback the transaction and register the `Error` in the Logging. */'
    SET @tx_sql += @nwl + '    IF (@@TRANCOUNT > 0) BEGIN ROLLBACK TRANSACTION; EXEC rdp.run_failed @id_dataset; END;'
    SET @tx_sql += @nwl + '    '
    SET @tx_sql += @nwl + '    /* Ended in `Error` !!!! */'
    SET @tx_sql += @nwl + '    PRINT(@tx_error_message)'
    SET @tx_sql += @nwl + '    PRINT("Data Ingestion for Dataset `' + @ip_nm_target_schema + '`.`' + @ip_nm_target_table + '` has ended in `Error`.")'
    SET @tx_sql += @nwl + '    '
    SET @tx_sql += @nwl + '  END CATCH'
    SET @tx_sql += @nwl + '  '
    SET @tx_sql += @nwl + 'END'
    SET @tx_sql = REPLACE(@tx_sql, '"', '''');
    EXEC gnc_commen.show_and_execute_sql @tx_message, @tx_sql, @ip_is_debugging, @ip_is_testing;

  END	

END
GO