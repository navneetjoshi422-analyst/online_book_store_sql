CREATE TABLE Books (
    Book_ID SERIAL PRIMARY KEY,
    Title VARCHAR(100),
    Author VARCHAR(100),
    Genre VARCHAR(50),
    Published_Year INT,
    Price NUMERIC(10, 2),
    Stock INT
);
CREATE TABLE Customers (
    Customer_ID SERIAL PRIMARY KEY,
    Name VARCHAR(100),
    Email VARCHAR(100),
    Phone VARCHAR(15),
    City VARCHAR(50),
    Country VARCHAR(150)
);
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

-- 1) Retrieve all books in the "Fiction" genre:
select * from Books 
where genre='Fiction';


-- 2) Find books published after the year 1950:
select * from Books
where published_year>1950
order by published_year;

-- 3) List all customers from the Canada:
select * from customers
where country='Canada';

-- 4) Show orders placed in November 2023:
select * from orders 
where order_date between '2023-11-01' and '2023-11-30'; 

-- 5) Retrieve the total stock of books available:
select sum(stock) as total_books from books;

-- 6) Find the details of the most expensive book:
select * from books
order by price desc limit 1;

-- 7) Show all customers who ordered more than 1 quantity of a book:
select * from orders 
where quantity>1
order by quantity desc;

-- 8) Retrieve all orders where the total amount exceeds $20:
select * from orders 
where total_amount>20
order by total_amount desc;

-- 9) List all genres available in the Books table:
SELECT DISTINCT genre FROM Books;

select distinct genre,count(title) from books
group by genre;

-- 10) Find the book with the lowest stock:
select * from books
order by stock limit 5;

-- 11) Calculate the total revenue generated from all orders:
select sum(total_amount) 
as total_revenue from orders;
-- Advance Questions : 

-- 1) Retrieve the total number of books sold for each genre:

select b.genre,sum(o.quantity) AS Total_Books_sold from
books b
join orders o
on b.book_id = o.book_id
group by b.genre;


-- 2) Find the average price of books in the "Fantasy" genre:

select genre, round(avg(price),2) as Average_Price from books
where genre = 'Fantasy'
group by genre
;

-- 3) List customers who have placed at least 2 orders:

select c.name, count(order_id) as total from
orders o
join customers c
on o.customer_id= c.customer_id
group by c.name
having count(order_id) >=2
order by total ;

-- 4) Find the most frequently ordered book:

SELECT o.Book_id, b.title, COUNT(o.order_id) as ORDER_COUNT
from orders o
join books b
on o.book_id = b.book_id
group by o.Book_id,b.title
ORDER BY ORDER_COUNT DESC LIMIT 1
;


-- 5) Show the top 3 most expensive books of 'Fantasy' Genre :

select * from books
where genre = 'Fantasy'
order by price desc
limit 3 ;


-- 6) Retrieve the total quantity of books sold by each author:

select b.author , sum(o.quantity) as qty from books b
join orders o
on b.book_id = o.book_id
group by b.author;


-- 7) List the cities where customers who spent over $30 are located:

select distinct c.city , total_amount as total from orders o
join customers c
on c.customer_id = o.customer_id
WHERE o.total_amount > 30;

-- 8) Find the customer who spent the most on orders:

select distinct c.customer_id,c.name ,sum(o.total_amount) as total_spent from orders o
join customers c
on c.customer_id = o.customer_id
GROUP BY c.customer_id, c.name
ORDER BY Total_spent Desc LIMIT 1;

--9) Calculate the stock remaining after fulfilling all orders:

select b.book_id, b.title, b.stock, COALESCE(SUM(o.quantity),0) AS Order_quantity,  
	b.stock- COALESCE(SUM(o.quantity),0) AS Remaining_Quantity
from books b
left join orders o
on b.book_id = o.book_id 
group by b.book_id
order by b.book_id;
