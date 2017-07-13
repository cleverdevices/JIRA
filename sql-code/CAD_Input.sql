CREATE DEFINER=`readonly`@`%` PROCEDURE `CAD_Input`()
BEGIN
	call CAD_updateInput() ;
    
drop table if exists CAD_InputTable ;
create table CAD_InputTable    
    
    Select CAD_middleInput.* ,

ifnull(case when CAD_middleInput.Ticket_Closed = 1 then 0 else (case when (CAD_middleInput.Closed_Story_Points + CAD_middleInput.Remaining_Story_Points = 0) then CAD_middleInput.Proposal_or_NRE_Hours else (case when (CAD_middleInput.Closed_Story_Points + CAD_middleInput.Remaining_Story_Points) > CAD_middleInput.Proposal_or_NRE_Hours then CAD_middleInput.Remaining_Story_Points else (CAD_middleInput.Proposal_or_NRE_Hours - CAD_middleInput.Closed_Story_Points) end) end) end, 0) as Hours_to_Use,
workMatch.releaseRow as Release_Actual


from CAD_middleInput 
left join workMatch on CAD_middleInput.ReleaseDate = workMatch.calendar_date;

END
