USE master
GO
CREATE DATABASE CURSOS_UNIV
GO
USE CURSOS_UNIV
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