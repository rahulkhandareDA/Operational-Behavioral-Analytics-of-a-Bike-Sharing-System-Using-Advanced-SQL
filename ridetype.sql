select count(ride_id) as total_rides, 
  case when 
  timestampdiff(minute, start_time, 
   case when end_time_dt < start_time 
            then end_time_dt + interval 1 day
            else end_time_dt
        end
    ) < 10 then "short_ride" 
    
    when
    timestampdiff(minute, start_time, 
   case when end_time_dt < start_time 
            then end_time_dt + interval 1 day
            else end_time_dt
        end
    ) <= 50 then "medium_ride" else "Long_ride"
  end as ride_type 
  from rides
  group by 2
  order by 1 desc;
  