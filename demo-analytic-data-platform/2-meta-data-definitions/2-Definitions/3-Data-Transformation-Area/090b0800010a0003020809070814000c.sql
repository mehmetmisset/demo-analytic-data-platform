/* -------------------------------------------------------------------------- */
/* Definitions for `Dataset` and `related`-objects like `attributes`,         */
/* `DQ Controls`, `DQ Thresholds` and `related Group(s)`.                     */
/* -------------------------------------------------------------------------- */
/*                                                                            */
/* ID Dataset : `090b0800010a0003020809070814000c`                            */
/*                                                                            */
/* -------------------------------------------------------------------------- */
BEGIN

  /* --------------------- */
  /* `Dataset`-definitions */
  /* --------------------- */
  INSERT INTO tsa_dta.tsa_dataset (id_development_status, id_dataset, id_group, is_ingestion, fn_dataset, fd_dataset, nm_target_schema, nm_target_table, tx_source_query) VALUES ('06010b0900010908010d0e0404021503', '090b0800010a0003020809070814000c', '000f0e0007000e03020c0a0007091406', '0', 'Fact Exchange Rates', '<div><font face="Cascadia Mono" size=1>Historical Historical Exchange Rates for USD and CAD.</font></div>', 'dta_yahoo_exchange_rate', 'exchange_rate', 'SELECT <newline>    cur.Currency    AS [cd_currency],<newline>    ''DAILY''         AS [cd_exchange_rate],<newline>    stk.[Date]      AS [dt_exchange_rate],<newline>    stk.[Adj Close  Adjusted close price adjusted for splits and dividend and/or capital gain distributions.] AS [nr_exchange_rate]<newline><newline>FROM psa_yahoo_exchange_rate.eur_x_usd AS stk<newline><newline>JOIN psa_yahoo_static_data.currency AS cur ON cur.Currency = ''USD''<newline><newline>WHERE stk.meta_is_actual = 1<newline>AND   stk.[Date] IS NOT NULL<newline><newline>UNION ALL<newline><newline>SELECT<newline>    ''CAD''           AS [cd_currency],<newline>    ''DAILY''         AS [cd_exchange_rate],<newline>    stk.[Date]      AS [dt_exchange_rate],<newline>    stk.[Adj Close  Adjusted close price adjusted for splits and dividend and/or capital gain distributions.] AS [nr_exchange_rate]<newline><newline>FROM psa_yahoo_exchange_rate.eur_x_cad AS stk<newline><newline>WHERE stk.meta_is_actual = 1<newline>AND   stk.[Date] IS NOT NULL');
  
  /* ----------------------- */
  /* `Attribute`-definitions */
  /* ----------------------- */
  INSERT INTO tsa_dta.tsa_attribute (id_attribute, id_dataset, id_datatype, fn_attribute, fd_attribute, ni_ordering, nm_target_column, is_businesskey, is_nullable) VALUES ('000a000600010c0005090e05050c1402', '090b0800010a0003020809070814000c', '000e0b00050008010800000102140a0c', 'Currency Code', 'Currency Code', '1', 'cd_currency', '1', '0');
  INSERT INTO tsa_dta.tsa_attribute (id_attribute, id_dataset, id_datatype, fn_attribute, fd_attribute, ni_ordering, nm_target_column, is_businesskey, is_nullable) VALUES ('000b0f06090d090307000d0602001401', '090b0800010a0003020809070814000c', '00010804040e0b0300090e06030b1406', 'Exchange Rate Date', 'Exchange Rate Date', '3', 'dt_exchange_rate', '1', '0');
  INSERT INTO tsa_dta.tsa_attribute (id_attribute, id_dataset, id_datatype, fn_attribute, fd_attribute, ni_ordering, nm_target_column, is_businesskey, is_nullable) VALUES ('050d0006050b000203090f031d010f03', '090b0800010a0003020809070814000c', '000e0b00050008010800000102140a0c', 'Exchange Rate Code', 'Exchange Rate Code', '2', 'cd_exchange_rate', '1', '0');
  INSERT INTO tsa_dta.tsa_attribute (id_attribute, id_dataset, id_datatype, fn_attribute, fd_attribute, ni_ordering, nm_target_column, is_businesskey, is_nullable) VALUES ('06090d03090e0a05080e0f0002140a05', '090b0800010a0003020809070814000c', '00010804040e0b0300090e06030b1406', 'Exchange Rate', 'Exchange Rate', '4', 'nr_exchange_rate', '0', '0');

  /* ------------------------------ */
  /* `Parameter Values`-definitions */
  /* ------------------------------ */
  -- No Defintions for `Parameter Values`

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

