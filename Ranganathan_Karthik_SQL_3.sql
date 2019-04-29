--1) Using AdventureWorks - List all the
 employees show name and department

   select he.DepartmentID, hr.Name, p.Firstname, p.LastName from person.Person as p

   join HumanResources.EmployeeDepartmentHistory as he
    on he.BusinessEntityID = p.BusinessEntityID
	
	join HumanResources.Department as hr
	  on hr.DepartmentID = he.DepartmentID 

	
--2) Using AdventureWorks - Show the employees and their current and prior departments
 
 select pp.firstname, pp.lastname, ed.DepartmentID, ed.BusinessEntityID
   from HumanResources.EmployeeDepartmentHistory as ed, HumanResources.EmployeeDepartmentHistory as ed1
   Join person.person as pp
   on pp.BusinessEntityID = ed1.BusinessEntityID
   where ed.BusinessEntityID = ed1.BusinessEntityID
   and ed.DepartmentID <> ed1.DepartmentID

-- 3) Using AdventureWorks - Break apart the employee login id so that you have the domain (before the /) in one column and the login id (after the /) in two columnsz   
    
	select he.loginid, substring(he.loginid,1,15) as Firstpart,
	 substring(he.loginid,17,10) as lastpart, he.businessentityid 
	
	from humanresources.employee as he
    
-- 4) Using AdventureWorks - Build a new column in a copy of the employee table that is the employee email address in the form login_id@domain.com, populate the column
 
Select * into  Humanresources.employee2 from Humanresources.employee 
   Alter Table Humanresources.employee2 ADD Email_ID varchar (30) Null
   
   Update  HumanResources.employee2
   set Email_ID = concat (substring(HumanResources.employee2.LoginID ,17,10),'@', substring(HumanResources.employee2.LoginID,1,15), '.com')
   select * from HumanResources.employee2

--6) Using AdventureWorks - Calculate the age of an employee in years - Does it work if the birthday hasn't happened yet if not fix it


select he.LoginID, he.BirthDate, 

 CASE WHEN DATEADD(Year, DATEDIFF(year, he.BirthDate, GETDATE()),he.BirthDate)<GETDATE()
   THEN DATEDIFF(year, he.BirthDate,GETDATE())
ELSE DATEDIFF(year,he.BirthDate, GETDATE()) -1 END as AGE
from humanresources.employee2 as he
order by he.BirthDate

--7) Using Pubs - List a titles prior year sales, define the current year as the max year in the sales (use a subquery).

select ti.title, ti.title_id, s.ord_date, s.ord_num, s.stor_id  from dbo.sales as s
  Join dbo.titles as ti
   on ti.title_id = s.title_id
   where year(s.ord_date) = (select max(year(ord_date)-1) from sales);

   -- 8) Create a function to change the case of a string. As Follows.
         -- This is A TEST String
          -- becomes          
          -- tHIS IS a test sTRING

CREATE FUNCTION Invert1
(@string VARCHAR(MAX))
RETURNS VARCHAR(MAX)
BEGIN
DECLARE @count INT,
@output VARCHAR(MAX)
SET @count = 1
SET @output = ''
WHILE (@count <LEN(@string)+1)
BEGIN

IF ASCII(SUBSTRING(@string, @count, 1)) between 90 and 122

SET @output= @output + UPPER(SUBSTRING(@string, @count, 1))
ELSE IF ASCII(SUBSTRING(@string, @count, 1)) between 65 and 90
SET @output = @output + LOWER(Substring(@string, @count, 1))
ELSE 
SET @output = @output + ' '
SET @count= @count+ 1

END
RETURN @output
END

select dbo.invert1 ('Hey Look It Works') as done

 --9) Create a function to return the gender of an employee based on the emploee id (gender is Male / Female)
 
CREATE FUNCTION Gender (@emp_id VARCHAR(max))
RETURNS VARCHAR(max)
AS BEGIN
DECLARE @GEN AS VARCHAR(MAX), @Gender AS VARCHAR(MAX)

SELECT
@GEN = SUBSTRING(emp_id, len(emp_id),1)
 
 FROM     employee
 WHERE    emp_id = @emp_id
BEGIN  IF  @GEN = 'M' 
	 SET @Gender ='Male'
     Else SET @Gender = 'Female'
RETURN   @Gender
END
RETURN   @Gender
END

--test
select emp_id, dbo.gender (emp_id) as gender
from employee

--10) Create a table function that returns the employee columns and a new row called gender (again Male / Female)
CREATE FUNCTION Emp_Gen()
RETURNS Table AS
RETURN
SELECT *,
	 'Gender' =  CASE SUBSTRING(emp_id, len(emp_id),1 )
      WHEN 'M'  THEN 'Male' 
      ELSE 'Female'
      END
 FROM  employee

 --test
 SELECT *
 FROM   dbo.Emp_Gen()

 --11) Write a function to calculate age in years take into account the birth date
CREATE FUNCTION age(@DOB DATE)
RETURNS VARCHAR(MAX)
AS
BEGIN
DECLARE @age as VARCHAR(MAX)
SELECT @age =FLOOR(DATEDIFF(month,@DOB,GETDATE())/12)
FROM HumanResources.Employee
WHERE BirthDate = @DOB
RETURN @age
END

--TEST

SELECT BirthDate,
       [dbo].[age](BirthDate) as age	   
FROM   HumanResources.Employee

-- 12) Create a SQLprocedure to insert a record into the jobs table in pubs.  The procedure should validate the input before doing the insert.

-- Making a copy of jobs table
SELECT * INTO dbo.jobs_copy FROM dbo.jobs

-- creating a procedure to insert recors into the jobs table with validation

CREATE PROCEDURE InsertIntoJobs 

 @jobdesc VARCHAR(50),
 @minlvl TINYINT,
 @maxlvl TINYINT
 
AS
BEGIN

IF @minlvl >= 10 
 AND  @maxlvl <= 250
    
   INSERT INTO jobs_copy (job_desc, min_lvl, max_lvl) 
    VALUES (@jobdesc, @minlvl,@maxlvl) 
	ELSE
	
RAISERROR('error',0,1) 
END
GO
exec insertintojobs 'Artist', 9, 250
select * from jobs_copy