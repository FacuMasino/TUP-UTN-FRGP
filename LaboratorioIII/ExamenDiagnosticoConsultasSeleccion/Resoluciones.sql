USE DIAGNOSTICO
GO

-- ¿Cuál es el costo de la consulta promedio de los/as especialistas en "Oftalmología"?
SELECT AVG(M.Costo_Consulta)
FROM Medicos M
	INNER JOIN Especialidades E
	ON E.IDESPECIALIDAD = M.IDESPECIALIDAD
WHERE E.NOMBRE = 'Oftalmología'

-- ¿Cuál es el apellido del médico (sexo masculino) con más antigüedad de la clínica?
SELECT TOP 1
	Apellido
FROM MEDICOS
WHERE Sexo = 'M'
ORDER BY FECHAINGRESO ASC

-- ¿Cuántos pacientes distintos se atendieron en turnos que duraron más que la duración promedio?

SELECT Count(DISTINCT P.IDPACIENTE)
FROM Pacientes P
	INNER JOIN turnos T
	ON T.IDPACIENTE = P.IDPACIENTE
WHERE T.DURACION > (
	SELECT AVG(Duracion)
FROM TURNOS
)

--¿Cuáles son el/los paciente/s que se atendieron más veces? 
-- (indistintamente del sexo del paciente)
SELECT P.Apellido, P.Nombre, (
	SELECT COUNT(T.IDTURNO)
	FROM Turnos T
	WHERE T.IDPACIENTE = P.IDPACIENTE
) TotalTurnos
FROM Pacientes P
ORDER BY TotalTurnos DESC

-- Alternativa
SELECT P.APELLIDO, P.NOMBRE, COUNT(*) AS CANTIDAD_TURNOS
FROM PACIENTES P
	INNER JOIN TURNOS T ON P.IDPACIENTE = T.IDPACIENTE
GROUP BY P.IDPACIENTE, P.APELLIDO, P.NOMBRE
ORDER BY CANTIDAD_TURNOS DESC

-- ¿Cuántas médicas cobran sus honorarios de consulta un costo mayor a $1000?
SELECT Count(M.IDMEDICO)
FROM MEDICOS M
WHERE M.COSTO_CONSULTA > 1000 AND M.Sexo = 'F'

-- ¿Cuántos turnos fueron atendidos por la doctora Flavia Rice?
SELECT Count(T.IDTURNO) TurnosFlaviaRice
FROM TURNOS T
	INNER JOIN MEDICOS M
	ON T.IDMEDICO = M.IDMEDICO
WHERE M.APELLIDO = 'Rice' AND M.NOMBRE = 'Flavia'

/* ¿Cuánto tuvo que pagar la consulta el paciente con el turno nro 146?

Teniendo en cuenta que el paciente debe pagar el costo de la consulta del médico menos lo que cubre la cobertura de la obra social. La cobertura de la obra social está expresado en un valor decimal entre 0 y 1. Siendo 0 el 0% de cobertura y 1 el 100% de la cobertura.



Si la cobertura de la obra social es 0.2, entonces el paciente debe pagar el 80% de la consulta.
*/

SELECT T.IDTURNO, M.COSTO_CONSULTA - M.Costo_Consulta * OS.COBERTURA AS 'CostoFinal'
FROM Turnos T
	INNER JOIN MEDICOS M
	ON T.IDMEDICO = M.IDMEDICO
	INNER JOIN PACIENTES P
	ON T.IDPACIENTE = P.IDPACIENTE
	INNER JOIN OBRAS_SOCIALES OS
	ON OS.IDOBRASOCIAL = P.IDOBRASOCIAL
WHERE T.IDTURNO = 146

-- ¿Cuál es la cantidad de pacientes que no se atendieron en el año 2019?
SELECT Count(DISTINCT P.IDPACIENTE)
FROM pacientes P
WHERE P.IDPACIENTE NOT IN (
	SELECT T.IDPACIENTE
FROM Turnos T
WHERE YEAR(T.FECHAHORA) = 2019
)

-- cantidad que no sacó turno
SELECT COUNT(P.IDPACIENTE)
FROM PACIENTES P
	LEFT JOIN TURNOS t
	ON T.IDPACIENTE = p.IDPACIENTE
WHERE T.IDTURNO IS NULL

SELECT COUNT(DISTINCT P.IDPACIENTE)
FROM PACIENTES P
	LEFT JOIN TURNOS T ON P.IDPACIENTE = T.IDPACIENTE AND YEAR(T.FECHAHORA) = 2019
WHERE T.IDTUrno IS NULL

/*
¿Qué Obras Sociales cubren a pacientes
 que se hayan atendido en algún turno con algún médico 
 de especialidad 'Odontología'?
*/
SELECT DISTINCT OS.Nombre
FROM OBRAS_SOCIALES OS
	INNER JOIN PACIENTES P
	ON P.IDOBRASOCIAL = OS.IDOBRASOCIAL
	INNER JOIN TURNOS T
	ON T.IDPACIENTE = P.IDPACIENTE
	INNER JOIN MEDICOS M
	ON T.IDMEDICO = M.IDMEDICO
	INNER JOIN ESPECIALIDADES E
	ON E.IDESPECIALIDAD = M.IDESPECIALIDAD
WHERE E.NOMBRE = 'Odontología'

-- alternativa con subconsulta
SELECT DISTINCT OS.Nombre
FROM OBRAS_SOCIALES OS
WHERE OS.Nombre IN (
	SELECT OS.Nombre
FROM PACIENTES P
	INNER JOIN OBRAS_SOCIALES OS2
	ON OS2.IDOBRASOCIAL = P.IDOBRASOCIAL
	INNER JOIN TURNOS T
	ON T.IDPACIENTE = P.IDPACIENTE
	INNER JOIN MEDICOS M
	ON M.IDMEDICO = T.IDMEDICO
	INNER JOIN ESPECIALIDADES E
	ON E.IDESPECIALIDAD = M.IDESPECIALIDAD
WHERE E.NOMBRE = 'Odontología'
)

-- ¿Cuántos médicos tienen la especialidad "Gastroenterología" ó "Pediatría"?
SELECT Count(M.IDMedico)
FROM MEDICOS M
	INNER JOIN ESPECIALIDADES E
	ON E.IDESPECIALIDAD = M.IDESPECIALIDAD
WHERE E.NOMBRE IN ('Gastroenterología', 'Pediatría')

