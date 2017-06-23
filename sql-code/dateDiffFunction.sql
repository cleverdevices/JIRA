
CREATE PROCEDURE CDdatediff @start_Date date, @end_Date date
AS
BEGIN
	drop table num_days;
	create table num_days(Number_of_Days int)

	insert into num_days 
	Select count(*) from CDDates
	where calendar_date between @start_date and @end_date and trading_day_flag='Y' and holiday_flag='N';
END