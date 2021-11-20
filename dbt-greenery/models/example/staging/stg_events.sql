{{
  config(
    materialized='table'
  )
}}

with events_source as (
    select * from {{ source('tutorial', 'events') }}
)

, events_mod as (
select 
    created_at
    , event_id
    , event_type
    , page_url
    , session_id
    , user_id
from events_source
)

select * from events_mod