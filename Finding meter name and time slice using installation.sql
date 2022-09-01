SELECT



EAST.ANLAGE as "Installation",
EG.GERAET as "Meter Number", --unsure if this is meter number
ltrim(EG.LOGIKNR,0) as "Meter Number1", --this is not meter number, i don't know what this is
EAST.AB as "Meter time slice start",
EAST.BIS as "Meter time slice ended"


from

 

COMMERCIAL.EASTS EAST --Installation table
LEFT JOIN
COMMERCIAL.ETDZ ET -- Bring in meter info
ON EAST.LOGIKZW = ET.LOGIKZW
LEFT JOIN
COMMERCIAL.EGERR EG -- More meter info
ON ET.EQUNR = EG.EQUNR

 


where
EAST.ANLAGE in
('3000956854')
