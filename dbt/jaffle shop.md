# Jaffle Shop

## Refactoring SQL for Modularity

### Migrating Code

In the dbt project, under your models folder, I create a subfolder called `legacy`. Within the `legacy` folder, create a file called `customer_orders.sql` with the following query. 

_Note: Code has been updated with correct source and formatting. All models built for this tutorial is affixed with `_tt`._

```sql
-- customer_orders.sql
WITH 

paid_orders as (
    
    select 
        Orders.ID as order_id,
        Orders.USER_ID as customer_id,
        Orders.ORDER_DATE AS order_placed_at,
        Orders.STATUS AS order_status,
        p.total_amount_paid,
        p.payment_finalized_date,
        C.FIRST_NAME    as customer_first_name,
        C.LAST_NAME as customer_last_name
    
    FROM {{ source('jaffle_shop', 'orders') }} as Orders
    left join (
        
        select 
            ORDERID as order_id, 
            max(CREATED) as payment_finalized_date, 
            sum(AMOUNT) / 100.0 as total_amount_paid
       
        from {{ source('jaffle_shop', 'payments') }}
       
        where STATUS <> 'fail'
        group by 1) p 
        
    ON orders.ID = p.order_id

    left join {{ source('jaffle_shop', 'customers') }} C 
    on orders.USER_ID = C.ID

),

customer_orders as (
    
    select 
        C.ID as customer_id, 
        min(ORDER_DATE) as first_order_date, 
        max(ORDER_DATE) as most_recent_order_date, 
        count(ORDERS.ID) AS number_of_orders
    
    from {{ source('jaffle_shop', 'customers') }} C 
    left join {{ source('jaffle_shop', 'orders') }} as Orders
    on orders.USER_ID = C.ID 
    
    group by 1

)

select
    
    p.*,

    ROW_NUMBER() OVER (
    ORDER BY p.order_id) as transaction_seq,
    
    ROW_NUMBER() OVER (
    PARTITION BY customer_id 
    ORDER BY p.order_id) as customer_sales_seq,

    CASE WHEN c.first_order_date = p.order_placed_at
    THEN 'new'
    ELSE 'return' END as nvsr,
  
    x.clv_bad as customer_lifetime_value,
  
    c.first_order_date as fdos
  
    FROM paid_orders p
    left join customer_orders as c 
    USING (customer_id)
    
    LEFT OUTER JOIN (
        
        select
            
            p.order_id,
            sum(t2.total_amount_paid) as clv_bad
        
        from paid_orders p
        left join paid_orders t2 
        on p.customer_id = t2.customer_id 
        and p.order_id >= t2.order_id

        group by 1
        order by p.order_id
    
    ) x 
    
    on x.order_id = p.order_id
    
    ORDER BY order_id
```

<img width="1438" alt="image" src="https://user-images.githubusercontent.com/81607668/218353988-c083671c-4c3f-42d5-9d6c-92341c6925b2.png">

Conduct a `dbt run -m customer_orders` to ensure the model is built in the BigQuery warehouse under dbt_khuang > customer_orders_tt (i.e, dbt_khuang.customer_orders_tt)

<img width="1438" alt="Screenshot 2023-02-13 at 9 50 59 AM" src="https://user-images.githubusercontent.com/81607668/218353156-aec88436-b04e-4651-bbf1-4aee04edafe9.png">

Under the models folder, create a subfolder called marts. Within the marts folder, create a file called fct_customer_orders_tt.sql with the following query.

```sql
-- fct_customer_orders_tt.sql

WITH 

paid_orders as (
    
    select 
        Orders.ID as order_id,
        Orders.USER_ID as customer_id,
        Orders.ORDER_DATE AS order_placed_at,
        Orders.STATUS AS order_status,
        p.total_amount_paid,
        p.payment_finalized_date,
        C.FIRST_NAME as customer_first_name,
        C.LAST_NAME as customer_last_name
    
    FROM {{ source('jaffle_shop', 'orders') }} as Orders
    left join (
        
        select 
        
            ORDERID as order_id, 
            max(CREATED) as payment_finalized_date, 
            sum(AMOUNT) / 100.0 as total_amount_paid
        
        from {{ source('jaffle_shop', 'payments') }}

        where STATUS <> 'fail'
        group by 1
        
        ) p 
        ON orders.ID = p.order_id

        left join {{ source('jaffle_shop', 'customers') }} C 
        on orders.USER_ID = C.ID 
        
),

customer_orders as (
    
    select 
    
        C.ID as customer_id, 
        min(ORDER_DATE) as first_order_date, 
        max(ORDER_DATE) as most_recent_order_date, 
        count(ORDERS.ID) AS number_of_orders
    
    from {{ source('jaffle_shop', 'customers') }} C 
    left join {{ source('jaffle_shop', 'orders') }} as Orders
    on orders.USER_ID = C.ID 
    
    group by 1
    
)

select
    p.*,
    
    ROW_NUMBER() OVER (
    ORDER BY p.order_id) as transaction_seq,

    ROW_NUMBER() OVER (
    PARTITION BY customer_id 
    ORDER BY p.order_id) as customer_sales_seq,

    CASE WHEN c.first_order_date = p.order_placed_at
    THEN 'new'
    ELSE 'return' END as nvsr,
    
    x.clv_bad as customer_lifetime_value,
    c.first_order_date as fdos
    
FROM paid_orders p
left join customer_orders as c 
USING (customer_id)

LEFT OUTER JOIN (
    
    select
        
        p.order_id,
        sum(t2.total_amount_paid) as clv_bad
        
    from paid_orders p
    left join paid_orders t2 
    on p.customer_id = t2.customer_id 
    and p.order_id >= t2.order_id

    group by 1
    order by p.order_id
    
) x 
on x.order_id = p.order_id
    
ORDER BY order_id
```

<img width="1438" alt="image" src="https://user-images.githubusercontent.com/81607668/218354059-f9eb509f-6387-4d04-8de8-6f43f0b72b76.png">

Conduct a `dbt run -m fct_customer_orders_tt` to ensure the model is built in the BigQuery warehouse under dbt_khuang > fct_customer_orders_tt (i.e, dbt_khuang.fct_customer_orders_tt).

n your project, in the root folder, create a file packages.yml. Get the updated package [here](https://hub.getdbt.com/dbt-labs/audit_helper/latest/).

```yml
packages:
  - package: dbt-labs/audit_helper
    version: 0.7.0
```

<img width="1438" alt="image" src="https://user-images.githubusercontent.com/81607668/218355233-1b2d66fd-36d5-4af8-94ec-ea85e11cdfaf.png">

<img width="1438" alt="image" src="https://user-images.githubusercontent.com/81607668/218354873-181096fa-b8a4-4da6-981a-7c6c740fd50f.png">

Hit the Preview button.

The 1 line output is showing 100% match between the two files, because they are exactly the same. 

<img width="1438" alt="image" src="https://user-images.githubusercontent.com/81607668/218355021-946807d5-cfdf-4039-bd6a-3ebf28f71a35.png">

***

### Implementing Sources and Choosing a Refactoring Strategy

Create a subfolder under models folder called staging.

Under your models > staging folder, create two subfolders - one for each source schema that our original query pulls from. These subfolders are stripe and jaffle_shop.

Then, I create a file under models > staging > jaffle_shop called `src_jaffle_shop.yml`. The other configurations in the file were from the dbt Fundamentals course's project.

<img width="1438" alt="image" src="https://user-images.githubusercontent.com/81607668/218363805-048ec489-ba24-4c84-83bc-315b6dd5e878.png">

Create a file under models > staging > stripe called `src_stripe.yml`. 

<img width="1438" alt="image" src="https://user-images.githubusercontent.com/81607668/218363845-9c333a00-dbbd-4157-a34f-cb16ae9246b6.png">

Conduct a `dbt run -m fct_customer_orders` to ensure that your sources are configured properly and your model rebuilds in the warehouse.

Run `dbt docs generate` and inspect the DAG. 

<img width="1438" alt="image" src="https://user-images.githubusercontent.com/81607668/218363685-fb8821ce-cec5-485e-9ff9-f32fe38bf860.png">

***

### Cosmetic Cleanups and CTE Groupings

### Centralizing Logic and Splitting Up Models

**a. Staging Models**

**b. Intermediate Models / Additional CTEs**

**c. Final Model**

### Auditing
