SELECT * FROM customers;
SELECT * FROM employees;
SELECT * FROM orders;

-- 1. Obtener el nombre del cliente y la fecha de sus pedidos.
SELECT c.customer_name, o.order_date FROM customers AS c
INNER JOIN orders AS o
ON c.customer_id = o.customer_id;

-- 2. Mostrar todos los clientes y, si tienen, los pedidos asociados.
SELECT c.customer_id, c.customer_name, o.order_id, o.order_date, o.status FROM customers AS c
LEFT JOIN orders AS o 
ON c.customer_id = o.customer_id;

-- 3. Mostrar todas las órdenes y los clientes, si es que tienen.
SELECT
    o.order_id,
    o.order_date,
    o.status,
    c.customer_id,
    c.customer_name
FROM orders AS o
LEFT JOIN customers AS c
    ON o.customer_id = c.customer_id;

-- 4. Obtener el número total de pedidos por cada cliente.
SELECT c.customer_id,  c.customer_name, COUNT(order_id) AS total_pedidos FROM customers AS c
INNER JOIN orders AS o
ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.customer_name
ORDER BY total_pedidos DESC;

-- 5. Mostrar clientes que tienen más de 5 pedidos.
SELECT c.customer_id, c.customer_name, COUNT(order_id) AS total_perdidos FROM customers AS c
INNER JOIN orders AS o 
ON c.customer_id = o.customer_id 
GROUP BY c.customer_id, c.customer_name 
HAVING COUNT(o.order_id) > 5; 

-- 6. Mostrar el total de pedidos por cliente para pedidos con estado 'Shipped'.
SELECT
    c.customer_id,
    c.customer_name,
    COUNT(order_id) AS total_shipped
FROM customers AS c
INNER JOIN orders AS o
    ON c.customer_id = o.customer_id
WHERE o.status = 'Shipped'
GROUP BY c.customer_id, c.customer_name;

-- 7. Mostrar clientes con más de 3 pedidos que están en estado 'Pending'.
SELECT
    c.customer_id,
    c.customer_name,
    COUNT(o.order_id) AS total_pending
FROM customers AS c
INNER JOIN orders AS o
    ON c.customer_id = o.customer_id
WHERE o.status = 'Pending'
GROUP BY  c.customer_id, c.customer_name
HAVING COUNT(o.order_id) > 3;

-- 8. Mostrar los clientes que han realizado pedidos en 2024.
SELECT DISTINCT c.customer_id, c.customer_name, o.order_date FROM customers AS c
INNER JOIN orders AS o
ON c.customer_id = o.customer_id 
WHERE extract(Year from order_date) > 2024;

SELECT DISTINCT c.customer_id, c.customer_name, o.order_date FROM customers AS c
INNER JOIN orders AS o
ON c.customer_id = o.customer_id 
WHERE o.order_date >= '2024-01-01' AND o.order_date < '2025-01-01';

-- 9. Mostrar las órdenes de clientes que viven en países específicos.Se utiliza country porque el ERD no contiene una columna city.
SELECT
    o.order_id,
    o.order_date,
    o.status,
    c.customer_name,
    c.country
FROM orders AS o
INNER JOIN customers AS c
    ON o.customer_id = c.customer_id
WHERE c.country IN ('Spain', 'France', 'Germany');

-- 10. Mostrar los clientes cuyos nombres comienzan con 'J'.
SELECT 
    customer_id, 
    customer_name, 
    contact_name, 
    country 
FROM customers
WHERE customer_name LIKE 'J%';

-- 11. Mostrar las órdenes realizadas entre el 1 de febrero de 2024 y el 30 de abril de 2024.
SELECT
    order_id,
    customer_id,
    order_date,
    status
FROM orders
WHERE order_date BETWEEN '2024-02-01' AND '2024-04-30';


-- 12. Mostrar las órdenes con estado 'Pending' o 'Cancelled'.
SELECT
    order_id,
    customer_id,
    order_date,
    status
FROM orders
WHERE status IN ('Pending', 'Cancelled');


-- 13. Mostrar los pedidos realizados por clientes de España
-- con estado 'Shipped'.
-- Se utiliza country = 'Spain' porque el ERD no contiene una columna city.
SELECT
    o.order_id,
    o.order_date,
    o.status,
    c.customer_name,
    c.country
FROM orders AS o
INNER JOIN customers AS c
    ON o.customer_id = c.customer_id
WHERE c.country = 'Spain'
  AND o.status = 'Shipped';


-- 14. Mostrar todos los clientes y sus pedidos,
-- incluyendo aquellos que no tienen pedidos en 2024.
SELECT
    c.customer_id,
    c.customer_name,
    o.order_id,
    o.order_date,
    o.status
FROM customers AS c
LEFT JOIN orders AS o
    ON c.customer_id = o.customer_id
    AND o.order_date >= '2024-01-01'
    AND o.order_date < '2025-01-01';


-- 15. Mostrar los clientes que tienen más de 3 pedidos.
SELECT
    c.customer_id,
    c.customer_name,
    COUNT(o.order_id) AS total_orders
FROM customers AS c
INNER JOIN orders AS o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.customer_name
HAVING COUNT(o.order_id) > 3;


-- 16. Mostrar los clientes que tienen más de 5 pedidos
-- en estado 'Shipped'.
SELECT
    c.customer_id,
    c.customer_name,
    COUNT(o.order_id) AS total_shipped
FROM customers AS c
INNER JOIN orders AS o
    ON c.customer_id = o.customer_id
WHERE o.status = 'Shipped'
GROUP BY
    c.customer_id,
    c.customer_name
HAVING COUNT(o.order_id) > 5;


-- 17. Mostrar el número de pedidos por cliente y estado.
SELECT
    c.customer_id,
    c.customer_name,
    o.status,
    COUNT(o.order_id) AS total_orders
FROM customers AS c
INNER JOIN orders AS o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.customer_name,
    o.status
ORDER BY
    c.customer_name,
    o.status;


-- 18. Mostrar el nombre del cliente y un mensaje
-- dependiendo del estado de sus pedidos.
SELECT
    c.customer_name,
    o.order_id,
    o.status,
    CASE
        WHEN o.status = 'Shipped'
            THEN 'The order has been shipped'
        WHEN o.status = 'Pending'
            THEN 'The order is pending'
        WHEN o.status = 'Cancelled'
            THEN 'The order has been cancelled'
        ELSE 'Unknown status'
    END AS status_message
FROM customers AS c
INNER JOIN orders AS o
    ON c.customer_id = o.customer_id;