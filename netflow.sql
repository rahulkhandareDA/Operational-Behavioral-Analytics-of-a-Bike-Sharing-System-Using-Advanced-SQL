 with d as (
  select 
  r.start_station_id,
  count(r.ride_id) as total_starts
  from rides r
  group by 1), 
  
  a as ( 
  select r.end_station_id,
  count(r.ride_id) as total_arrivals
  from rides r
  group by 1)
  
  select s.station_id, s.station_name, d.total_starts, a.total_arrivals, 
  (a.total_arrivals - d.total_starts) as net_ride_flow
  from stations as s
  join d on s.station_id = d.start_station_id 
  join a on s.station_id = a.end_station_id
  group by 1
  order by (a.total_arrivals - d.total_starts);