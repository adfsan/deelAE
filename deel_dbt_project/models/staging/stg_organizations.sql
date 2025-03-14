{{
    config(
        materialized="table",
        schema="staging",
    )
}}

with
    organizations as (
        select
            organization_id,
            first_payment_date::date as first_payment_date,
            last_payment_date::date as last_payment_date,
            legal_entity_country_code,
            count_total_contracts_active::integer as count_total_contracts_active,
            created_date::date as created_date
        from {{ source("raw", "raw_organizations") }}
    )

select *
from organizations
