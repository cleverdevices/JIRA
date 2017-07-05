CREATE DEFINER=`readonly`@`%` PROCEDURE `CleverWare_updateInput`()
BEGIN

call CleverWare_TicketToUse() ;

drop table if exists CleverWare_middleInput ;
create table CleverWare_middleInput

Select CleverWare_startInput.* ,case when ((CleverWare_EpicUpdateLink.epic_issuenum = CleverWare_startInput.Ticket_to_Use) AND CleverWare_EpicUpdateLink.column1 = 0) then round(sum(CleverWare_EpicUpdateLink.storyHours),0) else 0 end as Closed_Story_Points,
case when ((CleverWare_EpicUpdateLink.epic_issuenum = CleverWare_startInput.Ticket_to_Use) AND CleverWare_EpicUpdateLink.column1 = 1) then round(sum(CleverWare_EpicUpdateLink.storyHours),0) else 0 end as Remaining_Story_Points
from CleverWare_startInput left join CleverWare_EpicUpdateLink on CleverWare_EpicUpdateLink.epic_issuenum = CleverWare_startInput.Ticket_to_Use

group by Manual_JIRA, NRE_JIRA, Linked, customer, version ;

END
