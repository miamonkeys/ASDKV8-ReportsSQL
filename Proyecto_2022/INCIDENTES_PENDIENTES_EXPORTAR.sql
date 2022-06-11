/**
    REPORTE DE TODOS LOS INCIDENTES QUE NO
    TIENEN EL ESTADO ANULADO
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
    Ultima_nota_realizada,
    Fecha_de_la_ultima_nota,
    COMPANIA,
    CLIENTE,
    VIP,
    servicio,
    fabierto,
    fsolucionest,
    fsolucion ,
    fcierre,
    MOTIVOPROGRAMADO,
    FECHAPROGRAMADO,
    CATEGORIAFULL,
    GRUPOX,
    servicioid,
    CALENDARY,
    APLICAA,
    SUCURSAL,
    dbo.FUN_ASDK_TOTAL_TIME (servicioid, fsolucionest, fsolucion) dif01,
    dbo.FUN_ASDK_TOTAL_TIME (servicioid, fsolucion, fabierto) dif02,
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
        Select
            Usuarios.Uname ESPECIALISTA,
            'INCIDENTE' TIPO_DE_CASO,
            i.INCI_id_by_project NUMERO_DEL_CASO,
            GROUPHD.GRP_NAME GRUPO_ESPECIALISTA,
            I.inci_description_nohtml AS DESCRIPCION,
            (
                CASE
                    WHEN GROUPHD.GRP_NAME LIKE 'NIVEL 2_Gestion de Activos y Garantias%'
                    THEN 'N2_Gestion Acivos'
                ELSE
                    CASE
                        WHEN GROUPHD.GRP_NAME LIKE 'NIVEL 2_Gestión de Terceros%'
                        THEN 'N2_Gestión Terceros'
                    ELSE
                        CASE
                            WHEN GROUPHD.GRP_NAME LIKE 'NIVEL 2_Soporte Tecnico%' 
                            THEN REPLACE(GROUPHD.GRP_NAME, 'NIVEL 2_Soporte Tecnico', 'N2_Sop Tec')
                        ELSE
                            CASE
                                WHEN GROUPHD.GRP_NAME LIKE 'NIVEL 3_Administracion de Base de Datos%'
                                THEN 'N3_Administ BD'
                            ELSE
                                CASE
                                    WHEN GROUPHD.GRP_NAME LIKE 'NIVEL 3_Administracion de Respaldos%'
                                    THEN 'N3_Administ Respaldos'
                                ELSE
                                    CASE
                                        WHEN GROUPHD.GRP_NAME LIKE 'NIVEL 3_Aplicaciones_BANCO%'
                                        THEN REPLACE(GROUPHD.GRP_NAME, 'NIVEL 3_Aplicaciones_BANCO', 'N3_App_BCO')
                                    ELSE
                                        CASE
                                            WHEN GROUPHD.GRP_NAME LIKE 'NIVEL 3_Aplicaciones_TIENDA%' 
                                            THEN REPLACE(GROUPHD.GRP_NAME, 'NIVEL 3_Aplicaciones_TIENDA', 'N3_App_TDA')
                                        ELSE
                                            CASE
                                                WHEN GROUPHD.GRP_NAME LIKE 'NIVEL 3_Soporte de Aplicativos%'
                                                THEN REPLACE(GROUPHD.GRP_NAME, 'NIVEL 3_Soporte de Aplicativos', 'N3_Sop App')
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
            I.add_str_1 APLICAA,
            I.add_str_2 SUCURSAL,
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
            Afw_status.Stat_name ESTADO,
            ASDK_REASON.reas_description RAZON, --, SUBSTRING(i.INCI_description_nohtml,1,1000) DESCRIPCION_DEL_CASO
            (
                Select
                    top 1 
                    DBO.DESC_CASOS(hino_description)
                From
                    Asdk_hist_notes
                Where
                    hino_item_id = i.INCI_id
                    and hino_row_type = 1
                Order by
                    hino_created desc
            ) Ultima_nota_realizada,
            (
                Select
                    max(hino_created) FechaUlt
                From
                    Asdk_hist_notes
                Where
                    hino_item_id = i.INCI_id
                and hino_row_type = 1
            ) Fecha_de_la_ultima_nota,
            SITE.description Compania,
            UCli.Uname CLIENTE,
            (
                SELECT
                    USS_NAME
                FROM
                    USER_STATUS
                WHERE
                    USER_STATUS.USS_ID = UCLI.USS_ID
            ) VIP,
            ASDK_CATEGORY.FL_STR_HIERARCHY CATEGORIAFULL,
            i.INCI_opened_date fabierto,
            i.INCI_solution_real_date fsolucion,
            i.INCI_colsed_date fCIERRE,
            i.INCI_expired_date fsolucionest,
            ASDK_SERVICE.NAME servicio,
            ASDK_SERVICE.FL_INT_SERVICE_ID servicioid,
            ASDK_CALENDAR.CALENDAR_name CALENDARY,
            isnull(i.INCI_current_time,0) TIEMPO_DEL_CASO,
            (isnull(i.INCI_attention_time,0) + isnull(i.INCI_solution_time,0)) SLA_MINUTOS,
            l.NAME SLA_NOMBRE,
            (
                CASE
                    WHEN DATEDIFF(HH, i.INCI_OPENED_DATE, GETDATE()) < 4 
                    THEN 1
                ELSE 0
                END
            ) DE_00_04H,
            (
                CASE
                    WHEN DATEDIFF(HH, i.INCI_OPENED_DATE, GETDATE()) >= 4
                    AND DATEDIFF(HH, i.INCI_OPENED_DATE, GETDATE()) <24 
                    THEN 1
                ELSE 0
                END
            ) DE_04_24H,
            (
                CASE
                    WHEN DATEDIFF(HH, i.INCI_OPENED_DATE, GETDATE()) >= 24
                    AND DATEDIFF(HH, i.INCI_OPENED_DATE, GETDATE()) <72 THEN 1
                ELSE 0
                END
            ) DE_01_03D,
            (
                CASE
                    WHEN DATEDIFF(HH, i.INCI_OPENED_DATE, GETDATE()) >= 72
                    AND DATEDIFF(HH, i.INCI_OPENED_DATE, GETDATE()) <168 THEN 1
                ELSE 0
                END
            ) DE_03_07D,
            (
                CASE
                    WHEN DATEDIFF(HH, i.INCI_OPENED_DATE, GETDATE()) >= 168 
                    THEN 1
                ELSE 0
                END
            ) DE_07_XXD,
            --(CASE WHEN DATEDIFF(HH,i.INCI_OPENED_DATE,GETDATE()) < 4 THEN 1 ELSE 0 END) MENOS_4
            --(CASE WHEN DATEDIFF(HH,i.INCI_OPENED_DATE,GETDATE()) < 4 THEN 1 ELSE 0 END) MENOS_4
            (
                SELECT
                    FL_STR_FIELD_VALUE
                FROM
                    AFW_ADD_FIELDS_DATA
                WHERE
                    V_ASDK_INCIDENTS.inci_id = AFW_ADD_FIELDS_DATA.FL_INT_ID_CASO
                    AND FL_INT_ID_FIELD = 3
            ) AS MOTIVOPROGRAMADO,
            (
                SELECT
                    FL_DATE_FIELD_VALUE
                FROM
                    AFW_ADD_FIELDS_DATA
                WHERE
                    V_ASDK_INCIDENTS.inci_id = AFW_ADD_FIELDS_DATA.FL_INT_ID_CASO
                    AND FL_INT_ID_FIELD = 229
            ) AS FECHAPROGRAMADO
        From
            ASDK_INCIDENT I
            LEFT OUTER JOIN V_ASDK_INCIDENTS ON
                I.INCI_ID = V_ASDK_INCIDENTS.INCI_ID
            left outer join USUARIOS on
                i.INCI_responsible_id = Usuarios.Codusuario
            left outer join GROUPHD on
                i.INCI_responsible_group_id = GROUPHD.GRP_ID
            left outer join Usuarios UCli on
                i.INCI_customer_id = UCli.Codusuario
            left outer join AFW_STATUS on
                i.INCI_status_id = Afw_status.Stat_id
            left outer join SITE on
                UCli.SITEID = SITE.siteid
            left outer join ASDK_REASON on
                i.INCI_reason_id = ASDK_REASON.reas_id
            LEFT OUTER JOIN ASDK_SERVICE ON
                ASDK_SERVICE.FL_INT_SERVICE_ID = i.INCI_service_id
            left join ASDK_SLA l on
                l.SLA_ID = i.INCI_service_sla_id
            left outer join ASDK_CALENDAR ON
                ASDK_CALENDAR.CALENDAR_ID = ASDK_SERVICE.fl_int_calendar_id
            left outer join ASDK_CATEGORY on
                ASDK_CATEGORY.CTG_INDEX = i.INCI_category_id
        WHERE
            i.INCI_fl_int_project_id = 1
    ) TMP
WHERE
    fsolucion IS NULL
    and fcierre is null
    and estado not in ('ANULADO')
ORDER BY
    fabierto DESC