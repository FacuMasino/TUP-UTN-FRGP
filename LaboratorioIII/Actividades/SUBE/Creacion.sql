CREATE DATABASE SUBE
GO

Use SUBE

CREATE TABLE Localidades (
	IdLocalidad int NOT NULL IDENTITY(1,1) PRIMARY KEY,
	Nombre varchar(100) NOT NULL
)
GO

CREATE TABLE Usuarios (
	IdUsuario bigint NOT NULL IDENTITY (1,1) PRIMARY KEY,
	Nombres varchar(100) NOT NULL,
	Apellidos varchar(100) NOT NULL,
	DNI varchar(8) NOT NULL,
	Domicilio varchar(200) NOT NULL,
	FechaNacimiento date NOT NULL,
	Estado bit NOT NULL Default 1
)
GO

CREATE TABLE Tarjetas (
	IdTarjeta bigint NOT NULL IDENTITY(1,1) PRIMARY KEY,
	NroTarjeta varchar(16) NOT NULL UNIQUE,
	IdUsuario bigint NOT NULL FOREIGN KEY REFERENCES Usuarios(IdUsuario),
	FechaAlta date NOT NULL,
	Saldo money NOT NULL,
	Estado bit NOT NULL Default 1,
	CONSTRAINT CHK_Saldo Check (Saldo >= 0)
)
GO

CREATE TABLE Empresas (
	IdEmpresa bigint NOT NULL IDENTITY(1,1) PRIMARY KEY,
	Nombre varchar(100) NOT NULL,
	Domicilio varchar(200) NOT NULL,
	IdLocalidad int NOT NULL REFERENCES Localidades(IdLocalidad)
)
GO

CREATE TABLE Lineas_de_Colectivos (
	IdLinea bigint NOT NULL IDENTITY(1,1) PRIMARY KEY,
	NroLinea int NOT NULL UNIQUE,
	IdEmpresa bigint NOT NULL FOREIGN KEY REFERENCES Empresas(IdEmpresa),
)
GO

CREATE TABLE Colectivos (
	IdColectivo bigint NOT NULL IDENTITY(1,1) PRIMARY KEY,
	NroInterno int NOT NULL,
	IdLinea bigint NOT NULL REFERENCES Lineas_de_Colectivos(IdLinea)
	CONSTRAINT UQ_NroInterno_IdLinea UNIQUE (NroInterno, IdLinea)
)
GO

CREATE TABLE Movimientos (
	IdMovimiento bigint NOT NULL IDENTITY(1,1) PRIMARY KEY,
	FechaHora datetime NOT NULL,
	IdTarjeta bigint NOT NULL FOREIGN KEY REFERENCES Tarjetas(IdTarjeta),
	Importe money NOT NULL,
	Tipo char(1) NOT NULL,
	CONSTRAINT CHK_Importe CHECK (Importe > 0),
	CONSTRAINT CHK_Tipo CHECK (Tipo LIKE 'D' OR Tipo LIKE 'C')
)
GO

CREATE TABLE Viajes (
	IdViaje bigint NOT NULL IDENTITY(1,1) PRIMARY KEY,
	IdColectivo bigint NOT NULL FOREIGN KEY REFERENCES Colectivos(IdColectivo),
	IdMovimiento bigint NOT NULL FOREIGN KEY REFERENCES Movimientos(IdMovimiento)
)
GO


