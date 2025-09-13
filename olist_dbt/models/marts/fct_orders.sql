-- models/marts/fct_orders.sql

with orders as (
    select * from {{ ref('stg_orders') }}
),
order_items as (
    select * from {{ ref('stg_order_items') }}
),
order_payments as (
    select * from {{ ref('stg_order_payments') }}
),
order_reviews as (
    select * from {{ ref('stg_order_reviews') }}
),
final as (
    select
        -- We create a unique key for each order item, as order_id is not unique
        {{ dbt_utils.generate_surrogate_key(['oi.order_id', 'oi.order_item_id']) }} as order_item_sk,
        oi.order_id,
        oi.order_item_id,
        o.customer_id,
        oi.product_id,
        oi.seller_id,
        
        -- Order details
        o.order_status,
        o.order_purchase_timestamp,
        
        -- Item details
        oi.price,
        oi.freight_value,
        
        -- Payment details
        op.payment_type,
        op.payment_installments,
        op.payment_value,
        
        -- Review details
        r.review_score

    from order_items oi
    left join orders o on oi.order_id = o.order_id
    left join order_payments op on oi.order_id = op.order_id
    left join order_reviews r on oi.order_id = r.order_id
)
select * from final