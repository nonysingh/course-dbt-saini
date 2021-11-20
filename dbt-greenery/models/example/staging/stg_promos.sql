{{
  config(
    materialized='table'
  )
}}

with promos_source as (
    select * from {{ source('tutorial', 'promos') }}
)

, promos_mod as (
select 
    promo_id
    , discout as discount
    , status
from promos_source
)

select * from promos_mod