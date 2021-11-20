#! /usr/bin/bash

set -x
echo "Hi Harminder"
dbt run
export PGPASSWORD=corise PGUSER=corise PGDATABASE=dbt psql
dbt run -m stg_users
dbt run -m stg_products
dbt run -m stg_orders
dbt run -m stg_order_items
dbt run -m stg_events
dbt run -m stg_addresses
dbt run -m stg_promos

exit