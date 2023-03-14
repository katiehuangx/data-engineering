select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      -- Checks that there is no review date that is submitted before its listing was created

SELECT *
FROM airbnb.dev.dim_listings_cleansed AS listings
INNER JOIN airbnb.dev.fct_reviews AS reviews
	USING (listing_id)
WHERE reviews.review_date <=  listings.created_at
      
    ) dbt_internal_test