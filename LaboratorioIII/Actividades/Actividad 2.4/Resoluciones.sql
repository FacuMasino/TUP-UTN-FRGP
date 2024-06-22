-- 1 Listado con apellidos y nombres de los usuarios que no se hayan
-- inscripto a cursos durante el año 2019.
SELECT Apellidos, Nombres
FROM Datos_Personales DP
WHERE DP.ID NOT IN (
	SELECT ID
FROM Inscripciones
WHERE YEAR(Inscripciones.Fecha) = 2019
)
-- Alternativa
SELECT DP.Apellidos, DP.Nombres
FROM Datos_Personales DP
	INNER JOIN usuarios U
	ON U.ID = DP.ID
WHERE DP.ID NOT IN (
	SELECT ID
FROM Inscripciones
WHERE YEAR(Inscripciones.Fecha) = 2019
)

-- 2 Listado con apellidos y nombres de los usuarios que se hayan inscripto
-- a cursos pero no hayan realizado ningún pago.
SELECT DP.Apellidos, DP.Nombres
FROM Usuarios U
	INNER JOIN Datos_Personales DP
	ON U.ID = DP.ID
	INNER JOIN Inscripciones Insc
	ON U.ID = Insc.IDUsuario
WHERE Insc.ID NOT IN (
	SELECT IDInscripcion
FROM Pagos 
)

-- 3 Listado de países que no tengan usuarios relacionados.
SELECT *
FROM Paises
WHERE Paises.ID NOT IN (
		SELECT Loc.IDPais
FROM Usuarios U
	INNER JOIN Datos_Personales DP
	ON DP.ID = U.ID
	INNER JOIN Localidades Loc
	ON Loc.ID = DP.IDLocalidad
	)

-- 4 Listado de clases cuya duración sea mayor a la duración promedio.
SELECT *
FROM Clases Cla
WHERE Cla.Duracion > (
	SELECT AVG(Duracion)
FROM clases
)

-- Alternativa con variable
DECLARE @DuracionPromedio int
SET @DuracionPromedio = (SELECT AVG(Duracion)
FROM clases)

SELECT *
FROM Clases
WHERE duracion > @DuracionPromedio

-- 5 Listado de contenidos cuyo tamaño sea mayor al tamaño de todos los
-- contenidos de tipo 'Audio de alta calidad'.
SELECT *
FROM Contenidos Con
WHERE Con.Tamaño > (
	SELECT SUM(CAudioHQ.Tamaño)
FROM Contenidos CAudioHQ
	INNER JOIN TiposContenido TC
	ON TC.ID = CAudioHQ.IDTipo
WHERE TC.Nombre = 'Audio de alta calidad' 
)

-- 6 Listado de contenidos cuyo tamaño sea menor al tamaño de algún
-- contenido de tipo 'Audio de alta calidad'.
SELECT *
FROM Contenidos Con
WHERE Con.Tamaño < ANY (
SELECT CAud.Tamaño
FROM Contenidos CAud
	INNER JOIN TiposContenido TC
	ON CAud.IdTipo = TC.ID
WHERE TC.Nombre = 'Audio de alta calidad'
)

-- 7 Listado con nombre de país y la cantidad de usuarios de género
-- masculino y la cantidad de usuarios de género femenino que haya
-- registrado.
SELECT p.Nombre,
	Count(CASE WHEN DP.genero = 'M' THEN 1 END) UsuariosMasculinos,
	Count(CASE WHEN DP.genero = 'F' THEN 1 END) UsuariosFemeninos
FROM Paises p
	INNER JOIN Localidades Loc
	ON Loc.IDPais = p.ID
	INNER JOIN Datos_Personales DP
	ON DP.IDLocalidad = Loc.ID
	INNER JOIN Usuarios U
	ON U.ID = DP.ID
GROUP BY p.Nombre

-- 8 Listado con apellidos y nombres de los usuarios y la cantidad de
-- inscripciones realizadas en el 2019 y la cantidad de inscripciones
-- realizadas en el 2020.
SELECT DP.Apellidos, DP.Nombres,
	SUM (CASE WHEN YEAR(Insc.Fecha) = 2019 THEN 1 ELSE 0 END) NInscripciones2019,
	SUM (CASE WHEN YEAR(Insc.Fecha) = 2020 THEN 1 ELSE 0 END) NInscripciones2020
FROM Usuarios U
	INNER JOIN Inscripciones Insc
	ON Insc.IDUsuario = U.ID
	INNER JOIN Datos_Personales DP
	ON DP.ID = U.ID
GROUP BY DP.Apellidos, DP.Nombres

-- 9 Listado con nombres de los cursos y la cantidad de idiomas de cada
-- tipo. Es decir, la cantidad de idiomas de audio, la cantidad de
-- subtítulos y la cantidad de texto de video.
SELECT C.Nombre NombreCurso,
	SUM (CASE WHEN Fmt.Nombre = 'Audio' THEN 1 ELSE 0 END) IdiomasAudio,
	SUM(CASE WHEN Fmt.Nombre = 'Subtitulo' THEN 1 ELSE 0 END) IdiomasSubtitulo,
	SUM (CASE WHEN Fmt.Nombre = 'Texto del video' THEN 1 ELSE 0 END) IdiomasTextoVideo
FROM Cursos C
	INNER JOIN Idiomas_x_Curso IxC
	ON IxC.IDCurso = C.ID
	INNER JOIN FormatosIdioma Fmt
	ON Fmt.ID = IxC.IDFormatoIdioma
GROUP BY C.Nombre

-- 10 Listado con apellidos y nombres de los usuarios, nombre de usuario y
-- cantidad de cursos de nivel 'Principiante' que realizó y cantidad de
-- cursos de nivel 'Avanzado' que realizó.
SELECT DP.Apellidos, DP.Nombres, U.NombreUsuario,
	SUM (CASE WHEN Lvl.Nombre = 'Principiante' THEN 1 ELSE 0 END) CursosPrincipante,
	SUM (CASE WHEN Lvl.Nombre = 'Avanzado' THEN 1 ELSE 0 END) CursosAvanzado
FROM Datos_Personales DP
	INNER JOIN Usuarios U
	ON DP.ID = U.ID
	INNER JOIN Inscripciones Insc
	ON Insc.IDUsuario = U.ID
	INNER JOIN Cursos C
	ON C.ID = Insc.IDCurso
	INNER JOIN Niveles Lvl
	ON C.IDNivel = Lvl.ID
GROUP BY DP.Apellidos, DP.Nombres, U.NombreUsuario

-- FORMA CORRECTA CON SUBSONTULTAS
SELECT DP.Apellidos, DP.Nombres, U.NombreUsuario,
	(
			SELECT Count(Lvl.Id)
	FROM Inscripciones Insc
		INNER JOIN Cursos C
		ON C.ID = Insc.IDCurso
		INNER JOIN Niveles Lvl
		ON Lvl.Id = C.IDNivel
	WHERE Lvl.Nombre = 'Principiante' AND Insc.IDUsuario = U.ID
		) CursosPrincipante,
	(
			SELECT Count(Lvl.Id)
	FROM Inscripciones Insc
		INNER JOIN Cursos C
		ON C.ID = Insc.IDCurso
		INNER JOIN Niveles Lvl
		ON Lvl.Id = C.IDNivel
	WHERE Lvl.Nombre = 'Avanzado' AND Insc.IDUsuario = U.ID
		) CursosAvanzado
FROM Datos_Personales DP
	INNER JOIN Usuarios U
	ON U.ID = DP.ID


-- 11 Listado con nombre de los cursos y la recaudación de inscripciones de
-- usuarios de género femenino que se inscribieron y la recaudación de
-- inscripciones de usuarios de género masculino.

-- 12 Listado con nombre de país de aquellos que hayan registrado más
-- usuarios de género masculino que de género femenino.

-- 13 Listado con nombre de país de aquellos que hayan registrado más
-- usuarios de género masculino que de género femenino pero que haya
-- registrado al menos un usuario de género femenino.

-- 14 Listado de cursos que hayan registrado la misma cantidad de idiomas
-- de audio que de subtítulos.

-- 15 Listado de usuarios que hayan realizado más cursos en el año 2018
-- que en el 2019 y a su vez más cursos en el año 2019 que en el 2020.

-- 16 Listado de apellido y nombres de usuarios que hayan realizado cursos
-- pero nunca se hayan certificado.
-- Aclaración: Listado con apellidos y nombres de usuarios que hayan 
-- realizado al menos un curso y no se hayan certificado nunca.