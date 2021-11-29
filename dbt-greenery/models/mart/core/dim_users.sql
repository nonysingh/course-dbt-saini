-- User level Info
{{
  config(
    materialized='table',
    unique_key = 'user_id'
  )
}}

SELECT
  u.user_id
  ,u.first_name
  ,u.last_name
  ,u.email
  ,u.phone_number
  ,u.created_at
  ,u.updated_at
  ,u.address_id
  ,b.state
  ,b.country
  ,i.order_recency
  ,i.last_touch_recency
  ,i.user_tenure
  ,i.num_orders
  ,i.customer_type
  ,i.total_order_value
  ,i.avg_order_value

FROM {{ ref('stg_users') }} u
LEFT JOIN {{ ref('stg_addresses') }} b
  on u.address_id = b.address_id
LEFT JOIN {{ ref('int_users') }} i
  on u.user_id = i.user_id  
