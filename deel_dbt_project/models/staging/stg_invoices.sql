{{
    config(
        materialized="table",
        schema="staging",
    )
}}


with
    invoices as (
        select
            invoice_id,
            parent_invoice_id,
            transaction_id,
            organization_id,
            type,
            status,
            currency,
            payment_currency,
            payment_method,
            amount::numeric as amount,
            payment_amount::numeric as payment_amount,
            fx_rate::numeric as fx_rate,
            fx_rate_payment::numeric as fx_rate_payment,
            created_at::date as created_at
        from {{ source("raw", "raw_invoices") }}
    )

select *
from invoices
