{{
    config(
        materialized = 'table',
        unique_key = 'order_id'
        )
}}

select
    o.order_id
    , o.user_id
    , u.first_name
    , u.last_name
    , u.email
    , u.phone_number
    , oi.product_id
    , oi.quantity
    , o.order_total
    , o.promo_id
    , p.discount as promo_discount
    , p.status as promo_status
    , o.address_id
    , ad.state
    , ad.country
    , o.created_at order_creation_dt
    , o.order_cost
    , o.shipping_cost
    , o.tracking_id
    , o.shipping_service
    , o.estimated_delivery_at est_delivery_dt
    , o.delivered_at 
    , o.status as order_status
from {{ ref('stg_orders') }} as o
left join {{ ref('stg_order_items') }} as oi
    on o.order_id = oi.order_id
left join {{ ref('stg_users') }} as u
    on o.user_id = u.user_id
left join {{ ref('stg_addresses') }} as ad
    on o.address_id = ad.address_id
left join {{ ref('stg_promos') }} as p
    on o.promo_id = p.promo_id