Q1: How many users do we have?
```sql
select count(distinct user_id) count_distinct_users from dbt_harminder_s.stg_users;
```
```130```

Q2: On average, how many orders do we receive per hour?
```sql
with order_info as
(
select count(order_id) total_orders, date_trunc('hour', created_at) hr from orders group by 2
)
select round(avg(total_orders),2) avg_orders from order_info;
```
```8.16 orders per hour```

Q3: On average, how long does an order take from being placed to being delivered?
```sql
with delivery_time as 
(
select delivered_at, created_at,  (EXTRACT(EPOCH FROM delivered_at - created_at)/3600)::Integer as hrs from orders where delivered_at is not null and created_at is not null
)
select round(avg(hrs),2) average_hours, round(avg(hrs/24),2)  average_days from delivery_time;
```
```
average_hours | average_days
--------------+--------------
        94.22 |         3.93 
```

Q4: How many users have only made one purchase? Two purchases? Three+ purchases? 
```sql
with num_orders as
(select user_id
    ,count(distinct order_id) num_of_orders 
    from orders 
    group by 1
)
select SUM(case when num_of_orders = 1 then 1 else 0 end) users_having_1_purchase
    ,SUM(case when num_of_orders = 2 then 1 else 0 end) users_having_2_purchases
    ,SUM(case when num_of_orders >= 3 then 1 else 0 end) users_having_3plus_purchases
from num_orders;
```
```
 users_having_1_purchase | users_having_2_purchases | users_having_3plus_purchases 
-------------------------+--------------------------+------------------------------
                      25 |                       22 |                           81
```

Q5: On average, how many unique sessions do we have per hour?
```sql
with sessions_info as 
(
select count(distinct session_id) distinct_session_id
 ,date_trunc('hour', created_at) session_hr 
 from events 
 where created_at is not null
 group by date_trunc('hour', created_at) 
)
select round(avg(distinct_session_id),2) uniq_session_per_hr from sessions_info;
```
```
 uniq_session_per_hr 
---------------------
                7.27
```                
