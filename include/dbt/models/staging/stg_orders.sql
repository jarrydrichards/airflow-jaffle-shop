with

source as (
    select * from {{ source('raw', 'raw_orders') }}
),

renamed as (
    select
        id as order_id,
        customer as customer_id,
        ordered_at,
        store_id,
        (subtotal / 100)::decimal(8, 2) as amount_excluding_tax,
        (tax_paid / 100)::decimal(8, 2) as tax_amount,
        (order_total / 100)::decimal(8, 2) as amount_including_tax
    from source
)

select * from renamed