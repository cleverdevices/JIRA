CREATE DEFINER=`readonly`@`%` PROCEDURE `CleverReports_AgilePtsToNRE`()
BEGIN

#Update Calculate table that converts base query
call CleverReports_EpicUpdate();

#Create Table from new query and join values from static table
DROP TABLE IF EXISTS CleverReports_EpicUpdateLink;
Create Table CleverReports_EpicUpdateLink 


Select CleverReports_EpicUpdateTable.*, CDCleverReportsteamvelocity.storyHours, case when issue_status = 1 then 1 else 0 end as column1  from CleverReports_EpicUpdateTable
 join CDCleverReportsteamvelocity 
on CleverReports_EpicUpdateTable.Team = CDCleverReportsteamvelocity.team and CleverReports_EpicUpdateTable.`Story Points` = CDCleverReportsteamvelocity.points ;

Select * from CleverReports_EpicUpdateLink ;

END
