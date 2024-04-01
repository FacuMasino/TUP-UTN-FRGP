USE TP_1A
GO
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