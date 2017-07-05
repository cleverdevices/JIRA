CREATE DEFINER=`readonly`@`%` PROCEDURE `CleverReports_DevTeamSize`()
BEGIN
declare num_days int;

call CleverReports_Input();
call CleverReports_tblVersions();

drop table if exists CleverReports_DeveloperTeamSize;
create table CleverReports_DeveloperTeamSize

select  CleverReports_tblVersions.vname as Version , 3 as Team_Size, 

(CleverReports_tblVersions.Column_0) as Total_NRE_per_Version,

 CleverReports_InputTable.StartDate as Version_Start_Date, CleverReports_InputTable.ReleaseDate as Version_Release_Date,
 

if(if(date(now()) > CleverReports_InputTable.StartDate, CDdateDiffFunction(date(now() - interval 7 day), CleverReports_InputTable.ReleaseDate)*0.7*8*21, CDdateDiffFunction(CleverReports_InputTable.StartDate, CleverReports_InputTable.ReleaseDate)*0.7*8*21) < 0, 0, if(date(now()) > CleverReports_InputTable.StartDate, CDdateDiffFunction(date(now() - interval 7 day), CleverReports_InputTable.ReleaseDate)*0.7*8*21, CDdateDiffFunction(CleverReports_InputTable.StartDate, CleverReports_InputTable.ReleaseDate)*0.7*8*21)) as Hours,

if(if(date(now()) > CleverReports_InputTable.StartDate, CDdateDiffFunction(date(now() - interval 7 day), CleverReports_InputTable.ReleaseDate)*0.7*8*21, CDdateDiffFunction(CleverReports_InputTable.StartDate, CleverReports_InputTable.ReleaseDate)*0.7*8*21) < 0, 0, if(date(now()) > CleverReports_InputTable.StartDate, CDdateDiffFunction(date(now() - interval 7 day), CleverReports_InputTable.ReleaseDate)*0.7*8*21, CDdateDiffFunction(CleverReports_InputTable.StartDate, CleverReports_InputTable.ReleaseDate)*0.7*8*21)) - (CleverReports_tblVersions.Column_0) as Available_Hours

from projectversion, CleverReports_tblVersions


left join CleverReports_InputTable on CleverReports_InputTable.Version = CleverReports_tblVersions.vname where (projectversion.project in( 10291, 10692) and projectversion.released is null and projectversion.archived is null and projectversion.releasedate >0) 



group by CleverReports_tblVersions.vname;

select CleverReports_DeveloperTeamSize.*, workMatch.releaseRow as Release_Date_Includes_QA_Testing_and_Regression from CleverReports_DeveloperTeamSize
left join workMatch on CleverReports_DeveloperTeamSize.Version_Release_Date = workMatch.calendar_date
group by CleverReports_DeveloperTeamSize.Version;


END
