--VISTA DONDE ESTAN LOS INCIDENTES Y REQUERIMIENTOS (DEL DIA) AGRUPADOS POR GRUPO RESOLUTOR Y CANTIDAD
--REPORTE DIARIO

CREATE VIEW VISTA_GRU_INC_REQ
AS
(
	SELECT 
		A.GRUPO AS 'GRUPO', 
		COUNT(A.CASO) 'Tickets del día'
	FROM 
		(
		
		--GRUPOS RESOLUTORES
		SELECT 
			A.GRP_NAME AS 'GRUPO', 
			NULL AS 'CASO' 
		FROM 
			GROUPHD AS A
		WHERE
			A.GRP_NAME NOT IN ('TI FONAFE', 'Proveedores','Aprobadores')
			
		UNION
		
		--INCIDENTES
		SELECT
			A.GRP_NAME AS 'GRUPO',
			B.inci_composed_id AS 'CASO'
		FROM
			ASDK_INCIDENT AS B
		RIGHT JOIN GROUPHD AS A ON
			(B.inci_responsible_group_id = A.GRP_ID)
		WHERE
			A.GRP_NAME NOT IN ('TI FONAFE', 'Proveedores','Aprobadores')
			AND FORMAT(B.inci_opened_date, 'dd/MM/yyyy') = FORMAT(GETDATE(), 'dd/MM/yyyy')
			--NO INCLUIR LOS INCIDENTES EN ESTADO ANULADO
			AND B.inci_status_id NOT IN (5)
			
		UNION
		
		--REQUERIMIENTOS DE SERVICIO
		SELECT
			A.GRP_NAME AS 'GRUPO',
			B.serv_composed_id AS 'NRO DE CASO'
		FROM
			ASDK_SERVICE_CALL AS B
		INNER JOIN GROUPHD AS A ON
			(B.serv_responsible_group_id = A.GRP_ID)
		WHERE
			A.GRP_NAME NOT IN ('TI FONAFE', 'Proveedores','Aprobadores') 
			AND FORMAT(B.serv_opened_date, 'dd/MM/yyyy') = FORMAT(GETDATE(), 'dd/MM/yyyy')
			--NO INCLUIR LAS SOLICITUDES EN ESTADO ANULADO
			AND B.serv_status_id NOT IN (12)
		) AS A
	GROUP BY A.GRUPO
)