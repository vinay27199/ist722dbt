with customer_ratings as (
    select * from {{ ref('fact_customer_ratings') }}
),

customers as (
    select * from {{ ref('dim_customer') }}
),

items as (
    select * from {{ ref('dim_item') }}
)

select 
    cr.customer_id,
    dc.full_name as customer_name,
    dc.email as customer_email,
    dc.location as customer_location,
    
    cr.item_id,
    di.item_name,
    di.item_type,
    di.item_source,

    cr.rating
from customer_ratings cr
left join customers dc 
    on cr.customer_id = dc.customer_id
left join items di 
    on cr.item_id = di.item_id