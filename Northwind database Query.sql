---Some Exploratory Data Analysis using the Northwind database.

-- 1. Customer analysis
--i Top 10 customers by total orders:
SELECT c.customer_id, c.company_name, COUNT(o.order_id) Total_Orders
FROM customers c
JOIN orders o 
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.company_name
ORDER BY Total_Orders DESC
LIMIT 10

--ii Average Order value per customer
SELECT c.customer_id, c.company_name, AVG((od.unit_price*od.quantity*(1-od.discount))) average_order_value
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN order_details od
ON o.order_id = od.order_id
GROUP BY c.customer_id, c.company_name
ORDER BY average_order_value DESC

--iii Customer distribution by Country 
SELECT country, COUNT (customer_id) customer_count
FROM customers
GROUP BY country
ORDER BY customer_count DESC


--iv List of customers who have placed more orders than the average number of orders
SELECT c.customer_id, c.company_name
FROM customers c
WHERE (SELECT COUNT (o.order_id)
	FROM orders o
	WHERE c.customer_id = o.customer_id)
		>(SELECT AVG (order_count)
		  FROM (SELECT customer_id, COUNT (order_id) order_count
				FROM orders GROUP BY customer_id) subquery);	

--2. Product Analysis
--i. Top 10 selling products
SELECT p.product_id, p.product_name, SUM (od.quantity) total_quantity_sold
FROM products p
JOIN order_details od
ON p.product_id = od.product_id
GROUP BY p.product_id, p.product_name
ORDER BY total_quantity_sold DESC
LIMIT 10

-- ii Product distribution by Country

SELECT c.country,  COUNT (od.product_id) product_count
FROM customers c
JOIN orders o
ON c.customer_id = o.customer_id
JOIN order_details od
ON o.order_id = od.order_id
JOIN products p
ON p.product_id = od.product_id
GROUP BY c.country
ORDER BY product_count DESC

--iii. Product categories by revenue

SELECT c.category_name, p.product_name, SUM ((od.unit_price*od.quantity*(1-od.discount))) total_revenue
FROM categories c
JOIN products p
ON c.category_id = p.category_id
JOIN order_details od
ON p.product_id = od.product_id
GROUP BY c.category_name, p.product_name
ORDER BY total_revenue DESC

--3. Order Analysis
--i. Orders trend analysis over time 

SELECT DATE_TRUNC('month', o.order_date) order_month, COUNT (o.order_id) order_count
FROM orders o
GROUP BY order_month
ORDER BY order_month

--ii. The average shipping period for the order

SELECT AVG (o.shipped_date - o.order_date) average_shipping_period
FROM orders o


--4. How fast is the delivery by the Shippers

SELECT s.shipper_id, s.company_name, AVG (o.shipped_date - o.order_date) average_shipping_days
FROM shippers s
JOIN orders o
ON s.shipper_id = o.ship_via
GROUP BY s.shipper_id, s.company_name
ORDER BY average_shipping_days ASC

--5. Revenues by territories
SELECT t.territory_id, t.territory_description, SUM ((od.unit_price*od.quantity*(1-od.discount))) revenue_by_territory
FROM territories t
JOIN region r ON t.region_id = r.region_id
JOIN employee_territories et ON t.territory_id = et.territory_id
JOIN employees e ON e.employee_id = et.employee_id
JOIN orders o ON o.employee_id = e.employee_id
JOIN order_details od ON od.order_id = o.order_id
GROUP BY t.territory_id, t.territory_description
ORDER BY revenue_by_territory DESC

--6. List of employee names, title, and the number of orders they have placed
SELECT e.first_name || ' ' || e.last_name employee_name, title, COUNT (o.order_id) order_count
FROM employees e
JOIN orders o
ON e.employee_id = o.employee_id
GROUP BY employee_name, title
ORDER BY order_count DESC


