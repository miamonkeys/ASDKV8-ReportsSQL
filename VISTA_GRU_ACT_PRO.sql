--VISTA DONDE ESTAN LAS ACTIVIDADES AGRUPADOS POR GRUPO RESOLUTOR Y CANTIDAD
--REPORTE HISTORICO

CREATE VIEW VISTA_GRU_ACT_PRO
AS
(
	SELECT 
		A.GRUPO AS 'GRUPO',
		COUNT(A.ID) AS 'Act/Proy (Pendientes)'
	FROM
	(
		--GRUPOS RESOLUTORES
		SELECT 
			A.GRP_NAME AS 'GRUPO', 
			NULL AS 'ID' 
		FROM 
			GROUPHD AS A
		WHERE
			A.GRP_NAME NOT IN ('TI FONAFE', 'Proveedores','Aprobadores')
		
		UNION
		
		-- SOLICITUDES
		SELECT
			A.GRP_NAME AS 'GRUPO',
			B.serv_composed_id AS 'ID'
		FROM
			GROUPHD AS A
			INNER JOIN ASDK_SERVICE_CALL AS B
			ON (B.serv_responsible_group_id = A.GRP_ID)
			INNER JOIN ASDK_SERVICE AS C
			ON (B.serv_service_id = C.FL_INT_SERVICE_ID)
			INNER JOIN (SELECT AFW_STATUS.stat_id, AFW_STATUS.stat_name FROM AFW_STATUS WHERE AFW_STATUS.stat_app_category = 4) AS D
			ON (D.stat_id = B.serv_status_id)
		WHERE
			--NO SE TOMAN EN CUENTA LOS TK CON LOS SIGUIENTES ESTADOS
			D.stat_name NOT IN ('Solucionado', 'Cerrado', 'Anulado') AND
			C.NAME = 'Desarrollo de aplicaciones internas y corporativo'
		
		UNION
		
		--INCIDENTES
		SELECT
			Y.GRP_NAME AS 'GRUPO',
			X.inci_composed_id AS 'ID'
		FROM
			GROUPHD AS Y
			INNER JOIN ASDK_INCIDENT AS X
			ON (X.inci_responsible_group_id = Y.GRP_ID)
			INNER JOIN ASDK_SERVICE AS T
			ON (X.inci_service_id = T.FL_INT_SERVICE_ID)
			INNER JOIN (SELECT AFW_STATUS.stat_id, AFW_STATUS.stat_name FROM AFW_STATUS WHERE AFW_STATUS.stat_app_category = 1) AS R
			ON (R.stat_id = X.inci_status_id)
		WHERE
			--NO SE TOMAN EN CUENTA LOS TK CON LOS SIGUIENTES ESTADOS
			R.stat_name NOT IN ('Solucionado', 'Cerrado', 'Anulado') AND
			T.NAME = 'Desarrollo de aplicaciones internas y corporativo'
	) AS A
	GROUP BY A.GRUPO
)