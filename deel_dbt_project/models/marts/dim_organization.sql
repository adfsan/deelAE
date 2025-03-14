{{
    config(
        materialized="table",
        schema="mart",
    )
}}


select
    organization_id,
    created_date,
    first_payment_date,
    last_payment_date,
    legal_entity_country_code,
    count_total_contracts_active
from {{ ref("stg_organizations") }}
