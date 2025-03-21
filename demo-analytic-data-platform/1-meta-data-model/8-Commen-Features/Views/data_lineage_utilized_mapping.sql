CREATE VIEW [mdm].[data_lineage_utilized_mapping] AS 
SELECT id_target_dataset         = tgt.id_dataset
     , fn_target_dataset         = tgt.fn_dataset
     , nm_target_schema          = tgt.nm_target_schema
     , nm_target_table           = tgt.nm_target_table
	   , ni_target_ordering        = tgc.ni_ordering
	   , nm_target_colum           = tgc.nm_target_column	   
	   , ni_transformation_part    = prt.ni_transformation_part
	   , tx_source_mapping         = ump.tx_transformation_mapping
	   , nm_source_column          = src.nm_target_column
	   , nm_source_schema          = srd.nm_target_schema
	   , nm_source_table           = srd.nm_target_table

FROM [dta].[dataset]                AS tgt
JOIN [dta].[attribute]              AS tgc ON tgc.meta_is_active = 1 AND tgc.id_dataset             = tgt.id_dataset
JOIN [dta].[transformation_part]	  AS prt ON prt.meta_is_active = 1 AND prt.id_dataset             = tgt.id_dataset
JOIN [dta].[transformation_mapping]	AS ump ON ump.meta_is_active = 1 AND ump.id_transformation_part = prt.id_transformation_part AND ump.id_attribute = tgc.id_attribute

LEFT JOIN [dta].[transformation_attribute] AS uat ON uat.meta_is_active = 1 AND uat.id_transformation_mapping = ump.id_transformation_mapping
LEFT JOIN [dta].[attribute]                AS src ON src.meta_is_active = 1 AND src.id_attribute              = uat.id_attribute
LEFT JOIN [dta].[dataset]                  AS srd ON srd.meta_is_active = 1 AND srd.id_dataset                = src.id_dataset
           
WHERE tgt.meta_is_active = 1
