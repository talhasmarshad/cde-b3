-- Querying data

-- fully qualified naming
-- [BikeStores].[sales].[customers]
-- [database].[schema].[table/view]

SELECT * FROM [BikeStores].[sales].[customers];

SELECT first_name FROM [BikeStores].[sales].[customers];

SELECT first_name, last_name FROM [BikeStores].[sales].[customers];

-- condition (WHERE)

SELECT * FROM [BikeStores].[sales].[customers] WHERE state = 'NY';
SELECT * FROM [BikeStores].[sales].[customers] WHERE customer_id > 100;
SELECT * FROM [BikeStores].[sales].[customers] WHERE state <> 'NY';

-- Operatos (AND, OR, NOT)

SELECT * FROM [BikeStores].[sales].[customers] WHERE customer_id > 100 AND state = 'NY';
SELECT * FROM [BikeStores].[sales].[customers] WHERE phone IS NOT NULL; -- recommended
SELECT * FROM [BikeStores].[sales].[customers] WHERE phone <> 'NULL';

-- Sorting ORDER BY, ASC/DESC(Optional: default ASC)

SELECT * FROM [BikeStores].[sales].[customers] ORDER BY first_name;
SELECT * FROM [BikeStores].[sales].[customers] ORDER BY first_name, state;
SELECT * FROM [BikeStores].[sales].[customers] ORDER BY state, first_name;

SELECT * 
FROM [BikeStores].[sales].[customers] 
ORDER BY state DESC, first_name ASC;

SELECT * 
FROM [BikeStores].[sales].[customers] 
ORDER BY state DESC, first_name DESC;

-- limiting ( TOP

SELECT TOP(15) * 
FROM [BikeStores].[sales].[customers];

