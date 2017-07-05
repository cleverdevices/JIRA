CREATE DEFINER=`readonly`@`%` PROCEDURE `CAD_tblVersions`()
BEGIN

drop table if exists CAD_tblVersions;
create table CAD_tblVersions

select projectversion.* ,
case when (projectversion.vname = CAD_InputTable.Version) then sum(CAD_InputTable.Hours_to_Use) else 0 end as Column_0
 
from projectversion left join CAD_InputTable on CAD_InputTable.Version = projectversion.vname where (projectversion.project in(11091) and projectversion.released is null and projectversion.archived is null and projectversion.releasedate >0) group by projectversion.vname;

END
