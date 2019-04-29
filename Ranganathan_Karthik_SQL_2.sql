-- 1. List each title name and their authors can you do it on a single line for multiple authors

Select t.title,

     STUFF(( Select '; '+ CONCAT (a.au_fname, ' ', a.au_lname)
          from titleauthor ta

          Join authors a
          on a.au_id = ta.au_id
		             Join titles t1
					 on ta.title_id = t1.title_id
					 where t1.title = t.title
					 for xml path ('')), 1, 1, '')
					 as authors_name
					 
					 from titles t
		   
-- 2. List the titles in order of total sale. Totals sales is determined by reading the qty from sales and calculating the sales price based on the price of the book in the titles table


 Select t.title, s.qty, t.price*s.qty as Sales_total from titles t
     Join Sales s 
	on s.title_id = t.title_id
	order by Sales_total desc
	
-- 3. Add the store name to the query above

Select t.title, s.qty,st.stor_name, t.price*s.qty as Sale_total from titles t
    Join Sales s 
	on s.title_id = t.title_id
	        
			  Join stores as st
	          on s.stor_id = st.stor_id
	            
				       order by Sale_total desc

-- 4. List all the titles and list the royalty schedule

select ro.lorange, ro.hirange, ro.royalty, t.title, t.ytd_sales from titles t
  Inner Join roysched as ro
   on ro.title_id = t.title_id
                            Where ro.royalty	Between 
                            ro.lorange And ro.hirange  

-- 5. List the stores that have orders with more than one title on the order
select st.stor_name from stores st
      Join sales as s
	  on st.stor_id = s.stor_id
	        Join titles t
			on s.title_id = t.title_id
			  group by st.stor_name having COUNT(*) >0 ;

-- 6. Using the last position of the employee id to determine gender generate a count of the number of males and females

select  Lower (Right (employee.emp_id,1)) as gender,
          Count(*) as T_count
          From employee
                         Group by (Right (emp_id,1))

-- 7. Produce a report firstname, lastname and gender.  Show gender as Male or Female based on last position in the employee id

select employee.fname,employee.lname, 
CASE 
WHEN substring(employee.emp_id,9,1) = 'F'
THEN 'Female' 
WHEN substring(employee.emp_id,9,1) = 'M'
THEN 'Male' 
END AS Gender
 from employee
 

