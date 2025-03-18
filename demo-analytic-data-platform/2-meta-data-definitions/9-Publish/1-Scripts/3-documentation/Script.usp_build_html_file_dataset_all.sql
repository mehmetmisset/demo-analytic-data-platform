
DROP PROCEDURE IF EXISTS ##build_html_file_dataset_all;
GO
CREATE PROCEDURE ##build_html_file_dataset_all

    /* Input Parameters */
    @ip_is_debugging     BIT = 0,
    @ip_is_testing       BIT = 0

AS DECLARE 
      
    /* Data Attributes */
    @id_dataset CHAR(32)

BEGIN
    
  IF (1=1 /* Extract all "datasets". */) BEGIN

    DROP TABLE IF EXISTS ##dst; SELECT dst.id_dataset
    INTO ##dst FROM tsa_dta.tsa_dataset AS dst
    WHERE NOT nm_target_schema IN ('dq_result', 'dq_totals', 'dta_dq_aggregates', 'dqm');

  END

  WHILE ((SELECT COUNT(*) FROM ##dst) > 0) BEGIN
    
    /* Fetch Next "dataset" and remove from temp-table.. */
    SELECT @id_dataset = id_dataset FROM (SELECT TOP 1 * FROM ##dst) AS dst;
    DELETE FROM ##dst WHERE id_dataset = @id_dataset;

	  /* Extract all "Transformation"-parts from "source"-query. */
    EXEC ##build_html_file_dataset
      @ip_id_dataset   = @id_dataset,
      @ip_is_debugging = @ip_is_debugging;

  END
  
END
GO

