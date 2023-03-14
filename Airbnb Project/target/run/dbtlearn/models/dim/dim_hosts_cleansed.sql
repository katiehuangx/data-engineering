
  create or replace   view airbnb.dev.dim_hosts_cleansed
  
   as (
    

WITH  __dbt__cte__src_hosts as (
WITH raw_hosts AS (
	SELECT * FROM airbnb.raw.raw_hosts
)

SELECT
    id AS host_id,
    name AS host_name,
    is_superhost,
    created_at,
    updated_at
FROM raw_hosts
),src_hosts AS (
    SELECT * FROM __dbt__cte__src_hosts
)

SELECT 
    host_id,
    NVL(host_name, 'Anonymous') AS host_name,
    is_superhost,
    created_at,
    updated_at
FROM src_hosts
  );

