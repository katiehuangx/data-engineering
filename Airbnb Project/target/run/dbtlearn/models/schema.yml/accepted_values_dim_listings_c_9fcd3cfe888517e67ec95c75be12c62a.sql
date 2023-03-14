select
      count(*) as failures,
      count(*) != 0 as should_warn,
      count(*) != 0 as should_error
    from (
      
    
    

with all_values as (

    select
        room_type as value_field,
        count(*) as n_records

    from airbnb.dev.dim_listings_cleansed
    group by room_type

)

select *
from all_values
where value_field not in (
    'Entire room/apt','Private room','Shared room','Hotel room'
)



      
    ) dbt_internal_test