
Select 

	C.POD,
	C.INSTALLATION_UEC,
	C.UEC_CONTRACT,
	C.UEC_MOVE_IN,
	C.UEC_MOVE_OUT,
	C.CUSTOMER_TYPE,
	C.UEC_ACCOUNT,
	C.UEC_ACCOUNT_CLASS,
	C.CUST_TYPE,
	C.STATE,
	UBA.UB_AUTO_LINE_ITEM,
	UBA.UB_AUTO_AMOUNT,
	UB.MAIN,
	UB.SUB,
	UB.Posting_date,
	UB.UB_amount,
	D.WRITE_OFF_CONTRACT,
	D.WRITE_OFF_DATE,
	D.WRITE_OFF_AMOUNT,
	DBT.UEC_BALANCE,
	DBT.UEC_DEBTPROVISION
	
From


(select --Bringing in UEC data 
	POD.EXT_UI as POD,
	EV2.ANLAGE as INSTALLATION_UEC,
	EV2.VERTRAG as UEC_CONTRACT,
	TO_DATE (EV2.EINZDAT) as UEC_MOVE_IN,
	TO_DATE (EV2.AUSZDAT) as UEC_MOVE_OUT,
	FK.KTOKL as CUSTOMER_TYPE,
	substr (FK.VKONT,3,12) as UEC_ACCOUNT,
	te.text50 as UEC_ACCOUNT_CLASS,
	Case 
		When (te.text50) like '%Residential%' then 'Residential'
		When (te.text50) like '%Business%' then 'Business'
		else 'Unknown'
	End as CUST_TYPE,
	Case 
		When (te.text50) like '%VIC%' then 'Victoria'
		When (te.text50) like '%NSW%' then 'New South Wales'
		When (te.text50) like '%QLD%' then 'Queensland'
		When (te.text50) like '%SA%' then 'South Australia'
		else 'Unknown'
	End as STATE

FROM
COMMERCIAL.EVER EV2

LEFT JOIN
CUSTOMER.FKKVKP FK
on EV2.VKONTO = FK.VKONT

Left Join
open.te097AT te
on EV2.kofiz = te.kofiz
and SPRAS ='E'

Left Join
COMMERCIAL.EUIINSTLN INST2
on EV2.ANLAGE = INST2.ANLAGE

Left Join
CUSTOMER.EUITRANS POD
on INST2.INT_UI = POD.INT_UI


where
FK.KTOKL = 'DCUS' --UEC account type
and EV2.EINZDAT <> '00000000' --excludes reversed accounts
and EV2.AUSZDAT <> '00000000') C

Left join 

(Select   --Bringing in Unbillable Consumption auto data

	db1.belzart as UB_AUTO_LINE_ITEM,
	abs(db3.NETTOBTR) as UB_AUTO_AMOUNT,
	ever.vertrag as UB_AUTO_CONTRACT


from dataint.tbl_sapisu_dberchz1 db1 -- table that has line items
inner join 
dataint.tbl_sapisu_dberchz3 db3  --joining in table that has pricing info
on db1.BELNR = db3.BELNR 
and db1.BELZEILE = db3.BELZEILE 
inner join
commercial.erch erch
on db3.belnr = erch.belnr 
and erch.stornodat ='00000000' -- no reversal date, not reversed

inner join
commercial.ever ever --bringing in contract for installation for line item matches
on erch.vertrag = ever.vertrag

Where db1.belzart = 'ZCWODA') UBA
on C.UEC_CONTRACT = UBA.UB_AUTO_CONTRACT 

Left Join

(Select --Bringing in Unbillable consumption manual data
substr (VTREF,11,20) as UB_CONTRACT,
HVORG as MAIN,
TVORG as SUB,
BUDAT as Posting_date,
abs(betrw) as UB_amount

from commercial.dfkkop

where
hvorg = 'Z200' and tvorg = '0020') UB

on C.UEC_CONTRACT = UB.UB_CONTRACT

Left Join
(
Select --Bringing in write off data
	CONTRACT as WRITE_OFF_CONTRACT,
	WRITEOFFDATE as WRITE_OFF_DATE,
	WRITEOFFAMOUNTINCGST as WRITE_OFF_AMOUNT

from SP_COMMERCIAL.CIA_THETRUTHABOUTWRITEOFF
) D
On C.UEC_CONTRACT = D.WRITE_OFF_CONTRACT

Left Join

(
SELECT
	substr(CONTRACTACCOUNTNUMBER,3,12) as D_UEC_AC,
	CONTRACT,
	TOTALBALANCE as UEC_BALANCE,
	TOTALPROVISION as UEC_DEBTPROVISION
FROM "SP_COMMERCIAL"."CIA_TheTruthAboutDebt") DBT
on C.UEC_CONTRACT = DBT.CONTRACT


Where C.UEC_MOVE_IN >= '20210831'


; -- Move to second result for comparison period

Select 

	C.POD,
	C.INSTALLATION_UEC,
	C.UEC_CONTRACT,
	C.UEC_MOVE_IN,
	C.UEC_MOVE_OUT,
	C.CUSTOMER_TYPE,
	C.UEC_ACCOUNT,
	C.UEC_ACCOUNT_CLASS,
	C.CUST_TYPE,
	C.STATE,
	UBA.UB_AUTO_LINE_ITEM,
	UBA.UB_AUTO_AMOUNT,
	UB.MAIN,
	UB.SUB,
	UB.Posting_date,
	UB.UB_amount,
	D.WRITE_OFF_CONTRACT,
	D.WRITE_OFF_DATE,
	D.WRITE_OFF_AMOUNT,
	DBT.UEC_BALANCE,
	DBT.UEC_DEBTPROVISION
	
From


(select --Bringing in UEC data 
	POD.EXT_UI as POD,
	EV2.ANLAGE as INSTALLATION_UEC,
	EV2.VERTRAG as UEC_CONTRACT,
	TO_DATE (EV2.EINZDAT) as UEC_MOVE_IN,
	TO_DATE (EV2.AUSZDAT) as UEC_MOVE_OUT,
	FK.KTOKL as CUSTOMER_TYPE,
	substr (FK.VKONT,3,12) as UEC_ACCOUNT,
	te.text50 as UEC_ACCOUNT_CLASS,
	Case 
		When (te.text50) like '%Residential%' then 'Residential'
		When (te.text50) like '%Business%' then 'Business'
		else 'Unknown'
	End as CUST_TYPE,
	Case 
		When (te.text50) like '%VIC%' then 'Victoria'
		When (te.text50) like '%NSW%' then 'New South Wales'
		When (te.text50) like '%QLD%' then 'Queensland'
		When (te.text50) like '%SA%' then 'South Australia'
		else 'Unknown'
	End as STATE

FROM
COMMERCIAL.EVER EV2

LEFT JOIN
CUSTOMER.FKKVKP FK
on EV2.VKONTO = FK.VKONT

Left Join
open.te097AT te
on EV2.kofiz = te.kofiz
and SPRAS ='E'

Left Join
COMMERCIAL.EUIINSTLN INST2
on EV2.ANLAGE = INST2.ANLAGE

Left Join
CUSTOMER.EUITRANS POD
on INST2.INT_UI = POD.INT_UI


where
FK.KTOKL = 'DCUS' --UEC account type
and EV2.EINZDAT <> '00000000' --excludes reversed accounts
and EV2.AUSZDAT <> '00000000') C

Left join 

(Select   --Bringing in Unbillable Consumption auto data

	db1.belzart as UB_AUTO_LINE_ITEM,
	abs(db3.NETTOBTR) as UB_AUTO_AMOUNT,
	ever.vertrag as UB_AUTO_CONTRACT


from dataint.tbl_sapisu_dberchz1 db1 -- table that has line items
inner join 
dataint.tbl_sapisu_dberchz3 db3  --joining in table that has pricing info
on db1.BELNR = db3.BELNR 
and db1.BELZEILE = db3.BELZEILE 
inner join
commercial.erch erch
on db3.belnr = erch.belnr 
and erch.stornodat ='00000000' -- no reversal date, not reversed

inner join
commercial.ever ever --bringing in contract for installation for line item matches
on erch.vertrag = ever.vertrag

Where db1.belzart = 'ZCWODA') UBA
on C.UEC_CONTRACT = UBA.UB_AUTO_CONTRACT 

Left Join

(Select --Bringing in Unbillable consumption manual data
substr (VTREF,11,20) as UB_CONTRACT,
HVORG as MAIN,
TVORG as SUB,
BUDAT as Posting_date,
abs(betrw) as UB_amount

from commercial.dfkkop

where
hvorg = 'Z200' and tvorg = '0020') UB

on C.UEC_CONTRACT = UB.UB_CONTRACT

Left Join
(
Select --Bringing in write off data
	CONTRACT as WRITE_OFF_CONTRACT,
	WRITEOFFDATE as WRITE_OFF_DATE,
	WRITEOFFAMOUNTINCGST as WRITE_OFF_AMOUNT

from SP_COMMERCIAL.CIA_THETRUTHABOUTWRITEOFF
) D
On C.UEC_CONTRACT = D.WRITE_OFF_CONTRACT

Left Join

(
SELECT
	substr(CONTRACTACCOUNTNUMBER,3,12) as D_UEC_AC,
	CONTRACT,
	TOTALBALANCE as UEC_BALANCE,
	TOTALPROVISION as UEC_DEBTPROVISION
FROM "SP_COMMERCIAL"."CIA_TheTruthAboutDebt") DBT
on C.UEC_CONTRACT = DBT.CONTRACT


Where C.UEC_MOVE_IN between '20210301' and '20210331'
