select erdk.opbel, erdk.druckdat, erdk.vkont, zz_disp_ctrl, zz_vertrag, zz_state, erdk.simulated from commercial.erdk inner join commercial.ever on ever.vertrag = erdk.zz_vertrag
where ever.begru = 'ZCNI' and
erdk.druckdat > '20171201' and
erdk.abrvorg = '03' and
ever.sparte = '02'

Select top 100 * from commercial.ERDK

