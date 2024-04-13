-- ##################### SCRIPT ACTIVIDAD 1.1 ##################### 
USE master
GO
CREATE DATABASE CURSOS_UNIV_TEST2
GO
USE CURSOS_UNIV_TEST2
GO
CREATE TABLE cursos
(
	id_curso int NOT NULL IDENTITY (0,1),
	nombre_curso varchar(60) NOT NULL,
	fecha_inicio date NOT NULL,
	costo_curso money NOT NULL,
	costo_certificacion money NULL,
	nivel_curso varchar(30) NULL,
	PRIMARY KEY (id_curso)
)
GO
CREATE TABLE categorias
(
	id_categoria int NOT NULL,
	nombre_categoria varchar(50) NOT NULL,
	PRIMARY KEY (id_categoria)
)
GO
CREATE TABLE cursos_x_categoria
(
	id_categoria int NOT NULL,
	id_curso int NOT NULL,
	FOREIGN KEY (id_categoria) REFERENCES categorias(id_categoria),
	FOREIGN KEY (id_curso) REFERENCES cursos(id_curso),
	PRIMARY KEY (id_categoria, id_curso)
)
GO
CREATE TABLE idiomas
(
	id_idioma int NOT NULL,
	nombre_idioma varchar(30) NOT NULL,
	PRIMARY KEY (id_idioma)
)
GO
CREATE TABLE idiomas_x_curso
(
	id_idioma int NOT NULL,
	id_curso int NOT NULL,
	audio bit NOT NULL,
	subtitulo bit NOT NULL,
	PRIMARY KEY (id_idioma, id_curso),
	FOREIGN KEY (id_idioma) REFERENCES idiomas(id_idioma),
	FOREIGN KEY (id_curso) REFERENCES cursos(id_curso)
)
GO
CREATE TABLE clases
(
	id_clase int NOT NULL,
	nombre_clase varchar(60) NOT NULL,
	nro_clase int NOT NULL,
	id_curso int NOT NULL,
	duracion int NOT NULL,
	PRIMARY KEY (id_clase),
	-- no deberia haber dos nros de
	-- clase iguales para un mismo curso
	CONSTRAINT UQ_nro_clase_id_curso UNIQUE (nro_clase, id_curso),
	FOREIGN KEY (id_curso) REFERENCES cursos(id_curso),
	CONSTRAINT CHK_duracion CHECK (duracion > 0)
)
GO
CREATE TABLE tipos_contenidos
(
	id_tipo int NOT NULL,
	nombre_tipo varchar(30) NOT NULL UNIQUE,
	PRIMARY KEY (id_tipo)
)
GO
CREATE TABLE contenidos
(
	id_contenido int NOT NULL,
	id_tipo_contenido int NOT NULL,
	id_clase int NOT NULL,
	tamanio bigint NOT NULL,
	PRIMARY KEY (id_contenido),
	FOREIGN KEY (id_tipo_contenido) REFERENCES tipos_contenidos(id_tipo),
	FOREIGN KEY (id_clase) REFERENCES clases(id_clase),
	CONSTRAINT CHK_tamanio CHECK (tamanio > 0)
)
-- ##################### SCRIPT ACTIVIDAD 1.2 ##################### 
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
	id_usuario int NOT NULL,
	PRIMARY KEY (id_instructor_curso),
	FOREIGN KEY (id_curso) REFERENCES cursos(id_curso),
	FOREIGN KEY (id_usuario) REFERENCES usuarios(id_usuario)
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