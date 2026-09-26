with customers_orders as (

    select
        c.customer_unique_id,
        c.customer_zip_code_prefix,
        c.customer_city,
        c.customer_state,
        o.order_purchase_timestamp,
        row_number() over (
            partition by c.customer_unique_id
            order by o.order_purchase_timestamp desc
        ) as rn
    from {{ ref('stg_customers') }} c
    left join {{ ref('stg_orders') }} o
        on c.customer_id = o.customer_id

),

latest_customer as (

    select
        customer_unique_id,
        customer_zip_code_prefix,
        customer_city,
        customer_state
    from customers_orders
    where rn = 1

)

select
    c.customer_unique_id,
    c.customer_zip_code_prefix,
    c.customer_city,
    c.customer_state,
    g.latitude,
    g.longitude
from latest_customer c
left join {{ ref('int_geolocation_by_zip') }} g
    on c.customer_zip_code_prefix = g.geolocation_zip_code_prefix