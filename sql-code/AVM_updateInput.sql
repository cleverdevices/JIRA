CREATE DEFINER=`readonly`@`%` PROCEDURE `AVM_updateInput`()
BEGIN

call AVM_TicketToUse() ;

drop table if exists AVM_middleInput ;
create table AVM_middleInput

Select AVM_startInput.* ,case when ((AVM_EpicUpdateLink.epic_issuenum = AVM_startInput.Ticket_to_Use) AND AVM_EpicUpdateLink.column1 = 0) then round(sum(AVM_EpicUpdateLink.storyHours),0) else 0 end as Closed_Story_Points,
case when ((AVM_EpicUpdateLink.epic_issuenum = AVM_startInput.Ticket_to_Use) AND AVM_EpicUpdateLink.column1 = 1) then round(sum(AVM_EpicUpdateLink.storyHours),0) else 0 end as Remaining_Story_Points
from AVM_startInput left join AVM_EpicUpdateLink on AVM_EpicUpdateLink.epic_issuenum = AVM_startInput.Ticket_to_Use

group by Manual_JIRA, NRE_JIRA, Linked, customer, version ;

END
