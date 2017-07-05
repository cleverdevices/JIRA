CREATE DEFINER=`readonly`@`%` PROCEDURE `CleverReports_EpicUpdate`()
BEGIN

Drop table if exists CleverReports_EpicUpdateTable;
Create Table CleverReports_EpicUpdateTable 

select concat("CRS-",t1.epic_issuenum)  as epic_issuenum, t1.story_num, t1.issue_status,
t1.s as 'Story Points', 
1 as 'Team' from
(select B.*, cfv.CUSTOMFIELD, cfv.numbervalue as s, cfv.stringvalue as t
 from customfieldvalue cfv join 
	(select EPIC_IssueNUM, ji.issuenum as Story_Num, a.story_id as Story_ID, ji.issuetype as Issue_Type, ji.issuestatus as Issue_Status
	from jiraissue ji join  
		(select ji.id as EPIC_ID, ji.issuetype, ji.issuenum as EPIC_IssueNUM , il.destination as Story_id, il.*
		from jiraissue ji left join issuelink il on  ji.id = il.source
		where project = 10200 and issuetype =8  and il.linktype =10150
		) as A
		on ji.id = a.story_id) B on cfv.issue =B.story_id
where cfv.customfield in (10463)) as T1
union all
select concat("CRS-",t1.story_num)  as epic_issuenum, t1.story_num, t1.issue_status,
t1.s as 'Story Points', 1 as 'Team' from 
(select B.*, cfv.CUSTOMFIELD, cfv.numbervalue as s, cfv.stringvalue as t
 from customfieldvalue cfv join 
	(select ji.issuenum as Story_Num, ji.id as Story_ID, ji.issuetype as Issue_Type, ji.issuestatus as Issue_Status
	from jiraissue ji where issuetype in (2,3,4,5,6,7,9) and issuestatus not in (6) and project =10200) B on cfv.issue =B.story_id
where cfv.customfield in (10463)) as T1;

END
