select
    o.id as order_id
    ,o.user_id as customer_id
    ,o.order_date
    ,o.status
    ,sum(p.amount)/100 as USD
from raw.jaffle_shop.orders o
LEFT JOIN {{ref('stg_payments')}} p
ON o.id = p.order_id
GROUP BY 1,2,3,4
