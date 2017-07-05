CREATE DEFINER=`readonly`@`%` PROCEDURE `GreyHawk_tblVersions`()
BEGIN

drop table if exists GreyHawk_tblVersions;
create table GreyHawk_tblVersions

select projectversion.* ,
case when (projectversion.vname = GreyHawk_InputTable.Version) then sum(GreyHawk_InputTable.Hours_to_Use) else 0 end as Column_0
 
from projectversion left join GreyHawk_InputTable on GreyHawk_InputTable.Version = projectversion.vname where (projectversion.project in(10180) and projectversion.released is null and projectversion.archived is null and projectversion.releasedate >0) group by projectversion.vname;

END
