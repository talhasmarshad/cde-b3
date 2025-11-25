USE BikeStores;

SELECT * FROM [sales].[customers];

-- group by, having
SELECT
	state,
	COUNT(state) AS customer_per_state
FROM [sales].[customers]
GROUP BY state
HAVING count(state) > 200;

SELECT 
	brand,
	category,
	SUM(sales) as total_sales
FROM [sales].[sales_summary]
GROUP BY brand, category;

-- GROUPING SETs
--a,b = (), (a), (b), (a,b)
--eg: brand, category
--	- total ()
--	- per brand (brand)
--	- per category (category)
--	- per brand per cateogory (brand, cateogry)

SELECT 
	brand,
	category,
	SUM(sales) as total_sales
FROM [sales].[sales_summary]
GROUP BY
 GROUPING SETS (
	(),
	(brand),
	(category),
	(brand, category)
 );

-- CUBE
SELECT 
	brand,
	category,
	SUM(sales) as total_sales
FROM [sales].[sales_summary]
GROUP BY
	CUBE(brand, category);

-- ROLLUP
--()
--(brand)
--(brand, category)
--(brand, category, model_year)
SELECT 
	brand,
	category,
	SUM(sales) as total_sales
FROM [sales].[sales_summary]
GROUP BY
	ROLLUP(brand, category);

-- ROLLUP
--()
--(brand)
--(brand, category)
--(brand, category, model_year)
SELECT 
	brand,
	category,
	SUM(sales) as total_sales
FROM [sales].[sales_summary]
GROUP BY
	ROLLUP(category,);


-- SUB-QUERY

SELECT customer_id, state FROM [sales].[customers] WHERE state = 'NY';

SELECT * FROM [sales].[orders] 
WHERE customer_id IN (
	SELECT customer_id 
	FROM [sales].[customers] 
	WHERE state = 'NY'
);
-- SQL Server Correlated Subquery
select product_name, list_price, category_id 
from [production].[products] AS p1
WHERE
    list_price IN (
        SELECT
            MAX (p2.list_price)
        FROM
            [production].[products] AS p2
        WHERE
            p2.category_id = p1.category_id
        GROUP BY
            p2.category_id
    )
ORDER BY
    category_id,
    product_name;

IF NOT EXISTS (
    SELECT 1 FROM sys.databases WHERE name = 'YourDatabaseName'
)
BEGIN
    CREATE DATABASE YourDatabaseName;
END

IF NOT EXISTS(
 SELECT name FROM sys.databases WHERE name = 'MISC'
)
BEGIN
	CREATE DATABASE testing;
END      




