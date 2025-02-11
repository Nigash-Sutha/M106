USE WideWorldImporters;
GO

 
CREATE VIEW CalifornianCities AS 
    SELECT c.CityID, c.CityName, sp.StateProvinceID, sp.StateProvinceCode,  sp.StateProvinceName  
    FROM Application.Cities c 
    INNER JOIN Application.StateProvinces sp on c.StateProvinceID = sp.StateProvinceID 
    WHERE StateProvinceName = 'California'
GO 
-- 2. Los Angeles suchen 
SELECT * FROM CalifornianCities WHERE CityName = 'Los Angeles'

-- 3. VIEW löschen 
DROP VIEW CalifornianCities