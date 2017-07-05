CREATE DEFINER=`readonly`@`%` PROCEDURE `CAD_AgilePtsToNRE`()
BEGIN

#Update Calculate table that converts base query
call CAD_EpicUpdate();

#Create Table from new query and join values from static table
DROP TABLE IF EXISTS CAD_EpicUpdateLink;
Create Table CAD_EpicUpdateLink 


Select CAD_EpicUpdateTable.*, CDCADteamvelocity.storyHours, case when issue_status = 1 then 1 else 0 end as column1  from CAD_EpicUpdateTable
 join CDCADteamvelocity 
on CAD_EpicUpdateTable.Team = CDCADteamvelocity.team and CAD_EpicUpdateTable.`Story Points` = CDCADteamvelocity.points ;

Select * from CAD_EpicUpdateLink ;

END
