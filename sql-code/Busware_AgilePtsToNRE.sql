CREATE DEFINER=`readonly`@`%` PROCEDURE `Busware_AgilePtsToNRE`()
BEGIN

#Update Calculate table that converts base query
call Busware_EpicUpdate();

#Create Table from new query and join values from static table
DROP TABLE IF EXISTS Busware_EpicUpdateLink;
Create Table Busware_EpicUpdateLink 


Select Busware_EpicUpdateTable.*, cdbuswareteamvelocity.storyHours, case when issue_status = 1 then 1 else 0 end as column1  from Busware_EpicUpdateTable
 join cdbuswareteamvelocity 
on Busware_EpicUpdateTable.Team = cdbuswareteamvelocity.team and Busware_EpicUpdateTable.`Story Points` = cdbuswareteamvelocity.points ;

Select * from Busware_EpicUpdateLink ;

END
