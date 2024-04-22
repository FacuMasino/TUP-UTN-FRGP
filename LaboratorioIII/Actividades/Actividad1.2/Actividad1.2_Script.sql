USE CURSOS_UNIV
GO
CREATE TABLE usuarios
(
	id_usuario int IDENTITY(0,1) NOT NULL,
	nick_usuario varchar(50) NOT NULL,
	email_usuario varchar (60) NOT NULL,
	PRIMARY KEY (id_usuario)
)
GO
CREATE TABLE paises
(
	id_pais int NOT NULL,
	nombre_pais varchar(50) NOT NULL,
	PRIMARY KEY (id_pais)
)
GO
CREATE TABLE localidades
(
	codigo_postal int NOT NULL,
	nombre_localidad varchar(50) NOT NULL,
	id_pais int NOT NULL,
	PRIMARY KEY (codigo_postal),
	FOREIGN KEY (id_pais) REFERENCES paises(id_pais)
)
GO
CREATE TABLE domicilios
(
	id_domicilio int IDENTITY(0,1) NOT NULL,
	direccion varchar(50) NOT NULL,
	codigo_postal int NOT NULL,
	PRIMARY KEY (id_domicilio),
	FOREIGN KEY (codigo_postal) REFERENCES localidades(codigo_postal)
)
GO
CREATE TABLE personas
(
	id_usuario int NOT NULL,
	id_domicilio int NOT NULL,
	nombre varchar(50) NOT NULL,
	otros_nombres varchar(50),
	apellido varchar(50) NOT NULL,
	genero char(1),
	telefono varchar(10),
	PRIMARY KEY (id_usuario),
	FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
	FOREIGN KEY (id_domicilio) REFERENCES domicilios(id_domicilio)
)
GO
CREATE TABLE instructores_cursos
(
	id_instructor_curso int NOT NULL,
	id_curso int NOT NULL,
	PRIMARY KEY (id_instructor_curso, id_curso),
	FOREIGN KEY (id_curso) REFERENCES cursos(id_curso),
	FOREIGN KEY (id_instructor_curso) REFERENCES usuarios(id_usuario)
)
GO
CREATE TABLE inscripciones
(
	id_inscripcion int NOT NULL,
	id_usuario int NOT NULL,
	id_curso int NOT NULL,
	fecha_inscripcion date NOT NULL,
	-- No puede haber mas de una inscripcion en la misma fecha
	-- para un mismo curso-usuario
	CONSTRAINT UNQ_inscripcion_fecha UNIQUE(id_usuario, id_curso, fecha_inscripcion),
	FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario),
	FOREIGN KEY (id_curso) REFERENCES cursos(id_curso),
	PRIMARY KEY (id_inscripcion)
)
GO
CREATE TABLE certificaciones
(
	id_certificacion int NOT NULL,
	id_inscripcion int NOT NULL UNIQUE,
	fecha_certificacion date NOT NULL,
	costo_certificacion money NOT NULL,
	PRIMARY KEY (id_certificacion),
	FOREIGN KEY (id_inscripcion) REFERENCES inscripciones(id_inscripcion)
)
GO
CREATE TABLE pagos
(
	id_pago int NOT NULL,
	id_inscripcion int NOT NULL,
	fecha_pago date NOT NULL,
	monto money NOT NULL,
	PRIMARY KEY (id_pago),
	FOREIGN KEY (id_inscripcion) REFERENCES inscripciones(id_inscripcion),
	CONSTRAINT CHK_monto CHECK (monto>0)
)
GO
CREATE TABLE resenias
(
	id_resenia int NOT NULL,
	id_inscripcion int NOT NULL UNIQUE,
	comentario varchar(100) NOT NULL,
	FOREIGN KEY (id_inscripcion) REFERENCES inscripciones(id_inscripcion),
	PRIMARY KEY (id_resenia)
)
GO