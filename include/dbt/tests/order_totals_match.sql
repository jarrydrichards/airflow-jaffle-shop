{{ config(tag='mart') }}

with 

staging_orders as (
    select 
        order_id,
        amount_excluding_tax
    from {{ ref('stg_orders') }}
),

mart_orders as (
    select
        order_id,
        sum(order_amount) as order_amount
    from {{ ref('orders') }}
    group by order_id
),

comparison as (
    select
        s.order_id,
        s.amount_excluding_tax as staging_amount,
        m.order_amount as mart_amount,
        (s.amount_excluding_tax - m.order_amount) as difference
    from staging_orders s
    left join mart_orders m on s.order_id = m.order_id
)

select *
from comparison
where
    order_id is null
    or abs(difference) > 0.01 -- catches floating point rounding