# 🛌 Airbnb Project

## Objective

Work in progress.

## Tools and Technologies

- Data warehouse: Snowflake
- Transformation: dbt
- BI: Prefect

## Architecture

Data pipeline: Data Warehouse (Snowflake) -> Transformation (dbt) -> BI Tool (Prefect)

**Data Flow**
1.
2.
3.

**DAG**

<img width="1371" alt="image" src="https://user-images.githubusercontent.com/81607668/223373076-a320ca6e-b58c-4421-b41e-cda991365772.png">

## Setup virtual environment and dbt

Create a virtual environment by running the commands below:
```bash
# Create the virtual environment. Ensure that you have "cd" in the desired project's folder.
python3 -m venv venv # venv is the name of the virtual environment

# Activate the newly created virtual environment "venv"
source venv/bin/activate
```

Install dbt-snowflake library:
```bash
pip3 install dbt-snowflake
dbt # Run dbt to confirm that dbt is installed and working. You'll see a list of help guides.
```

Create a dbt project
```bash
dbt init dbtlearn # dbtlearn is the project name

type: snowflake
account: https://<take this value>.snowflakecomputing.com
user: <username in Snowflake>
password: <password in Snowflake>
role: <role in Snowflake>
warehouse: <warehouse in Snowflake> # Uppercase/lowercase-sensitive
database: <database in Snowflake> # Uppercase/lowercase-sensitive
schema: <schema in Snowflake> # Uppercase/lowercase-sensitive

# To check that the project has all the files it needs
dbt debug # Ensure it says "All checks passed!"
```

## Create dbt Models

Create a `src_listings` model (.sql) in `models/src` folder with the following query in VS Code editor. Save it.

```sql
-- models/src/src_listings.sql
WITH raw_listings AS (
	SELECT * FROM AIRBNB.RAW.RAW_LISTINGS
)

SELECT 
  id AS listing_id,
  name AS listing_name,
  listing_url,
  room_type,
  minimum_nights,
  host_id,
  price AS price_str,
  created_at,
  updated_at
FROM 
  raw_listings
```

To materialise models in dbt and Snowflake, run `dbt run` in termimal.

<img width="825" alt="Screenshot 2023-02-27 at 11 19 35 AM" src="https://user-images.githubusercontent.com/81607668/221465370-43ca1830-945c-4789-88ca-b8d48ed7a945.png">

Do the same with `src_reviews` and `src_hosts` models.
```sql
-- models/src/src_reviews.sql
WITH raw_reviews AS (
	SELECT * FROM AIRBNB.RAW.RAW_REVIEWS
)

SELECT
    listing_id,
    date AS review_date,
    reviewer_name,
    comments AS review_text,
    sentiment AS review_sentiment
FROM raw_reviews
```

```sql
-- models/src/src_hosts.sql
WITH raw_hosts AS (
	SELECT * FROM AIRBNB.RAW.RAW_HOSTS
)

SELECT
    id AS host_id,
    name AS host_name,
    is_superhost,
    created_at,
    updated_at
FROM raw_hosts
```

Run `dbt run` to materialise the views in dbt and Snowflake.
<img width="828" alt="image" src="https://user-images.githubusercontent.com/81607668/221467527-563cc613-86a5-46d7-a3c8-77b8b1c76524.png">


The DEV folder is created in Snowflake and Views folder contains all 3 of the views. 
<img width="1438" alt="Screenshot 2023-02-27 at 11 42 14 AM" src="https://user-images.githubusercontent.com/81607668/221467811-70144a38-8407-4d8f-b8d5-a0aa158444ac.png">

```
code target/run/dbtlearn/models/dim/dim_listings_cleansed.sql
```

***

### Snapshots

Snapshots are created using a snapshot block with configs onto a SELECT statement.

Here's an example of how a snapshot looks like:

<img width="611" alt="image" src="https://user-images.githubusercontent.com/81607668/221782071-35e66952-caa2-4fa1-a678-2d4ea322626f.png">

Snapshot automatically includes the columns `dbt_scd_id`, `dbt_updated_at`, `dbt_valid_from` and `dbt_valid_to`. In the first snapshot, `dbt_valid_to` is `null` because this column contains date of the next most recent changes or snapshot. 

<img width="1136" alt="image" src="https://user-images.githubusercontent.com/81607668/221782810-89766268-0725-4b95-a121-974423892382.png">

Let's say I make a change in id=3176 and ran `dbt snapshot` again. You'll see that `dbt_valid_to` contains the current timestamped and the next line represents id 3176 as well with a null `dbt_valid_to`.

<img width="833" alt="image" src="https://user-images.githubusercontent.com/81607668/221783996-15275e80-e3ac-4fb8-84c1-2882b061f585.png">

***

### Tests

Creating singular tests

```sql
-- tests/dim_listings_minimum_nights.sql
SELECT * 
FROM {{ref ('dim_listings_cleansed')}}
WHERE minimum_nights < 1
LIMIT 10
```

Instead of creating query tests, I can also convert them into custom generic test like below so that I can reuse for other purposes.

```sql
-- macro/positive_value.sql
-- A singular test that fails when column_name is less than 1

{% test positive_value(model, column_name) %}

    SELECT * FROM {{ model }}
    WHERE {{ column_name }} < 1

{% endtest %}
```

To apply them, I add the `positive_value` macro to the `schema.yml` referencing the `minimum_nights` field.

<img width="1438" alt="Screenshot 2023-03-02 at 1 12 51 PM" src="https://user-images.githubusercontent.com/81607668/222337104-2acedc89-21e6-46c1-a439-f5740022938c.png">

***

### dbt Packages

I'm using a `dbt utils`[doc](https://hub.getdbt.com/dbt-labs/dbt_utils/latest/) packages specifically the `generate_source_key`[doc](https://github.com/dbt-labs/dbt-utils/tree/1.0.0/#generate_surrogate_key-source) which generates a unique ID based on the specified column IDs.

<img width="893" alt="image" src="https://user-images.githubusercontent.com/81607668/222340554-760c7e0d-2cbc-499e-a59c-e123ca7fcfb6.png">


I created a `packages.yml` file with the following package and ran `dbt deps` to install the package.

```yml
-- packages.yml
packages:
  - package: dbt-labs/dbt_utils
    version: 1.0.0
```

<img width="733" alt="image" src="https://user-images.githubusercontent.com/81607668/222339997-61556323-9fdc-434e-a5b1-11819dc66442.png">

Then, I use this function in the `fct_reviews.sql` where I created a unique ID as the `review_id` based on the `listing_id`, `review_date`, `reviewer_name`, and `review_text` fields. 

<img width="1022" alt="image" src="https://user-images.githubusercontent.com/81607668/222340279-0d2a97a2-136b-4379-bc42-cb6fdc741ad7.png">

As `fct_reviews.sql` is an incremental, I ran the `dbt run --full-refresh --select fct_reviews` instead of `dbt run` because

***

### Documentation

I ran `dbt docs serve` to open into website.

<img width="1360" alt="image" src="https://user-images.githubusercontent.com/81607668/222343062-d9465f5e-0802-4ed6-8432-b6aa36afd371.png">
