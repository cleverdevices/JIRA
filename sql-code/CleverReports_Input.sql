CREATE DEFINER=`readonly`@`%` PROCEDURE `CleverReports_Input`()
BEGIN
	call CleverReports_updateInput() ;
    
drop table if exists CleverReports_InputTable ;
create table CleverReports_InputTable    
    
    Select CleverReports_middleInput.* ,

ifnull(case when CleverReports_middleInput.Ticket_Closed = 1 then 0 else (case when (CleverReports_middleInput.Closed_Story_Points + CleverReports_middleInput.Remaining_Story_Points = 0) then CleverReports_middleInput.Proposal_or_NRE_Hours else (case when (CleverReports_middleInput.Closed_Story_Points + CleverReports_middleInput.Remaining_Story_Points) > CleverReports_middleInput.Proposal_or_NRE_Hours then CleverReports_middleInput.Remaining_Story_Points else (CleverReports_middleInput.Proposal_or_NRE_Hours - CleverReports_middleInput.Closed_Story_Points) end) end) end, 0) as Hours_to_Use

from CleverReports_middleInput ;

END
