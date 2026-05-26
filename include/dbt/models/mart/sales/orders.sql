with

orders as (
    select * from {{ ref('stg_orders') }}
),

order_items as (
    select * from {{ ref('stg_order_items') }}
),

products as (
    select * from {{ ref('stg_products') }}
),

costs_per_product as (
    select * from {{ ref('int_cost_per_product') }}
),

customers as (
    select * from {{ ref('stg_customers') }}
),

stores as (
    select * from {{ ref('stg_stores') }}
),

product_details_joined_to_order_items as (
    select
        oi.order_id,
        p.product_id,
        p.product_name,
        COUNT(*) as quantity,
        p.price as unit_price,
        cpp.cost as unit_cost,
        sum(p.price) as order_amount,
        sum(cpp.cost) as order_cost
    from order_items oi
    left join products p on oi.product_id = p.product_id
    left join costs_per_product cpp on oi.product_id = cpp.product_id
    group by oi.order_id, p.product_id, p.product_name, p.price, cpp.cost
),
    
joined_to_orders as (
    select
        o.order_id,
        o.customer_id,
        c.customer_name,
        o.store_id,
        s.store_name,
        o.ordered_at,
        i.product_id,
        i.product_name,
        i.quantity,
        i.unit_price,
        i.unit_cost,
        i.order_amount,
        i.order_cost,
        (i.order_amount - i.order_cost) as order_profit
    from orders o
    inner join product_details_joined_to_order_items i on o.order_id = i.order_id
    left join customers c on o.customer_id = c.customer_id
    left join stores s on o.store_id = s.store_id
)

select * from joined_to_orders