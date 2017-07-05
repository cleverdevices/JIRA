CREATE DEFINER=`readonly`@`%` PROCEDURE `BusTime_AgilePtsToNRE`()
BEGIN

#Update Calculate table that converts base query
call BusTime_EpicUpdate();

#Create Table from new query and join values from static table
DROP TABLE IF EXISTS BusTime_EpicUpdateLink;
Create Table BusTime_EpicUpdateLink 


Select BusTime_EpicUpdateTable.*, CDBusTimeteamvelocity.storyHours, case when issue_status = 1 then 1 else 0 end as column1  from BusTime_EpicUpdateTable
 join CDBusTimeteamvelocity 
on BusTime_EpicUpdateTable.Team = CDBusTimeteamvelocity.team and BusTime_EpicUpdateTable.`Story Points` = CDBusTimeteamvelocity.points ;

Select * from BusTime_EpicUpdateLink ;

END
