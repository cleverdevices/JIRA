drop table if exists JiraLinkTypes;
create table JiraLinkTypes (Link_ID int, jira_subtask_link varchar(100), jira_subtask_inward varchar(100), jira_subtask_outward varchar(100), jira_subtask varchar(100));

insert into JiraLinkTypes values (10010,'Existing Issue','Reported By','Exists In', NULL) ;
insert into JiraLinkTypes values (10012,'Depends','Is Required By','Depends On', NULL) ;
insert into JiraLinkTypes values (10020,'Duplicate','Is Duplicated By','Is a Duplicate of', NULL) ;
insert into JiraLinkTypes values (10030,'Related','Related to','Relates to', NULL) ;
insert into JiraLinkTypes values (10040,'Replace','Replaced By','Replaces', NULL) ;
insert into JiraLinkTypes values (10050,'Finish-to-Start Dependency','Is Finish-to-Start Depended by','Finish-to-Start Depends on', NULL) ;
insert into JiraLinkTypes values (10051,'Finish-to-Finish Dependency','Is Finish-to-Finish Depended by','Finish-to-Finish Depends on', NULL) ;
insert into JiraLinkTypes values (10052,'Start-to-Finish Dependency','Is Start-to-Finish Depended by','Start-to-Finish Depends on', NULL) ;
insert into JiraLinkTypes values (10053,'Start-to-Start Dependency','Is Start-to-Start Depended by','Start-to-Start Depends on', NULL) ;
insert into JiraLinkTypes values (10150,'Epic-Story Link','Has Epic','Is Epic of','jira_gh_epic_story') ;
insert into JiraLinkTypes values (10250,'Defect','Created By','Created', NULL) ;
insert into JiraLinkTypes values (10350,'Tests','Tested By','Tests', NULL) ;
