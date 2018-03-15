USE TSQL2012;

--using FROM
SELECT
  empid
 ,firstname
 ,lastname
FROM HR.Employees;

--using pseudoname
SELECT
  e.empid
 ,e.firstname
 ,e.lastname
FROM HR.Employees AS e;

--non-relational
SELECT
  e.empid
 ,e.firstname + N' ' + e.lastname
FROM HR.Employees AS e;

--relational
SELECT
  e.empid
 ,e.firstname + N' ' + e.lastname AS fullname
FROM HR.Employees AS e;

--no duplicates (relational)
SELECT DISTINCT
  e.country
 ,e.region
 ,e.city
FROM HR.Employees AS e;

--non standart
SELECT
  10 AS col1
 ,'ABC' AS col2;

--error
SELECT
  CAST('abc' AS INT);

--NULL
SELECT
  TRY_CAST('abc' AS INT);

--using style
SELECT
  CONVERT(DATE, '1/3/2012', 101);

--using lang and regional parameters
SELECT
  PARSE('1/2/2012' AS DATE USING 'en-US');

--string concatenation
SELECT
  empid
 ,country
 ,region
 ,city
 ,country + N',' + region + N',' + city AS location
FROM HR.Employees;

--using function coalesce
SELECT
  empid
 ,country
 ,region
 ,city
 ,country + COALESCE(N',' + region, N'') + N',' + city AS location
FROM HR.Employees;

--using function concat
SELECT
  empid
 ,country
 ,region
 ,city
 ,CONCAT(country, N',' + region, N',' + city) AS location
FROM HR.Employees;

--finding index
SELECT
  CHARINDEX('I', 'Itzic Ben-Gan');

--editing strings
SELECT
  REPLACE('.1.2.3.', '.', '/');
SELECT
  REPLICATE('0', 10);
SELECT
  STUFF(',x,y,z', 1, 3, '-');

--formatting string
SELECT
  FORMAT(1759, '0000000000');

--CASE - simple form
SELECT
  p.productid
 ,p.productname
 ,p.unitprice
 ,p.discontinued
 ,CASE p.discontinued
    WHEN 0 THEN 'No'
    WHEN 1 THEN 'Yes'
    ELSE 'Unknown'
  END AS discounted_desc
FROM Production.Products AS p;

--CASE - searching form
SELECT
  productid
 ,productname
 ,unitprice
 ,CASE
    WHEN unitprice < 20.00 THEN 'Low'
    WHEN unitprice < 40.00 THEN 'Medium'
    WHEN unitprice >= 40.00 THEN 'High'
  END
FROM Production.Products;
