SELECT 
      --[Case Type]
	  [Case ID]
      ,ca.[partner]
	  ,ca.[account_no]
	  ,[Create Date]
      ,[Created By]
	  --,t.[LOB]
	  --,t.[centre]
	  --,t.[jobtitle]
	  --,t.[stream]
      --,[Complaint ID]
      ,[Person Responsible]
      ,[CMS Status]
      ,[Complaint Level]
	  ,CASE 
			WHEN [Complaint Level] IN ('RHL','RHL - Consultation') THEN 'RHL' WHEN [Complaint Level] IN ('RHL - Facilitated','Investigation- Final','Investigation- Full','Investigation- Upgraded','Intake/Batch','Determination') THEN 'Investigation'
			ELSE 'Internal'
	   END AS complaint_type
      --,[Channel]
      --,[Timestamp]
      --,[report_date]
      --,[report_id]
	  ,ca.[state]
	  --,ca.[cms_fuel_id]
	  ,CASE WHEN ca.[cms_fuel_id] = '1' THEN 'Gas' WHEN ca.[cms_fuel_id] = '2' THEN 'Electricity' WHEN ca.[cms_fuel_id] = '3' THEN 'Dual Fuel'
	  ELSE 'No Fuel'
	  END AS fuel_desc
	  ,ca.[company_description]
	  ,map.[Functional area]
	  ,cat.[DESCRIPTION] 
	  ,ca.[sub_description]
	  
  FROM [SD_workflow_views].[ccm].[complaint_cases_created] cr

  -- left join [SD_workflow_views].[ccm].[cms_identity] i
  -- on i.[complaint_id] = cr.[Complaint ID]

  left join [SD_workflow_views].[ccm].[cms_identity] i
  on i.[case_number] = cr.[Case ID]

  left join [SD_workflow_views].[ccm].[complaint] co
  on co.[cms_identity_id] = i.[id]

  left join [SD_workflow_views].[ccm].[cms_category] cat
  on co.[cms_category_id] = cat.[id]

  left join [SD_workflow_views].[ccm].[cms_attribute] ca
  on ca.[cms_identity_id]= i.[id]

  left join [GLBWI1119].[Users].[dbo].[CF_CMS_Complaint_Mapping] map 
  on ca.[sub_description] = map.[Level 2 Description]  collate Latin1_General_CI_AS

  --left join [GLBWI1119].[Users].[dbo].[REP_TEAM_STRUCTURE] t 
  --on t.[Anumber] = cr.[Person Responsible] collate Latin1_General_CI_AS and cr.[Create Date] >= t.[assignmentstart] and cr.[Create Date]  <= t.[assignmentend]

  -- removed top date filter to bring all complaints from FY19 to current date
			where [Create Date] >= '2018-07-01'
			and [Person Responsible] NOT IN ('CMS-WDPESC','CMS-WDPNECF')
	
-- MC Updated filteres for billing and removing internal non OMB complaints	
			and [Functional area] = 'Billing'
			and 'complaint_type' not in ('Internal')
			