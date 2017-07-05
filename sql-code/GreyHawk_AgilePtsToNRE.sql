CREATE DEFINER=`readonly`@`%` PROCEDURE `GreyHawk_AgilePtsToNRE`()
BEGIN

#Update Calculate table that converts base query
call GreyHawk_EpicUpdate();

#Create Table from new query and join values from static table
DROP TABLE IF EXISTS GreyHawk_EpicUpdateLink;
Create Table GreyHawk_EpicUpdateLink 


Select GreyHawk_EpicUpdateTable.*, CDGreyHawkteamvelocity.storyHours, case when issue_status = 1 then 1 else 0 end as column1  from GreyHawk_EpicUpdateTable
 join CDGreyHawkteamvelocity 
on GreyHawk_EpicUpdateTable.Team = CDGreyHawkteamvelocity.team and GreyHawk_EpicUpdateTable.`Story Points` = CDGreyHawkteamvelocity.points ;

Select * from GreyHawk_EpicUpdateLink ;

END
