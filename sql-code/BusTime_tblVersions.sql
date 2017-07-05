CREATE DEFINER=`readonly`@`%` PROCEDURE `BusTime_tblVersions`()
BEGIN

drop table if exists BusTime_tblVersions;
create table BusTime_tblVersions

select projectversion.* ,
case when (projectversion.vname = BusTime_InputTable.Version) then sum(BusTime_InputTable.Hours_to_Use) else 0 end as Column_0
 
from projectversion left join BusTime_InputTable on BusTime_InputTable.Version = projectversion.vname where (projectversion.project in(10790) and projectversion.released is null and projectversion.archived is null and projectversion.releasedate >0) group by projectversion.vname;

END
