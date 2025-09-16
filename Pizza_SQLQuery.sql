CREATE DATABASE pizzadb

USE pizzadb

--Basic:
---Pizzahut sales project---

--Q1--Retrieve the total number of orders placed.
select count(order_id) as Total_orders 
from orders 

--Q2--Calculate the total revenue generated from pizza sales.(R=P*Q)
select round(sum(order_details.quantity * pizzas.price),2) as Total_revenue
from order_details
join pizzas 
on order_details.pizza_id = pizzas.pizza_id

--Q3--Identify the highest-priced pizza.
select top 1
pizza_types.name, pizzas.price 
from pizza_types 
join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
order by pizzas.price desc

--Q4--Identify the most common pizza size ordered.
select top 1
pizzas.size, count(order_details.order_id) as order_count
from pizzas 
join order_details 
on pizzas.pizza_id = order_details.pizza_id
group by pizzas.size
order by order_count desc

--Q5--List the top 5 most ordered pizza types along with their quantities.
select top 5
pizzas.pizza_type_id, sum(order_details.quantity) as total_quantities
from order_details 
join pizzas
on order_details.pizza_id = pizzas.pizza_id
group by pizzas.pizza_type_id
order by total_quantities desc

--Intermediate:
--Q6--Join the necessary tables to find the total quantity of each pizza category ordered.
select pizza_types.category, sum(order_details.quantity) as Total_quantities
from order_details 
join pizzas
on order_details.pizza_id = pizzas.pizza_id
join pizza_types 
on pizzas.pizza_type_id = pizza_types.pizza_type_id 
group by pizza_types.category
order by Total_quantities

--Q7--Determine the distribution of orders by hour of the day.
select datepart(hour, time) as order_timing, count(order_id) as order_count 
from orders
group by datepart(hour, time)
order by order_timing

--Q8--Join relevant tables to find the category-wise distribution of pizzas.
select pizza_types.category, count(pizzas.pizza_id)
from pizza_types 
join pizzas 
on pizza_types.pizza_type_id = pizzas.pizza_type_id
group by pizza_types.category

--Q9--Group the orders by date and calculate the average number of pizzas ordered per day.
select avg(quantities) as avg_quantities_per_day
from
(select orders.date, sum(order_details.quantity) as quantities
from orders 
join order_details 
on orders.order_id = order_details.order_id 
group by orders.date) as quantities

--Q10--Determine the top 3 most ordered pizza types based on revenue.
select top 3
pizza_types.name, sum(order_details.quantity*pizzas.price) as revenue
from order_details 
join pizzas
on order_details.pizza_id = pizzas.pizza_id
join pizza_types
on pizzas.pizza_type_id = pizza_types.pizza_type_id
group by pizza_types.name
order by revenue desc

--Advanced:
--Q11--Calculate the percentage contribution of each pizza type to total revenue.
select pizza_types.name, 
round(sum(order_details.quantity*pizzas.price) * 100 / 
(select round(sum(pizzas.price
* order_details.quantity),2) as total_revenue	 
from pizzas join order_details
on pizzas.pizza_id = order_details.pizza_id),2) as
percentage_contribution
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details 
on pizzas.pizza_id = order_details.pizza_id
group by pizza_types.name
order by percentage_contribution desc

--Q12--Analyze the cumulative revenue generated over time.
select rev_date.date, sum(revenue) over(order by date) as cum_revenue
from 
(select orders.date, sum(order_details.quantity * pizzas.price) as revenue
from orders 
join order_details 
on orders.order_id = order_details.order_id
join pizzas 
on pizzas.pizza_id = order_details.pizza_id
group by orders.date) as rev_date

--Q13--Determine the top 3 most ordered pizza types based on revenue for each pizza category.
	select name, revenue 
	from
	(select category,name, revenue, 
	rank() over(partition by category order by revenue) as rn 
	from(
	select pizza_types.category, pizza_types.name, 
	sum(order_details.quantity * pizzas.price) as revenue
	from pizza_types join pizzas 
	on pizza_types.pizza_type_id = pizzas.pizza_type_id
	join order_details
	on order_details.pizza_id = pizzas.pizza_id
	group by pizza_types.category, pizza_types.name) as a)b
	where rn <=3





