
      begin;
    merge into "AIRBNB"."DEV"."SCD_RAW_LISTINGS" as DBT_INTERNAL_DEST
    using "AIRBNB"."DEV"."SCD_RAW_LISTINGS__dbt_tmp" as DBT_INTERNAL_SOURCE
    on DBT_INTERNAL_SOURCE.dbt_scd_id = DBT_INTERNAL_DEST.dbt_scd_id

    when matched
     and DBT_INTERNAL_DEST.dbt_valid_to is null
     and DBT_INTERNAL_SOURCE.dbt_change_type in ('update', 'delete')
        then update
        set dbt_valid_to = DBT_INTERNAL_SOURCE.dbt_valid_to

    when not matched
     and DBT_INTERNAL_SOURCE.dbt_change_type = 'insert'
        then insert ("ID", "LISTING_URL", "NAME", "ROOM_TYPE", "MINIMUM_NIGHTS", "HOST_ID", "PRICE", "CREATED_AT", "UPDATED_AT", "DBT_UPDATED_AT", "DBT_VALID_FROM", "DBT_VALID_TO", "DBT_SCD_ID")
        values ("ID", "LISTING_URL", "NAME", "ROOM_TYPE", "MINIMUM_NIGHTS", "HOST_ID", "PRICE", "CREATED_AT", "UPDATED_AT", "DBT_UPDATED_AT", "DBT_VALID_FROM", "DBT_VALID_TO", "DBT_SCD_ID")

;
    commit;
  