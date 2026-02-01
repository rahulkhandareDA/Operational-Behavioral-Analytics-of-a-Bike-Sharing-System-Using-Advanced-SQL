

/*                     ANSWERING KEY BUSINESS QUESTIONS         */


--   Q1.    MEMBERSHIP-WISE USER DISTRIBUTION   -- 


select 
a.membership_level as membership, 
count(b.ride_id) as total_rides, 
avg(b.distance_km) as avg_dist,
avg(timestampdiff(
        minute,
        b.start_time,
        case when b.end_time_dt < b.start_time 
            then b.end_time_dt + interval 1 day
            else b.end_time_dt
        end
    )) as duration_mins
    from users as a join rides as b on a.user_id = b.user_id
    group by 1
    order by 2;


--   Q2.       PEAK HOURS        -- 


select hour(r.start_time) as ride_hour , count(r.ride_id) as total_rides
from rides as r
group by 1
order by count(r.ride_id) desc;


--  Q3.     MOST POPULAR STATIONS   -- 


select 
s.station_id, s.station_name, count(r.ride_id) as total_rides 
  from stations as s join rides as r 
  on s.station_id = r.start_station_id
  group by 1
  order by count(r.ride_id) desc
  limit 10;
  
  
  --  Q4.     DIFFERENTIATING RIDES ON THE BASIS OF TOTAL RIDE TIME   --
  
  
  
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
  
  
  --   Q5.         NET RIDE FLOW STATION-WISE   --
  
  
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
  
  
  --   Q6.              MoM USER GROWTH            --       
  
  
  with signups as (
Select 
date_format(created_at, '%Y-%m') as signup_month,
count(user_id) as users_signed_up
from users
group by signup_month
order by signup_month)


select *, lag (users_signed_up) over () as prev_users,
concat(round((users_signed_up - lag (users_signed_up) over ())/100*100,2),'%') as MoM_user_growth
from signups 
order by signup_month;
