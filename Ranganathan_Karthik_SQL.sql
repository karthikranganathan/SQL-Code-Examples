-- 1.  What authors are in California
select *
         from authors
		 where state like 'ca'

-- 2.  List the titles and author names
Select t.title,a.au_fname, a.au_lname 
          from authors as a

          join titleauthor as ta
           on a.au_id = ta.au_id
                                 join titles t
                                 on t.title_id = ta.title_id
	
--3.  List all employees and their jobs	 
 select e.fname, e.emp_id, j.job_desc
           from employee as e

		   join jobs as j
		   on e.job_id = j.job_id

--  4.  List the titles by total sales price
select s.title_id, s.qty, t.title_id, t.price, t.title,
                                                            t.price*s.qty as total_sales_done
            from titles as t

			join sales as s 
			on t.title_id = s.title_id

-- 5.  Find the sales for stores in California
select sum(s.qty) as total_qty, st.stor_name, st.state

           from sales as s 

		   join stores as st
		   on s.stor_id = st.stor_id
		   where st.state like 'ca'
		   group by st.stor_name,st.state

		    
-- 6.  Use SSMS to generate a script to create the authors table describe what the script does
    /*    ==Scripting Parameters==

    Source Server Version : SQL Server 2016 (13.0.4206)
    Source Database Engine Edition : Microsoft SQL Server Enterprise Edition
    Source Database Engine Type : Standalone SQL Server

    Target Server Version : SQL Server 2016
    Target Database Engine Edition : Microsoft SQL Server Enterprise Edition
    Target Database Engine Type : Standalone SQL Server
*/

USE [pubs]
GO

/****** Object:  Table [dbo].[authors]    Script Date: 9/22/2017 1:16:28 PM ******/

SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

CREATE TABLE [dbo].[authors](
	[au_id] [dbo].[id] NOT NULL,
	[au_lname] [varchar](40) NOT NULL,
	[au_fname] [varchar](20) NOT NULL,
	[phone] [char](12) NOT NULL,
	[address] [varchar](40) NULL,
	[city] [varchar](20) NULL,
	[state] [char](2) NULL,
	[zip] [char](5) NULL,
	[contract] [bit] NOT NULL,
 CONSTRAINT [UPKCL_auidind] PRIMARY KEY CLUSTERED 
(
	[au_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[authors] ADD  DEFAULT ('UNKNOWN') FOR [phone]
GO

ALTER TABLE [dbo].[authors]  WITH CHECK ADD CHECK  (([au_id] like '[0-9][0-9][0-9]-[0-9][0-9]-[0-9][0-9][0-9][0-9]'))
GO

ALTER TABLE [dbo].[authors]  WITH CHECK ADD CHECK  (([zip] like '[0-9][0-9][0-9][0-9][0-9]'))
GO



-- 7.  Describe what the au_id is using for a data type

   -- Answer 
   sp_help authors
    -- Variable character of 11 bytes with identity attribute and not null

-- 8.  List the store name, title title name and quantity for all stores that have net 30 payterms

select s.stor_id, s.title_id, t.title_id, t.title, t.ytd_sales, st.stor_id, st.stor_name, s.payterms 
from sales as s
                join titles as t
                on s.title_id= t.title_id

				Join stores as st
				on s.stor_id=st.stor_id

				WHERE s.payterms like 'Net 30'

-- 9.Find the titles that do not have any sales show the name of the title
select t.title_id, t.title, t.ytd_sales, s.title_id, s.qty
from titles as t
                 left outer join sales as s
				 on t.title_id = s.title_id

				 where s.title_id is null

-- 10. Do previous question another way
select t.title_id, t.title, t.ytd_sales

from titles as t 
                where t.ytd_sales is null

