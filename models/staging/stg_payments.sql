SELECT 
    p.ID as payment_id
    ,p."orderID" as order_id
    ,p."paymentMethod" as payment_method
    ,p.amount
    ,p.created as created_dt
    ,p._batched_at as _batched_at_dt
    from raw.stripe.payment p