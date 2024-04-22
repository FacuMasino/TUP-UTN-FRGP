USE Univ
GO

-- 1 Listado de todos los idiomas.
SELECT *
FROM Idiomas

-- 2 Listado de todos los cursos.
SELECT *
FROM Cursos


-- 3 Listado con nombre, costo de inscripción (costo de curso),
-- costo de certificación y fecha de estreno de todos los cursos.
SELECT Nombre, CostoCurso, CostoCertificacion, FechaEstreno
FROM Cursos

-- 4 Listado con ID, nombre, costo de inscripción y ID de nivel de
-- todos los cursos cuyo costo de certificación sea menor a $5000.
SELECT ID, Nombre, CostoCurso, IDNivel
FROM Cursos
WHERE CostoCertificacion < 5000

-- 5 Listado con ID, nombre, costo de inscripción y ID de nivel de
-- todos los cursos cuyo costo de certificación sea mayor a $1200.
SELECT ID, Nombre, CostoCurso, IDNivel
FROM
	Cursos
WHERE CostoCertificacion > 12000

-- 6 Listado con nombre, número y duración de todas las clases 
-- del curso con ID número 6.
SELECT Nombre, Numero, Duracion
FROM Clases
WHERE ID = 6

-- 7 Listado con nombre, número y duración de todas las clases
-- del curso con ID número 10.
SELECT Nombre, Numero, Duracion
FROM Clases
WHERE IDCurso = 10

-- 8 Listado con nombre y duración de todas las clases del curso
-- con ID número 4. Ordenado por duración de mayor a menor.
SELECT Nombre, Duracion
FROM Clases
WHERE IDCurso = 4
ORDER BY Duracion DESC

-- 9 Listado de cursos con nombre, fecha de estreno, costo del curso,
-- costo de certificación ordenados por fecha de estreno de manera creciente.
SELECT Nombre, FechaEstreno, CostoCurso, CostoCertificacion
FROM Cursos
ORDER BY FechaEstreno ASC

-- 10 Listado con nombre, fecha de estreno y costo del curso 
-- de todos aquellos cuyo ID de nivel sea 1, 5, 9 o 10.
SELECT Nombre, FechaEstreno, CostoCurso
FROM Cursos
WHERE IDNivel IN (1,5,9,10)

-- 11 Listado con nombre, fecha de estreno y costo 
-- de cursado de los tres cursos más caros de certificar.
SELECT TOP(3)
	Nombre, FechaEstreno, CostoCurso
FROM Cursos
ORDER BY CostoCertificacion DESC

-- 12 Listado con nombre, duración y número de todas las 
-- clases de los cursos con ID 2, 5 y 7. Ordenados por 
-- ID de Curso ascendente y luego por número de clase ascendente.
SELECT Nombre, Duracion, Numero
FROM Clases
WHERE IDCurso IN (2,5,7)
ORDER BY IDCurso ASC, Numero ASC

-- 13 Listado con nombre y fecha de estreno de todos los cursos 
-- cuya fecha de estreno haya sido en el primer semestre del año 2019.
SELECT Nombre, FechaEstreno
FROM Cursos
WHERE YEAR(FechaEstreno) = 2019
	AND MONTH(FechaEstreno) <= 6

SELECT nombre, FechaEstreno
FROM Cursos
WHERE DATEPART(YEAR, FechaEstreno) = 2019
	AND DATEPART(QUARTER, FechaEstreno) IN (1, 2);

-- 14 Listado de cursos cuya fecha de estreno haya sido en el año 2020.
SELECT *
FROM Cursos
WHERE YEAR(FechaEstreno) = 2020

-- ``5 Listado de cursos cuyo mes de estreno haya sido entre el 1 y el 4.
SELECT *
FROM Cursos
WHERE MONTH(FechaEstreno) BETWEEN 1 AND 4

-- 16 Listado de clases cuya duración se encuentre entre 15 y 90 minutos.
SELECT *
FROM Clases
WHERE Duracion BETWEEN 15 AND 90

-- 17 Listado de contenidos cuyo tamaño supere los 5000MB y sean 
-- de tipo 4 o sean menores a 400MB y sean de tipo 1.
SELECT *
FROM Contenidos
WHERE tamaño > 5000 AND IDTipoContenido = 4
	OR tamaño < 400 AND IDTipoContenido = 1

-- 18 Listado de cursos que no posean ID de nivel.
SELECT *
FROM Cursos
WHERE IDNivel IS NULL

-- 19 Listado de cursos cuyo costo de certificación corresponda 
-- al 20% o más del costo del curso.
SELECT *
FROM Cursos
WHERE CostoCertificacion >= CostoCurso * 0.2

-- Verificacion
SELECT *, CostoCurso * 0.2 AS CostoMinimo
FROM Cursos
WHERE CostoCertificacion >= CostoCurso * 0.2

-- 20 Listado de costos de cursado de todos los cursos 
-- sin repetir y ordenados de mayor a menor.
SELECT DISTINCT CostoCurso
FROM Cursos
ORDER BY CostoCurso DESC 