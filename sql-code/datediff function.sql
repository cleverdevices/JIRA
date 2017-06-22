
drop procedure CDdatediff;

DELIMITER //
CREATE PROCEDURE CDdatediff
(IN start_date datetime, IN end_date datetime, OUT num_days int)
BEGIN
  Select count(*) into num_days from dates 
	where calendar_date between start_date and end_date and trading_day_flag='Y' and holiday_flag='N';

END //
DELIMITER ;



