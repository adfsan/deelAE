{{config(
    materialized='table', schema='mart',
)}}


select  organization_id,
        created_date::DATE as "ORGANIZATION_CREATED_DATE",
        "FIRST_PAYMENT_DATE"::DATE as "FIRST_PAYMENT_DATE",
        "LAST_PAYMENT_DATE"::DATE as "LAST_PAYMENT_DATE",
        "LEGAL_ENTITY_COUNTRY_CODE",
        "COUNT_TOTAL_CONTRACTS_ACTIVE"
from {{ source('raw', 'raw_organizations') }}
left join {{ source('raw', 'raw_invoices') }}
using("ORGANIZATION_ID")
group by 1, 2, 3, 4, 5, 6