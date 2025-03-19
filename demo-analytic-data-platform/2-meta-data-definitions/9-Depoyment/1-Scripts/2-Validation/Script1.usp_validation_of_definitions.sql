SET NOCOUNT ON;

/* Create "temporal"-table for storing "Validataion"-issue of the Definitions. */
DROP TABLE IF EXISTS mdm.validation_issues;
GO
CREATE TABLE mdm.validation_issues (
  id_dataset          CHAR(32)      NULL,
  id_attribute        CHAR(32)      NULL,
  nm_validation_issue NVARCHAR(128) NULL,
  ds_validation_issue NVARCHAR(999) NULL,
)
GO

IF (1=1 /* Validate that all "utilized" datasets in "Transformations" have a "Alias" assigned. */) BEGIN
  INSERT INTO mdm.validation_issues (id_dataset, id_attribute, nm_validation_issue, ds_validation_issue)
  SELECT 
    id_dataset          = tgt.id_dataset,
    id_attribute        = NULL,
    nm_validation_issue = 'Missing "Alias"!',
    ds_validation_issue = 'For "Transformation" named "' + tgt.fn_dataset + '" the utilized dataset "' + src.fn_dataset + '" has NO "Alias".'

  FROM tsa_dta.tsa_transformation_dataset AS uds
  JOIN tsa_dta.tsa_transformation_part    AS prt ON prt.id_transformation_part = uds.id_transformation_part
  JOIN tsa_dta.tsa_dataset                AS tgt ON tgt.id_dataset = prt.id_dataset
  LEFT JOIN tsa_dta.tsa_dataset           AS src ON src.id_dataset = uds.id_dataset
  
  WHERE uds.cd_alias IS NULL;
END
GO

IF ((SELECT COUNT(*) FROM mdm.validation_issues) > 0) BEGIN
  
  SELECT * FROM mdm.validation_issues;
  RAISERROR('Various Error where detected in the Definitions of the metadata!', 16, 1);

END;
GO

