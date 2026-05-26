with

products as (
    select * from {{ ref('stg_products') }}
),

supplies as (
    select * from {{ ref('stg_supplies') }}
),

-- Aggregate the total supply cost per product.
agg_supplies as (
    select
        product_id,
        sum(cost) as total_cost
    from supplies
    group by product_id
),

-- Cost and price of each product.
joined_to_products as (
    select
        p.product_id,
        p.price,
        s.total_cost as cost
    from products p
    left join agg_supplies s on p.product_id = s.product_id
)

select * from joined_to_products