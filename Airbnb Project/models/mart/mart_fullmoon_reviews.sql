{{
    config(
        materialized = 'table'
    )
}}

WITH fct_reviews AS (

    SELECT * FROM {{ref ('fct_reviews')}}

),
full_moon_dates AS (

    SELECT * FROM {{ref ('seed_full_moon_dates')}}
)

SELECT
    reviews.*,
    CASE
        WHEN fullmoon.full_moon_date IS NULL THEN 'not full moon'
        ELSE 'full moon' END AS is_full_moon
FROM fct_reviews AS reviews
LEFT JOIN full_moon_dates AS fullmoon
    ON (TO_DATE(reviews.review_date) = DATEADD(DAY, 1, fullmoon.full_moon_date))
