--  What is Total Revenue Genrated by male vs. female customers
select* from my_table
Select gender, sum(purchase_amount)
from my_table
Group By gender
--Which customers used discount but still spent more than average purchase amount 
Select customer_id, purchase_amount, discount_applied
from my_table
Where discount_applied = 'Yes' and purchase_amount > (select avg(purchase_amount) from my_table)

--Which are top 5 products with the highest average review rating 
Select item_purchased, Round(avg(review_rating::numeric),2) as "Average product Rating"
from my_table
Group By item_purchased
Order By avg(review_rating) desc

--Compare the average purchase amounts beetwen standart and express shipping
Select shipping_type, Round(avg(purchase_amount),2)
from my_table
where shipping_type in ('Standard','Express')
group by shipping_type
--Do subscribed customers spend more ? Compare average spend and total_revenue beetwen
--subscribers and non-subscribers

Select subscription_status,
Count(customer_id) as total_customers,
Round(avg(purchase_amount),2)  avg_spend,
sum(purchase_amount) as total_revenue 
from my_table
group by  subscription_status
--Which 5 products have the highest percentage of purchases with discount applied
Select item_purchased,
100 *Sum(Case when discount_applied = 'Yes' Then 1 Else 0 End)/count(*)  as discount_rate
from my_table
group by item_purchased
order by discount_rate desc
limit 5
--Segment customers into new, returing, loyal based on their total number of
--previous purchases and show the count of each segment 

with customer_type as(
Select customer_id, previous_purchases,
Case When previous_purchases = 1 Then  'New'
When previous_purchases between 2 and 10 Then 'Returning'
Else 'Loyal'
End As customer_segment
from my_table
)
Select customer_segment, count(*) as "Number of Customers"
from customer_type
group by customer_segment
--What are the 3 top most purchased products within each category 

with item_counts as (
Select category,item_purchased,
Count(customer_id) as total_orders,
ROW_NUMBER() over(
partition by category order by Count(customer_id) desc) as item_rank
from my_table
group by  category,item_purchased)
select item_rank,category,item_purchased,total_orders
from item_counts
where item_rank<= 3

--Are the customers who are repeat buyers (more than 5 previous purchases)
--also likely to subscribe

SELECT
 subscription_status,
 Count(customer_id) as repeat_buyers
 from my_table
 where previous_purchases >=5
Group by  subscription_status
--What is revenue contribution of each age group
Select age_group,  sum(purchase_amount) as total_revenue
from my_table
group by age_group
order by total_revenue desc