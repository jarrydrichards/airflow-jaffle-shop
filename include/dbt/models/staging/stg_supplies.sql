with

source as (
    select * from {{ source('raw', 'raw_supplies') }}
),

renamed as (
    select
        concat(id, '_', sku) as supply_surrogate_id,
        id as supply_id,
        name as supply_name,
        (cost / 100)::decimal(8,2) as cost,
        perishable as is_perishable,
        sku as product_id
    from source
)

select * from renamed