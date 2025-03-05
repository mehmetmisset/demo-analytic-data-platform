import modules.webtable as web
import modules.df_into_sql as tsl

is_debugging = 1

wtb_1_any_ds_url   = "https://finance.yahoo.com/quote/"
wtb_2_any_ds_path  = "NVDA/history/?period1=1709544776&period2=1741080767&filter=history" 
wtb_3_any_ni_index = "0"

df = web.webtable(wtb_1_any_ds_url, wtb_2_any_ds_path,wtb_3_any_ni_index, is_debugging)

sql_1_nm_server   = "misset.synology.me:1433"
sql_2_nm_username = "sa"
sql_3_nm_database = "meta"
sql_4_nm_schema   = "tsl_psa_yahoo_exchange_rate"
sql_5_nm_table    = "tsl_eur_x_usd"
sql_6_nm_secret   = "Bahar@2810"

tsl.copy_df_to_sql(df, sql_1_nm_server, sql_2_nm_username, sql_3_nm_database, sql_4_nm_schema, sql_5_nm_table, sql_6_nm_secret, is_debugging)

print("all done")