select
	 acct.gpart as "Business Partner"
	,acct.vkbez as "Full Name"
	,TITLE.TITLE_MEDI as "Title"
	,NAME.NAME_FIRST as "First Name"
	,NAME.NAME_LAST as "Surname"
	,substr(acct.vkont,3,12) as "Account Number"
	,cont.vertrag as "Contract Number"
	,cont.anlage as "Installation Number"
	,POD.EXT_UI as "POD"
	,supp.region as "State"
	,to_date(cont.einzdat) as "Move in Date"
	,to_date(cont.auszdat) as "Move out Date"
	,CONCARD.CON_CARD as "Existing Concession Card No"
	,CONCARD.CON_CARDTYP as "Concession Card Type"
	,CONCARD.CON_ISSUER as "Concession Card Issuer"
	,CONCARD.CON_CARD_ISSUED as "Concession Card Issue Date"
	,CONCARD.CON_CARD_EXP as "Concession Card Expiry Date"
	,CONC.OPERAND as "Active Concession Operand"
	,CONC.CONCESSION_START as "Concession Start"
	,CONC.CONCESSION_END as "Concession End"
	,CASE --determining if active or inactive based on move out date
		WHEN cont.auszdat <= current_date then 'INACTIVE'
		WHEN cont.auszdat >= current_date then 'ACTIVE'
	end as "Contract Status"
	,mail.mailing_address as "Mailing Address"
	,case --this case statement is to include the unit number where there is one
		when prem.haus_num2 != '' and prem.haus_num2 is not null then prem.haus_num2 || '/' || supp.house_num1 || ' ' || supp.street || ' ' || supp.city1 || ' ' || supp.region || ' ' || supp.post_code1
		else supp.house_num1 || ' ' || supp.street || ' ' || supp.city1 || ' ' || supp.region || ' ' || supp.post_code1
	 end as "Supply Address"

from
	commercial.ever as cont --joining contract table 
inner join
	customer.fkkvkp as acct --joining account table
	on cont.vkonto = acct.vkont

left join
(
	select --getting mailing address, via bp
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
	and mail.addr_rank = 1 --getting the mailing address that is CURRENT for that BP

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
LEFT JOIN 
COMMERCIAL.EUIINSTLN as INSTALL -- POD part 1
on CONT.ANLAGE = INSTALL.ANLAGE

LEFT JOIN
customer.isu_but000 as NAME --Name info
on acct.GPART = NAME.PARTNER

LEFT JOIN
CUSTOMER.EUITRANS as POD --POD part 2
on INSTALL.INT_UI = POD.INT_UI

Left JOIN

(
SELECT --Getting concession operand data
	ETTIFN.ANLAGE as INSTALLATION,
	ETTIFN.OPERAND as OPERAND,
	TO_DATE(ETTIFN.AB) as CONCESSION_START,
	TO_DATE(ETTIFN.BIS) as CONCESSION_END

FROM
COMMERCIAL.ETTIFN ETTIFN

INNER JOIN --joining to get concession specific operands
COMMERCIAL.TE221 TE221
	ON TE221.OPERAND = ETTIFN.OPERAND
	AND TE221.OPGROUP = 'CONCESSION' --ensures concession only operands
	AND ETTIFN.INAKTIV != 'X' --removes inactive operands
	AND CURRENT_DATE BETWEEN ETTIFN.AB AND ETTIFN.BIS --ensures current active only
) CONC
on CONT.ANLAGE = CONC.INSTALLATION

Left join
CUSTOMER.ECONCARD as CONCARD --bringing in card info
on acct.GPART = CONCARD.PARTNER

left join open.crm_tsad3t TITLE --getting title
on NAME.TITLE = TITLE.TITLE
and TITLE.LANGU = 'E'


where
	acct.gpart in ('0100749151','0901175620') -- Put BP numbers here for Supply addresses
	and cont.einzdat != '00000000' --exclude reversed contracts, because reversing a contract deletes the ANLAGE in IS-U

order by
	 acct.gpart asc
	,cont.einzdat asc
	,cont.vertrag asc

