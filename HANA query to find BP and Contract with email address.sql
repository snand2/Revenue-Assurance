Select
B.PARTNER as PARTNER,
A.SMTP_ADDR as EMAIL,
D.VERTRAG as ACTIVE_CONTRACT
from customer.CRM_ADR6 A
INNER JOIN commercial.ISU_BUT021_FS B
on A.ADDRNUMBER = B.ADDRNUMBER
INNER JOIN customer.fkkvkp C
on C.GPART = B.PARTNER
INNER JOIN commercial.ever D
on C.VKONT = D.VKONTO
where A.SMTP_ADDR = 'none@none@agl.com.au'
and D.AUSZDAT = '99991231'