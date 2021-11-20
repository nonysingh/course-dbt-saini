{{
  config(
    materialized='table'
  )
}}

with orders_source as (
    select * from {{ source('tutorial', 'orders') }}
)

, orders_mod as (
select 
    address_id
    , created_at
    , delivered_at
    , estimated_delivery_at
    , order_cost
    , order_id
    , order_total
    , promo_id
    , shipping_cost
    , shipping_service
    , status
    , tracking_id
    , user_id
from orders_source
)

select * from orders_mod