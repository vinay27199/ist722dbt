with fudgeflix_ratings as (
    select 
        {{ dbt_utils.generate_surrogate_key(['at_account_id', "'FudgeFlix'"]) }} as customer_id,
        {{ dbt_utils.generate_surrogate_key(['at_title_id', "'FudgeFlix'"]) }} as item_id,
        at_rating as rating
    from {{ source('fudgeflix_v3', 'ff_account_titles') }}
),

fudgemart_ratings as (
    select 
        {{ dbt_utils.generate_surrogate_key(['customer_id', "'FudgeMart'"]) }} as customer_id,
        {{ dbt_utils.generate_surrogate_key(['product_id', "'FudgeMart'"]) }} as item_id,
        review_stars as rating
    from {{ source('fudgemart_v3', 'fm_customer_product_reviews') }}
),

all_ratings as (
    select * from fudgeflix_ratings
    union all
    select * from fudgemart_ratings
)

select 
    customer_id,
    item_id,
    cast(rating as int) as rating
from all_ratings