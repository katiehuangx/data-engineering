-- Testing `no_nulls_in_columns` macro on `dim_listings_cleansed table`
-- Run dbt test -select dim_listings_cleansed

{{ no_nulls_in_columns(ref ('dim_listings_cleansed'))}}

