-- 1. Selecciona todos los clientes.
SELECT * FROM clientes;

-- 2. Selecciona todos los empleados.
SELECT * FROM empleados;

-- 3. Selecciona todas las tiendas.
SELECT * FROM tiendas;

-- 4. Selecciona todas las prendas de ropa.
SELECT * FROM prendas;

-- 5. Busca clientes cuyo nombre comience con la letra "L".
SELECT nombre_cliente FROM clientes WHERE nombre_cliente LIKE "L%";

-- 6. Cuenta cuántos clientes hay en la base de datos.
SELECT count(id_cliente) AS total_clientes FROM clientes;

-- 7. Selecciona las compras realizadas después del 1 de mayo de 2023.
SELECT id_cliente, fecha_compra FROM compras WHERE fecha_compra>"2023-06-01" ORDER BY fecha_compra ASC;

-- 8. Actualiza el correo electrónico de un cliente específico.
SELECT * FROM clientes;
SELECT upper(email_cliente) AS updated_email FROM clientes WHERE email_cliente LIKE "l%";
UPDATE Clientes SET email_cliente = 'carlos.ramirez@nuevoemail.com' WHERE id_cliente = 1;
SELECT * FROM clientes;

-- 9. Elimina un cliente por su ID.
SELECT * FROM compras;
DELETE FROM compras WHERE id_cliente = 5 AND id_compra > 0; 
DELETE FROM clientes WHERE id_cliente = 5; 

-- 10. Selecciona las prendas de color Negro.
SELECT * FROM prendas WHERE color = "Negro";

-- 11. Selecciona todas las tiendas que hay en Madrid.
SELECT * FROM tiendas WHERE ciudad = "Madrid";

-- 12. Cuenta cuántas prendas tienen un precio mayor a 50.
SELECT * FROM prendas WHERE precio>50;

-- 13. Selecciona los empleados que trabajan en la tienda con ID 1.
SELECT * FROM tiendas WHERE id_tienda = 1;

-- 14. Busca clientes cuyo nombre contenga "Andrés".
SELECT * FROM clientes WHERE nombre_cliente LIKE "%Andrés%";

-- 15. Selecciona las compras realizadas por el cliente con ID 2.
SELECT * FROM compras WHERE id_cliente = 2;

-- 16. Elimina todas las compras cuyo monto sea menor a 30.
DELETE FROM compras WHERE monto_total<30;

-- 17. Selecciona las prendas cuyo precio esté entre 20 y 40.
SELECT * FROM prendas WHERE precio BETWEEN 20 AND 40;

-- 18. Busca empleados cuyo nombre contenga la letra "a".
SELECT * FROM empleados WHERE nombre_empleado LIKE "%a%";

-- 19. Selecciona las 5 prendas más caras.
SELECT * FROM prendas ORDER BY precio DESC LIMIT 5;

-- 20. Selecciona las compras de un cliente con un monto superior a 75.
SELECT * FROM compras WHERE monto_total>75;

-- 21. Selecciona las prendas de talla M.
SELECT * FROM prendas WHERE talla LIKE "%M%";

-- 22. Actualiza la talla de una prenda específica por su ID.
UPDATE Prendas SET talla = 'L'WHERE id_prenda = 1;
SELECT * FROM prendas;

-- 23. Selecciona todos los empleados contratados después del 1 de enero de 2022.
SELECT * FROM Empleados WHERE fecha_contratacion > '2022-01-01';

-- 24. Busca tiendas en "Barcelona".
SELECT * FROM Tiendas WHERE ciudad = 'Barcelona';

-- 25. Elimina un empleado por su ID.
DELETE FROM Empleados WHERE id_empleado = 5;

-- 26. Selecciona las compras que se realizaron antes del 1 de julio de 2023.
SELECT * FROM Compras WHERE fecha_compra < '2023-07-01';

-- 27. Busca prendas cuyo nombre termine en "eta".
SELECT * FROM Prendas WHERE tipo_prenda LIKE '%eta';

-- 28. Selecciona los clientes que no tengan un email registrado con "hotmail".
SELECT * FROM Clientes
WHERE email_cliente NOT LIKE '%hotmail%';

-- 29. Cuenta cuántas compras se realizaron en septiembre de 2023.
SELECT COUNT(*) AS compras_septiembre_2023 FROM Compras WHERE fecha_compra >= '2023-09-01' AND fecha_compra < '2023-10-01';

-- 30. Actualiza la dirección de una tienda por su ID.
UPDATE Tiendas SET direccion = 'Calle Gran Vía, 50' WHERE id_tienda = 1;
SELECT * FROM Tiendas WHERE id_tienda = 1;

-- 31. Selecciona las prendas que sean camisetas.
SELECT * FROM Prendas WHERE tipo_prenda = 'Camiseta';

-- 32. Elimina todas las prendas cuyo precio sea menor a 20.
DELETE FROM Prendas WHERE precio < 20;

-- 33. Selecciona todas las tiendas y ordénalas por ciudad.
SELECT * FROM Tiendas ORDER BY ciudad ASC;

-- 34. Selecciona los empleados que sean vendedores.
SELECT * FROM Empleados WHERE puesto = 'Vendedor';

-- 35. Cuenta cuántas prendas son de color blanco.
SELECT COUNT(*) AS prendas_blancas FROM Prendas WHERE color = 'Blanco';

-- 36. Selecciona los clientes que tengan nombres de más de 10 caracteres.
SELECT * FROM Clientes WHERE CHAR_LENGTH(nombre_cliente) > 10;

-- 37. Busca compras cuyo monto total esté entre 50 y 100.
SELECT * FROM Compras WHERE monto_total BETWEEN 50 AND 100;

-- 38. Selecciona las 3 compras más recientes.
SELECT * FROM Compras ORDER BY fecha_compra DESC, id_compra DESC LIMIT 3;

-- 39. Busca cursos cuyo nombre contenga la palabra "Digital".

-- 40. Agrupa las prendas por color y cuenta cuántas hay de cada color.
SELECT color, COUNT(*) AS total_prendas FROM Prendas GROUP BY color ORDER BY color;

-- 41. Añade dos tiendas más de Madrid que no estén en la base de datos.
INSERT INTO Tiendas (nombre_tienda, direccion, ciudad,pais)
VALUES
    ('Zara Serrano', 'Calle de Serrano, 23', 'Madrid', 'España'),
    ('Zara Preciados', 'Calle de Preciados, 18', 'Madrid', 'España');

-- Comprobación:
SELECT * FROM Tiendas WHERE ciudad = 'Madrid';

-- 42. Actualiza el nombre y el email de Miguel Torres.
UPDATE Clientes SET nombre_cliente = 'Micaela Torres', email_cliente = 'micaela.torres@email.com' WHERE nombre_cliente = 'Miguel Torres';

-- Comprobación:
SELECT * FROM Clientes WHERE nombre_cliente = 'Micaela Torres';