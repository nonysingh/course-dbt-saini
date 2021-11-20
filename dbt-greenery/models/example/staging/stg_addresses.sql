{{
  config(
    materialized='table'
  )
}}

with addresses_source as (
    select * from {{ source('tutorial', 'addresses') }}
)

, addresses_mod as (
select 
    address
    , address_id
    , country
    , state
    , zipcode
from addresses_source
)

select * from addresses_mod