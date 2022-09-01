Select
	db3.BELZEILE as "Line Item", 
	db1.BELNR as "Bill Doc",
	db1.BELZART as "Line Item Type",  
	db1.AKLASSE as "Class", 
	te.text50 as "account class",
	db3.NETTOBTR as "Amount", 
	erch.GPARTNER as "Business Partner", 
	substr(erch.VKONT,3,12) as "Account Number", 
	erch.vertrag as "Contract", 
	but.name_first as "Customer first name",
	TO_DATE (erch.BEGABRPE) as "Start Billing Period", 
	TO_DATE (erch.ENDABRPE) as "End Billing Period", 
	TO_DATE (erch.ERDAT) as "Creation date",
	erch.ERNAM as "Created by",
	CASE 
	when concat(but.name_first,concat(' ',but.name_last)) is null then mc_name1
	when concat(but.name_first,concat(' ',but.name_last)) =' ' then mc_name1
	else concat(but.name_first,concat(' ',but.name_last)) 
		end as "BP_NAME",
	CASE 
		when ever.vrefer like '%ck%' then 'CLICK'
		when ever.vrefer like '%as%' then 'AMAYSIM'
		when ever.vrefer not like '%ck%' then 'AGL'
		when ever.vrefer not like '%as%' then 'AGL'
	end as "CK_AS"
from dataint.tbl_sapisu_dberchz1 db1

inner join 
dataint.tbl_sapisu_dberchz3 db3  
on  db1.BELZEILE = db3.BELZEILE 
and db1.BELNR = db3.BELNR
and  db1.BELZART = 'ZCWODA' 

inner join 
commercial.erch erch 
on db3.belnr = erch.belnr 
and erch.erdat >= '20210101'

inner join
commercial.ever ever
on erch.vertrag = ever.vertrag

inner join
open.te097AT te
on ever.kofiz = te.kofiz
and SPRAS ='E'

inner join
customer.ISU_BUT000 but
on erch.gpartner = but.partner

