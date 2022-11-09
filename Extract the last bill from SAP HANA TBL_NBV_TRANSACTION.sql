SELECT METER_ID,BILLING_PERIOD_START,BILLING_PERIOD_END FROM 
(select METER_ID,BILLING_PERIOD_START,BILLING_PERIOD_END, row_number()over (partition by meter_id
order by BILLING_PERIOD_END desc) as rank from "DATAINT"."TBL_NBV_TRANSACTION"
where METER_ID IN ()------Enter the MeterID(NMI/MIRN)
and QUANTITY_UOM IN('kwh','KWH','GJ','MJ')--------KWH stands for Electricity an GJ/MJ stand for Gas
group by METER_ID,BILLING_PERIOD_START,BILLING_PERIOD_END)a
where rank=1
order by METER_ID,BILLING_PERIOD_START,BILLING_PERIOD_END

