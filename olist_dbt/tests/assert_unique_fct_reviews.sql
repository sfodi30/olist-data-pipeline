select
    review_id,
    order_id,
    count(*) as nb
from {{ ref('fct_reviews') }}
group by
    review_id,
    order_id
having count(*) > 1