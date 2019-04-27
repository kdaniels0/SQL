-- Kenny Daniels
use sakila;

-- 1a
SELECT first_name, last_name
FROM actor;

-- 1b
SELECT Concat(first_name, " ", last_name) as Actor_name
from actor;

-- 2a
SELECT actor_id, first_name, last_name 
FROM actor
WHERE first_name="JOE";

-- 2b
SELECT *
FROM actor
WHERE last_name LIKE "%GEN%";

-- 2c
SELECT *
FROM actor
WHERE last_name LIKE "%LI%"
GROUP BY last_name, first_name;

-- 2d
SELECT country_id, country
FROM country
WHERE country IN ("Afghanistan", "Bangladesh", "China");

-- 3a
ALTER TABLE actor
ADD Description BLOB;

-- 3b
ALTER TABLE actor
DROP Description;

-- 4a
SELECT last_name, count(*)
FROM actor
GROUP BY last_name;

-- 4b
SELECT last_name, count(last_name)
FROM actor
GROUP BY last_name
HAVING count(last_name)>1;

-- 4c
UPDATE actor
SET first_name="HARPO"
WHERE first_name="GROUCHO" AND last_name="WILLIAMS";

-- 4d
SET SQL_SAFE_UPDATES = 0;
UPDATE actor
SET first_name="GROUCHO"
WHERE first_name="HARPO";

-- 5a
SHOW CREATE TABLE address;

-- 6a
SELECT staff.first_name, staff.last_name, address.address
FROM address
INNER JOIN staff ON staff.address_id = address.address_id;

-- 6b
SELECT first_name, last_name, payment.amount
FROM staff
INNER JOIN payment ON staff.staff_id = payment.staff_id
WHERE payment.payment_date LIKE "2005-08%"
GROUP BY staff.staff_id;

-- 6c
SELECT title, count(film_actor.film_id) as "Total Actors"
FROM film
INNER JOIN film_actor ON  film_actor.film_id = film.film_id
GROUP BY title;

-- 6d
select title,count(inventory.inventory_id) as "Total In Stock"
from film
inner join inventory on film.film_id = inventory.film_id
where title="Hunchback Impossible"
group by title;

-- 6e
select first_name, last_name, sum(payment.amount) as "Total Amount Paid"
from customer
inner join payment on payment.customer_id=customer.customer_id
group by last_name,first_name;

-- 7a
select title
from film
where language_id in (
	select language_id
    from language
    where name="english")
AND (title like "K%") or (title like "Q%");

-- 7b
select first_name, last_name
from actor
where actor_id in(
	select actor_id
	from film_actor
	where film_id in (
		select film_id
        from film
        where title="Alone Trip")
);

-- 7c
select first_name, last_name, email
from customer
join address on customer.address_id=address.address_id
join city on city.city_id=address.city_id
join country on country.country_id=city.country_id
where country="Canada";

-- 7d
select title
from film
where film_id in (
	select film_id
    from film_category
    where category_id in (
		select category_id
        from category
        where name = "Family")
	);

-- 7e
select title, count(rental_id)
from rental
join inventory on (rental.inventory_id = inventory.inventory_id)
join film on (inventory.film_id = film.film_id)
group by film.title
order by count(rental_id) DESC;

-- 7f
select store.store_id, sum(payment.amount)
from store
join staff on staff.store_id = store.store_id
join payment on staff.staff_id=payment.staff_id
group by store_id;

-- 7g
select store.store_id, city.city, country.country
from store
join address on address.address_id = store.address_id
join city on address.city_id=city.city_id
join country on country.country_id=city.country_id
group by store.store_id;

-- 7h
select name, sum(payment.amount) Revenue
from category
join film_category on film_category.category_id=category.category_id
join inventory on inventory.film_id = film_category.film_id
join rental on rental.inventory_id = inventory.inventory_id
join payment on rental.rental_id = payment.rental_id
group by name
order by Revenue
limit 5;

-- 8a
create view category_rev as
select name, sum(payment.amount) Revenue
from category
join film_category on film_category.category_id=category.category_id
join inventory on inventory.film_id = film_category.film_id
join rental on rental.inventory_id = inventory.inventory_id
join payment on rental.rental_id = payment.rental_id
group by name
order by Revenue
limit 5;

-- 8b
select * from category_rev;

-- 8c
drop view category_rev;