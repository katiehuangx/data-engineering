{% snapshot scd_raw_listings %}

{{ 
    config(
    target_schema="dev",
    unique_key="id",
    strategy="timestamp",
    updated_at="updated_at",
    invalidate_hard_deletes=True
    ) 
}}

-- Base of a snapshot is ALWAYS a SELECT * statement
-- Doc | Snapshots: https://docs.getdbt.com/docs/build/snapshots

SELECT * FROM {{source ('airbnb', 'listings')}}

{% endsnapshot %}