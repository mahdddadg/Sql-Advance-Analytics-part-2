/*

segmenting products into cost ranges and
count how many products fall into each segment  :

*/



with cte_product_segment as (
select

product_key,
product_name, 
cost, 

case 
when cost < 100 then 'Below 100'
when cost between 100 and 500 then '100 to 500'
when cost between 500 and 1000 then '500 to 1000'
else 'Above 1000'
end as cost_range
from gold.dim_products

)


select

cost_range ,
count (product_key ) as totall_product


from cte_product_segment
group by cost_range
order by totall_product desc

/*
=====================================================================================================
=====================================================================================================
*/


/*  

now i want to group the customers into 3 segments , baseed on thier spending :
1) 'VIP' at least 12 months of history + spending more than 5.000 .
2) 'Relular' at least 12 month of history and spending 5.000 or less.
3) 'New' liftime of less than 12 months .
and totall number of each group as well . 
*/



with cte_customer_spending as(


select 

c.customer_key ,
sum (f.sales_amount ) totall_spending,
max(f.order_date ) as last_order ,
min(f.order_date ) as first_order ,
datediff( month ,min(f.order_date ), max(f.order_date )) as liftime 

from gold.facts_sales as f
left join gold.dim_customers as c
on f.customer_key = c.customer_key
group by c.customer_key

) 


, cte_customer_segment as (

select

totall_spending ,
liftime ,
case 
when liftime > 12 and totall_spending > 5000 then 'VIP'
when liftime >= 12 and totall_spending <= 5000 then 'Regular'
else  'New'
end as customer_segment

from cte_customer_spending 

)


select

customer_segment , 
count (customer_segment ) as segmet_count

from cte_customer_segment

group by customer_segment 