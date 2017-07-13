CREATE DEFINER=`readonly`@`%` PROCEDURE `SmartYard_Input`()
BEGIN
	call SmartYard_updateInput() ;
    
drop table if exists SmartYard_InputTable ;
create table SmartYard_InputTable    
    
    Select SmartYard_middleInput.* ,

ifnull(case when SmartYard_middleInput.Ticket_Closed = 1 then 0 else (case when (SmartYard_middleInput.Closed_Story_Points + SmartYard_middleInput.Remaining_Story_Points = 0) then SmartYard_middleInput.Proposal_or_NRE_Hours else (case when (SmartYard_middleInput.Closed_Story_Points + SmartYard_middleInput.Remaining_Story_Points) > SmartYard_middleInput.Proposal_or_NRE_Hours then SmartYard_middleInput.Remaining_Story_Points else (SmartYard_middleInput.Proposal_or_NRE_Hours - SmartYard_middleInput.Closed_Story_Points) end) end) end, 0) as Hours_to_Use

from SmartYard_middleInput ;

select SmartYard_InputTable.*, workMatch.releaseRow as Release_Actual from SmartYard_InputTable
left join workMatch on SmartYard_InputTable.ReleaseDate = workMatch.calendar_date;

END
