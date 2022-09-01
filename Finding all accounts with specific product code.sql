SELECT ANLAGE as "Installation", VERTRAG as "Contract", AB as "Contract Start Date", BIS as "Contract End Date", CRM_PRODUCT as "Product Code"
from COMMERCIAL.EVERH
WHERE BIS = '99991231'
AND CRM_PRODUCT = 'AGLMKTRG2420005'