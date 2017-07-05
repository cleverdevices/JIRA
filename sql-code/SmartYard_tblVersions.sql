CREATE DEFINER=`readonly`@`%` PROCEDURE `SmartYard_tblVersions`()
BEGIN

drop table if exists SmartYard_tblVersions;
create table SmartYard_tblVersions

select projectversion.* ,
case when (projectversion.vname = SmartYard_InputTable.Version) then sum(SmartYard_InputTable.Hours_to_Use) else 0 end as Column_0
 
from projectversion left join SmartYard_InputTable on SmartYard_InputTable.Version = projectversion.vname where (projectversion.project in(10590) and projectversion.released is null and projectversion.archived is null and projectversion.releasedate >0) group by projectversion.vname;

END
