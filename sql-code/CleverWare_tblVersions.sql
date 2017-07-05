CREATE DEFINER=`readonly`@`%` PROCEDURE `CleverWare_tblVersions`()
BEGIN

drop table if exists CleverWare_tblVersions;
create table CleverWare_tblVersions

select projectversion.* ,
case when (projectversion.vname = CleverWare_InputTable.Version) then sum(CleverWare_InputTable.Hours_to_Use) else 0 end as Column_0
 
from projectversion left join CleverWare_InputTable on CleverWare_InputTable.Version = projectversion.vname where (projectversion.project in(12191) and projectversion.released is null and projectversion.archived is null and projectversion.releasedate >0) group by projectversion.vname;

END
