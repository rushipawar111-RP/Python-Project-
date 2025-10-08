use project;

/*List all customers from Maharashtra.*/

select customer_name, state
from customers
where state = "Maharashtra";

/*Find all orders placed in 2024*/

select * from orders
where year(order_date) = 2024;

/* Get all products in the “Electronics” category with price > 1000.*/

select product_name, price
from products
where category = "Electronics" and Price > 1000;

/*Count how many customers belong to each segment.*/

select segment, count(customer_name) as total_customer
from customers
group by segment;

/*Show the total number of orders placed by each customer.*/

select c.customer_name, count(o.order_id) as total_orders
from customers c
join orders o on c.customer_id = o.customer_id
group by c.customer_name;

/*Find the total revenue (sum of total_amount) for each state.*/

SELECT c.state, SUM(o.total_amount) AS total_revenue
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
GROUP BY c.state;

/* List top 5 products by total quantity sold.*/

SELECT p.product_name, SUM(oi.quantity) AS total_sold
FROM Order_Items oi
JOIN Products p ON oi.product_id = p.product_id
GROUP BY p.product_name
ORDER BY total_sold DESC
LIMIT 5;

/*Find customers who have never placed an order.*/

SELECT c.customer_name
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

/*Calculate profit per product (price - cost*/

select product_name, round((price - cost),2) as profit_per_unit
from products;

/*Show total sales (after discount) for each order.*/

select order_id, round(sum((unit_price * quantity) * discount),2) as total_sales
from order_items
group by order_id;

/*Find top 3 customers by total purchase amount.*/

select c.customer_name, sum(o.total_amount) as total_purchase
from orders o
join Customers.c ON c.customer_id = o.customer_id
group by c.customer_name
order by sum(o.total_amount) DESC
limit 3;

/*Find the most popular product category by revenue*/

SELECT p.category, SUM(oi.quantity * oi.unit_price) AS total_revenue
FROM Order_Items oi
JOIN Products p ON oi.product_id = p.product_id
GROUP BY p.category
ORDER BY total_revenue DESC
LIMIT 1;

/*Show monthly sales trend for 2024*/

SELECT 
    DATE_FORMAT(order_date, "%Y-%m") AS month_year,
    SUM(total_amount) AS total_amount
FROM orders
WHERE YEAR(order_date) = 2024
GROUP BY DATE_FORMAT(order_date, "%Y-%m")
ORDER BY DATE_FORMAT(order_date, "%Y-%m");

/*Find customers who ordered more than 5 different products.*/

select c.customer_name, count(distinct oi.product_id) as unique_products
from customers c
JOIN Orders o ON c.customer_id = o.customer_id
JOIN Order_Items oi ON o.order_id = oi.order_id
GROUP BY c.customer_name
HAVING COUNT(DISTINCT oi.product_id) > 5;

/*Rank customers by total revenue using RANK() window function.*/

SELECT 
    c.customer_name,
    SUM(o.total_amount) AS total_revenue,
    RANK() OVER (ORDER BY SUM(o.total_amount) DESC) AS revenue_rank
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name;

/*Find each customer’s most recent order date.*/

SELECT 
    c.customer_name,
    MAX(o.order_date) AS last_order_date
FROM Customers c
JOIN Orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_name;

/*Calculate repeat purchase rate (customers with >1 order).*/

SELECT 
    COUNT(DISTINCT CASE WHEN order_count > 1 THEN customer_id END) * 100.0 /
    COUNT(DISTINCT customer_id) AS repeat_purchase_rate
FROM (
    SELECT customer_id, COUNT(order_id) AS order_count
    FROM Orders
    GROUP BY customer_id
) AS c;

/*Identify top suppliers by profit contribution.*/

SELECT 
    p.supplier_id,
    SUM((oi.unit_price * oi.quantity) - oi.discount - (p.cost * oi.quantity)) AS profit
FROM Order_Item oi
JOIN Products p ON oi.product_id = p.product_id
GROUP BY p.supplier_id
ORDER BY profit DESC;











