# Jaffle Shop

## Refactoring SQL for Modularity

### Migrating Code

In the dbt project, under your models folder, I create a subfolder called `legacy`. Within the `legacy` folder, create a file called `customer_orders.sql` with the following query. 

_Note: Code has been updated with correct source and formatting._

```sql
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

Conduct a `dbt run -m customer_orders` to ensure the model is built in the BigQuery warehouse under dbt_khuang > customer_orders_tt (i.e, dbt_khuang.customer_orders_tt)

<img width="1438" alt="Screenshot 2023-02-13 at 9 50 59 AM" src="https://user-images.githubusercontent.com/81607668/218353156-aec88436-b04e-4651-bbf1-4aee04edafe9.png">


5. In your dbt project, under your models folder, create a subfolder called marts.

6. Within the legacy folder, create a file called fct_customer_orders.sql

Paste the following query in the fct_customer_orders.sql file:

5. In your dbt project, under your models folder, create a subfolder called marts.

6. Within the legacy folder, create a file called fct_customer_orders.sql

Paste the following query in the fct_customer_orders.sql file:


### Implementing Sources

### Choosing a Refactoring Strategy

### Cosmetic Cleanups and CTE Groupings

### Centralizing Logic and Splitting Up Models

**a. Staging Models**

**b. Intermediate Models / Additional CTEs**

**c. Final Model**

### Auditing
