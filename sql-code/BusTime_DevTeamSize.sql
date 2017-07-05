CREATE DEFINER=`readonly`@`%` PROCEDURE `BusTime_DevTeamSize`()
BEGIN
declare num_days int;

call BusTime_Input();
call BusTime_tblVersions();

drop table if exists BusTime_DeveloperTeamSize;
create table BusTime_DeveloperTeamSize

select  BusTime_tblVersions.vname as Version , 7 as Team_Size, 

(BusTime_tblVersions.Column_0) as Total_NRE_per_Version,

 BusTime_InputTable.StartDate as Version_Start_Date, BusTime_InputTable.ReleaseDate as Version_Release_Date,
 

if(if(date(now()) > BusTime_InputTable.StartDate, CDdateDiffFunction(date(now() - interval 7 day), BusTime_InputTable.ReleaseDate)*0.7*8*21, CDdateDiffFunction(BusTime_InputTable.StartDate, BusTime_InputTable.ReleaseDate)*0.7*8*21) < 0, 0, if(date(now()) > BusTime_InputTable.StartDate, CDdateDiffFunction(date(now() - interval 7 day), BusTime_InputTable.ReleaseDate)*0.7*8*21, CDdateDiffFunction(BusTime_InputTable.StartDate, BusTime_InputTable.ReleaseDate)*0.7*8*21)) as Hours,

if(if(date(now()) > BusTime_InputTable.StartDate, CDdateDiffFunction(date(now() - interval 7 day), BusTime_InputTable.ReleaseDate)*0.7*8*21, CDdateDiffFunction(BusTime_InputTable.StartDate, BusTime_InputTable.ReleaseDate)*0.7*8*21) < 0, 0, if(date(now()) > BusTime_InputTable.StartDate, CDdateDiffFunction(date(now() - interval 7 day), BusTime_InputTable.ReleaseDate)*0.7*8*21, CDdateDiffFunction(BusTime_InputTable.StartDate, BusTime_InputTable.ReleaseDate)*0.7*8*21)) - (BusTime_tblVersions.Column_0) as Available_Hours

from projectversion, BusTime_tblVersions


left join BusTime_InputTable on BusTime_InputTable.Version = BusTime_tblVersions.vname where (projectversion.project in( 10790) and projectversion.released is null and projectversion.archived is null and projectversion.releasedate >0) 



group by BusTime_tblVersions.vname;

select BusTime_DeveloperTeamSize.*, workMatch.releaseRow as Release_Date_Includes_QA_Testing_and_Regression from BusTime_DeveloperTeamSize
left join workMatch on BusTime_DeveloperTeamSize.Version_Release_Date = workMatch.calendar_date
group by BusTime_DeveloperTeamSize.Version;


END
