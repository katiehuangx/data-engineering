


WITH  __dbt__cte__src_listings as (
WITH raw_listings AS (
	SELECT * FROM airbnb.raw.raw_listings
)

SELECT 
	id AS listing_id,
    name AS listing_name,
    listing_url,
    room_type,
    minimum_nights,
    host_id,
    price AS price_str,
    created_at,
    updated_at
FROM 
	raw_listings
),src_listings AS (
    SELECT * FROM __dbt__cte__src_listings
)

SELECT
    listing_id,
    listing_name,
    room_type,
    CASE 
        WHEN minimum_nights = 0 THEN 1 -- 0 night = 1 night, so we assign the value of 1 to indicate 1 night
        ELSE minimum_nights
    END AS minimum_nights,
    host_id,
    REPLACE( -- Parse string value into numerical form
        price_str, '$' -- Replace '$' with price_str value. In other words, to remove '$' from string.
        ) :: NUMBER (10, 2 -- Convert string type to numerical with 2 decimal places
    ) AS price,
    created_at,
    updated_at
    
FROM src_listings