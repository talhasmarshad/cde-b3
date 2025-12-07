-- char(5) -- ayan -- fixed storage
-- varchar(5) -- ayan(4) 1(1) --

CREATE TABLE sales.activities (
    activity_id INT PRIMARY KEY IDENTITY ,
    activity_name VARCHAR (255) NOT NULL,
    activity_date DATE NOT NULL
);


CREATE TABLE sales.participants(
    activity_id int,
    customer_id int ,
    PRIMARY KEY(activity_id, customer_id)
);

ALTER TABLE sales.participants
ADD participant_name VARCHAR (255) NOT NULL;

select * from sales.participants;


CREATE TABLE sales.events(
    event_id INT NOT NULL,
    event_name VARCHAR(255),
    start_date DATE NOT NULL,
    duration DEC(5,2)
);

drop table sales.participants;

CREATE TABLE sales.participants(
    activity_id int,
    customer_id int,
    CONSTRAINT prmiary_key PRIMARY KEY(activity_id, customer_id)
);

ALTER TABLE sales.events 
ADD PRIMARY KEY(event_id);

create schema procurement;
CREATE TABLE procurement.vendor_groups (
    group_id INT IDENTITY PRIMARY KEY,
    group_name VARCHAR (100) NOT NULL
);

CREATE TABLE procurement.vendors (
        vendor_id INT IDENTITY PRIMARY KEY,
        vendor_name VARCHAR(100) NOT NULL,
        group_id INT NOT NULL,
);


select group_name, vendor_name
from vendors_group vg
inner join vendors v
on vg.group_id = v.group_id;


DROP TABLE procurement.vendors;

CREATE TABLE procurement.vendors (
        vendor_id INT IDENTITY PRIMARY KEY,
        vendor_name VARCHAR(100) NOT NULL,
        group_pid INT NOT NULL,
        CONSTRAINT fk_group FOREIGN KEY (group_pid) 
        REFERENCES procurement.vendor_groups(group_id)
);

INSERT INTO procurement.vendor_groups(group_name)
VALUES('Third-Party Vendors'),
      ('Interco Vendors'),
      ('One-time Vendors');

select * from procurement.vendor_groups;

INSERT INTO procurement.vendors(vendor_name, group_pid)
VALUES('ABC Corp',1);

INSERT INTO procurement.vendors(vendor_name, group_pid)
VALUES('XYZ Corp',4);


--FOREIGN KEY (foreign_key_columns)
--    REFERENCES parent_table(parent_key_columns)
--    ON UPDATE action 
--    ON DELETE action;



CREATE SCHEMA hr;
GO

CREATE TABLE hr.persons(
    person_id INT IDENTITY PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    phone VARCHAR(20)
);

INSERT INTO hr.persons(first_name,last_name,email)
VALUES('Moiz', 'Sami', 'aaaa@gmail.com')

select * from hr.persons;



CREATE SCHEMA hr;
GO

CREATE TABLE hr.persons_1(
    person_id INT IDENTITY PRIMARY KEY,
    first_name VARCHAR(255) NOT NULL,
    last_name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE
);


INSERT INTO hr.persons_1(first_name, last_name, email)
VALUES('John','Doe','j.doe@bike.stores');


create SCHEMA test;
CREATE TABLE test.sql_server_decimal (
    dec_col DECIMAL (4, 2), -- (
    num_col NUMERIC (4, 2)
);
INSERT INTO test.sql_server_decimal (dec_col, num_col)
VALUES
    (100.25, 20.05);

CREATE SCHEMA test;
GO

CREATE TABLE test.products_2(
    product_id INT IDENTITY PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    unit_price DEC(10,2) CHECK(unit_price > 0)
);

INSERT INTO test.products(product_name, unit_price)
VALUES ('Awesome Free Bike', NULL);

