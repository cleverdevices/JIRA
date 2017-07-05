CREATE DEFINER=`readonly`@`%` PROCEDURE `GreyHawk_updateInput`()
BEGIN

call GreyHawk_TicketToUse() ;

drop table if exists GreyHawk_middleInput ;
create table GreyHawk_middleInput

Select GreyHawk_startInput.* ,case when ((GreyHawk_EpicUpdateLink.epic_issuenum = GreyHawk_startInput.Ticket_to_Use) AND GreyHawk_EpicUpdateLink.column1 = 0) then round(sum(GreyHawk_EpicUpdateLink.storyHours),0) else 0 end as Closed_Story_Points,
case when ((GreyHawk_EpicUpdateLink.epic_issuenum = GreyHawk_startInput.Ticket_to_Use) AND GreyHawk_EpicUpdateLink.column1 = 1) then round(sum(GreyHawk_EpicUpdateLink.storyHours),0) else 0 end as Remaining_Story_Points
from GreyHawk_startInput left join GreyHawk_EpicUpdateLink on GreyHawk_EpicUpdateLink.epic_issuenum = GreyHawk_startInput.Ticket_to_Use

group by Manual_JIRA, NRE_JIRA, Linked, customer, version ;

END
