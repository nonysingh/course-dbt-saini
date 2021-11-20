{% snapshot snapshot_products %}

{{
    config(
      target_database='dbt',
      target_schema='snapshots',
      unique_key='product_id',
      strategy='check',
      check_cols=['name','price','quantity']
    )
 }}

select * from {{ref('stg_products')}}

{% endsnapshot %}