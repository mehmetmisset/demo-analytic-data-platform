/* -------------------------------------------------------------------------- */
/* Definitions for `Dataset` and `related`-objects like `attributes`,         */
/* `DQ Controls`, `DQ Thresholds` and `related Group(s)`.                     */
/* -------------------------------------------------------------------------- */
/*                                                                            */
/* ID Dataset : `06010b0900010806040c0a0701041509`                            */
/*                                                                            */
/* -------------------------------------------------------------------------- */
BEGIN

  /* --------------------- */
  /* `Dataset`-definitions */
  /* --------------------- */
  INSERT INTO tsa_dta.tsa_dataset (id_development_status, id_dataset, id_group, is_ingestion, fn_dataset, fd_dataset, nm_target_schema, nm_target_table, tx_source_query) VALUES ('06010b0900010908010d0e0404021503', '06010b0900010806040c0a0701041509', '000c0a0c060c080d070d0c00020b1402', '1', 'Currencies', '<div><font face="Cascadia Mono" size=1>List of Currencies in use, with ISO code and Name</font></div>', 'psa_yahoo_static_data', 'currency', 'SELECT Currency, Name<newline>FROM tsl_yahoo_static_data.currency');
  
  /* ----------------------- */
  /* `Attribute`-definitions */
  /* ----------------------- */
  INSERT INTO tsa_dta.tsa_attribute (id_attribute, id_dataset, id_datatype, fn_attribute, fd_attribute, ni_ordering, nm_target_column, is_businesskey, is_nullable) VALUES ('01040805030d0805020c090500190905', '06010b0900010806040c0a0701041509', '000b0f06090d0904090d000c05091400', 'Currency Code', '<div>Code of Currency</div>', '1', 'Currency', '1', '0');
  INSERT INTO tsa_dta.tsa_attribute (id_attribute, id_dataset, id_datatype, fn_attribute, fd_attribute, ni_ordering, nm_target_column, is_businesskey, is_nullable) VALUES ('06030d0804000804030008040e0c1500', '06010b0900010806040c0a0701041509', '000b0f06090d0904090d000c05091400', 'Currency Name', '<div>Name of Currency</div>', '2', 'Name', '0', '0');

  /* ------------------------------ */
  /* `Parameter Values`-definitions */
  /* ------------------------------ */
  INSERT INTO tsa_dta.tsa_parameter_value (id_parameter_value, id_dataset, id_parameter, tx_parameter_value, ni_parameter_value) VALUES ('00080b0600000104030d0d0d04001401', '06010b0900010806040c0a0701041509', '06020f05010d0e080205010504041501', 'currency.xlsx', '6');
  INSERT INTO tsa_dta.tsa_parameter_value (id_parameter_value, id_dataset, id_parameter, tx_parameter_value, ni_parameter_value) VALUES ('00080e06090e0c03000c0d07080e1407', '06010b0900010806040c0a0701041509', '0601090601040e01050d0b08060c1502', 'xls', '2');
  INSERT INTO tsa_dta.tsa_parameter_value (id_parameter_value, id_dataset, id_parameter, tx_parameter_value, ni_parameter_value) VALUES ('00090002040b0905060c080d06011405', '06010b0900010806040c0a0701041509', '06050f030f030d070203000507021502', 'Currency', '7');
  INSERT INTO tsa_dta.tsa_parameter_value (id_parameter_value, id_dataset, id_parameter, tx_parameter_value, ni_parameter_value) VALUES ('000c0a0c060c0a04030f000707081401', '06010b0900010806040c0a0701041509', '000c0a0c060c0a04030f000d060e1400', 'sasYahooFiles', '3');
  INSERT INTO tsa_dta.tsa_parameter_value (id_parameter_value, id_dataset, id_parameter, tx_parameter_value, ni_parameter_value) VALUES ('000d000c0401000209000f07080c140d', '06010b0900010806040c0a0701041509', '06020d070f040d000f01000701071508', 'statis_data', '5');
  INSERT INTO tsa_dta.tsa_parameter_value (id_parameter_value, id_dataset, id_parameter, tx_parameter_value, ni_parameter_value) VALUES ('000f0e0007000004050e0c03060c140c', '06010b0900010806040c0a0701041509', '06040002070308080001000205051505', 'abs_sas_url', '1');
  INSERT INTO tsa_dta.tsa_parameter_value (id_parameter_value, id_dataset, id_parameter, tx_parameter_value, ni_parameter_value) VALUES ('03090900060e0e0003080b0705140b06', '06010b0900010806040c0a0701041509', '06030d08040008060f0d0e0801011502', 'yahoo', '4');
  INSERT INTO tsa_dta.tsa_parameter_value (id_parameter_value, id_dataset, id_parameter, tx_parameter_value, ni_parameter_value) VALUES ('07000f0602000f0d0000000300140b0c', '06010b0900010806040c0a0701041509', '0e0100000506080806030a050e190802', 'true', '8');

  /* ------------------------------ */
  /* `SQL for ETL`-definitions      */
  /* ------------------------------ */
  -- No Defintions for `SQL for ETL`

  /* ------------------------------ */
  /* `Schedule`-definitions         */
  /* ------------------------------ */
  -- No Defintions for `SQL for ETL`

  /* -------------------------------- */
  /* `Related (Group(s))`-definitions */
  /* -------------------------------- */
  INSERT INTO tsa_ohg.tsa_related (id_related, id_dataset, id_group) VALUES ('05010f01010a0c03050a0e0108140902', '06010b0900010806040c0a0701041509', '000e0f0104090f0002080e04070f1403');

  /* ------------------------ */
  /* `DQ Control`-definitions */
  /* ------------------------ */
  INSERT INTO tsa_dqm.tsa_dq_control (id_dq_requirement, id_development_status, id_dq_control, id_dq_dimension, id_dataset, cd_dq_control, fn_dq_control, fd_dq_control, tx_dq_control_query, dt_valid_from, dt_valid_till) VALUES ('06010b09000108000001010805041503', '06010b0900010908010d0e0404021503', '06010b0900010b06040009090e0d1505', '06070e08050d0d09000c0e0706011509', '06010b0900010806040c0a0701041509', 'DQC-0001', 'Currency must be Filled', 'Check if Currency is Filled', 'SELECT cur.meta_ch_bk AS id_dataset_1_bk, <newline>          ''n/a''                  AS id_dataset_2_bk, <newline>          ''n/a''                  AS id_dataset_3_bk, <newline>          ''n/a''                  AS id_dataset_4_bk, <newline>          ''n/a''                  AS id_dataset_5_bk, CASE <newline>            WHEN [cur].[Currency] IS NULL THEN ''NOK''<newline>            WHEN LEN([cur].[Currency]) = 0 THEN ''NOK''<newline>            ELSE ''OK''<newline>          END AS id_dq_result_status<newline><newline>FROM psa_yahoo_static_data.currency AS cur', '1900-01-01', '9999-12-31');

  /* -------------------------- */
  /* `DQ Threshold`-definitions */
  /* -------------------------- */
  INSERT INTO tsa_dqm.tsa_dq_threshold (id_dq_threshold, id_dq_risk_level, id_dq_control, nr_dq_threshold_from, nr_dq_threshold_till, dt_valid_from, dt_valid_till) VALUES ('01040805030d0c0605050c0600190d04', '06020f05010d0f06040d0d0105061508', '06010b0900010b06040009090e0d1505', '0.925000', '0.974999', '1900-01-01', '9999-12-31');
  INSERT INTO tsa_dqm.tsa_dq_threshold (id_dq_threshold, id_dq_risk_level, id_dq_control, nr_dq_threshold_from, nr_dq_threshold_till, dt_valid_from, dt_valid_till) VALUES ('06010b0900010b06040008050f021507', '06050f030f030a0805030f08020d1505', '06010b0900010b06040009090e0d1505', '0.975000', '1.000000', '1900-01-01', '9999-12-31');
  INSERT INTO tsa_dqm.tsa_dq_threshold (id_dq_threshold, id_dq_risk_level, id_dq_control, nr_dq_threshold_from, nr_dq_threshold_till, dt_valid_from, dt_valid_till) VALUES ('06030d0804000b070e010f090f0d1502', '06020d070f040b080f010e040f051501', '06010b0900010b06040009090e0d1505', '0.000000', '0.924999', '1900-01-01', '9999-12-31');
  
END
GO

