-- models/staging/stg_order_items.sql

select
    order_id,
    order_item_id,
    product_id,
    seller_id,
    cast(shipping_limit_date as timestamp) as shipping_limit_date,
    price,
    freight_value
from {{ source('raw_data', 'order_items') }}