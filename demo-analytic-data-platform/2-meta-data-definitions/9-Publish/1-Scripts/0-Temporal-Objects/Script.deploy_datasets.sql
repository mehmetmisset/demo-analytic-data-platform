DROP PROCEDURE IF EXISTS ##deploy_datasets
GO
CREATE PROCEDURE ##deploy_datasets

    /* Input Parameters */
    @ip_is_debugging     BIT = 0,
    @ip_is_testing       BIT = 0

AS DECLARE 
      
    /* Data Attributes */
    @id_dataset       CHAR(32),
    @nm_target_schema NVARCHAR(128),
    @nm_target_table  NVARCHAR(128)

BEGIN
    
  IF (1=1 /* Extract all "datasets". */) BEGIN

    DROP TABLE IF EXISTS ##to_deploy; SELECT 
      dst.id_dataset, 
      dst.nm_target_schema, 
      dst.nm_target_table
    INTO ##to_deploy FROM tsa_dta.tsa_dataset AS dst;        

  END

  WHILE ((SELECT COUNT(*) FROM ##to_deploy) > 0) BEGIN
    
    /* Fetch Next "dataset" and remove from temp-table.. */
    SELECT @id_dataset       = id_dataset,
           @nm_target_schema = nm_target_schema,
           @nm_target_table  = nm_target_table 
    FROM (SELECT TOP 1 * FROM ##to_deploy) AS dst;
    DELETE FROM ##to_deploy WHERE id_dataset = @id_dataset;

    /* Show what is being deployed. */
    PRINT('----------------------------------------------------------------');
    PRINT('@id_dataset       : ' + @id_dataset);
    PRINT('@nm_target_schema : ' + @nm_target_schema);
    PRINT('@nm_target_table  : ' + @nm_target_table);

	  BEGIN TRY /* Deploy Dataset. */
      EXEC mdm.deploy_dataset
        @ip_id_dataset       = @id_dataset,
        @ip_nm_target_schema = @nm_target_schema,
        @ip_nm_target_table  = @nm_target_table,
        @ip_is_debugging     = @ip_is_debugging,
        @ip_is_testing       = @ip_is_testing;
      PRINT('#status           : Successfull');

    END TRY
    BEGIN CATCH
      PRINT('#status           : Failed');
    END CATCH
    PRINT('');

  END
  
END
GO

