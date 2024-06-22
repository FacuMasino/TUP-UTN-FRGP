USE Univ
GO

ALTER TABLE Cursos
	ADD DebeSerMayorDeEdad Bit DEFAULT 0

UPDATE Cursos
	SET DebeSerMayorDeEdad = 1
	WHERE Id IN (1,4,6,9);