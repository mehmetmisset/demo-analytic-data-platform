import sys
sys.path.append('modules')

# Import Custom Modules
import modules.credentials as sa
import modules.source      as src
import modules.target      as tgt
import modules.run         as run

print(run.get_secret('Yahoo-Blob-SAS-Token', '1'))
