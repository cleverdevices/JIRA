CREATE DEFINER=`readonly`@`%` PROCEDURE `AVM_AgilePtsToNRE`()
BEGIN

#Update Calculate table that converts base query
call AVM_EpicUpdate();

#Create Table from new query and join values from static table
DROP TABLE IF EXISTS AVM_EpicUpdateLink;
Create Table AVM_EpicUpdateLink 


Select AVM_EpicUpdateTable.*, CDAVMteamvelocity.storyHours, case when issue_status = 1 then 1 else 0 end as column1  from AVM_EpicUpdateTable
 join CDAVMteamvelocity 
on AVM_EpicUpdateTable.Team = CDAVMteamvelocity.team and AVM_EpicUpdateTable.`Story Points` = CDAVMteamvelocity.points ;

Select * from AVM_EpicUpdateLink ;

END
