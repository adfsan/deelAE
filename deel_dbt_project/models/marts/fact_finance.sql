{{
    config(
        materialized="table",
        schema="mart",
    )
}}

with
    invoice_cte as (
        select
            created_date as date,
            organization_id,
            sum(
                case when status = 'paid' then payment_amount / fx_rate else 0 end
            ) as total_amount_paid_usd,
            sum(
                case when status = 'refund' then payment_amount / fx_rate else 0 end
            ) as total_amount_refunded_usd
            count(distinct transaction_id) as count_total_transactions
        from {{ ref("stg_invoices") }}
        inner join {{ ref("stg_organizations") }} using (organization_id)
        group by 1, 2
    )

select *, total_amount_paid_usd - total_amount_refunded_usd as total_amount_net_usd
from invoice_cte
