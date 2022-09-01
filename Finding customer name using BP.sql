select

    UPPER(BUT000.NAME_LAST) AS Last_Name,
    UPPER(BUT000.NAME_FIRST) AS First_Name,
    UPPER(BUT000.NAME_ORG1) AS Business_Name,
    
    
    from customer.fkkkvkp
    	  left join 		CUSTOMER.ISU_BUT000 BUT000
	  		 ON				CUST.GPART = BUT000.PARTNER
	  		 
	  		 where customer.gpart
	  		 in (