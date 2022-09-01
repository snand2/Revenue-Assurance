
select distinct a.contract,a.created_date,a.proposed_date,a.process,b.zzbill_amount,b.vertrag,b.endabrpe,b.stornodat
from 
(
(select contract,created_date,cast(proposed_date as date) as proposed_date,process
from "COMMERCIAL"."ZCMKTT354" where process = 'BDMO' and created_date between '20180701' and '20190630') a      
join 
(select zzbill_amount,vertrag,endabrpe,stornodat from commercial.erch 
join commercial.erchc on erch.belnr = erchc.belnr and erch.vertrag = '9051461383'
where simulation = '') b
on a.contract = b.vertrag
)
where b.endabrpe > a.proposed_date and b.stornodat >= a.created_date

----------------------------------------------------
Find the contract that had a BDMO, find the installation, check in ever table that started from the proposed date. Within 3 months of the moveout date of the old contract.

select distinct x.contract,x.contractaccountnumber, x.contractaccountcreated,a.nmi,b.contract, c.CLEARINGDATE,d.ZZ_CURR_CHGS,c.CLEARINGREASON,b.proposed_date,
x.moveoutdate,x.moveindate,a.moveoutdate, a.moveindate,b.created_date,d.OPBEL , a.bptype , x.bptype
from
(
select distinct contractaccountnumber, contractaccountcreated, contract, CONTRACTCREATED, nmi, moveoutdate, moveindate, contractreversal_flag, bptype,installation
FROM "SP_CUSTOMER"."CIA_TheTruthAboutCustomer" where NMI <> '' ) a
join
(select distinct contract,created_date,proposed_date,process 
from "COMMERCIAL"."ZCMKTT354" 
where process = 'BDMO' and created_date between '20180701' and '20190630' and contract <> '') b
on a.contract = b.contract
join
(select distinct contractaccountnumber, contractaccountcreated, contract, CONTRACTCREATED, nmi, moveoutdate, moveindate, contractreversal_flag, bptype,installation
FROM "SP_CUSTOMER"."CIA_TheTruthAboutCustomer" where NMI <> '' ) x on
(x.nmi = a.nmi)
join
(select distinct rank() over(partition by VERTRAG order by endabrpe desc) as rn2, *
from "COMMERCIAL"."ERCH" e
where e.simulation = '' and e.stornodat = '00000000')e
 on e.vertrag = x.contract
 and rn2= 1
 join 
 "COMMERCIAL"."ERCHC" ec on ec.belnr = e.belnr
join 
"COMMERCIAL"."ERDK" d
on d.opbel = ec.opbel
LEFT join
(select distinct contract,CLEARINGDATE,INVOICEAMOUNT,CLEARINGREASON,rank() over(partition by INVOICEDOCUMENT order by invoiceduedate desc) as rn, invoicedocument
from "SP_COMMERCIAL"."CIA_TheTruthAboutBilling" where  CLEARINGREASON = '01') c
on c.invoicedocument = d.OPBEL

 where x.contract <> b.contract
and x.moveindate > cast(b.proposed_date as date )

New contract movein after od contract moveout

select distinct a.contract,d.anlage, a.created_date,a.proposed_date,a.process, c.VERTRAG, D.AUSZDAT,c.EINZDAT
from 
(
(select contract,created_date,cast(proposed_date as date) as proposed_date,process
from "COMMERCIAL"."ZCMKTT354" where process = 'BDMO' and created_date between '20180701' and '20180731') a      
join "COMMERCIAL"."EVER" d
on a.contract = d.VERTRAG
and d.anlage <> ''
join  "COMMERCIAL"."EVER" c on c.anlage = d.anlage   
and  c.einzdat between d.auszdat and add_days(d.auszdat,90)
and d.auszdat < current_date
)

Deceased
select contract , moveoutdate , businesspartner , installation, ACCOUNTCLASS,SPECIALCASE
FROM "SP_CUSTOMER"."CIA_TheTruthAboutCustomer"
where ACCOUNTCLASS = 'DECE' and SPECIALCASE = 'Insolvency/Deceased'
and contract in
C&I
select BEGRU,vertrag
from "COMMERCIAL"."EVER"
WHERE BEGRU = 'ZCNI'

Concessions table name - CUSTOMER.ECONCARD  




Historical BDMO

select a.* from commercial.ever a join (
select * from commercial.ever where erdat > einzdat and einzdat <> '00000000' and erdat between '20150701' and '20160630' --> BDMI
)b
on a.anlage = b.anlage
and a.auszdat = add_days(b.einzdat,-1)
and a.vertrag <> b.vertrag

b.erdat is the creation date
 
 a.auszdat is the proposed date
 
 
Active inactive status
select distinct A.NMI , A.contract, A.status , A.RN , a.type , a.bptype,a.fuel
from 
(SELECT NMI , contract ,moveoutdate ,  status, type,bptype,fuel, rank() over(partition by contract order by moveoutdate desc) as rn
from "SP_CUSTOMER"."CIA_TheTruthAboutCustomer"
WHERE contract in
