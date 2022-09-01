SELECT

activity_partner
,object_id
,BP.MailState
--,category
,category_description
,created_by
--,created_date_time_ausvic
,CONVERT(varchar,created_date_time_ausvic,105) as create_date
--,created_date_time_utc
--,(DATEDIFF(dd, [created_date_time_ausvic], [created_date_time_ausvic])) as days_open
--,Case 
		    --WHEN (DATEDIFF(dd, [created_date_time_ausvic], [created_date_time_ausvic])) < 10 then '0 to 9'
			--end as ageing_group
--,description
--,follow_up_date
--,guid
,map.[Functional Area]
,lvl1_categorisation_text
,lvl2_categorisation_text
,lvl3_categorisation_text
--,lvl4_categorisation_text
--,object_type
--,objective
,objective_description
--,planned_completion_date
--,planned_date
--,priority
,process_category
--,process_type
,process_type_description
--,reason_catalog
--,reason_code
--,reason_code_group
--,status_profile
--,system_status
,system_status_text
--,user_status
,user_status_text

FROM  [customer].[GeneralComplaints_Tasks_ContactNotes] t

left join [customer].[dim_BusinessPartnerContact] BP
on t.activity_partner = BP.BusinessPartner and BP.RecordEndDate = '9999-12-31'

left join [sp_commercial].[CRM_Mapping_07022020] map
on t.lvl1_categorisation_text = map.Level1_Text and t.lvl2_categorisation_text = map.Level2_Text

where  lvl1_categorisation_text NOT IN ('NULL')
and lvl1_categorisation_text NOT IN ('Feedback')
and process_category IN ('Complaint')
and created_date_time_ausvic >= '2020-05-01' and created_date_time_ausvic < '2020-06-01'
and process_type IN ('ZCMM')
and created_by NOT IN ('AGLBATCH','ISU_RFC','XECMCRM')

