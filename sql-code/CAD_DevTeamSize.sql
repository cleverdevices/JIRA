CREATE DEFINER=`readonly`@`%` PROCEDURE `CAD_DevTeamSize`()
BEGIN
declare num_days int;


call WorkDays();
call CAD_Input();
call CAD_tblVersions();

call CAD_EpicUpdate();

#Create Table from new query and join values from static table
DROP TABLE IF EXISTS CAD_EpicUpdateLink;
Create Table CAD_EpicUpdateLink 


Select CAD_EpicUpdateTable.*, CDCADteamvelocity.storyHours, case when issue_status = 1 then 1 else 0 end as column1  from CAD_EpicUpdateTable
 join CDCADteamvelocity 
on CAD_EpicUpdateTable.Team = CDCADteamvelocity.team and CAD_EpicUpdateTable.`Story Points` = CDCADteamvelocity.points ;

drop table if exists CAD_DeveloperTeamSize;
create table CAD_DeveloperTeamSize

select  CAD_tblVersions.vname as Version , 43.5 as Team_Size, 

(CAD_tblVersions.Column_0) as Total_NRE_per_Version,

 CAD_InputTable.StartDate as Version_Start_Date, CAD_InputTable.ReleaseDate as Version_Release_Date,
 

if(if(date(now()) > CAD_InputTable.StartDate, CDdateDiffFunction(date(now() - interval 7 day), CAD_InputTable.ReleaseDate)*0.7*8*21, CDdateDiffFunction(CAD_InputTable.StartDate, CAD_InputTable.ReleaseDate)*0.7*8*21) < 0, 0, if(date(now()) > CAD_InputTable.StartDate, CDdateDiffFunction(date(now() - interval 7 day), CAD_InputTable.ReleaseDate)*0.7*8*21, CDdateDiffFunction(CAD_InputTable.StartDate, CAD_InputTable.ReleaseDate)*0.7*8*21)) as Hours,

if(if(date(now()) > CAD_InputTable.StartDate, CDdateDiffFunction(date(now() - interval 7 day), CAD_InputTable.ReleaseDate)*0.7*8*21, CDdateDiffFunction(CAD_InputTable.StartDate, CAD_InputTable.ReleaseDate)*0.7*8*21) < 0, 0, if(date(now()) > CAD_InputTable.StartDate, CDdateDiffFunction(date(now() - interval 7 day), CAD_InputTable.ReleaseDate)*0.7*8*21, CDdateDiffFunction(CAD_InputTable.StartDate, CAD_InputTable.ReleaseDate)*0.7*8*21)) - (CAD_tblVersions.Column_0) as Available_Hours

from projectversion, CAD_tblVersions


left join CAD_InputTable on CAD_InputTable.Version = CAD_tblVersions.vname where (projectversion.project in( 10291, 10692) and projectversion.released is null and projectversion.archived is null and projectversion.releasedate >0) 



group by CAD_tblVersions.vname;

select CAD_DeveloperTeamSize.*, workMatch.releaseRow as Release_Date_Includes_QA_Testing_and_Regression from CAD_DeveloperTeamSize
left join workMatch on CAD_DeveloperTeamSize.Version_Release_Date = workMatch.calendar_date
group by CAD_DeveloperTeamSize.Version;


END
