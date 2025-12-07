Select * from students
where marks > 80;

Select avg(marks) from students; -- inner query 

select * from students -- outer query 
where marks > (Select avg(marks) from students)

-- IN 
-- [1,2,3,4]
-- x = 2
-- if x in  list:
--		print(x)

SELECT
    order_id,
    order_date,
    customer_id
FROM
    sales.orders
WHERE
    customer_id IN (
        SELECT
            customer_id
        FROM
            sales.customers
        WHERE
            city = 'New York'
    )
ORDER BY
    order_date DESC;

-- do the same by joins 
select  order_id,
    order_date,
    c.customer_id FROM
    sales.orders o
inner join sales.customers c on c.customer_id = o.customer_id
where c.city = 'New York';

select * from students s -- outer query 
where marks > (
	Select avg(marks)
	from students ss
		where ss.class = s.class
	);


	SELECT
            customer_id
        FROM
            sales.customers
        WHERE
            city = 'New York';


SELECT
    product_name,
    list_price,
    category_id
FROM
    production.products p1 -- outer table 
WHERE
    list_price IN (
        SELECT
            MAX (p2.list_price)
        FROM
            production.products p2  -- inner table 
        WHERE
            p2.category_id = p1.category_id
        GROUP BY
            p2.category_id
    )
ORDER BY
    category_id,
    product_name;


-- customers who have placed orders more than twice 
select customer_id, count(*) as order_counts
from sales.orders
group by (customer_id)
having count(*) >= 2;


SELECT
    customer_id,
    first_name,
    last_name
FROM
    sales.customers c
WHERE
    EXISTS (
		select count(*) 
			from sales.orders o
			where o.customer_id = c.customer_id
			group by (customer_id)
			having count(*) >= 2
		)


 --  any 

 -- all

 -- create by your own 
 select * from students;

select * from students
where marks > all(select avg(marks) from students
group by class) -- (87, 74)
--kantesh	1	a	85
--arham	2	a	90
--sultan	3	b	65
--annas	4	b	70
--ayan	5	b	88
-- 70,80, 90 
-- any minimum check 

-->  all (satisfy all )
--- max 


SELECT
    product_name,
    list_price
FROM
    production.products
WHERE
    product_id = ANY (
        SELECT
            product_id
        FROM
            sales.order_items
        WHERE
            quantity >= 2
    )
ORDER BY
    product_name;



SELECT
    product_name,
    list_price
FROM
    production.products
WHERE
    list_price > ALL (
        SELECT
            AVG (list_price) avg_list_price
        FROM
            production.products
        GROUP BY
            brand_id
    )
ORDER BY
    list_price;


-- Set operators 
-- Same no of columns 
-- Union 

Select first_name, last_name 
	from sales.staffs -- 10
union 
Select first_name, last_name 
	from sales.customers -- 1445 + 10 --1454


Select first_name, last_name 
	from sales.staffs -- 10
union all
Select first_name, last_name 
	from sales.customers -- 1445 + 10 --1455

Select first_name, last_name 
	from sales.staffs
intersect
Select first_name, last_name 
	from sales.customers;

select first_name, last_name ,count(*)
	from sales.customers
	group by first_name, last_name
	having count(*) = 2; 

-- [1,2,3,4] - [2,3,4,5] 
-- 1

SELECT
    product_id
FROM
    production.products
EXCEPT
SELECT
    product_id
FROM
    sales.order_items;
