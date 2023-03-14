select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      -- Testing `no_nulls_in_columns` macro on `dim_listings_cleansed table`



    SELECT * 
    FROM airbnb.dev.dim_listings_cleansed
    WHERE
        -- Interested in columns where column name is null OR... iterates to next column
            LISTING_ID IS NULL OR
        -- Interested in columns where column name is null OR... iterates to next column
            LISTING_NAME IS NULL OR
        -- Interested in columns where column name is null OR... iterates to next column
            ROOM_TYPE IS NULL OR
        -- Interested in columns where column name is null OR... iterates to next column
            MINIMUM_NIGHTS IS NULL OR
        -- Interested in columns where column name is null OR... iterates to next column
            HOST_ID IS NULL OR
        -- Interested in columns where column name is null OR... iterates to next column
            PRICE IS NULL OR
        -- Interested in columns where column name is null OR... iterates to next column
            CREATED_AT IS NULL OR
        -- Interested in columns where column name is null OR... iterates to next column
            UPDATED_AT IS NULL OR
        
        FALSE -- To terminate the iteration

      
    ) dbt_internal_test