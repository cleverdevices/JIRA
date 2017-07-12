drop table if exists CDRollUp_Projects;
create table CDRollUp_Projects (Project varchar(25),	Start_date date,	End_date date);

insert into CDRollUp_Projects values ('Disney', '2017-10-01', '2018-12-01') ;
insert into CDRollUp_Projects values ('SEPTA', '1900-10-01', '2100-12-01') ;
insert into CDRollUp_Projects values ('TTC - Toronto', '2016-07-01', '2017-02-01') ;
insert into CDRollUp_Projects values ('VTA - Santa Clara', '2017-03-01', '2017-06-01') ;
insert into CDRollUp_Projects values ('CCB - Culver City', '2017-10-01', '2018-06-01') ;
insert into CDRollUp_Projects values ('PTD - Phoenix', '2017-09-01', '2018-01-01') ;
insert into CDRollUp_Projects values ('DDOT - Detroit', '2017-10-01', '2017-12-01') ;
insert into CDRollUp_Projects values ('SRTA - New Bedford', '2017-03-01', '2017-11-17') ;
insert into CDRollUp_Projects values ('NYCT', '2017-02-01', '2017-07-01') ;
insert into CDRollUp_Projects values ('SMTD - Springfield', '2017-04-01', '2017-09-01') ;
insert into CDRollUp_Projects values ('NORTA', '2017-05-02', '2017-06-01') ;
insert into CDRollUp_Projects values ('Red Deer', '2017-05-01', '2017-10-01') ;
insert into CDRollUp_Projects values ('Greenlink', '2017-03-01', '2017-04-01') ;
insert into CDRollUp_Projects values ('MBTA', '2017-12-01', '2017-12-01') ;
insert into CDRollUp_Projects values ('City of Lubbock', '2017-08-01', '2017-11-01') ;
insert into CDRollUp_Projects values ('City of Tallahasse', '2017-09-01', '2018-10-01') ;
insert into CDRollUp_Projects values ('COTA', '2017-07-01', '2100-12-01') ;