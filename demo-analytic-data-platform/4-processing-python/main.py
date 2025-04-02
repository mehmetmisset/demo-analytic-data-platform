# This is the main script to run the data pipeline for the PSA and DTA datasets.
# It is the main entry point for the data pipeline and is used to run the data pipeline for all datasets.
# It is also used to run the data pipeline for a specific dataset.
import sys
sys.path.append('modules')

# Import Custom Modules
import modules.run as run

# Set Debugging to "1" => true
is_debugging = "1"

# rebuild html documentation for main pagepip
run.export_documentation('-1', is_debugging)

# Process all datasets

# run.data_pipeline('psa_references', 'currency', is_debugging)
# run.data_pipeline('psa_references', 'stock', is_debugging)

# run.data_pipeline('psa_yahoo_dividends', 'o', is_debugging)
# run.data_pipeline('psa_yahoo_dividends', 'abnas', is_debugging)
# run.data_pipeline('psa_yahoo_dividends', 'rf', is_debugging)
# run.data_pipeline('psa_yahoo_dividends', 'nvidia', is_debugging)

run.data_pipeline('psa_yahoo_exchange_rate', 'eur_x_cad', is_debugging)
run.data_pipeline('psa_yahoo_exchange_rate', 'eur_x_usd', is_debugging)

run.data_pipeline('psa_yahoo_stocks', 'abnas', is_debugging)
run.data_pipeline('psa_yahoo_stocks', 'rf', is_debugging)
run.data_pipeline('psa_yahoo_stocks', 'o', is_debugging)
run.data_pipeline('psa_yahoo_stocks', 'nvidia', is_debugging)

#Transformations
run.data_pipeline('dta_dimensions', 'currency', is_debugging)
run.data_pipeline('dta_yahoo_stocks', 'stocks_u01_v02', is_debugging)
run.data_pipeline('dta_yahoo_stocks', 'stocks_u01_v01', is_debugging)
# run.data_pipeline('dta_yahoo_exchange_rate', 'exchange_rate', is_debugging)

print("all done")