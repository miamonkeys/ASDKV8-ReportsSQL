/*
    HISTORICO.
    INCIDENTES Y REQUERIMIENTOS SOLUCIONADOS CON SUS GRUPOS
*/

SELECT
	A.GRP_NAME AS 'GRUPO',
	B.inci_composed_id AS 'CASO',
	C.stat_name  AS 'ESTADO ACTUAL DEL TICKET',
	FORMAT(B.inci_solution_real_date, 'dd/MM/yyyy') AS 'FECHA DE SOLUCIÓN',
	'INCIDENTE' AS 'TIPO'
FROM
	AFW_STATUS AS C
INNER JOIN
	ASDK_INCIDENT AS B
ON
	(C.stat_id = B.inci_status_id)
INNER JOIN 
	GROUPHD AS A 
ON 
	(B.inci_responsible_group_id = A.GRP_ID)
	
UNION

SELECT
	A.GRP_NAME AS 'GRUPO',
	B.serv_composed_id AS 'NRO DE CASO',
	C.stat_name  AS 'ESTADO ACTUAL DEL TICKET',
	FORMAT(B.serv_solution_real_date, 'dd/MM/yyyy') AS 'FECHA DE SOLUCIÓN',
	'REQUERIMIENTO' AS 'TIPO'
FROM
	AFW_STATUS AS C
INNER JOIN
	ASDK_SERVICE_CALL AS B
ON
	(C.stat_id = B.serv_status_id)
INNER JOIN 
	GROUPHD AS A 
ON 
	(B.serv_responsible_group_id = A.GRP_ID)