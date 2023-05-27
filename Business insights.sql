
--TOP 10 PRODUCTS IN TERMS OF SALES AND THEIR RESPECTIVE CATEGORIES
SELECT TOP (10) OIT.[product_id], ROUND(SUM(OIT.[price]),2) as total_sales, 
OPC.[product_category_name], COUNT(OIT.[order_id]),
ROUND(SUM(OOPT.[payment_value]),2) as total_orders
FROM [dbo].[DW_OLIST_ORDER_ITEMS_TABLE] OIT
inner join [dbo].[DW_OLIST_ORDERS_TABLE] OT
ON OIT.[order_id] = OT.[order_id]
INNER JOIN [dbo].[DW_OLIST_ORDER_PAYMENT_TABLE] OOPT
ON OT.[order_id] = OOPT.[order_id]
INNER JOIN [dbo].[DW_OLIST_PRODUCT_TABLE] OPT
ON OIT.[product_id] = OPT.[product_id]
INNER JOIN [dbo].[DW_OLIST_PRODUCT_CATEGORY] OPC
ON OPT.[product_category_name] = OPC.[product_category_name]
WHERE [order_status] = 'delivered'
GROUP BY OPC.[product_category_name],OIT.[product_id], OIT.[price]
ORDER BY SUM(OIT.[price]) DESC


--Top selling product categories
select OPC.[product_category_name],SUM(OIT.[price]), SUM(OOPT.[payment_value])
FROM [dbo].[DW_OLIST_ORDER_ITEMS_TABLE] OIT
INNER JOIN [dbo].[DW_OLIST_ORDERS_TABLE] OT
ON OT.[order_id] = OIT.[order_id]
INNER JOIN [dbo].[DW_OLIST_PRODUCT_TABLE] OPT
ON OIT.[product_id] = OPT.[product_id]
INNER JOIN [dbo].[DW_OLIST_PRODUCT_CATEGORY] OPC
ON OPT.[product_category_name] = OPC.[product_category_name]
INNER JOIN [dbo].[DW_OLIST_ORDER_PAYMENT_TABLE] OOPT
ON OOPT.[order_id] = OT.[order_id]
GROUP BY OPC.[product_category_name]
ORDER BY SUM(OIT.[price]) DESC
