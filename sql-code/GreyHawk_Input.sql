CREATE DEFINER=`readonly`@`%` PROCEDURE `GreyHawk_Input`()
BEGIN
	call GreyHawk_updateInput() ;
    
drop table if exists GreyHawk_InputTable ;
create table GreyHawk_InputTable    
    
    Select GreyHawk_middleInput.* ,

ifnull(case when GreyHawk_middleInput.Ticket_Closed = 1 then 0 else (case when (GreyHawk_middleInput.Closed_Story_Points + GreyHawk_middleInput.Remaining_Story_Points = 0) then GreyHawk_middleInput.Proposal_or_NRE_Hours else (case when (GreyHawk_middleInput.Closed_Story_Points + GreyHawk_middleInput.Remaining_Story_Points) > GreyHawk_middleInput.Proposal_or_NRE_Hours then GreyHawk_middleInput.Remaining_Story_Points else (GreyHawk_middleInput.Proposal_or_NRE_Hours - GreyHawk_middleInput.Closed_Story_Points) end) end) end, 0) as Hours_to_Use,
workMatch.releaseRow as Release_Actual


from GreyHawk_middleInput 
left join workMatch on GreyHawk_middleInput.ReleaseDate = workMatch.calendar_date;

END
