SELECT
	  		
				EAST.ANLAGE as "Installation",
				EVER.VERTRAG as "Contract",
				FK.GPART as "BP",
				EG.GERAET as "Meter Number",
				EG.ZWGRUPPE,
				EVER.AUSZDAT,
				EG.BIS as "Meter time slice ended"
				
				
from 	

			COMMERCIAL.EASTS EAST --Installation table
		LEFT JOIN
			COMMERCIAL.ETDZ ET -- Bring in multiplier data on meter
			ON EAST.LOGIKZW = ET.LOGIKZW
		LEFT JOIN
			COMMERCIAL.EGERR EG -- Meter information
			ON  ET.EQUNR = EG.EQUNR
		LEFT JOIN
			COMMERCIAL.EVER EVER
			ON EVER.ANLAGE = EAST.ANLAGE	
		LEFT JOIN 
			CUSTOMER.FKKVKP FK
			ON FK.VKONT = EVER.VKONTO
		
where ZWGRUPPE in (
'BULKHW')
