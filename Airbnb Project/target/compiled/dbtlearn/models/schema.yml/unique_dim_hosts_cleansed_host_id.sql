
    
    

select
    host_id as unique_field,
    count(*) as n_records

from airbnb.dev.dim_hosts_cleansed
where host_id is not null
group by host_id
having count(*) > 1


