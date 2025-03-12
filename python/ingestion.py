import sys
sys.path.append('modules')

# Import Custom Modules
from modules import source as src
from modules import target as tgt

is_debugging = 1

wtb_1_any_ds_url   = "https://finance.yahoo.com/quote/"
wtb_2_any_ds_path  = "NVDA/history/?period1=1709544776&period2=1741080767&filter=history" 
wtb_3_any_ni_index = "0"

source_df = src.web_table_anonymous_web(wtb_1_any_ds_url, wtb_2_any_ds_path,wtb_3_any_ni_index, is_debugging)
# 
# nm_target_schema = "tsl_psa_yahoo_exchange_rate"
# nm_target_table  = "tsl_eur_x_usd"
# 
# tgt.load_tsl(source_df, nm_target_schema, nm_target_table, is_debugging)
# 
# print("all done")