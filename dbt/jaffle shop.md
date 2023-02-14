# Jaffle Shop

## Refactoring SQL for Modularity [Tutorial]

### 1. Migrating Legacy Code 1:1

**Objectives:**
- Transfer your legacy code to your dbt project as a `.sql` file in the models folder.
- Ensure that it can run and build in your data warehouse by running `dbt run`.
- Depending on the system you're migrating between, you may need to adjust the flavour of SQL in your existing code to successfully build the model.


In the dbt project, under the models folder, I create a subfolder called `legacy`. Within the `legacy` folder, I create a file called `customer_orders.sql` with the following query provided by the tutorial.

_Note: Model and YAML files built for this tutorial are affixed with `_tt`._

```sql
-- customer_orders.sql
WITH paid_orders as (select Orders.ID as order_id,
        Orders.USER_ID    as customer_id,
        Orders.ORDER_DATE AS order_placed_at,
            Orders.STATUS AS order_status,
        p.total_amount_paid,
        p.payment_finalized_date,
        C.FIRST_NAME    as customer_first_name,
            C.LAST_NAME as customer_last_name
    FROM raw.jaffle_shop.orders as Orders
    left join (select ORDERID as order_id, max(CREATED) as payment_finalized_date, sum(AMOUNT) / 100.0 as total_amount_paid
from raw.stripe.payment
where STATUS <> 'fail'
group by 1) p ON orders.ID = p.order_id
left join raw.jaffle_shop.customers C on orders.USER_ID = C.ID ),

customer_orders 
    as (select C.ID as customer_id
        , min(ORDER_DATE) as first_order_date
        , max(ORDER_DATE) as most_recent_order_date
        , count(ORDERS.ID) AS number_of_orders
    from raw.jaffle_shop.customers C 
    left join raw.jaffle_shop.orders as Orders
    on orders.USER_ID = C.ID 
    group by 1)

select
    p.*,
    ROW_NUMBER() OVER (ORDER BY p.order_id) as transaction_seq,
    ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY p.order_id) as customer_sales_seq,
    CASE WHEN c.first_order_date = p.order_placed_at
    THEN 'new'
    ELSE 'return' END as nvsr,
    x.clv_bad as customer_lifetime_value,
    c.first_order_date as fdos
    FROM paid_orders p
    left join customer_orders as c USING (customer_id)
    LEFT OUTER JOIN 
    (
            select
            p.order_id,
            sum(t2.total_amount_paid) as clv_bad
        from paid_orders p
        left join paid_orders t2 on p.customer_id = t2.customer_id and p.order_id >= t2.order_id
        group by 1
        order by p.order_id
    ) x on x.order_id = p.order_id
    ORDER BY order_id
```

<img width="1438" alt="image" src="https://user-images.githubusercontent.com/81607668/218353988-c083671c-4c3f-42d5-9d6c-92341c6925b2.png">

Conduct a `dbt run -m customer_orders` to ensure the model is built in the BigQuery warehouse under `dbt_khuang > customer_orders_tt` (i.e, `dbt_khuang.customer_orders_tt`)

<img width="1438" alt="Screenshot 2023-02-13 at 9 50 59 AM" src="https://user-images.githubusercontent.com/81607668/218353156-aec88436-b04e-4651-bbf1-4aee04edafe9.png">

Under the models folder, create a subfolder called marts. Within the marts folder, create a file called `fct_customer_orders_tt.sql` with the following query.

```sql
-- fct_customer_orders_tt.sql
WITH paid_orders as (select Orders.ID as order_id,
        Orders.USER_ID    as customer_id,
        Orders.ORDER_DATE AS order_placed_at,
            Orders.STATUS AS order_status,
        p.total_amount_paid,
        p.payment_finalized_date,
        C.FIRST_NAME    as customer_first_name,
            C.LAST_NAME as customer_last_name
    FROM raw.jaffle_shop.orders as Orders
    left join (select ORDERID as order_id, max(CREATED) as payment_finalized_date, sum(AMOUNT) / 100.0 as total_amount_paid
from raw.stripe.payment
where STATUS <> 'fail'
group by 1) p ON orders.ID = p.order_id
left join raw.jaffle_shop.customers C on orders.USER_ID = C.ID ),

customer_orders 
    as (select C.ID as customer_id
        , min(ORDER_DATE) as first_order_date
        , max(ORDER_DATE) as most_recent_order_date
        , count(ORDERS.ID) AS number_of_orders
    from raw.jaffle_shop.customers C 
    left join raw.jaffle_shop.orders as Orders
    on orders.USER_ID = C.ID 
    group by 1)

select
    p.*,
    ROW_NUMBER() OVER (ORDER BY p.order_id) as transaction_seq,
    ROW_NUMBER() OVER (PARTITION BY customer_id ORDER BY p.order_id) as customer_sales_seq,
    CASE WHEN c.first_order_date = p.order_placed_at
    THEN 'new'
    ELSE 'return' END as nvsr,
    x.clv_bad as customer_lifetime_value,
    c.first_order_date as fdos
    FROM paid_orders p
    left join customer_orders as c USING (customer_id)
    LEFT OUTER JOIN 
    (
            select
            p.order_id,
            sum(t2.total_amount_paid) as clv_bad
        from paid_orders p
        left join paid_orders t2 on p.customer_id = t2.customer_id and p.order_id >= t2.order_id
        group by 1
        order by p.order_id
    ) x on x.order_id = p.order_id
    ORDER BY order_id
```

<img width="1438" alt="image" src="https://user-images.githubusercontent.com/81607668/218354059-f9eb509f-6387-4d04-8de8-6f43f0b72b76.png">

Conduct a `dbt run -m fct_customer_orders_tt` to ensure the model is built in the BigQuery warehouse under `dbt_khuang > fct_customer_orders_tt` (i.e, `dbt_khuang.fct_customer_orders_tt`).

In the root folder, I create a file `packages.yml` to utilise the audit helper. I obtained the updated package [here](https://hub.getdbt.com/dbt-labs/audit_helper/latest/).

```yml
packages:
  - package: dbt-labs/audit_helper
    version: 0.7.0
```

<img width="1438" alt="image" src="https://user-images.githubusercontent.com/81607668/218355233-1b2d66fd-36d5-4af8-94ec-ea85e11cdfaf.png">

<img width="1438" alt="image" src="https://user-images.githubusercontent.com/81607668/218354873-181096fa-b8a4-4da6-981a-7c6c740fd50f.png">

Hit the Preview button. The 1 line output is showing 100% match between the two files, because they are exactly the same. 

<img width="1438" alt="image" src="https://user-images.githubusercontent.com/81607668/218355021-946807d5-cfdf-4039-bd6a-3ebf28f71a35.png">

***

### 2 and 3. Implementing Sources and Choosing a Refactoring Strategy

**Objectives of Implementing Sources:**
- For each of the raw tables referenced in the new model, configure a source to map to those tables.
- Replace all the explicit table references in your query using the source macro.

**Objectives of Choosing a Refactoring Strategy:**
Decide on your refactoring strategy:
- Refactor on top of the existing model - Create a new branch and refactor directly on the model that you created in the steps above.
- Refactor alongside the existing model - Rename the existing model by prepending it with legacy. Then copy the code into a new file with the original file name.

In this tutorial, we are selecting the second option.

Create a subfolder under models folder called staging.

Under your models > staging folder, create two subfolders - one for each source schema that the original query pulls from. These subfolders are stripe and jaffle_shop.

Then, I create a file under models > staging > jaffle_shop called `src_jaffle_shop.yml`. The other configurations in the file were from the dbt Fundamentals course's project.

<img width="1438" alt="image" src="https://user-images.githubusercontent.com/81607668/218363805-048ec489-ba24-4c84-83bc-315b6dd5e878.png">

Create a file under models > staging > stripe called `src_stripe.yml`. 

<img width="1438" alt="image" src="https://user-images.githubusercontent.com/81607668/218363845-9c333a00-dbbd-4157-a34f-cb16ae9246b6.png">

Conduct a `dbt run -m fct_customer_orders` to ensure that your sources are configured properly and your model rebuilds in the warehouse.

Run `dbt docs generate` and inspect the DAG. 

<img width="1438" alt="image" src="https://user-images.githubusercontent.com/81607668/218363685-fb8821ce-cec5-485e-9ff9-f32fe38bf860.png">

***

### 4. Cosmetic Cleanups and CTE Groupings

Objectives:
- Create one CTE for each source referenced at the top of your model.
- Reimplement subqueries as CTEs beneath the source CTEs.
- Update code to follow your style guide. 

**Import CTEs at the top**

1. Refactor the cosmetics of the `fct_customer_orders.sql` model using the following guidelines:

- Add whitespacing
- No lines over 80 characters
- Lowercase keywords

2. Refactor the code to follow this structure:

```sql
-- WITH statement
-- Import CTEs
-- Logical CTEs
-- Final CTE
-- Simple Select Statement
```

Steps to achieve this:
a. Add a WITH statement to the top of the `fct_customer_orders` model
b. Add import CTEs after the WITH statement for each source table used in the query
c. Ensure subsequent FROM statements reference the named CTEs instead of {{ source() }}.

### 5. Centralizing Transformations and Splitting Up Models

**Objectives:**
- Structure your SQL into layers of modeling via staging models, intermediate models and final models.

**Staging models**
- Capture light transformations in staging models on source data. i.e. renaming columns, concatenating fields, converting data types.
- Update aliases with purposeful names. i.e. from `p` to `paid_customers`.
- Scan for redundant transformations in the code and migrate into staging models.
- Build dependencies between the existing model and the newly created staging models.

**CTEs or immediate models**
- Inspect the grain of the transformations in latest version of the model and look for opportunities to move filters and aggregations into earlier CTEs.
- Break CTEs into intermediate models if the model is too lengthy or could be reusable.

**a. Staging Models**

1. Create new staging files for each source:
- `stg_jaffle_shop__customers.sql` & `stg_jaffle_shop__orders.sql` under `models > staging > jaffle_shop`
- `stg_stripe__payments.sql` under `models > staging > stripe`

2. Make necessary changes in each file:
- Change `id` fields to `<object>_id`
- Make potentially clashing fields more specific, i.e. `status` becomes `order_status`
- Apply rounding or simple transformations, i.e. change `amount` to `round(amount / 100.0, 2) as payment_amount`
    
```sql
-- models/staging/jaffle_shop/stg_jaffle_shop_customers.sql
with 

source as (
    
    select * from {{ source('jaffle_shop', 'customers') }}
    
),
    
transformed as (

    select 

        id as customer_id,
        last_name as surname,
        first_name as givenname,
        first_name || ' ' || last_name as full_name
    
    from source

)

select * from transformed
```

```sql
-- models/staging/jaffle_shop/stg_jaffle_shop_orders.sql
with

source as (
    
    select * from {{ source('jaffle_shop', 'orders') }}

),

transformed as (
    select
        id as order_id,
        user_id as customer_id,
        status as order_status,
        order_date as order_placed_at,

        case
            when status not in ('returned', 'return_pending') 
            then order_date
        end as valid_order_date,
        
        row_number() over (
            partition by user_id 
            order by order_date, id
        ) as user_order_seq

    from source
)

select * from transformed
```

```sql
-- models/staging/jaffle_shop/stg_payments.sql
with 

source as (

    select * from {{ source('jaffle_shop', 'payments') }}

),

transformed as (
    select 
        id as payment_id,
        orderid as order_id,
        created as payment_created_at,
        status as payment_status,
        round(amount/100.0, 2) as payment_amount

    from source

)

select * from transformed
```

1. Update references in `fct_customer_orders.sql` to point to the new staging models using the `{{ ref('<your_model>') }}` function.

2. Change any column reference from the original column names to the new column names, for example, change id to customer_id.

**b. Intermediate Models / Additional CTEs**

1. Create a new intermediate model to store reusable logic.

2. Add a new file `int_orders_tt.sql` under the `marts/intermediate` folder.

```sql
-- models/marts/intermediate/int_orders_tt.sql
with

customers as (

    select * from {{ ref('stg_jaffle_shop_customers') }}

),

orders as (

    select * from {{ ref('stg_jaffle_shop_orders') }}

),

payments as (

    select * from {{ ref('stg_jaffle_shop_payments') }}

),

completed_payments as (

    select 
        
        order_id, 
        max(payment_created_at) as payment_finalized_date, 
        sum(payment_amount) as total_amount_paid
        
    from payments

    where payment_status <> 'fail'
    group by 1

),

paid_orders as (
    
    select 

        orders.order_id,
        orders.customer_id,
        orders.order_placed_at,
        orders.order_status,
        completed_payments.total_amount_paid,
        completed_payments.payment_finalized_date,
        customers.givenname,
        customers.surname
    
    from orders
    left join completed_payments
    on orders.order_id = completed_payments.order_id

    left join customers
    on orders.customer_id = customers.customer_id 
        
)

select * from paid_orders
```

4. Remove helper comments we added for the course (i.e. -- Import CTEs)

**c. Final Model**

In the final file, be more explicit with ordering of window function subclause. This fixes a future potential bug where if there are multiple orders placed on the same day for one customer ID, this would cause indeterminate ordering.

```sql
-- models/core/fct_customer_orders_tt
with

customers as (

    select * from {{ ref('stg_jaffle_shop_customers') }}

),

paid_orders as (
    
    select * from {{ ref('int_orders_tt') }}
        
),

final as (

select
    order_id,
    customer_id,
    order_placed_at,
    order_status,
    total_amount_paid,
    payment_finalized_date,
    givenname,
    surname,

    -- sales transaction sequence
    row_number() over (
        order by order_id) as transaction_seq,

    -- customer sales sequence
    row_number() over (
        partition by customer_id 
        order by order_id) as customer_sales_seq,

    -- new vs returning customers
    case when (
        rank() over (
        partition by customer_id
        order by order_placed_at, order_id)
    ) = 1
    then 'new'
    else 'return' 
    end as nvsr,

    -- customer lifetime value
    sum(total_amount_paid) over (
        partition by customer_id
        order by order_placed_at
    ) as customer_lifetime_value,

    -- first day of sales
    first_value(order_placed_at) over (
        partition by customer_id
        order by order_placed_at
    ) as fdos
        
from paid_orders

)

-- Simple Select Statement

select * from final
```

### 6. Auditing

**Objectives:**
- Audit your new model against your old query to ensure that none of the changes you implemented changed the results of the modelling.
- The goal is for both the original code and your final model to produce the same results.
