
with orders as (
    SELECT * FROM {{ref('stg_jaffle_shop__orders')}}
)
, payments as (
    select * from {{ref('stg_stripe_payments')}}
)

, total_paid as (
    select 
        order_id
        ,sum(amount) as amount
        FROM payments
        group by 1
)

,joined as (

    SELECT *
    FROM orders o
    LEFT JOIN total_paid p
        USING (order_id)

    )

select * from joined