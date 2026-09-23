USE classicmodels;

-- Sección 1
-- 1. Contactos de oficina: Tiene una tabla que contiene los códigos de oficina y sus números de teléfono asociados.
SELECT officecode, phone FROM offices;

-- 2. Detectives de correo electrónico: ¿Puede identificar a los empleados cuyas direcciones de correo electrónico terminan en “.es”?
SELECT EMAIL AS Email_ES FROM employees WHERE email LIKE "%.es";

-- 3. Estado de confusión: descubra qué clientes carecen de información estatal en sus registros.
SELECT customerNumber, customerName, State FROM customers WHERE State IS NULL;

-- 4. Grandes gastadores: busquemos pagos que superen los $20.000.
SELECT customerNumber, amount FROM payments WHERE amount>20000;

-- 5. Grandes gastadores de 2005: Ahora, acote la lista aún más y busque los pagos mayores a $20,000 que se realizaron en el año 2005.
SELECT * FROM payments;
SELECT customerNumber, amount, paymentDate FROM payments WHERE amount>20000 AND paymentDate between "2005-01-01" AND "2005-12-31";
SELECT customerNumber, checkNumber, paymentDate, amount FROM payments
WHERE amount > 20000 AND YEAR(paymentDate) = 2005 ORDER BY amount DESC;

-- 6. Detalles distintos: busque y muestre solo las filas únicas de la tabla “orderdetails” en función de la columna “productcode”.
SELECT DISTINCT productcode FROM orderdetails;
SELECT DISTINCT productcode FROM orderdetails ORDER BY productCode;

-- 7. Estadísticas globales de compradores: por último, cree una tabla que muestre el recuento de compras realizadas por país.
SELECT * FROM orders;
SELECT DISTINCT c.country, COUNT(o.orderNumber) AS total_orders_country FROM customers AS c
INNER JOIN orders AS o 
ON c.customerNumber = o.customerNumber
GROUP BY c.country ORDER BY total_orders_country DESC; 

-- Sección 2
-- 1. Descripción de línea de producto más larga: descubramos qué línea de producto tiene la descripción de texto más larga.
SELECT productLine, textDescription, LENGTH(textDescription) AS tDescrip_length FROM productlines ORDER BY LENGTH(tDescrip_length) DESC;
SELECT productLine, textDescription, CHAR_LENGTH(textDescription) AS descriptionLength FROM productlines
ORDER BY descriptionLength DESC LIMIT 1;

-- 2. Recuento de clientes de oficina: ¿Puede determinar el número de clientes asociados a cada oficina?
SELECT o.officeCode, o.city, o.country, COUNT(c.customerNumber) AS customerCount FROM offices AS o
LEFT JOIN employees AS e
    ON o.officeCode = e.officeCode
LEFT JOIN customers AS c
    ON e.employeeNumber = c.salesRepEmployeeNumber
GROUP BY o.officeCode, o.city, o.country
ORDER BY customerCount DESC;

-- 3. Día de mayores ventas de automóviles: descubra qué día de la semana se registra el mayor número de ventas de automóviles.
SELECT DISTINCT weekday(orderDate) AS Week_Day , COUNT(orderNumber) AS daily_purchases FROM orders 
GROUP BY Week_Day ORDER BY Week_Day; -- no sirve xq tiene que ser únicamente de coches

SELECT
    DAYNAME(o.orderDate) AS dayOfWeek,
    SUM(od.quantityOrdered) AS carsSold
FROM orders AS o
INNER JOIN orderdetails AS od
    ON o.orderNumber = od.orderNumber
INNER JOIN products AS p
    ON od.productCode = p.productCode
WHERE p.productLine = 'Classic Cars'
GROUP BY
    DAYOFWEEK(o.orderDate),
    DAYNAME(o.orderDate)
ORDER BY carsSold DESC
LIMIT 1;

-- 4. Corrección de datos territoriales faltantes: Hay algunos valores faltantes (NA) en la variable " territory " de la tabla " offices ". Podemos usar una instrucción "case when" para corregir estos valores y establecerlos en " USA".
SELECT
    officeCode,
    city,
    country,
    CASE
        WHEN territory IS NULL
          OR TRIM(territory) = ''
          OR UPPER(TRIM(territory)) = 'NA'
        THEN 'USA'
        ELSE territory
    END AS correctedTerritory
FROM offices
ORDER BY officeCode;

-- 5. Estadísticas de empleados de la familia Patterson: calcule el monto promedio del carrito y el total de artículos, año por mes, para las compras realizadas en los años 2004 y 2005 por clientes asistidos por empleados de la familia Patterson.
SELECT
    YEAR(orderSummary.orderDate) AS orderYear,
    MONTH(orderSummary.orderDate) AS orderMonth,
    ROUND(AVG(orderSummary.cartAmount), 2) AS averageCartAmount,
    SUM(orderSummary.totalItems) AS totalItems
FROM
(
    SELECT
        o.orderNumber,
        o.orderDate,
        SUM(od.quantityOrdered * od.priceEach) AS cartAmount,
        SUM(od.quantityOrdered) AS totalItems
    FROM orders AS o
    INNER JOIN orderdetails AS od
        ON o.orderNumber = od.orderNumber
    INNER JOIN customers AS c
        ON o.customerNumber = c.customerNumber
    INNER JOIN employees AS e
        ON c.salesRepEmployeeNumber = e.employeeNumber
    WHERE YEAR(o.orderDate) IN (2004, 2005)
      AND e.lastName = 'Patterson'
    GROUP BY
        o.orderNumber,
        o.orderDate
) AS orderSummary
GROUP BY
    YEAR(orderSummary.orderDate),
    MONTH(orderSummary.orderDate)
ORDER BY
    orderYear,
    orderMonth;

-- Sección 3
-- 1. Análisis de compras anuales: Analicemos algunos cálculos avanzados mediante subconsultas. Queremos encontrar el importe promedio del carrito y el total de artículos, desglosados por año y mes. Esto se aplica específicamente a las compras realizadas en los años 2004 y 2005, pero nos interesan los clientes atendidos por empleados de la familia Patterson.
SELECT YEAR(o.orderDate) AS orderYear, MONTH(o.orderDate) AS orderMonth,
    ROUND(AVG(
    (SELECT SUM(od1.quantityOrdered * od1.priceEach) FROM orderdetails AS od1 WHERE od1.orderNumber = o.orderNumber)
    ),2) AS averageCartAmount,
    SUM((SELECT SUM(od2.quantityOrdered) FROM orderdetails AS od2 WHERE od2.orderNumber = o.orderNumber)) AS totalItems
FROM orders AS o
WHERE YEAR(o.orderDate) IN (2004, 2005)
  AND o.customerNumber IN
  (SELECT c.customerNumber FROM customers AS c 
  WHERE c.salesRepEmployeeNumber IN (SELECT e.employeeNumber FROM employees AS e WHERE e.lastName = 'Patterson'))
GROUP BY YEAR(o.orderDate), MONTH(o.orderDate)
ORDER BY orderYear, orderMonth;

-- 2. Viaje a la oficina: ¡Llegó una misión especial! Visitaremos algunas de nuestras oficinas personalmente. Queremos identificar cuáles tienen empleados que atienden a clientes con información estatal vacía. Visitaremos estas oficinas para charlar y asegurarnos de que todo esté en orden.
SELECT o.officeCode, o.city, o.phone, o.country, o.territory FROM offices AS o
WHERE o.officeCode IN
(SELECT e.officeCode FROM employees AS e WHERE e.employeeNumber IN
	(SELECT c.salesRepEmployeeNumber FROM customers AS c WHERE c.state IS NULL OR TRIM(c.state) = '' OR UPPER(TRIM(c.state)) = 'NA'))
ORDER BY o.officeCode;



