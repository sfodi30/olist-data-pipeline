select
    p.order_id,
    p.payment_sequential,
    p.payment_type,
    p.payment_installments,
    p.payment_value,
    o.order_purchase_timestamp::date as date_day,
    c.customer_unique_id

from {{ ref('stg_order_payments') }} p

inner join {{ ref('stg_orders') }} o
    on p.order_id = o.order_id

inner join {{ ref('stg_customers') }} c
    on o.customer_id = c.customer_id