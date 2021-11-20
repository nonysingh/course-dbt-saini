{% snapshot snapshot_users %}

{{
    config(
      target_database='dbt',
      target_schema='snapshots',
      unique_key='user_id',
      strategy='timestamp',
      updated_at='updated_at'
    )
}}

select * from {{ref('stg_users')}}

{% endsnapshot %}