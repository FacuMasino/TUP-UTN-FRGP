CREATE DATABASE TP_1A
GO
USE TP_1A
GO
CREATE TABLE product_types
(
	type_id int NOT NULL,
	type_name varchar(50) NOT NULL,
	PRIMARY KEY (type_id)
)
CREATE TABLE product_brands
(
	brand_id int NOT NULL,
	brand_name varchar(30) NOT NULL,
	PRIMARY KEY (brand_id)
)
GO
CREATE TABLE products
(
	prod_code varchar(6) NOT NULL,
	prod_description varchar(60) NOT NULL,
	prod_brand_id int NOT NULL,
	prod_type_id int NOT NULL,
	prod_sale_price money NOT NULL,
	prod_buy_price money NOT NULL,
	prod_stock int NOT NULL,
	prod_min_stock int NOT NULL,
	prod_status bit NOT NULL,
	PRIMARY KEY (prod_code),
	FOREIGN KEY (prod_brand_id) REFERENCES product_brands(brand_id),
	FOREIGN KEY (prod_type_id) REFERENCES product_types(type_id)
)
