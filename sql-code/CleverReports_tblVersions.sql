CREATE DEFINER=`readonly`@`%` PROCEDURE `CleverReports_tblVersions`()
BEGIN

drop table if exists CleverReports_tblVersions;
create table CleverReports_tblVersions

select projectversion.* ,
case when (projectversion.vname = CleverReports_InputTable.Version) then sum(CleverReports_InputTable.Hours_to_Use) else 0 end as Column_0
 
from projectversion left join CleverReports_InputTable on CleverReports_InputTable.Version = projectversion.vname where (projectversion.project in(10200) and projectversion.released is null and projectversion.archived is null and projectversion.releasedate >0) group by projectversion.vname;

END
