SELECT
    B.ret_description AS 'REPORTADO EN:',
    COUNT(A.inci_id_by_project) AS 'CANTIDAD'
FROM
    ASDK_INCIDENT AS A
INNER JOIN
    REGISTRY_TYPE AS B
ON (A.inci_registry_type_id	= B.ret_id)
GROUP BY 
    B.ret_description
ORDER BY
    'CANTIDAD' DESC;