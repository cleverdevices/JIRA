CREATE DEFINER=`readonly`@`%` PROCEDURE `BusTime_Sheet2`()
BEGIN

#Select all the epics that are open and are not linked to an NRE ticket
#Select all the epics that are open and are not linked to an NRE ticket
				   #change me out for projects                   

DROP TABLE if exists BusTime_Sheet2Table;
CREATE Table BusTime_Sheet2Table


select Y.*, Open_Hours, Closed_Hours, ActualNRE from (
select concat(p.pkey,"-",X.Manual_JIRA) as Manual_JIRA, X.NRE_JIRA, X.Linked , X.summary, X.Description, X.issuestatus, 
	X.duedate, X.timespent, X.Customer, X.DevelopmentType,  X.NRE_Proposal, X.TShirtSize, X.Version, X.ReleaseDate, X.StartDate, p.pkey as Project from (
	Select   F.project, F.issuenum as Manual_JIRA, null as NRE_JIRA,Null as Linked , F.summary, F. Description, F. issuestatus, 
	F.duedate, F.timespent, F. Customer, F. DevelopmentType,  null as NRE_Proposal, G.Tshirtsize as TShirtSize, F.version as Version, F.ReleaseDate, F.StartDate from 	
		(Select D.*, e.developmenttype as DevelopmentType from 
			(select B.project, B.id, B.issuenum, B.issuetype, B.summary, B.description, B.issuestatus, B.duedate, B.timespent, B.Customer, C.version, C.ReleaseDate, C.StartDate from 
				(select ji.project, ji.id, ji.issuenum, ji.issuetype, ji.summary, ji.description, ji.issuestatus, ji.duedate, ji.timespent, A.Customer
				from jiraissue ji left outer join (select cfv.id, cfv.issue, cfv.numbervalue, cfo.customvalue as Customer 
									from customfieldvalue cfv, 		customfieldoption cfo 
									where cfo.id = cfv.stringvalue and cfo.customfield = 10021)  A on ji.id = A.issue				
				where ji.issuetype =8 
				and ji.project in (10790)     #change me out for projects
				and ji.id not in (select AA.D from  
									(select destination D from 
										issuelink where linktype=10012 ) AA left join jiraissue ji on
										AA.D =ji.id
										where project in (10790))
				and ji.issuestatus not in (6,10002,5)
				and ji.updated >'1/1/2015') B 
				left outer join (SELECT 
								(SELECT  id from jiraissue WHERE jiraissue.ID = nodeassociation.source_node_id) AS id2,
								(SELECT vname FROM projectversion WHERE projectversion.ID = nodeassociation.sink_node_id) AS version,
								(SELECT releasedate FROM projectversion WHERE projectversion.ID = nodeassociation.sink_node_id) AS ReleaseDate,
								(SELECT StartDate FROM projectversion WHERE projectversion.ID = nodeassociation.sink_node_id) AS StartDate
								FROM nodeassociation JOIN projectversion ON nodeassociation.sink_node_id = projectversion.ID 
								
								WHERE source_node_entity='Issue' and (association_type='IssueFixVersion'))  C on B.id = C.id2) D left outer join 
							   (Select AA_id as e_id, cfo.customvalue as DevelopmentType  from 
									(select ji.id as AA_id, cfv.* from jiraissue ji left join 
						 Customfieldvalue cfv on ji.id = cfv.issue where customfield  =14763 ) As AA left join customfieldoption cfo on AA.stringvalue = cfo.id) E on D.id =E.e_id) F
						 left outer join  (
						 select a.epic_id as id, numbervalue as TShirtSize from 
			(select ji.id as EPIC_ID, issuenum EPIC_ISSUE_NUM, project
			from jiraissue ji where  ji.issuetype in(8,9,2,3,4,5,6,7)
			)
				as A left join  Customfieldvalue cfv on a.epic_id = cfv.issue where customfield in (14761)) G on F.id = G.id) X left join
                project p on X.project = p.id) Y left join  (
						select concat(p.pkey,"-",X.story) as Story ,ActualNRE from (        
						select  A.issuenum as story, sum(ji.timespent)/3600 as ActualNRE, ji.project from jiraissue ji join 
							(select project, issuenum, timespent, destination 
								from jiraissue ji join issuelink il on ji.id = il.source 
						where il.linktype =10150 and project = 10790) as A on ji.id = a.destination 
						group by story) X left join project p on X.project = p.id) Z 
                        
                        on Y.manual_jira = Z.Story

#get the story points that are opened and closed                        
                        left join (select concat(p.pkey,"-",X.epic_issuenum) as epic_issuenum,Closed_Hours, Open_hours from (
select project, epic_issuenum, sum(closed_hours) as Closed_Hours, sum(open_hours) as Open_Hours from 
(
	select project, epic_issuenum, 
	sum(case when issue_status in (6,10002,5) then hours else 0 end) as Closed_hours,
	sum(case when issue_status in (1,2,3,4,8,10016) then hours else 0 end) as Open_hours
	 from 
	(select *, qry.Storypoints  * 5.25 as Hours from 
		(select project,  epic_issuenum, t1.story_num, t1.issue_status,
		t1.s as StoryPoints, 
		1 as 'Team' from
		(select B.*, cfv.CUSTOMFIELD, cfv.numbervalue as s, cfv.stringvalue as t
		 from customfieldvalue cfv join 
			(select A.project, EPIC_IssueNUM, ji.issuenum as Story_Num, a.story_id as Story_ID, ji.issuetype as Issue_Type, ji.issuestatus as Issue_Status
			from jiraissue ji join  
				(select ji.project, ji.id as EPIC_ID, ji.issuetype, ji.issuenum as EPIC_IssueNUM , il.destination as Story_id, il.*
				from jiraissue ji left join issuelink il on  ji.id = il.source
				where project = 10790 and issuetype =8  and il.linktype =10150
				) as A
				on ji.id = a.story_id) B on cfv.issue =B.story_id
		where cfv.customfield in (10463)) as T1
		union all
		
        select project, t1.story_num  as epic_issuenum, t1.story_num, t1.issue_status,
		t1.s as 'Story Points', 1 as 'Team' from 
		(select  B.*, cfv.CUSTOMFIELD, cfv.numbervalue as s, cfv.stringvalue as t
		 from customfieldvalue cfv join 
			(select project, ji.issuenum as Story_Num, ji.id as Story_ID, ji.issuetype as Issue_Type, ji.issuestatus as Issue_Status
			from jiraissue ji where issuetype in (2,3,4,5,6,7,9) and issuestatus not in (6,5,10002) and project =10692) B on cfv.issue =B.story_id
		where cfv.customfield in (10463)) as T1 
        
        
        ) as qry) as include_hours
		group by project, epic_issuenum, issue_status ) as rollup
group by project, epic_issuenum) X left join project  p on X.project = p.id) W on Y.manual_jira =W.epic_issuenum
                
                 
union all                  

#select all of the stories and other work that are not linked to NRE
select Y.*, Open_Hours, Closed_Hours, null as ActualNRE from (
select concat(p.pkey,"-",X.issuenum) as Manual_JIRA,  X.NRE_JIRA, X.Linked ,X.summary, X.Description, X.issuestatus,
 X.duedate, X.timespent, X.Customer, X.DevelopmentType, X.NRE_Proposal, X.TShirtSize, X.Version,  X.ReleaseDate, X.StartDate, p.pkey as Project  
 from (
	Select F.project, F.issuenum, null as NRE_JIRA, Null as Linked ,F.summary, F. Description, F. issuestatus,
	 F.duedate, F.timespent, F. Customer, F. DevelopmentType, null as NRE_Proposal, G.Tshirtsize as TShirtSize, F.version as Version,  F.ReleaseDate, F.StartDate  from
		(Select D.*, e.developmenttype as DevelopmentType from 
			(select B.project, B.id, B.issuenum, B.issuetype, B.summary, B.description, B.issuestatus, B.duedate, B.timespent, B.Customer, C.version,  C.ReleaseDate, C.StartDate from 
				(select ji.project, ji.id, ji.issuenum, ji.issuetype, ji.summary, ji.description, ji.issuestatus, ji.duedate, ji.timespent, A.Customer
				from jiraissue ji left outer join (select cfv.id, cfv.issue, cfv.numbervalue, cfo.customvalue as Customer 
									from customfieldvalue cfv, 
									customfieldoption cfo 
									where cfo.id = cfv.stringvalue and cfo.customfield = 10021)  A on ji.id = A.issue				
				where issuetype in (3,4,5,6,7,9) 
				and ji.project in (10790) 
				and ji.id not in (select destination from issuelink where linktype in ( 10012, 10150) )
				and ji.issuestatus not in (6,5,10002)) B 
				left outer join (SELECT 
								(SELECT  id from jiraissue WHERE jiraissue.ID = nodeassociation.source_node_id) AS id2,
								(SELECT vname FROM projectversion WHERE projectversion.ID = nodeassociation.sink_node_id) AS version,
								(SELECT releasedate FROM projectversion WHERE projectversion.ID = nodeassociation.sink_node_id) AS ReleaseDate,
								(SELECT StartDate FROM projectversion WHERE projectversion.ID = nodeassociation.sink_node_id) AS StartDate
								FROM nodeassociation JOIN projectversion ON nodeassociation.sink_node_id = projectversion.ID 
								WHERE source_node_entity='Issue' and (association_type='IssueFixVersion'))  C on B.id = C.id2) D left outer join 
							   (Select AA_id as e_id, cfo.customvalue as DevelopmentType  from 
									(select ji.id as AA_id, cfv.* from jiraissue ji left join 
						 Customfieldvalue cfv on ji.id = cfv.issue where customfield  =14763 ) As AA left join customfieldoption cfo on AA.stringvalue = cfo.id) E on D.id =E.e_id) F
						 left outer join  (
						 select a.epic_id as id, numbervalue as TShirtSize from 
			(select ji.id as EPIC_ID, issuenum EPIC_ISSUE_NUM, project
			from jiraissue ji where  ji.issuetype in(8,9,2,3,4,5,6,7))
				as A left join  Customfieldvalue cfv on a.epic_id = cfv.issue where customfield in (14761)) G on F.id = G.id ) X
            left join project p on X.project = p.id) as Y
            
            left join (select concat(p.pkey,"-",X.epic_issuenum) as epic_issuenum,Closed_Hours, Open_hours from (
select project, epic_issuenum, sum(closed_hours) as Closed_Hours, sum(open_hours) as Open_Hours from 
(
	select project, epic_issuenum, 
	sum(case when issue_status in (6,5,10002) then hours else 0 end) as Closed_hours,
	sum(case when issue_status in (1,2,3,4,8,10016) then hours else 0 end) as Open_hours
	 from 
	(select *, qry.Storypoints  * 5.25 as Hours from 
		(select project,  epic_issuenum, t1.story_num, t1.issue_status,
		t1.s as StoryPoints, 
		1 as 'Team' from
		(select B.*, cfv.CUSTOMFIELD, cfv.numbervalue as s, cfv.stringvalue as t
		 from customfieldvalue cfv join 
			(select A.project, EPIC_IssueNUM, ji.issuenum as Story_Num, a.story_id as Story_ID, ji.issuetype as Issue_Type, ji.issuestatus as Issue_Status
			from jiraissue ji join  
				(select ji.project, ji.id as EPIC_ID, ji.issuetype, ji.issuenum as EPIC_IssueNUM , il.destination as Story_id, il.*
				from jiraissue ji left join issuelink il on  ji.id = il.source
				where project = 10790 and issuetype =8  and il.linktype =10150
				) as A
				on ji.id = a.story_id) B on cfv.issue =B.story_id
		where cfv.customfield in (10463)) as T1
		union all
		
        select project, t1.story_num  as epic_issuenum, t1.story_num, t1.issue_status,
		t1.s as 'Story Points', 1 as 'Team' from 
		(select  B.*, cfv.CUSTOMFIELD, cfv.numbervalue as s, cfv.stringvalue as t
		 from customfieldvalue cfv join 
			(select project, ji.issuenum as Story_Num, ji.id as Story_ID, ji.issuetype as Issue_Type, ji.issuestatus as Issue_Status
			from jiraissue ji where issuetype in (2,3,4,5,6,7,9) and issuestatus not in (6,5,10002) and project =10790) B on cfv.issue =B.story_id
		where cfv.customfield in (10463)) as T1 
        
        
        ) as qry) as include_hours
		group by project, epic_issuenum, issue_status ) as rollup
group by project, epic_issuenum) X left join project  p on X.project = p.id) as Z on Y.manual_jira = Z.epic_issuenum
            
union all                                      
#-------------------------

#all NRE tickets that have product specific hours in them
#get closed product tickets

-- retrieve NREs with desired characteristic
-- retrieve NREs with desired characteristic
select
  null as manual_jira,
  concat(project.pkey, '-', jiraissue.issuenum) as NRE_JIRA,
  dependent_issues.dependent_issue_num linked,
  IfNull(dependent_issues.summary, jiraissue.summary) summary,
  IfNull(dependent_issues.DESCRIPTION, jiraissue.DESCRIPTION) description,
  jiraissue.issuestatus,
  jiraissue.DUEDATE,
  jiraissue.TIMESPENT,
  customer,
  null as developmenttype,
  customfieldvalue.NUMBERVALUE as NRE_Proposal,
  TShirtSize,
  version,
  ReleaseDate,
  StartDate,
  project.pkey,
  sum(OpenHours) Open_Hours,
  sum(ClosedHours) ClosedHours,
  sum(Actual_NRE) ActualNRE
FROM
  jiraissue
inner join
  project on jiraissue.PROJECT = PROJECT.ID
inner join
  customfieldvalue on issue = jiraissue.id
-- find customer[s] for NRE ticket
left outer join
    (
      select
        issue,
        customfieldoption.customvalue customer
        FROM
          customfieldvalue
          inner join customfieldoption ON
                                         customfieldoption.CUSTOMFIELD = customfieldvalue.CUSTOMFIELD
                                         AND
                                         customfieldoption.ID = customfieldvalue.STRINGVALUE

          where customfieldvalue.CUSTOMFIELD = 10021
      ) customer on jiraissue.id = customer.ISSUE
-- find all dependent epics / stories that are associated with the target project
left outer join (
      select source, destination from issuelink
      inner join jiraissue on issuelink.DESTINATION = jiraissue.ID
      inner join project on jiraissue.PROJECT = PROJECT.ID
      where PROJECT.pkey = 'BSTA'
        -- depends on link (10012)
      and issuelink.LINKTYPE = 10012
    ) issuelink
        on
      issuelink.SOURCE = jiraissue.ID
-- get statistics from dependent epics / issues if present
left outer join
    (
    -- statistics for Epic
    SELECT
      epic.id as dependent_issue_id,
      concat(epic_project.pkey, '-', epic.issuenum) dependent_issue_num,
      epic_project.pkey dependent_project,
      epic.SUMMARY,
      epic.DESCRIPTION,
      sum(CASE WHEN epic_story.issuestatus = 6
        THEN epic_story.TimeSpent
          ELSE 0 END) / 3600                   AS ClosedHours,
      sum(CASE WHEN epic_story.issuestatus = 6
        THEN 0
          ELSE epic_story.TimeSpent END) + epic.TIMESPENT / 3600
        AS OpenHours,
      sum(epic_story.TimeSpent) + epic.TIMESPENT/3600 as Actual_NRE,
      t_shirt_size TShirtSize,
      latest_version,
      epic_version.vname version,
      epic_version.STARTDATE StartDate,
      epic_version.RELEASEDATE ReleaseDate,
      epic.issuestatus dependent_issue_status
    FROM
      jiraissue epic
      # find version of epic
      left outer JOIN (
                   SELECT
                     source_node_id    AS issue_id,
                     sink_node_id AS latest_version
                   FROM
                     nodeassociation
                   WHERE
                     ASSOCIATION_TYPE = 'IssueFixVersion'
                 ) latest_version ON
                                    epic.id = latest_version.issue_id
          left outer JOIN projectversion epic_version ON
                                  epic.PROJECT = epic_version.PROJECT
                                  AND
                                  latest_version = epic_version.ID
      left outer join
      # find children of epic through epic-to-story (10150) links
      # then build statistics for them
      # links must be from target project
      (
        select
          Source,
          TimeSpent,
          issuestatus
        from
          issuelink
          inner join jiraissue on destination = jiraissue.ID
          inner join project on jiraissue.PROJECT = PROJECT.ID
        where
          issuelink.LINKTYPE = 10150
          and
          project.pkey = 'BSTA'
      ) epic_story ON
                          epic_story.SOURCE = epic.ID
      inner join project epic_project on
        epic.PROJECT = epic_project.ID
      left outer join
        (
          SELECT issue, NUMBERVALUE t_shirt_size
          FROM
            customfieldvalue
          WHERE
            customfieldvalue.customfield = 14761
          ) t_shirt on epic.id = t_shirt.issue
    WHERE
      # restrict to Epics from the desired project
      epic.issuetype in (9, 8)
      AND
      epic_project.pkey = 'BSTA'
    group by
      epic.id,
      concat(epic_project.pkey, '-', epic.issuenum),
      epic_project.pkey,
      epic.SUMMARY,
      epic.DESCRIPTION,
      t_shirt_size,
      latest_version,
      epic_version.vname,
      epic_version.STARTDATE,
      epic_version.RELEASEDATE,
      epic.issuestatus,
      epic.TIMESPENT
    UNION
      # the same statistics for individual stories
      # required because some NRE tickets only have stories under them
      SELECT
      story.id as dependent_issue_id,
      concat(project.pkey, '-', story.issuenum) depedendent_issue_num,
      project.pkey dependent_project,
      story.SUMMARY,
      story.DESCRIPTION,
      sum(t_shirt_size) TShirtSize,
      sum(CASE WHEN story.issuestatus = 6
        THEN story.TimeSpent
          ELSE 0 END) / 3600                  AS ClosedHours,
      sum(CASE WHEN story.issuestatus = 6
        THEN 0
          ELSE story.TimeSpent END) / 3600 AS OpenHours,
      sum(story.TimeSpent)/3600 as Actual_NRE,
      latest_version,
      projectversion.vname version,
      projectversion.STARTDATE StartDate,
      projectversion.RELEASEDATE ReleaseDate,
      story.issuestatus
    FROM
      jiraissue story
      left outer JOIN (
                   SELECT
                     source_node_id    AS issue_id,
                     sink_node_id AS latest_version
                   FROM
                     nodeassociation
                   WHERE
                     ASSOCIATION_TYPE = 'IssueFixVersion'
                 ) latest_version ON
                                    story.id = latest_version.issue_id
      left outer JOIN projectversion ON
                                  story.PROJECT = projectversion.PROJECT
                                  AND
                                  latest_version = projectversion.ID
      left outer join
        (
          SELECT issue, NUMBERVALUE t_shirt_size
          FROM
            customfieldvalue
          WHERE
            customfieldvalue.customfield = 14761
          ) t_shirt on story.id = t_shirt.issue
      inner join project on
        story.PROJECT = project.ID
    WHERE
        # exclude epics to prevent double counting
        story.issuetype <> 8
        AND
        project.pkey = 'BSTA'
    group by
      story.id,
      concat(project.pkey, '-', story.issuenum),
      project.pkey,
      story.SUMMARY,
      story.DESCRIPTION,
      latest_version,
      projectversion.vname,
      projectversion.STARTDATE,
      projectversion.RELEASEDATE,
      story.issuestatus
) dependent_issues on DESTINATION = dependent_issues.dependent_issue_id
WHERE
  -- inner join to matrixed values, which restricts the NRE projects
  customfieldvalue.CUSTOMFIELD = 14364
  AND
  jiraissue.issuestatus <> 6
  AND
  -- do not include the NRE ticket if all of its dependent tickets are
  -- closed or resolved
  IfNull(dependent_issue_status, 1) not in (5, 6, 10002)
group by
  concat(project.pkey, '-', jiraissue.issuenum),
  dependent_issues.dependent_issue_num,
  IfNull(dependent_issues.summary, jiraissue.summary),
  IfNull(dependent_issues.DESCRIPTION, jiraissue.DESCRIPTION),
  issuestatus,
  DUEDATE,
  TIMESPENT,
  customer,
  customfieldvalue.NUMBERVALUE,
  version,
  ReleaseDate,
  StartDate,
  PROJECT.pkey;
  
  Select * from BusTime_Sheet2Table;

END
