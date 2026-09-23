USE restaurante;
SELECT * FROM members;
SELECT * FROM menu;
SELECT * FROM sales;

-- Ejercicio
-- 1. ¿Cuál es la cantidad total que gastó cada cliente en el restaurante?
SELECT s.customer_id, SUM(m.price) AS total_spent FROM sales AS s
INNER JOIN menu AS m
ON s.product_id = m.product_id
GROUP BY s.customer_id ORDER BY s.customer_id;

-- 2. ¿Cuántos días ha visitado cada cliente el restaurante?
SELECT DISTINCT customer_id, count(order_date) AS num_visitas FROM sales 
GROUP BY customer_id; 

-- 3. ¿Cuál fue el primer artículo del menú comprado por cada cliente?
WITH ranked_sales AS (SELECT s.customer_id, s.order_date, m.product_name,
        DENSE_RANK() OVER (PARTITION BY s.customer_id ORDER BY s.order_date) AS purchase_rank FROM sales AS s
    INNER JOIN menu AS m
        ON s.product_id = m.product_id)
SELECT DISTINCT customer_id, product_name FROM ranked_sales
WHERE purchase_rank = 1 ORDER BY customer_id, product_name;

-- 4. ¿Cuál es el artículo más comprado en el menú y cuántas veces lo compraron todos los clientes?
SELECT m.product_name, COUNT(*) AS purchase_count FROM menu AS m
INNER JOIN sales AS s
ON m.product_id = s.product_id
GROUP BY m.product_id, m.product_name ORDER BY purchase_count DESC LIMIT 1;

-- 5. ¿Qué artículo fue el más popular para cada cliente?
WITH product_counts AS (SELECT s.customer_id, m.product_name, COUNT(*) AS purchase_count FROM sales AS s
    INNER JOIN menu AS m ON s.product_id = m.product_id
    GROUP BY s.customer_id, m.product_name),
ranked_products AS (SELECT customer_id, product_name, purchase_count, 
	DENSE_RANK() OVER (PARTITION BY customer_id ORDER BY purchase_count DESC) AS popularity_rank
    FROM product_counts)
SELECT customer_id, product_name, purchase_count FROM ranked_products WHERE popularity_rank = 1
ORDER BY customer_id, product_name;

-- 6. ¿Qué artículo compró primero el cliente después de convertirse en miembro?
WITH purchases_after_joining AS (
    SELECT s.customer_id, s.order_date, me.join_date, m.product_name,
        DENSE_RANK() OVER (PARTITION BY s.customer_id ORDER BY s.order_date) AS purchase_rank
    FROM sales AS s
    INNER JOIN members AS me ON s.customer_id = me.customer_id
    INNER JOIN menu AS m ON s.product_id = m.product_id
    WHERE s.order_date >= me.join_date)
SELECT DISTINCT customer_id, order_date, product_name FROM purchases_after_joining
WHERE purchase_rank = 1 ORDER BY customer_id, product_name;

-- 7. ¿Qué artículo se compró justo antes de que el cliente se convirtiera en miembro?
WITH purchases_before_joining AS (
    SELECT s.customer_id, s.order_date, me.join_date, m.product_name,
        DENSE_RANK() OVER (PARTITION BY s.customer_id ORDER BY s.order_date DESC) AS purchase_rank FROM sales AS s
    INNER JOIN members AS me ON s.customer_id = me.customer_id
    INNER JOIN menu AS m ON s.product_id = m.product_id
    WHERE s.order_date < me.join_date)
SELECT DISTINCT customer_id, order_date, product_name FROM purchases_before_joining
WHERE purchase_rank = 1 ORDER BY customer_id, product_name;

-- 8. ¿Cuál es el total de artículos y la cantidad gastada por cada miembro antes de convertirse en miembro?
SELECT s.customer_id, COUNT(*) AS total_items, SUM(m.price) AS total_spent FROM sales AS s
INNER JOIN members AS me ON s.customer_id = me.customer_id
INNER JOIN menu AS m ON s.product_id = m.product_id
WHERE s.order_date < me.join_date
GROUP BY s.customer_id ORDER BY s.customer_id;

-- 9. Si cada $1 gastado equivale a 10 puntos y el sushi tiene un multiplicador de puntos 2x, ¿Cuántos puntos tendría cada cliente?
SELECT s.customer_id,
    SUM(CASE WHEN m.product_name = 'sushi' THEN m.price * 10 * 2 ELSE m.price * 10 END) AS total_points
FROM sales AS s
INNER JOIN menu AS m ON s.product_id = m.product_id
GROUP BY s.customer_id
ORDER BY s.customer_id;

-- 10. Suposición: Solo los clientes que son miembros reciben puntos al comprar artículos, los puntos los reciben en las órdenes iguales o posteriores a la fecha en la que se convierten en miembros.
-- En la primera semana después de que un cliente se une al programa (incluida la fecha de ingreso), gana el doble de puntos en todos los artículos, no solo en sushi. ¿Cuántos puntos tienen los clientes A y B a fines de enero?
-- Suposición: Solo los clientes que son miembros reciben puntos al comprar artículos, los puntos los reciben en las órdenes iguales o posteriores a la fecha en la que se convierten en miembros. Solo las órdenes de la primera semana en la que se convierten en miembros suman 20 puntos para todos los artículos.
SELECT s.customer_id,
    SUM(CASE
            -- Primera semana como miembro: todos los productos valen 2x
            WHEN s.order_date BETWEEN me.join_date AND DATE_ADD(me.join_date, INTERVAL 6 DAY) THEN m.price * 20
            -- Después de la primera semana, el sushi sigue valiendo 2x
            WHEN m.product_name = 'sushi' THEN m.price * 20
            -- Resto de productos después de la primera semana
            ELSE m.price * 10 END) AS total_points FROM sales AS s
INNER JOIN members AS me
    ON s.customer_id = me.customer_id
INNER JOIN menu AS m
    ON s.product_id = m.product_id
WHERE s.order_date >= me.join_date AND s.order_date <= '2021-01-31'
GROUP BY s.customer_id ORDER BY s.customer_id; 

