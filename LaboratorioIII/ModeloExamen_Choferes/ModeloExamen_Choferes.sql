
Create Database ModeloExamen20232C
GO
Use ModeloExamen20232C

-- Tabla Choferes
CREATE TABLE Choferes (
    ID bigint NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Apellidos varchar(100) NOT NULL,
    Nombres varchar(100) NOT NULL,
    FechaRegistro date NOT NULL,
    FechaNacimiento date NOT NULL,
    IDVehiculo bigint NOT NULL,
    Suspendido bit NOT NULL
);

-- Tabla Vehiculos
CREATE TABLE Vehiculos (
    ID bigint NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Patente varchar(8) NOT NULL,
    AñoPatentamiento smallint NOT NULL,
    Marca varchar(50) NOT NULL,
    Modelo varchar(50) NOT NULL
);

-- Tabla Clientes
CREATE TABLE Clientes (
    ID bigint NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Apellidos varchar(100) NOT NULL,
    Nombres varchar(100) NOT NULL,
    Telefono varchar(30),
    Email varchar(120),
    TelefonoVerificado bit NOT NULL,
    EmailVerificado bit NOT NULL
);

-- Tabla FormasPago
CREATE TABLE FormasPago (
    ID int NOT NULL IDENTITY(1,1) PRIMARY KEY,
    Nombre varchar(50) NOT NULL
);

-- Tabla Viajes
CREATE TABLE Viajes (
    ID bigint NOT NULL IDENTITY(1,1) PRIMARY KEY,
    IDCliente bigint,
    IDChofer bigint NOT NULL,
    FormaPago int,
    Inicio datetime,
    Fin datetime,
    Kms decimal(10,2) NOT NULL,
    Importe money NOT NULL,
    Pagado bit NOT NULL,
    FOREIGN KEY (IDCliente) REFERENCES Clientes(ID),
    FOREIGN KEY (IDChofer) REFERENCES Choferes(ID),
    FOREIGN KEY (FormaPago) REFERENCES FormasPago(ID)
);

-- Tabla Puntos
CREATE TABLE Puntos (
    ID bigint NOT NULL IDENTITY(1,1) PRIMARY KEY,
    IDCliente bigint NOT NULL,
    IDViaje bigint,
    Fecha datetime NOT NULL,
    PuntosObtenidos int NOT NULL,
    FechaVencimiento date NOT NULL,
    FOREIGN KEY (IDCliente) REFERENCES Clientes(ID),
    FOREIGN KEY (IDViaje) REFERENCES Viajes(ID)
);

-- Agregar clave foránea a Choferes para IDVehiculo
ALTER TABLE Choferes
ADD CONSTRAINT FK_Choferes_Vehiculos
FOREIGN KEY (IDVehiculo) REFERENCES Vehiculos(ID);