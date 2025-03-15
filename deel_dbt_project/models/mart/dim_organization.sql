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
    coalesce(count_total_contracts_active, 0) as count_total_contracts_active,
    case when last_payment_date >= (select max(created_at) - interval '1 month' from {{ ref("stg_invoices") }}) then true else false end as is_active_last_30_days --arbitraty date to consider an organization active
from {{ ref("stg_organizations") }}
