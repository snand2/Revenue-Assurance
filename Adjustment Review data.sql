Select top 5 * --ALL ADJUSTMENTS

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
(
SELECT *
from"COMMERCIAL"."DFKKOP"
WHERE (hvorg in ('Z010') and tvorg in ('0020'))
	or (hvorg in ('Z010') and tvorg in ('0040'))
	or (hvorg in ('Z120') and tvorg in ('0580'))
	or (hvorg in ('Z120') and tvorg in ('0610'))
	or (hvorg in ('Z140') and tvorg in ('0530'))
	or (hvorg in ('Z141') and tvorg in ('0020'))
	or (hvorg in ('Z160') and tvorg in ('0120'))
	or (hvorg in ('Z160') and tvorg in ('0130'))
	or (hvorg in ('Z160') and tvorg in ('0140'))
	or (hvorg in ('Z160') and tvorg in ('0150'))
	or (hvorg in ('Z280') and tvorg in ('0020'))
	or (hvorg in ('Z800') and tvorg in ('0020','0040','0060','0100','0120'))
	or (hvorg in ('Z260') and tvorg in ('0011','0013','0040','0060'))
	or (hvorg in ('Z350') and tvorg in ('0020'))
	or (hvorg in ('Z400') and tvorg in ('0020'))
	or (hvorg in ('Z410') and tvorg in ('0010'))
	or (hvorg in ('Z410') and tvorg in ('0020'))
	or (hvorg in ('Z420') and tvorg in ('0020'))
	or (hvorg in ('Z200') and tvorg in ('0020'))
	or (hvorg in ('Z450') and tvorg in ('0020') and (xblnr =''))
	or (hvorg in ('Z450') and tvorg in ('0060') and (XBLNR >'0'))) c

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


where c.budat between ADD_DAYS(LAST_DAY(ADD_MONTHS(CURRENT_DATE,-2)),1) and ADD_DAYS(LAST_DAY(ADD_MONTHS(CURRENT_DATE,-1)),1)

and d.ernam <> 'AGLBATCH'
and d.ernam <> 'WF-BATCH'
and d.ernam <> 'CRM_RFC'
and d.ernam <> 'MBLE_ISU_RFC'
and d.ernam <> 'XNWG_ISU_RFC'
and d.ernam <> 'WDEPCIAGL'
and d.ernam <> 'DATAMIGCNI11'
and d.ernam <> 'DATAMIGAPG04'

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
;

Select top 5 * --POTD ADJUSTMENTS

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
(
SELECT *
from"COMMERCIAL"."DFKKOP"
WHERE  (hvorg in ('Z450') and tvorg in ('0020') and (xblnr =''))
	or (hvorg in ('Z450') and tvorg in ('0060') and (XBLNR >'0'))) c

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


where c.budat between ADD_DAYS(LAST_DAY(ADD_MONTHS(CURRENT_DATE,-2)),1) and ADD_DAYS(LAST_DAY(ADD_MONTHS(CURRENT_DATE,-1)),1)

and d.ernam <> 'AGLBATCH'
and d.ernam <> 'WF-BATCH'
and d.ernam <> 'CRM_RFC'
and d.ernam <> 'MBLE_ISU_RFC'
and d.ernam <> 'XNWG_ISU_RFC'
and d.ernam <> 'WDEPCIAGL'
and d.ernam <> 'DATAMIGCNI11'
and d.ernam <> 'DATAMIGAPG04'

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

;

Select top 5 * --Write offs

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


where c.budat between ADD_DAYS(LAST_DAY(ADD_MONTHS(CURRENT_DATE,-2)),1) and ADD_DAYS(LAST_DAY(ADD_MONTHS(CURRENT_DATE,-1)),1)

and d.ernam <> 'AGLBATCH'
and d.ernam <> 'WF-BATCH'
and d.ernam <> 'CRM_RFC'
and d.ernam <> 'MBLE_ISU_RFC'
and d.ernam <> 'XNWG_ISU_RFC'
and d.ernam <> 'WDEPCIAGL'
and d.ernam <> 'DATAMIGCNI11'
and d.ernam <> 'DATAMIGAPG04'
and c.blart in ('WO','UB')

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

;

Select top 5 * --Transfers

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


where c.budat between ADD_DAYS(LAST_DAY(ADD_MONTHS(CURRENT_DATE,-2)),1) and ADD_DAYS(LAST_DAY(ADD_MONTHS(CURRENT_DATE,-1)),1)

and d.ernam <> 'AGLBATCH'
and d.ernam <> 'WF-BATCH'
and d.ernam <> 'CRM_RFC'
and d.ernam <> 'MBLE_ISU_RFC'
and d.ernam <> 'XNWG_ISU_RFC'
and d.ernam <> 'WDEPCIAGL'
and d.ernam <> 'DATAMIGCNI11'
and d.ernam <> 'DATAMIGAPG04'
and c.blart in ('TF')

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

;

Select top 5 * --INACTIVE ACCOUNT TRANSACTIONS

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
	cia.status as "Status",
	EMP."Full Name",
	EMP."Worker Position",
	EMP."Level 4 Org Unit",
	EMP."Level 5 Org Unit",
	EMP."Manager - Level 01"
	
FROM 
(
SELECT *
from"COMMERCIAL"."DFKKOP"
WHERE (hvorg in ('Z010') and tvorg in ('0020'))
	or (hvorg in ('Z010') and tvorg in ('0040'))
	or (hvorg in ('Z120') and tvorg in ('0580'))
	or (hvorg in ('Z120') and tvorg in ('0610'))
	or (hvorg in ('Z140') and tvorg in ('0530'))
	or (hvorg in ('Z141') and tvorg in ('0020'))
	or (hvorg in ('Z160') and tvorg in ('0120'))
	or (hvorg in ('Z160') and tvorg in ('0130'))
	or (hvorg in ('Z160') and tvorg in ('0140'))
	or (hvorg in ('Z160') and tvorg in ('0150'))
	or (hvorg in ('Z280') and tvorg in ('0020'))
	or (hvorg in ('Z800') and tvorg in ('0020','0040','0060','0100','0120'))
	or (hvorg in ('Z260') and tvorg in ('0011','0013','0040','0060'))
	or (hvorg in ('Z350') and tvorg in ('0020'))
	or (hvorg in ('Z400') and tvorg in ('0020'))
	or (hvorg in ('Z410') and tvorg in ('0010'))
	or (hvorg in ('Z410') and tvorg in ('0020'))
	or (hvorg in ('Z420') and tvorg in ('0020'))
	or (hvorg in ('Z200') and tvorg in ('0020'))
	or (hvorg in ('Z450') and tvorg in ('0020') and (xblnr =''))
	or (hvorg in ('Z450') and tvorg in ('0060') and (XBLNR >'0'))) c

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

left join "SP_CUSTOMER"."CIA_TheTruthAboutCustomer" cia

on substr(c.vtref,11,20) = cia.CONTRACT


where c.budat between ADD_DAYS(LAST_DAY(ADD_MONTHS(CURRENT_DATE,-2)),1) and ADD_DAYS(LAST_DAY(ADD_MONTHS(CURRENT_DATE,-1)),1)

and d.ernam <> 'AGLBATCH'
and d.ernam <> 'WF-BATCH'
and d.ernam <> 'CRM_RFC'
and d.ernam <> 'MBLE_ISU_RFC'
and d.ernam <> 'XNWG_ISU_RFC'
and d.ernam <> 'WDEPCIAGL'
and d.ernam <> 'DATAMIGCNI11'
and d.ernam <> 'DATAMIGAPG04'
and cia.status ='INACTIVE'

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
	cia.status,
	EMP."Full Name",
	EMP."Worker Position",
	EMP."Level 4 Org Unit",
	EMP."Level 5 Org Unit",
	EMP."Manager - Level 01"
) A
Order by A."Number" DESC

;

Select * -- Refunds over 25k

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


where c.budat between ADD_DAYS(LAST_DAY(ADD_MONTHS(CURRENT_DATE,-2)),1) and ADD_DAYS(LAST_DAY(ADD_MONTHS(CURRENT_DATE,-1)),1)
and c.blart in ('RB','RC','RQ')
and Abs(c.betrw) >= '25000'

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