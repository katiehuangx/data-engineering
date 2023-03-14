SELECT * 
FROM airbnb.dev.dim_listings_cleansed
WHERE minimum_nights < 1
LIMIT 10

-- Query is written in such a way that the results returned must be zero to PASS the test.