with

source as (
    select * from {{ source('raw', 'raw_products') }}
),

renamed as (
    select
        sku as product_id,
        name as product_name,
        type as product_type,
        description as product_description,
        (price / 100)::decimal(8,2) as price,
    from source
)

select * from renamed