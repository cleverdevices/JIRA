CREATE DEFINER=`readonly`@`%` PROCEDURE `BusTime_updateInput`()
BEGIN

call BusTime_TicketToUse() ;

drop table if exists BusTime_middleInput ;
create table BusTime_middleInput

Select BusTime_startInput.* ,case when ((BusTime_EpicUpdateLink.epic_issuenum = BusTime_startInput.Ticket_to_Use) AND BusTime_EpicUpdateLink.column1 = 0) then round(sum(BusTime_EpicUpdateLink.storyHours),0) else 0 end as Closed_Story_Points,
case when ((BusTime_EpicUpdateLink.epic_issuenum = BusTime_startInput.Ticket_to_Use) AND BusTime_EpicUpdateLink.column1 = 1) then round(sum(BusTime_EpicUpdateLink.storyHours),0) else 0 end as Remaining_Story_Points
from BusTime_startInput left join BusTime_EpicUpdateLink on BusTime_EpicUpdateLink.epic_issuenum = BusTime_startInput.Ticket_to_Use

group by Manual_JIRA, NRE_JIRA, Linked, customer, version ;

END
