{{
    config(
        materialized="view",
        schema="qa",
    )
}}

with base_cte as (
select
    organization_id,
    date,
    total_amount_net_usd_cumulative,
    lag(total_amount_net_usd_cumulative, 1, 0) over (
        partition by organization_id order by date
    ) as previous_total_amount_net_usd_cumulative
from {{ ref("fact_finance") }}
)

select
    organization_id,
    date,
    abs(
        (total_amount_net_usd_cumulative - previous_total_amount_net_usd_cumulative)*1.0
        / nullif(previous_total_amount_net_usd_cumulative, 0)
    ) as dod_balance_change_usd_pct
from base_cte
where date >= (select max(date) - interval '6 month' from {{ ref("fact_finance") }}) -- arbitrary date to start calculating DoD balance change
