select distinct
	c.opbel as "Document_Number",
	c.gpart as "Business_Partner",
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
	a.IDNUMBER


FROM "COMMERCIAL"."DFKKOP" c

join "COMMERCIAL"."DFKKKO" d

on c.OPBEL = d.OPBEL

join "CUSTOMER"."CRM_BUT0ID" a

on a.PARTNER = c.GPART

and a.TYPE = 'ZEMP'

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


where c.budat >= '20200701'
and d.ernam <> 'AGLBATCH'
and d.ernam <> 'WF-BATCH'
and d.ernam <> 'CRM_RFC'
and d.ernam <> 'MBLE_ISU_RFC'
and d.ernam <> 'XNWG_ISU_RFC'
and d.ernam <> 'WDEPCIAGL'
and d.ernam <> 'DATAMIGCNI11'
and d.ernam <> 'DATAMIGAPG04'
and d.ernam = a.IDNUMBER

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
c.betrw,
c.xblnr,
d.ernam,
a.IDNUMBER,
d.herkf
