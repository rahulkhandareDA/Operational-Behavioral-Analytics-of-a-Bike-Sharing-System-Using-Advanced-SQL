select hour(r.start_time) as ride_hour , count(r.ride_id) as total_rides
from rides as r
group by 1
order by count(r.ride_id) desc;