/* -------------------------------------------------------------------------- */
/* Definitions for `Dataset` and `related`-objects like `attributes`,         */
/* `DQ Controls`, `DQ Thresholds` and `related Group(s)`.                     */
/* -------------------------------------------------------------------------- */
/*                                                                            */
/* ID Dataset : `000c0a0c060d0e050301090d0409140d`                            */
/*                                                                            */
/* -------------------------------------------------------------------------- */
BEGIN

  /* --------------------- */
  /* `Dataset`-definitions */
  /* --------------------- */
  INSERT INTO tsa_dta.tsa_dataset (id_development_status, id_dataset, id_group, is_ingestion, fn_dataset, fd_dataset, nm_target_schema, nm_target_table, tx_source_query) VALUES ('06010b0900010908010d0e0404021503', '000c0a0c060d0e050301090d0409140d', '000c0a0c060d0d03090f0d02080c1400', '1', 'NVIDIA Corporation (NVDA) - Dividends', '<div>Dividents of NVIDIA, the rawdata gie stock prize, splits as well, these are filtered out, also the current date is filtered out, for reason that in-day values can change still.</div>', 'psa_yahoo_dividends', 'nvidia', 'SELECT tsl.[Date]<newline>     , tsl.[Open]<newline>     , tsl.[High]<newline>     , tsl.[Low]<newline>     , tsl.[Close Close price adjusted for splits.]<newline>     , tsl.[Adj Close Adjusted close price adjusted for splits and dividend and/or capital gain distributions.]<newline>     , tsl.[Volume]<newline><newline>FROM [tsl_psa_yahoo_dividends].[tsl_nvidia] AS tsl<newline><newline>WHERE CHARINDEX(''Dividend'', tsl.[Close Close price adjusted for splits.], 1) != 0<newline>AND   CONVERT(DATE, tsl.[Date]) < CONVERT(DATE, GETDATE())');
  
  /* ----------------------- */
  /* `Attribute`-definitions */
  /* ----------------------- */
  INSERT INTO tsa_dta.tsa_attribute (id_attribute, id_dataset, id_datatype, fn_attribute, fd_attribute, ni_ordering, nm_target_column, is_businesskey, is_nullable) VALUES ('07090900040c0b04050a090502140905', '000c0a0c060d0e050301090d0409140d', '000b0f06090d0904090d000c05091400', 'Datum', '<div>Datum</div>', '1', 'Date', '1', '1');
  INSERT INTO tsa_dta.tsa_attribute (id_attribute, id_dataset, id_datatype, fn_attribute, fd_attribute, ni_ordering, nm_target_column, is_businesskey, is_nullable) VALUES ('000f0c02090b090103080a02050a1400', '000c0a0c060d0e050301090d0409140d', '000b0f06090d0904090d000c05091400', 'Open', 'Open', '2', 'Open', '0', '1');
  INSERT INTO tsa_dta.tsa_attribute (id_attribute, id_dataset, id_datatype, fn_attribute, fd_attribute, ni_ordering, nm_target_column, is_businesskey, is_nullable) VALUES ('00080e06090f0d06010c0f0103091401', '000c0a0c060d0e050301090d0409140d', '000b0f06090d0904090d000c05091400', 'High', 'High', '3', 'High', '0', '1');
  INSERT INTO tsa_dta.tsa_attribute (id_attribute, id_dataset, id_datatype, fn_attribute, fd_attribute, ni_ordering, nm_target_column, is_businesskey, is_nullable) VALUES ('040b0c05090108050208010608140b04', '000c0a0c060d0e050301090d0409140d', '000b0f06090d0904090d000c05091400', 'Low', 'Low', '4', 'Low', '0', '1');
  INSERT INTO tsa_dta.tsa_attribute (id_attribute, id_dataset, id_datatype, fn_attribute, fd_attribute, ni_ordering, nm_target_column, is_businesskey, is_nullable) VALUES ('000c0803070b080d080f0b0c07011402', '000c0a0c060d0e050301090d0409140d', '000b0f06090d0904090d000c05091400', 'Close', 'Close', '5', 'Close Close price adjusted for splits.', '0', '1');
  INSERT INTO tsa_dta.tsa_attribute (id_attribute, id_dataset, id_datatype, fn_attribute, fd_attribute, ni_ordering, nm_target_column, is_businesskey, is_nullable) VALUES ('00090e00060e0d0008080901080a140d', '000c0a0c060d0e050301090d0409140d', '000b0f06090d0904090d000c05091400', 'Adjusted Close', 'Adjusted Close', '6', 'Adj Close Adjusted close price adjusted for splits and dividend and/or capital gain distributions.', '0', '1');
  INSERT INTO tsa_dta.tsa_attribute (id_attribute, id_dataset, id_datatype, fn_attribute, fd_attribute, ni_ordering, nm_target_column, is_businesskey, is_nullable) VALUES ('07080100060c0007040e090d05140f0d', '000c0a0c060d0e050301090d0409140d', '000b0f06090d0904090d000c05091400', 'Volume', 'Volume', '7', 'Volume', '0', '1');

  /* ------------------------------ */
  /* `Parameter Values`-definitions */
  /* ------------------------------ */
  INSERT INTO tsa_dta.tsa_parameter_value (id_parameter_value, id_dataset, id_parameter, tx_parameter_value, ni_parameter_value) VALUES ('090b080000090a03020c090305140103', '000c0a0c060d0e050301090d0409140d', '06040002070308080001000205051505', 'web', '1');
  INSERT INTO tsa_dta.tsa_parameter_value (id_parameter_value, id_dataset, id_parameter, tx_parameter_value, ni_parameter_value) VALUES ('00090b02000a0c04050f0004030e1405', '000c0a0c060d0e050301090d0409140d', '0601090601040e01050d0b08060c1502', 'web_table_anonymous_web', '2');
  INSERT INTO tsa_dta.tsa_parameter_value (id_parameter_value, id_dataset, id_parameter, tx_parameter_value, ni_parameter_value) VALUES ('000a080300090807030a0004010d1400', '000c0a0c060d0e050301090d0409140d', '030001030306000407070b001b020001', 'https://finance.yahoo.com/quote/', '1');
  INSERT INTO tsa_dta.tsa_parameter_value (id_parameter_value, id_dataset, id_parameter, tx_parameter_value, ni_parameter_value) VALUES ('00000004090a0905080a0b0d0800140c', '000c0a0c060d0e050301090d0409140d', '06060e030f000b0104070b080f0c1503', 'NVDA/history/?period1=<@ni_previous_epoch>&period2=<@ni_current_epoch>&filter=history', '2');
  INSERT INTO tsa_dta.tsa_parameter_value (id_parameter_value, id_dataset, id_parameter, tx_parameter_value, ni_parameter_value) VALUES ('0409010209090e0c040a0b0006140f05', '000c0a0c060d0e050301090d0409140d', '00040c060f030a040007090507190d05', '0', '3');

  /* ------------------------------ */
  /* `SQL for ETL`-definitions      */
  /* ------------------------------ */
  INSERT INTO tsa_dta.tsa_ingestion_etl (id_ingestion_etl, id_dataset, nm_processing_type, tx_sql_for_meta_dt_valid_from, tx_sql_for_meta_dt_valid_till) VALUES ('0008080609090002020b010108091403', '000c0a0c060d0e050301090d0409140d', 'Incremental', 'tsl.[Date]', '''9999-12-31''');

  /* ------------------------------ */
  /* `Schedule`-definitions         */
  /* ------------------------------ */
  INSERT INTO tsa_dta.tsa_schedule (id_schedule, id_dataset, cd_frequency, ni_interval, dt_start, dt_end) VALUES ('090d0e00030b0804080d08030814010d', '000c0a0c060d0e050301090d0409140d', 'Minutes', '5', '2025-03-18', '2025-03-30');

  /* -------------------------------- */
  /* `Related (Group(s))`-definitions */
  /* -------------------------------- */
  INSERT INTO tsa_ohg.tsa_related (id_related, id_dataset, id_group) VALUES ('06010b0900000f000406010700051505', '000c0a0c060d0e050301090d0409140d', '000e0f0104090f0002080e04070f1403');

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

