# 🛌 Airbnb Project

Data pipeline: Data Warehouse (Snowflake) -> Transformation (dbt) -> BI Tool (Prefect)

## Create Staging Models

Create a `src_listings` model (.sql) in `models/src` folder with the following query in VS Code editor. Save it.

```sql
-- models/src/src_listings.sql
WITH raw_listings AS (
	SELECT * FROM AIRBNB.RAW.RAW_LISTINGS
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
```

To materialise models in dbt and Snowflake, run `dbt run` in termimal.

<img width="825" alt="Screenshot 2023-02-27 at 11 19 35 AM" src="https://user-images.githubusercontent.com/81607668/221465370-43ca1830-945c-4789-88ca-b8d48ed7a945.png">

Do the same with `src_reviews` and `src_hosts` models.
```sql
-- models/src/src_reviews.sql
WITH raw_reviews AS (
	SELECT * FROM AIRBNB.RAW.RAW_REVIEWS
)

SELECT
    listing_id,
    date AS review_date,
    reviewer_name,
    comments AS review_text,
    sentiment AS review_sentiment
FROM raw_reviews
```

```sql
-- models/src/src_hosts.sql
WITH raw_hosts AS (
	SELECT * FROM AIRBNB.RAW.RAW_HOSTS
)

SELECT
    id AS host_id,
    name AS host_name,
    is_superhost,
    created_at,
    updated_at
FROM raw_hosts
```

Run `dbt run` to materialise the views in dbt and Snowflake.
<img width="828" alt="image" src="https://user-images.githubusercontent.com/81607668/221467527-563cc613-86a5-46d7-a3c8-77b8b1c76524.png">


The DEV folder is created in Snowflake and Views folder contains all 3 of the views. 
<img width="1438" alt="Screenshot 2023-02-27 at 11 42 14 AM" src="https://user-images.githubusercontent.com/81607668/221467811-70144a38-8407-4d8f-b8d5-a0aa158444ac.png">

```
code target/run/dbtlearn/models/dim/dim_listings_cleansed.sql
```
