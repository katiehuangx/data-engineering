-- Checks that there is no review date that is submitted before its listing was created

SELECT *
FROM {{ref ('dim_listings_cleansed')}} AS listings
INNER JOIN {{ref ('fct_reviews')}} AS reviews
	USING (listing_id)
WHERE reviews.review_date <=  listings.created_at

