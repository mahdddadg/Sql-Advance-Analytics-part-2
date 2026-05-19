
/*
============================================================================================================

Product REPORT 

===========================================================================================================

Purpose :

This report consolidates key product metrics and behaviors .


Highlights : 

1- Gathers essentioal fields such as product name , metrics and behaviors .


2- segments products by revenue to identify , High-performance , Mid_range or Low-performance  .


3- Aggregates product-levle metrics :

- totall orders
- totall sales
- qunatity sold
- totall customers( unique ) 
- liftime (lifespan )


4- Calculates valuable KPIs :
- recency ( months since last sale ) 
- avrage order value  (AOR ) 
- avrage monthly REVENUE  


*** At the end i will make a view from my report so , other analyst could use my query in
order to make data visualization or report or  etc ...

==============================================================================================================*/




----------------------------------------------------------------------------------------------------------------


--- 1 ) base query : 

with cte_base_query as (

select

f.order_number ,
f.order_date ,
f.customer_key ,
f.sales_amount ,
f.quality ,
p.product_key ,
p.product_name ,
p.category ,
p.subcategory ,
p.cost

from gold.facts_sales as f
left join gold.dim_products as p
on f.product_key = p.product_key 

where order_date is not null 

)


, cte_aggregation_products as (

select

product_key ,
product_name ,
category ,
subcategory ,
cost ,



count(distinct order_number ) as totall_orders ,


datediff(month , min(order_date) , max(order_date) ) as lifespan ,
max(order_date) as lastest_order ,


count(distinct customer_key) as totall_customer ,


sum(sales_amount) as totall_sales ,


sum(quality) as totall_quantity  ,

round ( avg (cast(sales_amount as float )   /   nullif (quality, 0 )), 1 )   as avg_selling_price



from cte_base_query

group by product_key ,
product_name ,
category ,
subcategory ,
cost 

)





select


product_key ,
product_name ,
category ,
subcategory ,
cost ,



totall_orders ,
lifespan ,

lastest_order ,
datediff (month , lastest_order , getdate() ) as recency_in_month ,

case 
when totall_sales > 50000 then 'High-performance'
when totall_sales >= 10000 then 'Mid-Range'
else 'Low-performace'
end as product_segment , 

totall_customer ,
totall_sales ,
totall_quantity  ,
avg_selling_price ,

--AOR :

CASE WHEN totall_sales = 0 THEN 0
ELSE totall_sales / totall_orders 
end as avg_order_revenue , 


CASE WHEN lifespan = 0 THEN totall_sales
ELSE totall_sales / lifespan
end as avg_monthly_revenue 

from cte_aggregation_products