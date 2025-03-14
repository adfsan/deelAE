{{config(
    materialized='table', schema='staging',
)}}


WITH invoices AS (
    SELECT
        INVOICE_ID,
        PARENT_INVOICE_ID,
        TRANSACTION_ID,
        ORGANIZATION_ID,
        TYPE,
        STATUS,
        CURRENCY,
        PAYMENT_CURRENCY,
        PAYMENT_METHOD,
        AMOUNT::NUMERIC AS AMOUNT,
        PAYMENT_AMOUNT::NUMERIC AS PAYMENT_AMOUNT,
        FX_RATE::NUMERIC AS FX_RATE,
        FX_RATE_PAYMENT::NUMERIC AS FX_RATE_PAYMENT,
        CREATED_AT::DATE AS CREATED_AT
    FROM {{ source('raw', 'raw_invoices') }}
)
SELECT * FROM invoices
