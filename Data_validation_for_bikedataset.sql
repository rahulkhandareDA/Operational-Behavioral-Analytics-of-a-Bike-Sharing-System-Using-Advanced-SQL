

/*                       DATA VALIDATION AND CLEANING                  */

-- COUNT OF ROWS OF EACH TABLE  -- 

select count(*) as total_users from users;

select count(*) as rides_rows from rides;

select count(*) as total_stations from stations;


--              COUNT OF NULL VALUES            -- 

-- FROM USERS TABLE 

select sum(user_id is null) as missing_user_id,
sum(username is null) as missing_username,
sum(membership_level is null) as missing_membership_level,
sum(created_at is null) as missing_created_at
from users;

-- FROM RIDES TABLE

select sum(user_id is null) as missing_user_id,
sum(start_station_id is null) as missing_start_station,
sum(end_station_id is null) as missing_end_station,
sum(start_time is null) as missing_start_time,
sum(end_time is null) as missing_end_time,
sum(distance_km is null) as missing_distance
from rides;


--  Updating the column datatype into Datetime for easier calculations --


alter table rides
add column end_time_dt datetime;

update rides
set end_time_dt = cast(concat(date(start_time), ' ', end_time) as datetime);



--          SUMMARY STATISTICS FROM RIDES TABLE  --


Select 
min(distance_km) as min_dist,
max(distance_km) as max_dist,
round(avg(distance_km),2) as avg_dist,

min(timestampdiff( minute, start_time,
    case when end_time_dt < start_time 
	then end_time_dt + interval 1 day
	else end_time_dt
    end
)) as min_duration_mins,

max(timestampdiff(minute, start_time,
    case when end_time_dt < start_time 
	then end_time_dt + interval 1 day
	else end_time_dt
    end
)) as max_duration_mins,

round(avg(timestampdiff(minute, start_time,
    case when end_time_dt < start_time then end_time_dt + interval 1 day
	else end_time_dt
    end )),2) as average_duration_mins
 from rides;
 

-- COMMENT : BECAUSE SOME RIDES MIGHT CROSS MIDNIGHT AND THAT MIGHT AFFECT THE CALCULATION LOGIC, I HAVE ADDED INTERVAL 1 DAY
-- TO ENSURE THE DATE STAYS THE SAME DURING CALCULATION



--   The query to calculate the ride time duration correctly --



select user_id,
    (timestampdiff( minute, start_time,
	case when end_time_dt < start_time 
	then end_time_dt + interval 1 day
	else end_time_dt
	end )) as duration_mins
from rides
order by 2 desc;  


 --     checking false starts  -- 
 
 
select 
    count(*) as rides_under_2_mins
from rides
where timestampdiff(minute, start_time, 
Case when 
end_time_dt < start_time 
then end_time_dt + interval 1 day 
else end_time_dt
end  ) < 2 ;
