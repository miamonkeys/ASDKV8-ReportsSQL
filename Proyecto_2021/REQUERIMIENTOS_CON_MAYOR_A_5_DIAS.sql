-- SE DECLARA UNA VARIABLE DE TIPO TABLA.
DECLARE @ESTADOS TABLE(ESTADOS VARCHAR(100));

-- SE LLENA LA TABLA CON LOS ESTADOS NO DESEADOS.
INSERT INTO @ESTADOS 
VALUES
    ('Solucionado'), ('Anulado'), ('Cerrado');

SELECT
	'REQ' AS 'TIPO DE CASO',
	T2.serv_id_by_project AS 'NRO DE CASO',
	T2.serv_subject AS 'ASUNTO',
	FORMAT(T2.serv_opened_date, 'dd/MM/yyyy HH:mm:ss') AS 'FECHA DE REGISTRO',
	T1.stat_name AS 'ESTADO',
	T3.UNAME AS 'CLIENTE',
	T4.GRP_NAME AS 'GRUPO',
	FORMAT(T2.serv_expired_date, 'dd/MM/yyyy HH:mm:ss') AS 'FECHA ESTIMADA DE SOLUCIÓN'
FROM
    AFW_STATUS AS T1
INNER JOIN 
    ASDK_SERVICE_CALL AS T2 
ON (T2.serv_status_id = T1.stat_id)
INNER JOIN 
    USUARIOS AS T3 
ON (T2.serv_customer_id = T3.CODUSUARIO)
INNER JOIN 
    GROUPHD AS T4 
ON (T2.serv_responsible_group_id = T4.GRP_ID)
INNER JOIN 
    ASDK_SERVICE AS T5 
ON (T5.FL_INT_SERVICE_ID = T2.serv_service_id)
WHERE
	T1.stat_name NOT IN (SELECT * FROM @ESTADOS)
    AND DATEDIFF(DAY, T2.serv_opened_date, GETDATE()) >= 5;
