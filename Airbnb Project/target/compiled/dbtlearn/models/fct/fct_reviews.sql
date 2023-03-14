-- Doc | Config : https://docs.getdbt.com/reference/dbt-jinja-functions/config


-- dbt materializes the model as an incremental table. 
-- Read for difference btw table vs. incremental: https://docs.getdbt.com/docs/build/materializations

WITH  __dbt__cte__src_reviews as (
WITH raw_reviews AS (
	SELECT * FROM airbnb.raw.raw_reviews
)

SELECT
    listing_id,
    date AS review_date,
    reviewer_name,
    comments AS review_text,
    sentiment AS review_sentiment
FROM raw_reviews
),src_reviews AS (
    SELECT * FROM __dbt__cte__src_reviews
)

SELECT 
    -- Create a unique review_id based on the following columns
    
    
md5(cast(coalesce(cast(listing_id as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(review_date as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(reviewer_name as TEXT), '_dbt_utils_surrogate_key_null_') || '-' || coalesce(cast(review_text as TEXT), '_dbt_utils_surrogate_key_null_') as TEXT)) as review_id,
    listing_id,
    review_date,
    NVL(reviewer_name, 'Anonymous') AS reviewer_name,
    review_text,
    review_sentiment
FROM src_reviews
WHERE review_text IS NOT NULL


  and review_date > (select max(review_date) from airbnb.dev.fct_reviews)
