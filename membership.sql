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