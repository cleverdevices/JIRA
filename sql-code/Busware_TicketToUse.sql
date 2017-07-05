CREATE DEFINER=`readonly`@`%` PROCEDURE `Busware_TicketToUse`()
BEGIN

call Busware_NRE_Tshirt_Size() ;

drop table if exists Busware_startInput ;
create table Busware_startInput

select Manual_JIRA, NRE_JIRA, Linked, summary, duedate, Customer, DevelopmentType, NRE_Proposal, TShirtSize, Version, ReleaseDate, StartDate, Project, Open_hours, Closed_Hours, round(ActualNRE, 0) as ActualNRE,	
case when (Linked is null AND Manual_JIRA is null) then NRE_JIRA else (case when Linked is null then Manual_JIRA else Linked end) end AS Ticket_to_Use,    
case when (DevelopmentType is null AND Linked is null AND Manual_Jira is null) then 'Proposal' else (case when (DevelopmentType is null AND Manual_JIRA is not null) then 'Development' else DevelopmentType end) end as Type_of_Work,    
case when TShirtSize > 0 then TShirtSize else (case when NRE_Proposal = 1 then 0 else NRE_Proposal end) end as Proposal_or_NRE_Hours,
case when (((select Busware_NRE_Tshirt_Size_Table.issuestatus from Busware_NRE_Tshirt_Size_Table where Ticket_to_Use = Busware_NRE_Tshirt_Size_Table.Epic_ID) = 6) OR ((select Busware_NRE_Tshirt_Size_Table.issuestatus from Busware_NRE_Tshirt_Size_Table where Ticket_to_Use = Busware_NRE_Tshirt_Size_Table.Epic_ID) = 5)) Then 1 else 0 end as Ticket_Closed 


from Busware_Sheet2Table ;

END
