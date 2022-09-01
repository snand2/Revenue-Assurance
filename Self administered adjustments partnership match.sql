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
	c.bukrs as "Company_Code",
	Abs(c.betrw) as "Number",
	d.ernam as "Created_By",
	d.herkf as "Origin",
	a.partnership_code,
	EMP."FULL NAME UPPER",
	EMP."Worker Position",
	EMP."Level 4 Org Unit",
	EMP."Level 5 Org Unit",
	EMP."Manager - Level 01"


FROM "COMMERCIAL"."DFKKOP" c

join "COMMERCIAL"."DFKKKO" d

on c.OPBEL = d.OPBEL

inner join 
(
select distinct
	a.ZZCUSTOMER_I2101 as Partnership_code,
	b.A4ISUCONTR as FFContract,
	B.A4BPNO as FFBP
from "COMMERCIAL"."CRMD_CUSTOMER_I" a
join 
"COMMERCIAL"."CRMD_ISUEXTA4" b
on b.GUID = a.GUID
where b.A4ISUCONTR <> ''
and a.ZZCUSTOMER_I2101 like 'A%') a

on a.FFBP = c.GPART

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


left join 
(
select distinct 
	hvorg,
	txt30 from "OPEN"."TFKHVOT" where spras='E'  )t 
on (t.hvorg = c.hvorg)

left join 
(
SELECT DISTINCT 
	hvorg,
	tvorg,
	txt30 from "OPEN"."TFKTVOT" where spras='E' )tf 
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
and d.ernam = a.partnership_code


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
a.partnership_code,
d.herkf,
EMP."FULL NAME UPPER",
EMP."Worker Position",
EMP."Level 4 Org Unit",
EMP."Level 5 Org Unit",
EMP."Manager - Level 01"