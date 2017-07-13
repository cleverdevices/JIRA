CREATE DEFINER=`readonly`@`%` PROCEDURE `AVM_Input`()
BEGIN
	call AVM_updateInput() ;
    
drop table if exists AVM_InputTable ;
create table AVM_InputTable    
    
    Select AVM_middleInput.* ,

ifnull(case when AVM_middleInput.Ticket_Closed = 1 then 0 else (case when (AVM_middleInput.Closed_Story_Points + AVM_middleInput.Remaining_Story_Points = 0) then AVM_middleInput.Proposal_or_NRE_Hours else (case when (AVM_middleInput.Closed_Story_Points + AVM_middleInput.Remaining_Story_Points) > AVM_middleInput.Proposal_or_NRE_Hours then AVM_middleInput.Remaining_Story_Points else (AVM_middleInput.Proposal_or_NRE_Hours - AVM_middleInput.Closed_Story_Points) end) end) end, 0) as Hours_to_Use,
workMatch.releaseRow as Release_Actual


from AVM_middleInput 
left join workMatch on AVM_middleInput.ReleaseDate = workMatch.calendar_date;



END
