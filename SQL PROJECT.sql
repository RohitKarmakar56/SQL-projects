--Creating a table of books

DROP TABLE IF EXISTS books;

CREATE TABLE books(
		book_id SERIAL PRIMARY KEY,
		title VARCHAR(100),
		author VARCHAR(100),
		genre VARCHAR(100),
		published_year INT,
		price NUMERIC(10,2),
		stock INT
);

--CREATING TABLE OF Customers
DROP TABLE IF EXISTS customers;

CREATE TABLE customers(
			customer_id SERIAL PRIMARY KEY,
			name varchar(50),
			email varchar(100),
			phone INT,
			city VARCHAR(100),
			country varchar(100)
);

--Creating a table of Orders
DROP TABLE IF EXISTS orders;

CREATE TABLE orders(
			order_id SERIAL PRIMARY KEY,
			customer_id INT REFERENCES customers(customer_id),
			book_id INT REFERENCES books(book_id),
			order_date DATE,
			quantity INT,
			total_amount NUMERIC(10,2)
);

SELECT * FROM books;
SELECT * FROM customers;
SELECT * FROM orders;

--Importing CSV file into books table 

COPY
books(book_id,title,author,genre,published_year,price,stock)
FROM 'H:\Books.csv'
CSV HEADER;

--Importing CSV file into customers table

COPY 
customers(customer_id,name,email,phone,city,country)
FROM '‪H:\Customers.csv'
CSV HEADER;

--Importing CSV file into orders table

COPY
orders(order_id,customer_id,book_id,order_date,quantity,total_amount)
FROM 'H:\Orders.csv'
CSV HEADER;

--Basic Questions:

--1.Retrive all books in the "Fiction" genre

SELECT book_id,title,author,genre
FROM books
WHERE genre='Fiction';

--2.Find the books where published after 1989

SELECT title,author,published_year
FROM books
WHERE published_year>1989;

--3.List all customers from CANADA

SELECT name,country
FROM customers
WHERE country='Canada';

--4.Show order placed in nov.23

SELECT order_id,quantity,total_amount,order_date
FROM orders
WHERE order_date BETWEEN '2023-11-01' AND '2023-11-30';

--5.Retrive the total stock of book avaliable

SELECT SUM(stock) AS total_stock_of_book
FROM books;

--6.Find the details of most expensive book

SELECT MAX(price) AS most_expensive_book
FROM books;
--OR
SELECT * FROM books
ORDER BY price DESC;

--7.Show all customers who ordered books more than 1

SELECT * FROM orders
WHERE quantity>1;

--8.Retrive all orders when total amount exceeds $20

SELECT * FROM orders
WHERE total_amount>20;

--9.List all genre avaliable in books table

SELECT DISTINCT genre FROM books;

--10.Find the book with the lowest stock

SELECT * FROM books 
ORDER BY stock;

--11.Calculate the total revenue generate from orders 

SELECT SUM(total_amount) AS total_revenew_generate
FROM orders;

--Advanced Questions

-- 1) Retrieve the total number of books sold for each genre:

SELECT b.genre,SUM(o.quantity) AS total_books_sold
FROM books b
JOIN orders o
ON b.book_id=o.book_id
GROUP BY b.genre;

-- 2) Find the average price of books in the "Fantasy" genre:

SELECT * FROM books;

SELECT AVG(price) AS average_price,
genre
FROM books 
WHERE genre='Fantasy'
GROUP BY genre;

-- 3) List customers who have placed at least 2 orders:

SELECT * FROM orders;
SELECT * FROM customers;

SELECT o.customer_id,c.name,count(o.order_id) AS order_count
FROM customers c
JOIN orders o
ON c.customer_id=o.customer_id
GROUP BY o.customer_id,c.name
HAVING COUNT(order_id)>=2;

-- 4) Find the most frequently ordered book:

SELECT o.book_id,b.title,COUNT(o.order_id) AS frequently_ordered_book
FROM orders o
JOIN 
books b
ON b.book_id=o.book_id
GROUP BY o.book_id,b.title
ORDER BY frequently_ordered_book DESC
LIMIT 1;

-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :

SELECT * FROM books;

SELECT title,genre,price
FROM books 
WHERE genre='Fantasy'
ORDER BY price DESC
LIMIT 3;

-- 6) Retrieve the total quantity of books sold by each author:

SELECT b.author,SUM(o.quantity) AS total_books_sold
FROM books b
JOIN orders o
ON b.book_id=o.book_id
GROUP BY b.author;



-- 7) List the cities where customers who spent over $30 are located:

SELECT DISTINCT c.city,o.total_amount
FROM orders o
JOIN customers c
ON o.customer_id=c.customer_id
WHERE o.total_amount >30;

-- 8) Find the customer who spent the most on orders:

SELECT c.name,SUM(o.total_amount) AS most_orders
FROM orders o
JOIN customers c
ON o.customer_id=c.customer_id
GROUP BY c.name
ORDER BY most_orders DESC
LIMIT 1;

--9) Calculate the stock remaining after fulfilling all orders:

SELECT b.book_id,b.title,b.stock,COALESCE(SUM(o.quantity),0) AS ordered_stock,
b.stock - COALESCE(SUM(o.quantity),0) AS remaining_stock
FROM books b
LEFT JOIN 
orders o
ON b.book_id=o.book_id
GROUP BY b.book_id
ORDER BY b.book_id;