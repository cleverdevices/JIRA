CREATE DEFINER=`readonly`@`%` PROCEDURE `GreyHawk_DevTeamSize`()
BEGIN
declare num_days int;

call WorkDays();
call GreyHawk_Input();
call GreyHawk_tblVersions();

call GreyHawk_EpicUpdate();

#Create Table from new query and join values from static table
DROP TABLE IF EXISTS GreyHawk_EpicUpdateLink;
Create Table GreyHawk_EpicUpdateLink 


Select GreyHawk_EpicUpdateTable.*, CDGreyHawkteamvelocity.storyHours, case when issue_status = 1 then 1 else 0 end as column1  from GreyHawk_EpicUpdateTable
 join CDGreyHawkteamvelocity 
on GreyHawk_EpicUpdateTable.Team = CDGreyHawkteamvelocity.team and GreyHawk_EpicUpdateTable.`Story Points` = CDGreyHawkteamvelocity.points ;

drop table if exists GreyHawk_DeveloperTeamSize;
create table GreyHawk_DeveloperTeamSize

select  GreyHawk_tblVersions.vname as Version , 6 as Team_Size,  #change for correct team size

(GreyHawk_tblVersions.Column_0) as Total_NRE_per_Version,

 GreyHawk_InputTable.StartDate as Version_Start_Date, GreyHawk_InputTable.ReleaseDate as Version_Release_Date,
 

if(if(date(now()) > GreyHawk_InputTable.StartDate, CDdateDiffFunction(date(now() - interval 7 day), GreyHawk_InputTable.ReleaseDate)*0.7*8*21, CDdateDiffFunction(GreyHawk_InputTable.StartDate, GreyHawk_InputTable.ReleaseDate)*0.7*8*21) < 0, 0, if(date(now()) > GreyHawk_InputTable.StartDate, CDdateDiffFunction(date(now() - interval 7 day), GreyHawk_InputTable.ReleaseDate)*0.7*8*21, CDdateDiffFunction(GreyHawk_InputTable.StartDate, GreyHawk_InputTable.ReleaseDate)*0.7*8*21)) as Hours,

if(if(date(now()) > GreyHawk_InputTable.StartDate, CDdateDiffFunction(date(now() - interval 7 day), GreyHawk_InputTable.ReleaseDate)*0.7*8*21, CDdateDiffFunction(GreyHawk_InputTable.StartDate, GreyHawk_InputTable.ReleaseDate)*0.7*8*21) < 0, 0, if(date(now()) > GreyHawk_InputTable.StartDate, CDdateDiffFunction(date(now() - interval 7 day), GreyHawk_InputTable.ReleaseDate)*0.7*8*21, CDdateDiffFunction(GreyHawk_InputTable.StartDate, GreyHawk_InputTable.ReleaseDate)*0.7*8*21)) - (GreyHawk_tblVersions.Column_0) as Available_Hours

from projectversion, GreyHawk_tblVersions


left join GreyHawk_InputTable on GreyHawk_InputTable.Version = GreyHawk_tblVersions.vname where (projectversion.project in(10180) and projectversion.released is null and projectversion.archived is null and projectversion.releasedate >0) 



group by GreyHawk_tblVersions.vname;

select GreyHawk_DeveloperTeamSize.*, workMatch.releaseRow as Release_Date_Includes_QA_Testing_and_Regression from GreyHawk_DeveloperTeamSize
left join workMatch on GreyHawk_DeveloperTeamSize.Version_Release_Date = workMatch.calendar_date
group by GreyHawk_DeveloperTeamSize.Version;


END
