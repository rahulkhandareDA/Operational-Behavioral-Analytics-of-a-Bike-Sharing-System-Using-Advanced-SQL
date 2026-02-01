select 
s.station_id, s.station_name, count(r.ride_id) as total_rides 
  from stations as s join rides as r 
  on s.station_id = r.start_station_id
  group by 1
  order by count(r.ride_id) desc
  limit 10;