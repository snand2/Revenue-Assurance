--a simple output of mailing address
select
	*
from	
(
	select
		 addr_no.partner as bp
		,mail_ad.house_num2 as unit
		,mail_ad.house_num1 as number
		,mail_ad.street
		,mail_ad.city1 as suburb
		,mail_ad.post_code1 as postcode
		,row_number() over (partition by addr_no.partner order by addr_no.valid_from desc, addr_no.addrnumber asc) as addr_rank
	from
		customer.isu_adrc as mail_ad
	inner join
		commercial.isu_but021_fs as addr_no
		on mail_ad.addrnumber = addr_no.addrnumber
)
where
	addr_rank = 1
	and bp in ('0100749151','0901175620')
;

--a demonstration of the way supply address is obtained vs. mailing address, even though they are both found in table ADRC
select
	 acct.gpart as bp
	,cont.vertrag as contract_number
	,to_date(cont.einzdat) as move_in_date
	,to_date(cont.auszdat) as move_out_date
	,mail.mailing_address
	,case --this case statement is to include the unit number where there is one
		when prem.haus_num2 != '' and prem.haus_num2 is not null then prem.haus_num2 || '/' || supp.house_num1 || ' ' || supp.street || ' ' || supp.city1 || ' ' || supp.region || ' ' || supp.post_code1
		else supp.house_num1 || ' ' || supp.street || ' ' || supp.city1 || ' ' || supp.region || ' ' || supp.post_code1
	 end as supply_address

from
	commercial.ever as cont
inner join
	customer.fkkvkp as acct
	on cont.vkonto = acct.vkont

--getting mailing address, via bp
left join
(
	select
		 addr_no.partner as bp
		,case --this case statement is to include the unit number where there is one
			when mail_ad.house_num2 != '' then mail_ad.house_num2 || '/' || mail_ad.house_num1 || ' ' || mail_ad.street || ' ' || mail_ad.city1 || ' ' || mail_ad.region || ' ' || mail_ad.post_code1
			else mail_ad.house_num1 || ' ' || mail_ad.street || ' ' || mail_ad.city1 || ' ' || mail_ad.region || ' ' || mail_ad.post_code1
		 end as mailing_address
		,row_number() over (partition by addr_no.partner order by addr_no.valid_from desc, addr_no.addrnumber asc) as addr_rank
	from
		customer.isu_adrc as mail_ad
	inner join
		commercial.isu_but021_fs as addr_no
		on mail_ad.addrnumber = addr_no.addrnumber
) 	as mail
	on acct.gpart = mail.bp
	and mail.addr_rank = 1

--getting supply address, via contract
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

where
	acct.gpart in ('0100749151','0901175620')
	and cont.einzdat != '00000000' --exclude reversed contracts, because reversing a contract deletes the ANLAGE in IS-U

order by
	 acct.gpart asc
	,cont.einzdat asc
	,cont.vertrag asc
;