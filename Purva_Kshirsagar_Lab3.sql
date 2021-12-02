--1 For the first statement in the .SQL file, specify which database should be queried with a USE statement.  

use sunshine

--2 Write a statement that returns all orders (displaying order_id and order_date) and the first name and last name of the employee that took each order.


SELECT order_header.order_id,order_header.order_date,employee.fname,employee.lname FROM order_header INNER JOIN employee
ON order_header.taken_by_employee_id=employee.employee_id


--3 Write a statement that returns each product_order and the name and price of the product purchased.  Also create a product_order_total column that is equivalent to the price times the quantity.  Sort from lowest to highest product_order_total.


SELECT product.name,product.price,product_order.quantity,product.price*product_order.quantity as 'product_order_total' FROM product_order INNER JOIN product ON
product_order.product_id=product.product_id  ORDER BY product_order.quantity,product.price*product_order.quantity


--4 Write a statement that returns the number of orders taken by each employee
--and display the employees' id, first name, and last name.  Sort by last name and then first name, and alias the calculated column appropriately.


SELECT employee.employee_id,employee.fname,employee.lname,count(order_header.order_id) FROM order_header INNER JOIN employee ON
order_header.taken_by_employee_id=employee.employee_id GROUP BY employee.employee_id,employee.fname,employee.lname ORDER BY employee.lname,employee.fname

--5 Write a statement that returns a list of states from which orders were placed in November 2018 and how many orders have been placed from each state. Sort from high to low based on the number of orders from each state.  

SELECT customer.xstate,count(order_header.order_id) FROM customer INNER JOIN order_header ON 
customer.customer_id=order_header.customer_id WHERE (year(order_header.order_date)=2018 and month(order_header.order_date)=11)
GROUP BY customer.xstate ORDER BY count(order_header.order_id) DESC


--6 Prepare a query that shows each product name, it’s current price, and the clearance price, which is 50% off the current price, and the total quantity sold of each product.  
--Name columns as needed and sort the products from lowest clearance price to highest clearance price.

SELECT product.name,product.price,product.price*.5 as 'clearanceprice' ,sum(product_order.quantity) as 'total quantity sold' FROM product_order 
INNER JOIN product ON product_order.product_id=product.product_id GROUP BY product.name,product.price,product.price*.5

--7 Write a query that returns the order id, order_date, and the total for each order.  Order total is defined as the sum of the price times the quantity.  
--Sort from highest to lowest order total.

SELECT  product_order.order_id,order_header.order_date,sum(product.price*product_order.quantity) as 'order total' FROM order_header INNER JOIN product_order ON
order_header.order_id=product_order.order_id 
JOIN Product ON product_order.product_id=product.product_id 
GROUP BY product_order.order_id,order_header.order_date ORDER BY  sum( product.price*product_order.quantity) DESC


--8 Prepare a query that returns the sum of the order totals for each month.  
--Order total is defined as the sum of the price times the quantity.  Sort chronologically.


SELECT year(order_header.order_date) as 'year',month(order_header.order_date) as 'month',sum(product.price*product_order.quantity) as 'order total' FROM order_header INNER JOIN product_order ON
order_header.order_id=product_order.order_id 
JOIN Product ON product_order.product_id=product.product_id 
 GROUP BY month(order_header.order_date), year(order_header.order_date) ORDER BY month(order_header.order_date)

--9 Prepare a query that determines which products sold a quantity less than 200 in either September or October of 2018.  Also report which month the quantity less than 100 sold occurred.  
--Use order_date for this analysis.


SELECT  month(order_header.order_date) as 'month', product.product_id,product.name,sum(product_order.quantity) FROM  order_header INNER JOIN product_order ON
order_header.order_id=product_order.order_id 
JOIN Product ON product_order.product_id=product.product_id WHERE (month(order_header.order_date) = 9 or month(order_header.order_date) =10)  
and year(order_header.order_date)=2018
GROUP BY product.product_id,product.name,month(order_header.order_date) 
HAVING ((sum(product_order.quantity) BETWEEN 100 and 200) OR
(sum(product_order.quantity) <100)) ORDER BY  month(order_header.order_date) desc 


--10 Write a query that returns bouquets that had a total quantity sold greater than 3000

SELECT product.product_id,product.name ,sum(product_order.quantity) as 'total quantity sold' FROM product_order INNER JOIN product ON 
product_order.product_id=product.product_id WHERE product.name like '%Bouquet%' GROUP BY product.product_id,product.name 
HAVING sum(product_order.quantity) >3000 


--11 Prepare a query that shows orders that meet AT LEAST ONE of the following criteria:
--	Has an order total greater than $1500 
--	Has a total quantity greater than 25.Sort the orders by order_date.


SELECT order_header.order_id,order_header.order_date,sum(product.price*product_order.quantity) as 'order total' ,sum(product_order.quantity) as 'order qty' FROM order_header INNER JOIN product_order
ON order_header.order_id=product_order.order_id 
JOIN Product ON product_order.product_id=product.product_id GROUP BY order_header.order_id,order_header.order_date 
HAVING (sum(product.price*product_order.quantity) > 1500 or sum(product_order.quantity) >25 )
order by order_header.order_id 


--12 Prepare a query that shows orders that meet ALL of the following criteria:
--	Has an order total greater than $1500
-- Has a total quantity greater than 25.Sort the orders by order_date.

SELECT order_header.order_id,order_header.order_date,sum(product.price*product_order.quantity) as 'order total' ,sum(product_order.quantity) as 'order qty' FROM order_header INNER JOIN product_order
ON order_header.order_id=product_order.order_id 
JOIN Product ON product_order.product_id=product.product_id GROUP BY order_header.order_id,order_header.order_date 
HAVING (sum(product.price*product_order.quantity) > 1500 and sum(product_order.quantity) >25 )
order by order_header.order_id 


--13 Specify which database should be queried with a USE statement.  

use chinook

--14 What artists (by name) are associated with more than 100 tracks? Sort alphabetically.

SELECT Artist.ArtistId, Artist.Name ,count(TrackId) as 'qty tracks' FROM Artist INNER JOIN ALBUM ON 
Artist.ArtistId=Album.ArtistId JOIN Track ON Album.AlbumId=Track.AlbumId GROUP BY Artist.ArtistId, Artist.Name HAVING count(TrackId) > 100
ORDER BY Artist.Name


--15 What artist has the most albums?


SELECT Top 1 Artist.ArtistId, Artist.Name ,count(distinct AlbumId) as 'qty albums' FROM (Artist INNER JOIN Album ON 
Artist.ArtistId=Album.ArtistId) GROUP BY Artist.ArtistId, Artist.Name ORDER BY count(distinct AlbumId) DESC


--16 What two countries have generated the highest total sales (use total column in the invoice table and country in the customer table)?

Select Top 2 customer.country,sum(invoice.Total) as 'Total sales' FROM (customer INNER JOIN invoice ON 
customer.customerId=invoice.customerId) GROUP BY customer.country
ORDER BY sum(invoice.Total) DESC

--17 During which month(s) in 2018 did the artists below collectively sell at least 10 tracks?
--Green Day
--Iron Maiden
--Pearl Jam
--Queen


SELECT month(invoice.invoiceDate),count(track.TrackId) as 'Total tracks' FROM(invoice INNER JOIN invoiceline ON
invoice.invoiceId=invoiceline.invoiceId INNER JOIN track ON invoiceline.TrackId=track.TrackId 
INNER JOIN Album ON Album.AlbumId=track.AlbumId
INNER JOIN Artist ON Artist.ArtistId=Album.ArtistId)  
WHERE year(invoice.invoiceDate)=2018  and artist.name in ('Green Day','Iron Maiden','Pearl Jam','Queen')  GROUP BY month(invoice.invoiceDate)
HAVING count(track.TrackId) > 10 



--18 What customers have purchased more than 35 tracks of mediatype MPEG audio file?  Sort by last name then first name.


SELECT customer.customerId,customer.FirstName,customer.LastName,count(track.TrackId) FROM(customer INNER JOIN invoice ON
customer.customerId=invoice.customerId INNER JOIN invoiceline ON invoiceline.invoiceId=invoice.invoiceId
INNER JOIN track ON invoiceline.TrackId=track.TrackId 
INNER JOIN mediatype ON mediatype.mediatypeId=track.mediatypeId)  
WHERE mediatype.Name ='MPEG audio file' GROUP BY customer.customerId,customer.FirstName,customer.LastName
HAVING count(track.TrackId) > 35 order by customer.LastName,customer.FirstName


--19 From what genre were tracks purchased most often in 2018?

SELECT Top 1 Genre.GenreId,Genre.Name,count(track.TrackId) as 'Total tracks' FROM(invoice INNER JOIN invoiceline ON
invoice.invoiceId=invoiceline.invoiceId INNER JOIN track ON invoiceline.TrackId=track.TrackId 
INNER JOIN Album ON Album.AlbumId=track.AlbumId
INNER JOIN Artist ON Artist.ArtistId=Album.ArtistId
INNER JOIN Genre ON track.GenreId=Genre.GenreId)  
WHERE year(invoice.invoiceDate)=2018  GROUP BY Genre.GenreId,Genre.Name
ORDER BY count(track.TrackId) DESC


--20 What customers purchased from more than 5 genres in 2018?  

SELECT  customer.FirstName,customer.LastName ,count(distinct Genre.GenreId) as 'Total Genre' FROM(customer INNER JOIN invoice ON
customer.customerId=invoice.customerId INNER JOIN invoiceline ON
invoice.invoiceId=invoiceline.invoiceId INNER JOIN track ON invoiceline.TrackId=track.TrackId 
INNER JOIN Genre ON track.GenreId=Genre.GenreId)  
WHERE year(invoice.invoiceDate)=2018  GROUP BY customer.FirstName,customer.LastName HAVING count(distinct Genre.GenreId) > 5 



