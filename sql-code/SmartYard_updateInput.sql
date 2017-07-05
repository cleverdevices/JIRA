CREATE DEFINER=`readonly`@`%` PROCEDURE `SmartYard_updateInput`()
BEGIN

call SmartYard_TicketToUse() ;

drop table if exists SmartYard_middleInput ;
create table SmartYard_middleInput

Select SmartYard_startInput.* ,case when ((SmartYard_EpicUpdateLink.epic_issuenum = SmartYard_startInput.Ticket_to_Use) AND SmartYard_EpicUpdateLink.column1 = 0) then round(sum(SmartYard_EpicUpdateLink.storyHours),0) else 0 end as Closed_Story_Points,
case when ((SmartYard_EpicUpdateLink.epic_issuenum = SmartYard_startInput.Ticket_to_Use) AND SmartYard_EpicUpdateLink.column1 = 1) then round(sum(SmartYard_EpicUpdateLink.storyHours),0) else 0 end as Remaining_Story_Points
from SmartYard_startInput left join SmartYard_EpicUpdateLink on SmartYard_EpicUpdateLink.epic_issuenum = SmartYard_startInput.Ticket_to_Use

group by Manual_JIRA, NRE_JIRA, Linked, customer, version ;

END
