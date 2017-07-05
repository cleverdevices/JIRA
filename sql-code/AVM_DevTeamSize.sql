CREATE DEFINER=`readonly`@`%` PROCEDURE `AVM_DevTeamSize`()
BEGIN
declare num_days int;

call AVM_Input();
call AVM_tblVersions();

drop table if exists AVM_DeveloperTeamSize;
create table AVM_DeveloperTeamSize

select  AVM_tblVersions.vname as Version , 3 as Team_Size, 

(AVM_tblVersions.Column_0) as Total_NRE_per_Version,

 AVM_InputTable.StartDate as Version_Start_Date, AVM_InputTable.ReleaseDate as Version_Release_Date,
 

if(if(date(now()) > AVM_InputTable.StartDate, CDdateDiffFunction(date(now() - interval 7 day), AVM_InputTable.ReleaseDate)*0.7*8*21, CDdateDiffFunction(AVM_InputTable.StartDate, AVM_InputTable.ReleaseDate)*0.7*8*21) < 0, 0, if(date(now()) > AVM_InputTable.StartDate, CDdateDiffFunction(date(now() - interval 7 day), AVM_InputTable.ReleaseDate)*0.7*8*21, CDdateDiffFunction(AVM_InputTable.StartDate, AVM_InputTable.ReleaseDate)*0.7*8*21)) as Hours,

if(if(date(now()) > AVM_InputTable.StartDate, CDdateDiffFunction(date(now() - interval 7 day), AVM_InputTable.ReleaseDate)*0.7*8*21, CDdateDiffFunction(AVM_InputTable.StartDate, AVM_InputTable.ReleaseDate)*0.7*8*21) < 0, 0, if(date(now()) > AVM_InputTable.StartDate, CDdateDiffFunction(date(now() - interval 7 day), AVM_InputTable.ReleaseDate)*0.7*8*21, CDdateDiffFunction(AVM_InputTable.StartDate, AVM_InputTable.ReleaseDate)*0.7*8*21)) - (AVM_tblVersions.Column_0) as Available_Hours

from projectversion, AVM_tblVersions


left join AVM_InputTable on AVM_InputTable.Version = AVM_tblVersions.vname where (projectversion.project in( 10291, 10692) and projectversion.released is null and projectversion.archived is null and projectversion.releasedate >0) 



group by AVM_tblVersions.vname;

select AVM_DeveloperTeamSize.*, workMatch.releaseRow as Release_Date_Includes_QA_Testing_and_Regression from AVM_DeveloperTeamSize
left join workMatch on AVM_DeveloperTeamSize.Version_Release_Date = workMatch.calendar_date
group by AVM_DeveloperTeamSize.Version;


END
