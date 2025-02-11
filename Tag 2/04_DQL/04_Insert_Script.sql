USE WideWorldImporters;
GO
1. 
SELECT CustomerName, DeliveryAddressLine1 FROM Sales.Customers;

2. 
SELECT CustomerName, PhoneNumber as 'Telefonnummer' 
FROM Sales.Customers;

3. 
SELECT CountryName + ' (' + IsoAlpha3Code + ')' AS 'Land' 
FROM Application.Countries ORDER BY CountryName DESC; 


4. 
SELECT DISTINCT Continent FROM Application.Countries;¨


5. 
SELECT TOP 3 * FROM Sales.Orders ORDER BY OrderDate ASC;


1. 
SELECT CountryID, FormalName, SubRegion FROM Application.Countries 
WHERE CountryName = 'Switzerland';


2. 
SELECT * FROM Application.People
WHERE FullName NOT LIKE 'a%';

3. 
SELECT * FROM Sales.Orders 
WHERE OrderDate BETWEEN '2016-01-01' and '2016-01-31' 
ORDER BY OrderDate DESC

/*Case*/

SELECT OrderID, Quantity,
CASE
    WHEN Quantity > 10 THEN 'Die Bestellmenge ist groesser als 10'
    WHEN Quantity = 10 THEN 'Die Bestellmenge ist 10'
    ELSE 'Die Bestellmenge ist kleiner als 10'
END AS QuantityText
FROM Sales.OrderLines;

-- 1. 
SELECT StockItemID, StockItemName, UnitPrice 
FROM Warehouse.StockItems
WHERE UnitPrice > (SELECT AVG(UnitPrice) 
FROM Warehouse.StockItems);

-- 2. 
SELECT c.CustomerID, c.CustomerName, o.OrderDate, o.AnzahlBestellungen 
FROM Sales.Customers c
JOIN (SELECT CustomerID, OrderDate, COUNT(*) AS AnzahlBestellungen
        FROM Sales.Orders 
        GROUP BY CustomerID, OrderDate
        HAVING COUNT(*) > 4) AS o 
ON c.CustomerID = o.CustomerID


-- 3. 
SELECT * FROM Warehouse.StockItems AS s
WHERE (
    SELECT SUM(Quantity) 
    FROM Sales.OrderLines AS o 
    WHERE o.StockItemID = s.StockItemID
) > 50000;

-- 1. 
SELECT FullName FROM Application.People 
INTERSECT 
SELECT CustomerName FROM Sales.Customers

-- 2. 
