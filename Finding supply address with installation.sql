select
	 acct.gpart as bp
	 ,eanl.anlage as installation
	,cont.vertrag as contract_number
	,to_date(cont.einzdat) as move_in_date
	,to_date(cont.auszdat) as move_out_date
	,case --this case statement is to include the unit number where there is one
		when prem.haus_num2 != '' and prem.haus_num2 is not null then prem.haus_num2 || '/' || supp.house_num1 || ' ' || supp.street || ' ' || supp.city1 || ' ' || supp.region || ' ' || supp.post_code1
		else supp.house_num1 || ' ' || supp.street || ' ' || supp.city1 || ' ' || supp.region || ' ' || supp.post_code1
	 end as supply_address

from
	commercial.ever as cont
inner join
	customer.fkkvkp as acct
	on cont.vkonto = acct.vkont
left join
	commercial.eanl_excols as eanl		--installation table
	on cont.anlage = eanl.anlage
left join
	commercial.evbs_excols as prem		--premise table
	on eanl.vstelle = prem.vstelle
left join	
	commercial.iloa as locn				--location table
	on prem.haus = locn.tplnr
left join
	customer.isu_adrc as supp			--address table
	on locn.adrnr = supp.addrnumber

where eanl.anlage in
('3007816135')