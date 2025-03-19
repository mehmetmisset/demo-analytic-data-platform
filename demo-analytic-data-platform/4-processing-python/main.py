import sys
sys.path.append('modules')

# Import Custom Modules
import modules.run as run

# Set Debugging to "1" => true
is_debugging = "1"

# Process all datasets
run.process('psa_yahoo_stocks',        'o', is_debugging)
run.process('psa_yahoo_stocks',        'nvidia', is_debugging)
run.process('psa_yahoo_stocks',        'abnas', is_debugging)
run.process('psa_yahoo_exchange_rate', 'eur_x_cad', is_debugging)
run.process('psa_yahoo_exchange_rate', 'eur_x_usd', is_debugging)
run.process('psa_yahoo_dividends',     'nvidia', is_debugging)
run.process('psa_references',          'currency', is_debugging)
run.process('psa_references',          'stock', is_debugging)

print("all done")