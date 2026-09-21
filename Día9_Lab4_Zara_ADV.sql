-- 1. Selecciona todos los clientes junto con las compras que han realizado, mostrando el nombre del cliente y el monto de cada compra.
SELECT c.nombre_cliente, co.monto_total FROM Clientes AS c
INNER JOIN Compras AS co
    ON c.id_cliente = co.id_cliente; 

-- 2. Muestra todos los empleados y la tienda en la que trabajan, incluyendo el nombre del empleado y el nombre de la tienda.
SELECT e.nombre_empleado, t.nombre_tienda FROM empleados AS e
INNER JOIN tiendas AS t
    ON e.tienda_id = t.id_tienda;

-- 3. Selecciona todas las prendas que han sido compradas, junto con el nombre del cliente que las compró.
SELECT p.tipo_prenda, c.nombre_cliente FROM Prendas p
INNER JOIN Detalle_Compras dc
    ON p.id_prenda = dc.id_prenda
INNER JOIN Compras co
    ON dc.id_compra = co.id_compra
INNER JOIN Clientes c
    ON co.id_cliente = c.id_cliente;

-- 4. Muestra el total de compras realizadas por cada cliente, mostrando su nombre y el total de compras.
SELECT
    c.nombre_cliente,
    COUNT(co.id_compra) AS total_compras
FROM Clientes c
LEFT JOIN Compras co
    ON c.id_cliente = co.id_cliente
GROUP BY
    c.id_cliente,
    c.nombre_cliente;
    
-- 5. Selecciona los empleados que han vendido prendas de color "Rojo", mostrando el nombre del empleado y el tipo de prenda.
SELECT DISTINCT
    e.nombre_empleado,
    p.tipo_prenda
FROM Empleados e
INNER JOIN Compras c
    ON e.id_empleado = c.id_empleado
INNER JOIN Detalle_Compras dc
    ON c.id_compra = dc.id_compra
INNER JOIN Prendas p
    ON dc.id_prenda = p.id_prenda
WHERE p.color = 'Rojo';

-- 6. Muestra la cantidad de prendas vendidas por cada tienda, mostrando el nombre de la tienda y el total de prendas vendidas.
SELECT
    t.nombre_tienda,
    COALESCE(SUM(dc.cantidad), 0) AS total_prendas_vendidas
FROM Tiendas t
LEFT JOIN Compras c
    ON t.id_tienda = c.id_tienda
LEFT JOIN Detalle_Compras dc
    ON c.id_compra = dc.id_compra
GROUP BY
    t.id_tienda,
    t.nombre_tienda;

-- 7. Selecciona los clientes que han realizado compras por un monto total superior a 100, mostrando su nombre y el monto total de la compra.
SELECT
    cl.nombre_cliente,
    SUM(c.monto_total) AS monto_total_compras
FROM Clientes cl
INNER JOIN Compras c
    ON cl.id_cliente = c.id_cliente
GROUP BY
    cl.id_cliente,
    cl.nombre_cliente
HAVING SUM(c.monto_total) > 100;

-- 8. Muestra todos los tipos de prendas y cuántas han sido compradas, mostrando el tipo de prenda y la cantidad vendida.
SELECT
    p.tipo_prenda,
    COALESCE(SUM(dc.cantidad), 0) AS cantidad_vendida
FROM Prendas p
LEFT JOIN Detalle_Compras dc
    ON p.id_prenda = dc.id_prenda
GROUP BY
    p.tipo_prenda;

-- 9. Selecciona las prendas que han sido compradas por más de un cliente, mostrando el tipo de prenda y el número de clientes que la han comprado.
SELECT
    p.tipo_prenda,
    COUNT(DISTINCT c.id_cliente) AS numero_clientes
FROM Prendas p
INNER JOIN Detalle_Compras dc
    ON p.id_prenda = dc.id_prenda
INNER JOIN Compras c
    ON dc.id_compra = c.id_compra
GROUP BY
    p.id_prenda,
    p.tipo_prenda
HAVING COUNT(DISTINCT c.id_cliente) > 1;

-- 10. Muestra la lista de compras realizadas en una tienda específica, incluyendo el nombre del cliente y el monto de la compra.
SELECT
    cl.nombre_cliente,
    c.monto_total
FROM Compras c
INNER JOIN Clientes cl
    ON c.id_cliente = cl.id_cliente
INNER JOIN Tiendas t
    ON c.id_tienda = t.id_tienda
WHERE t.nombre_tienda = 'Zara Gran Vía';

-- 11. Selecciona los empleados que trabajan en tiendas en "Madrid", mostrando su nombre y el nombre de la tienda.
SELECT
    e.nombre_empleado,
    t.nombre_tienda
FROM Empleados e
INNER JOIN Tiendas t
    ON e.tienda_id = t.id_tienda
WHERE t.ciudad = 'Madrid';

-- 12. Muestra los clientes que no han realizado ninguna compra, mostrando su nombre y correo electrónico.
SELECT
    cl.nombre_cliente,
    cl.email_cliente
FROM Clientes cl
LEFT JOIN Compras c
    ON cl.id_cliente = c.id_cliente
WHERE c.id_compra IS NULL;

-- 13. Selecciona el nombre de la tienda con el mayor número de empleados, mostrando el nombre de la tienda y la cantidad de empleados.
SELECT
    t.nombre_tienda,
    COUNT(e.id_empleado) AS cantidad_empleados
FROM Tiendas t
LEFT JOIN Empleados e
    ON t.id_tienda = e.tienda_id
GROUP BY
    t.id_tienda,
    t.nombre_tienda
ORDER BY
    cantidad_empleados DESC
LIMIT 1;

-- 14. Muestra el monto total de compras por cada empleado, incluyendo el nombre del empleado y el monto total vendido.
SELECT
    e.nombre_empleado,
    COALESCE(SUM(c.monto_total), 0) AS monto_total_vendido
FROM Empleados e
LEFT JOIN Compras c
    ON e.id_empleado = c.id_empleado
GROUP BY
    e.id_empleado,
    e.nombre_empleado;
    
-- 15. Selecciona las compras realizadas en el mes de septiembre de 2023, mostrando el nombre del cliente y la fecha de la compra.
SELECT
    cl.nombre_cliente,
    c.fecha_compra
FROM Compras c
INNER JOIN Clientes cl
    ON c.id_cliente = cl.id_cliente
WHERE c.fecha_compra >= '2023-09-01'
  AND c.fecha_compra < '2023-10-01';
  
-- 16. Muestra todos los clientes y las tiendas donde han realizado compras, incluyendo el nombre del cliente y el nombre de la tienda.
SELECT DISTINCT
    cl.nombre_cliente,
    t.nombre_tienda
FROM Clientes cl
INNER JOIN Compras c
    ON cl.id_cliente = c.id_cliente
INNER JOIN Tiendas t
    ON c.id_tienda = t.id_tienda;
    
-- 17. Selecciona las prendas cuyo precio promedio es superior a 40, mostrando el tipo de prenda y el precio promedio.
SELECT
    tipo_prenda,
    AVG(precio) AS precio_promedio
FROM Prendas
GROUP BY
    tipo_prenda
HAVING AVG(precio) > 40;

-- 18. Muestra la lista de empleados y la cantidad de compras que han gestionado, mostrando su nombre y la cantidad de compras.
SELECT
    e.nombre_empleado,
    COUNT(c.id_compra) AS cantidad_compras
FROM Empleados e
LEFT JOIN Compras c
    ON e.id_empleado = c.id_empleado
GROUP BY
    e.id_empleado,
    e.nombre_empleado;
    
-- 19. Selecciona los clientes que han realizado más de 3 compras, mostrando su nombre y el número de compras.
SELECT
    cl.nombre_cliente,
    COUNT(c.id_compra) AS numero_compras
FROM Clientes cl
INNER JOIN Compras c
    ON cl.id_cliente = c.id_cliente
GROUP BY
    cl.id_cliente,
    cl.nombre_cliente
HAVING COUNT(c.id_compra) > 3;

-- 20. Muestra el total de ventas por cada tipo de prenda, mostrando el tipo de prenda y el monto total vendido.
SELECT
    p.tipo_prenda,
    SUM(p.precio * dc.cantidad) AS monto_total_vendido
FROM Prendas p
INNER JOIN Detalle_Compras dc
    ON p.id_prenda = dc.id_prenda
GROUP BY
    p.tipo_prenda;
    
-- 21. Usa CASE WHEN para mostrar un mensaje diferente según el monto total de las compras: "Bajo", "Medio" o "Alto" para cada cliente.

-- 22. Actualiza el precio de todas las prendas de ropa que sean de tipo "Zapatos" incrementándolos en un 10%.
UPDATE Prendas
SET precio = precio * 1.10
WHERE tipo_prenda = 'Zapatos';

-- 23. Alterar la tabla de Clientes para agregar una nueva columna llamada "telefono_cliente".
ALTER TABLE Clientes
ADD COLUMN telefono_cliente VARCHAR(20);

-- 24. Muestra el número total de compras y el promedio de gasto por cliente, usando GROUP BY.
SELECT
    cl.nombre_cliente,
    COUNT(c.id_compra) AS total_compras,
    COALESCE(AVG(c.monto_total), 0) AS promedio_gasto
FROM Clientes cl
LEFT JOIN Compras c
    ON cl.id_cliente = c.id_cliente
GROUP BY
    cl.id_cliente,
    cl.nombre_cliente;
    
-- 25. Elimina todas las prendas cuyo precio es menor que 10.
DELETE FROM Prendas WHERE precio < 10;

-- 26. Usa JOIN para mostrar el nombre de los clientes y la cantidad total que han gastado en compras.
SELECT
    cl.nombre_cliente,
    COALESCE(SUM(c.monto_total), 0) AS cantidad_total_gastada
FROM Clientes cl
LEFT JOIN Compras c
    ON cl.id_cliente = c.id_cliente
GROUP BY
    cl.id_cliente,
    cl.nombre_cliente;
    
-- 27. Muestra un informe que incluya el nombre del empleado y la cantidad de compras gestionadas por tienda, usando GROUP BY.
SELECT
    t.nombre_tienda,
    e.nombre_empleado,
    COUNT(c.id_compra) AS cantidad_compras
FROM Tiendas t
INNER JOIN Empleados e
    ON t.id_tienda = e.tienda_id
LEFT JOIN Compras c
    ON e.id_empleado = c.id_empleado
    AND t.id_tienda = c.id_tienda
GROUP BY
    t.id_tienda,
    t.nombre_tienda,
    e.id_empleado,
    e.nombre_empleado;
    
-- 28. Usa un subquery para mostrar el cliente que ha realizado la compra más alta.

-- 29. Actualiza la ciudad de los empleados que trabajan en la tienda "Zara Gran Vía" a "Madrid".

-- 30. Usa una subconsulta con EXISTS para seleccionar todos los clientes que han realizado compras, mostrando solo sus nombres.
SELECT
    cl.nombre_cliente
FROM Clientes cl
WHERE EXISTS (
    SELECT 1
    FROM Compras c
    WHERE c.id_cliente = cl.id_cliente);