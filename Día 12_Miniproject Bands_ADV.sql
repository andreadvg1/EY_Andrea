SELECT * FROM album;
SELECT * FROM band;
SELECT * FROM band_genre;
SELECT * FROM band_musician;
SELECT * FROM musician;
SELECT * FROM musician_name;

-- 1 Que músico ha pertenecido a más bandas
SELECT mn.musician_name, COUNT(DISTINCT bm.band_id) AS num_bands FROM musician_name AS mn
JOIN band_musician AS bm
ON mn.musician_id = bm.musician_id
GROUP BY mn.musician_id, mn.musician_name
ORDER BY num_bands DESC;

-- 2 Qué músico ha participado en más albumes 
SELECT mn.musician_name, COUNT(DISTINCT a.album_id) AS total_albums FROM musician_name AS mn
JOIN band_musician AS bm
ON mn.musician_id = bm.musician_id
JOIN album AS a
ON bm.band_id = a.band_id
GROUP BY mn.musician_id, mn.musician_name
ORDER BY total_albums DESC; 

-- 3 Que banda ha hecho más discos 
SELECT b.band_name, COUNT(a.album_id) AS total_albums FROM band AS b
JOIN album AS a
ON b.band_id = a.band_id
GROUP BY b.band_id, b.band_name
ORDER BY total_albums DESC; 

-- 4 Bandas con más ventas acumuladas 
SELECT b.band_name, SUM(a.sales_amount) AS total_sales FROM band b
JOIN album AS a
ON b.band_id = a.band_id
GROUP BY b.band_name
ORDER BY total_sales DESC; 

-- 5 Género con más bandas 
SELECT genre_name, COUNT(DISTINCT band_id) AS total_bands FROM band_genre
GROUP BY genre_name
ORDER BY total_bands DESC;


