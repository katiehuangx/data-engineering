select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      




    with grouped_expression as (
    select
        
        
    
  
( 1=1 and max(price) <= 5000
)
 as expression


    from airbnb.dev.dim_listings_w_hosts
    

),
validation_errors as (

    select
        *
    from
        grouped_expression
    where
        not(expression = true)

)

select *
from validation_errors






      
    ) dbt_internal_test