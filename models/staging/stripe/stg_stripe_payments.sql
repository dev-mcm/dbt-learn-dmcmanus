SELECT 
    p.ID as payment_id
    ,p."orderID" as order_id
    ,p."paymentMethod" as payment_method
    ,{{ cents_to_decimal('amount') }} as macro_amount
    ,p.amount/100 as amount
    ,p.created as created_dt
    ,p._batched_at as _batched_at_dt
    from {{ source('stripe', 'payment')}}  p