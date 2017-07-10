CREATE DEFINER=`readonly`@`%` PROCEDURE `AVM_updateInput`()
BEGIN

call AVM_TicketToUse() ;

drop table if exists AVM_middleInput ;
create table AVM_middleInput

Select AVM_startInput.* ,
case when (AVM_EpicUpdateLink.epic_issuenum = AVM_startInput.Ticket_to_Use) then (select round(sum(AVM_EpicUpdateLink.storyHours)) from AVM_EpicUpdateLink where AVM_EpicUpdateLink.column1 = 0 and AVM_EpicUpdateLink.epic_issuenum = AVM_startInput.Ticket_to_Use ) else 0 end as Closed_Story_Points,
case when (AVM_EpicUpdateLink.epic_issuenum = AVM_startInput.Ticket_to_Use) then (select round(sum(AVM_EpicUpdateLink.storyHours)) from AVM_EpicUpdateLink where AVM_EpicUpdateLink.column1 = 1 and AVM_EpicUpdateLink.epic_issuenum = AVM_startInput.Ticket_to_Use) else 0 end as Remaining_Story_Points
from AVM_startInput left join AVM_EpicUpdateLink on AVM_EpicUpdateLink.epic_issuenum = AVM_startInput.Ticket_to_Use

group by Manual_JIRA, NRE_JIRA, Linked, customer, version ;

END
