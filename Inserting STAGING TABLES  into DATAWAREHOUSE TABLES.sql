
--INSERTING FROM PRODUCT CATEGORY STAGING TABLE INTO DATA WAREHOUSE CATEGORY TABLE
insert into [dbo].[DW_OLIST_PRODUCT_CATEGORY] ([product_category_name], [product_category_name_english])
SELECT [product_category_name], [product_category_name_english]
FROM [dbo].[staging_olist_product_category]


--INSERTING FROM PRODUCT STAGING TABLE INTO DATA WAREHOUSE PRODUCT TABLE
INSERT INTO [dbo].[DW_OLIST_PRODUCT_TABLE] 
([product_id], [product_category_name], [product_name_lenght], [product_description_lenght],
[product_photos_qty], [product_weight_g], [product_length_cm], [product_height_cm], [product_width_cm])
Select  [product_id], sopc.[product_category_name], [product_name_lenght], [product_description_lenght],
[product_photos_qty], [product_weight_g], [product_length_cm], [product_height_cm], [product_width_cm]
from [dbo].[staging_olist_products_table] sopt
inner join [dbo].[staging_olist_product_category] sopc
on sopt.[product_category_name] = sopc.[product_category_name]


--INSERTING FROM STAGING TABLE INTO DATA WAREHOUSE SELLERS TABLE
insert into [dbo].[DW_OLIST_SELLERS_TABLE]
([sellers_id], [seller_zip_code], [seller_city], [seller_state])
select [seller_id], [seller_zip_code_prefix], [seller_city], [seller_state]
from [dbo].[staging_olist_sellers_table]


--INSERTING FROM STAGING TABLE INTO DATA WAREHOUSE GEOLOCATION TABLE
insert into [dbo].[DW_OLIST_GEOLOCATION_TABLE]
([geolocation_zip_code_prefix], [geolocation_lat], [geolocation_lng], [geolocation_city], [geolocation_state])
select [geolocation_zip_code_prefix], [geolocation_lat],[geolocation_lng],[geolocation_city],[geolocation_state]
from [dbo].[staging_olist_geolocation_table]


--INSERTING FROM CUSTOMER STAGING TABLE INTO DATA WAREHOUSE CUSTOMER TABLE
insert into [dbo].[DW_OLIST_CUSTOMER_TABLE]
([customer_id], [customer_unique_id], [customer_zip_code_prefix], [customer_city], [customer_state])
select [customer_id], [customer_unique_id], [customer_zip_code_prefix], [customer_city], [customer_state]
from [dbo].[staging_olist_Customer_table]


--INSERTING FROM ORDERS STAGING TABLE INTO DATA WAREHOUSE CUSTOMER TABLE
insert into [dbo].[DW_OLIST_ORDERS_TABLE]
([order_id], [customer_id], [order_status], [order_purchase_timestamp], [order_approved_at],
[order_delivered_carrier_date], [order_delivered_customer_date], [order_estimated_delivery_date])
select [order_id], soot.[customer_id], [order_status], [order_purchase_timestamp], [order_approved_at],
[order_delivered_carrier_date], [order_delivered_customer_date], [order_estimated_delivery_date]
from [dbo].[staging_olist_orders_table] soot
inner join [dbo].[staging_olist_Customer_table] soct
on soot.[customer_id] = soct.[customer_id]


--INSERTING FROM ORDER REVIEWS STAGING TABLE INTO DATA WAREHOUSE CUSTOMER TABLE
insert into [dbo].[DW_OLIST_ORDER_REVIEWS_TABLE]
([review_id], [order_id], [review_score], [review_comment_title], [review_comment_message],
[review_creation_date], [review_answer_timestamp])
select [review_id], soort.[order_id],[review_score],[review_comment_title],
cast([review_comment_message] as varchar),
[review_creation_date],[review_answer_timestamp]
from [dbo].[staging_olist_order_reviews_table] soort
inner join [dbo].[staging_olist_orders_table] soot
on soort.[order_id] = soot.[order_id]



--INSERTING FROM ORDER PAYMENT STAGING TABLE INTO DATA WAREHOUSE CUSTOMER TABLE
insert into [dbo].[DW_OLIST_ORDER_PAYMENT_TABLE]
([order_id], [payment_sequential], [payment_type], [payment_installments], [payment_value])
select soopt.[order_id], [payment_sequential], [payment_type], [payment_installments], [payment_value]
from [dbo].[staging_olist_order_payment_table] soopt
inner join [dbo].[staging_olist_orders_table] soot
on soopt.[order_id] = soot.[order_id]


--INSERTING FROM ORDER ITEMS STAGING TABLE INTO DATA WAREHOUSE CUSTOMER TABLE
insert into [dbo].[DW_OLIST_ORDER_ITEMS_TABLE]
([order_id], [order_item_id], [product_id], [sellers_id],
[shipping_limit_date], [price], [freight_value])
select sooit.[order_id], [order_item_id], sopt.[product_id], sost.[seller_id],
[shipping_limit_date], [price], [freight_value]
from [dbo].[staging_olist_order_items_table] sooit
inner join [dbo].[staging_olist_orders_table] soot
on sooit.[order_id] = soot.[order_id]
inner join [dbo].[staging_olist_products_table] sopt
on sooit.[product_id] = sopt.[product_id]
inner join [dbo].[staging_olist_product_category] sopc
on sopt.[product_category_name] = sopc.[product_category_name]
inner join [dbo].[staging_olist_sellers_table] sost
on sooit.[seller_id] = sost.[seller_id]
