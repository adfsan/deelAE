{{config(
    materialized='table', schema='mart',
)}}


select  "raw_invoices"."CREATED_DATE"::DATE as "CREATED_DATE",
        "ORGANIZATION_ID",
        COALESCE(SUM("PAYMENT_AMOUNT"/"FX_RATE"), 0) as "TOTAL_PAYMENT_AMOUNT_USD",
        COUNT("TRANSACTION_ID") as "COUNT_TOTAL_TRANSACTIONS"
from {{ source('raw', 'raw_invoices') }} as "raw_invoices"
inner join {{ ref('dim_organization')}} as "dim_organization"
using("ORGANIZATION_ID")
WHERE lower("STATUS") = 'paid' or lower("STATUS") = 'refunded'
group by 1, 2