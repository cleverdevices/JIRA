CREATE DEFINER=`readonly`@`%` PROCEDURE `CAD_updateInput`()
BEGIN

call CAD_TicketToUse() ;

drop table if exists CAD_middleInput ;
create table CAD_middleInput

Select CAD_startInput.* ,
case when (CAD_EpicUpdateLink.epic_issuenum = CAD_startInput.Ticket_to_Use) then (select round(sum(CAD_EpicUpdateLink.storyHours)) from CAD_EpicUpdateLink where CAD_EpicUpdateLink.column1 = 0 and CAD_EpicUpdateLink.epic_issuenum = CAD_startInput.Ticket_to_Use ) else 0 end as Closed_Story_Points,
case when (CAD_EpicUpdateLink.epic_issuenum = CAD_startInput.Ticket_to_Use) then (select round(sum(CAD_EpicUpdateLink.storyHours)) from CAD_EpicUpdateLink where CAD_EpicUpdateLink.column1 = 1 and CAD_EpicUpdateLink.epic_issuenum = CAD_startInput.Ticket_to_Use) else 0 end as Remaining_Story_Points
from CAD_startInput left join CAD_EpicUpdateLink on CAD_EpicUpdateLink.epic_issuenum = CAD_startInput.Ticket_to_Use

group by Manual_JIRA, NRE_JIRA, Linked, customer, version ;

END
