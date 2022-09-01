Select 

*,
substring(a.applicdate,0,7) as "Calendar month" 

from
(
Select
CURRENT_DATE as Applicdate,
count (*)
from
commercial.ever ever
inner join	
commercial.everh everh
on
ever.vertrag = everh.vertrag

inner join         
SP_COMMERCIAL.GEEKII_REF_PRODUCT_LIST PROD
ON 
EVERH.CRM_PRODUCT = PROD.CRM_PRODUCT

where
	ever.auszdat >= CURRENT_DATE
and
	everh.bis >= CURRENT_DATE
and 
	prod.POT_DISC_PERC is not null
and
 	prod.POT_DISC_PERC !=0

union

Select
add_months(CURRENT_DATE, -1) as Applicdate,
count (*)
from
commercial.ever ever
inner join	
commercial.everh everh
on
ever.vertrag = everh.vertrag

inner join         
SP_COMMERCIAL.GEEKII_REF_PRODUCT_LIST PROD
ON 
EVERH.CRM_PRODUCT = PROD.CRM_PRODUCT

where
	ever.auszdat >= add_months(CURRENT_DATE, -1)
and
	everh.bis >= add_months(CURRENT_DATE, -1)
and 
	prod.POT_DISC_PERC is not null
and
 	prod.POT_DISC_PERC !=0
 	
 union

Select
add_months(CURRENT_DATE, -2) as Applicdate,
count (*)
from
commercial.ever ever
inner join	
commercial.everh everh
on
ever.vertrag = everh.vertrag

inner join         
SP_COMMERCIAL.GEEKII_REF_PRODUCT_LIST PROD
ON 
EVERH.CRM_PRODUCT = PROD.CRM_PRODUCT

where
	ever.auszdat >= add_months(CURRENT_DATE, -2)
and
	everh.bis >= add_months(CURRENT_DATE, -2)
and 
	prod.POT_DISC_PERC is not null
and
 	prod.POT_DISC_PERC !=0
 	
 union

Select
add_months(CURRENT_DATE, -3) as Applicdate,
count (*)
from
commercial.ever ever
inner join	
commercial.everh everh
on
ever.vertrag = everh.vertrag

inner join         
SP_COMMERCIAL.GEEKII_REF_PRODUCT_LIST PROD
ON 
EVERH.CRM_PRODUCT = PROD.CRM_PRODUCT

where
	ever.auszdat >= add_months(CURRENT_DATE, -3)
and
	everh.bis >= add_months(CURRENT_DATE, -3)
and 
	prod.POT_DISC_PERC is not null
and
 	prod.POT_DISC_PERC !=0
 	
 union

Select
add_months(CURRENT_DATE, -4) as Applicdate,
count (*)
from
commercial.ever ever
inner join	
commercial.everh everh
on
ever.vertrag = everh.vertrag

inner join         
SP_COMMERCIAL.GEEKII_REF_PRODUCT_LIST PROD
ON 
EVERH.CRM_PRODUCT = PROD.CRM_PRODUCT

where
	ever.auszdat >= add_months(CURRENT_DATE, -4)
and
	everh.bis >= add_months(CURRENT_DATE, -4)
and 
	prod.POT_DISC_PERC is not null
and
 	prod.POT_DISC_PERC !=0
 	
 union

Select
add_months(CURRENT_DATE, -5) as Applicdate,
count (*)
from
commercial.ever ever
inner join	
commercial.everh everh
on
ever.vertrag = everh.vertrag

inner join         
SP_COMMERCIAL.GEEKII_REF_PRODUCT_LIST PROD
ON 
EVERH.CRM_PRODUCT = PROD.CRM_PRODUCT

where
	ever.auszdat >= add_months(CURRENT_DATE, -5)
and
	everh.bis >= add_months(CURRENT_DATE, -5)
and 
	prod.POT_DISC_PERC is not null
and
 	prod.POT_DISC_PERC !=0

 union

Select
add_months(CURRENT_DATE, -6) as Applicdate,
count (*)
from
commercial.ever ever
inner join	
commercial.everh everh
on
ever.vertrag = everh.vertrag

inner join         
SP_COMMERCIAL.GEEKII_REF_PRODUCT_LIST PROD
ON 
EVERH.CRM_PRODUCT = PROD.CRM_PRODUCT

where
	ever.auszdat >= add_months(CURRENT_DATE, -6)
and
	everh.bis >= add_months(CURRENT_DATE, -6)
and 
	prod.POT_DISC_PERC is not null
and
 	prod.POT_DISC_PERC !=0
 	
 union

Select
add_months(CURRENT_DATE, -7) as Applicdate,
count (*)
from
commercial.ever ever
inner join	
commercial.everh everh
on
ever.vertrag = everh.vertrag

inner join         
SP_COMMERCIAL.GEEKII_REF_PRODUCT_LIST PROD
ON 
EVERH.CRM_PRODUCT = PROD.CRM_PRODUCT

where
	ever.auszdat >= add_months(CURRENT_DATE, -7)
and
	everh.bis >= add_months(CURRENT_DATE, -7)
and 
	prod.POT_DISC_PERC is not null
and
 	prod.POT_DISC_PERC !=0
 	
 union

Select
add_months(CURRENT_DATE, -8) as Applicdate,
count (*)
from
commercial.ever ever
inner join	
commercial.everh everh
on
ever.vertrag = everh.vertrag

inner join         
SP_COMMERCIAL.GEEKII_REF_PRODUCT_LIST PROD
ON 
EVERH.CRM_PRODUCT = PROD.CRM_PRODUCT

where
	ever.auszdat >= add_months(CURRENT_DATE, -8)
and
	everh.bis >= add_months(CURRENT_DATE, -8)
and 
	prod.POT_DISC_PERC is not null
and
 	prod.POT_DISC_PERC !=0
 
 union 
 	
Select
add_months(CURRENT_DATE, -9) as Applicdate,
count (*)
from
commercial.ever ever
inner join	
commercial.everh everh
on
ever.vertrag = everh.vertrag

inner join         
SP_COMMERCIAL.GEEKII_REF_PRODUCT_LIST PROD
ON 
EVERH.CRM_PRODUCT = PROD.CRM_PRODUCT

where
	ever.auszdat >= add_months(CURRENT_DATE, -9)
and
	everh.bis >= add_months(CURRENT_DATE, -9)
and 
	prod.POT_DISC_PERC is not null
and
 	prod.POT_DISC_PERC !=0

 union

Select
add_months(CURRENT_DATE, -10) as Applicdate,
count (*)
from
commercial.ever ever
inner join	
commercial.everh everh
on
ever.vertrag = everh.vertrag

inner join         
SP_COMMERCIAL.GEEKII_REF_PRODUCT_LIST PROD
ON 
EVERH.CRM_PRODUCT = PROD.CRM_PRODUCT

where
	ever.auszdat >= add_months(CURRENT_DATE, -10)
and
	everh.bis >= add_months(CURRENT_DATE, -10)
and 
	prod.POT_DISC_PERC is not null
and
 	prod.POT_DISC_PERC !=0
 	
 union

Select
add_months(CURRENT_DATE, -11) as Applicdate,
count (*)
from
commercial.ever ever
inner join	
commercial.everh everh
on
ever.vertrag = everh.vertrag

inner join         
SP_COMMERCIAL.GEEKII_REF_PRODUCT_LIST PROD
ON 
EVERH.CRM_PRODUCT = PROD.CRM_PRODUCT

where
	ever.auszdat >= add_months(CURRENT_DATE, -11)
and
	everh.bis >= add_months(CURRENT_DATE, -11)
and 
	prod.POT_DISC_PERC is not null
and
 	prod.POT_DISC_PERC !=0 	

union

Select
add_months(CURRENT_DATE, -12) as Applicdate,
count (*)
from
commercial.ever ever
inner join	
commercial.everh everh
on
ever.vertrag = everh.vertrag

inner join         
SP_COMMERCIAL.GEEKII_REF_PRODUCT_LIST PROD
ON 
EVERH.CRM_PRODUCT = PROD.CRM_PRODUCT

where
	ever.auszdat >= add_months(CURRENT_DATE, -12)
and
	everh.bis >= add_months(CURRENT_DATE, -12)
and 
	prod.POT_DISC_PERC is not null
and
 	prod.POT_DISC_PERC !=0 	 	
 	
)a
