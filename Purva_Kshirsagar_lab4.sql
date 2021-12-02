use crimsondb;

--1  Prepare a query that determines how many males and how many females own a Porsche.
-- This query requires a join.  A subquery is not necessary.	

SELECT A.gender as gender, count(V.vehicle_make) as 'account count'
FROM account A, vehicle V
WHERE V.account_id = A.account_id
AND A.gender IS NOT NULL
AND V.vehicle_make = 'Porsche'
GROUP BY A.gender;


--2 Prepare a query that determines how many vehicles owners are from California or Oregon.
--This query requires a join.  A subquery is not necessary.

SELECT count(distinct A.account_id) as 'account count'
FROM account A, vehicle V
WHERE A.state in ('California', 'Oregon')
AND A.account_id = V.account_id;


--3 Prepare a query that determines how accounts that do not own a vehicle (based on this dataset)
-- are from California or Oregon

SELECT count(distinct A.account_id) as 'account count'
FROM account A, vehicle V
WHERE A.state in ('California', 'Oregon') 
AND A.account_id  NOT IN (SELECT distinct V.account_id 
FROM vehicle V);

--4 What accounts own a Chevrolet manufactured within the last 10 years
-- and had a household size greater than 4 in 2019?
-- This query requires a join.  A subquery is not necessary.

SELECT A.account_id, A.title, A.first_name, A.last_name, A.email
FROM vehicle V, account A
WHERE V.vehicle_make = 'Chevrolet'
AND A.account_id = V.account_id
AND V.vehicle_model_year >= year(GETDATE())-10
AND A.householdsize_2019 > 4;


--5 Prepare a query that shows how many vehicles each account owns.
-- Include all accounts in the query result, even if they own no vehicles.
-- This query requires a join.  A subquery is not necessary.

SELECT A.account_id, A.first_name, A.last_name, count(V.account_id) as 'Vehicle Count'
FROM account A
LEFT OUTER JOIN vehicle V ON
A.account_id = V.account_id
GROUP BY A.account_id, A.first_name, A.last_name
ORDER BY A.account_id;

--6 What is the average household size (as of 2019) among accounts that were referred by a female?
-- This query requires a join.  A subquery is not necessary.  As the table must be joined with itself, use table aliasing.

SELECT avg(CAST(A1.householdsize_2019 as decimal))
FROM account A1, account A2
WHERE A1.account_id_referral = A2.account_id
AND A2.gender = 'Female';


--7 How many accounts had a household size in 2019 greater than the average household size in 2018 based on the available data?
-- Use a subquery.

SELECT COUNT(A1.account_id)
FROM account A1
WHERE A1.householdsize_2019 >
(SELECT avg(CAST(A2.householdsize_2018 as decimal))
FROM account A2);

--8 What accounts reported an above average household size in 2019 (based on 2018 average) and owned at least 6 vehicles?
-- Use a subquery.
SELECT A1.account_id, A1.first_name, A1.last_name, count(V.account_id) as 'vehicle count'
FROM account A1, vehicle V
WHERE A1.householdsize_2019 >
(SELECT avg(CAST(A2.householdsize_2018 as decimal))
FROM account A2)
AND A1.account_id = V.account_id
GROUP BY A1.account_id, A1.first_name, A1.last_name
HAVING count(V.account_id) >= 6;

-- 9 What accounts reported an above average household size in 2019 (based on 2018 average)
-- and owned more than 3 times the average number of vehicles?
-- Use subqueries.
SELECT A1.account_id, A1.first_name, A1.last_name, count(V1.account_id) as 'vehicle count'
FROM account A1, vehicle V1
WHERE A1.householdsize_2019 >
(SELECT avg(CAST(A2.householdsize_2018 as decimal))
FROM account A2)
AND A1.account_id = V1.account_id
GROUP BY A1.account_id, A1.first_name, A1.last_name
HAVING count(V1.account_id) > (
	SELECT avg(T.vehicles) * 3 FROM
	(
		SELECT A3.account_id, count(V2.account_id) as vehicles
		FROM account A3, vehicle V2
		WHERE A3.account_id = V2.account_id
		GROUP BY A3.account_id
	) T
);

-- 10 What accounts own a Chevrolet or a Ford?  Sort by account_id.
SELECT distinct A.account_id, A.first_name, A.last_name
FROM account A, vehicle V
WHERE A.account_id = V.account_id
AND V.vehicle_make IN ('Chevrolet', 'Ford')
ORDER BY A.account_id;

-- 11 What accounts own a Chevrolet and a Ford?
SELECT distinct A.account_id, A.first_name, A.last_name
FROM account A, vehicle V
WHERE A.account_id = V.account_id
AND A.account_id in (SELECT account_id FROM vehicle WHERE vehicle_make = 'Chevrolet')
AND A.account_id in (SELECT account_id FROM vehicle WHERE vehicle_make = 'Ford')
ORDER BY A.account_id;

-- 12 What accounts own a Chevrolet and a Ford but not a Dodge?
SELECT distinct A.account_id, A.first_name, A.last_name
FROM account A, vehicle V
WHERE A.account_id = V.account_id
AND A.account_id in (SELECT account_id FROM vehicle WHERE vehicle_make = 'Chevrolet')
AND A.account_id in (SELECT account_id FROM vehicle WHERE vehicle_make = 'Ford')
AND A.account_id not in (SELECT account_id FROM vehicle WHERE vehicle_make = 'Dodge')
ORDER BY A.account_id;

-- 13 What accounts own multiple GMC vehicles and two out of the following four makes?
-- Dodge,  Chevrolet, BMW, Toyota.
SELECT distinct A.account_id, A.first_name, A.last_name
FROM account A, vehicle V
WHERE A.account_id = V.account_id
AND EXISTS
(
	SELECT V1.account_id, count(V1.account_id)
	FROM vehicle V1
	WHERE V1.vehicle_make = 'GMC'
	AND V1.account_id = A.account_id
	GROUP BY V1.account_id HAVING count(V1.account_id) > 1
)
AND EXISTS
(
	SELECT V2.account_id, count(V2.account_id)
	FROM vehicle V2
	WHERE V2.vehicle_make in ('Dodge', 'Chevrolet', 'BMW', 'Toyota')
	AND V2.account_id = A.account_id
	GROUP BY V2.account_id HAVING count(V2.account_id) = 2
)
ORDER BY A.account_id;

-- 14 Prepare a list of accounts (by account_id) that represents customers that either
-- have a household size greater than 4 as of 2019 or
-- have more than 5 vehicles.
-- Use a union.
SELECT A1.account_id
FROM account A1
WHERE A1.householdsize_2019 > 4
UNION
SELECT A2.account_id
FROM account A2
WHERE EXISTS
(
	SELECT V.account_id, count(V.account_id)
	FROM vehicle V
	WHERE V.account_id = A2.account_id
	GROUP BY V.account_id
	HAVING count(V.account_id) > 5
);
