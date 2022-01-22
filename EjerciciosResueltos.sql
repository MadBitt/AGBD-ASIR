-- 1. Actores que tienen de primer nombre ‘Scarlett’.

SELECT * from actor
WHERE first_name = "Scarlett"
;

-- 2. Actores que tienen de apellido ‘Johansson’.

SELECT * from actor
WHERE last_name = "Johansson"
;

-- 3. Actores que contengan una ‘O’ en su nombre.

SELECT * FROM actor
WHERE first_name LIKE "%o%"
;

-- 4. Actores que contengan una ‘O’ en su nombre y en una ‘A’ en su apellido.

SELECT * FROM actor 
WHERE first_name LIKE "%O%" AND last_name LIKE "%A%"
;

-- 5. Actores que contengan dos ‘O’ en su nombre y en una ‘A’ en su apellido.

SELECT * FROM actor
WHERE first_name LIKE "%O%O" AND last_name LIKE "%A%"
;

-- 6. Actores donde su tercera letra sea ‘B’.

SELECT * FROM actor
WHERE first_name LIKE "__B%"
;

-- 7. Ciudades que empiezan por ‘a’.

SELECT * FROM city 
WHERE city LIKE "a%"
;

-- 8. Ciudades que acaban por ‘s’.

SELECT * FROM city
WHERE city LIKE "%s"
;

-- 9. Ciudades del country 61.

SELECT * FROM city
WHERE country_id = 61
;

-- 10. Ciudades del country ‘Spain’.

SELECT * FROM city
WHERE country_id = (SELECT country_id FROM country WHERE country = "Spain")
;

-- 11. Ciudades con nombres compuestos.

SELECT * FROM city
WHERE city LIKE "% %"
;

-- 12. Películas con una duración entre 80 y 100.

SELECT * FROM film
WHERE length BETWEEN 80 AND 100
;

-- 13. Películas con un rental_rate entre 1 y 3.

SELECT * FROM film
WHERE rental_rate BETWEEN 1 AND 3
;

-- 14. Películas con un titulo de más de 12 letras.

SELECT * FROM film
WHERE length(title) > 12
;

-- 15. Películas con un rating de PG o G.

SELECT * FROM film
WHERE rating = "PG" OR rating ="G"
;

-- 16. Películas que no tengan un rating de NC-17.

SELECT * FROM film
WHERE rating <> "NC-17"
;

-- 17. Películas con un rating PG y duracion de más de 120.

SELECT * FROM film
WHERE rating = "PG" AND length > 120
;

-- 18. ¿Cuantos actores hay?

SELECT COUNT(actor_id) AS "Nº actores" FROM actor;

-- 19. ¿Cuantas ciudades tiene el country ‘Spain’?

SELECT COUNT(city_id) AS "Nº Ciudades España" FROM city
WHERE country_id = (SELECT country_id FROM country WHERE country = "Spain")
;

-- 20. ¿Cuantos countries hay que empiezan por ‘a’?

SELECT COUNT(country_id) AS "Nº países A" FROM country
WHERE country LIKE "A%"
;

-- 21. Media de duración de películas con PG.

SELECT ROUND(AVG(length),2) AS "Media duración películas PG"  FROM film
WHERE rating = "PG"
;

-- 22. Suma de rental_rate de todas las películas.

SELECT SUM(rental_rate) AS "Suma de rental_rate" FROM film;

-- 23. Película con mayor duración.

SELECT * FROM film
WHERE length = (SELECT MAX(length) from film)
LIMIT 1
;

-- 24. Muestra el nombre y apellido de todos los actores.

SELECT first_name, last_name FROM actor;

-- 25. Muestra el nombre y apellido de cada actor en una sola columna, en mayúscula. Nombra la columna "Nombre del actor".

SELECT CONCAT(first_name, " ", last_name) AS "Nombre del actor" FROM actor;

-- 26. Muestra el ID, nombre y apellido de un actor, de quien solo tienes el nombre "Joe".

SELECT actor_id, first_name, last_name FROM actor
WHERE first_name = "JOE"
;

-- 27. Encuentra los actores cuyo apellido contenga "GEN".

SELECT * FROM actor
WHERE last_name LIKE "%GEN%"
;

-- 28. Encuentra los actores cuyo apellido contenga "LI". Ordena las filas por apellido y nombre (en ese orden).

SELECT * FROM actor
WHERE last_name LIKE "%LI%"
ORDER BY last_name, first_name
;

-- 29. Usando la función IN, muestra el nombre y apellido de todos los clientes llamados "Terry", "Jessie" o "Alice".

SELECT first_name, last_name FROM customer
WHERE first_name IN ("Terry", "Jessie", "Alice")
;

-- 30. Muestra el apellido de cada actor y la cantidad de actores que tienen ese apellido

SELECT last_name, COUNT(actor_id) AS "Numero" FROM actor
GROUP BY last_name
;

-- 31. Muestra el apellido y la cantidad de actores que tienen ese apellido, pero solo los apellidos compartidos por dos o más actores.

SELECT last_name, COUNT(last_name) FROM actor
GROUP BY last_name
HAVING COUNT(last_name) >= 2
;

-- 32. Usando joins, muestra el nombre, apellido y dirección de cada miembro del staff.

SELECT first_name, last_name, a.address FROM staff s
INNER JOIN address a
ON a.address_id = s.address_id
;

-- 33. Muestra el total de dinero recaudado por cada empleado durante agosto del 2005.

SELECT first_name AS "Empleado", SUM(amount) AS "Dinero recaudado en (€)" FROM payment p
INNER JOIN staff s 
ON p.staff_id = s.staff_id
WHERE p.payment_date LIKE "2005-08%"
GROUP BY first_name
;

-- 34. Despliega la cantidad de actores por cada película.

SELECT f.title, COUNT(actor_id) AS "Nº de actores" from film_actor fa
INNER JOIN film f
ON f.film_id = fa.film_id
GROUP BY fa.film_id
;

-- 35. ¿Cuántas copias hay inventariadas en el sistema de la película "Hunchback Impossible"?

SELECT COUNT(inventory_id) AS "Nº de copias de Hunchback Impossible" FROM inventory
WHERE film_id = (SELECT film_id FROM film WHERE title = "Hunchback Impossible")
;

-- 36. Muestra el total de dinero pagado por cada cliente, solo si ha realizado compras. Ordena los clientes por apellido de forma ascendente.

SELECT first_name, last_name, SUM(amount) AS "Dinero gastado" FROM payment p
INNER JOIN customer c
ON c.customer_id = p.customer_id
GROUP BY c.customer_id
ORDER BY last_name 
;

-- 37. Se debe realizar una campaña de marketing en Canada. Para esto necesitas el nombre y correo electrónico de todos los clientes canadienses.

SELECT first_name, last_name, email from customer
WHERE address_id IN (SELECT address_id FROM address WHERE city_id IN
(SELECT city_id FROM city WHERE country_id IN 
(SELECT country_id FROM country WHERE country ="Canada")))
;

-- 38. Identifica todas las películas categorizadas como familiares (categoría "family").

SELECT * FROM film
WHERE film_id IN (SELECT film_id FROM film_category WHERE category_id IN 
(SELECT category_id FROM category WHERE name = "Family"))
;

-- 39. Muestra las películas más arrendadas en orden descendente.

SELECT title, COUNT(r.inventory_id) AS "Nº veces arrendada" FROM film f
INNER JOIN inventory i
ON f.film_id = i.film_id
INNER JOIN rental r
ON i.inventory_id = r.inventory_id
GROUP BY f.title
ORDER BY COUNT(i.film_id) DESC
;

-- 40. Despliega el dinero recaudado por cada tienda.

SELECT t.store_id AS "Tienda", SUM(p.amount) AS "Dinero recaudado" FROM store t
INNER JOIN staff s 
ON t.store_id = s.store_id
INNER JOIN payment p
ON s.staff_id = p.staff_id
GROUP BY Tienda;