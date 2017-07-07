CREATE DEFINER=`readonly`@`%` PROCEDURE `CleverWare_DevTeamSize`()
BEGIN
declare num_days int;

call WorkDays();
call CleverWare_Input();
call CleverWare_tblVersions();

call CleverWare_EpicUpdate();

#Create Table from new query and join values from static table
DROP TABLE IF EXISTS CleverWare_EpicUpdateLink;
Create Table CleverWare_EpicUpdateLink 


Select CleverWare_EpicUpdateTable.*, CDCleverWareteamvelocity.storyHours, case when issue_status = 1 then 1 else 0 end as column1  from CleverWare_EpicUpdateTable
 join CDCleverWareteamvelocity 
on CleverWare_EpicUpdateTable.Team = CDCleverWareteamvelocity.team and CleverWare_EpicUpdateTable.`Story Points` = CDCleverWareteamvelocity.points ;

drop table if exists CleverWare_DeveloperTeamSize;
create table CleverWare_DeveloperTeamSize

select  CleverWare_tblVersions.vname as Version , 5 as Team_Size, #change this for team size

(CleverWare_tblVersions.Column_0) as Total_NRE_per_Version,

 CleverWare_InputTable.StartDate as Version_Start_Date, CleverWare_InputTable.ReleaseDate as Version_Release_Date,
 

if(if(date(now()) > CleverWare_InputTable.StartDate, CDdateDiffFunction(date(now() - interval 7 day), CleverWare_InputTable.ReleaseDate)*0.7*8*21, CDdateDiffFunction(CleverWare_InputTable.StartDate, CleverWare_InputTable.ReleaseDate)*0.7*8*21) < 0, 0, if(date(now()) > CleverWare_InputTable.StartDate, CDdateDiffFunction(date(now() - interval 7 day), CleverWare_InputTable.ReleaseDate)*0.7*8*21, CDdateDiffFunction(CleverWare_InputTable.StartDate, CleverWare_InputTable.ReleaseDate)*0.7*8*21)) as Hours,

if(if(date(now()) > CleverWare_InputTable.StartDate, CDdateDiffFunction(date(now() - interval 7 day), CleverWare_InputTable.ReleaseDate)*0.7*8*21, CDdateDiffFunction(CleverWare_InputTable.StartDate, CleverWare_InputTable.ReleaseDate)*0.7*8*21) < 0, 0, if(date(now()) > CleverWare_InputTable.StartDate, CDdateDiffFunction(date(now() - interval 7 day), CleverWare_InputTable.ReleaseDate)*0.7*8*21, CDdateDiffFunction(CleverWare_InputTable.StartDate, CleverWare_InputTable.ReleaseDate)*0.7*8*21)) - (CleverWare_tblVersions.Column_0) as Available_Hours

from projectversion, CleverWare_tblVersions


left join CleverWare_InputTable on CleverWare_InputTable.Version = CleverWare_tblVersions.vname where (projectversion.project in( 12191) and projectversion.released is null and projectversion.archived is null and projectversion.releasedate >0) 



group by CleverWare_tblVersions.vname;

select CleverWare_DeveloperTeamSize.*, workMatch.releaseRow as Release_Date_Includes_QA_Testing_and_Regression from CleverWare_DeveloperTeamSize
left join workMatch on CleverWare_DeveloperTeamSize.Version_Release_Date = workMatch.calendar_date
group by CleverWare_DeveloperTeamSize.Version;


END
