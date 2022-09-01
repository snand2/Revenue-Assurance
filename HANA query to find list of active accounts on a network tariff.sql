Select top 100 a.* from commercial.easts A
join commercial.eanl_excols B on A.anlage = B.anlage and b.anlart = '2'
join commercial.ever v on a.anlage = v.anlage and v.auszdat > current_date
where preiskla = 'QBSR'
and BIS = '99991231'
