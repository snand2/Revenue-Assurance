with BASE as
(
select *
from
	(
	SELECT  DISTINCT
       D."PARTNER",
     D."CONTRACT",
      TO_DATE(D."CREATED_DATE") AS CREATED_DATE,
      TO_DATE(D.proposed_date) AS proposed_date,
 Days_between(D.proposed_date,D."CREATED_DATE") as datediff,
   case when Days_between(D.proposed_date,D."CREATED_DATE") > 120 then '>120' else '<120' end as GREATER_THAN_120_DAYS,
   D."CREATION_TIME",
    D."PROCESS",
  D."AID",
      D.STATUS,
  D.MESSAGE,
      D.CONTACT_NOTE,
       D.USER_SEL,
       
      CASE
          WHEN CR."Location" IN ('Gandhinagar','Kolkata')
             THEN 'Service Delivery'
     
           WHEN CR."Location" IN ('Adelaide Corporate','Melbourne Corporate','Melbourne 664 Collins','Sydney','Canberra','BATHURST','CLARK TOWER C','CLARK TOWER D','Manila','Manila Tower B','Manila Tower A','Angeles')
            THEN 'Customer Service'
              
            WHEN USER_SEL <> ''
	              THEN 'Customer Service'
                                  
            ELSE 'Unknown'
       END AS Division
      
	FROM
       "COMMERCIAL"."ZCMKTT354" D
	JOIN
      (SELECT
	              A."PARTNER",
              A."CONTRACT",
           A."CREATED_DATE",
            MIN(A."CREATION_TIME") AS MAX_TIME
     FROM
            "COMMERCIAL"."ZCMKTT354" A
      JOIN
            (SELECT 
                    "PARTNER",
                  "CONTRACT",
                    MIN("CREATED_DATE") as MAX_DATE
            FROM
                    "COMMERCIAL"."ZCMKTT354"
              GROUP BY
                     "PARTNER",
                     "CONTRACT"
	              )B
       ON
            A."PARTNER" = B."PARTNER" AND
              A."CONTRACT" = B."CONTRACT" AND
              A."CREATED_DATE" = B."MAX_DATE"
       GROUP BY
              A."PARTNER",
            A."CONTRACT",
              A."CREATED_DATE"
       )C
	ON
	       D."PARTNER" = C."PARTNER" AND
       D."CONTRACT" = C."CONTRACT" AND
       D."CREATED_DATE" = C."CREATED_DATE" AND
       D."CREATION_TIME" =  C."MAX_TIME"
       
	LEFT JOIN
	       SP_COMMERCIAL.AID CR
       ON
       CR.ANUMBER = D.AID 
	WHERE
      D."PROCESS" = 'BDMO' --AND
        --TO_DATE(D.CREATED_DATE) BETWEEN ADD_DAYS(CURRENT_DATE, -365) AND ADD_DAYS(CURRENT_DATE, -WEEKDAY(CURRENT_DATE) -2)
	)
	where datediff > '120'
	and created_date between '20200701' and '20210630'
	)
	
	,MOVEINANDOUT AS
	(
	select *
	from
(
select distinct a.contract as OLD_CONTRACT,
	            d.anlage as INSTALLATION, 
           a.created_date,
           a.proposed_date,
            a.process, 
           c.VERTRAG as NEW_CONTRACT, 
	            D.AUSZDAT as MOVEOUTDATE_OLD_CONTRACT,
           c.EINZDAT as MOVEINDATE_NEW_CONTRACT,
            tac.contract,
	            tac.bptype as NEW_CONTRACT_BPYTPE,
	            tac.businesspartner,
	            rank() over(partition by a.contract, c.EINZDAT  order by created_date desc) as rn
	from
	(
	      (select contract,created_date,cast(proposed_date as date) as proposed_date,process
	      from "COMMERCIAL"."ZCMKTT354" 
	      where process = 'BDMO' 
	      and created_date >= '20210726') a     
	      
	      join "COMMERCIAL"."EVER" d
	      on a.contract = d.VERTRAG
	      and d.anlage <> ''
	      
	      join  "COMMERCIAL"."EVER" c on c.anlage = d.anlage  
	      and  c.einzdat between d.auszdat and add_days(d.auszdat,90)
	      and d.auszdat < current_date
) 
	
	left join "SP_CUSTOMER"."CIA_TheTruthAboutCustomer" tac
on tac.contract = c.vertrag

where tac.bptype = 'Consumer'
)
	where RN = 1
	)
	
	,MSAT as
(
	select *
	from
	(
	SELECT distinct a.NMI, a.STARTDATE,a.ENDDATE, a.NMISTATUSCODE, a.FRMP, tac.contract, a.rn
	from 
	(select NMI, STARTDATE,ENDDATE, NMISTATUSCODE, FRMP , rank() over(partition by NMI order by ENDDATE desc) as rn
	
	FROM "DATAINT"."TBL_NMISTANDINGDATA" WHERE FRMP in ('SOLARIS', 'AGLE', 'AES', 'PULSE', 'ERGON', 'AGLQLD2', 'CLICK')
	
	--and ENDDATE = '99991231'
	--and NMISTATUSCODE = 'A'
	ORDER BY ENDDATE DESC  ) a
	
	left join "SP_CUSTOMER"."CIA_TheTruthAboutCustomer" tac
	on left(tac.NMI,10) = a.NMI
	)
	where rn = 1
	
	)
	
	select  CREATed_DATE, 
	            count(*) as CONTRACT, 
	          (count(*)*326*0.7) as DEBT_AVOIDED, --326 = average debt saved, 70% = portion of NON AGL Error
	          (360459/92) as DAILY_TARGET
	from
	(
	select  base.*,
	            msat.*,
	            tac.fuel
	from base
	left join MOVEINANDOUT
	on base.partner = moveinandout.businesspartner
	and base.contract = moveinandout.old_contract
	
	left join MSAT
	on MSAT.contract = base.contract
	
	
	left join "SP_CUSTOMER"."CIA_TheTruthAboutCustomer" tac
	on base.contract = tac.contract
	and base.partner = tac.businesspartner
	
	where moveinandout.old_contract is null
	and (NMISTATUSCODE = 'A' or (NMISTATUSCODE is null and tac.fuel = 'GAS'))
	)
	group by created_DATE
	;
