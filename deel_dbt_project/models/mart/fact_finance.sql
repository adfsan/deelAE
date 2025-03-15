{{
    config(
        materialized="table",
        schema="mart",
    )
}}

with
    invoice_cte as (
        select
            invoices.created_at::text
            || '-'
            || organization_id as invoice_date_organization_id,
            invoices.created_at as date,
            organization_id,
            sum(
                case
                    when status = 'paid'
                    then coalesce(payment_amount, amount) / fx_rate
                    else 0
                end
            ) as total_amount_paid_usd,
            sum(
                case
                    when status = 'refunded'
                    then coalesce(payment_amount, amount) / fx_rate
                    else 0
                end
            ) as total_amount_refunded_usd,
            count(distinct transaction_id) as count_total_transactions
        from {{ ref("stg_invoices") }} as invoices
        inner join
            {{ ref("stg_organizations") }} as organizations using (organization_id)
        group by 1, 2, 3
    )

select
    *,
    total_amount_paid_usd - total_amount_refunded_usd as total_amount_net_usd,
    sum(total_amount_paid_usd - total_amount_refunded_usd) over (
        partition by organization_id order by date
    ) as total_amount_net_usd_cumulative
from invoice_cte
