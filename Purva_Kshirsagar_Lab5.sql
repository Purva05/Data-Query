use crimsondb;

--1 Prepare a query that returns trimmed first names for account_ids less than 10.  Trim both the beginning and the end


SELECT LTRIM(first_name) as trimmedfirst
FROM account 
WHERE account_id <10;


--2 Prepare a query that returns first names and last names in all caps for account_ids less than 10

SELECT UPPER(first_name) as FIRST_NAME, UPPER(last_name) as LAST_NAME 
FROM account 
WHERE account_id <10;

--3 Prepare a query that returns the first name and last name (with a single space in between) as a single column for account_ids less than 10.

SELECT CONCAT(first_name, ' ', last_name) as full_name 
FROM account 
WHERE account_id<10;

--4 Prepare a query that returns the number of characters in the email addresses of account_IDs less than 10

SELECT LEN(email) as No_of_email_id_char
FROM account 
WHERE account_id<10;

--5 Prepare a query that extracts the last three characters from the email addresses of account_IDs less than 10

SELECT RIGHT(email,3) as Email_id_last_3
FROM account 
WHERE account_id<10;

--6 Prepare a query that determines the position of the @ symbol in the email addresses of account_IDs less than 10

SELECT CHARINDEX('@',email) as Email_id
FROM account 
WHERE account_id<10;

--7 Prepare a query that extracts everything after the @ symbol from the email addresses of account_IDs less than 10

SELECT SUBSTRING(email,CHARINDEX('@',email)+1,LEN(email)) as Email_id 
FROM account 
WHERE account_id<10;

--8 Prepare a query that returns the email addresses of account_IDs less than 10.  If no email is available, return ‘n/a’.

SELECT ISNULL(email,'n/a') as Email_id 
FROM account 
WHERE account_id<10;

--9 Return the average household size in 2019 and the absolute value of the average household size in 2019 of accounts from California

SELECT AVG(CAST(householdsize_2019 as decimal)) as average,
ABS(AVG(CAST(householdsize_2019 as decimal))) as abs_of_average 
FROM account 
WHERE state = 'California';

--10 Return the average household size in 2019 among California accounts rounded to three digits after the decimal.

SELECT ROUND(AVG(CAST(householdsize_2019 as decimal)),3) as average 
FROM account 
WHERE state = 'California';

--11 Return the average household size in 2019 among California accounts rounded down.

SELECT FLOOR(AVG(CAST(householdsize_2019 as decimal))) as average 
FROM account 
WHERE state = 'California';

--12 Return the average the most recent available household size for accounts from New York.  
--If no household size is available, use a household size of 2.

SELECT AVG(CAST(COALESCE(householdsize_2019,2)as decimal)) as average
FROM account 
WHERE state = 'New York';

--13 Using the most recently available household size (or household size of 2 if none is available), 
--what is the average household size among households with children vs. without children?

SELECT child_boolean, 
AVG(CAST(COALESCE(householdsize_2019,householdsize_2018,householdsize_2017,2) as decimal)) as household_size_avg
FROM account 
GROUP BY child_boolean

--14 For accounts with account_ids less than 15, evaluate whether the zip code for each account has less than 5 digits. 
--If less than 5 digits, return “invalid zip.”  If this test fails, return the zip code.

SELECT IIF(LEN(zip)=5, zip,'invalid zip') as zip_code
FROM account 
WHERE account_id <15 

--15 Prepare a query that returns the account’s title and full name for accounts with account_ids less than 15.  
--If no title is provided, write Ms. for female accounts and Mr. for male accounts.  
--If no title and no gender is provided, write the full name without a title.

SELECT
CASE
	WHEN A.title IS NOT NULL THEN CONCAT(A.title, ' ', A.first_name, ' ', A.last_name)
ELSE
	CASE
		WHEN A.gender = 'Female' THEN CONCAT('Ms. ', first_name, ' ', last_name)
		WHEN A.gender = 'Male' THEN CONCAT('Mr. ', first_name, ' ', last_name)
		ELSE CONCAT(first_name, ' ', last_name)
	END
END
as full_name_with_title
FROM account A
WHERE A.account_id < 15;







