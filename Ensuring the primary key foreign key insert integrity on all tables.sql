


--Before we start creating tables for our data warehouse, we need to ensure that the 
--tables which have a foreign key, primary key relationship are properly related.

--We want to also make sure that no values will be ommited when inserting records
--into the data warehouse tables. 

--The syntax below helps us to find out if there are any descrepancies between the parent
--table and the child table. If the parent table (primary key column) has less values 
--than the child table (foreign key column), then you will not be able to insert the 
--total number of values into the data warehouse, this eventually affects the total
--number of records you will have in the data warehouse,for example instead of inserting 
--1000 values, you might only be able to insert 900 values, and this 
--will eventually affect your analysis and business decisions.


select count(*)
from [dbo].[staging_olist_products_table]
select count(*)
from [dbo].[staging_olist_products_table] sopt
inner join [dbo].[staging_olist_product_category] soct
on sopt.[product_category_name] = soct.[product_category_name]

--For these tables above the count isnt the same 
--after applying the join syntax with the parent table
--hereby there is an insert integrity issue 
--and we must fix this 

--Lets compare distinct values between both tables
--for the column relating the parent table
--to the chld table.
select distinct([product_category_name])
from [dbo].[staging_olist_products_table]
where [product_category_name] not in 
(select [product_category_name]
from [dbo].[staging_olist_product_category])


select [product_category_name]
from [dbo].[staging_olist_products_table]
where [product_category_name] not in 
(select [product_category_name]
from [dbo].[staging_olist_product_category])

--Now we know that there are some values present in the child table foreign
--key column which are not present in the parent table primary key
--column, we will fix that by making sure that both have the same 
--number of values because a primary key column cannot accept
--a foreign value which it does not have.

--I also found out that the foreign key column of the
--child table has a null value, and nulls are not allowed in 
--primary key columns using the syntax below.

select distinct([product_category_name])
from [dbo].[staging_olist_products_table]
where [product_category_name] is null

select distinct([product_category_name])
from [dbo].[staging_olist_product_category]
where [product_category_name] is null

--Now lets fix everything


--With the syntax below, I found the number of named
--columns which are present in the child table but are not 
--present in the parent table.

select count(distinct([product_category_name]))
from [dbo].[staging_olist_products_table]
where [product_category_name] not in 
(select [product_category_name]
from [dbo].[staging_olist_product_category])


--Inserting records not present in product_category column 
--of product_category_table (parent table) but present in 
--product_category column of product_table (child table)
--into product_category_table (parent table)
insert into [dbo].[staging_olist_product_category]([product_category_name])
select distinct(sopt.[product_category_name])
from [dbo].[staging_olist_products_table] sopt
left join [dbo].[staging_olist_product_category] sopc 
on  sopt.[product_category_name] = sopc.[product_category_name]
where sopt.[product_category_name] not in 
(select [product_category_name]
from [dbo].[staging_olist_product_category])

--Now lets insert a null record into the 
--product_category_table (parent table) as well
insert into [dbo].[staging_olist_product_category]
select distinct([product_category_name])
from [dbo].[staging_olist_products_table]
where [product_category_name] is null

--Now we have same number of records in the parent table 
--primary key column and the child table foreign key column 


--But as we all know, null values are not allowed in primary 
--key columns, hereby we need to convert the null to a named 
--value and that value is going to be called 'Unknown category'

select *
from [dbo].[staging_olist_products_table]
where [product_category_name] is null

--Thats done here
update [dbo].[staging_olist_products_table]
set [product_category_name] = 'Unknown Category'
where [product_category_name] is null



--Now let check for insert integrity
select count(*)
from [dbo].[staging_olist_products_table]
select count(*)
from [dbo].[staging_olist_products_table] sopt
inner join [dbo].[staging_olist_product_category] soct
on sopt.[product_category_name] = soct.[product_category_name]

--The count gives the same exact number of values 
--when you count only for the single table child table as 
--well as the inner join where you count values for both
--tables.
--Hereby we have completed
--our insert integrity for these two connected tables


--Next lets do this for the remianing CONNECTED tables

--COUNT FOR CHILD TABLE
select count(*)
from [dbo].[staging_olist_orders_table]

--COUNT FOR CHILD TABLE INNER JOIN PARENT TABLE
select count(*)
from [dbo].[staging_olist_orders_table] soot
inner join [dbo].[staging_olist_Customer_table] soct
on soot.[customer_id] = soct.[customer_id]
--NO DESCREPANCY FOUND
--INSERT INTEGRITY CONFIRMED FOR ORDERS TABLE 
--AND CUSTOMER TABLE.

--COUNT FOR CHILD TABLE
select count(*)
from [dbo].[staging_olist_order_payment_table]

--COUNT FOR CHILD TABLE INNER JOIN PARENT TABLE
select count(*)
from [dbo].[staging_olist_order_payment_table] soopt
INNER join [dbo].[staging_olist_orders_table] soot
on soopt.[order_id] = soot.[order_id]
--NO DESCREPANCY FOUND
--INSERT INTEGRITY CONFIRMED FOR THE ORDER PAYMENT TABLE

--COUNT FOR CHILD TABLE
select count(*)
from [dbo].[staging_olist_order_reviews_table]

--COUNT FOR CHILD TABLE INNER JOIN PARENT TABLE
select count(*)
from [dbo].[staging_olist_order_reviews_table] soort
inner join [dbo].[staging_olist_orders_table] soot
on soort.[order_id]= soot.[order_id]
--NO DESCREPANCY FOUND
--INSERT INTEGRITY CONFIRMED FOR THE ORDER REVIEWS TABLE

--COUNT FOR CHILD TABLE 
select count(*)
from [dbo].[staging_olist_order_items_table] 

--COUNT FOR CHILD TABLE INNER JOIN PARENT TABLE
select count(*)
from [dbo].[staging_olist_order_items_table] sooit
inner join [dbo].[staging_olist_sellers_table] sost
on sooit.[seller_id] = sost.[seller_id]
inner join [dbo].[staging_olist_products_table] sopt
on sooit.[product_id] = sopt.[product_id]
inner join [dbo].[staging_olist_orders_table] soot
on sooit.[order_id] = soot.[order_id]
--NO DESCREPANCY FOUND
--INSERT INTEGRITY CONFIRMED FOR THE FACT ORDER ITEMS TABLE


