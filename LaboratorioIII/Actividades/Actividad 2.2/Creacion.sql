CREATE DATABASE Univ
GO
USE Univ
GO
CREATE TABLE Niveles
(
	ID tinyint NOT NULL PRIMARY KEY IDENTITY (1, 1),
	Nombre varchar(50) NOT NULL
)
GO
CREATE TABLE Idiomas
(
	ID smallint NOT NULL PRIMARY KEY IDENTITY (1, 1),
	Nombre varchar(50) NOT NULL
)
GO
CREATE TABLE FormatosIdioma
(
	ID tinyint NOT NULL PRIMARY KEY IDENTITY (1, 1),
	Nombre varchar(50) NOT NULL
)
GO
CREATE TABLE Categorias
(
	ID smallint NOT NULL PRIMARY KEY IDENTITY (1, 1),
	Nombre varchar(100) NOT NULL
)
GO
CREATE TABLE TiposContenido
(
	ID int NOT NULL PRIMARY KEY IDENTITY (1, 1),
	Nombre varchar(100) NOT NULL
)
GO
CREATE TABLE Cursos
(
	ID bigint NOT NULL PRIMARY KEY IDENTITY (1, 1),
	IDNivel tinyint NULL FOREIGN KEY REFERENCES Niveles(ID),
	Nombre varchar(100) NOT NULL,
	CostoCurso money NOT NULL CHECK (CostoCurso >= 0),
	CostoCertificacion money NOT NULL CHECK (CostoCertificacion >= 0),
	Estreno date NOT NULL
)
GO
CREATE TABLE Clases
(
	ID bigint NOT NULL PRIMARY KEY IDENTITY (1, 1),
	IDCurso bigint NOT NULL FOREIGN KEY REFERENCES Cursos(ID),
	Nombre varchar(100) NOT NULL,
	Numero smallint NULL CHECK (Numero >= 0),
	Duracion int NOT NULL CHECK (Duracion > 0)
)
GO
CREATE TABLE Contenidos
(
	ID bigint NOT NULL PRIMARY KEY IDENTITY (1, 1),
	IDClase bigint NOT NULL FOREIGN KEY REFERENCES Clases(ID),
	IDTipo int NOT NULL FOREIGN KEY REFERENCES TiposContenido(ID),
	Tamaño int NOT NULL CHECK (Tamaño > 0)
)
GO
CREATE TABLE Idiomas_x_Curso
(
	IDCurso bigint NOT NULL FOREIGN KEY REFERENCES Cursos(ID),
	IDIdioma smallint NOT NULL FOREIGN KEY REFERENCES Idiomas(ID),
	IDFormatoIdioma tinyint NOT NULL FOREIGN KEY REFERENCES FormatosIdioma(ID),
	PRIMARY KEY (IDCurso, IDIdioma, IDFormatoIdioma)
)
GO
CREATE TABLE Categorias_x_Curso
(
	IDCurso bigint NOT NULL FOREIGN KEY REFERENCES Cursos(ID),
	IDCategoria smallint NOT NULL FOREIGN KEY REFERENCES Categorias(ID),
	PRIMARY KEY (IDCurso, IDCategoria)
)
GO
CREATE TABLE Paises
(
	ID smallint NOT NULL PRIMARY KEY,
	Nombre varchar(50) NOT NULL
)
GO
CREATE TABLE Localidades
(
	ID int NOT NULL PRIMARY KEY,
	IDPais smallint NOT NULL FOREIGN KEY REFERENCES Paises(ID),
	Nombre varchar(50) NOT NULL
)
GO
CREATE TABLE Usuarios
(
	ID bigint NOT NULL PRIMARY KEY IDENTITY (1, 1),
	NombreUsuario varchar(50) NOT NULL UNIQUE,
)
GO
CREATE TABLE Datos_Personales
(
	ID bigint NOT NULL PRIMARY KEY FOREIGN KEY REFERENCES Usuarios(ID),
	Apellidos varchar(100) NOT NULL,
	Nombres varchar(100) NOT NULL,
	Nacimiento date NOT NULL,
	Genero char NULL,
	Telefono varchar(15) NULL,
	Celular varchar(15) NULL,
	Email varchar(140) NULL,
	Domicilio varchar(200) NOT NULL,
	IDLocalidad int NOT NULL FOREIGN KEY REFERENCES Localidades(ID)
)
GO
CREATE TABLE Inscripciones
(
	ID bigint NOT NULL PRIMARY KEY IDENTITY (1, 1),
	IDUsuario bigint NOT NULL FOREIGN KEY REFERENCES Usuarios(ID),
	IDCurso bigint NOT NULL FOREIGN KEY REFERENCES Cursos(ID),
	Fecha date NOT NULL DEFAULT(getdate()),
	Costo money NOT NULL CHECK (Costo >= 0)
)
GO
CREATE TABLE Pagos
(
	ID bigint NOT NULL PRIMARY KEY IDENTITY (1, 1),
	IDInscripcion bigint NOT NULL FOREIGN KEY REFERENCES Inscripciones(ID),
	Fecha date NOT NULL DEFAULT(getdate()),
	Importe money NOT NULL CHECK(Importe > 0)
)
GO
CREATE TABLE Certificaciones
(
	IDInscripcion bigint NOT NULL PRIMARY KEY FOREIGN KEY REFERENCES Inscripciones(ID),
	Fecha date NOT NULL DEFAULT(getdate()),
	Costo money NOT NULL CHECK(Costo >= 0)
)
GO
CREATE TABLE Reseñas
(
	IDInscripcion bigint NOT NULL PRIMARY KEY FOREIGN KEY REFERENCES Inscripciones(ID),
	Fecha date NOT NULL DEFAULT(getdate()),
	Observaciones varchar(MAX) NOT NULL,
	Puntaje decimal(3, 1) NOT NULL,
	Inapropiada bit NOT NULL DEFAULT(0)
)
GO
CREATE TABLE Instructores_x_Curso
(
	IDUsuario bigint NOT NULL FOREIGN KEY REFERENCES Usuarios(ID),
	IDCurso bigint NOT NULL FOREIGN KEY REFERENCES Cursos(ID),
	PRIMARY KEY (IDUsuario, IDCurso)
)