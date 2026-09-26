select
    c.customer_unique_id,
    r.review_id,
    r.order_id,
    r.review_score,
    r.review_comment_title,
    r.review_comment_message,
    r.review_creation_date::date as date_day,
    r.review_answer_timestamp

from {{ ref('stg_order_reviews') }} r

inner join {{ ref('stg_orders') }} o
    on r.order_id = o.order_id

inner join {{ ref('stg_customers') }} c
    on o.customer_id = c.customer_id