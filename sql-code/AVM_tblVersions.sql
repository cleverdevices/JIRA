CREATE DEFINER=`readonly`@`%` PROCEDURE `AVM_tblVersions`()
BEGIN

drop table if exists AVM_tblVersions;
create table AVM_tblVersions

select projectversion.* ,
case when (projectversion.vname = AVM_InputTable.Version) then sum(AVM_InputTable.Hours_to_Use) else 0 end as Column_0
 
from projectversion left join AVM_InputTable on AVM_InputTable.Version = projectversion.vname where (projectversion.project in( 10291, 10692) and projectversion.released is null and projectversion.archived is null and projectversion.releasedate >0) group by projectversion.vname;

END
