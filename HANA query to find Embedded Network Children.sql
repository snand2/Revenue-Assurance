select
	 cont.vertrag as contract_number
	,cont.vkonto as account_number
	,cont.bukrs as company_code
	,stat.text50 as state_class
from								--installation header contains 'embdnwchild' flag
	commercial.euihead as grid
inner join
	commercial.euiinstln as inst
	on grid.int_ui = inst.int_ui
inner join							--inner join to contract table, restrict to open contracts
	commercial.ever as cont
	on inst.anlage = cont.anlage
	and cont.auszdat = '99991231'
left join							--obtain state and busi/resi class from account determination ID ('kofiz')
	open.te097at as stat
	on cont.kofiz = stat.kofiz
	and stat.spras = 'E'
where
	grid.embnwchild != ''			--restrict only to sites where embedded network child flag is not blank
;