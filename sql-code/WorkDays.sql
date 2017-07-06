CREATE DEFINER=`readonly`@`%` PROCEDURE `WorkDays`()
BEGIN

Drop table if exists workdays;
Create table workdays

Select @i:=@i+1 AS rowNum ,calendar_date 
from cddates, (SELECT @i:=0) foo where trading_day_flag = 'Y' and holiday_flag = 'N';

Drop Table if exists workMatch;
Create Table workMatch
select rowNum, calendar_date, (select calendar_date from workdays b where b.rowNum = a.rowNum + 5 ) as releaseRow from workdays a;

END
