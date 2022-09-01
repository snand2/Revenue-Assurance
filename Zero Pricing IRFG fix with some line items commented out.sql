Select 
db3.BELZEILE as "Line Item", 
db1.BELNR as "Bill Doc",
db1.BELZART as "Line Item Type", 
te.text30 as "Line Item Description",
db1.STTARIF as "STTARIF", 
db1.AKLASSE as "Class", 
db1.TARIFTYP as "Rate Category", 
db1.STATTART as "Rate Type1", 
ettifn.kondigr as "IRFG RFG",
db1.EIN01 as "EIN01", 
db1.EIN02 as "EIN02", 
db1.ABRMENGE as "Billing Quantity", 
db3.PREIS as "Price",
db3.PREISBTR as "Price Amount",
db3.NETTOBTR as "Amount", 
erch.GPARTNER as "Business Partner", 
erch.VKONT as "Account Number", 
erch.vertrag as "Contract", 
ever.anlage as "Installation",
pod.ext_ui as "POD",
TO_DATE (erch.BEGABRPE) as "Start Billing Period", 
TO_DATE (erch.ENDABRPE) as "End Billing Period", 
TO_DATE (erch.ERDAT) as "Creation date",
case --checking CK or AS
	when ever.VREFER like '%CK%' then 'Former Click Customer'
	when ever.VREFER like '%AS%' then 'Former Amaysim Customer'
	when ever.VREFER not like '%CK%' then 'AGL OR PD'
	when ever.VREFER not like '%AS%' then 'AGL OR PD'
else null 
end as "Customer Type"

from dataint.tbl_sapisu_dberchz1 db1 -- table that has line items

inner join 
dataint.tbl_sapisu_dberchz3 db3  --joining in table that has pricing info
on db1.BELNR = db3.BELNR 
and db1.BELZEILE = db3.BELZEILE 
and db3.PREISBTR = 0 -- specifically zero pricing for that line item

inner join 
open.te835t te --line item descriptions
on db1.belzart = te.belzart
and te.SPRAS ='E'

inner join 
commercial.erch erch --joining to bill doc table
on db3.belnr = erch.belnr 
and erch.erdat >= '20200701' --start date of which data is  from
and erch.stornodat ='00000000' -- no reversal date, not reversed

inner join
commercial.ever ever --bringing in contract for installation
on erch.vertrag = ever.vertrag

inner join
commercial.euiinstln instl
on ever.anlage = instl.anlage
and instl.dateto ='99991231'

inner join
customer.euitrans pod
on instl.int_ui = pod.int_ui
and pod.dateto ='99991231'

inner join
commercial.ettifn ettifn --bringing in installation facts for IRFG
on ever.anlage = ettifn.anlage
and ettifn.AB  <= erch.ENDABRPE --start date of IRFG has to be less than bill end date
and ettifn.BIS  >= erch.BEGABRPE --end date of IRFG has to be greater than bill start date
--and ettifn.BIS ='99991231'
and ettifn.TARIFART ='E_BUNDLE'
--and ettifn.inaktiv !='X'

where  db1.ABRMENGE <> 0 --has quantity to be billed
and db1.belzart in 
('ZNCLAT', --Control load
'ZGU_AT', --General usage
'ZSPVAT',
'ZDM_AT',
'ZCLMAT',
'ZOP_AT',
'1',
'ZPK_AT',
'ZT33AT',
'ZCL1AT',
'ZSH_AT',
'ZT31AT',
'ZCL2AT',
'ZSC_OA',
'ZSNBAT')
--'ZSSMOA', --solar service metering charge
--'ZCL1OA', --CL1 NSW supply charge
--'ZCL2OA', --CL2 NSW supply charge
--'ZT31OA',--T31 QLD supply charge
--'ZR33OA') --T33 QLD supply charge
