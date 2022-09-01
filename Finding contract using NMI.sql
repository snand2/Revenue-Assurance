SELECT 
	V.VERTRAG AS CONTRACT,
	V.EINZDAT AS "START DATE",
	V.AUSZDAT AS "END DATE", 	
	ET.EXT_UI AS POD
FROM COMMERCIAL.EVER V
JOIN COMMERCIAL.EUIINSTLN EU
ON V.ANLAGE = EU.ANLAGE
JOIN CUSTOMER.EUITRANS ET
ON ET.INT_UI = EU.INT_UI
WHERE 
ET.EXT_UI IN 
(
	'43112864461',
	'43112973701',
	'43112850604'
)