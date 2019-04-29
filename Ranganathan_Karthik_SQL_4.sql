--1) Create  function the first call ZipFix will take in integer and turn it into a 5 digit zip code or a 5-4 digit zip code
Create Function ZipFix 
(@Zip int)
Returns varchar(10)
As 
Begin
Declare @Z varchar(10)
set @Z =
  CASE
	  WHEN isnumeric(@Zip) = 1 and len(@Zip) = 5
	       Then substring(convert(varchar(10),@Zip),1,5) 
      WHEN isnumeric(@Zip) = 1 and len(@Zip) = 9
	       Then substring(convert(varchar(10),@Zip),1,5) + '-' + substring(convert(varchar(10),@Zip),6,9) 
   ELSE 'Invalid'
   END
return @Z
end
go


Select dbo.ZipFix (954685987) 







--2) Create  function call PhoneFIx will take an integer phone number and convert it to a character number with the format of (xxx) xxx-xxxx
	 
	  CREATE FUNCTION dbo.Phonefix (@Phone Bigint)
RETURNS VARCHAR(14)
AS
BEGIN
DECLARE @Formatted VARCHAR(15)

IF (LEN(@Phone) <> 10) 
    SET @Formatted = 'Wrong no.'
ELSE  if isnumeric(@phone) = 1
    SET @Formatted ='('
	    + LEFT(@Phone, 3) 
	    + ') ' 
	    + SUBSTRING (Convert (Varchar(15), @Phone), 4, 3) 
		+ '-' 
		+ SUBSTRING(Convert (Varchar(15),@Phone), 7, 4)

RETURN @Formatted
END
GO

 select dbo.Phonefix(9872222222) 

 