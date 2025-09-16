# 🍕 Pizza-Sales-SQL-Project

This project explores a fictional **Pizza Hut sales dataset** using Microsoft SQL Server.  
It answers business questions about revenue, customer ordering patterns, and product performance.

---

## 📂 Project Structure
Pizza-Sales-SQL-Project/
│
├─ Pizza_SQLQuery.sql # All SQL queries (Q1–Q13)
├─ analysis_report.md # Question-wise explanations and insights
└─ README.md # This overview

---

## 🛠️ Technologies
- SQL Server (T-SQL)
- Window functions
- Aggregation
- Subqueries
- Joins

---

## 🗃️ Dataset

Tables used:
- **orders** – order_id, date, time  
- **order_details** – order_id, pizza_id, quantity  
- **pizzas** – pizza_id, pizza_type_id, size, price  
- **pizza_types** – pizza_type_id, name, category  

---

## 🧮 Key Analyses
- Total revenue and total orders  
- Top-selling pizzas by quantity & revenue  
- Category-wise revenue contributions  
- Hourly ordering patterns  
- Cumulative revenue over time  

---

## ▶️ How to Run
1. Create and use the database:
   ```sql
   CREATE DATABASE pizzadb;
   USE pizzadb;
2.Load the dataset tables.

3.Execute queries from Pizza_SQLQuery.sql in SQL Server Management Studio.

## 📊 Insights (Highlights)

Large pizzas generated the highest revenue.

Peak order time is evening (6–8 PM).

Classic category leads in both quantity and revenue.
