SELECT * FROM actor;
SELECT * FROM film;
SELECT * FROM customer;

SELECT title FROM film;
SELECT DISTINCT name AS language FROM language;
SELECT count(store_id) AS Num_Store FROM customer;
SELECT count(store_id) AS Num_Store FROM store;
SELECT * FROM staff;
SELECT COUNT(*) AS total_staff FROM staff;
SELECT first_name FROM staff;
SELECT CONCAT(first_name, ' ', last_name) AS employee_name FROM staff;
SELECT CONCAT(first_name, ' ', last_name) AS employee_name FROM actor WHERE first_name = "Scarlett";
SELECT CONCAT(first_name, ' ', last_name) AS employee_name FROM actor WHERE last_name = "Johansson";
SELECT COUNT(*) AS films_available FROM inventory;
SELECT * FROM rental;
SELECT count(rental_id) AS rented_films FROM rental;
SELECT * FROM film;
SELECT MIN(rental_duration) AS shortest_rent_period, MAX(rental_duration) AS longest_rent_period FROM film;
SELECT MIN(length) AS min_duration, MAX(length) AS max_duration FROM film;
SELECT avg(length) AS avg_fil_duration FROM film;
SELECT FLOOR(AVG(length) / 60) AS hours, ROUND(MOD(AVG(length),60)) AS minutes FROM film;
SELECT length AS films_over_3_hours FROM film WHERE length > 180;
SELECT * FROM customer;
SELECT CONCAT(LOWER(first_name),' ',LOWER(last_name)) AS customer_fullname, LOWER(email) AS contact_info FROM customer;
SELECT MAX(LENGTH(title)) AS longest_title_length FROM film;
SELECT title, LENGTH(title) AS title_length FROM film ORDER BY title_length DESC LIMIT 1;


