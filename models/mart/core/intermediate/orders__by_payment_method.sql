{% set payment_methods_query %}
select distinct payment_method from {{ ref('stg_stripe_payments')}}
-- order by 1
{% endset %}

{% set payment_methods = run_query(payment_methods_query) %}

{% if execute %}
{# Return the first column #}
    {% set payment_method_results = payment_methods.columns[0].values() %}
{% else %}
    {% set payment_method_results = [] %}
{% endif %}

with payments as (
    select * 
    FROM {{ ref('stg_stripe_payments') }}
)

-- ,pivot as (
--     SELECT 
--         order_id
--         ,sum(CASE
--             WHEN payment_method = 'bank_transfer' THEN amount end) as bank_transfer_amount
--         ,sum(CASE
--             WHEN payment_method = 'coupon' THEN amount end) as coupon_amount
--         ,sum(CASE
--             WHEN payment_method = 'credit_card' THEN amount end) as credit_card_amount
--         ,sum(CASE
--             WHEN payment_method = 'gift_card' THEN amount end) as gift_card_amount

--         FROM payments
--         GROUP BY 1
-- )


, loop1 as (
    SELECT order_id,
    {% for payment_method in payment_method_results %}
    coalesce(
    sum(CASE WHEN payment_method = '{{ payment_method }}' THEN amount end),0) as {{ payment_method }}_amount 
    {% if not loop.last %}, {% endif %}
    {% endfor %}
    FROM payments
    GROUP BY 1
)



SELECT * FROM loop1

