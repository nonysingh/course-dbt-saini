{{
  config(
    materialized='table'
  )
}}

with orders_source as (
    select * from {{ source('tutorial', 'order_items') }}
)

, orderitems_mod as (
select 
    order_id
    , product_id
    , quantity
from orders_source
)

select * from orderitems_mod