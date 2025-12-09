-- CTE  Common Table Expression 
-- Clean & Readable code 
-- Re-usability 

--WITH expression_name[(column_name [,...])]
--AS
--    (CTE_definition)
--SQL_statement;

WITH tables_data
AS 
(
	select * from sales.customers
)
select * from tables_data;

select 
	sf.first_name + ' ' + sf.last_name as staff_name,
	SUM((ot.quantity * ot.list_price) * (1- ot.discount)) as sales
from sales.staffs sf
inner join sales.orders o on o.staff_id = sf.staff_id
inner join sales.order_items ot on ot.order_id = o.order_id
group by sf.first_name + ' ' + sf.last_name;

select * from sales.order_items;

-- 1 - 0.2 == 0.8 80%
--100 20% -- 100 -20 == 80
-- 100 * 80% == 80


WITH sales_cte as (
	select 
		sf.first_name + ' ' + sf.last_name as staff_name,

		SUM((ot.quantity * ot.list_price) * (1- ot.discount)) as sales
	from sales.staffs sf
		inner join sales.orders o on o.staff_id = sf.staff_id
		inner join sales.order_items ot on ot.order_id = o.order_id
	group by sf.first_name + ' ' + sf.last_name
)
select * from sales_cte
where model_year = 2017
;


WITH sales_cte as (
	select 
		sf.first_name + ' ' + sf.last_name as staff_name,
		YEAR(o.order_date) as order_year,
		SUM((ot.quantity * ot.list_price) * (1- ot.discount)) as sales
	from sales.staffs sf
		inner join sales.orders o on o.staff_id = sf.staff_id
		inner join sales.order_items ot on ot.order_id = o.order_id
	group by sf.first_name + ' ' + sf.last_name,
	YEAR(o.order_date)
)
select * from sales_cte
WHERE order_year = 2016;


select * from 
	(select 
		sf.first_name + ' ' + sf.last_name as staff_name,

		SUM((ot.quantity * ot.list_price) * (1- ot.discount)) as sales
	from sales.staffs sf
		inner join sales.orders o on o.staff_id = sf.staff_id
		inner join sales.order_items ot on ot.order_id = o.order_id
	group by sf.first_name + ' ' + sf.last_name)
sales
;



WITH cte_sales AS (
    SELECT 
        staff_id, 
        COUNT(*) order_count  
    FROM
        sales.orders
    WHERE 
        YEAR(order_date) = 2018
    GROUP BY
        staff_id

)
SELECT
    AVG(order_count) average_orders_by_staff
FROM 
    cte_sales;


WITH cte_category_counts (
    category_id, 
    category_name, 
    product_count
)
AS (
    SELECT 
        c.category_id, 
        c.category_name, 
        COUNT(p.product_id)
    FROM 
        production.products p
        INNER JOIN production.categories c 
            ON c.category_id = p.category_id
    GROUP BY 
        c.category_id, 
        c.category_name
),
cte_category_sales(category_id, sales) AS (
    SELECT    
        p.category_id, 
        SUM(i.quantity * i.list_price * (1 - i.discount))
    FROM    
        sales.order_items i
        INNER JOIN production.products p 
            ON p.product_id = i.product_id
        INNER JOIN sales.orders o 
            ON o.order_id = i.order_id
    WHERE order_status = 4 -- completed
    GROUP BY 
        p.category_id
) 

SELECT 
    c.category_id, 
    c.category_name, 
    c.product_count, 
    s.sales
FROM
    cte_category_counts c
    INNER JOIN cte_category_sales s 
        ON s.category_id = c.category_id
ORDER BY 
    c.category_name;

-- Piovt 
-- convert rows to columns


SELECT 
    category_name, 
    COUNT(product_id) product_count
FROM 
    production.products p
    INNER JOIN production.categories c 
        ON c.category_id = p.category_id
GROUP BY 
    category_name;


-- Syntax
-- select from table 
-- PIVOT 
-- AGGREGATE FUNCTION 
-- FOR (LIST) IN (columns) as pivot 

SELECT * FROM (
    SELECT 
        category_name, -- PIVOT COLUMN 
        product_id -- AGG COLUMN 
    FROM 
        production.products p
        INNER JOIN production.categories c 
            ON c.category_id = p.category_id
) t
PIVOT (
	COUNT(product_id)
    FOR category_name IN (
        [Children Bicycles], 
        [Comfort Bicycles], 
        [Cruisers Bicycles], 
        [Cyclocross Bicycles], 
        [Electric Bikes], 
        [Mountain Bikes], 
        [Road Bikes])
) AS pivot_table;



SELECT * FROM   
(
    SELECT 
        category_name, -- pivot column
        product_id, -- agg column
        model_year -- grouping column 
    FROM 
        production.products p
        INNER JOIN production.categories c 
            ON c.category_id = p.category_id
) t 
PIVOT(
    COUNT(product_id) 
    FOR category_name IN (
        [Children Bicycles], 
        [Comfort Bicycles], 
        [Cruisers Bicycles], 
        [Cyclocross Bicycles], 
        [Electric Bikes], 
        [Mountain Bikes], 
        [Road Bikes])
) AS pivot_table;



-- insert 
--INSERT INTO table_name (column_list)
--VALUES (value_list);


CREATE TABLE sales.promotions (
    promotion_id INT PRIMARY KEY IDENTITY (1, 1),
    promotion_name VARCHAR (255) NOT NULL,
    discount NUMERIC (3, 2) DEFAULT 0,
    start_date DATE NOT NULL,
    expired_date DATE NOT NULL
); 


INSERT INTO sales.promotions (
    promotion_name,
    discount,
    start_date,
    expired_date
) OUTPUT inserted.promotion_id
VALUES
    (
        '2019 Spring Promotion',
        0.25,	
        '20190201',
        '20190301'
    );


SELECT * FROM sales.promotions;

UPDATE sales.promotions
SET discount = 0.5
where promotion_id = 1

delete from sales.promotions
where promotion_id = 1;


-- merge 

CREATE TABLE sales.category (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(255) NOT NULL,
    amount DECIMAL(10 , 2 )
);

INSERT INTO sales.category(category_id, category_name, amount)
VALUES(1,'Children Bicycles',15000),
    (2,'Comfort Bicycles',25000),
    (3,'Cruisers Bicycles',13000),
    (4,'Cyclocross Bicycles',10000);


CREATE TABLE sales.category_staging (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(255) NOT NULL,
    amount DECIMAL(10 , 2 )
);


INSERT INTO sales.category_staging(category_id, category_name, amount)
VALUES(1,'Children Bicycles',15000),
    (3,'Cruisers Bicycles',13000),
    (4,'Cyclocross Bicycles',20000),
    (5,'Electric Bikes',10000),
    (6,'Mountain Bikes',10000);

select * from sales.category_staging;

CREATE TABLE sales.category (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(255) NOT NULL,
    amount DECIMAL(10 , 2 )
);

INSERT INTO sales.category(category_id, category_name, amount)
VALUES(1,'Children Bicycles',15000),
    (2,'Comfort Bicycles',25000),
    (3,'Cruisers Bicycles',13000),
    (4,'Cyclocross Bicycles',10000);
