--## Part I: W3Schools SQL Lab 

This challenge uses the [W3Schools SQL playground](http://www.w3schools.com/sql/trysql.asp?filename=trysql_select_all). Please add solutions to this markdown file and submit.

--1. Which customers are from the UK?

SELECT * FROM Customers WHERE Country = 'UK';

--2. What is the name of the customer who has the most orders?

SELECT Customers.CustomerID, SUM(Orders.OrderID)
FROM Customers JOIN Orders ON Customers.CustomerID=Orders.CustomerID
GROUP BY Customers.CustomerID ORDER BY SUM(Orders.OrderID) DESC;

--3. Which supplier has the highest average product price?

SELECT Suppliers.SupplierName, AVG(price)
FROM Products JOIN Suppliers ON Products.SupplierID = Suppliers.SupplierID
GROUP BY Products.SupplierID ORDER BY AVG(price) DESC LIMIT 1;

--4. How many different countries are all the customers from? (*Hint:* consider [DISTINCT](http://www.w3schools.com/sql/sql_distinct.asp).)

SELECT COUNT(DISTINCT(Country)) FROM Customers;

--5. What category appears in the most orders?

SELECT Categories.CategoryName, COUNT(DISTINCT(OrderID))
FROM Categories JOIN Products ON Categories.CategoryID = Products.CategoryID
JOIN OrderDetails ON Products.ProductID = OrderDetails.ProductID
GROUP BY Categories.CategoryName ORDER BY COUNT(DISTINCT(OrderID)) DESC LIMIT 1;

--6. What was the total cost for each order?

SELECT Orders.OrderID, Price
FROM Orders JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID
JOIN Products ON Products.ProductID = OrderDetails.ProductID
GROUP BY OrderDetails.OrderID ORDER BY Price DESC;

--7. Which employee made the most sales (by total price)?

SELECT Employees.EmployeeID, LastName, FirstName, Price
FROM Employees JOIN Orders on Employees.EmployeeID = Orders.EmployeeID
JOIN OrderDetails ON Orders.OrderID = OrderDetails.OrderID JOIN Products ON OrderDetails.ProductID = Products.ProductID
GROUP BY Orders.EmployeeID ORDER BY Price DESC;

--8. Which employees have BS degrees? (*Hint:* look at the [LIKE](http://www.w3schools.com/sql/sql_like.asp) operator.)

SELECT * FROM Employees WHERE Notes LIKE '%BS%';

--9. Which supplier of three or more products has the highest average product price? (*Hint:* look at the [HAVING](http://www.w3schools.com/sql/sql_having.asp) operator.)

SELECT SupplierName, COUNT(ProductName), AVG(Price)
FROM Products JOIN Suppliers ON Products.SupplierID = Suppliers.SupplierID
GROUP BY SupplierName HAVING COUNT(ProductName)>=3
ORDER BY AVG(Price) DESC;
