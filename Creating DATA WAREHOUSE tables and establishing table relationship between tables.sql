

select distinct([product_category_name]), count(*)
from [dbo].[staging_olist_product_category]
group by [product_category_name]


select *
from [dbo].[staging_olist_products_table]

SELECT *
FROM [dbo].[staging_olist_product_category]

SELECT DISTINCT(product_category_name)
FROM [dbo].[staging_olist_product_category]


--SINCE WE ARE USING THIS TABLES FOR OLAP PURPOSES AND QUERIES WILL BE 
--RUN REGULARLY ON THE DATAWAREHOUSE WE NEED TO REDUCE NORMALIZATION AND ENSURE
--THAT THE LENGTH OF QUERIES ARE REDUCED WHEN ANALYSING. HEREBY WE WILL HAVE
--PRODUCT CATEGORY AND PRODUCT TABLE AS ONE TABLE.


--CREATING TABLE FOR PRODUCT_CATEGORY WHICH HAS A PRIMARY KEY FOREIGN KEY RELATIONSHIP WITH 
--THE PRODUCT_TABLE (ONE TO MANY RELATIONSHIP)
create table DW_OLIST_PRODUCT_CATEGORY(
product_category_name varchar(100) primary key not null,
product_category_name_english varchar(100))


--CREATING TABLE FOR PRODUCT WHICH REFERENCES PRODUCT CATEGORY TABLE ON product_category_name
create table DW_OLIST_PRODUCT_TABLE(
product_id varchar(100) primary key,
product_category_name varchar(100) null,
product_name_lenght integer,
product_description_lenght integer,
product_photos_qty integer,
product_weight_g integer, 
product_length_cm integer,
product_height_cm integer,
product_width_cm integer
constraint fk_product_table foreign key (product_category_name) references DW_OLIST_PRODUCT_CATEGORY
(product_category_name))


--CREATING TABLE FOR SELLER TABLE
CREATE TABLE DW_OLIST_SELLERS_TABLE(
sellers_id varchar(100) primary key,
seller_zip_code bigint,
seller_city varchar(100),
seller_state varchar(100))

--CREATING GEOLOCATION TABLE
CREATE TABLE DW_OLIST_GEOLOCATION_TABLE(
geolocation_zip_code_prefix bigint,
geolocation_lat float,
geolocation_lng float,
geolocation_city varchar(100),
geolocation_state varchar (100))



--CREATING TABLE FOR CUSTOMER WHICH HAS A PRIMARY KEY FOREIGN KEY RELATIONSHIP WITH 
--THE ORDERS_TABLE (ONE TO MANY RELATIONSHIP)
CREATE TABLE DW_OLIST_CUSTOMER_TABLE(
customer_id varchar(100) primary key,
customer_unique_id varchar (100),
customer_zip_code_prefix bigint, 
customer_city varchar (100),
customer_state varchar(100))

--CREATING TABLE FOR ORDERS WHICH REFERENCES CUSTOMER TABLE ON CUSTOMER_ID
CREATE TABLE DW_OLIST_ORDERS_TABLE(
order_id varchar(100) primary key,
customer_id varchar(100),
order_status varchar (100),
order_purchase_timestamp datetime,
order_approved_at datetime, 
order_delivered_carrier_date datetime,
order_delivered_customer_date datetime,
order_estimated_delivery_date datetime
constraint fk_orders_table foreign key (customer_id) references DW_OLIST_CUSTOMER_TABLE (customer_id)
on delete set null on update cascade)

--CREATING TABLE FOR ORDER_REVIEWS WHICH REFERENCES ORDERS_TABLE ON order_id
CREATE TABLE DW_OLIST_ORDER_REVIEWS_TABLE(
review_id varchar(100),
order_id varchar(100),
review_score bigint,
review_comment_title varchar(100),
review_comment_message varchar(100),
review_creation_date datetime,
review_answer_timestamp datetime
constraint fk_reviews_table foreign key (order_id) references DW_OLIST_ORDERS_TABLE (order_id) 
on delete set null on update cascade)

--CREATING TABLE FOR ORDER_PAYMENTS WHICH REFERENCES ORDERS_TABLE ON order_id
CREATE TABLE DW_OLIST_ORDER_PAYMENT_TABLE(
[order_id] varchar(100),
[payment_sequential] int, 
[payment_type] varchar(100),
[payment_installments] int,
[payment_value] float
constraint fk_order_payment_table foreign key ([order_id]) references DW_OLIST_ORDERS_TABLE ([order_id])
ON delete set null on update cascade)

--CREATING TABLE FOR ORDER_ITEMS TABLE WHICH HAS 3 CONSTRAINTS
--This is th fact table
--1. order_id references order_id on ORDERS_TABLE
--2. product_id references product_id on PRODUCT_TABLE
--3. sellers_id references sellers_id on SELLERS_TABLE
--4. I also created an autoincrement primary key which is order_items_unique_id
CREATE TABLE DW_OLIST_ORDER_ITEMS_TABLE(
order_items_unique_id int identity primary key,
[order_id] varchar(100),
[order_item_id] int,
[product_id] VARCHAR(100), 
[sellers_id] VARCHAR(100), 
[shipping_limit_date] datetime,
[price] float,
[freight_value] float
constraint fk_order_items_for_order_id foreign key ([order_id]) references DW_OLIST_ORDERS_TABLE ([order_id])
ON delete set null on update cascade,
constraint fk_order_items_for_product_id foreign key ([product_id]) references DW_OLIST_PRODUCT_TABLE ([product_id])
ON delete set null on update cascade,
constraint fk_order_items_for_sellers_id foreign key ([sellers_id]) references DW_OLIST_SELLERS_TABLE ([sellers_id])
ON delete set null on update cascade)




























DROP TABLE DW_OLIST_PRODUCT_CATEGORY

DROP TABLE DW_OLIST_PRODUCT_TABLE


select *
from [dbo].[staging_olist_product_category]
where product_category_name is null


select *
from [dbo].[staging_olist_products_table]
where product_category_name is null


select pt.[product_category_name], ct.[product_category_name]
from [dbo].[staging_olist_products_table] pt
full join [dbo].[staging_olist_product_category] ct
on pt.product_category_name = ct.product_category_name
where pt.product_category_name = ct.product_category_name

select *
from [dbo].[staging_olist_products_table]

SELECT *
FROM [dbo].[staging_olist_product_category]
inner join 


