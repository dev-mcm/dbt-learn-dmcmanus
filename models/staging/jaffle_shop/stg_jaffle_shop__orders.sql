select
    o.id as order_id
    ,o.user_id as customer_id
    ,o.order_date
    ,o.status
from raw.jaffle_shop.orders o

