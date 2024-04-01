USE TP_1A
GO
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