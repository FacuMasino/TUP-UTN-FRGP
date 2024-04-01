USE TP_1A
GO
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