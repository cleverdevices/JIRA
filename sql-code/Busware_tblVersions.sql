CREATE DEFINER=`readonly`@`%` PROCEDURE `Busware_tblVersions`()
BEGIN

drop table if exists Busware_tblVersions;
create table Busware_tblVersions

select projectversion.* ,
case when (projectversion.vname = Busware_InputTable.Version) then sum(Busware_InputTable.Hours_to_Use) else 0 end as Column_0
 
from projectversion left join Busware_InputTable on Busware_InputTable.Version = projectversion.vname where (projectversion.project in( 11690, 10027) and projectversion.released is null and projectversion.archived is null and projectversion.releasedate >0) group by projectversion.vname;

END
