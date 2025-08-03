with fudgeflix_items as (
    select 
        t.title_id as source_item_id,
        'FudgeFlix' as item_source,
        t.title_name as item_name,
        t.title_type as item_type
    from {{ source('fudgeflix_v3', 'ff_titles') }} t
),
fudgemart_items as (
    select 
        cast(p.product_id as varchar) as source_item_id,
        'FudgeMart' as item_source,
        p.product_name as item_name,
        d.department_id as item_type
    from {{ source('fudgemart_v3', 'fm_products') }} p
    left join {{ source('fudgemart_v3', 'fm_departments_lookup') }} d 
        on p.product_department = d.department_id
),
all_items as (
    select * from fudgeflix_items
    union all
    select * from fudgemart_items
)

select
    {{ dbt_utils.generate_surrogate_key(['source_item_id', 'item_source']) }} as item_id,
    source_item_id,
    item_name,
    item_source,
    item_type
from all_items
