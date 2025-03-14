CREATE PROCEDURE [mdm].[deploy_dataset]

  /* Input Parameters */
  @ip_id_dataset       CHAR(32),
  @ip_nm_target_schema NVARCHAR(128),
  @ip_nm_target_table  NVARCHAR(128),

  /* Input Paramters for "Debugging". */
  @ip_is_debugging     BIT = 0,
  @ip_is_testing       BIT = 0

AS BEGIN

  /* Local Variables */
  DECLARE @NOW DATETIME = GETDATE();
  
  BEGIN

	  IF (@ip_id_dataset != 'n/a' /* Generate "Presisten/Temporal Staging Area"- or "Data Transformation Area"-tables, -Views and -Procedures. */) BEGIN

		  /* Create "Schemas" if needed. */
		  EXEC mdm.create_schema @ip_nm_target_schema;

      /* Create "Presisten/Temporal Staging Area"- or "Data Transformation Area"-tables. */
		  EXEC mdm.create_temporal_staging_area_table @ip_id_dataset, @ip_nm_target_schema, @ip_nm_target_table;

      /* Create "Procedures" for processing data changes. */
		  EXEC mdm.create_user_specified_procedure @ip_nm_target_schema, @ip_nm_target_table;

	  END
  END
  /* All Done */
  RETURN 0

END
GO