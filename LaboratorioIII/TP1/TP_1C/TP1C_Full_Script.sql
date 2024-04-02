-- Create a new database called 'TP_1C'
-- Connect to the 'master' database to run this snippet
USE master
GO
-- Create the new database if it does not exist already
IF NOT EXISTS (
	SELECT name
FROM sys.databases
WHERE name = N'TP_1C'
)
CREATE DATABASE TP_1C
GO
USE TP_1C
GO
CREATE TABLE docentes
(
	legajo int NOT NULL,
	dni varchar(10) NOT NULL UNIQUE,
	nombre_docente varchar(50) NOT NULL,
	apellido_docente varchar(50) NOT NULL,
	fecha_nacimiento date NOT NULL,
	PRIMARY KEY (legajo),
	CONSTRAINT CHK_FECHA_NACIMIENTO CHECK(DATEDIFF(YEAR, fecha_nacimiento, GETDATE()) >= 18)
)
GO
CREATE TABLE carreras
(
	codigo_carrera int NOT NULL,
	nombre_carrera varchar(60) NOT NULL,
	resolucion varchar(30) NOT NULL,
	PRIMARY KEY (codigo_carrera)
)
GO
CREATE TABLE materias
(
	codigo_materia int NOT NULL,
	nombre_materia varchar(60) NOT NULL,
	codigo_carrera int NOT NULL,
	PRIMARY KEY (codigo_materia),
	FOREIGN KEY (codigo_carrera) REFERENCES carreras(codigo_carrera)
)
GO
CREATE TABLE cargos_docentes
(
	id_cargo int NOT NULL,
	nombre_cargo varchar(50) NOT NULL,
	PRIMARY KEY (id_cargo)
)
GO
CREATE TABLE plantas_docentes
(
	codigo_materia int NOT NULL,
	legajo_docente int NOT NULL,
	id_cargo int NOT NULL,
	anio int NOT NULL,
	PRIMARY KEY (codigo_materia, legajo_docente, id_cargo),
	FOREIGN KEY (codigo_materia) REFERENCES materias(codigo_materia),
	FOREIGN KEY (legajo_docente) REFERENCES docentes(legajo),
	FOREIGN KEY (id_cargo) REFERENCES cargos_docentes(id_cargo)
)
