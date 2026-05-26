with

source as (
    select * from {{ source('raw', 'raw_stores') }}
),

renamed as (
    select
        id as store_id,
        name as store_name,
        opened_at::date as opened_date,
        tax_rate
    from source
)

select * from renamed