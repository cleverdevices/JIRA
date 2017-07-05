CREATE DEFINER=`readonly`@`%` PROCEDURE `SmartYard_NRE_Tshirt_Size`()
BEGIN

drop table if exists SmartYard_NRE_Tshirt_Size_Table ;
create table SmartYard_NRE_Tshirt_Size_Table

select concat("SMY-",EPIC_ISSUE_NUM) as Epic_ID, numbervalue as NRE_HOURS, customfield as CF, issuestatus from 
			(select ji.id as EPIC_ID, issuenum EPIC_ISSUE_NUM, project, issuestatus
			from jiraissue ji where project=10590 and ji.issuetype in (8,9,4,5, 3) )
			 as A left join  Customfieldvalue cfv on a.epic_id = cfv.issue where customfield in (14761);

END
