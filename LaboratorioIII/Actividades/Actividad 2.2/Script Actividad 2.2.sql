USE Univ
GO

-- 1 Listado con nombre de usuario de todos los usuarios y 
-- sus respectivos nombres y apellidos.
SELECT A.NombreUsuario, B.Nombres, B.Apellidos
FROM Usuarios AS A
	INNER JOIN Datos_Personales AS B
	ON  A.ID = B.ID

-- 2 Listado con apellidos, nombres, fecha de nacimiento y 
-- nombre del país de nacimiento. 
SELECT A.Apellidos, A.Nombres, A.Nacimiento, C.Nombre AS 'Pais Nacimiento'
FROM Datos_Personales AS A
	INNER JOIN Localidades AS B
	ON A.IDLocalidad = B.ID
	INNER JOIN Paises AS C
	ON B.IDPais = C.ID

-- 3 Listado con nombre de usuario, apellidos, nombres, 
-- email o celular de todos los usuarios que vivan en 
-- una domicilio comience con vocal.
-- NOTA: Si no tiene email, obtener el celular.
SELECT A.NombreUsuario, B.Apellidos, B.Nombres,
	CASE
	WHEN B.Email IS NULL THEN B.Celular
	ELSE B.Email
END AS "Contacto"
FROM Usuarios AS A
	INNER JOIN Datos_Personales AS B
	ON A.ID = B.ID
WHERE B.Domicilio LIKE '[AEIOU]%'

-- 4 Listado con nombre de usuario, apellidos, nombres, email o celular
-- o domicilio como 'Información de contacto'.
-- NOTA: Si no tiene email, obtener el celular y si no posee celular
-- obtener el domicilio.
SELECT Usr.NombreUsuario, P.Apellidos, P.Nombres,
	CASE
	WHEN P.Email IS NULL AND P.Celular IS NULL THEN P.Domicilio
	WHEN P.Email IS NULL THEN P.Celular
	ELSE P.Email
END AS "Información de contacto"
FROM Usuarios AS Usr
	INNER JOIN Datos_Personales AS P
	ON Usr.ID = P.ID

-- 5 Listado con apellido y nombres, nombre del curso y costo de la
-- inscripción de todos los usuarios inscriptos a cursos.
-- NOTA: No deben figurar los usuarios que no se inscribieron a ningún
-- curso.
SELECT P.Apellidos, P.Nombres, C.Nombre AS "Nombre del curso", Insc.Costo AS "Costo Inscripción"
FROM Inscripciones AS Insc
	INNER JOIN Cursos AS C
	ON Insc.IDCurso = C.ID
	INNER JOIN Datos_Personales AS P
	ON Insc.IDUsuario = P.ID

-- 6 Listado con nombre de curso, nombre de usuario y mail de todos los
-- inscriptos a cursos que se hayan estrenado en el año 2020.
SELECT C.Nombre AS "Nombre Curso", Usr.NombreUsuario, P.Email, Insc.IDCurso
FROM Inscripciones AS Insc
	INNER JOIN Cursos AS C
	ON Insc.IDCurso = C.ID
	INNER JOIN Usuarios AS Usr
	ON Insc.IDUsuario = Usr.ID
	INNER JOIN Datos_Personales AS P
	ON Usr.ID = P.ID
WHERE YEAR(C.Estreno) = 2020

-- 7 Listado con nombre de curso, nombre de usuario, apellidos y nombres,
-- fecha de inscripción, costo de inscripción, fecha de pago e importe de
-- pago. Sólo listar información de aquellos que hayan pagado.
SELECT C.Nombre AS "Nombre Curso", Usr.NombreUsuario, P.Apellidos,
	P.Nombres, Insc.Fecha, Insc.Costo, Pago.Fecha, Pago.importe
FROM Pagos AS Pago
	INNER JOIN Inscripciones AS Insc
	ON Pago.IDInscripcion = Insc.ID
	INNER JOIN Cursos AS C
	ON Insc.IDCurso = C.ID
	INNER JOIN Usuarios AS Usr
	ON Insc.IDUsuario = Usr.ID
	INNER JOIN Datos_Personales AS P
	ON Usr.ID = P.ID

-- 8 Listado con nombre y apellidos, género, fecha de nacimiento, mail,
-- nombre del curso y fecha de certificación de todos aquellos usuarios
-- que se hayan certificado.
SELECT P.Nombres, P.Apellidos, P.genero, P.Nacimiento, P.Email,
	C.Nombre AS "Nombre del curso", Certif.Fecha AS "Fecha de Certificación"
FROM Certificaciones AS Certif
	INNER JOIN Inscripciones AS Insc
	ON Certif.IDInscripcion = Insc.ID
	INNER JOIN Cursos AS C
	ON C.ID = Insc.IdCurso
	INNER JOIN Usuarios
	ON Insc.IDUsuario = Usuarios.ID
	INNER JOIN Datos_Personales AS P
	ON Usuarios.ID = P.ID

-- 9 Listado de cursos con nombre, costo de cursado y certificación, costo
-- total (cursado + certificación) con 10% de todos los cursos de nivel
-- Principiante.
SELECT TOP (10) PERCENT
	Cursos.Nombre, Cursos.CostoCurso, Cursos.CostoCertificacion,
	Cursos.CostoCurso + Cursos.CostoCertificacion AS "Costo Total"
FROM Cursos
	INNER JOIN Niveles
	ON Cursos.IDNivel = Niveles.ID
WHERE Niveles.Nombre = 'Principiante'

-- 10 Listado con nombre y apellido y mail de todos los instructores. Sin repetir.
SELECT DISTINCT P.Nombres, P.Apellidos, P.Email
FROM Instructores_x_Curso AS Instructores
	INNER JOIN Usuarios
	ON Instructores.IDUsuario = Usuarios.ID
	INNER JOIN Datos_Personales AS P
	ON Usuarios.ID = P.ID

-- 11. Listado con nombre y apellido de todos los usuarios 
-- que hayan cursado algún curso cuya categoría sea 'Historia'.
SELECT P.Nombres, P.Apellidos
FROM Inscripciones AS Insc
	INNER JOIN Categorias_x_Curso AS CxC
	ON Insc.IDCurso = CxC.IDCurso
	INNER JOIN Categorias
	ON Categorias.ID = CxC.IDCategoria
	INNER JOIN Usuarios
	ON Insc.IDUsuario = Usuarios.ID
	INNER JOIN Datos_Personales AS P
	ON Usuarios.ID = P.ID
WHERE Categorias.Nombre = 'Historia'

-- 12 Listado con nombre de idioma, código de curso y código de tipo de
-- idioma. Listar todos los idiomas indistintamente si no tiene cursos
-- relacionados.
SELECT Idio.Nombre, IxC.IDCurso, IxC.IDFormatoIdioma
FROM Idiomas AS Idio
	LEFT JOIN Idiomas_x_Curso AS IxC
	ON Idio.ID = IxC.IDIdioma

-- 13 Listado con nombre de idioma de todos los idiomas que no tienen
-- cursos relacionados.
SELECT Idio.Nombre, IxC.IDCurso, IxC.IDFormatoIdioma
FROM Idiomas AS Idio
	LEFT JOIN Idiomas_x_Curso AS IxC
	ON Idio.ID = IxC.IDIdioma
WHERE IxC.IDCurso IS NULL

-- 14 Listado con nombres de idioma que figuren como audio de algún curso.
-- Sin repeticiones.
SELECT DISTINCT Idiomas.Nombre "Idioma con audio"
FROM Idiomas
	INNER JOIN Idiomas_x_Curso AS IxC
	ON Idiomas.ID = IxC.IDIdioma
	INNER JOIN FormatosIdioma AS Fmt
	ON IxC.IDFormatoIdioma = Fmt.ID
WHERE Fmt.Nombre = 'Audio'

-- Alternativa
SELECT DISTINCT Idiomas.Nombre "Idioma con audio"
FROM Idiomas
	INNER JOIN Idiomas_x_Curso AS IxC
	ON Idiomas.ID = IxC.IDIdioma
WHERE IxC.IDFormatoIdioma = 2

-- 15 Listado con nombres y apellidos de todos los usuarios y el nombre del
-- país en el que nacieron. Listar todos los países indistintamente si no
-- tiene usuarios relacionados.

SELECT
	DP.Nombres,
	DP.Apellidos,
	P.Nombre PaisNacimiento
from Usuarios U
	inner join Datos_Personales DP
	on U.ID = DP.ID
	inner join Localidades Loc
	on Loc.Id = DP.IDLocalidad
	right join Paises P
	on P.ID = Loc.IDPais

-- 16 Listado con nombre de curso, fecha de estreno y nombres de usuario de
-- todos los inscriptos. Listar todos los nombres de usuario indistintamente
-- si no se inscribieron a ningún curso.

SELECT
	C.Nombre NombreCurso,
	C.Estreno,
	U.NombreUsuario
from Cursos C
	inner join Inscripciones Insc
	on Insc.IDCurso = C.ID
	right join Usuarios U
	on U.ID = Insc.IDUsuario
Order By C.Nombre Desc

-- 17 Listado con nombre de usuario, apellido, nombres, género, fecha de
-- nacimiento y mail de todos los usuarios que no cursaron ningún curso.

Select
	U.NombreUsuario,
	DP.Apellidos,
	DP.Nombres,
	DP.Genero,
	DP.Nacimiento,
	DP.Email
from Usuarios U
	inner join Datos_Personales DP
	on U.ID = DP.ID
	left join Inscripciones Insc
	on Insc.IDUsuario = U.ID
Where Insc.ID Is NULL

-- 18 Listado con nombre y apellido, nombre del curso, puntaje otorgado y
-- texto de la reseña. Sólo de aquellos usuarios que hayan realizado una
-- reseña inapropiada.

Select
	DP.Nombres,
	DP.Apellidos,
	C.Nombre,
	R.Puntaje,
	R.Observaciones
from Datos_Personales DP
	inner join Usuarios U
	on U.ID = DP.ID
	inner join inscripciones Insc
	on Insc.IDUsuario = U.ID
	inner join Cursos C
	on C.ID = Insc.IDCurso
	inner join Reseñas R
	on R.IDInscripcion = Insc.ID
Where R.Inapropiada = 1

-- 19 Listado con nombre del curso, costo de cursado, costo de certificación,
-- nombre del idioma y nombre del tipo de idioma de todos los cursos cuya
-- fecha de estreno haya sido antes del año actual. Ordenado por nombre del
-- curso y luego por nombre de tipo de idioma. Ambos ascendentemente.

Select
	C.Nombre,
	C.CostoCurso,
	C.CostoCertificacion,
	ID.Nombre,
	FmtID.Nombre
from Cursos C
	inner join Idiomas_x_Curso IxC
	on IxC.IDCurso = C.ID
	inner join Idiomas ID
	on ID.ID = IxC.IDIdioma
	inner join FormatosIdioma FmtID
	on FmtID.ID = IxC.IDFormatoIdioma
Order By C.Nombre, FmtId.Nombre Asc 

-- 20 Listado con nombre del curso y todos los importes de los pagos relacionados.

Select
	C.Nombre,
	P.Importe
from Cursos C
	inner join Inscripciones Insc
	on Insc.IDCurso = C.ID
	inner join Pagos P
	on P.IDInscripcion = Insc.ID

-- 21 Listado con nombre de curso, costo de cursado y una leyenda que indique
-- "Costoso" si el costo de cursado es mayor a $15000, "Accesible" si el costo
-- de cursado está entre $2500 y $15000, "Barato" si el costo está entre $1 y
-- $2499 y "Gratis" si el costo es $0.

Select
	C.Nombre,
	C.CostoCurso,
	Case When C.CostoCurso > 15000
	Then 'Costoso'
	When C.CostoCurso BETWEEN 2500 And 15000
	Then 'Accesible'
	When C.CostoCurso BETWEEN 1 And 2499
	Then 'Barato'
	Else 'Gratis'
	End as Clasificacion
From Cursos C