CREATE DEFINER=`readonly`@`%` PROCEDURE `SmartYard_AgilePtsToNRE`()
BEGIN

#Update Calculate table that converts base query
call SmartYard_EpicUpdate();

#Create Table from new query and join values from static table
DROP TABLE IF EXISTS SmartYard_EpicUpdateLink;
Create Table SmartYard_EpicUpdateLink 


Select SmartYard_EpicUpdateTable.*, CDSmartYardteamvelocity.storyHours, case when issue_status = 1 then 1 else 0 end as column1  from SmartYard_EpicUpdateTable
 join CDSmartYardteamvelocity 
on SmartYard_EpicUpdateTable.Team = CDSmartYardteamvelocity.team and SmartYard_EpicUpdateTable.`Story Points` = CDSmartYardteamvelocity.points ;

Select * from SmartYard_EpicUpdateLink ;

END
