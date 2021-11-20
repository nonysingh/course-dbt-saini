{{
  config(
    materialized='table'
  )
}}

with products_source as (
    select * from {{ source('tutorial', 'products') }}
)

, products_mod as (
select 
    product_id
    , name
    , price
    , quantity
from products_source
)

select * from products_mod