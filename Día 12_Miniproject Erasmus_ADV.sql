USE Erasmus;

/* ============================================================
 1.  ¿Cuál es la edad promedio de los estudiantes que tienen calificaciones sobresalientes?
   Complete la tabla con:
   - EXCELENTE si tienen un 9 o un 10.
   - BUENO si tienen un 7 o un 8.
   - APROBADO si tienen un 5 o un 6.
   - REPROBADO si tienen menos de 5.
   ============================================================ */
-- Clasificación de las calificaciones de los estudiantes
SELECT s.student_id, s.f_name, s.l_name, TIMESTAMPDIFF(YEAR, s.dob, CURDATE()) AS age, g.subject_id, g.grades,
    CASE
        WHEN g.grades >= 9 THEN 'EXCELENTE'
        WHEN g.grades >= 7 THEN 'BUENO'
        WHEN g.grades >= 5 THEN 'APROBADO'
        ELSE 'REPROBADO'
    END AS grade_category
FROM students AS s
INNER JOIN grades AS g
    ON s.student_id = g.student_id
ORDER BY s.student_id, g.subject_id;

-- Edad promedio de los estudiantes con calificaciones excelentes.
-- Cada estudiante se cuenta una sola vez.
SELECT ROUND(AVG(excellent_students.age), 2) AS average_age
FROM (SELECT DISTINCT s.student_id,TIMESTAMPDIFF(YEAR, s.dob, CURDATE()) AS age FROM students AS s
    INNER JOIN grades AS g
        ON s.student_id = g.student_id
    WHERE g.grades >= 9) AS excellent_students;


/* ============================================================
   2. ¿Cuál es la edad media de los estudiantes por universidad?
   ============================================================ */
SELECT u.university_id, u.uni_name,
    ROUND(AVG(TIMESTAMPDIFF(YEAR, s.dob, CURDATE())),2) AS average_age FROM university AS u
INNER JOIN campus AS c
    ON u.university_id = c.university_id
INNER JOIN students AS s
    ON c.campus_id = s.campus_id
GROUP BY u.university_id, u.uni_name
ORDER BY average_age DESC;

/* ============================================================
   3. ¿Cuál es la proporción de alumnos que suspendieron cada asignatura?
   Indique:
   - El nombre de la asignatura.
   - El número de alumnos que suspendieron.
   - El número total de alumnos.
   - La proporción de alumnos que suspendieron en porcentaje.
   Muestre los resultados en orden descendente según la proporción de alumnos que suspendieron.
   ============================================================ */
SELECT sub.subject_id, sub.subj_name,
    COUNT(DISTINCT CASE WHEN g.grades < 5 THEN g.student_id END) AS failed_students,
    COUNT(DISTINCT g.student_id) AS total_students,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN g.grades < 5 THEN g.student_id END)
        / NULLIF(COUNT(DISTINCT g.student_id), 0),2) AS failed_percentage
FROM subjects AS sub
LEFT JOIN grades AS g
    ON sub.subject_id = g.subject_id
GROUP BY sub.subject_id, sub.subj_name
ORDER BY failed_percentage DESC, sub.subj_name;


/* ============================================================
  4. ¿Cuál es la nota media de los estudiantes que han realizado un Erasmus en comparación con los que no lo han hecho?
   ============================================================ */
SELECT CASE WHEN ia.student_id IS NOT NULL THEN 'ERASMUS' ELSE 'NO ERASMUS'
    END AS erasmus_status, ROUND(AVG(g.grades), 2) AS average_grade, COUNT(DISTINCT s.student_id) AS total_students
FROM students AS s
INNER JOIN grades AS g
    ON s.student_id = g.student_id
LEFT JOIN
(SELECT DISTINCT student_id FROM international_agreement) AS ia
    ON s.student_id = ia.student_id
GROUP BY CASE
        WHEN ia.student_id IS NOT NULL THEN 'ERASMUS'
        ELSE 'NO ERASMUS'
    END ORDER BY erasmus_status;


/* ============================================================
  5. Para cada universidad, identifique el número de títulos de licenciatura, maestría y doctorado otorgados.
   Proporcione:
   - La identificación de la universidad.
   - El nombre de la universidad.
   - El recuento de cada tipo de título.
   IMPORTANTE: En el diagrama proporcionado solamente aparece la tabla bachelor. No aparecen las tablas correspondientes a los títulos de maestría y doctorado.
   ============================================================ */
-- Consulta compatible con el diagrama proporcionado
SELECT u.university_id, u.uni_name, COUNT(DISTINCT b.bachelor_id) AS bachelor_count FROM university AS u
LEFT JOIN bachelor AS b
    ON u.university_id = b.university_id
GROUP BY u.university_id, u.uni_name
ORDER BY u.university_id;

/* ============================================================
6. ¿Cuáles son las 5 universidades con la clasificación media más alta a lo largo de los años?
   Indique:
   - El ID de la universidad.
   - El nombre de la universidad.
   - La clasificación media.
   ============================================================ */
SELECT u.university_id, u.uni_name, ROUND(AVG(r.int_ranking), 2) AS average_ranking FROM university AS u
INNER JOIN ranking AS r
    ON u.university_id = r.university_id
GROUP BY u.university_id, u.uni_name
ORDER BY average_ranking ASC LIMIT 5;

/* ============================================================
7. Proporcione el número de identificación, el nombre, los apellidos, el nombre de la universidad de origen y el correo
   electrónico de los 10 estudiantes que hayan participado más veces en un acuerdo internacional.
   ============================================================ */
SELECT s.student_id, s.f_name, s.l_name,
GROUP_CONCAT(DISTINCT u.uni_name ORDER BY u.uni_name SEPARATOR ', ') AS home_universities, s.email, COUNT(DISTINCT ia.agreement_code) AS agreement_count
FROM students AS s
INNER JOIN international_agreement AS ia
    ON s.student_id = ia.student_id
INNER JOIN university AS u
    ON ia.home_university = u.university_id
GROUP BY s.student_id, s.f_name, s.l_name, s.email
ORDER BY agreement_count DESC, s.student_id LIMIT 10;

/* ============================================================
9. Busque y muestre el número de universidades que ofrecen cada asignatura, junto con la nota media de cada asignatura.
   ============================================================ */
SELECT sub.subject_id, sub.subj_name, COUNT(DISTINCT us.university_id) AS university_count, ROUND(AVG(g.grades), 2) AS average_grade
FROM subjects AS sub
LEFT JOIN uni_subj AS us
    ON sub.subject_id = us.subject_id
LEFT JOIN grades AS g
    ON sub.subject_id = g.subject_id
GROUP BY sub.subject_id, sub.subj_name
ORDER BY university_count DESC, sub.subj_name;


/* ============================================================
10. Encuentre las 5 ciudades con el mayor porcentaje de estudiantes con calificaciones sobresalientes, es decir, con notas de 9 o 10.
   Indique:
   - La ciudad.
   - El estado.
   - El porcentaje de estudiantes sobresalientes.
   ============================================================ */
SELECT s.city, s.state,
    COUNT(DISTINCT CASE WHEN g.grades >= 9 THEN s.student_id END) AS excellent_students,
    COUNT(DISTINCT s.student_id) AS total_students,
    ROUND(100.0 * COUNT(DISTINCT CASE WHEN g.grades >= 9 THEN s.student_id END)
        / NULLIF(COUNT(DISTINCT s.student_id), 0), 2) AS excellent_percentage
FROM students AS s
INNER JOIN grades AS g
    ON s.student_id = g.student_id
GROUP BY s.city, s.state
ORDER BY excellent_percentage DESC, excellent_students DESC LIMIT 5;

/* ============================================================
11. Compare las universidades que envían más estudiantes con las universidades que reciben más estudiantes.
   Realice el análisis en dos consultas.
   ================================================*/
   -- Universidades que envían más estudiantes
SELECT u.university_id, u.uni_name, COUNT(DISTINCT ia.student_id) AS students_sent
FROM university AS u
INNER JOIN international_agreement AS ia
    ON u.university_id = ia.home_university
GROUP BY u.university_id, u.uni_name
ORDER BY students_sent DESC, u.uni_name;
    
-- Universidades que reciben más estudiantes
SELECT u.university_id, u.uni_name, COUNT(DISTINCT ia.student_id) AS students_received
FROM university AS u
INNER JOIN international_agreement AS ia
    ON u.university_id = ia.away_university
GROUP BY u.university_id, u.uni_name
ORDER BY students_received DESC, u.uni_name;
