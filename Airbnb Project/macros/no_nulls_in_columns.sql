-- Doc | adapter.get_columns_in_relation: https://docs.getdbt.com/reference/dbt-jinja-functions/adapter#get_columns_in_relation
-- adapter.get_columns_in_relation iterates through every column in the model and checks whether column name is null.

{% macro no_nulls_in_columns (model)%}

    SELECT * 
    FROM {{ model }}
    WHERE
        {% for col in adapter.get_columns_in_relation(model) -%}
            -- Interested in columns where column name is null OR... iterates to next column
            {{ col.column }} IS NULL OR
        {% endfor %}
        FALSE -- To terminate the iteration
{% endmacro %}