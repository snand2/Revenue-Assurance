Select *
from (

 

Select ever.vertrag,
ever.anlage,
te4.termtdat,
RANK() OVER (PARTITION BY EVER.VERTRAG,EAN.ANLAGE ORDER BY TE4.TERMTDAT ASC) AS NSRD_RANK

 


from commercial.ever ever

 

left join commercial.eanlh ean
on
ever.anlage = ean.anlage
left join
open.TE418 te4
on
ean.ableinh = te4.termschl

 

where ean.bis ='99991231'
and te4.termtdat > CURRENT_DATE
and ever.vertrag in
('9409358003')

)
where NSRD_RANK = 1