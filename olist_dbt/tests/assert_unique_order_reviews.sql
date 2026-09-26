select
    review_id,
    order_id,
    count(*) as nb

from {{ ref('stg_order_reviews') }}

group by
    review_id,
    order_id

having count(*) > 1