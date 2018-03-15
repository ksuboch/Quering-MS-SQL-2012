USE TSQL2012;

SELECT
  s.shipperid
 ,s.companyname
 ,s.phone AS [phone number]
FROM Sales.Shippers AS s;

SELECT
  empid
 ,firstname + N' ' + lastname AS fullname
 ,YEAR(birthdate) AS birthyear
FROM HR.Employees;

SELECT
  EOMONTH(SYSDATETIME()) AS end_of_current_month;

SELECT
  DATEFROMPARTS(YEAR(SYSDATETIME()), 12, 31) AS end_of_current_year;

SELECT
  productid
 ,RIGHT(REPLICATE('0', 10) + CAST(productid AS VARCHAR(10)), 10) AS str_productid
FROM Production.Products;

SELECT
  productid
 ,FORMAT(productid, 'd10') AS str_productid
FROM Production.Products;
