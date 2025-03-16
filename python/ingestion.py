import sys
sys.path.append('modules')

# Import Custom Modules
import modules.source as src
import modules.target as tgt
import modules.run    as run

is_debugging = "1"

def update_dataset(id_dataset):
    
    # Local Vairables
    result = 'OK'

    # Get the parameters
    params = run.get_parameters(id_dataset)
    
    # Target Schema/Table
    nm_target_schema   = params.loc[0]['nm_target_schema']
    nm_target_table    = params.loc[0]['nm_target_table']
    cd_parameter_group = params.loc[0]['cd_parameter_group']

    # Switch for cd_parameter_group
    if cd_parameter_group == 'web_table_anonymous_web':

        # Get Ingestion specific parameters
        wtb_1_any_ds_url   = params.loc[params['nm_parameter_value'] == 'wtb_1_any_ds_url'].values[0][5]
        wtb_2_any_ds_path  = params.loc[params['nm_parameter_value'] == 'wtb_2_any_ds_path'].values[0][5]
        wtb_3_any_ni_index = params.loc[params['nm_parameter_value'] == 'wtb_3_any_ni_index'].values[0][5]

        # load source to dataframe
        source_df = src.web_table_anonymous_web(wtb_1_any_ds_url, wtb_2_any_ds_path, wtb_3_any_ni_index, is_debugging)

    elif cd_parameter_group == 'abs_sas_url_xls':

        # Get Ingestion specific parameters
        abs_1_csv_nm_account         = params.loc[params['nm_parameter_value']=='abs_1_csv_nm_account'].values[0][5]
        abs_2_csv_nm_secret          = params.loc[params['nm_parameter_value']=='abs_2_csv_nm_secret'].values[0][5]
        abs_3_csv_nm_container       = params.loc[params['nm_parameter_value']=='abs_3_csv_nm_container'].values[0][5]
        abs_4_csv_ds_folderpath      = params.loc[params['nm_parameter_value']=='abs_4_csv_ds_folderpath'].values[0][5]
        abs_5_csv_ds_filename        = params.loc[params['nm_parameter_value']=='abs_5_csv_ds_filename'].values[0][5]
        abs_6_csv_nm_decode          = params.loc[params['nm_parameter_value']=='abs_6_csv_nm_decode'].values[0][5]
        abs_7_csv_is_1st_header      = params.loc[params['nm_parameter_value']=='abs_7_csv_is_1st_header'].values[0][5]
        abs_8_csv_cd_delimiter_value = params.loc[params['nm_parameter_value']=='abs_8_csv_cd_delimiter_value'].values[0][5]
        abs_9_csv_cd_delimter_text   = params.loc[params['nm_parameter_value']=='abs_9_csv_cd_delimter_text'].values[0][5]

        # load source to dataframe
        source_df = src.abs_sas_url_xls(abs_1_csv_nm_account, abs_2_csv_nm_secret, abs_3_csv_nm_container, abs_4_csv_ds_folderpath, abs_5_csv_ds_filename, abs_6_csv_nm_decode, abs_7_csv_is_1st_header, abs_8_csv_cd_delimiter_value, abs_9_csv_cd_delimter_text, is_debugging)

    elif cd_parameter_group == 'abs_sas_url_csv':

        # Get Ingestion specific parameters
        abs_1_xls_nm_account           = params.loc[params['nm_parameter_value']=='abs_1_xls_nm_account'].values[0][5]
        abs_2_xls_nm_secret            = params.loc[params['nm_parameter_value']=='abs_2_xls_nm_secret'].values[0][5]
        abs_3_xls_nm_container         = params.loc[params['nm_parameter_value']=='abs_3_xls_nm_container'].values[0][5]
        abs_4_xls_ds_folderpath        = params.loc[params['nm_parameter_value']=='abs_4_xls_ds_folderpath'].values[0][5]
        abs_5_xls_ds_filename          = params.loc[params['nm_parameter_value']=='abs_5_xls_ds_filename'].values[0][5]
        abs_6_xls_nm_sheet             = params.loc[params['nm_parameter_value']=='abs_6_xls_nm_sheet'].values[0][5]
        abs_7_xls_is_first_header      = params.loc[params['nm_parameter_value']=='abs_7_xls_is_first_header'].values[0][5]
        abs_8_xls_cd_top_left_cell     = params.loc[params['nm_parameter_value']=='abs_8_xls_cd_top_left_cell'].values[0][5]
        abs_9_xls_cd_bottom_right_cell = params.loc[params['nm_parameter_value']=='abs_9_xls_cd_bottom_right_cell'].values[0][5]

        # load source to dataframe
        source_df = src.abs_sas_url_csv(abs_1_xls_nm_account, abs_2_xls_nm_secret, abs_3_xls_nm_container, abs_4_xls_ds_folderpath, abs_5_xls_ds_filename, abs_6_xls_nm_sheet, abs_7_xls_is_first_header, abs_8_xls_cd_top_left_cell, abs_9_xls_cd_bottom_right_cell, is_debugging)
        
    else:
        raise ValueError(f"Unsupported cd_parameter_group: {cd_parameter_group}")
        
    # Load "Source"-dataframe to "Temporal Staging Landing"-table.
    tgt.load_tsl(source_df, nm_target_schema, nm_target_table, is_debugging)
    
    # Start sql procedure to process data on database side.
    # ...

    # All is well
    return result


result = update_dataset("07090900040c09010908080200140a03")


 
print("all done")