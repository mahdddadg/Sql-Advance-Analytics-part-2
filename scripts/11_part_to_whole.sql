-- category that contributae the most overall sale : 



with cte_totall_category_sales as (

select

d.category ,
sum (f.sales_amount ) as totall_sales_by_category

from gold.facts_sales as f
left join gold.dim_products as d
on f.product_key = d.product_key

group by d.category

)


select
category ,
totall_sales_by_category ,
sum ( totall_sales_by_category ) over()  as totall_overall_sale ,

concat (round ( cast (totall_sales_by_category as float ) 
/ sum ( totall_sales_by_category ) over() *100.0 , 2) , '%') as tottall_percentage 


from cte_totall_category_sales
order by totall_sales_by_category desc