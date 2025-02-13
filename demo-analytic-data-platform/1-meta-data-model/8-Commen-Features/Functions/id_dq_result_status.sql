CREATE FUNCTION gnc_commen.id_dq_result_status (@ip_fn_dq_result_status NVARCHAR(128) ) RETURNS CHAR(32) AS BEGIN
  
  /* ----------------------------------------------------------------------- */
  /* This function will return "id_dq_result_status" based on the input of   */
  /* "@ip_fn_dq_result_status".                                              */ 
  /* ----------------------------------------------------------------------- */
  
  RETURN (SELECT id_dq_result_status FROM srd.dq_result_status WHERE meta_is_active = 1 AND fn_dq_result_status = @ip_fn_dq_result_status);

END
GO
