CREATE DEFINER=`readonly`@`%` PROCEDURE `Busware_Input`()
BEGIN
	call Busware_updateInput() ;
    
drop table if exists Busware_InputTable ;
create table Busware_InputTable    
    
    Select Busware_middleInput.* ,

ifnull(case when Busware_middleInput.Ticket_Closed = 1 then 0 else (case when (Busware_middleInput.Closed_Story_Points + Busware_middleInput.Remaining_Story_Points = 0) then Busware_middleInput.Proposal_or_NRE_Hours else (case when (Busware_middleInput.Closed_Story_Points + Busware_middleInput.Remaining_Story_Points) > Busware_middleInput.Proposal_or_NRE_Hours then Busware_middleInput.Remaining_Story_Points else (Busware_middleInput.Proposal_or_NRE_Hours - Busware_middleInput.Closed_Story_Points) end) end) end, 0) as Hours_to_Use,
workMatch.releaseRow as Release_Actual


from Busware_middleInput 
left join workMatch on Busware_middleInput.ReleaseDate = workMatch.calendar_date;

END
