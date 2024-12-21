USE ASSIGNMENT

SELECT *
FROM Album

SELECT *
FROM Artist

SELECT *
FROM Customer

SELECT *
FROM Employee

SELECT *
FROM Genre

SELECT *
FROM Invoice

SELECT *
FROM Invoice_Line

SELECT *
FROM Media_Type

SELECT *
FROM Playlist

SELECT *
FROM Playlist_Track

SELECT *
FROM Track

--- 1. Which countries have the most Invoices?

SELECT TOP 1 billingcountry, COUNT(invoiceid) AS Total_Invoice
FROM Invoice
GROUP BY billingcountry
ORDER BY Total_Invoice DESC

--- 2.	What City has the best Customer?

SELECT 
TOP 1 
billingcity, FORMAT (SUM(total), '#,##0.00') AS Total_order
FROM Invoice
GROUP BY billingcity
ORDER BY Total_order DESC

--- 3. Who is the best customer?

SELECT TOP 1 CONCAT(firstname, ' ',lastname) AS Full_Name, FORMAT( SUM(total), '#,##0.00')  AS Total_Order
FROM CUSTOMER AS C
JOIN Invoice AS I
ON C.customerid = I.customerid
GROUP BY CONCAT(firstname, ' ', lastname)
ORDER BY Total_Order DESC 

---4. Use your query to return the email, first name, last name, and Genre of all Rock Music listeners 
---(Rock & Roll would be considered a different category for this exercise). Return your list ordered alphabetically by email address starting with A.

SELECT DISTINCT C.firstname, C.lastname, C.email, G.name
FROM Customer AS C
JOIN Invoice AS I
ON C.customerid = I.customerid
JOIN Invoice_Line AS IL
ON IL.invoiceid = I.invoiceid
JOIN Track AS T
ON T.trackid = IL.trackid
JOIN Genre AS G
ON G.genreid = T.genreid
WHERE T.genreid = 1
ORDER BY C.email ASC

---5. Write a query that returns the name of artist and the number of ROCK songs they have written.

SELECT A.name, COUNT(*) AS NUMBER_OF_ROCK
FROM Artist AS A
JOIN Album AS AL
ON A.artistid = AL.artistid
JOIN Track AS T
ON T.albumid = AL.albumid
WHERE T.genreid = 1
GROUP BY A.name
ORDER BY NUMBER_OF_ROCK DESC

---6. Find which artist has earned the most according to the InvoiceLines?
SELECT  A.name, ROUND(SUM(IL.unitprice),2)  AS Total_Invoice
FROM Artist AS A
JOIN Album AS AL
ON A.artistid = AL.artistid
JOIN Track AS T
ON T.albumid = AL.albumid
JOIN Invoice_Line AS IL
ON IL.trackid = T.trackid
JOIN Invoice AS I
ON I.invoiceid = IL.invoiceid
GROUP BY A.name
ORDER BY Total_Invoice DESC

--- To get the data type of a column
SELECT DATA_TYPE 
FROM INFORMATION_SCHEMA.COLUMNS 
WHERE TABLE_NAME = 'Invoice_Line ' AND COLUMN_NAME = 'unitprice';

SELECT *
FROM Invoice_Line

SELECT DATA_TYPE
FROM INFORMATION_SCHEMA.COLUMNS
WHERE TABLE_NAME = 'Invoice_Line'


--- 7.	Find the customer who spent the most on the artist in Question 6
SELECT TOP 1 CONCAT( firstname, ' ' ,lastname) AS FULL_NAME, COUNT(*) AS Number_Purchased
FROM Customer AS C
JOIN Invoice AS I
ON C.customerid = I.customerid
JOIN Invoice_Line AS IL
ON IL.invoiceid = I.invoiceid
JOIN Track AS T
ON T.trackid = IL.trackid
JOIN Album AS AL
ON AL.albumid = T.albumid
JOIN Artist AS A
ON A.artistid = AL.artistid
WHERE A.name = 'Iron Maiden'
GROUP BY CONCAT( firstname, ' ' ,lastname) 
ORDER BY Number_Purchased DESC

--- 8. find out the most popular music Genre for each country. We determine the most popular genre as 
---the genre with the highest amount of purchases on the invoice table.

SELECT C.country AS LOCATION , G.name AS GENRE_TYPE, COUNT(IL.quantity) AS NUMBER_PURCHASED
FROM Customer AS C
JOIN Invoice AS I
ON C.customerid = I.customerid
JOIN Invoice_Line AS IL
ON IL.invoiceid = I.invoiceid
JOIN Track AS T
ON IL.trackid = T.trackid
JOIN Genre AS G
ON G.genreid = T.genreid
GROUP BY C.country, G.name
ORDER BY NUMBER_PURCHASED DESC

--- 9. Return all the track names that have a song length longer than the average song length.

SELECT name, FORMAT(milliseconds, '#,##0') AS Song_Length
FROM Track
WHERE milliseconds > (SELECT AVG(milliseconds) 
						FROM Track)
ORDER BY milliseconds DESC

---10. Write a query that determines the customer that has spent the most on music for each country.

SELECT CONCAT(firstname, ' ', lastname) AS Full_Name, country, FORMAT(SUM(T.unitprice), '#,##0.00') AS Total_Spent
FROM Customer AS C
JOIN Invoice AS I
ON C.customerid = I.customerid
JOIN Invoice_Line AS IL
ON IL.invoiceid = I.invoiceid
JOIN Track AS T
ON T.trackid = IL.trackid
GROUP BY CONCAT(firstname,' ', lastname), country
ORDER BY Total_Spent DESC

---11.	Write a query that returns the country along with the top customer and how much they spent.

SELECT DISTINCT country, CONCAT(firstname, ' ', lastname) AS Full_Name, FORMAT((SUM(IL.unitprice)), '#,##0.00') AS Total_Spent 
FROM Customer AS C
JOIN Invoice AS I
ON I.customerid = C.customerid
JOIN Invoice_Line AS IL
ON IL.invoiceid = I.invoiceid
JOIN Track AS T
ON T.trackid = IL.trackid
GROUP BY CONCAT(firstname, ' ', lastname), country
ORDER BY country, Total_Spent DESC



