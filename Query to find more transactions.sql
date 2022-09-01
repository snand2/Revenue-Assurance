
Select * 

From 
(
SELECT DISTINCT
	Abs(c.betrw) as "Number",
	c.opbel as "Document_Number",
	c.gpart as "Business_Partner",
	substr(c.vtref,11,20) as "Contract",
	substr(c.vkont,3,12) as "Contract_Account_Number",
	c.HVORG as "Main-Transaction",
	c.TVORG as "Sub-Transaction",
	tf.txt30 as "DESC",
	to_date(c.budat) as "Posting_Date",
	substring(c.budat,0,6) as "Posting Calmonth",
	c.blart as "Document_Type",
	c.bukrs as "Company_Code",
	d.ernam as "Created_By",
	d.herkf as "Origin",
	EMP."Full Name",
	EMP."Worker Position",
	EMP."Level 4 Org Unit",
	EMP."Level 5 Org Unit",
	EMP."Manager - Level 01"
	
FROM 
"COMMERCIAL"."DFKKOP" c

left join "COMMERCIAL"."DFKKKO" d

on c.OPBEL = d.OPBEL

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

left join
A116627.EMPDATA2021 EMP
on d.ernam = EMP.ANUMBER

where c.budat between '20210706' and '20210720'
and d.ernam = 'A128800'


group by 
	c.opbel,
	c.gpart,
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
	c.xblnr,
	d.ernam,
	d.herkf,
	EMP."Full Name",
	EMP."Worker Position",
	EMP."Level 4 Org Unit",
	EMP."Level 5 Org Unit",
	EMP."Manager - Level 01"
) A
Order by A."Number" DESC
