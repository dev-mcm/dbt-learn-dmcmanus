
with orders as (
    SELECT * FROM {{ref('stg_jaffle_shop__orders')}}
)

SELECT o.*
    ,sum(p.amount) as amount
FROM orders o
LEFT JOIN {{ref('stg_stripe_payments')}} p
ON o.order_id = p.order_id
GROUP BY 1,2,3,4