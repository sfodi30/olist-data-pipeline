select
    o.order_id,
    c.customer_unique_id,
    o.order_status,
    o.order_purchase_timestamp,
    o.order_approved_at,
    o.order_delivered_carrier_date,
    o.order_delivered_customer_date,
    o.order_estimated_delivery_date,
    o.order_purchase_timestamp::date as date_day,

    datediff(
        day,
        o.order_purchase_timestamp,
        o.order_delivered_customer_date
    ) as delivery_duration_days,

    datediff(
        day,
        o.order_estimated_delivery_date,
        o.order_delivered_customer_date
    ) as delivery_vs_estimate_days,

    case
        when o.order_delivered_customer_date is null then null
        when o.order_delivered_customer_date > o.order_estimated_delivery_date then 1
        else 0
    end as is_late_delivery

from {{ ref('stg_orders') }} o

inner join {{ ref('stg_customers') }} c
    on o.customer_id = c.customer_id