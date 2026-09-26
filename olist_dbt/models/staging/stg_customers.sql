select
    "customer_id" as customer_id,
    "customer_unique_id" as customer_unique_id,
    lpad("customer_zip_code_prefix"::varchar, 5, '0') as customer_zip_code_prefix,
    "customer_city" as customer_city,
    "customer_state" as customer_state

from {{ source('raw', 'customers') }}