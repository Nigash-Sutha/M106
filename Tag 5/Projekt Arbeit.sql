 -- Aufgabe 2 Erstelle ein Backup von der soeben erstellten Northwind-Datenbank in den dafür vorgesehenen Backupfolder deiner SQL-Instanz.

BACKUP DATABASE [Northwind]
TO DISK = N'C:\Northwind backup\Northwind.bak' 
WITH NOFORMAT, NOINIT, NAME = N'Northwind vollständige Datenbanksicherung', SKIP, STATS = 10
GO

-- Aufgabe 3 Teste dein Backup, indem du die Northwind-Datenbank löschst und anhand des Backups wieder herstellst.
USE master;
GO

ALTER DATABASE Northwind SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
GO
DROP DATABASE Northwind;


RESTORE DATABASE [Northwind]
FROM DISK = N'C:\Northwind backup\Northwind.bak'

-- Aufgabe 4 Du willst dir Übersicht über die Produktetabelle erschaffen und möchtest wissen, welche Datentypen in der Produktetabelle verwendet werden. Erschaffe dir die Übersicht anhand der geeigneten gespeicherten Prozedur.

USE Northwind;
GO
exec sp_columns Products

-- Aufgabe 5 Die Geschäftsleitung hat entschieden, Lohninformationen in der Datenbank zu speichern. Die Mitarbeiter der Firma Northwind haben folgende Anstellungen und Jahresgehälter:

CREATE SCHEMA hr AUTHORIZATION dbo;
GO

CREATE TABLE hr.payroll_accounting (
	payroll_accounting_id INT PRIMARY KEY,
	title NVARCHAR(30),
	salary MONEY);


INSERT hr.payroll_accounting VALUES
(1,'Inside Sales Coordinator',	80000),
(2,'Vice President, Sales',	100000),
(3,'Sales Representative',	80000),
(4,'Sales Manager',	90000);
GO

-- Aufgabe 6 Erstelle eine View lohnuebersicht, welche den Vornahmen, Nachnahmen und das Gehalt ausgibt. Die Jahresgehälter werden jeden Monat um 30$ erhöht. Mitarbeiter, welche im Jahre 1993 eingestellt wurden, erhalten zudem jährlich noch einen Bonus von 1000$. Da immer wieder eine Lohnliste erstellt werden muss, machst du eine View.

Create VIEW lohnuebersicht AS
SELECT e.FirstName,e.LastName, 
CASE
	WHEN YEAR(e.HireDate)= 1993 THEN DATEDIFF(MONTH,HIREDATE, GETDATE())*30 + p.salary + DATEDIFF(YEAR,HIREDATE, GETDATE())*1000
	ELSE DATEDIFF(MONTH,HIREDATE, GETDATE())*30 + p.salary
	END 
	AS GEHALT
FROM Employees e
JOIN hr.payroll_accounting p ON e.Title = p.title;
GO

SELECT * FROM lohnuebersicht;

-- Aufgabe 7 Die Mitarbeiter werden jährlich aufgrund ihrer Leistung und der Zielerreichung bewertet. Die möglichen Bewertungen sind von A-D. Füge bei der Employees-Tabelle eine Spalte valuation mit dem Standartwert B ein. Achte darauf, dass nur die Werte A-D eingetragen werden können. Fülle diese Werte gleich ab: Alle Mitarbeiter erhalten die Bewertung B, einzig Nancy Davolio hat eine A und Robert King hat eine C.

ALTER TABLE employees ADD valutation CHAR DEFAULT('B');
GO
ALTER TABLE employees ADD CHECK(valutation like '[A-D]');
GO

UPDATE Employees
SET valutation ='B';

UPDATE Employees
SET valutation ='A'
WHERE firstname = 'Nancy' AND lastname='Davolio';

UPDATE Employees
SET valutation ='C'
WHERE firstname = 'Robert' AND lastname='King';
GO


-- Aufgabe 8 Die neue Spalte soll von valutation in rating umbenannt werden.


EXEC sp_rename 'dbo.employees.valutation', 'rating', 'COLUMN';--Fehlermeldung
--zuerst den Check löschen
ALTER TABLE Employees
DROP CONSTRAINT CK__Employees__valut__70DDC3D8;



--Nun kann die Prozedur ausgeführt werden
EXEC sp_rename 'dbo.employees.valutation', 'rating', 'COLUMN';

--Den Check wieder erstellen.
ALTER TABLE dbo.Employees
ADD CHECK(rating like '[A-D]');

-- 9 Aufgabe Die neue Spalte soll von valutation in rating umbenannt werden.

EXEC sp_rename 'hr.payroll_accounting', 'salaries';


-- 10 Aufgabe Erstelle von der Tabelle Products eine Kopie mit dem Namen products_backup (ohne Constraints).

SELECT * INTO products_backup FROM Products;

SELECT * FROM products_backup;

-- 11 Aufgabe Lösche den Inhalt der Tabelle products_backup innerhalb einer Transaktion. Schliesse die Transaktion so ab, dass die Änderungen nicht ausgeführt werden.

BEGIN TRANSACTION
DELETE FROM products_backup
--testen
SELECT * FROM products_backup


--abschliessen ohne commit
ROLLBACK 

-- 12 Aufgabe Lösche den Inhalt der Tabelle products_backup mit einem DDL-Befehl.

TRUNCATE TABLE products_backup;

SELECT * FROM products_backup;

-- 13 Aufgabe Lösche die gesamte Tabelle products_backup


DROP TABLE products_backup;


-- 14 Aufgabe Erstelle nochmals eine Kopie der Produktetabelle. Ändere den Produktnamen eines beliebigen Produktes in der Produkte-Tabelle. Du möchtest nun diese Anpassung wieder rückgängig machen. Verwende hierzu einen Merge. Kontrolliere die Änderungen jeweils mit einer Abfrage.

--Erstelle nochmals ein Backup der Produktetabelle.
SELECT * INTO products_backup FROM Products;

--Ändere den Produktnamen eines beliebten Produktes in der Produkte-Tabelle.
UPDATE Products
SET ProductName='Chai Tea'
WHERE ProductName='Chai'




--Kontrolliere die Änderungen jeweils mit einer Abfrage.
SELECT * FROM Products;
SELECT * FROM products_backup;

--Du möchtes nun diese Anpassung wieder rückgängig machen. Verwende hierzu einen Merge.
MERGE products p
USING products_backup pb ON p.productid=pb.productid
WHEN MATCHED THEN
UPDATE SET p.productname=pb.productname;