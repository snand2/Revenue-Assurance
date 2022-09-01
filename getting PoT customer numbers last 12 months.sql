Select

*,
substring(a.applicdate,0,7) as "Calmonth" 

from
(
Select
CURRENT_DATE as Applicdate,
count (*)
from	
commercial.everh everh

inner join         
SP_COMMERCIAL.GEEKII_REF_PRODUCT_LIST PROD
ON 
EVERH.CRM_PRODUCT = PROD.CRM_PRODUCT

where
everh.bis >= CURRENT_DATE
and
 prod.POT_DISC_PERC !=0

Union 

Select
add_days(CURRENT_DATE, -31) as Applicdate,
count (*)
from	
commercial.everh everh

inner join         
SP_COMMERCIAL.GEEKII_REF_PRODUCT_LIST PROD
ON 
EVERH.CRM_PRODUCT = PROD.CRM_PRODUCT

where
everh.bis >= add_days(CURRENT_DATE, -31)
and
 prod.POT_DISC_PERC !=0
 
 Union
 
 Select
add_days(CURRENT_DATE, -61) as Applicdate,
count (*)
from	
commercial.everh everh

inner join         
SP_COMMERCIAL.GEEKII_REF_PRODUCT_LIST PROD
ON 
EVERH.CRM_PRODUCT = PROD.CRM_PRODUCT

where
everh.bis >= add_days(CURRENT_DATE, -61)
and
 prod.POT_DISC_PERC !=0
 
 Union
 
  Select
add_days(CURRENT_DATE, -92) as Applicdate,
count (*)
from	
commercial.everh everh

inner join         
SP_COMMERCIAL.GEEKII_REF_PRODUCT_LIST PROD
ON 
EVERH.CRM_PRODUCT = PROD.CRM_PRODUCT

where
everh.bis >= add_days(CURRENT_DATE, -92)
and
 prod.POT_DISC_PERC !=0
 
 Union
 
   Select
add_days(CURRENT_DATE, -122) as Applicdate,
count (*)
from	
commercial.everh everh

inner join         
SP_COMMERCIAL.GEEKII_REF_PRODUCT_LIST PROD
ON 
EVERH.CRM_PRODUCT = PROD.CRM_PRODUCT

where
everh.bis >= add_days(CURRENT_DATE, -122)
and
 prod.POT_DISC_PERC !=0
 
 Union
 
    Select
add_days(CURRENT_DATE, -153) as Applicdate,
count (*)
from	
commercial.everh everh

inner join         
SP_COMMERCIAL.GEEKII_REF_PRODUCT_LIST PROD
ON 
EVERH.CRM_PRODUCT = PROD.CRM_PRODUCT

where
everh.bis >= add_days(CURRENT_DATE, -153)
and
 prod.POT_DISC_PERC !=0
 
  Union
 
    Select
add_days(CURRENT_DATE, -183) as Applicdate,
count (*)
from	
commercial.everh everh

inner join         
SP_COMMERCIAL.GEEKII_REF_PRODUCT_LIST PROD
ON 
EVERH.CRM_PRODUCT = PROD.CRM_PRODUCT

where
everh.bis >= add_days(CURRENT_DATE, -183)
and
 prod.POT_DISC_PERC !=0
 
   Union
 
    Select
add_days(CURRENT_DATE, -214) as Applicdate,
count (*)
from	
commercial.everh everh

inner join         
SP_COMMERCIAL.GEEKII_REF_PRODUCT_LIST PROD
ON 
EVERH.CRM_PRODUCT = PROD.CRM_PRODUCT

where
everh.bis >= add_days(CURRENT_DATE, -214)
and
 prod.POT_DISC_PERC !=0

   Union
 
    Select
add_days(CURRENT_DATE, -244) as Applicdate,
count (*)
from	
commercial.everh everh

inner join         
SP_COMMERCIAL.GEEKII_REF_PRODUCT_LIST PROD
ON 
EVERH.CRM_PRODUCT = PROD.CRM_PRODUCT

where
everh.bis >= add_days(CURRENT_DATE, -244)
and
 prod.POT_DISC_PERC !=0
 
   Union
 
    Select
add_days(CURRENT_DATE, -275) as Applicdate,
count (*)
from	
commercial.everh everh

inner join         
SP_COMMERCIAL.GEEKII_REF_PRODUCT_LIST PROD
ON 
EVERH.CRM_PRODUCT = PROD.CRM_PRODUCT

where
everh.bis >= add_days(CURRENT_DATE, -275)
and
 prod.POT_DISC_PERC !=0
 
    Union
 
    Select
add_days(CURRENT_DATE, -305) as Applicdate,
count (*)
from	
commercial.everh everh

inner join         
SP_COMMERCIAL.GEEKII_REF_PRODUCT_LIST PROD
ON 
EVERH.CRM_PRODUCT = PROD.CRM_PRODUCT

where
everh.bis >= add_days(CURRENT_DATE, -305)
and
 prod.POT_DISC_PERC !=0
 
     Union
 
    Select
add_days(CURRENT_DATE, -336) as Applicdate,
count (*)
from	
commercial.everh everh

inner join         
SP_COMMERCIAL.GEEKII_REF_PRODUCT_LIST PROD
ON 
EVERH.CRM_PRODUCT = PROD.CRM_PRODUCT

where
everh.bis >= add_days(CURRENT_DATE, -336)
and
 prod.POT_DISC_PERC !=0
 
      Union
 
    Select
add_days(CURRENT_DATE, -366) as Applicdate,
count (*)
from	
commercial.everh everh

inner join         
SP_COMMERCIAL.GEEKII_REF_PRODUCT_LIST PROD
ON 
EVERH.CRM_PRODUCT = PROD.CRM_PRODUCT

where
everh.bis >= add_days(CURRENT_DATE, -366)
and
 prod.POT_DISC_PERC !=0
  
)a
