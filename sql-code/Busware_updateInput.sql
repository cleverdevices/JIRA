CREATE DEFINER=`readonly`@`%` PROCEDURE `Busware_updateInput`()
BEGIN

call Busware_TicketToUse() ;

drop table if exists Busware_middleInput ;
create table Busware_middleInput

Select Busware_startInput.* ,
case when (Busware_EpicUpdateLink.epic_issuenum = Busware_startInput.Ticket_to_Use) then (select round(sum(Busware_EpicUpdateLink.storyHours)) from Busware_EpicUpdateLink where Busware_EpicUpdateLink.column1 = 0 and Busware_EpicUpdateLink.epic_issuenum = Busware_startInput.Ticket_to_Use ) else 0 end as Closed_Story_Points,
case when (Busware_EpicUpdateLink.epic_issuenum = Busware_startInput.Ticket_to_Use) then (select round(sum(Busware_EpicUpdateLink.storyHours)) from Busware_EpicUpdateLink where Busware_EpicUpdateLink.column1 = 1 and Busware_EpicUpdateLink.epic_issuenum = Busware_startInput.Ticket_to_Use) else 0 end as Remaining_Story_Points
from Busware_startInput left join Busware_EpicUpdateLink on Busware_EpicUpdateLink.epic_issuenum = Busware_startInput.Ticket_to_Use

group by Manual_JIRA, NRE_JIRA, Linked, customer, version ;

END
