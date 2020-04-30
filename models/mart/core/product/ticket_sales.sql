with orders as(
    SELECT * FROM    {{ source('ticket_tailor','orders') }}
)
, refunds as (
    SELECT * FROM {{ source('learn_stripe','refunds') }}
)

 ,orders1 as (SELECT 
    event_id
    ,event_name
    ,transaction_id as charge_id            
    ,sum(tickets_purchased) as tickets_purchased
    ,sum(order_cancelled) as canceled
    FROM orders
                GROUP BY 1,2,3
                )
, refunds1 as (SELECT 
                charge_id
                ,sum(CASE 
                    WHEN status = 'succeeded' THEN tickets_purchased END) as tickets_refunded
                ,sum(CASE 
                    WHEN status = 'pending' THEN tickets_purchased END) as tickets_refund_pending
              FROM refunds
              JOIN orders1 USING (charge_id)

              GROUP BY 1
     
)

, summary as (
    SELECT
        event_name
        ,COALESCE(sum(tickets_purchased), 0) tickets_purchased
        ,COALESCE(sum(canceled), 0) tickets_canceled
        ,COALESCE(sum(tickets_refunded), 0) as tickets_refunded
        ,COALESCE(sum(tickets_refund_pending), 0) as tickets_refund_pending
     FROM orders1
  LEFT JOIN refunds1 USING (charge_id)
  GROUP BY 1
        
)

    SELECT * FROM summary    