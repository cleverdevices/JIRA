CREATE DEFINER=`readonly`@`%` PROCEDURE `CleverReports_updateInput`()
BEGIN

call CleverReports_TicketToUse() ;

drop table if exists CleverReports_middleInput ;
create table CleverReports_middleInput

Select CleverReports_startInput.* ,
case when (CleverReports_EpicUpdateLink.epic_issuenum = CleverReports_startInput.Ticket_to_Use) then (select round(sum(CleverReports_EpicUpdateLink.storyHours)) from CleverReports_EpicUpdateLink where CleverReports_EpicUpdateLink.column1 = 0 and CleverReports_EpicUpdateLink.epic_issuenum = CleverReports_startInput.Ticket_to_Use ) else 0 end as Closed_Story_Points,
case when (CleverReports_EpicUpdateLink.epic_issuenum = CleverReports_startInput.Ticket_to_Use) then (select round(sum(CleverReports_EpicUpdateLink.storyHours)) from CleverReports_EpicUpdateLink where CleverReports_EpicUpdateLink.column1 = 1 and CleverReports_EpicUpdateLink.epic_issuenum = CleverReports_startInput.Ticket_to_Use) else 0 end as Remaining_Story_Points
from CleverReports_startInput left join CleverReports_EpicUpdateLink on CleverReports_EpicUpdateLink.epic_issuenum = CleverReports_startInput.Ticket_to_Use

group by Manual_JIRA, NRE_JIRA, Linked, customer, version ;

END
