import sys
sys.path.append('modules')

# Import Custom Modules
import modules.credentials as sa
import modules.source      as src
import modules.target      as tgt
import modules.run         as run

from datetime import datetime as dt

# Set Debugging to "1" => true
is_debugging = "1"

def update_dataset(ds_external_reference_id, id_dataset, is_ingestion, nm_procedure, nm_tsl_schema, nm_tsl_table):
    
    # Local Vairables
    result = 'OK'

    # If "Ingestion" first extract "source" data
    if is_ingestion == 1:

        # for "Ingestion" the run must be started, if "Transformation" the run is started in the "procedure" itself.
        run.start(id_dataset, is_debugging, ds_external_reference_id)

        # Get the parameters
        params = run.get_parameters(id_dataset)
        
        # Paramters
        cd_parameter_group = params.loc[0]['cd_parameter_group']

        # Switch for cd_parameter_group
        if cd_parameter_group == 'web_table_anonymous_web':

            # Get Ingestion specific parameters
            wtb_1_any_ds_url   = run.get_param_value('wtb_1_any_ds_url', params)
            wtb_2_any_ds_path  = run.get_param_value('wtb_2_any_ds_path', params)
            wtb_3_any_ni_index = run.get_param_value('wtb_3_any_ni_index', params)

            # load source to dataframe
            source_df = src.web_table_anonymous_web(wtb_1_any_ds_url, wtb_2_any_ds_path, wtb_3_any_ni_index, is_debugging)

        elif cd_parameter_group == 'abs_sas_url_csv':

            # Get Ingestion specific parameters
            abs_1_csv_nm_account         = run.get_param_value('abs_1_csv_nm_account', params)
            abs_2_csv_nm_secret          = run.get_param_value('abs_2_csv_nm_secret', params)
            abs_3_csv_nm_container       = run.get_param_value('abs_3_csv_nm_container', params)
            abs_4_csv_ds_folderpath      = run.get_param_value('abs_4_csv_ds_folderpath', params)
            abs_5_csv_ds_filename        = run.get_param_value('abs_5_csv_ds_filename', params)
            abs_6_csv_nm_decode          = run.get_param_value('abs_6_csv_nm_decode', params)
            abs_7_csv_is_1st_header      = run.get_param_value('abs_7_csv_is_1st_header', params)
            abs_8_csv_cd_delimiter_value = run.get_param_value('abs_8_csv_cd_delimiter_value', params)
            abs_9_csv_cd_delimter_text   = run.get_param_value('abs_9_csv_cd_delimter_text', params)

            # load source to dataframe
            source_df = src.abs_sas_url_xls(abs_1_csv_nm_account, abs_2_csv_nm_secret, abs_3_csv_nm_container, abs_4_csv_ds_folderpath, abs_5_csv_ds_filename, abs_6_csv_nm_decode, abs_7_csv_is_1st_header, abs_8_csv_cd_delimiter_value, abs_9_csv_cd_delimter_text, is_debugging)

        elif cd_parameter_group == 'abs_sas_url_xls':

            # Get Ingestion specific parameters
            abs_1_xls_nm_account           = run.get_param_value('abs_1_xls_nm_account', params)
            abs_2_xls_nm_secret            = run.get_param_value('abs_2_xls_nm_secret', params)
            abs_3_xls_nm_container         = run.get_param_value('abs_3_xls_nm_container', params)
            abs_4_xls_ds_folderpath        = run.get_param_value('abs_4_xls_ds_folderpath', params)
            abs_5_xls_ds_filename          = run.get_param_value('abs_5_xls_ds_filename', params)
            abs_6_xls_nm_sheet             = run.get_param_value('abs_6_xls_nm_sheet', params)
            abs_7_xls_is_first_header      = run.get_param_value('abs_7_xls_is_first_header', params)
            abs_8_xls_cd_top_left_cell     = run.get_param_value('abs_8_xls_cd_top_left_cell', params)
            abs_9_xls_cd_bottom_right_cell = run.get_param_value('abs_9_xls_cd_bottom_right_cell', params)

            # load source to dataframe
            source_df = src.abs_sas_url_xls(abs_1_xls_nm_account, abs_2_xls_nm_secret, abs_3_xls_nm_container, abs_4_xls_ds_folderpath, abs_5_xls_ds_filename, abs_6_xls_nm_sheet, abs_7_xls_is_first_header, abs_8_xls_cd_top_left_cell, abs_9_xls_cd_bottom_right_cell, is_debugging)

        elif cd_parameter_group == 'sql_user_password':

            # Get Ingestion specific parameters
            sql_1_nm_server   = run.get_param_value('sql_1_nm_server', params)
            sql_2_nm_username = run.get_param_value('sql_2_nm_username', params)
            sql_3_nm_secret   = run.get_param_value('sql_3_nm_secret', params)
            sql_4_nm_database = run.get_param_value('sql_4_nm_database', params)
            sql_5_tx_query    = run.get_param_value('sql_5_tx_query', params)

            # load source to dataframe
            source_df = src.sql_user_password(sql_1_nm_server, sql_2_nm_username, sql_3_nm_secret, sql_4_nm_database, sql_5_tx_query, is_debugging)
            
        else:
            raise ValueError(f"Unsupported cd_parameter_group: {cd_parameter_group}")
        
        # Load "Source"-dataframe to "Temporal Staging Landing"-table.
        tgt.load_tsl(source_df, nm_tsl_schema, nm_tsl_table, is_debugging)
        
        # Start sql procedure specific for the "Target"-dataset on database side.
        run.usp_dataset_ingestion(nm_procedure, is_debugging)
    
    # If "Transformation" start the run and the procedure
    else:
        run.usp_dataset_transformation(nm_procedure, ds_external_reference_id)
        
    # All is well
    return result

# fetch all dataset tobe processed
todo = run.query(sa.target_db, "SELECT ni_process_group, id_dataset, is_ingestion, nm_procedure, nm_tsl_schema, nm_tsl_table, nm_tgt_schema, nm_tgt_table "\
                +"FROM dta.process_group "\
                +"WHERE nm_tgt_schema IN ('psa_references')--, psa_stocks', 'dta_dividend') "\
                +"ORDER BY ni_process_group ASC")

ni_index = 0
mx_index = todo.shape[0]

while (ni_index < mx_index):

    # External Reference ID
    ds_external_reference_id = 'python-'+todo.loc[ni_index]['id_dataset']+dt.now().strftime('%Y%m%d%H%M%S')

    # Parameter for "update_dataset"
    id_dataset    = todo.loc[ni_index]['id_dataset']  
    is_ingestion  = todo.loc[ni_index]['is_ingestion'] 
    nm_procedure  = todo.loc[ni_index]['nm_procedure'] 
    nm_tsl_schema = todo.loc[ni_index]['nm_tsl_schema'] 
    nm_tsl_table  = todo.loc[ni_index]['nm_tsl_table']
    nm_tgt_schema = todo.loc[ni_index]['nm_tgt_schema'] 
    nm_tgt_table  = todo.loc[ni_index]['nm_tgt_table']

    if (is_debugging == "1"): # Show what dataset is being processed
        print("--- " + ("Ingestion ----" if (is_ingestion == 1) else "Transformation ") + "--------------------------------------")
        print(f"ds_external_reference_id : '{ds_external_reference_id}'")
        print(f"id_dataset               : '{id_dataset}'")
        print(f"nm_tgt_schema            : '{nm_tgt_schema}'")
        print(f"nm_tgt_table             : '{nm_tgt_table}'")
        print(f"nm_procedure             : '{nm_procedure}'")  
        print(f"nm_tsl_schema            : '{nm_tsl_schema}'")
        print(f"nm_tsl_table             : '{nm_tsl_table}'")
        print("")

    # Update dataset "NVIDIA Corporation (NVDA)"
    result = update_dataset(ds_external_reference_id, id_dataset, is_ingestion, nm_procedure, nm_tsl_schema, nm_tsl_table)

    # Next Index
    ni_index += 1
 
print("all done")