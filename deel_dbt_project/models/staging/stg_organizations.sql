{{config(
    materialized='table', schema='staging',
)}}

WITH organizations AS (
    SELECT
        ORGANIZATION_ID,
        FIRST_PAYMENT_DATE::DATE AS FIRST_PAYMENT_DATE,
        LAST_PAYMENT_DATE::DATE AS LAST_PAYMENT_DATE,
        LEGAL_ENTITY_COUNTRY_CODE,
        COUNT_TOTAL_CONTRACTS_ACTIVE::INTEGER AS COUNT_TOTAL_CONTRACTS_ACTIVE,
        CREATED_DATE::DATE AS CREATED_DATE
    FROM {{ source('raw', 'raw_organizations') }}
)
SELECT * FROM organizations