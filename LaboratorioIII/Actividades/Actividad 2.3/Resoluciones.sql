-- 1 Listado con la cantidad de cursos.

SELECT Count(*) AS 'Cantidad Cursos'
FROM Cursos

-- 2 Listado con la cantidad de usuarios.

SELECT Count(*) AS 'Cantidad Usuarios'
FROM Usuarios

-- 3 Listado con el promedio de costo de certificación de los cursos.

SELECT AVG(C.CostoCurso) AS 'Promedio de costo cursos'
FROM Cursos C

-- 4 Listado con el promedio general de calificación de reseñas.

SELECT AVG(R.Puntaje) AS 'Prom. Gral Calif Reseñas'
FROM Reseñas R

-- 5 Listado con la fecha de estreno de curso más antigua.

SELECT MIN(C.Estreno) AS 'Estreno más antiguo'
FROM Cursos C

-- 6 Listado con el costo de certificación menos costoso.

SELECT MIN(C.CostoCurso) AS 'Curso menor costo'
FROM Cursos C

-- 7 Listado con el costo total de todos los cursos.

SELECT SUM(C.CostoCurso) AS 'CostoTotalCursos'
FROM cursos C

-- 8 Listado con la suma total de todos los pagos.

SELECT SUM(P.Importe) AS 'TotalPagos'
FROM Pagos P

-- 9 Listado con la cantidad de cursos de nivel principiante.

SELECT COUNT(*) AS 'TotalNvlPrincipiante'
FROM Cursos C
	INNER JOIN Niveles N
	ON C.IDNivel = N.ID
WHERE N.Nombre = 'Principiante'

-- 10 Listado con la suma total de todos los pagos realizados en 2020.

SELECT SUM(P.Importe) AS 'Total2020'
FROM Pagos P
WHERE YEAR(P.Fecha) = 2020

-- 11 Listado con la cantidad de usuarios que son instructores.

SELECT COUNT(DISTINCT IDUsuario) AS 'TotalInstructores'
FROM Instructores_x_Curso

-- 12 Listado con la cantidad de usuarios distintos que se hayan certificado.

SELECT COUNT(DISTINCT Insc.IDUsuario) AS 'UsuariosCertificados'
FROM Certificaciones Cer
	INNER JOIN Inscripciones Insc
	ON Insc.ID = Cer.IDInscripcion

-- 13 Listado con el nombre del país y la cantidad de usuarios de cada país.

SELECT p.nombre, COUNT(u.ID) AS 'CantidadUsuarios'
FROM Paises P
	LEFT JOIN Localidades loc
	ON P.ID = Loc.IDPais
	LEFT JOIN Datos_Personales dp
	ON dp.IDLocalidad = loc.ID
	LEFT JOIN usuarios U
	ON U.ID = dp.ID
GROUP BY p.Nombre

-- 14 Listado con el apellido y nombres del usuario y el importe más costoso
-- abonado como pago. Sólo listar aquellos que hayan abonado más de $7500.
SELECT DP.apellidos, DP.nombres, MAX(P.Importe) AS 'MayorImportePago'
FROM Pagos AS P
	INNER JOIN Inscripciones Insc
	ON P.IDInscripcion = Insc.ID
	INNER JOIN Usuarios U
	ON U.Id = Insc.IDUsuario
	INNER JOIN Datos_Personales DP
	ON U.Id = DP.ID
GROUP BY DP.Apellidos, DP.Nombres
HAVING MAX(P.Importe) > 7500

-- 15 Listado con el apellido y nombres de usuario de cada usuario y el
-- importe más costoso del curso al cual se haya inscripto. Si hay usuarios
-- sin inscripciones deben figurar en el listado de todas maneras.
SELECT DP.apellidos, U.NombreUsuario, Max(C.CostoCurso) AS 'ImporteMasCostoso'
FROM usuarios U
	LEFT JOIN Inscripciones Insc
	ON U.ID = Insc.IDUsuario
	LEFT JOIN Datos_Personales DP
	ON U.ID = DP.ID
	LEFT JOIN Cursos C
	ON C.ID = Insc.IDCurso
GROUP BY DP.Apellidos, U.NombreUsuario

-- 16 Listado con el nombre del curso, nombre del nivel, cantidad total de
-- clases y duración total del curso en minutos.
SELECT C.Nombre 'Curso', Lvl.Nombre 'Nivel', Count(Cla.Id) 'TotalClases', Sum(Cla.Duracion) 'TotalMinutos'
FROM Cursos C
	INNER JOIN Niveles Lvl
	ON Lvl.Id = C.IDNivel
	INNER JOIN Clases Cla
	ON Cla.IdCurso = C.Id
GROUP BY C.Nombre, Lvl.nombre

-- 17 Listado con el nombre del curso y cantidad de contenidos registrados.
-- Sólo listar aquellos cursos que tengan más de 10 contenidos registrados.
SELECT C.Nombre 'Curso', Count(Con.ID)
FROM Cursos C
	INNER JOIN Clases Cla
	ON Cla.IDCurso = C.ID
	INNER JOIN Contenidos Con
	ON Con.IDClase = Cla.ID
GROUP BY C.Nombre
HAVING Count(Con.ID) > 10

-- 18 Listado con nombre del curso, nombre del idioma y cantidad de tipos de
-- idiomas.
SELECT C.Nombre, I.Nombre, Count(IxC.IdFormatoIdioma) 'CantidadTiposIdioma'
FROM Cursos C
	INNER JOIN Idiomas_x_Curso IxC
	ON C.ID = IxC.IDCurso
	INNER JOIN Idiomas I
	ON I.ID = IxC.IDIdioma
GROUP BY C.Nombre, I.Nombre

-- 19 Listado con el nombre del curso y cantidad de idiomas distintos
-- disponibles.
SELECT C.Nombre, Count(DISTINCT IxC.IdIdioma) 'CantIdiomas'
FROM Cursos C
	INNER JOIN Idiomas_x_Curso IxC
	ON C.Id = IxC.IDCurso
GROUP BY C.Nombre

-- 20 Listado de categorías de curso y cantidad de cursos asociadas a cada
-- categoría. Sólo mostrar las categorías con más de 5 cursos.
SELECT Cat.Nombre, Count(CxC.IDCurso) 'CantCursos'
FROM Categorias Cat
	INNER JOIN Categorias_x_Curso CxC
	ON CxC.IDCategoria = Cat.ID
GROUP BY cat.Nombre
HAVING Count(CxC.IDCurso) > 5

-- 21 Listado con tipos de contenido y la cantidad de contenidos asociados a
-- cada tipo. Mostrar también aquellos tipos que no hayan registrado
-- contenidos con cantidad 0.
SELECT T.Nombre TipoContenido, ISNULL(Count(C.Id), 0) CantidadAsociada
FROM TiposContenido T
	LEFT JOIN Contenidos C
	ON C.IdTipo = T.ID
GROUP BY T.Nombre

-- 22 Listado con Nombre del curso, nivel, año de estreno y el total
-- recaudado en concepto de inscripciones. Listar también aquellos cursos
-- sin inscripciones con total igual a $0.
SELECT C.nombre NombreCurso, N.Nombre Nivel, YEAR(C.Estreno) AñoEstreno, ISNULL(Sum(Insc.Costo),0) TotalRecaudado
FROM Cursos C
	LEFT JOIN Niveles N
	ON C.IDNivel = N.ID
	LEFT JOIN Inscripciones Insc
	ON Insc.IDCurso = C.ID
GROUP BY C.Nombre, N.Nombre, YEAR(C.Estreno)

-- 23 Listado con Nombre del curso, costo de cursado y certificación y
-- cantidad de usuarios distintos inscriptos cuyo costo de cursado sea menor
-- a $10000 y cuya cantidad de usuarios inscriptos sea menor a 5. Listar
-- también aquellos cursos sin inscripciones con cantidad 0.
SELECT C.Nombre Curso, C.CostoCurso, C.CostoCertificacion, Count(DISTINCT Insc.IDUsuario) UsuariosInscriptos
FROM Cursos C
	INNER JOIN Inscripciones Insc
	ON Insc.IDCurso = C.ID
WHERE C.CostoCurso < 10000
GROUP BY C.Nombre, C.CostoCurso, C.CostoCertificacion
HAVING COUNT(DISTINCT Insc.IDUsuario) < 5

-- 24 Listado con Nombre del curso, fecha de estreno y nombre del nivel del
-- curso que más recaudó en concepto de certificaciones.
SELECT TOP 1
	C.Nombre, C.Estreno, Lvl.Nombre Nivel, Sum(Cer.Costo) RecaudacionCertificaciones
FROM Cursos C
	INNER JOIN Niveles Lvl
	ON Lvl.ID = C.IDNivel
	INNER JOIN Inscripciones Insc
	ON Insc.IdCurso = C.ID
	INNER JOIN Certificaciones Cer
	ON Cer.IDInscripcion = Insc.ID
GROUP BY C.Nombre, C.Estreno, Lvl.Nombre
ORDER BY Sum(Cer.Costo) DESC

-- 25 Listado con Nombre del idioma del idioma más utilizado como subtítulo.

-- 26 Listado con Nombre del curso y promedio de puntaje de reseñas
-- apropiadas.

-- 27 Listado con Nombre de usuario y la cantidad de reseñas inapropiadas
-- que registró.

-- 28 Listado con Nombre del curso, nombre y apellidos de usuarios y la
-- cantidad de veces que dicho usuario realizó dicho curso. No mostrar
-- cursos y usuarios que contabilicen cero.

-- 29 Listado con Apellidos y nombres, mail y duración total en concepto de
-- clases de cursos a los que se haya inscripto. Sólo listar información de
-- aquellos registros cuya duración total supere los 400 minutos.

-- 30 Listado con nombre del curso y recaudación total. La recaudación
-- total consiste en la sumatoria de costos de inscripción y de
-- certificación. Listarlos ordenados de mayor a menor por recaudación.
