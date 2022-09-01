
SELECT
      Bills.Installation_Number,
      Bills.Start_Billing_Period,
      Bills.End_Billing_Period,
      EUITRANS.EXT_UI,
      COUNT(*)    
FROM
      COMMERCIAL.HNODS_ST_BILL_ALL_BILLS Bills
      INNER JOIN
            COMMERCIAL.EUIINSTLN EUIINSTLN
            ON Bills.Installation_Number = EUIINSTLN.ANLAGE
            AND DATETO = '99991231'
      INNER JOIN
            CUSTOMER.EUITRANS EUITRANS
            ON EUIINSTLN.INT_UI = EUITRANS.INT_UI
            AND EUITRANS.DATETO = '99991231'
WHERE
      Bills.Print_Date >= '20190101'
      AND Bills.Reversal_Date != ''
GROUP BY
      Bills.Installation_Number,
      Bills.Start_Billing_Period,
      Bills.End_Billing_Period,
      EUITRANS.EXT_UI
HAVING
      COUNT(*) > 3
