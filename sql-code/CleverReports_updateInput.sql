CREATE DEFINER=`readonly`@`%` PROCEDURE `CleverReports_updateInput`()
BEGIN

call CleverReports_TicketToUse() ;

drop table if exists CleverReports_middleInput ;
create table CleverReports_middleInput

Select CleverReports_startInput.* ,case when ((CleverReports_EpicUpdateLink.epic_issuenum = CleverReports_startInput.Ticket_to_Use) AND CleverReports_EpicUpdateLink.column1 = 0) then round(sum(CleverReports_EpicUpdateLink.storyHours),0) else 0 end as Closed_Story_Points,
case when ((CleverReports_EpicUpdateLink.epic_issuenum = CleverReports_startInput.Ticket_to_Use) AND CleverReports_EpicUpdateLink.column1 = 1) then round(sum(CleverReports_EpicUpdateLink.storyHours),0) else 0 end as Remaining_Story_Points
from CleverReports_startInput left join CleverReports_EpicUpdateLink on CleverReports_EpicUpdateLink.epic_issuenum = CleverReports_startInput.Ticket_to_Use

group by Manual_JIRA, NRE_JIRA, Linked, customer, version ;

END
