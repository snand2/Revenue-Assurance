select *,
case 
	when "Adherence" like 'Res InconvenienceCredit <= 50' then 'True'
	when "Adherence" is null then 'False'
else null 
end as "Authorised Transactions"

from
(
Select *,
case 
	when "Organizational Unit" like 'TEAM 27 - CA' and "New Sub-Trans desc group" like 'Credit Adjustment%' and XBLNR = '' and Sum_Number > 836.01 then 'CA > Average'
	when "Organizational Unit" like 'CUSTOMER ADVOCACY' and "New Sub-Trans desc group" like 'Credit Adjustment%' and XBLNR = '' and Sum_Number > 836.01 then 'CA > Average'
	when "Organizational Unit" like 'GANDHINAGAR CUSTOMER ADVOCACY' and "New Sub-Trans desc group" like 'Credit Adjustment%' and XBLNR = '' and Sum_Number > 836.01 then 'CA > Average'
	when "Organizational Unit" like 'KOLKATA CUSTOMER ADVOCACY' and "New Sub-Trans desc group" like 'Credit Adjustment%' and XBLNR = '' and Sum_Number > 836.01 then 'CA > Average'


	when lob like 'Resolution' and "New Sub-Trans desc group" like 'Inconvenience Credit%' and XBLNR = '' and Sum_Number <= 50.00 then 'Res InconvenienceCredit <= 50'
	when lob like 'Resolution' and "New Sub-Trans desc group" like 'Inconvenience Credit%' and XBLNR = '' and Sum_Number > 50.01 and Sum_Number <=99.99 then 'Res InconvenienceCredit > between 50 & 100'
	when lob like 'Resolution' and "New Sub-Trans desc group" like 'Inconvenience Credit%' and XBLNR = '' and Sum_Number = 100.00 then 'Res InconvenienceCredit = 100'  
	when lob like 'Resolution' and "New Sub-Trans desc group" like 'Inconvenience Credit%' and XBLNR = '' and Sum_Number > 100.01 then 'Res InconvenienceCredit > 100' 

	when lob like 'Resolution' and "New Sub-Trans desc group" like 'Compensation Credit%' and XBLNR = '' and Sum_Number > 100.01 then 'Res Compensation Credit > 100'
	when lob like 'Resolution' and "New Sub-Trans desc group" like 'Compensation Credit%' and XBLNR = '' and Sum_Number <= 100.00 then 'Res Compensation Credit <= 100'
	when lob like 'Resolution' and "New Sub-Trans desc group" like 'Move-in connection guarantee%' and XBLNR = '' and Sum_Number > 100.01 then 'Res Movein connection guarantee > 100' 
	when lob like 'Resolution' and "New Sub-Trans desc group" like 'Move-in connection guarantee%' and XBLNR = '' and Sum_Number <= 100.00 then 'Res Movein connection guarantee <= 100' 

	when lob like 'High Value' and "New Sub-Trans desc group" like 'Inconvenience Credit%' and XBLNR = '' and Sum_Number > 50.01 then 'High V Inconvenience Credit > than 50'
	when lob like 'High Value' and "New Sub-Trans desc group" like 'Inconvenience Credit%' and XBLNR = '' and Sum_Number <= 50.00 then 'High V Inconvenience Credit <= 50'

	when lob like 'High Value' and "New Sub-Trans desc group"like 'Move-in connection guarantee%' and XBLNR = '' and Sum_Number > 250.01 then 'High V Inconvenience Credit > than 250'
	when lob like 'High Value' and "New Sub-Trans desc group" like 'Move-in connection guarantee%' and XBLNR = '' and Sum_Number <= 250.00 then 'High V Inconvenience Credit <= 250'


	when lob like 'Complaints/Ombudsman' and "New Sub-Trans desc group" like 'Inconvenience Credit%' and XBLNR = '' and Sum_Number > 150.01 then 'Complaints Inconvenience Credit> 250'
	when lob like 'Complaints/Ombudsman' and "New Sub-Trans desc group" like 'Inconvenience Credit%' and XBLNR = '' and Sum_Number <= 150.00 then 'Complaints Inconvenience Credit<= 250'
	when lob like 'Complaints/Ombudsman' and "New Sub-Trans desc group" like 'Move-in connection guarantee%' and XBLNR = '' and Sum_Number > 100.01 then 'Complaints Move-in connection guarantee unsubstantiated >100'
	when lob like 'Complaints/Ombudsman' and "New Sub-Trans desc group" like 'Move-in connection guarantee%' and XBLNR = '' and Sum_Number <= 100.00 then 'Complaints Move-in connection guarantee substantiated<= 100'
	when lob like 'Complaints/Ombudsman' and "New Sub-Trans desc group" like 'Compensation%' and XBLNR = '' and Sum_Number > 100.01 then 'Complaints Compensation Unsubtantiated > 100'
	when lob like 'Complaints/Ombudsman' and "New Sub-Trans desc group" like 'Compensation%' and XBLNR = '' and Sum_Number <= 100.00 then 'Complaints Compensation Subtantiated <= 100'
else null 
end as "Adherence"



from
(
select*,
case 
	when "New Sub-Trans desc group" like 'CRM Pay On Time Discount' or "New Sub-Trans desc group" like 'ISU Pay on Time Discount' then 'Manual Pay on Time Discount'
	when "New Sub-Trans desc group" like 'Manual Billing Adjustment' then 'Manual Billing Adjustment' 
	when "New Sub-Trans desc group" like 'Solar Energy Rebate Credit' then 'Solar Energy Rebate Credit' 
	when "New Sub-Trans desc group" like 'Inconvenience Credit' then 'Inconvenience Credit'
	when "New Sub-Trans desc group" like 'Move-in Connection Guarantee' then 'Move-in Connection Guarantee'
	when "New Sub-Trans desc group" like 'Compensation Credit' then 'Compensation Credit'
	when "New Sub-Trans desc group" like 'Commercial Decision' then 'Commercial Decision'
	when "New Sub-Trans desc group" like 'Bushfire Relief Credit' then 'Bushfire Relief Credit'
	when "New Sub-Trans desc group" like 'Metering Delay Exchange Credit' then 'Metering Delay Exchange Credit'
	when "New Sub-Trans desc group" like 'Merchant Service Fee Credit' then 'Merchant Service Fee Credit'
	when "New Sub-Trans desc group" like 'Late Payment Fee Credit' then 'Late Payment Fee Credit'
else null 
end as "New-New Sub-Trans desc group"
 


from 
(select distinct
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
	"Organizational Unit",
	"CONC_SAPH_BP_M_Y_",
	origin,
	sum(AUD) as AUD_SUM,
	sum("Number") as SUM_NUMBER,
	"USER CA Key",
	"User Type",
	"Posting Type",
	"BPCA",
	company_code,
	toporg,
	lob,
	jobtitle,
	org1,
	org2,
	org3,
	org4,
	org5,
	TEAMLEADER,
	SUPERVISOR_NAME,
	centre,
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
	organization as "Organizational Unit",
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
	else null 
	end as "New Sub-Trans desc group",
	concat(d.gpart,d.vkont) as "BPCA",
	d.bukrs as company_code,
	toporg,
	lob,
	jobtitle,
	org1,
	org2,
	org3,
	org4,
	org5,
	TEAMLEADER,
	SUPERVISOR_NAME,
	centre,
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
	AUGRD 
from "COMMERCIAL"."DFKKOP"
	where to_date(cast(budat as date),'yyyy-MM-dd') >= '2020-06-01'
	and HVORG like '%Z9%')d --singles out Service order fees

join
(
select distinct 
	opbel,
	ernam,
	herkf,
	blart 
from "COMMERCIAL"."DFKKKO") kk 
on ( kk.opbel = d.opbel)
  join 
(
select distinct 
	hvorg,
	txt30 
from "OPEN"."TFKHVOT" 
	where spras='E' )t 
	on (t.hvorg = d.hvorg) 
left join

(
select distinct 
	partner,
	case 
		when concat(name_first,concat(' ',name_last)) is null then mc_name1
		when concat(name_first,concat(' ',name_last)) =' ' then mc_name1
	else concat(name_first,concat(' ',name_last)) 
	end as BP_NAME 
from "CUSTOMER"."ISU_BUT000" )b 
on (b.partner =d.gpart) 
left join
(
select distinct 
	hvorg,
	tvorg,
	txt30 
from "OPEN"."TFKTVOT" 
	where spras='E')tf 
on (tf.hvorg = d.hvorg 
and tf.tvorg = d.tvorg) 
left   join
(
select distinct 
	vkont,
	kofiz_sd,
	vkbez 
from "CUSTOMER"."FKKVKP"  )e 
on ( e.vkont = d.vkont) 
left join
(
select distinct 
	bukrs,
	sparte,
	kofiz,
	text50 
from "OPEN"."TE097T" where spras='E' )te 
on ( te.kofiz = e.kofiz_sd 
and te.bukrs = d.bukrs 
and te.sparte = d.spart) 
left join
(
select distinct 
	contract,
	PRODUCTID,
	PRODUCTDESCRIPTION 
from "SP_CUSTOMER"."CIA_TheTruthAboutCustomer" )c 
on (c.contract = d.contract)
left join 
(
select distinct 
	anumber,
	toporg,
	lob,
	jobtitle,
	org1,
	org2,
	assignmentstart,
	assignmentend,
	org3,
	org4,
	org5,
	organization,
	centre,TEAMLEADER,
	SUPERVISOR_NAME
from "SP_COMMERCIAL"."CSTEAMSTRUCTURE" 
where to_date(cast(assignmentstart as date),'yyyy-MM-dd') <= current_Date
and to_date(cast(assignmentend as date),'yyyy-MM-dd') >= '2020-06-01')  cs 
on ( cs.anumber = kk.ernam and d.budat between to_date(cast(assignmentstart as date),'yyyy-MM-dd')
and  to_date(cast(assignmentend as date),'yyyy-MM-dd'))
)

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
	"Organizational Unit",
	origin,
	"USER CA Key",
	"User Type",
	"Posting Type",
	"BPCA",
	company_code,
	toporg,
	lob,
	jobtitle,
	org1,
	org2,
	org3,
	org4,
	org5,
	centre,
	TEAMLEADER,
	SUPERVISOR_NAME,
	"CONC_SAPH_BP_M_Y_",
	xblnr,
	AUGRD,
	"Sub-Trans desc group",
	PRODUCTID,
	PRODUCTDESCRIPTION
)))
