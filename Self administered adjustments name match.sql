select distinct
	c.opbel as "Document_Number",
	c.gpart as "Business_Partner",
	f.BP_NAME as "BP Name",
	substr(c.vtref,11,20) as "Contract",
	substr(c.vkont,3,12) as "Contract_Account_Number",
	c.HVORG as "Main-Transaction",
	c.TVORG as "Sub-Transaction",
	to_date(c.budat) as "Posting_Date",
	substring(c.budat,0,6) as "Posting Calmonth",
	c.blart as "Document_Type",
	c.xblnr,count(*) as "Total_Count_Document_Number",
	c.AUGBL as "Clearing_Document_Number",
	c.AUGRD as "Clearing_Reason",
	c.bukrs as "Company_Code",
	c.betrw AUD,
	Abs(c.betrw) as "Number",
	c.xblnr as "Reference_Document_Number",
	d.ernam as "Created_By",
	d.herkf as "Origin",
	a.PRODUCTDESCRIPTION,
	EMP."FULL NAME UPPER",
	EMP."Worker Position",
	EMP."Level 4 Org Unit",
	EMP."Level 5 Org Unit",
	EMP."Manager - Level 01"


FROM "COMMERCIAL"."DFKKOP" c

join "COMMERCIAL"."DFKKKO" d

on c.OPBEL = d.OPBEL

left join
(
select 
	BUSINESSPARTNER,
	UPPER (CONTRACTACCOUNTNAME) as "CONTRACT_ACCOUNT_NAME",
	CONTRACT,
	substr (CONTRACTACCOUNTNUMBER,3,12) as "Contract_Account_Number",
	PRODUCTDESCRIPTION	
from "SP_CUSTOMER"."CIA_TheTruthAboutCustomer"
where PRODUCTDESCRIPTION LIKE '%Employee%'
and STATUS != 'INACTIVE') a

on a.BUSINESSPARTNER = c.GPART

left join
(
Select 
	ANUMBER,
	UPPER ("Full Name") as "FULL NAME UPPER",
	"Worker Position",
	"Level 4 Org Unit",
	"Level 5 Org Unit",
	"Manager - Level 01"
From 
A116627.EMPDATA2021) EMP
on d.ernam = EMP.ANUMBER

left join (select distinct 
	hvorg,
	txt30 from "OPEN"."TFKHVOT" where spras='E'  )t 
on (t.hvorg = c.hvorg)

left join 
(
SELECT DISTINCT 
	hvorg,
	tvorg,
	txt30 
from "OPEN"."TFKTVOT" where spras='E' )tf 
on (tf.hvorg = c.hvorg and tf.tvorg = c.tvorg)

Left join 
(
select distinct 
	partner,
	case 
		when concat(name_first,concat(' ',name_last)) is null then mc_name1
		when concat(name_first,concat(' ',name_last)) =' ' then mc_name1
else concat(name_first,concat(' ',name_last)) 
end as BP_NAME 
from "CUSTOMER"."ISU_BUT000" ) f
on (f.partner =c.gpart) 

where c.budat between ADD_DAYS(LAST_DAY(ADD_MONTHS(CURRENT_DATE,-2)),1) and ADD_DAYS(LAST_DAY(ADD_MONTHS(CURRENT_DATE,-1)),1)
and d.ernam <> 'AGLBATCH'
and d.ernam <> 'WF-BATCH'
and d.ernam <> 'CRM_RFC'
and d.ernam <> 'MBLE_ISU_RFC'
and d.ernam <> 'XNWG_ISU_RFC'
and d.ernam <> 'WDEPCIAGL'
and d.ernam <> 'DATAMIGCNI11'
and d.ernam <> 'DATAMIGAPG04'
and a."CONTRACT_ACCOUNT_NAME" = EMP."FULL NAME UPPER"


group by 

c.opbel,
c.gpart,
f.bp_name,
c.VTREF,
c.vkont,
c.HVORG,
c.TVORG,
t.TXT30,
tf.TXT30,
c.budat,
c.budat,
c.budat,
c.blart,
c.xblnr,
c.AUGBL,
c.AUGRD,
c.bukrs,
c.betrw,
c.betrw,
c.xblnr,
d.ernam,
a.PRODUCTDESCRIPTION,
d.herkf,
EMP."FULL NAME UPPER",
EMP."Worker Position",
EMP."Level 4 Org Unit",
EMP."Level 5 Org Unit",
EMP."Manager - Level 01"
