CREATE DEFINER=`readonly`@`%` PROCEDURE `BusTime_Input`()
BEGIN
	call BusTime_updateInput() ;
    
drop table if exists BusTime_InputTable ;
create table BusTime_InputTable    
    
    Select BusTime_middleInput.* ,

ifnull(case when BusTime_middleInput.Ticket_Closed = 1 then 0 else (case when (BusTime_middleInput.Closed_Story_Points + BusTime_middleInput.Remaining_Story_Points = 0) then BusTime_middleInput.Proposal_or_NRE_Hours else (case when (BusTime_middleInput.Closed_Story_Points + BusTime_middleInput.Remaining_Story_Points) > BusTime_middleInput.Proposal_or_NRE_Hours then BusTime_middleInput.Remaining_Story_Points else (BusTime_middleInput.Proposal_or_NRE_Hours - BusTime_middleInput.Closed_Story_Points) end) end) end, 0) as Hours_to_Use

from BusTime_middleInput ;

END
