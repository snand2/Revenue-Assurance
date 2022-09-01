SELECT *,
    ROW_NUMBER() OVER (PARTITION BY
    "Business_Partner",
    "Contract_Account_Number",
    "Contract"
    ORDER BY "Posting_Date" DESC) AS RN

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
	CPROD."Prod Description" as "Current Product",
	CPROD."POTD Percentage" as "Current POTD Percentage",
	APROD."Prod Description" as "Product at post date",
	APROD."POTD Percentage" as "POTD Percentage as of Posting",
	d.herkf as "Origin",
	EMP."Full Name",
	EMP."Worker Position",
	EMP."Call Centre Type",
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
SP_COMMERCIAL.A116627_RA_EMPLIST EMP
on d.ernam = EMP.ANUMBER

LEFT JOIN

(
	Select 
		EVERH.Vertrag as "Contract",
		EVERH.AB as "Start Date",
		EVERH.BIS as "End Date",
		EVERH.CRM_PRODUCT as "Product",
		EVERH.CRM_ITEM_DESCR as "Prod Description",
		PROD.POT_DISC_PERC as "POTD Percentage"
	from COMMERCIAL.EVERH EVERH

	LEFT JOIN
	SP_COMMERCIAL.GEEKII_REF_PRODUCT_LIST PROD
	ON EVERH.CRM_PRODUCT = PROD.CRM_PRODUCT

) CPROD
on substr(c.vtref,11,20) = CPROD."Contract"
AND Current_date between CPROD."Start Date" and CPROD."End Date"

LEFT JOIN

(
	Select 
		EVERH.Vertrag as "Contract",
		EVERH.AB as "Start Date",
		EVERH.BIS as "End Date",
		EVERH.CRM_PRODUCT as "Product",
		EVERH.CRM_ITEM_DESCR as "Prod Description",
		PROD.POT_DISC_PERC as "POTD Percentage"
	from COMMERCIAL.EVERH EVERH

	LEFT JOIN
	SP_COMMERCIAL.GEEKII_REF_PRODUCT_LIST PROD
	ON EVERH.CRM_PRODUCT = PROD.CRM_PRODUCT

) APROD
on substr(c.vtref,11,20) = APROD."Contract"
AND to_date(c.budat) between APROD."Start Date" and APROD."End Date"


where c.budat between ADD_DAYS(LAST_DAY(ADD_MONTHS(CURRENT_DATE,-12)),1) and CURRENT_DATE

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
	CPROD."Prod Description",
	CPROD."POTD Percentage",
	APROD."Prod Description",
	APROD."POTD Percentage",
	EMP."Full Name",
	EMP."Worker Position",
	EMP."Call Centre Type",
	EMP."Level 4 Org Unit",
	EMP."Level 5 Org Unit",
	EMP."Manager - Level 01"
) A
Order by RN DESC
