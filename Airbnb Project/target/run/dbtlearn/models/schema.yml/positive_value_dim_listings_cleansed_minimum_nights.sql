select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      

    SELECT * FROM airbnb.dev.dim_listings_cleansed
    WHERE minimum_nights < 1


      
    ) dbt_internal_test