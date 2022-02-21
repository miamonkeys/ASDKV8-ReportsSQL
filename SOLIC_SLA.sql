SELECT
	A.serv_id AS 'ID',
	A.serv_id_by_project AS 'ID GLOBAL',
	FORMAT(A.serv_opened_date, 'dd/MM/yyyy hh:mm:ss') AS 'FECHA DE APERTURA',
	FORMAT(A.serv_attention_esti_date, 'dd/MM/yyyy hh:mm:ss') AS 'FECHA DE ATENCIÓN ESTIMADA',
	FORMAT(A.serv_attention_real_date, 'dd/MM/yyyy hh:mm:ss') AS 'FECHA DE ATENCIÓN REAL',
	FORMAT(A.serv_expired_date, 'dd/MM/yyyy hh:mm:ss') AS 'FECHA DE SOLUCIÓN ESTIMADA',
	FORMAT(A.serv_solution_real_date, 'dd/MM/yyyy hh:mm:ss') AS 'FECHA DE SOLUCIÓN REAL',
	FORMAT(A.serv_colsed_date, 'dd/MM/yyyy hh:mm:ss') AS 'FECHA DE CIERRE',
	B.NAME AS 'NOMBRE SLA',
	B.fl_int_times_at3 AS 'TIEMPO DE ATENCIÓN EN MINUTOS',
	B.fl_int_times_so3 AS 'TIEMPO DE SOLUCIÓN EN MINUTOS'
FROM 
	ASDK_SERVICE_CALL AS A
INNER JOIN 
	ASDK_SLA AS B ON A.serv_service_sla_id = B.SLA_ID 
ORDER BY 
	A.serv_opened_date DESC;