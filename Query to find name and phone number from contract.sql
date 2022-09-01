Select 

EV.Vertrag as contract,
FK.VKBEZ as Name,
TRT.Mobile as Mobile,
TRT.PHONE1 as PHONE1,
TRT.PHONE2 as PHONE2,
TRT.PHONE3 as PHONE3

from
commercial.ever EV
left join
customer.fkkvkp FK
on ev.vkonto = fk.vkont
left join
"SP_CUSTOMER"."CIA_TheTruthAboutCustomer" TRT
on fk.vkont = trt.CONTRACTACCOUNTNUMBER

where ev.vertrag in('9409537489')