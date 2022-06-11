/*
    UNIÓN DE INCIDENTES_PENDIENTES_EXPORTAR.SQL
    CON REQUERIMIENTOS_PENDIENTES_EXPORTAR.SQL
*/

SELECT 
    GRUPO_ESPECIALISTA,
    NIVEL,
    ESPECIALISTA ESPECIALISTA_ACTUAL,
    TIPO_DE_CASO,
    NUMERO_DEL_CASO,
    DESCRIPCION,
    ESTADO ESTADO_ACTUAL,
    RAZON,
    ULTIMA_NOTA_REALIZADA,
    FECHA_DE_LA_ULTIMA_NOTA,
    COMPANIA,
    CLIENTE,
    VIP,
    SERVICIO,
    FABIERTO,
    FSOLUCIONEST,
    FSOLUCION,
    MOTIVOPROGRAMADO,
    FECHAPROGRAMADO,
    FCIERRE,
    CATEGORIAFULL,
    GRUPOX,
    SERVICIOID,
    CALENDARY,
    APLICAA,
    SUCURSAL,
    DBO.FUN_ASDK_TOTAL_TIME (SERVICIOID, FSOLUCIONEST, FSOLUCION) DIF01,
    DBO.FUN_ASDK_TOTAL_TIME (SERVICIOID, FSOLUCION, FABIERTO) DIF02,
    SLA_NOMBRE,
    SLA_MINUTOS,
    TIEMPO_DEL_CASO,
    (
        CASE
            WHEN SLA_MINUTOS > TIEMPO_DEL_CASO 
            THEN 'SI'
        ELSE 'NO'
        END
    ) CUMPLE_SLA,
    (
        CASE
            WHEN SLA_MINUTOS <> 0 
            THEN (TIEMPO_DEL_CASO / SLA_MINUTOS) * 100
        ELSE 100
        END
    ) PORCENT,
    DE_00_04H,
    DE_04_24H,
    DE_01_03D,
    DE_03_07D,
    DE_07_XXD
FROM
    (
        SELECT
            USUARIOS.UNAME ESPECIALISTA,
            'REQUERIMIENTO' TIPO_DE_CASO,
            I.SERV_ID_BY_PROJECT NUMERO_DEL_CASO,
            GROUPHD.GRP_NAME GRUPO_ESPECIALISTA,
            I.SERV_DESCRIPTION_NOHTML AS DESCRIPCION,
            (
                CASE
                    WHEN GROUPHD.GRP_NAME LIKE 'NIVEL 2_GESTION DE ACTIVOS Y GARANTIAS%' 
                    THEN 'N2_GESTION ACIVOS'
                ELSE
                    CASE
                        WHEN GROUPHD.GRP_NAME LIKE 'NIVEL 2_GESTIÓN DE TERCEROS%'
                        THEN 'N2_GESTIÓN TERCEROS'
                    ELSE
                        CASE
                            WHEN GROUPHD.GRP_NAME LIKE 'NIVEL 2_SOPORTE TECNICO%'
                            THEN REPLACE(GROUPHD.GRP_NAME, 'NIVEL 2_SOPORTE TECNICO', 'N2_SOP TEC')
                        ELSE
                            CASE
                                WHEN GROUPHD.GRP_NAME LIKE 'NIVEL 3_ADMINISTRACION DE BASE DE DATOS%' 
                                THEN 'N3_ADMINIST BD'
                            ELSE
                                CASE
                                    WHEN GROUPHD.GRP_NAME LIKE 'NIVEL 3_ADMINISTRACION DE RESPALDOS%' 
                                    THEN 'N3_ADMINIST RESPALDOS'
                                ELSE
                                    CASE
                                        WHEN GROUPHD.GRP_NAME LIKE 'NIVEL 3_APLICACIONES_BANCO%' 
                                        THEN REPLACE(GROUPHD.GRP_NAME, 'NIVEL 3_APLICACIONES_BANCO', 'N3_APP_BCO')
                                    ELSE
                                        CASE
                                            WHEN GROUPHD.GRP_NAME LIKE 'NIVEL 3_APLICACIONES_TIENDA%' 
                                            THEN REPLACE(GROUPHD.GRP_NAME, 'NIVEL 3_APLICACIONES_TIENDA', 'N3_APP_TDA')
                                        ELSE
                                            CASE
                                                WHEN GROUPHD.GRP_NAME LIKE 'NIVEL 3_SOPORTE DE APLICATIVOS%' 
                                                THEN REPLACE(GROUPHD.GRP_NAME, 'NIVEL 3_SOPORTE DE APLICATIVOS', 'N3_SOP APP')
                                            ELSE
                                                CASE
                                                    WHEN GROUPHD.GRP_NAME LIKE 'NIVEL 3%' 
                                                    THEN REPLACE(GROUPHD.GRP_NAME, 'NIVEL 3', 'N3')
                                                ELSE
                                                    GROUPHD.GRP_NAME
                                                END
                                            END
                                        END
                                    END
                                END
                            END
                        END
                    END
                END
            ) GRUPOX, --SELECT REPLACE('SFSDF SDF SDF SD','SD','XXX')
            I.ADD_STR_1 APLICAA,
            I.ADD_STR_2 SUCURSAL,
            (
                CASE
                    WHEN GROUPHD.GRP_NAME LIKE 'NIVEL 1%' 
                    THEN 'NIVEL1'
                ELSE
                    CASE
                        WHEN GROUPHD.GRP_NAME LIKE 'NIVEL 2%' 
                        THEN 'NIVEL2'
                    ELSE
                        CASE
                            WHEN GROUPHD.GRP_NAME LIKE 'NIVEL 3%' THEN 'NIVEL3'
                        ELSE
                            GROUPHD.GRP_NAME
                        END
                    END
                END
            ) NIVEL,
            AFW_STATUS.STAT_NAME ESTADO,
            ASDK_REASON.REAS_DESCRIPTION RAZON, --, SUBSTRING(I.SERV_DESCRIPTION_NOHTML,1,1000) DESCRIPCION_DEL_CASO
            (
                SELECT
                    TOP 1
                    DBO.DESC_CASOS(HINO_DESCRIPTION)
                FROM
                    ASDK_HIST_NOTES
                WHERE
                    HINO_ITEM_ID = I.SERV_ID
                    AND HINO_ROW_TYPE = 4
                ORDER BY
                    HINO_CREATED DESC
            ) ULTIMA_NOTA_REALIZADA,
            (
                SELECT
                    MAX(HINO_CREATED) FECHAULT
                FROM
                    ASDK_HIST_NOTES
                WHERE
                    HINO_ITEM_ID = I.SERV_ID
                    AND HINO_ROW_TYPE = 4
            ) FECHA_DE_LA_ULTIMA_NOTA,
            SITE.DESCRIPTION COMPANIA,
            UCLI.UNAME CLIENTE,
            (
                SELECT
                    USS_NAME
                FROM
                    USER_STATUS
                WHERE
                    USER_STATUS.USS_ID = UCLI.USS_ID
            ) VIP,
            ASDK_CATEGORY.FL_STR_HIERARCHY CATEGORIAFULL,
            I.SERV_OPENED_DATE FABIERTO,
            I.SERV_SOLUTION_REAL_DATE FSOLUCION,
            I.SERV_COLSED_DATE FCIERRE,
            I.SERV_EXPIRED_DATE FSOLUCIONEST,
            ASDK_SERVICE.NAME SERVICIO,
            ASDK_SERVICE.FL_INT_SERVICE_ID SERVICIOID,
            ASDK_CALENDAR.CALENDAR_NAME CALENDARY,
            ISNULL(I.SERV_CURRENT_TIME,0) TIEMPO_DEL_CASO,
            (ISNULL(I.SERV_ATTENTION_TIME,0) + ISNULL(I.SERV_SOLUTION_TIME,0)) SLA_MINUTOS,
            L.NAME SLA_NOMBRE,
            (
                CASE
                    WHEN DATEDIFF(HH, I.SERV_OPENED_DATE, GETDATE()) < 4 
                    THEN 1
                ELSE 0
                END
            ) DE_00_04H,
            (
                CASE
                    WHEN DATEDIFF(HH, I.SERV_OPENED_DATE, GETDATE()) >= 4
                    AND DATEDIFF(HH, I.SERV_OPENED_DATE, GETDATE()) <24 
                    THEN 1
                ELSE 0
                END
            ) DE_04_24H,
            (
                CASE
                    WHEN DATEDIFF(HH, I.SERV_OPENED_DATE, GETDATE()) >= 24
                    AND DATEDIFF(HH, I.SERV_OPENED_DATE, GETDATE()) <72 
                    THEN 1
                ELSE 0
                END
            ) DE_01_03D,
            (
                CASE
                    WHEN DATEDIFF(HH, I.SERV_OPENED_DATE, GETDATE()) >= 72
                    AND DATEDIFF(HH, I.SERV_OPENED_DATE, GETDATE()) <168 
                    THEN 1
                ELSE 0
                END
            ) DE_03_07D,
            (
                CASE
                    WHEN DATEDIFF(HH, I.SERV_OPENED_DATE, GETDATE()) >= 168 
                    THEN 1
                ELSE 0
                END
            ) DE_07_XXD,
            --(CASE WHEN DATEDIFF(HH,I.SERV_OPENED_DATE,GETDATE()) < 4 THEN 1 ELSE 0 END) MENOS_4
            --(CASE WHEN DATEDIFF(HH,I.SERV_OPENED_DATE,GETDATE()) < 4 THEN 1 ELSE 0 END) MENOS_4
            (
                SELECT
                    FL_STR_FIELD_VALUE
                FROM
                    AFW_ADD_FIELDS_DATA
                WHERE
                    V_ASDK_SERVICE_CALL.SERV_ID = AFW_ADD_FIELDS_DATA.FL_INT_ID_CASO
                    AND FL_INT_ID_FIELD = 233
            ) MOTIVOPROGRAMADO,
            (
                SELECT
                    FL_DATE_FIELD_VALUE
                FROM
                    AFW_ADD_FIELDS_DATA
                WHERE
                    V_ASDK_SERVICE_CALL.SERV_ID = AFW_ADD_FIELDS_DATA.FL_INT_ID_CASO
                    AND FL_INT_ID_FIELD = 231
            ) FECHAPROGRAMADO
        FROM
            ASDK_SERVICE_CALL I
            LEFT OUTER JOIN V_ASDK_SERVICE_CALL ON
                V_ASDK_SERVICE_CALL.SERV_ID = I.SERV_ID
            LEFT OUTER JOIN USUARIOS ON
                I.SERV_RESPONSIBLE_ID = USUARIOS.CODUSUARIO
            LEFT OUTER JOIN GROUPHD ON
                I.SERV_RESPONSIBLE_GROUP_ID = GROUPHD.GRP_ID
            LEFT OUTER JOIN USUARIOS UCLI ON
                I.SERV_CUSTOMER_ID = UCLI.CODUSUARIO
            LEFT OUTER JOIN AFW_STATUS ON
                I.SERV_STATUS_ID = AFW_STATUS.STAT_ID
            LEFT OUTER JOIN SITE ON
                UCLI.SITEID = SITE.SITEID
            LEFT OUTER JOIN ASDK_REASON ON
                I.SERV_REASON_ID = ASDK_REASON.REAS_ID
            LEFT OUTER JOIN ASDK_SERVICE ON
                ASDK_SERVICE.FL_INT_SERVICE_ID = I.SERV_SERVICE_ID
            LEFT JOIN ASDK_SLA L ON
                L.SLA_ID = I.SERV_SERVICE_SLA_ID
            LEFT OUTER JOIN ASDK_CALENDAR ON
                ASDK_CALENDAR.CALENDAR_ID = ASDK_SERVICE.FL_INT_CALENDAR_ID
            LEFT OUTER JOIN ASDK_CATEGORY ON
                ASDK_CATEGORY.CTG_INDEX = I.SERV_CATEGORY_ID
        WHERE
            I.SERV_FL_INT_PROJECT_ID = 1

        UNION

        SELECT
            USUARIOS.UNAME ESPECIALISTA,
            'INCIDENTE' TIPO_DE_CASO,
            I.INCI_ID_BY_PROJECT NUMERO_DEL_CASO,
            GROUPHD.GRP_NAME GRUPO_ESPECIALISTA,
            I.INCI_DESCRIPTION_NOHTML AS DESCRIPCION,
            (
                CASE
                    WHEN GROUPHD.GRP_NAME LIKE 'NIVEL 2_GESTION DE ACTIVOS Y GARANTIAS%'
                    THEN 'N2_GESTION ACIVOS'
                ELSE
                    CASE
                        WHEN GROUPHD.GRP_NAME LIKE 'NIVEL 2_GESTIÓN DE TERCEROS%'
                        THEN 'N2_GESTIÓN TERCEROS'
                    ELSE
                        CASE
                            WHEN GROUPHD.GRP_NAME LIKE 'NIVEL 2_SOPORTE TECNICO%' 
                            THEN REPLACE(GROUPHD.GRP_NAME, 'NIVEL 2_SOPORTE TECNICO', 'N2_SOP TEC')
                        ELSE
                            CASE
                                WHEN GROUPHD.GRP_NAME LIKE 'NIVEL 3_ADMINISTRACION DE BASE DE DATOS%'
                                THEN 'N3_ADMINIST BD'
                            ELSE
                                CASE
                                    WHEN GROUPHD.GRP_NAME LIKE 'NIVEL 3_ADMINISTRACION DE RESPALDOS%'
                                    THEN 'N3_ADMINIST RESPALDOS'
                                ELSE
                                    CASE
                                        WHEN GROUPHD.GRP_NAME LIKE 'NIVEL 3_APLICACIONES_BANCO%'
                                        THEN REPLACE(GROUPHD.GRP_NAME, 'NIVEL 3_APLICACIONES_BANCO', 'N3_APP_BCO')
                                    ELSE
                                        CASE
                                            WHEN GROUPHD.GRP_NAME LIKE 'NIVEL 3_APLICACIONES_TIENDA%' 
                                            THEN REPLACE(GROUPHD.GRP_NAME, 'NIVEL 3_APLICACIONES_TIENDA', 'N3_APP_TDA')
                                        ELSE
                                            CASE
                                                WHEN GROUPHD.GRP_NAME LIKE 'NIVEL 3_SOPORTE DE APLICATIVOS%'
                                                THEN REPLACE(GROUPHD.GRP_NAME, 'NIVEL 3_SOPORTE DE APLICATIVOS', 'N3_SOP APP')
                                            ELSE
                                                CASE
                                                    WHEN GROUPHD.GRP_NAME LIKE 'NIVEL 3%'
                                                    THEN REPLACE(GROUPHD.GRP_NAME, 'NIVEL 3', 'N3')
                                                ELSE
                                                    GROUPHD.GRP_NAME
                                                END
                                            END
                                        END
                                    END
                                END
                            END
                        END
                    END
                END
            ) GRUPOX, --SELECT REPLACE('SFSDF SDF SDF SD','SD','XXX')
            I.ADD_STR_1 APLICAA,
            I.ADD_STR_2 SUCURSAL,
            (
                CASE
                    WHEN GROUPHD.GRP_NAME LIKE 'NIVEL 1%' 
                    THEN 'NIVEL1'
                ELSE
                    CASE
                        WHEN GROUPHD.GRP_NAME LIKE 'NIVEL 2%' 
                        THEN 'NIVEL2'
                    ELSE
                        CASE
                            WHEN GROUPHD.GRP_NAME LIKE 'NIVEL 3%' 
                            THEN 'NIVEL3'
                        ELSE
                            GROUPHD.GRP_NAME
                        END
                    END
                END
            ) NIVEL,
            AFW_STATUS.STAT_NAME ESTADO,
            ASDK_REASON.REAS_DESCRIPTION RAZON, --, SUBSTRING(I.INCI_DESCRIPTION_NOHTML,1,1000) DESCRIPCION_DEL_CASO
            (
                SELECT
                    TOP 1 
                    DBO.DESC_CASOS(HINO_DESCRIPTION)
                FROM
                    ASDK_HIST_NOTES
                WHERE
                    HINO_ITEM_ID = I.INCI_ID
                    AND HINO_ROW_TYPE = 1
                ORDER BY
                    HINO_CREATED DESC
            ) ULTIMA_NOTA_REALIZADA,
            (
                SELECT
                    MAX(HINO_CREATED) FECHAULT
                FROM
                    ASDK_HIST_NOTES
                WHERE
                    HINO_ITEM_ID = I.INCI_ID
                AND HINO_ROW_TYPE = 1
            ) FECHA_DE_LA_ULTIMA_NOTA,
            SITE.DESCRIPTION COMPANIA,
            UCLI.UNAME CLIENTE,
            (
                SELECT
                    USS_NAME
                FROM
                    USER_STATUS
                WHERE
                    USER_STATUS.USS_ID = UCLI.USS_ID
            ) VIP,
            ASDK_CATEGORY.FL_STR_HIERARCHY CATEGORIAFULL,
            I.INCI_OPENED_DATE FABIERTO,
            I.INCI_SOLUTION_REAL_DATE FSOLUCION,
            I.INCI_COLSED_DATE FCIERRE,
            I.INCI_EXPIRED_DATE FSOLUCIONEST,
            ASDK_SERVICE.NAME SERVICIO,
            ASDK_SERVICE.FL_INT_SERVICE_ID SERVICIOID,
            ASDK_CALENDAR.CALENDAR_NAME CALENDARY,
            ISNULL(I.INCI_CURRENT_TIME,0) TIEMPO_DEL_CASO,
            (ISNULL(I.INCI_ATTENTION_TIME,0) + ISNULL(I.INCI_SOLUTION_TIME,0)) SLA_MINUTOS,
            L.NAME SLA_NOMBRE,
            (
                CASE
                    WHEN DATEDIFF(HH, I.INCI_OPENED_DATE, GETDATE()) < 4 
                    THEN 1
                ELSE 0
                END
            ) DE_00_04H,
            (
                CASE
                    WHEN DATEDIFF(HH, I.INCI_OPENED_DATE, GETDATE()) >= 4
                    AND DATEDIFF(HH, I.INCI_OPENED_DATE, GETDATE()) <24 
                    THEN 1
                ELSE 0
                END
            ) DE_04_24H,
            (
                CASE
                    WHEN DATEDIFF(HH, I.INCI_OPENED_DATE, GETDATE()) >= 24
                    AND DATEDIFF(HH, I.INCI_OPENED_DATE, GETDATE()) <72 THEN 1
                ELSE 0
                END
            ) DE_01_03D,
            (
                CASE
                    WHEN DATEDIFF(HH, I.INCI_OPENED_DATE, GETDATE()) >= 72
                    AND DATEDIFF(HH, I.INCI_OPENED_DATE, GETDATE()) <168 THEN 1
                ELSE 0
                END
            ) DE_03_07D,
            (
                CASE
                    WHEN DATEDIFF(HH, I.INCI_OPENED_DATE, GETDATE()) >= 168 
                    THEN 1
                ELSE 0
                END
            ) DE_07_XXD,
            --(CASE WHEN DATEDIFF(HH,I.INCI_OPENED_DATE,GETDATE()) < 4 THEN 1 ELSE 0 END) MENOS_4
            --(CASE WHEN DATEDIFF(HH,I.INCI_OPENED_DATE,GETDATE()) < 4 THEN 1 ELSE 0 END) MENOS_4
            (
                SELECT
                    FL_STR_FIELD_VALUE
                FROM
                    AFW_ADD_FIELDS_DATA
                WHERE
                    V_ASDK_INCIDENTS.INCI_ID = AFW_ADD_FIELDS_DATA.FL_INT_ID_CASO
                    AND FL_INT_ID_FIELD = 3
            ) AS MOTIVOPROGRAMADO,
            (
                SELECT
                    FL_DATE_FIELD_VALUE
                FROM
                    AFW_ADD_FIELDS_DATA
                WHERE
                    V_ASDK_INCIDENTS.INCI_ID = AFW_ADD_FIELDS_DATA.FL_INT_ID_CASO
                    AND FL_INT_ID_FIELD = 229
            ) AS FECHAPROGRAMADO
        FROM
            ASDK_INCIDENT I
            LEFT OUTER JOIN V_ASDK_INCIDENTS ON
                I.INCI_ID = V_ASDK_INCIDENTS.INCI_ID
            LEFT OUTER JOIN USUARIOS ON
                I.INCI_RESPONSIBLE_ID = USUARIOS.CODUSUARIO
            LEFT OUTER JOIN GROUPHD ON
                I.INCI_RESPONSIBLE_GROUP_ID = GROUPHD.GRP_ID
            LEFT OUTER JOIN USUARIOS UCLI ON
                I.INCI_CUSTOMER_ID = UCLI.CODUSUARIO
            LEFT OUTER JOIN AFW_STATUS ON
                I.INCI_STATUS_ID = AFW_STATUS.STAT_ID
            LEFT OUTER JOIN SITE ON
                UCLI.SITEID = SITE.SITEID
            LEFT OUTER JOIN ASDK_REASON ON
                I.INCI_REASON_ID = ASDK_REASON.REAS_ID
            LEFT OUTER JOIN ASDK_SERVICE ON
                ASDK_SERVICE.FL_INT_SERVICE_ID = I.INCI_SERVICE_ID
            LEFT JOIN ASDK_SLA L ON
                L.SLA_ID = I.INCI_SERVICE_SLA_ID
            LEFT OUTER JOIN ASDK_CALENDAR ON
                ASDK_CALENDAR.CALENDAR_ID = ASDK_SERVICE.FL_INT_CALENDAR_ID
            LEFT OUTER JOIN ASDK_CATEGORY ON
                ASDK_CATEGORY.CTG_INDEX = I.INCI_CATEGORY_ID
        WHERE
            I.inci_fl_int_project_id = 1
    ) TMP
WHERE 
    FSOLUCION IS NULL
    AND FCIERRE IS NULL
    AND ESTADO NOT IN ('ANULADO')
    AND FABIERTO BETWEEN '2022-03-01' AND GETDATE()
ORDER BY
    FABIERTO DESC;
