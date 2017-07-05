CREATE DEFINER=`readonly`@`%` PROCEDURE `SmartYard_DevTeamSize`()
BEGIN
declare num_days int;

call SmartYard_Input();
call SmartYard_tblVersions();

drop table if exists SmartYard_DeveloperTeamSize;
create table SmartYard_DeveloperTeamSize

select  SmartYard_tblVersions.vname as Version , 3 as Team_Size, 

(SmartYard_tblVersions.Column_0) as Total_NRE_per_Version,

 SmartYard_InputTable.StartDate as Version_Start_Date, SmartYard_InputTable.ReleaseDate as Version_Release_Date,
 

if(if(date(now()) > SmartYard_InputTable.StartDate, CDdateDiffFunction(date(now() - interval 7 day), SmartYard_InputTable.ReleaseDate)*0.7*8*21, CDdateDiffFunction(SmartYard_InputTable.StartDate, SmartYard_InputTable.ReleaseDate)*0.7*8*21) < 0, 0, if(date(now()) > SmartYard_InputTable.StartDate, CDdateDiffFunction(date(now() - interval 7 day), SmartYard_InputTable.ReleaseDate)*0.7*8*21, CDdateDiffFunction(SmartYard_InputTable.StartDate, SmartYard_InputTable.ReleaseDate)*0.7*8*21)) as Hours,

if(if(date(now()) > SmartYard_InputTable.StartDate, CDdateDiffFunction(date(now() - interval 7 day), SmartYard_InputTable.ReleaseDate)*0.7*8*21, CDdateDiffFunction(SmartYard_InputTable.StartDate, SmartYard_InputTable.ReleaseDate)*0.7*8*21) < 0, 0, if(date(now()) > SmartYard_InputTable.StartDate, CDdateDiffFunction(date(now() - interval 7 day), SmartYard_InputTable.ReleaseDate)*0.7*8*21, CDdateDiffFunction(SmartYard_InputTable.StartDate, SmartYard_InputTable.ReleaseDate)*0.7*8*21)) - (SmartYard_tblVersions.Column_0) as Available_Hours

from projectversion, SmartYard_tblVersions


left join SmartYard_InputTable on SmartYard_InputTable.Version = SmartYard_tblVersions.vname where (projectversion.project in(10590) and projectversion.released is null and projectversion.archived is null and projectversion.releasedate >0) 



group by SmartYard_tblVersions.vname;

select SmartYard_DeveloperTeamSize.*, workMatch.releaseRow as Release_Date_Includes_QA_Testing_and_Regression from SmartYard_DeveloperTeamSize
left join workMatch on SmartYard_DeveloperTeamSize.Version_Release_Date = workMatch.calendar_date
group by SmartYard_DeveloperTeamSize.Version;


END
