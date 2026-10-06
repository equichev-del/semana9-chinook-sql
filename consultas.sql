SELECT current_database() AS base,
       current_user       AS usuario,
       COUNT(*)           AS total_clientes
FROM   Customer;

-- APARTADO 1: ¿Estoy conectado a la base correcta y cuántos clientes hay?

SELECT current_database() AS base,
       current_user       AS usuario,
       COUNT(*)           AS total_clientes
FROM   Customer;

-- APARTADO 2: ¿Qué pistas superan los 10 MB y cuánto cobran por segundo?
-- Pregunta: Identificar pistas grandes para saber qué ocupan más espacio y su costo relativo.

SELECT Name        AS pista,
       Milliseconds / 1000.0            AS segundos,
       Bytes / 1024.0 / 1024.0          AS megabytes,
       ROUND(unit_price / (Milliseconds / 1000.0) * 60, 5) AS precio_x_minuto
FROM   Track
WHERE  Bytes > 10 * 1024 * 1024
ORDER BY megabytes DESC;

-- APARTADO 3: ¿Qué clientes de EE. UU. o Canadá tienen número de fax registrado?
-- Pregunta: Segmentar clientes de Norteamérica que aún usan fax (candidatos a migración digital).

SELECT customer_id, --cliente id
       first_name,  --nombre
       last_name,   --apellido
       Country,     --pais
       Fax
FROM   Customer     --tabla
WHERE  (Country = 'USA' OR Country = 'Canada')
  AND  Fax IS NOT NULL
ORDER BY Country, last_name;

-- APARTADO 4: ¿Qué clientes corporativos de países objetivo atiende cada equipo de soporte?
-- Pregunta: Saber qué cuentas de empresa (B2B) están asignadas a los representantes 3 y 4.
--Pregunta que responde: ¿Qué clientes con empresa de ciertos países latinoamericanos y EE. UU.
-- están asignados a los asesores de soporte 3 y 4?
SELECT customer_id,   ---cliente
       first_name || ' ' || last_name AS cliente,  --nombre apellido = cliente
       Company AS compania,     --compania
       Country AS Pais,    --pais
       support_rep_id   --identificacion del representante de soporte
FROM   customer     -- tabla de busqueda
WHERE  support_rep_id IN (3, 4)
  AND  Company IS NOT NULL
  AND  Country IN ('Spain', 'Argentina', 'Brazil', 'Chile', 'USA')
ORDER BY Country, Company;

-- APARTADO 5: ¿Cómo mostramos un listado de clientes sin huecos vacíos
-- cuando no tienen empresa ni teléfono?
--Pregunta que responde: ¿Cómo presentamos los datos de los clientes de
-- forma que nunca aparezcan celdas vacías, reemplazando los NULL por un texto descriptivo?


SELECT first_name || ' ' || last_name AS cliente,
       COALESCE(Company, 'Particular')        AS empresa,
       COALESCE(Phone, 'Sin teléfono')         AS telefono,
       COALESCE(Fax,   'Sin fax')              AS fax
FROM   Customer
ORDER BY cliente;

-- APARTADO 6: ¿Qué clientes particulares (sin empresa) tienen un apellido
-- que empieza por la letra M?

SELECT customer_id AS id_cliente,     --cliente id
       first_name || ' ' || last_name AS cliente,       --nombre de la columna
       Email AS correo,       --correo
       country AS Pais     --pais
FROM   customer     --tabla de cliente
WHERE  Company IS NULL
  AND  last_name iLIKE 'M%'
ORDER BY last_name;


-- APARTADO 7: Ordenamiento por varios criterios.
-- SENTENCIA A: ¿Cuáles son las 5 pistas más caras y, a igual precio, las más largas?
--Preguntas que responde:
--A: ¿Qué 5 pistas tienen el precio unitario más alto y, entre las que cuestan lo mismo,
-- cuáles duran más?
--B: ¿Cuáles son las 5 pistas más breves de todo el catálogo?

SELECT Name      AS pista,
       Composer  AS compositor,
       unit_price AS precio,
       Milliseconds / 1000.0 AS segundos
FROM   Track
ORDER BY unit_price DESC, Milliseconds DESC
LIMIT  10;

-- SENTENCIA B: ¿Y las 5 pistas más cortas del catálogo?

SELECT Name      AS pista,
       Composer  AS compositor,
       Milliseconds / 1000.0 AS segundos
FROM   Track
ORDER BY Milliseconds ASC NULLS LAST
LIMIT  5;

-- APARTADO 8: Paginación para mostrar clientes de 5 en 5.
-- Pregunta: ¿Cómo implementamos la paginación en una aplicación web que muestra clientes?

-- PÁGINA 1 (primeros 5 clientes)
SELECT customer_id AS cliente_id,
       first_name || ' ' || last_name AS cliente,
       Country AS Pais
FROM   Customer   --Tabla de cliente
ORDER BY customer_id
LIMIT  5 OFFSET 0;

-- PÁGINA 2 (clientes del 6 al 10)
SELECT customer_id,
       first_name || ' ' || last_name AS cliente,
       Country
FROM   Customer
--WHERE customer_id >= 5
ORDER BY customer_id
LIMIT  5 OFFSET 5;

-- PÁGINA 3 (clientes del 11 al 15)
SELECT customer_id,
       first_name || ' ' || last_name AS cliente,
       Country
FROM   Customer
--ORDER BY cliente
ORDER BY customer_id
LIMIT  5 OFFSET 10;

-- APARTADO 9: ¿En qué países tenemos presencia comercial (sin duplicados)?
--SELECT Country
SELECT DISTINCT Country   --distinct hace que solo aparesca una ves un nombre o enunciado de las 2 o mas que haya
FROM   Customer
ORDER BY Country;

-- Países + ciudad únicos donde hay clientes
--DISTINCT actúa sobre la combinación completa de las columnas seleccionadas,
-- no sobre cada una por separado. Así verás cada ciudad única dentro de su país.

SELECT DISTINCT Country AS pais, City As ciudad
FROM   Customer
ORDER BY Country, City;

SELECT DISTINCT City AS ciudad
FROM customer
ORDER BY city;

-- APARTADO 10: Clasificación de clientes por equipo de soporte.
-- SENTENCIA A: ¿Qué cliente pertenece a qué equipo de soporte?

SELECT customer_id,
       first_name || ' ' || last_name AS cliente,
       Country,
       CASE
           WHEN support_rep_id = 3 THEN 'Equipo A'
           WHEN support_rep_id = 4 THEN 'Equipo B'
           ELSE 'Sin asignar'
       END AS equipo_soporte
FROM   Customer
ORDER BY equipo_soporte, cliente;

-- SENTENCIA B: ¿Cuántos clientes tiene cada equipo de soporte?

SELECT CASE         --herramienta que se utiliza para crear condiciones if/else dentro de consultas
           WHEN support_rep_id = 3 THEN 'Equipo A'  --CASE WHEN .. THEN .. END: es como un if/else
           WHEN support_rep_id = 4 THEN 'Equipo B'  --en SQL. Evalúa condiciones en orden y devuelve el primer valor que coincida.
           ELSE 'Sin asignar'  --ELSE 'Sin asignar': para cualquier otro caso (por si hay IDs 1, 2, etc.).
       END AS equipo_soporte,
       COUNT(*) AS cantidad_clientes
FROM   Customer
GROUP BY 1    --GROUP BY 1: se agrupa por la primera columna del SELECT (que es la expresión CASE). Es un atajo válido en PostgreSQL.
ORDER BY cantidad_clientes DESC;