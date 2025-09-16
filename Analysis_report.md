# 📊 Pizza Sales SQL Analysis – Detailed Report

This report documents the analysis of a fictional **Pizza Hut sales dataset** using SQL Server.  
It includes a **summary of key findings** and a **question-by-question breakdown** (Q1–Q13).

---

## 🔑 Executive Summary

- **Q1** – Total number of orders placed → Shows overall transaction count.  
- **Q2** – Total revenue → Calculates total sales revenue (price × quantity).  
- **Q3** – Highest-priced pizza → Identifies premium pizza item.  
- **Q4** – Most common pizza size ordered → Finds size preference (e.g., Large).  
- **Q5** – Top 5 most ordered pizzas → Lists customer favorites by quantity.  
- **Q6** – Quantity per category → Reveals demand by category (Classic, Veggie, etc.).  
- **Q7** – Orders by hour → Highlights peak business hours.  
- **Q8** – Category-wise pizza distribution → Shows menu composition.  
- **Q9** – Average pizzas per day → Gives baseline daily demand.  
- **Q10** – Top 3 pizzas by revenue → Identifies biggest revenue drivers.  
- **Q11** – Revenue contribution % per pizza → Shows each item’s share of revenue.  
- **Q12** – Cumulative revenue over time → Tracks sales growth trajectory.  
- **Q13** – Top 3 pizzas per category by revenue → Identifies star performers within each category.  

**Overall Business Insights:**
- Large pizzas and the Classic category dominate both orders and revenue.  
- Evening hours (6–8 PM) are peak sales time.  
- A few pizza types contribute disproportionately to total revenue (Pareto effect).  
- Cumulative revenue trend suggests steady growth, useful for forecasting.  

---

## 📌 Detailed Analysis (Q1–Q13)

### Q1 – Retrieve the total number of orders placed
```sql
SELECT COUNT(order_id) AS Total_orders 
FROM orders;
Explanation: Counts all unique orders in the orders table.
Insight: Reveals the total number of customer transactions.

### Q2 – Calculate the total revenue generated from pizza sales
SELECT ROUND(SUM(order_details.quantity * pizzas.price), 2) AS Total_revenue
FROM order_details
JOIN pizzas 
    ON order_details.pizza_id = pizzas.pizza_id;
Explanation: Multiplies quantity × price for all pizzas and sums them.
Insight: Shows the company’s total sales revenue.

### Q3 – Identify the highest-priced pizza
SELECT TOP 1
    pizza_types.name, pizzas.price 
FROM pizza_types 
JOIN pizzas
    ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price DESC;
Explanation: Orders pizzas by price and picks the most expensive one.
Insight: Identifies premium pizza on the menu.

### Q4 – Identify the most common pizza size ordered
SELECT TOP 1
    pizzas.size, COUNT(order_details.order_id) AS order_count
FROM pizzas 
JOIN order_details 
    ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizzas.size
ORDER BY order_count DESC;
Explanation: Groups orders by pizza size and finds the most frequent.
Insight: Shows which size is most popular (e.g., Large).

### Q5 – List the top 5 most ordered pizza types along with their quantities
SELECT TOP 5
    pizzas.pizza_type_id, SUM(order_details.quantity) AS total_quantities
FROM order_details 
JOIN pizzas
    ON order_details.pizza_id = pizzas.pizza_id
GROUP BY pizzas.pizza_type_id
ORDER BY total_quantities DESC;
Explanation: Aggregates total quantities per pizza type.
Insight: Reveals customer favorites in terms of sales volume.

### Q6 – Find the total quantity of each pizza category ordered
SELECT pizza_types.category, SUM(order_details.quantity) AS Total_quantities
FROM order_details 
JOIN pizzas
    ON order_details.pizza_id = pizzas.pizza_id
JOIN pizza_types 
    ON pizzas.pizza_type_id = pizza_types.pizza_type_id 
GROUP BY pizza_types.category
ORDER BY Total_quantities;
Explanation: Groups by pizza category (Classic, Veggie, etc.).
Insight: Determines which category contributes most to order volume.

### Q7 – Distribution of orders by hour of the day
SELECT DATEPART(HOUR, time) AS order_timing, COUNT(order_id) AS order_count 
FROM orders
GROUP BY DATEPART(HOUR, time)
ORDER BY order_timing;
Explanation: Extracts the hour from order time and counts orders.
Insight: Highlights peak business hours (e.g., evenings).

### Q8 – Category-wise distribution of pizzas
SELECT pizza_types.category, COUNT(pizzas.pizza_id)
FROM pizza_types 
JOIN pizzas 
    ON pizza_types.pizza_type_id = pizzas.pizza_type_id
GROUP BY pizza_types.category;
Explanation: Counts pizzas in each category.
Insight: Shows menu composition across categories.

### Q9 – Average number of pizzas ordered per day
SELECT AVG(quantities) AS avg_quantities_per_day
FROM (
    SELECT orders.date, SUM(order_details.quantity) AS quantities
    FROM orders 
    JOIN order_details 
        ON orders.order_id = order_details.order_id 
    GROUP BY orders.date
) AS quantities;
Explanation: First finds pizzas sold per day, then averages across days.
Insight: Gives baseline daily demand.

### Q10 – Top 3 most ordered pizza types based on revenue
SELECT TOP 3
    pizza_types.name, SUM(order_details.quantity*pizzas.price) AS revenue
FROM order_details 
JOIN pizzas
    ON order_details.pizza_id = pizzas.pizza_id
JOIN pizza_types
    ON pizzas.pizza_type_id = pizza_types.pizza_type_id
GROUP BY pizza_types.name
ORDER BY revenue DESC;
Explanation: Calculates total revenue per pizza and ranks top 3.
Insight: Identifies best sellers in terms of money earned.

### Q11 – Percentage contribution of each pizza type to total revenue
SELECT pizza_types.name, 
       ROUND(SUM(order_details.quantity*pizzas.price) * 100 /
        (SELECT SUM(pizzas.price * order_details.quantity)
         FROM pizzas JOIN order_details
             ON pizzas.pizza_id = order_details.pizza_id), 2) AS percentage_contribution
FROM pizza_types 
JOIN pizzas
    ON pizza_types.pizza_type_id = pizzas.pizza_type_id
JOIN order_details 
    ON pizzas.pizza_id = order_details.pizza_id
GROUP BY pizza_types.name
ORDER BY percentage_contribution DESC;
Explanation: Divides each pizza’s revenue by total revenue.
Insight: Highlights which pizzas dominate revenue.

### Q12 – Cumulative revenue generated over time
SELECT rev_date.date, 
       SUM(revenue) OVER(ORDER BY date) AS cum_revenue
FROM (
    SELECT orders.date, SUM(order_details.quantity * pizzas.price) AS revenue
    FROM orders 
    JOIN order_details 
        ON orders.order_id = order_details.order_id
    JOIN pizzas 
        ON pizzas.pizza_id = order_details.pizza_id
    GROUP BY orders.date
) AS rev_date;
Explanation: Daily revenue is summed cumulatively to show growth.
Insight: Useful for tracking sales trends over time.

### Q13 – Top 3 most ordered pizza types by revenue for each category
SELECT name, revenue 
FROM (
    SELECT category, name, revenue, 
           RANK() OVER(PARTITION BY category ORDER BY revenue DESC) AS rn 
    FROM (
        SELECT pizza_types.category, pizza_types.name, 
               SUM(order_details.quantity * pizzas.price) AS revenue
        FROM pizza_types 
        JOIN pizzas 
            ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN order_details
            ON order_details.pizza_id = pizzas.pizza_id
        GROUP BY pizza_types.category, pizza_types.name
    ) AS a
) b
WHERE rn <= 3;
Explanation: Uses RANK() to get top 3 pizzas by revenue in each category.
Insight: Shows star performers within each category.



