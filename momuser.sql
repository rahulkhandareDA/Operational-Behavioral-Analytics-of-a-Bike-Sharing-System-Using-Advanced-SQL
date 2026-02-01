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