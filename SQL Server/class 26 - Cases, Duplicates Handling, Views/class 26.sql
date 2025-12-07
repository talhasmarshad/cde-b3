-- CASES

--CASE input   
--    WHEN e1 THEN r1
--    WHEN e2 THEN r2
--    ...
--    WHEN en THEN rn
--    [ ELSE re ]   
--END

SELECT DISTINCT order_status FROM [sales].[orders];

--1 -> 'Pending'
--2 -> 'Processing'
--3 -> 'Rejected'
--4 -> 'Completed'

SELECT 
	CASE order_status
	WHEN 1 THEN 'Pending'
	WHEN 2 THEN 'Processing'
	WHEN 3 THEN 'Rejected'
	WHEN 4 THEN 'Completed'
	END AS modified_or_status,
	count(*) AS or_status_count
FROM [sales].[orders]
GROUP BY order_status;
	--CASE order_status
	--WHEN 1 THEN 'Pending'
	--WHEN 2 THEN 'Processing'
	--WHEN 3 THEN 'Rejected'
	--WHEN 4 THEN 'Completed'
	--END;

--PROBLEM:
-----------
--price --> 500 --> vlow
--price --> 1000 --> low
--price --> 5000 --> Medium
--price --> 10000 --> high
--price --> 100000> --> vhigh

SELECT 
	o.order_id,
	sum(quantity * list_price) as order_value,
	case
	when sum(quantity * list_price) <= 500
	then 'very low'
	when sum(quantity * list_price) > 500
	and sum(quantity * list_price) <= 1000
	then 'low'
	when sum(quantity * list_price) > 1000
	and sum(quantity * list_price) <= 5000
	then 'medium'
	when sum(quantity * list_price) > 5000
	and sum(quantity * list_price) <= 10000
	then 'high'
	when sum(quantity * list_price) > 10000
	then 'very high'
	end order_priority
FROM [sales].[order_items] o
group by o.order_id;

-- COALESCE

SELECT COALESCE('Hi', NULL);
SELECT COALESCE(NULL, 'Hello');

--phone --> NULL ('N/A')

SELECT 
	first_name,
	last_name,
	COALESCE(phone, 'N/A') as phone
FROM [sales].[customers];

-- NULLIF
-- lhs == rhs (lhs)
-- lhs != rhs (NULL)

-- HANDLING DUPLICATES
------------------------

DROP TABLE IF EXISTS t1;
CREATE TABLE t1 (
    id INT IDENTITY(1, 1), 
    a  INT, 
    b  INT, 
    PRIMARY KEY(id)
);

INSERT INTO
    t1(a,b)
VALUES
    (1,1),
    (1,2),
    (1,3),
    (2,1),
    (1,2),
    (1,3),
    (2,1),
    (2,2);

SELECT
	a,
	b,
	count(*) records_count
FROM t1
GROUP BY a,b
HAVING count(*) < 2;

SELECT
	a,
	b,
	count(*) records_count
FROM t1
GROUP BY a,b
HAVING count(*) > 1;

SELECT DISTINCT id, a,b FROM t1;

--id col1 col2 = col_new
--1  1,     2  =  1
--2  1,     2  =  2

WITH cte_duplicates AS (
	SELECT
		id,
		a,
		b,
		ROW_NUMBER() OVER (
			PARTITION BY a, b
			ORDER BY a, b
		) AS rn
	FROM t1
)
SELECT id, a,b FROM cte_duplicates WHERE rn = 1;

-- VIEWS

CREATE VIEW product_catalog
AS SELECT 
	p.product_id,
	p.product_name,
	p.model_year,
	p.list_price,
	c.category_id,
	c.category_name,
	b.brand_id,
	b.brand_name,
	s.quantity,
	s.store_id
FROM [production].[products] p
JOIN [production].[categories] c
ON p.category_id = c.category_id
JOIN [production].[brands] b
ON p.brand_id = b.brand_id
JOIN [production].[stocks] s
ON p.product_id = s.product_id;

SELECT * FROM [dbo].[product_catalog];

-- listing the view

SELECT name FROM sys.views;
SELECT * FROM sys.objects WHERE type = 'V';

-- get ddl
SELECT * FROM sys.sql_modules;

DROP VIEW [dbo].[product_catalog];