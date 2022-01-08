--INCIDENTES		
SELECT
	T3.inci_id_by_project AS 'ID',
	T3.inci_composed_id AS 'ID COMPUESTO',
	CONVERT(VARCHAR, T3.inci_opened_date, 120) AS 'FECHA DE APERTURA',
	T5.CONCAT_CAT AS 'CATEGORIA',
	T4.stat_name AS 'ESTADO ACTUAL',
	T3.inci_description AS 'DESCRIPCIÓN'
FROM 
	ASDK_HIST_MODIFY AS T1
INNER JOIN 
	ASDK_ACTION_HIST AS T2
ON 
    T1.himo_action_hist_id = T2.achi_id
INNER JOIN 
	ASDK_INCIDENT AS T3
ON
    T3.inci_id = T2.achi_item_id
 INNER JOIN
 	AFW_STATUS AS T4
 ON
 	T3.inci_status_id = T4.stat_id
 INNER JOIN
 	ALL_CATEGORY AS T5
 ON
 	T5.ID = T3.inci_category_id
WHERE 
	T1.himo_field_modified = 'REASON' AND 
	T1.himo_new_value = '16'
ORDER BY
	T3.inci_opened_date ASC;