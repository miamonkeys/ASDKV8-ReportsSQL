BEGIN
	UPDATE ASDK_SERVICE_CALL
	SET serv_description = CONCAT('ACTIVIDAD TI - ', serv_description)
	WHERE serv_id_by_project = 8536 
END;

BEGIN
	UPDATE ASDK_SERVICE_CALL
	SET serv_service_sla_id = 21
	WHERE serv_id_by_project = 8541
END;

BEGIN
	UPDATE ASDK_SERVICE_CALL
	SET serv_attention_real_date = '03-22-2022 08:09:18',
		serv_solution_real_date = '03-22-2022 08:12:19'
	WHERE serv_id_by_project = 8535
END;