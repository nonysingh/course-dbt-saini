{{
    config(
        materialized = 'table'
        )
}}

select 
 user_id
,session_id
,page_url
,event_type
,created_at
,case when lower(page_url) like '%product%' then 'product'
when lower(page_url) like '%signup%' then 'signup'
when lower(page_url) like '%checkout%' then 'checkout'
when lower(page_url) like '%browse%' then 'generic'
when lower(page_url) like '%help%' then 'help'
else 'Unknown' end as event_page_type
from {{ ref('stg_events') }} 