--- calculating the total sales per month and the running total of sales over time ( cumuletice analysis ) :



select
order_date ,
totall_sales ,
sum(totall_sales ) over (partition by order_date order by order_date asc ) as runing_totall_sales 

from (


select
datetrunc(month ,order_date ) as order_date,
sum(sales_amount) as totall_sales 



from gold.facts_sales
where order_date is not null 
group by datetrunc(month ,order_date )

)t


--- calculating the total sales per year and the running total of sales over time ( cumuletice analysis ) :

select
order_date ,
totall_sales ,
sum(totall_sales ) over ( order by order_date asc ) as runing_totall_sales 

from (


select
datetrunc(year ,order_date ) as order_date,
sum(sales_amount) as totall_sales 



from gold.facts_sales
where order_date is not null 
group by datetrunc(year ,order_date )

)t

-- now let's find moving avrage of our price over month toghether with running totall: 


select
order_date ,
totall_sales ,
sum(totall_sales ) over (partition by order_date order by order_date asc ) as runing_totall_sales ,
avg(avg_sales  ) over (partition by order_date order by order_date asc ) as moving_avrage_sales  

from (


select
datetrunc(month ,order_date ) as order_date,
sum(sales_amount) as totall_sales ,
avg(sales_amount) as avg_sales 



from gold.facts_sales
where order_date is not null 
group by datetrunc(month ,order_date )

)t

-- now let's find moving avrage of our price over year toghether with running totall: 


select
order_date ,
totall_sales ,
sum(totall_sales ) over ( order by order_date asc ) as runing_totall_sales ,
avg( avg_sales  ) over ( order by order_date asc ) as moving_avrage_sales  

from (


select
datetrunc(year ,order_date ) as order_date,
sum(sales_amount) as totall_sales ,
avg(sales_amount) as avg_sales 


from gold.facts_sales
where order_date is not null 
group by datetrunc(year ,order_date )

)t