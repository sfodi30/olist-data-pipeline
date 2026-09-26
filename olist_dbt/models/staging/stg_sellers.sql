select
    "seller_id" as seller_id,
    lpad("seller_zip_code_prefix"::varchar, 5, '0') as seller_zip_code_prefix,
    "seller_city" as seller_city,
    "seller_state" as seller_state

from {{ source('raw', 'sellers') }}