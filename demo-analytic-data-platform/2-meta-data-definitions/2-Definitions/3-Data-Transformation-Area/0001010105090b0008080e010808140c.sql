/* -------------------------------------------------------------------------- */
/* Definitions for `Dataset` and `related`-objects like `attributes`,         */
/* `DQ Controls`, `DQ Thresholds` and `related Group(s)`.                     */
/* -------------------------------------------------------------------------- */
/*                                                                            */
/* ID Dataset : `0001010105090b0008080e010808140c`                            */
/*                                                                            */
/* -------------------------------------------------------------------------- */
BEGIN

  /* --------------------- */
  /* `Dataset`-definitions */
  /* --------------------- */
  INSERT INTO tsa_dta.tsa_dataset (id_development_status, id_dataset, id_group, is_ingestion, fn_dataset, fd_dataset, nm_target_schema, nm_target_table, tx_source_query) VALUES ('06010b0900010908010d0e0404021503', '0001010105090b0008080e010808140c', '02090f01060b0d0c090b09031d00080c', '1', 'Currencies (rawdata)', '<div>List of Currencies loaded form Azure Blob Storage Account</div>', 'psa_references', 'currency', 'SELECT tsl.[Currency]<newline>     , tsl.[Name]<newline><newline>FROM [tsl_psa_references].[tsl_currency] AS tsl');
  
  /* ----------------------- */
  /* `Attribute`-definitions */
  /* ----------------------- */
  INSERT INTO tsa_dta.tsa_attribute (id_attribute, id_dataset, id_datatype, fn_attribute, fd_attribute, ni_ordering, nm_target_column, is_businesskey, is_nullable) VALUES ('06070e08050c010502000a0906031502', '0001010105090b0008080e010808140c', '000b0f06090d0904090d000c05091400', 'Currency Code', '<div>Code of the Currency</div>', '1', 'Currency', '1', '1');
  INSERT INTO tsa_dta.tsa_attribute (id_attribute, id_dataset, id_datatype, fn_attribute, fd_attribute, ni_ordering, nm_target_column, is_businesskey, is_nullable) VALUES ('06040a0706070d01030d010907051508', '0001010105090b0008080e010808140c', '000b0f06090d0904090d000c05091400', 'Currency Name', '<div>Naam of the Currency</div>', '2', 'Name', '0', '1');

  /* ------------------------------ */
  /* `Parameter Values`-definitions */
  /* ------------------------------ */
  INSERT INTO tsa_dta.tsa_parameter_value (id_parameter_value, id_dataset, id_parameter, tx_parameter_value, ni_parameter_value) VALUES ('000c0003020e090d070f0104030e140c', '0001010105090b0008080e010808140c', '0601090601040e01050d0b08060c1502', 'abs_sas_url_xls', '2');
  INSERT INTO tsa_dta.tsa_parameter_value (id_parameter_value, id_dataset, id_parameter, tx_parameter_value, ni_parameter_value) VALUES ('0309090006000f06080b0a0106140b0d', '0001010105090b0008080e010808140c', '06020f05010d0e080205010504041501', 'yahoo', '5');
  INSERT INTO tsa_dta.tsa_parameter_value (id_parameter_value, id_dataset, id_parameter, tx_parameter_value, ni_parameter_value) VALUES ('0008090d020c0a0208090c0708091406', '0001010105090b0008080e010808140c', '06020d070f040d000f01000701071508', 'Yahoo-Blob-SAS-Token', '4');
  INSERT INTO tsa_dta.tsa_parameter_value (id_parameter_value, id_dataset, id_parameter, tx_parameter_value, ni_parameter_value) VALUES ('000e0a050200090c000b0801080e140d', '0001010105090b0008080e010808140c', '06040002070308080001000205051505', 'abs', '1');
  INSERT INTO tsa_dta.tsa_parameter_value (id_parameter_value, id_dataset, id_parameter, tx_parameter_value, ni_parameter_value) VALUES ('000b080600010806030c0b05060d1400', '0001010105090b0008080e010808140c', '06030d08040008060f0d0e0801011502', 'demoasawedev', '3');
  INSERT INTO tsa_dta.tsa_parameter_value (id_parameter_value, id_dataset, id_parameter, tx_parameter_value, ni_parameter_value) VALUES ('000f0d0c070c0e07070e0e0201091404', '0001010105090b0008080e010808140c', '06050f030f030d070203000507021502', 'statis_data', '6');
  INSERT INTO tsa_dta.tsa_parameter_value (id_parameter_value, id_dataset, id_parameter, tx_parameter_value, ni_parameter_value) VALUES ('02080f070009090703090a0c05140d06', '0001010105090b0008080e010808140c', '0e0100000506080806030a050e190802', 'currency.xlsx', '7');
  INSERT INTO tsa_dta.tsa_parameter_value (id_parameter_value, id_dataset, id_parameter, tx_parameter_value, ni_parameter_value) VALUES ('040c0f00090d0103080f080103140d02', '0001010105090b0008080e010808140c', '0006000005020b0802060b0806190a02', 'Currency', '8');
  INSERT INTO tsa_dta.tsa_parameter_value (id_parameter_value, id_dataset, id_parameter, tx_parameter_value, ni_parameter_value) VALUES ('000a0d01000f0001010b0b0304081402', '0001010105090b0008080e010808140c', '0207090800000b0601050f0302190a06', '1', '9');
  INSERT INTO tsa_dta.tsa_parameter_value (id_parameter_value, id_dataset, id_parameter, tx_parameter_value, ni_parameter_value) VALUES ('020d0d0803030b0204010a061b010f08', '0001010105090b0008080e010808140c', '060c0901020d0a090f010f0603051508', 'A', '10');
  INSERT INTO tsa_dta.tsa_parameter_value (id_parameter_value, id_dataset, id_parameter, tx_parameter_value, ni_parameter_value) VALUES ('0f030c06010d0c0205040d0206190b03', '0001010105090b0008080e010808140c', '05040e05040d0a080f050c0606190103', 'B', '11');

  /* ------------------------------ */
  /* `SQL for ETL`-definitions      */
  /* ------------------------------ */
  INSERT INTO tsa_dta.tsa_ingestion_etl (id_ingestion_etl, id_dataset, nm_processing_type, tx_sql_for_meta_dt_valid_from, tx_sql_for_meta_dt_valid_till) VALUES ('06010b0900000f0004070e000f011509', '0001010105090b0008080e010808140c', 'Fullload', 'GETDATE()', '''9999-12-31''');

  /* ------------------------------ */
  /* `Schedule`-definitions         */
  /* ------------------------------ */
  -- No Defintions for `SQL for ETL`

  /* -------------------------------- */
  /* `Related (Group(s))`-definitions */
  /* -------------------------------- */
  -- No Defintions for `Related (Group(s))`

  /* ------------------------ */
  /* `DQ Control`-definitions */
  /* ------------------------ */
  -- No Defintions for `DQ Control`

  /* -------------------------- */
  /* `DQ Threshold`-definitions */
  /* -------------------------- */
  -- No Defintions for `DQ Threshold`
  
END
GO

