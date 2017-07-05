CREATE DEFINER=`readonly`@`%` PROCEDURE `CleverReports_NRE_Tshirt_Size`()
BEGIN

drop table if exists CleverReports_NRE_Tshirt_Size_Table ;
create table CleverReports_NRE_Tshirt_Size_Table

select concat("CRS-",EPIC_ISSUE_NUM) as Epic_ID, numbervalue as NRE_HOURS, customfield as CF, issuestatus from 
			(select ji.id as EPIC_ID, issuenum EPIC_ISSUE_NUM, project, issuestatus
			from jiraissue ji where project=10200 and ji.issuetype in (8,9,4,5, 3) )
			 as A left join  Customfieldvalue cfv on a.epic_id = cfv.issue where customfield in (14761);


END
