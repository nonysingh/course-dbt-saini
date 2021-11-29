{{
    config(
        materialized = 'table',
        unique_key = 'user_id'
        )
}}

with user_purchase_recency as (
    select distinct 
        user_id
        ,date_part('day', current_date::timestamp - first_value(created_at) over (partition by user_id order by created_at DESC))::numeric as days_past_last_purchase
    from {{ ref('stg_orders') }}
    where status = 'delivered'
),

user_tenure as (
    select 
        user_id
        ,date_part('day', current_date::timestamp - first_value(created_at) over (partition by user_id order by created_at ASC))::numeric as user_tenure
    from {{ ref('stg_users') }}
),

user_event_recency as (
    select distinct
        user_id
        ,date_part('day', current_date::timestamp - first_value(created_at) over (partition by user_id order by created_at DESC))::numeric as last_touch_recency          
    from {{ ref('stg_events') }}
),

user_orders as (
    select
        user_id
        , count(order_id) as num_orders
        , sum(order_total) as total_order_value
        , sum(order_total)/count(order_id) avg_order_value
    from {{ ref('stg_orders') }}
    where status = 'delivered'
    group by user_id
),

user_info as (
    select
        u.user_id
        ,case 
             when upr.days_past_last_purchase < 31 then 'R_30'
             when upr.days_past_last_purchase between 31 and 60 then 'R_31_60'
             when upr.days_past_last_purchase between 61 and 90 then 'R_61_90'
             when upr.days_past_last_purchase between 91 and 120 then 'R_91_120'
             when upr.days_past_last_purchase between 121 and 180 then 'R_121_180'
             when upr.days_past_last_purchase between 181 and 360 then 'R_181_360'
             when upr.days_past_last_purchase > 360 then 'R_361+'   
             end as order_recency
        ,case 
             when e.last_touch_recency < 31 then 'R_30'
             when e.last_touch_recency between 31 and 60 then 'R_31_60'
             when e.last_touch_recency between 61 and 90 then 'R_61_90'
             when e.last_touch_recency between 91 and 120 then 'R_91_120'
             when e.last_touch_recency between 121 and 180 then 'R_121_180'
             when e.last_touch_recency between 181 and 360 then 'R_181_360'
             when e.last_touch_recency > 360 then 'R_361+'   
             end as last_touch_recency
        ,t.user_tenure
        ,o.num_orders
        ,case when COALESCE(o.num_orders,0) < 2 then 'New' else 'Existing' end as customer_type
        ,o.total_order_value
        ,o.avg_order_value
        ,ad.state
        ,ad.country
    from {{ ref('stg_users') }} u
    left join user_purchase_recency upr
        on u.user_id = upr.user_id    
    left join user_tenure t
        on u.user_id = t.user_id
    left join user_event_recency e
        on u.user_id = e.user_id
    left join user_orders o
        on u.user_id = o.user_id
    left join {{ ref('stg_addresses') }} ad
        on u.address_id = ad.address_id
)

select
distinct user_id
,order_recency
,last_touch_recency
,user_tenure
,num_orders
,customer_type
,total_order_value
,avg_order_value
,state
,country
from user_info