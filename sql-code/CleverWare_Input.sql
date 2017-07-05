CREATE DEFINER=`readonly`@`%` PROCEDURE `CleverWare_Input`()
BEGIN
	call CleverWare_updateInput() ;
    
drop table if exists CleverWare_InputTable ;
create table CleverWare_InputTable    
    
    Select CleverWare_middleInput.* ,

ifnull(case when CleverWare_middleInput.Ticket_Closed = 1 then 0 else (case when (CleverWare_middleInput.Closed_Story_Points + CleverWare_middleInput.Remaining_Story_Points = 0) then CleverWare_middleInput.Proposal_or_NRE_Hours else (case when (CleverWare_middleInput.Closed_Story_Points + CleverWare_middleInput.Remaining_Story_Points) > CleverWare_middleInput.Proposal_or_NRE_Hours then CleverWare_middleInput.Remaining_Story_Points else (CleverWare_middleInput.Proposal_or_NRE_Hours - CleverWare_middleInput.Closed_Story_Points) end) end) end, 0) as Hours_to_Use

from CleverWare_middleInput ;

END
