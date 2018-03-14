USE TSQL2012;

SELECT
  s.shipperid
 ,s.companyname
 ,s.phone AS [phone number]
FROM Sales.Shippers AS s;
