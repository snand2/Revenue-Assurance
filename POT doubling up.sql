select distinct
ALPHA_CHCK.document_number as "User applied doc",
ALPHA_CHCK.clearing_doc as "User applied clearing",
BETA_CHCK.document_number as "batch applied doc",
BETA_CHCK.clearing_doc as "batch applied clearing",
ALPHA_CHCK."Sub-Transaction" as "User applied code",
BETA_CHCK."Sub-Transaction" as "batch applied code",
ALPHA_CHCK.SUM_NUMBER as "User applied sum",
BETA_CHCK.SUM_NUMBER as "batch applied sum",
ALPHA_CHCK."Contract Number" as "User_contract",
BETA_CHCK."Contract Number" as "batch_contract"

from

(
select distinct
	document_number,
	clearing_doc,
	"Posting Date",
	"Posting Calmonth",
	"Customer Class",
	"Business Partner",
	"BP name",
	"Contract Account",
	"Contract Number",
	"Document Type",
	"Main Transaction",
	"Main Transaction Desc",
	"Sub-Transaction",
	"Sub-Transaction Desc",
	"Sub-Trans desc group",
	"New Sub-Trans desc group",
	"Created By",
	"CONC_SAPH_BP_M_Y_",
	origin,
	sum(AUD) as AUD_SUM,
	sum("Number") as SUM_NUMBER,
	"USER CA Key",
	"User Type",
	"Posting Type",
	status,
	"BPCA",
	company_code,
	xblnr,count(*) as total_count,
	AUGRD,
	PRODUCTID,
	PRODUCTDESCRIPTION
from
(
select distinct
	d.opbel as document_number,
	d.AUGBL as clearing_doc,
	d.budat as "Posting Date",
	substring(d.budat,0,7) as "Posting Calmonth",
	te.text50 as "Customer Class",
	d.gpart as "Business Partner",
	BP_NAME as "BP name",
	e.vkont as "Contract Account",
	d.contract as "Contract Number",
	substr(vtref,11,20) as ISU_CONTRACT,
	blart as "Document Type",
	d.hvorg as "Main Transaction",
	t.txt30 as "Main Transaction Desc",
	d.tvorg as "Sub-Transaction",
	tf.txt30 as "Sub-Transaction Desc",
	ernam as "Created By",
	herkf as origin,
	betrw AUD,
	Abs(betrw) as "Number",
	concat (ernam,d.contract) as "USER CA Key",
	concat (d.gpart,substring(d.budat,0,7)) as "CONC_SAPH_BP_M_Y_",
case 
	when ernam like 'A%' then 'USER'
	when ernam like 'F%' then 'FIREFIGHTER'
	when ernam='AGLBATCH' then 'AGLBATCH'
else null 
end as "User Type",

case 
	when herkf like '01' then 'Manual Posting'
	when herkf like 'R4' then 'ISU-Invoicing'
else null 
end as "Posting Type",

case 
	when tf.txt30 like  'Credit Adjustment' then 'Credit Adjustment'
else null 
end as "Sub-Trans desc group",

case 
	when d.hvorg like 'Z450' and d.tvorg like '0060' and tf.txt30 like 'Pay On Time Discount%' and XBLNR >'0' then 'CRM Pay On Time Discount'
	when d.hvorg like 'Z450' and d.tvorg like '0020' and tf.txt30 like 'Pay On Time Discount%' and xblnr='' then 'ISU Pay on Time Discount'
	when d.hvorg like 'Z280' and d.tvorg like '0020' and xblnr='' then 'Manual Billing Adjustment' 
	when d.hvorg like 'Z120' and d.tvorg like '0610' and xblnr='' then 'Solar Energy Rebate Credit'
	when d.hvorg like 'Z140' and d.tvorg like '0530' and xblnr='' then 'Inconvenience Credit'
	when d.hvorg like 'Z400' or d.hvorg like 'Z410' or d.hvorg like 'Z420' and d.tvorg like '0020' and xblnr='' then 'Move-in Connection Guarantee'
	when d.hvorg like 'Z350' and d.tvorg like '0020' and xblnr='' then 'Metering Delay Exchange Credit'
	when d.hvorg like 'Z160' and d.tvorg like '0120' and xblnr='' then 'Merchant Service Fee Credit'
	when d.hvorg like 'Z160' and d.tvorg like '0130' and xblnr='' then 'Merchant Service Fee Credit'
	when d.hvorg like 'Z160' and d.tvorg like '0140' and xblnr='' then 'Merchant Service Fee Credit'
	when d.hvorg like 'Z160' and d.tvorg like '0150' and xblnr='' then 'Merchant Service Fee Credit'
	when d.hvorg like 'Z160' and d.tvorg like '0160' and xblnr='' then 'Merchant Service Fee Credit'
	when d.hvorg like 'Z010' and d.tvorg like '0020' and xblnr='' then 'Late Payment Fee Credit'
	when d.hvorg like 'Z010' and d.tvorg like '0040' and xblnr='' then 'Late Payment Fee Credit'
	when d.hvorg like 'Z120' and d.tvorg like '0580' and xblnr='' then 'Compensation Credit'
	when d.hvorg like 'Z141' and d.tvorg like '0020' and xblnr='' then 'Commercial Decision'
	when d.hvorg like 'Z142' and d.tvorg like '0020' and xblnr='' then 'Bushfire Relief Credit'
	when d.hvorg like 'Z142' and d.tvorg like '0060' and xblnr='' then 'ENA Network Relief'
	when d.hvorg like 'Z260' and d.tvorg like '0060' and xblnr='' then 'Mercantile Settlement- CR'
	when d.hvorg like 'Z171' and d.tvorg like '0020' and xblnr='' then 'QLD Govt Utility Relief Rebate'
	when d.hvorg like 'Z142' and d.tvorg like '0040' and xblnr='' then 'ENA Re-Energise & De-Energise Relief'
	when d.hvorg like 'Z200' and d.tvorg like '0020' and xblnr='' then 'Unbillable Consumption Manual'
else null 
end as "New Sub-Trans desc group",
	status,
	concat(d.gpart,d.vkont) as "BPCA",
	d.bukrs as company_code,
	xblnr,
	AUGRD,
	PRODUCTID,
	PRODUCTDESCRIPTION
from 
(
select distinct 
	vtref,
	opbel,
	augbl,
	bukrs,
	gpart,
	substr(vtref,11,20) as contract,
	vkont,
	to_date(cast(budat as date),'yyyy-MM-dd') as budat,
	betrw,
	hvorg,
	tvorg,
	spart,
	xblnr,
	AUGRD from "COMMERCIAL"."DFKKOP"
Where (hvorg in ('Z450') and tvorg in ('0020','0060') and (XBLNR >'0'))
and gpart !='SUSPREFUND') d  

join

(
select distinct 
	opbel,
	ernam,
	herkf,
	blart 
from "COMMERCIAL"."DFKKKO" 
where ernam not in ('AGLBATCH','CRM_RFC','WF-BATCH','MBLE_ISU_RFC')
and herkf='01')kk 
on (kk.opbel = d.opbel)

join 

(select distinct 
	hvorg,
	txt30 
from "OPEN"."TFKHVOT" where spras='E' )t 
on (t.hvorg = d.hvorg) 

left join
(select distinct 
	partner,
case 
	when concat(name_first,concat(' ',name_last)) is null then mc_name1
	when concat(name_first,concat(' ',name_last)) =' ' then mc_name1
else concat(name_first,concat(' ',name_last)) 
end as BP_NAME 

from "CUSTOMER"."ISU_BUT000" )b 
on (b.partner =d.gpart) 

left  join
(select distinct 
	hvorg,
	tvorg,
	txt30 
from "OPEN"."TFKTVOT" 
where spras='E' )tf 
on (tf.hvorg = d.hvorg and tf.tvorg = d.tvorg) 
left join

(
select distinct 
	vkont,
	kofiz_sd,
	vkbez 
from "CUSTOMER"."FKKVKP"  )e 
on (e.vkont = d.vkont) 
left join

(select distinct 
	bukrs,
	sparte,
	kofiz,
	text50 
from "OPEN"."TE097T" 
where spras='E' )te 
on ( te.kofiz = e.kofiz_sd and te.bukrs = d.bukrs and te.sparte = d.spart) 
left join

(
select distinct 
	contract,
	status,
	PRODUCTID,
	PRODUCTDESCRIPTION 
from "SP_CUSTOMER"."CIA_TheTruthAboutCustomer" )c 
on (c.contract = d.contract))

Where "Posting Date" >= '2020-07-01' 

group by
	document_number,
	clearing_doc,
	"Posting Date",
	"Posting Calmonth",
	"Customer Class",
	"Business Partner",
	"BP name",
	"Contract Account",
	"Contract Number",
	"Document Type",
	"Main Transaction",
	"Main Transaction Desc",
	"Sub-Transaction",
	"Sub-Transaction Desc",
	"New Sub-Trans desc group",
	"Created By",
	origin,
	"USER CA Key",
	"User Type",
	"Posting Type",
	status,
	"BPCA",
	company_code,
	"CONC_SAPH_BP_M_Y_",
	xblnr,
	AUGRD,
	"Sub-Trans desc group",
	PRODUCTID,
	PRODUCTDESCRIPTION
) ALPHA_CHCK

Left join

(
select distinct
	document_number,
	clearing_doc,
	"Posting Date",
	"Posting Calmonth",
	"Customer Class",
	"Business Partner",
	"BP name",
	"Contract Account",
	"Contract Number",
	"Document Type",
	"Main Transaction",
	"Main Transaction Desc",
	"Sub-Transaction",
	"Sub-Transaction Desc",
	"Sub-Trans desc group",
	"New Sub-Trans desc group",
	"Created By",
	"CONC_SAPH_BP_M_Y_",
	origin,
	sum(AUD) as AUD_SUM,
	sum("Number") as SUM_NUMBER,
	"USER CA Key",
	"User Type",
	"Posting Type",
	status,
	"BPCA",
	company_code,
	xblnr,count(*) as total_count,
	AUGRD,
	PRODUCTID,
	PRODUCTDESCRIPTION
from
(
select distinct
	d.opbel as document_number,
	d.AUGBL as clearing_doc,
	d.budat as "Posting Date",
	substring(d.budat,0,7) as "Posting Calmonth",
	te.text50 as "Customer Class",
	d.gpart as "Business Partner",
	BP_NAME as "BP name",
	e.vkont as "Contract Account",
	d.contract as "Contract Number",
	substr(vtref,11,20) as ISU_CONTRACT,
	blart as "Document Type",
	d.hvorg as "Main Transaction",
	t.txt30 as "Main Transaction Desc",
	d.tvorg as "Sub-Transaction",
	tf.txt30 as "Sub-Transaction Desc",
	ernam as "Created By",
	herkf as origin,
	betrw AUD,
	Abs(betrw) as "Number",
	concat (ernam,d.contract) as "USER CA Key",
	concat (d.gpart,substring(d.budat,0,7)) as "CONC_SAPH_BP_M_Y_",
case 
	when ernam like 'A%' then 'USER'
	when ernam like 'F%' then 'FIREFIGHTER'
	when ernam='AGLBATCH' then 'AGLBATCH'
else null 
end as "User Type",

case 
	when herkf like '01' then 'Manual Posting'
	when herkf like 'R4' then 'ISU-Invoicing'
else null 
end as "Posting Type",

case 
	when tf.txt30 like  'Credit Adjustment' then 'Credit Adjustment'
else null 
end as "Sub-Trans desc group",

case 
	when d.hvorg like 'Z450' and d.tvorg like '0060' and tf.txt30 like 'Pay On Time Discount%' and XBLNR >'0' then 'CRM Pay On Time Discount'
	when d.hvorg like 'Z450' and d.tvorg like '0020' and tf.txt30 like 'Pay On Time Discount%' and xblnr='' then 'ISU Pay on Time Discount'
	when d.hvorg like 'Z280' and d.tvorg like '0020' and xblnr='' then 'Manual Billing Adjustment' 
	when d.hvorg like 'Z120' and d.tvorg like '0610' and xblnr='' then 'Solar Energy Rebate Credit'
	when d.hvorg like 'Z140' and d.tvorg like '0530' and xblnr='' then 'Inconvenience Credit'
	when d.hvorg like 'Z400' or d.hvorg like 'Z410' or d.hvorg like 'Z420' and d.tvorg like '0020' and xblnr='' then 'Move-in Connection Guarantee'
	when d.hvorg like 'Z350' and d.tvorg like '0020' and xblnr='' then 'Metering Delay Exchange Credit'
	when d.hvorg like 'Z160' and d.tvorg like '0120' and xblnr='' then 'Merchant Service Fee Credit'
	when d.hvorg like 'Z160' and d.tvorg like '0130' and xblnr='' then 'Merchant Service Fee Credit'
	when d.hvorg like 'Z160' and d.tvorg like '0140' and xblnr='' then 'Merchant Service Fee Credit'
	when d.hvorg like 'Z160' and d.tvorg like '0150' and xblnr='' then 'Merchant Service Fee Credit'
	when d.hvorg like 'Z160' and d.tvorg like '0160' and xblnr='' then 'Merchant Service Fee Credit'
	when d.hvorg like 'Z010' and d.tvorg like '0020' and xblnr='' then 'Late Payment Fee Credit'
	when d.hvorg like 'Z010' and d.tvorg like '0040' and xblnr='' then 'Late Payment Fee Credit'
	when d.hvorg like 'Z120' and d.tvorg like '0580' and xblnr='' then 'Compensation Credit'
	when d.hvorg like 'Z141' and d.tvorg like '0020' and xblnr='' then 'Commercial Decision'
	when d.hvorg like 'Z142' and d.tvorg like '0020' and xblnr='' then 'Bushfire Relief Credit'
	when d.hvorg like 'Z142' and d.tvorg like '0060' and xblnr='' then 'ENA Network Relief'
	when d.hvorg like 'Z260' and d.tvorg like '0060' and xblnr='' then 'Mercantile Settlement- CR'
	when d.hvorg like 'Z171' and d.tvorg like '0020' and xblnr='' then 'QLD Govt Utility Relief Rebate'
	when d.hvorg like 'Z142' and d.tvorg like '0040' and xblnr='' then 'ENA Re-Energise & De-Energise Relief'
	when d.hvorg like 'Z200' and d.tvorg like '0020' and xblnr='' then 'Unbillable Consumption Manual'
else null 
end as "New Sub-Trans desc group",
	status,
	concat(d.gpart,d.vkont) as "BPCA",
	d.bukrs as company_code,
	xblnr,
	AUGRD,
	PRODUCTID,
	PRODUCTDESCRIPTION
from 
(
select distinct 
	vtref,
	opbel,
	augbl,
	bukrs,
	gpart,
	substr(vtref,11,20) as contract,
	vkont,
	to_date(cast(budat as date),'yyyy-MM-dd') as budat,
	betrw,
	hvorg,
	tvorg,
	spart,
	xblnr,
	AUGRD from "COMMERCIAL"."DFKKOP"
Where (hvorg in ('Z450') and tvorg in ('0020','0060') and (XBLNR >'0'))
and gpart !='SUSPREFUND') d  

join

(
select distinct 
	opbel,
	ernam,
	herkf,
	blart 
from "COMMERCIAL"."DFKKKO" 
where ernam in ('AGLBATCH','CRM_RFC','WF-BATCH','MBLE_ISU_RFC')
and herkf='01')kk 
on (kk.opbel = d.opbel)

join 

(select distinct 
	hvorg,
	txt30 
from "OPEN"."TFKHVOT" where spras='E' )t 
on (t.hvorg = d.hvorg) 

left join
(select distinct 
	partner,
case 
	when concat(name_first,concat(' ',name_last)) is null then mc_name1
	when concat(name_first,concat(' ',name_last)) =' ' then mc_name1
else concat(name_first,concat(' ',name_last)) 
end as BP_NAME 

from "CUSTOMER"."ISU_BUT000" )b 
on (b.partner =d.gpart) 

left  join
(select distinct 
	hvorg,
	tvorg,
	txt30 
from "OPEN"."TFKTVOT" 
where spras='E' )tf 
on (tf.hvorg = d.hvorg and tf.tvorg = d.tvorg) 
left join

(
select distinct 
	vkont,
	kofiz_sd,
	vkbez 
from "CUSTOMER"."FKKVKP"  )e 
on (e.vkont = d.vkont) 
left join

(select distinct 
	bukrs,
	sparte,
	kofiz,
	text50 
from "OPEN"."TE097T" 
where spras='E' )te 
on ( te.kofiz = e.kofiz_sd and te.bukrs = d.bukrs and te.sparte = d.spart) 
left join

(
select distinct 
	contract,
	status,
	PRODUCTID,
	PRODUCTDESCRIPTION 
from "SP_CUSTOMER"."CIA_TheTruthAboutCustomer" )c 
on (c.contract = d.contract))

Where "Posting Date" >= '2020-07-01' 

group by
	document_number,
	clearing_doc,
	"Posting Date",
	"Posting Calmonth",
	"Customer Class",
	"Business Partner",
	"BP name",
	"Contract Account",
	"Contract Number",
	"Document Type",
	"Main Transaction",
	"Main Transaction Desc",
	"Sub-Transaction",
	"Sub-Transaction Desc",
	"New Sub-Trans desc group",
	"Created By",
	origin,
	"USER CA Key",
	"User Type",
	"Posting Type",
	status,
	"BPCA",
	company_code,
	"CONC_SAPH_BP_M_Y_",
	xblnr,
	AUGRD,
	"Sub-Trans desc group",
	PRODUCTID,
	PRODUCTDESCRIPTION
) BETA_CHCK
on ALPHA_CHCK.Clearing_doc = BETA_CHCK.Clearing_doc
and ALPHA_CHCK."Contract Number" = BETA_CHCK."Contract Number"
and ALPHA_CHCK.clearing_doc is not null
and BETA_CHCK.clearing_doc is not null
