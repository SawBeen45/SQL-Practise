USE SAKILA;

-- Q1. Display all available tables in Sakila Database.alter

SHOW TABLES;

-- Q2. Display structure of table "actor".

SELECT * FROM ACTOR;

-- Q3. Diisplay the schema which was used to create the table "actor" and view the complete schema.

DESCRIBE ACTOR;

-- (USING VIEW)

CREATE VIEW ACTOR_V1 AS SELECT * FROM ACTOR;
SELECT * FROM ACTOR_V1;

-- Q4. Display the first and last name of all actors from the table "actor". [50 rows]

SELECT FIRST_NAME, LAST_NAME FROM ACTOR LIMIT 50;

-- Q5. Which actors have the last name 'Johansson'

SELECT FIRST_NAME FROM ACTOR WHERE LAST_NAME = "JOHANSSON";

-- Q6. Display the first and the last name of each actor in a single coulumn in upper case letters. Name the column as "Actor Name".

SELECT CONCAT(FIRST_NAME, ' ', LAST_NAME) AS 'ACTOR NAME' FROM ACTOR;
-- Q7. You need to find the ID number, first name and last name of an actor of whom you know only the first name as "Joe".

SELECT ACTOR_ID, FIRST_NAME, LAST_NAME FROM ACTOR WHERE FIRST_NAME = 'JOE'; 

-- Q8. Query to check which last names are not repeated.

SELECT LAST_NAME FROM ACTOR GROUP BY LAST_NAME HAVING COUNT(*)=1;

-- Q9. Which last names appear more than once? 
SELECT LAST_NAME, COUNT(*) AS COUNT FROM ACTOR GROUP BY LAST_NAME HAVING COUNT>1;
-- Q10. Which actor has appeared in the most films
select actor.actor_id, actor.first_name, actor.last_name,
       count(actor_id) as film_count
from actor join film_actor using (actor_id)
group by actor_id
order by film_count desc
limit 1;

-- Q11. Is ‘Academy Dinosaur’ available for rent from Store 1?
SELECT * FROM INVENTORY;

select film.film_id, film.title, store.store_id, inventory.inventory_id
from inventory join store using (store_id) join film using (film_id)
where film.title = 'Academy Dinosaur' and store.store_id = 1;

select inventory.inventory_id
from inventory join store using (store_id)
     join film using (film_id)
     join rental using (inventory_id)
where film.title = 'Academy Dinosaur'
      and store.store_id = 1
      and not exists (select * from rental
                      where rental.inventory_id = inventory.inventory_id
                      and rental.return_date is null);


-- Q12. Insert a record to represent Mary Smith renting ‘Academy Dinosaur’ from Mike Hillyer at Store 1 today .
Insert into rental (rental_date, inventory_id, customer_id, staff_id)
values (NOW(), 1, 1, 1);

-- Q14. What is that average running time of all the films in the sakila DB BY CATEGORY?
select category.name, avg(length)
from film join film_category using (film_id) join category using (category_id)
group by category.name
order by avg(length) desc;

-- Q13. What is that average running time of all the films in the sakila DB?

select category.name, avg(length)
from film join film_category using (film_id) join category using (category_id)
group by category.name
having avg(length) > (select avg(length) from film)
order by avg(length) desc;
