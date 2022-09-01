Select
B.PARTNER as PARTNER,
A.SMTP_ADDR AS EMAIL
from customer.CRM_ADR6 A
INNER JOIN commercial.ISU_BUT021_FS B
on A.ADDRNUMBER = B.ADDRNUMBER
where A.SMTP_ADDR = 'none@none.com.au'