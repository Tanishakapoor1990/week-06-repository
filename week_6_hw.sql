/* 1) Show all customers whose last names start with T. Order them by first name from A-Z
I have used  Like operator in the where clause of the select statement in order to filter out rows based on pattern. 
The percent sign (%) represents zero, one, or multiple characters.SO, in query we have used T% which will give 
us all records starting with T and I have further sorted the data using Order by clause on first_name column.
This is the following query that we will use:
SELECT * 
FROM customer
WHERE last_name LIKE 'T%'
ORDER BY first_name;*/


/* 2) Show all rentals returned from 5/28/2005 to 6/1/2005
For finding all rentals between a given date rangeI have used  Between in the where clause.Date format in sql
is year/month/day.
This is the following query that we will use:
SELECT * 
FROM rental
WHERE rental_date BETWEEN '2005/05/28' AND '2005/06/01'*/


/* 3)How would you determine which movies are rented the most
I have used  film > inventory > rental tables and then used joins, group by and order by clause for fetching records.
Firstly, we have joined film and inventory table on film_id 
where film_id  is the the primary key for film table.Then we have further joined inventory and rental by inventory_id which
is the foreign key in rental table and primary key for inventory table.Further, grouped the data using group by clause.
This is the following query that we will use */
/*SELECT film.title , count(film.rental_duration) AS "Most Rented"
FROM film
JOIN inventory
ON film.film_id=inventory.film_id
JOIN rental
ON inventory.inventory_id=rental.inventory_id
GROUP BY film.film_id
ORDER BY count(film.rental_duration) desc;*/


/*4) Show how much each customer spent on movies (for all time) . Order them from least to most
For this we have used (customer --> payment) tables and then used joins to fetch records from these two tables.
For customer table, customer_id is the primary key which acts as the  as the foreign key for payment table.So,
we have joined both the table on this common key.To show how much each customer spent on movies we have used aggregate 
function sum on amount column of payment table.I have laso used concat for joining first name and ast name as full name. 
This is the following query that we will use:*/
/*SELECT A.customer_id, concat(A.first_name,' ',A.last_name) AS Full_name, sum(B.amount) as Spendings
FROM customer as A  
INNER JOIN payment as B
ON A.customer_id=B.customer_id 
GROUP BY A.customer_id 
ORDER BY sum(B.amount);*/

/* 5)  Which actor was in the most movies in 2006 (based on this dataset)?
Be sure to alias the actor name and count as a more descriptive name. 
Order the results from most to least.

film --> film_actor --> actor tables are used to answer this query. In order to fetch records from multiple tables we have 
joined them using Joins.Then I have given actor name and count an alias name. Alias is a temporary name and it
makes the code more readable.For further soring the data I have used order by clause and concat for joining actor
first and last name.
This is the following query that we have used*/

/*SELECT count(film.title) As movies_done, 
concat(actor.first_name,' ',actor.last_name)as Actor_fullname ,film.release_year
FROM film
INNER JOIN  film_actorfdf
ON film.film_id=film_actor.film_id
INNER JOIN actor
ON film_actor.actor_id=actor.actor_id
GROUP BY film.release_year , actor.first_name, actor.last_name
HAVING film.release_year=2006
ORDER BY count(film.title) desc
FETCH FIRST 1 ROWS ONLY;*/

/* 6) 6.Write an explain plan for 4 and 5.
Show the queries and explain what is happening in each one.
Explained above with queries*/

/* 7) What is the average rental rate per genre
For this we have used category > film_category > film table .For further analysis we have used joins and group by clause.
GROUP BY statement is often used with aggregate functions.*/

/*SELECT C.name , round(avg(F.rental_rate),2) As "Average Rental Rate"
FROM category As C
JOIN film_category As FC
ON C.category_id=FC.category_id
JOIN film As F
ON FC.film_id=F.film_id
GROUP BY C.category_id
ORDER BY 2 DESC;*/

/*8) How many films were returned late? Early? On time
For this we have used the case syntax.Case goes through conditionsand returns value when the first condition is met.
If no conditions are true it returns the value in the else clause.
We have also used datepart() in our sql query to fetch the number of days. From the table, it can be deduced that a higher
percentage of movies are returned before the rental duration ends and also a significant percentage of films are 
returned late..*/

/*SELECT CASE
        WHEN rental_duration > date_part('day', return_date-rental_date)THEN 'Returned Early'
        WHEN rental_duration = date_part('day' , return_date-rental_date)THEN 'Returned on time'
		ELSE 'Returned Late'
		END AS status_of_return,
		COUNT(*) AS total_no_of_films
		FROM film
		INNER JOIN inventory 
		ON film.film_id=inventory.film_id
		INNER JOIN rental
		ON inventory.inventory_id=rental.inventory_id
		GROUP BY 1
		ORDER BY 2 DESC;*/
  

/* 9) What categories are the most rented and what are their total sales
category > film_category > film > inventory > rental > customer
The sports category is the most sought thus providing 
more profit in terms of sale for the store, this info can really help the team ensure they don't run out of stock*/

/*SELECT c.name AS Categories , COUNT(cust.customer_id) AS "total demand" , 
SUM(p.amount) AS "total sales"
FROM Category c 
INNER JOIN Film_category fc
ON c.category_id=fc.category_id
INNER JOIN  film f
on fc.film_id=f.film_id
INNER JOIN inventory i 
ON f.film_id=i.film_id
INNER JOIN  rental r
ON i.inventory_id=r.inventory_id
INNER JOIN  customer cust
on r.customer_id=cust.customer_id
INNER JOIN  payment p
ON r.rental_id=p.rental_id
GROUP BY c.category_id
ORDER BY COUNT(cust.customer_id)desc;*/


/* 10) Create a view for 8 and a view for 9. Be sure to name them appropriately. 
VIew For films returned late Early and  On time*/
/*CREATE VIEW Movies_Return_Stats AS
SELECT CASE
        WHEN rental_duration > date_part('day', return_date-rental_date)THEN 'Returned Early'
        WHEN rental_duration = date_part('day' , return_date-rental_date)THEN 'Returned on time'
		ELSE 'Returned Late'
		END AS status_of_return,
		COUNT(*) AS total_no_of_films
		FROM film
		INNER JOIN inventory 
		ON film.film_id=inventory.film_id
		INNER JOIN rental
		ON inventory.inventory_id=rental.inventory_id
		GROUP BY 1
		ORDER BY 2 DESC;
SELECT * FROM Movies_Return_Stats ;*/

/* View for categories that are most rented and their total sales*/
/*CREATE VIEW Movies_RentSale_Stats AS
SELECT c.name AS Categories , COUNT(cust.customer_id) AS "total demand" , SUM(p.amount) AS "total sales"
FROM Category c 
INNER JOIN Film_category fc
ON c.category_id=fc.category_id
INNER JOIN  film f
on fc.film_id=f.film_id
INNER JOIN inventory i 
ON f.film_id=i.film_id
INNER JOIN  rental r
ON i.inventory_id=r.inventory_id
INNER JOIN  customer cust
on r.customer_id=cust.customer_id
INNER JOIN  payment p
ON r.rental_id=p.rental_id
GROUP BY c.category_id
ORDER BY COUNT(cust.customer_id)desc;

SELECT * FROM Movies_RentSale_Stats ;*/

--Bonus Questions
/*11) Write a query that shows how many films were rented each month. Group them by category and month*/ 

/*SELECT
    DATE_PART('MONTH', rental_date) months,
    c.name AS Genre,
    COUNT(*) AS Filmsrented
FROM category c 
JOIN film_category fc 
  ON c.category_id =fc.category_id
JOIN film f
  ON fc.film_id = f.film_id
JOIN inventory i 
  ON f.film_id=i.film_id
JOIN rental r 
  ON i.inventory_id=r.inventory_id
GROUP BY 1,2;*/



		
