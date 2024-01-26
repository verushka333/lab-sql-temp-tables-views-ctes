Use sakila;

## Creating a Customer Summary Report

## In this exercise, you will create a customer summary report that summarizes key information about customers in the Sakila database, 
## including their rental history and payment details. The report will be generated using a combination of views, CTEs, and temporary tables.

## Step 1: Create a View
## First, create a view that summarizes rental information for each customer. The view should include the customer's ID, name, email address, and total number of rentals (rental_count).

CREATE VIEW rental_summary_lab AS
SELECT
	customer.customer_id,
	concat(first_name, ' ', last_name) as name,
	email,
	COUNT(rental_id) as rental_count
FROM 
	customer
join 
	rental on rental.customer_id = customer.customer_id
group by 
	customer.customer_id;
    
## Step 2: Create a Temporary Table
## Next, create a Temporary Table that calculates the total amount paid by each customer (total_paid). 
## The Temporary Table should use the rental summary view created in Step 1 to join with the payment table and calculate the total amount paid by each customer.

CREATE TEMPORARY TABLE customer_payment_summary AS 
select 
	rental_summary_lab.customer_id,
	name,
	email,
	rental_count,
	SUM(amount) as total_paid
from rental_summary_lab 
Join payment on payment.customer_ID = rental_summary_lab.customer_ID
group by payment.customer_ID;


## Step 3: Create a CTE and the Customer Summary Report
## Create a CTE that joins the rental summary View with the customer payment summary Temporary Table created in Step 2. 
## The CTE should include the customer's name, email address, rental count, and total amount paid.

## Next, using the CTE, create the query to generate the final customer summary report, which should include: customer name, email, rental_count, total_paid 
## and average_payment_per_rental, this last column is a derived column from total_paid and rental_count.

with final_customer_summary_report as (
SELECT AVG(total_paid/rental_count) AS average_payment_per_rental
    FROM customer_payment_summary
)
select 
	customer_id,
	name,
	email,
	rental_count,
	total_paid
from customer_payment_summary;
