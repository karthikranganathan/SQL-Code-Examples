Delete from dbo.[Trigger.Member] 

Select * from dbo.Trigger#Dependents$

Select * from dbo.Trigger#Member$

-- 1st trigger where it deletes or doesn't

CREATE TRIGGER trgInsteadOfDelete ON dbo.Trigger#Member$
INSTEAD OF DELETE
AS
    declare @F1 varchar(10);
    declare @F2 varchar(50);
	declare @F3 varchar(50);
	declare @F4 char(1);

	
	select @F1=d.F1 from deleted d;	
	select @F2=d.F2 from deleted d;	
	select @F3=d.F3 from deleted d;
	select @F4=d.F4 from deleted d;	
	

	BEGIN
	  if(@F4='Y')
	  begin
	  RAISERROR('Cannot delete as Member has Dependent',16,1);
			ROLLBACK;
		end
		else
		begin


			delete from dbo.Trigger#Member$ where F1=@F1;
			COMMIT;

	PRINT 'AFTER DELETE trigger fired.'
	end
END
GO

--Checking 

Select * from dbo.Trigger#Member$

Delete from dbo.Trigger#Member$ where F1=1

Delete from dbo.Trigger#Member$ where F1=2

drop trigger trgInsteadOfDeletecascade

--2nd Trigger where it cascading effect deletes from both tables if a member has dependent

CREATE TRIGGER trgInsteadOfDeletecascade ON dbo.Trigger#Member$
INSTEAD OF DELETE
AS
    declare @F1 varchar(10);
    declare @F2 varchar(50);
	declare @F3 varchar(50);
	declare @F4 char(1);

	
	select @F1=d.F1 from deleted d;	
	select @F2=d.F2 from deleted d;	
	select @F3=d.F3 from deleted d;
	select @F4=d.F4 from deleted d;	
	

	BEGIN
	  if(@F4='N')
	 begin
			delete from dbo.Trigger#Member$ where F1=@F1;
			COMMIT;

	PRINT 'AFTER DELETE trigger fired only for Member.'
	end
		else if @F4=('Y')
		begin

    DELETE FROM dbo.Trigger#Dependents$ where dbo.Trigger#Dependents$.F4= @F1;
   
   
			delete from dbo.Trigger#Member$ where F1=@F1;
			COMMIT;

	PRINT 'AFTER DELETing both tables trigger fired.'
	end
END
Go

--Checking

select F1 datatype from dbo.Trigger#Member$
select * from  dbo.Trigger#Dependents$

Delete from dbo.Trigger#Member$ where f1=3

Insert into dbo.Trigger#Member$
values ('1','Karthik','Ranganathan','Y'),

--Cascading type 2


ALTER TABLE dbo.Trigger#Dependents$ 
ADD CONSTRAINT FK_Trigger#Dependents$_F4
    FOREIGN KEY (F4)
    REFERENCES dbo.Trigger#Member$ (F1)
    ON DELETE CASCADE

delete from  dbo.Trigger#Member$
where F1= '123'

 