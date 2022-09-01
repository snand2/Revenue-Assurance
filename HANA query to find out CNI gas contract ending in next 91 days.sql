

Select top 1000 
vertrag as Contract,
anlage as Installation,
vkonto as Contract_Account,
sparte as fuel,
ABRSPERR as Bill_Block_Reason,
EINZDAT as Move_In_Date,
AUSZDAT as Move_Out_Date,
begru as Account_class
from commercial.ever
where begru = 'ZCNI'
and sparte = '02'
and to_date(auszdat) between current_date and add_days(current_date,91)
order by auszdat desc
