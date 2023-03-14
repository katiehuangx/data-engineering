-- Doc | Config : https://docs.getdbt.com/reference/dbt-jinja-functions/config

{{
    config(
        materialized = 'incremental', 
        on_schema_change = 'fail'
    )
}}
-- dbt materializes the model as an incremental table. 
-- Read for difference btw table vs. incremental: https://docs.getdbt.com/docs/build/materializations

WITH src_reviews AS (
    SELECT * FROM {{ref ('src_reviews')}}
)

SELECT 
    -- Create a unique review_id based on the following columns
    {{ dbt_utils.generate_surrogate_key(['listing_id', 'review_date','reviewer_name', 'review_text']) }} as review_id,
    listing_id,
    review_date,
    NVL(reviewer_name, 'Anonymous') AS reviewer_name,
    review_text,
    review_sentiment
FROM src_reviews
WHERE review_text IS NOT NULL

{% if is_incremental() %}
  and review_date > (select max(review_date) from {{ this }})
{% endif %}