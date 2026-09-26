with date_bounds as (

    select
        min(order_purchase_timestamp)::date as min_date,
        max(order_purchase_timestamp)::date as max_date
    from {{ ref('stg_orders') }}

),

numbers as (

    select
        row_number() over (order by seq4()) - 1 as n
    from table(generator(rowcount => 5000))

),

dates as (

    select
        dateadd(day, n, min_date) as date_day
    from date_bounds
    cross join numbers
    where dateadd(day, n, min_date) <= max_date

)

select
    date_day,
    year(date_day) as year,
    quarter(date_day) as quarter,
    month(date_day) as month,
    monthname(date_day) as month_name,
    day(date_day) as day_of_month,
    dayofweekiso(date_day) as day_of_week,
    dayname(date_day) as day_name
from dates