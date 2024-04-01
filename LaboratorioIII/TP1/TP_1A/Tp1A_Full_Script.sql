CREATE DATABASE TP_1A
GO
USE TP_1A
GO
-- Tablas necesarias para los productos
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
GO
-- Tablas necesarias para las personas y su informacion
CREATE TABLE states
(
	state_id int NOT NULL,
	state_name varchar(50) NOT NULL,
	PRIMARY KEY (state_id)
)
GO
CREATE TABLE localities
(
	postal_code int NOT NULL,
	city_name varchar(50) NOT NULL,
	state_id int NOT NULL,
	PRIMARY KEY (postal_code),
	FOREIGN KEY (state_id) REFERENCES states(state_id)
)
GO
CREATE TABLE addresses
(
	address_id int NOT NULL,
	full_address varchar(50) NOT NULL,
	postal_code int NOT NULL,
	PRIMARY KEY (address_id),
	FOREIGN KEY (postal_code) REFERENCES localities(postal_code)
)
GO
CREATE TABLE people
(
	dni varchar(10) NOT NULL,
	first_name varchar(50) NOT NULL,
	second_name varchar(50),
	surname varchar(50) NOT NULL,
	address_id int NOT NULL,
	phone varchar(10) NOT NULL,
	genre char(1) NOT NULL,
	birth_date date NOT NULL,
	effective_date date NOT NULL DEFAULT (GETDATE()),
	PRIMARY KEY (dni),
	FOREIGN KEY (address_id) REFERENCES addresses(address_id),
	CONSTRAINT CHK_birth_date CHECK (DATEDIFF(YEAR,birth_date, GETDATE()) >= 18)
)
GO
-- Tablas para clientes y vendedores
CREATE TABLE clients
(
	client_dni varchar(10) NOT NULL UNIQUE,
	client_email varchar(60) NOT NULL,
	FOREIGN KEY (client_dni) REFERENCES people(dni)
)
GO
CREATE TABLE sellers
(
	seller_id int NOT NULL IDENTITY(1000,1),
	seller_dni varchar(10) NOT NULL UNIQUE,
	seller_effective_date date NOT NULL,
	seller_salary money NOT NULL,
	PRIMARY KEY (seller_id),
	FOREIGN KEY (seller_dni) REFERENCES people(dni),
	CONSTRAINT CHK_seller_salary CHECK (seller_salary > 0)
)
GO
-- Tablas para las ventas y detalle de las mismas
CREATE TABLE sales
(
	invoice_number int NOT NULL IDENTITY (1000,1),
	sale_date date NOT NULL,
	client_dni varchar(10) NOT NULL,
	seller_id int NOT NULL,
	payment_method char(1) NOT NULL,
	sale_amount money NOT NULL,
	PRIMARY KEY (invoice_number),
	FOREIGN KEY (client_dni) REFERENCES clients(client_dni),
	FOREIGN KEY (seller_id) REFERENCES sellers(seller_id),
	CONSTRAINT CHK_AMOUNT CHECK (sale_amount > 0)
)
GO
/* Las columnas Descripcion y Marca son innecesarias
Serían columnas duplicadas que pueden obtenerse
a partir del codigo de producto */
CREATE TABLE sales_items
(
	invoice_number int NOT NULL,
	prod_code varchar(6) NOT NULL,
	unit_price money NOT NULL,
	prod_qty int NOT NULL,
	PRIMARY KEY (invoice_number, prod_code),
	FOREIGN KEY (invoice_number) REFERENCES sales(invoice_number),
	FOREIGN KEY (prod_code) REFERENCES products(prod_code)
)

-- Respuestas
/*
	A) La mejor manera de indicar que un articulo
	no posee marca es generando una marca en la tabla
	correspondiente que tenga como nombre "Sin marca"

	B) Creo que es correcto almacenar el precio unitario
	al momento de la compra ya que podría suceder que el
	precio del producto se actualiza en un futuro, y si
	desearamos por ej. calcular las ganancias obtenidas 
	del total de esa venta con el precio actualizado la
	relación entre el costo del producto VS la venta no
	sería correcta.
	
	C) El tipo de columna Identity permite generar valores
	numéricos que se autoincrementan.

	D) Las columnas "Total ventas realizadas en el ultimo
	mes" y "Total facturado en el ultimo mes" para la tabla
	de vendedores son innecesarias ya que se podría calcular
	a partir de obtener todas las ventas realizadas por
	ese vendedor.
*/