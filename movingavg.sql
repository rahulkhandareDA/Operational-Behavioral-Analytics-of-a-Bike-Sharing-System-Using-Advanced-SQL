with daily_rides as (
select date(start_time) as ride_date,
count(ride_id) as total_rides
from rides
group by ride_date )

select 
ride_date,
total_rides,
round(avg(total_rides) over (order by ride_date
rows between 6 preceding and current row), 2) as seven_day_moving_avg
from daily_rides
order by ride_date; 