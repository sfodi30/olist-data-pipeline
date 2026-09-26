select
    order_id,
    payment_sequential,
    count(*) as nb

from {{ ref('stg_order_payments') }}

group by
    order_id,
    payment_sequential

having count(*) > 1