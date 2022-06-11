/*
    ESTADOS QUE TIENE UN INCIDENTE O
    UN REQUERIMIENTO
*/

SELECT 
    ESTADOS.stat_id AS 'ID_ESTADO',
    ESTADOS .stat_name AS 'NOMBRE DE ESTADO',
    CASE
        WHEN ESTADOS.stat_app_category = 1
        THEN 'INCIDENTE'
    ELSE
        'REQUERIMIENTO'
    END AS 'TIPO DE CASO'
FROM 
    AFW_STATUS AS ESTADOS
WHERE
    ESTADOS.stat_project = 1
    AND ESTADOS.stat_app_category IN 
    (
        SELECT
            CATEGORIA_APP.apct_id 
        FROM 
            AFW_APPLICATION_CATEGORY AS CATEGORIA_APP
        WHERE 
        CATEGORIA_APP.apct_description IN ('SERVICE CALL', 'INCIDENT')
    );
