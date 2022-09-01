--Supply scenario lookup----
--0 = Undefined-------------
--1 = FRMP, LR, Active------
--2 = FRMP, LR, Inactive----
--3 = FRMP, NOT LR, Active--
--4 = FRMP, NOT LR, Inactive
--5 = Not FRMP, LR ---------
--6 = FRO, Active-----------
--7 = FRO, Inactive---------
--8 = Not FRMP, Not LR------
--9 = Not FRO---------------



select installation, supplyscenario
from "DATAINT"."TBL_CR96"
where
supplyenddate = '99991231'
and installation = '3000868283'
