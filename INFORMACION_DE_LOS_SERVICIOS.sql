SELECT 
	A.NAME AS 'NOMBRE DE SERVIIO',
	A.DESCRIPCION AS 'DESCRIPCION DEL SERVICIO',
	B.CALENDAR_NAME AS 'CALENDARIO',
	B.CALENDAR_DESCRIPTION AS 'DESCRIPCION DEL CALENDARIO',
	C.impa_description AS 'IMPACTO',
	D.GRP_NAME AS 'GRUPO POR DEFECTO',
	E.NAME AS 'SLA POR DEFECTO',
	F.stat_name 'ESTADO DEL SERVICIO',
	G.UNAME AS 'CREADOR DEL SERVICIO'
FROM 
	ASDK_SERVICE AS A
INNER JOIN
	ASDK_CALENDAR AS B
ON (A.fl_int_calendar_id = B.CALENDAR_ID)
INNER JOIN 
	ASDK_IMPACT AS C
ON (C.impa_id = A.fl_int_impact_id)
INNER JOIN 
	GROUPHD AS D 
ON (D.GRP_ID = A.GRP_ID)
INNER JOIN
	ASDK_SLA AS E
ON (E.SLA_ID = A.FL_INT_SERVICE_ID)
INNER JOIN 
	AFW_STATUS AS F
ON (F.stat_id = A.serv_status_id)
INNER JOIN
	USUARIOS AS G
ON (G.CODUSUARIO = A.FL_INT_RESPONSABLE_ID);