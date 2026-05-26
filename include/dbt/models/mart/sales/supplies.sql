with

supplies as (
    select * from {{ ref('stg_supplies') }}
),

products as (
    select * from {{ ref('stg_products') }}
),

joined as (
    select
        s.supply_id,
        s.supply_name,
        s.product_id,
        p.product_name,
        s.cost,
        s.is_perishable
    from supplies s
    left join products p on s.product_id = p.product_id
)

select * from joined