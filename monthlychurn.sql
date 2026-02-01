with last_activity as (
    select 	user_id,
max(start_time) as last_ride_date
from rides
group by user_id),

reference_date as (
select max(start_time) as max_date
from rides),

churned_users as (select 
user_id,
date_format(last_ride_date, '%Y-%m') as churn_month
from last_activity
cross join reference_date    
where datediff(max_date, last_ride_date) > 30 )


select churn_month, count(user_id) as churned_users
from churned_users
group by churn_month
order by churn_month;