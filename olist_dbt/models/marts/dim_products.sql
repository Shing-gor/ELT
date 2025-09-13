-- models/marts/dim_products.sql

with products as (
    select * from {{ ref('stg_products') }}
),
sellers as (
    select * from {{ ref('stg_sellers') }}
),
order_items as (
    -- We need to get the seller_id for each product from the order_items table
    -- This is a common pattern when a dimension's attribute is only in a fact-like table
    select
        product_id,
        seller_id
    from {{ ref('stg_order_items') }}
)
select
    p.product_id,
    oi.seller_id,
    p.product_category_name,
    s.seller_city,
    s.seller_state
from products p
left join order_items oi on p.product_id = oi.product_id
left join sellers s on oi.seller_id = s.seller_id