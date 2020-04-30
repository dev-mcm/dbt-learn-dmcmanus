{% macro cents_to_decimal(cents_amount) -%}

    ({{ cents_amount }}/100.0)::decimal(18,4)

{%- endmacro %}
