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

To create models in dbt, run `dbt run` in termimal.

<img width="825" alt="Screenshot 2023-02-27 at 11 19 35 AM" src="https://user-images.githubusercontent.com/81607668/221465370-43ca1830-945c-4789-88ca-b8d48ed7a945.png">




