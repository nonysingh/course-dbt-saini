{{
    config(
        materialized = 'table'
        )
}}

select 
 d.user_id
,d.email
,d.created_at
,d.state
,d.country
,d.user_tenure
,d.order_recency
,d.last_touch_recency
,d.num_orders
,d.customer_type
,d.total_order_value
,d.avg_order_value
from {{ ref('dim_users') }} d
left join  {{ ref('fact_orders') }} f
on d.user_id = f.user_id