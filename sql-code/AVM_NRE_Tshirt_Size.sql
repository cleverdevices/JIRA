CREATE DEFINER=`readonly`@`%` PROCEDURE `AVM_NRE_Tshirt_Size`()
BEGIN

drop table if exists AVM_NRE_Tshirt_Size_Table ;
create table AVM_NRE_Tshirt_Size_Table

select concat("AVMA-",EPIC_ISSUE_NUM) as Epic_ID, numbervalue as NRE_HOURS, customfield as CF, issuestatus from 
			(select ji.id as EPIC_ID, issuenum EPIC_ISSUE_NUM, project, issuestatus
			from jiraissue ji where project=10291 and ji.issuetype in (8,9,4,5, 3) )
			 as A left join  Customfieldvalue cfv on a.epic_id = cfv.issue where customfield in (14761)
union
select concat("ACE-",EPIC_ISSUE_NUM) as Epic_ID, numbervalue as NRE_HOURS, customfield as CF, issuestatus from 
			(select ji.id as EPIC_ID, issuenum EPIC_ISSUE_NUM, project, issuestatus
			from jiraissue ji where project=10692 and ji.issuetype in (8,9,4,5, 3) )
			 as A left join  Customfieldvalue cfv on a.epic_id = cfv.issue where customfield in (14761);


END
