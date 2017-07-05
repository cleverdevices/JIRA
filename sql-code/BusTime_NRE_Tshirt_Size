CREATE DEFINER=`readonly`@`%` PROCEDURE `BusTime_NRE_Tshirt_Size`()
BEGIN

drop table if exists BusTime_NRE_Tshirt_Size_Table ;
create table BusTime_NRE_Tshirt_Size_Table

select concat("BSTA-",EPIC_ISSUE_NUM) as Epic_ID, numbervalue as NRE_HOURS, customfield as CF, issuestatus from 
			(select ji.id as EPIC_ID, issuenum EPIC_ISSUE_NUM, project, issuestatus
			from jiraissue ji where project=10790 and ji.issuetype=8 )
			 as A left join  Customfieldvalue cfv on a.epic_id = cfv.issue where customfield in (14761) ;


END
