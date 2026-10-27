DROP TABLE IF EXISTS Books;
CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);
DROP TABLE IF EXISTS customers;
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);
DROP TABLE IF EXISTS orders;
CREATE TABLE Orders (
    Order_ID SERIAL PRIMARY KEY,
    Customer_ID INT REFERENCES Customers(Customer_ID),
    Book_ID INT REFERENCES Books(Book_ID),
    Order_Date DATE,
    Quantity INT,
    Total_Amount NUMERIC(10, 2)
);

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

copy Books( Book_ID, Title, Author, Genre, Published_Year,Price,Stock)
from 'D:\30 Day - SQL Practice Files\Books.csv'
delimiter ','
csv header;

copy Customers(Customer_ID ,Name,Email, Phone,City, Country)
from 'D:\30 Day - SQL Practice Files\Customers.csv'
delimiter ','
csv header;

copy Orders(Order_ID,Customer_ID,Book_ID, Order_Date,Quantity, Total_Amount)
from 'D:\30 Day - SQL Practice Files\Orders.csv'
delimiter ','
csv header;

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;


-- 1) Retrieve all books in the "Fiction" genre:
SELECT * FROM Books
WHERE genre = 'Fiction';


-- 2) Find books published after the year 1950
SELECT * FROM Books
WHERE Published_Year>=1950;

 --3) List all customers from the Canada:
 SELECT * FROM  Customers
 WHERE country = 'Canada';

 -- 4) Show orders placed in November 2023:
SELECT * FROM Orders
WHERE order_date between '2023-11-01' AND '2023-11-30';

---- 5) Retrieve the total stock of books available:
SELECT SUM(price) as total_stock_books
FROM Books;

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;

-- 6) Find the details of the most expensive book:
SELECT * FROM Books
ORDER BY price desc
limit 1;

--7) Show all customers who ordered more than 1 quantity of a book:
SELECT * FROM Orders
where quantity>4;
 


-- 8) Retrieve all orders where the total amount exceeds $20:
SELECT * FROM  Orders
where total_amount>=20;

-- 9) List all genres available in the Books table:
SELECT DISTINCT genre as list_books
FROM Books;

--10find the lowest books with lowest stock
SELECT * FROM Books
ORDER BY stock asc
limit 1;

--11 calculate the total revenue from all orders
SELECT order_id,
sum(total_amount) as total_reveunue
FROM Orders
GROUP BY order_id
ORDER BY total_reveunue desc;

SELECT * FROM Books;
SELECT * FROM Customers;
SELECT * FROM Orders;
--ADVANCE QUESRIES
--12 RETRTIVE THE NUMBER OF BOOKS SOLD FOR EACH GENRE
SELECT  b.genre,sum(o.quantity) as total_qunatity
FROM Books b
JOIN Orders o
on o.order_id=b.book_id
GROUP BY b.genre;

--13 FIND THE AVERGE OF PRICE OF BOOKS IN THE GENRE FANTASY
SELECT avg(price)  as total_price
FROM Books
WHERE genre  = 'Fantasy';

--14 List customers who have placed at least 2 orders:
SELECT o.customer_id,c.name,
count(o.order_id) as customer_2_orders
FROM Orders o
JOIN Customers c
ON c.customer_id=o.customer_id
GROUP BY o.customer_id,c.name
HAVING count(o.order_id)>2;

--15FIND THE most freuentl orders book
SELECT o.book_id,b.title,
count(o.order_id) as order_count
FROM Orders o
JOIN Books b
ON b.book_id = o.book_id
GROUP BY  o.book_id,b.title
ORDER BY order_count DESC
LIMIT 1;

--16  Show the top 3 most expensive books of 'Fantasy' Genre 
SELECT * FROM Books
where genre = 'Fantasy'
ORDER BY price DESC
LIMIT 3;

--1 7) Retrieve the total quantity of books sold by each author:
SELECT b.author,
sum(o.quantity) as total_bokk_sold
FROM Books b
JOIN Orders o
on o.book_id=b.book_id
GROUP BY b.author
ORDER BY  total_bokk_sold desc;


--18 list the cities  where cutumer spend over 30 $ are located
SELECT DISTINCT c.city,total_amount
FROM Orders o
JOIN Customers c
ON o.customer_id=c.customer_id
WHERE o.total_amount>250;

--19 find the customer who spen the most orders
SELECT c.customer_id,c.name,
sum(o.total_amount) as total_sepnt
FROM Customers c
JOIN Orders o
ON o.customer_id = c.customer_id
GROUP BY c.customer_id,c.name
ORDER BY total_sepnt DESC
LIMIT 3;


--20 Calculate the stock remaining after fullfill all orders
SELECT b.book_id,title,b.stock,
COALESCE (sum(o.quantity),0) as total_qunatoty,
b.stock - COALESCE(sum(o.quantity),0) as remaining_stock
FROM Books b
left JOIN Orders o
ON b.book_id = o.book_id
GROUP BY b.book_id,b.title,b.stock
ORDER BY b.book_id desc;


