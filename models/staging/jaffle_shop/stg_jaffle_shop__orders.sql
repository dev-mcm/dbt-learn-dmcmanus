select
    o.id as order_id
    ,o.user_id as customer_id
    ,o.order_date
    ,o.status
from {{ source('jaffle_shop', 'orders')}} o

