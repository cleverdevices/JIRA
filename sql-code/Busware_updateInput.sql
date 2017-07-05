CREATE DEFINER=`readonly`@`%` PROCEDURE `Busware_updateInput`()
BEGIN

call Busware_TicketToUse() ;

drop table if exists Busware_middleInput ;
create table Busware_middleInput

Select Busware_startInput.* ,case when ((Busware_EpicUpdateLink.epic_issuenum = Busware_startInput.Ticket_to_Use) AND Busware_EpicUpdateLink.column1 = 0) then round(sum(Busware_EpicUpdateLink.storyHours),0) else 0 end as Closed_Story_Points,
case when ((Busware_EpicUpdateLink.epic_issuenum = Busware_startInput.Ticket_to_Use) AND Busware_EpicUpdateLink.column1 = 1) then round(sum(Busware_EpicUpdateLink.storyHours),0) else 0 end as Remaining_Story_Points
from Busware_startInput left join Busware_EpicUpdateLink on Busware_EpicUpdateLink.epic_issuenum = Busware_startInput.Ticket_to_Use

group by Manual_JIRA, NRE_JIRA, Linked, customer, version ;

END
