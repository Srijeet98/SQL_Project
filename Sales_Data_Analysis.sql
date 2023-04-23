select * from project.sales_data;
use project;

-- Find the total sales amount in month of april of 2003.--
select year_id,month_id,round(sum(sales),2) as sales_amt from sales_data where month_id=4 and year_id=2003;

-- Which month had the highest sales? --
with t1 as(
select month_id,sum(sales) as highest_sales from sales_data group by month_id),
t2 as
(select month_id,highest_sales,dense_rank()over(order by highest_sales desc) as rnk from t1)
select month_id from t2 where rnk=1;


-- Which city sold the most products? --
with t1 as(
select city,sum(quantityordered) as highest_orders from sales_data group by city),
t2 as(
select city,highest_orders,dense_rank()over(order by highest_orders desc) as rnk from t1)
select city from t2 where rnk=1;

-- What is the most popular order deal size? --
with t1 as(
select dealsize,count(*) as count,dense_rank()over(order by count(*) desc) as rnk from sales_data group by dealsize)
select dealsize,count from t1 where rnk=1;

-- Which month of the year has the highest orders? --
with t1 as
(select month_id,year_id,sum(quantityordered) as quantity_total,dense_rank()over(partition by year_id order by sum(quantityordered) desc) as rnk 
from sales_data group by month_id,year_id)
select month_id,year_id,quantity_total from t1 where rnk=1;

-- Find the delivery status details and number of shipped and failed deliveries. --
select status as delivery_status,count(*) as count from sales_data group by status order by count desc;

-- Which customer ordered the maximum number of products. --
with t1 as(
select customername,sum(quantityordered) as max_products,dense_rank()over(order by sum(quantityordered) desc) as rnk from sales_data group by customername order by max_products desc)
select customername from t1 where rnk=1;

-- Find the customername and quantity ordered who lives in New York city. --
select customername,sum(quantityordered) as orders_quantity,city from sales_data where city='NYC' group by customername order by orders_quantity desc;

-- Find the product code and quantities ordered which are best selling(top 5) --
with t1 as(
select productcode,sum(quantityordered) as ordered_count,dense_rank()over(order by sum(quantityordered) desc) as rnk from sales_data group by productcode)
select productcode,ordered_count from t1 where rnk in(1,2,3,4,5);

-- Find the average quantity ordered country and city wise. --
select country,city,avg(quantityordered) as avg_quantity from sales_data group by country,city order by avg_quantity desc;

-- Which customer ordered the max and min amount of sales? --
select customername,sales as sales_amt_$ from sales_data where sales=(select max(sales) from sales_data)
union all
select customername,sales as sales_amt_$ from sales_data where sales=(select min(sales) from sales_data);
