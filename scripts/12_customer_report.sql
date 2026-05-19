
/*
============================================================================================================

CUSTOMER REPORT 

===========================================================================================================

Purpose :

this report consolidates key customer metrics and behaviors .


Highlights : 

1- Gathers essentioal fields such as ames , ages , and transactions details .


2- segments customers into categories ( VIP , Regular , New ) and age groups .


3- Aggregates customer-levle metrics :
- totall orders
- totall sales
- totall quantity purchased
- totall products 
- liftime (lifespan )


4- Calculates valuable KPIs :
- recency ( months since order ) 
- avrage orer value 
- avrage monthly spend 


*** At the end i will make a view from my report so , other analyst could use my query in
order to make data visualization or report or  etc ...

==============================================================================================================*/

create view gold.report_customers as 




------------------------------------------------------------

-- 1) Base Query : Reteriving core columns from tables : 

---------------------------------------------------------------



with cte_base_query as (

select

f.order_number ,
f.product_key ,
f.order_date ,
f.sales_amount ,
f.quality ,
c.customer_key ,
c.customer_number , 
concat(c.first_name ,' ',c.last_name ) as customer_name ,
datediff(year , c.birthdate , getdate()) as age 


from gold.facts_sales as f
left join gold.dim_customers as c
on c.customer_key = f.customer_key
where order_date is not null

)

/*
========================================================================================================

2)  customer aggregation : summerize key metrics at customer levle
========================================================================================================


*/

, cte_customer_aggregation as (

select

customer_key ,
customer_number , 
customer_name ,
age ,

count( distinct order_number ) as totall_order ,
sum(sales_amount) as totall_sales ,
sum(quality ) as totall_quantity ,
count( distinct product_key ) as totall_products ,
max(order_date) as last_order ,
datediff( month ,min(order_date), max(order_date)) as lifespan

from cte_base_query 

group by customer_key ,customer_number , customer_name , age 

)


select


customer_key ,
customer_number , 
customer_name ,
age ,

case
when age < 20 then 'Under 20 '
when age between 20 and 29 then '20 to 29 '
when age between 30 and 39 then '30 to 39 '
when age between 40 and 49 then '40 to 49 '
else '50 and above'
end as age_group ,

case 
when lifespan >= 12 and totall_sales > 5000 then 'VIP'
when lifespan >= 12 and totall_sales < 5000 then 'Regular'
else 'New'
end as customer_segment ,
last_order ,
datediff(day , last_order ,getdate() ) as recency ,

totall_order ,
totall_sales ,
totall_quantity ,
totall_products ,
lifespan ,

-- avrage order value (AVO):
case 
when totall_sales  = 0 then 0 
 else totall_sales  / totall_order
 end as AVO ,

 -- avrage monthly spend : 

 case 
 when lifespan = 0 then totall_sales
 else totall_sales / lifespan
 end as avrage_monthly_spend

from cte_customer_aggregation
