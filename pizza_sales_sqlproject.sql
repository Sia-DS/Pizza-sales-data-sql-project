CREATE DATABASE PIZZAHUT;
CREATE TABLE ORDERS 
(ORDER_ID INT NOT NULL,
ORDER_DATE DATE NOT NULL,
ORDER_TIME TIME NOT NULL,
PRIMARY KEY(ORDER_ID));
 
 USE PIZZAHUT;
 SELECT * FROM ORDER_DETAILS;
 SELECT * FROM ORDERS;
 SELECT * FROM pizza_types;
 SELECT * FROM pizzas;

 --Q1 Retrieve the total number of orders placed.(B)
 SELECT COUNT(order_id) AS TOTAL_ORDES FROM ORDERS;

 -- Q2 Calculate the total revenue generated from pizza sales.(B)
 SELECT
      ROUND(sum(order_details.quantity * pizzas.price),2)
		 AS TOTAL_SALES
 FROM order_details 
		JOIN pizzas
 ON pizzas.PIZZA_id = order_details.pizza_id;


 -- Q3 Identify the highest-priced pizza.(B)

 SELECT TOP 1
 pizza_types.NAME , pizzas.price
 FROM PIZZA_TYPES JOIN PIZZAS 
 ON PIZZA_TYPES.pizza_type_id = pizzas.pizza_type_id
 ORDER BY pizzas.price DESC ;

 -- Q4 Identify the most common pizza size ordered.(B)
 
 select pizzas.size, count(order_details.order_details_id) as order_count
 from pizzas join order_details
 on pizzas.pizza_id = order_details.pizza_id
 group by pizzas.size order by order_count desc;

 -- Q4 Identify the most common pizza size ordered.(B)

 select pizzas.size, count(order_details.order_details_id) as order_count
 from pizzas join order_details
 on pizzas.pizza_id = order_details.pizza_id
 group by pizzas.size order by order_count desc;

 -- Q5 List the top 5 most ordered pizza types along with their quantities.(B)

 select top 5 pizza_types.name,
 sum(order_details.quantity) as quantity
 from pizza_types join pizzas 
 on pizza_types.pizza_type_id = pizzas.pizza_type_id
 join order_details
 on order_details.pizza_id = pizzas.pizza_id
 group by pizza_types.name order by quantity desc;


 -- Q6 Join the necessary tables to find the total quantity of each pizza category ordered.(I)

 select pizza_types.category,
 sum(order_details.quantity) as quantity
 from pizza_types join pizzas
 on pizza_types.pizza_type_id = pizzas.pizza_type_id
 join order_details
 on order_details.pizza_id = pizzas.pizza_id
 group by pizza_types.category order by quantity desc;


-- Q7 Determine the distribution of orders by hour of the day.(I)

SELECT DATEPART(HOUR, time) AS order_hour, COUNT(order_id) AS order_count
FROM orders
GROUP BY DATEPART(HOUR, time)
ORDER BY order_hour;

-- Q8 Join relevant tables to find the category-wise distribution of pizzas.(I)
select category, count(name) from pizza_types
group by category;

-- Q9 Group the orders by date and calculate the average number of pizzas ordered per day.(I)

select round(avg (quantity),0) from
(select orders.date,sum(order_details.quantity) as quantity
from orders join order_details
on orders.order_id = order_details.order_id
group by orders.date) as order_quantity;

-- Q10 Determine the top 3 most ordered pizza types based on revenue.(I)

select top 3 pizza_types.name,
sum(order_details.quantity * pizzas.price )as revenue
from pizza_types join pizzas
on pizzas.pizza_type_id = pizza_types.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.name order by revenue desc;

-- Q11 Calculate the percentage contribution of each pizza type to total revenue.(A)

select pizza_types.category,
round(sum(order_details.quantity * pizzas.price )/ (select round (sum ( order_details.quantity * pizzas.price),2) as total_sales
from order_details join pizzas
on pizzas.pizza_id = order_details.pizza_id)*100,2) as revenue
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id 
group by pizza_types.category order by revenue desc;

-- Q12 Analyze the cumulative revenue generated over time.(I)

select date, sum(revenue) over (order by order_date) as cum_revenue 
from
(select orders.date,
sum(order_details.quantity*pizzas.price) as revenue
from order_details join pizzas
on order_details.pizza_id = pizzas.pizza_id
join orders 
on orders.order_id = order_details.order_id
group by orders.date) as sales;


SELECT 
    o.[date],
    SUM(od.quantity * p.price) AS revenue
FROM 
    order_details od
JOIN pizzas p ON od.pizza_id = p.pizza_id
JOIN orders o ON od.order_id = o.order_id
GROUP BY o.[date];


-- Q13 Determine the top 3 most ordered pizza types based on revenue for each pizza category.(A)
 
 select name, revenue from
 (select category, name, revenue, rank() over (partition by category order by revenue desc) as rn from
 (select pizza_types.category, pizza_types.name,
 sum((order_details.quantity)*pizzas.price) as revenue 
 from pizza_types join pizzas
 on pizza_types.pizza_type_id =  pizzas.pizza_type_id
 join order_details
 on order_details.pizza_id = pizzas.pizza_id
 group by pizza_types.category, pizza_types.name) as a) as b
 where rn<=3;

