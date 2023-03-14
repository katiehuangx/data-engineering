select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      


    with grouped_expression as (
    select
        
        
    
  
count(distinct room_type) = 4
 as expression


    from airbnb.raw.raw_listings
    

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