with fudgeflix_customers as (
    select 
        account_id as source_customer_id,
        'FudgeFlix' as source_system,
        account_firstname || ' ' || account_lastname as full_name,
        account_email as email,
        account_zipcode as location
    from {{ source('fudgeflix_v3', 'ff_accounts') }}
),
fudgemart_customers as (
    select 
        customer_id as source_customer_id,
        'FudgeMart' as source_system,
        customer_firstname || ' ' || customer_lastname as full_name,
        customer_email as email,
        customer_zip as location
    from {{ source('fudgemart_v3', 'fm_customers') }}
),
all_customers as (
    select * from fudgeflix_customers
    union all
    select * from fudgemart_customers
)
select
    {{ dbt_utils.generate_surrogate_key(['source_customer_id', 'source_system']) }} as customer_id,
    source_customer_id,
    source_system,
    full_name,
    email,
    cast(location as int) as location
from all_customers