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
		,row_number() over (partition by addr_no.partner order by addr_no.valid_from desc, addr_no.addrnumber asc) as addr_rank --Rank and partition to get most recent time slice
	from
		customer.isu_adrc as mail_ad
	inner join
		commercial.isu_but021_fs as addr_no --Join to BP table
		on mail_ad.addrnumber = addr_no.addrnumber
)
where
	addr_rank = 1 --only want the most recent
	and bp in ('0101019048')
	