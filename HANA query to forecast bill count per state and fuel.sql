SELECT TO_DATE(QRY.TERMTDAT) AS BILLDATE, STATE.INSTALLATION_STATE, CASE WHEN V.SPARTE = '01' THEN 'ELEC' WHEN V.SPARTE = '02' THEN 'GAS' END AS FUEL, COUNT(E.ANLAGE) AS CNT
FROM COMMERCIAL.EANLH E 
JOIN COMMERCIAL.EVER V 
ON E.ANLAGE = V.ANLAGE 
JOIN (SELECT DISTINCT TERMSCHL,TERMTDAT FROM "OPEN"."TE418" WHERE TERMTDAT BETWEEN CURRENT_DATE AND ADD_DAYS(CURRENT_DATE,5)) QRY
ON QRY.TERMSCHL = E.ABLEINH
JOIN COMMERCIAL.MANUAL_CR_INSTALLATION_STATE STATE
ON STATE.KOFIZ = V.KOFIZ
WHERE E.BIS = '99991231' AND V.AUSZDAT = '99991231'
GROUP BY QRY.TERMTDAT, V.SPARTE,STATE.INSTALLATION_STATE ORDER BY QRY.TERMTDAT
