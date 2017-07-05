CREATE DEFINER=`readonly`@`%` PROCEDURE `Busware_DevTeamSize`()
BEGIN
declare num_days int;

call Busware_tblVersions();
call Busware_Input();

drop table if exists Busware_DeveloperTeamSize;
create table Busware_DeveloperTeamSize

select  Busware_tblVersions.vname as Version , 21 as Team_Size, 

(Busware_tblVersions.Column_0) as Total_NRE_per_Version,

 Busware_InputTable.StartDate as Version_Start_Date, Busware_InputTable.ReleaseDate as Version_Release_Date,
 

if(if(date(now()) > Busware_InputTable.StartDate, CDdateDiffFunction(date(now() - interval 7 day), Busware_InputTable.ReleaseDate)*0.7*8*21, CDdateDiffFunction(Busware_InputTable.StartDate, Busware_InputTable.ReleaseDate)*0.7*8*21) < 0, 0, if(date(now()) > Busware_InputTable.StartDate, CDdateDiffFunction(date(now() - interval 7 day), Busware_InputTable.ReleaseDate)*0.7*8*21, CDdateDiffFunction(Busware_InputTable.StartDate, Busware_InputTable.ReleaseDate)*0.7*8*21)) as Hours,

if(if(date(now()) > Busware_InputTable.StartDate, CDdateDiffFunction(date(now() - interval 7 day), Busware_InputTable.ReleaseDate)*0.7*8*21, CDdateDiffFunction(Busware_InputTable.StartDate, Busware_InputTable.ReleaseDate)*0.7*8*21) < 0, 0, if(date(now()) > Busware_InputTable.StartDate, CDdateDiffFunction(date(now() - interval 7 day), Busware_InputTable.ReleaseDate)*0.7*8*21, CDdateDiffFunction(Busware_InputTable.StartDate, Busware_InputTable.ReleaseDate)*0.7*8*21)) - (Busware_tblVersions.Column_0) as Available_Hours

from projectversion, Busware_tblVersions


left join Busware_InputTable on Busware_InputTable.Version = Busware_tblVersions.vname where (projectversion.project in( 11690, 10027) and projectversion.released is null and projectversion.archived is null and projectversion.releasedate >0) 



group by Busware_tblVersions.vname;

select Busware_DeveloperTeamSize.*, workMatch.releaseRow as Release_Date_Includes_QA_Testing_and_Regression from Busware_DeveloperTeamSize
left join workMatch on Busware_DeveloperTeamSize.Version_Release_Date = workMatch.calendar_date
group by Busware_DeveloperTeamSize.Version;


END
