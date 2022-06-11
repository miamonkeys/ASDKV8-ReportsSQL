SELECT
	T2.prob_id_by_project AS 'NRO DE CASO',
	T2.prob_subject AS 'ASUNTO',
	FORMAT(T2.prob_opened_date, 'dd/MM/yyyy HH:mm:ss') AS 'FECHA DE REGISTRO',
	T1.stat_name AS 'ESTADO',
	T3.UNAME AS 'USUARIO FINAL',
	T4.GRP_NAME AS 'GRUPO',
	FORMAT(T2.prob_expired_date, 'dd/MM/yyyy HH:mm:ss') AS 'FECHA ESTIMADA DE SOLUCIÓN'
FROM
    AFW_STATUS AS T1
INNER JOIN 
    ASDK_PROBLEM AS T2 
ON (T2.prob_status_id = T1.stat_id)
INNER JOIN 
    USUARIOS AS T3
ON (T2.prob_author = T3.CODUSUARIO)
INNER JOIN 
    GROUPHD AS T4 
ON (T2.prob_responsible_group_id = T4.GRP_ID)
INNER JOIN 
    ASDK_SERVICE AS T5 
ON (T5.FL_INT_SERVICE_ID = T2.prob_service_id)
