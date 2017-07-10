CREATE DEFINER=`readonly`@`%` PROCEDURE `BusTime_updateInput`()
BEGIN

call BusTime_TicketToUse() ;

drop table if exists BusTime_middleInput ;
create table BusTime_middleInput

Select BusTime_startInput.* ,
case when (BusTime_EpicUpdateLink.epic_issuenum = BusTime_startInput.Ticket_to_Use) then (select round(sum(BusTime_EpicUpdateLink.storyHours)) from BusTime_EpicUpdateLink where BusTime_EpicUpdateLink.column1 = 0 and BusTime_EpicUpdateLink.epic_issuenum = BusTime_startInput.Ticket_to_Use ) else 0 end as Closed_Story_Points,
case when (BusTime_EpicUpdateLink.epic_issuenum = BusTime_startInput.Ticket_to_Use) then (select round(sum(BusTime_EpicUpdateLink.storyHours)) from BusTime_EpicUpdateLink where BusTime_EpicUpdateLink.column1 = 1 and BusTime_EpicUpdateLink.epic_issuenum = BusTime_startInput.Ticket_to_Use) else 0 end as Remaining_Story_Points
from BusTime_startInput left join BusTime_EpicUpdateLink on BusTime_EpicUpdateLink.epic_issuenum = BusTime_startInput.Ticket_to_Use

group by Manual_JIRA, NRE_JIRA, Linked, customer, version ;

END
