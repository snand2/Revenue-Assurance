select
ext_ui

from
customer.euitrans

where
left(ext_ui,10) in
('2001003377',
'2001003897',
'2001006829')
