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



  SELECT @param1, @param2
RETURN 0
