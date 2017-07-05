CREATE DEFINER=`readonly`@`%` PROCEDURE `CleverWare_AgilePtsToNRE`()
BEGIN

#Update Calculate table that converts base query
call CleverWare_EpicUpdate();

#Create Table from new query and join values from static table
DROP TABLE IF EXISTS CleverWare_EpicUpdateLink;
Create Table CleverWare_EpicUpdateLink 


Select CleverWare_EpicUpdateTable.*, CDCleverWareteamvelocity.storyHours, case when issue_status = 1 then 1 else 0 end as column1  from CleverWare_EpicUpdateTable
 join CDCleverWareteamvelocity 
on CleverWare_EpicUpdateTable.Team = CDCleverWareteamvelocity.team and CleverWare_EpicUpdateTable.`Story Points` = CDCleverWareteamvelocity.points ;

Select * from CleverWare_EpicUpdateLink ;

END
