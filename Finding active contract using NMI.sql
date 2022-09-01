SELECT	V.VERTRAG as "Contract", 
		ET.EXT_UI as "NMI"
				


					FROM CUSTOMER.EUITRANS ET
					left JOIN COMMERCIAL.EUIINSTLN EU
					ON ET.INT_UI = EU.INT_UI   
					left JOIN COMMERCIAL.EVER V
					ON V.ANLAGE = EU.ANLAGE



where v.auszdat = '99991231'

and ET.EXT_UI IN ('62032663209',
'62035307430'
)



