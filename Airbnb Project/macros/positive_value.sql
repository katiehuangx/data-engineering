-- A singular test that fails when column_name is less than 1

{% test positive_value(model, column_name) %}

    SELECT * FROM {{ model }}
    WHERE {{ column_name }} < 1

{% endtest %}