SELECT F.GPART, V.BEGRU FROM CUSTOMER.FKKVKP F
JOIN (            SELECT            *                                                           --trying to find an email address
                                          
                                                                  FROM      (     SELECT            bpbase.PARTNER AS BP
                                                                                                      ,emladd.SMTP_ADDR AS EMAIL
                                                                                                      ,ROW_NUMBER() OVER (PARTITION BY bpbase.PARTNER ORDER BY bpbase.VALID_FROM DESC, bpbase.ADDRNUMBER ASC) AS ADDR_RANK
                                                                                                      
                                                                                    FROM        "COMMERCIAL"."ISU_BUT021_FS" bpbase
                                                                                    
                                                                                    INNER JOIN  "CUSTOMER"."ISU_ADR6" emladd
                                                                                    ON                bpbase.ADDRNUMBER = emladd.ADDRNUMBER
                                                                                    AND               UPPER(emladd.SMTP_ADDR) LIKE 'NONE@NONE%'
                                                                                    AND         bpbase.VALID_TO = 99991231235959
                                                                              ) x
                                                                  
                                                                  WHERE       ADDR_RANK = 1
                                                        )   emladd
                                          ON                F.GPART = emladd.BP
JOIN COMMERCIAL.EVER V
ON V.VKONTO = F.VKONT
AND V.AUSZDAT > CURRENT_DATE


