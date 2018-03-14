USE TSQL2012;

--multiset
SELECT
  country
FROM HR.Employees;

--set
SELECT DISTINCT
  country
FROM HR.Employees;

--no sorting by default
SELECT
  empid
 ,lastname
FROM HR.Employees;

--ordering by empid field
SELECT
  empid
 ,lastname
FROM HR.Employees
ORDER BY empid;

--non-relational ordering
SELECT
  empid
 ,lastname
FROM HR.Employees
ORDER BY 1;

--non-relational (no alias)
 SELECT
  empid,
  firstname + ' ' + lastname --AS fullname
 FROM HR.Employees;
