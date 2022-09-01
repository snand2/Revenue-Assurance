Select 
	A.PARTNER as "BDMO Business Partner",
	A.CONTRACT as "BDMO Contract" ,
	A.CREATED_DATE as "BDMO Creation Date",
	A.FIN_YEAR as "Financial Year",
	A.PROPOSED_DATE as "BDMO Proposed Date",
	A.DATEDIFF as "Days Difference",
	A.DATE_BRACKET as "BDMO Days",
	A.CREATION_TIME as "BDMO Creation Time",
	A.PROCESS as "Process",
	A.AID as "A Number Created By",
	A.STATUS as "Status",
	RVE.OC_CONTRACT_NO as "Contracts bills reversed",
	RVE.OC_NUMBER_BILLS_REVERSED as "Number of Bills Reversed",
	RVE.OC_BILL_AMOUNT_REVERSED as "Amount of Billing Reversed",
	A.MESSAGE as "BDMO Message",
	A.CONTACT_NOTE as "Contact Note",
	A.USER_SEL as "User sel",
	B.INSTALLATION as "Installation Number",
	B.Fuel as "Fuel",
	C.UEC_ACCOUNT_CLASS as "Account Class",
	C.CUST_TYPE as "Busi Resi Status",
	C.STATE as "State",
	TO_DATE (B.MOVE_IN_DATE) as "BDMO Contract Move in Date",
	TO_DATE (B.MOVE_OUT_DATE) as "BDMO Contract Move out Date",
	B.POD as "NMI or MIRN", 
	C.UEC_CONTRACT as "UEC Contract",
	C.UEC_ACCOUNT as "UEC Account Number",
	C.UEC_MOVE_IN as "UEC Move in Date",
	C.UEC_MOVE_OUT as "UEC Move Out Date",
	Days_between(B.MOVE_OUT_DATE,C.UEC_MOVE_IN) as "Days between BDMO and UEC",
	D.UEC_WRITE_OFF_TOTAL as "UEC Write off Amount",
	UB.UB_amount as "UEC Unbillable Consumption Amount",
	UBA.UB_AUTO_AMOUNT as "UEC Unbillable Consumption auto amount",
	DBT.UEC_BALANCE as "UEC Current Balance",
	DBT.UEC_DEBTPROVISION as "UEC Debt Provision",
	VC.INSTALLATION as "Vacant Site Installation match",
  	VC.VACANTDATE as "Date on Vacant Site report",
  	VC.DAYSVACANT as "Days on Vacant Site report"
 from

(
select *
from
	(
SELECT  DISTINCT --Getting BDMO data
	D.PARTNER,
    D.CONTRACT,
    TO_DATE(D.CREATED_DATE) AS CREATED_DATE,
	case 
		when D.CREATED_DATE between '20170701' and '20180630' then 'FY18'
		when D.CREATED_DATE between '20180701' and '20190630' then 'FY19'
		when D.CREATED_DATE between '20190701' and '20200630' then 'FY20'
		when D.CREATED_DATE between '20200701' and '20210630' then 'FY21'
		when D.CREATED_DATE between '20210701' and '20220630' then 'FY22'
   		end as FIN_YEAR,
    TO_DATE(D.proposed_date) AS proposed_date,
 	Days_between(D.proposed_date,D.CREATED_DATE) as datediff,
	case 
		when Days_between(D.proposed_date,D.CREATED_DATE) <= 30 then '1. <30'
		when Days_between(D.proposed_date,D.CREATED_DATE) between 31 and 60  then '2. 31-60'
		when Days_between(D.proposed_date,D.CREATED_DATE) between 61 and 90  then '3. 61-90'
		when Days_between(D.proposed_date,D.CREATED_DATE) between 91 and 120  then '4. 91-120'
		when Days_between(D.proposed_date,D.CREATED_DATE) between 121 and 270  then '5. 121-270'
   		when Days_between(D.proposed_date,D.CREATED_DATE) > 270 then '6. >270' 
   		end as DATE_BRACKET, --Time bracket
   D.CREATION_TIME,
   D.PROCESS,
   D.AID,
   D.STATUS,
   D.MESSAGE,
   D.CONTACT_NOTE,
   D.USER_SEL
   
FROM COMMERCIAL.ZCMKTT354 D
JOIN
(
SELECT
	A.PARTNER,
	A.CONTRACT,
	A.CREATED_DATE,
	MIN(A.CREATION_TIME) AS MAX_TIME
FROM
COMMERCIAL.ZCMKTT354 A
JOIN
(
SELECT 
	PARTNER,
	CONTRACT,
	MIN(CREATED_DATE) as MAX_DATE
FROM
COMMERCIAL.ZCMKTT354
GROUP BY
	PARTNER,
CONTRACT ) B
ON  A.PARTNER = B.PARTNER 
AND A.CONTRACT = B.CONTRACT 
AND A.CREATED_DATE = B.MAX_DATE
GROUP BY
	A.PARTNER,
	A.CONTRACT,
	A.CREATED_DATE) C
ON  D.PARTNER = C.PARTNER 
AND D.CONTRACT = C.CONTRACT 
AND D.CREATED_DATE = C.CREATED_DATE 
AND D.CREATION_TIME =  C.MAX_TIME
	WHERE
      D."PROCESS" = 'BDMO' 

	)
	--where datediff > '120'
	where created_date between '20170701' and Current_date) A --date parameters
	
	Left join
	
(
Select  -- Bringing in contract, installation, move data, POD data for BDMO request
	EV.VERTRAG as CONTRACT_NO,
	EV.ANLAGE as INSTALLATION,
	EV.einzdat as MOVE_IN_DATE,
	EV.auszdat as MOVE_OUT_DATE,
	EV.VBEZ as FUEL,
	POD.EXT_UI as POD
	
	From commercial.ever EV

	left join
	COMMERCIAL.EUIINSTLN INST
	on EV.ANLAGE = INST.ANLAGE

	
	left join
	customer.euitrans POD
	on INST.INT_UI = POD.INT_UI
	Where EV.einzdat != '00000000'
	and EV.auszdat != '00000000'
	) B
	ON A.CONTRACT = B.CONTRACT_NO



Left Join

(
select --Bringing in UEC data 
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
and EV2.EINZDAT != '00000000' --excludes reversed accounts
and EV2.AUSZDAT != '00000000'

) C

on B.INSTALLATION = C.INSTALLATION_UEC
and C.UEC_MOVE_IN >= B.MOVE_OUT_DATE --Key condition	

LEFT JOIN 

(Select  --count of bills reversed and sum reversed for OG contract
	RV.OC_CONTRACT_NO as OC_CONTRACT_NO,
	COUNT(RV.OC_PRINT_DOC) as OC_NUMBER_BILLS_REVERSED,
	SUM(RV.OC_BILL_CHARGES) as OC_BILL_AMOUNT_REVERSED
from
(select distinct --Getting Billing info for reversals on contracts
	a.BILL_DOC_NUMBER as OC_BILL_DOC,
	a.PRINT_DOC_NUMBER as OC_PRINT_DOC,
	a.CONTRACT_NUMBER as OC_CONTRACT_NO,
	a.INSTALLATION_NUMBER as OC_INSTALLATION_NO,
	a.START_BILLING_PERIOD as OC_START_BILL_PD,
	a.END_BILLING_PERIOD as OC_END_BILL_PD,
	a.PRINT_DATE as OC_PRINT_DATE,
	a.DOCUMENT_REVERSED as OC_IS_REVERSED,
	a.REVERSAL_REASON as OC_RV_REASON,
	a.METER_READ_QUALITY_CODE as OC_MTR_RD_QUAL,
	a.IS_REBILL as OC_IS_REBILL,
	b.ZZ_CURR_CHGS as OC_BILL_CHARGES

from commercial.hnods_st_bill_all_bills a
Inner join
commercial.erdk b
on a.PRINT_DOC_NUMBER = b.opbel
where a.DOCUMENT_REVERSED ='X') RV

Group by RV.OC_CONTRACT_NO) RVE

on A.CONTRACT = RVE.OC_CONTRACT_NO


LEFT JOIN

(
Select --Sum of write off for EUC contract
	WO.WRITE_OFF_CONTRACT as WRITE_OFF_CONTRACT,
	SUM(WO.WRITE_OFF_AMOUNT) as UEC_WRITE_OFF_TOTAL

From
(
Select --Bringing in write off data
	CONTRACT as WRITE_OFF_CONTRACT,
	WRITEOFFDATE as WRITE_OFF_DATE,
	WRITEOFFAMOUNTINCGST as WRITE_OFF_AMOUNT

from SP_COMMERCIAL.CIA_THETRUTHABOUTWRITEOFF
) WO

Group by WO.WRITE_OFF_CONTRACT) D

On C.UEC_CONTRACT = D.WRITE_OFF_CONTRACT

LEFT JOIN
(
Select
	UBP.UB_CONTRACT as UB_CONTRACT,
	sum (UB_amount) as UB_amount
From
(
Select --Bringing in Unbillable consumption manual data
substr (VTREF,11,20) as UB_CONTRACT,
HVORG as MAIN,
TVORG as SUB,
BUDAT as Posting_date,
abs(betrw) as UB_amount

from commercial.dfkkop

where
hvorg = 'Z200' and tvorg = '0020') UBP

group by UBP.UB_CONTRACT) UB

on C.UEC_CONTRACT = UB.UB_CONTRACT

LEFT JOIN

(
Select
	UBAP.UB_AUTO_CONTRACT as UB_AUTO_CONTRACT,
	sum(UBAP.UB_AUTO_AMOUNT) as UB_AUTO_AMOUNT
From
(
Select   --Bringing in Unbillable Consumption auto data

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

Where db1.belzart = 'ZCWODA') UBAP

Group by UBAP.UB_AUTO_CONTRACT) UBA

on C.UEC_CONTRACT = UBA.UB_AUTO_CONTRACT 

Left join
(
SELECT
	substr(CONTRACTACCOUNTNUMBER,3,12) as D_UEC_AC,
	CONTRACT,
	TOTALBALANCE as UEC_BALANCE,
	TOTALPROVISION as UEC_DEBTPROVISION
FROM "SP_COMMERCIAL"."CIA_TheTruthAboutDebt") DBT
on C.UEC_CONTRACT = DBT.CONTRACT


left join

(select 
	INSTALLATION,
  	NMI,
  	VACANTDATE,
  	DAYSVACANT
from  "SP_COMMERCIAL"."CIA_UC_VACANT_SITE_EXTENDED") VC

on B.INSTALLATION = VC.INSTALLATION
and VC.VACANTDATE >= B.MOVE_OUT_DATE

order by A.PARTNER
