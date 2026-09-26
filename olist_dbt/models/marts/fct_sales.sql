select
    i.order_id,
    i.order_item_id,

    c.customer_unique_id,
    i.product_id,
    i.seller_id,

    o.order_purchase_timestamp::date as date_day,
    o.order_status,

    i.price,
    i.freight_value

from {{ ref('stg_order_items') }} i

inner join {{ ref('stg_orders') }} o
    on i.order_id = o.order_id

inner join {{ ref('stg_customers') }} c
    on o.customer_id = c.customer_id