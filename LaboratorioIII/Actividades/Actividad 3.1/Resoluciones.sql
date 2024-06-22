USE Univ
GO
-- 1. Hacer una función llamada FN_PagosxUsuario que a partir de un IDUsuario
-- devuelva el total abonado en concepto de pagos. Si no hay pagos debe
-- retornar 0.

CREATE OR ALTER FUNCTION FN_PagosxUsuario (
	@IdUsuario bigint 
)
returns money 
AS
BEGIN
	DECLARE @Monto money
	SELECT @Monto = IsNull(SUM(P.Importe), 0)
	FROM Pagos P
		INNER JOIN Inscripciones Insc
		ON Insc.ID = P.IDInscripcion
		INNER JOIN Usuarios U
		ON Insc.IDUsuario = U.ID
	WHERE U.Id = @IdUsuario
	RETURN @Monto
END
GO

-- Test
SELECT U.Id, P.Nombres, P.Apellidos, dbo.FN_PagosxUsuario(U.Id) AS TotalAbonado
FROM Usuarios U
	INNER JOIN Datos_Personales P
	ON P.ID = U.ID
GO

-- Usuarios sin isnscripción = sin pagos
SELECT U.ID, i.ID
FROM Usuarios U
	LEFT JOIN Inscripciones I
	ON I.IDUsuario = U.ID
WHERE I.ID IS NULL
GO

-- 2. Hacer una función llamada FN_DeudaxUsuario que a partir de un IDUsuario
-- devuelva el total adeudado. Si no hay deuda debe retornar 0.

CREATE OR ALTER FUNCTION FN_DeudaxUsuario(
	@IdUsuario bigint 
)
returns money 
AS
BEGIN
	DECLARE @TotalInscripciones money 
	DECLARE @TotalPagado money

	-- Sumar costo de todas las inscripciones
	SELECT @TotalInscripciones = IsNull(Sum(Insc.Costo),0)
	FROM Inscripciones Insc
		INNER JOIN Usuarios U
		ON U.Id = Insc.IDUsuario
	WHERE U.Id = @IdUsuario

	-- Si no se inscribió no seguir iterando y devolver 0
	IF @TotalInscripciones = 0
	RETURN 0

	-- Sumar total de pagos
	SELECT @TotalPagado = IsNull(Sum(P.Importe), 0)
	FROM Pagos P
		INNER JOIN Inscripciones Insc
		ON Insc.ID = P.IDInscripcion
		INNER JOIN Usuarios U
		ON U.ID = Insc.IDUsuario
	WHERE U.Id = @IdUsuario

	IF @TotalPagado >= @TotalInscripciones 
		RETURN 0

	RETURN @TotalInscripciones - @TotalPagado
END
GO

-- Test funcion
USE Univ
GO
SELECT U.Id, DP.Nombres, DP.Apellidos, DeudaTotal = dbo.FN_DeudaxUsuario(U.ID)
FROM Usuarios U
	INNER JOIN Datos_Personales DP
	ON DP.ID = U.ID
GO

-- 3. Hacer una función llamada FN_CalcularEdad que a partir de un IDUsuario
-- devuelva la edad del mismo. La edad es un valor entero.
CREATE OR ALTER FUNCTION FN_CalcularEdad (
	@IdUsuario bigint 
)
returns int
AS
BEGIN
	DECLARE @nacimiento date
	DECLARE @edad int
	-- obtener fecha
	SELECT @nacimiento = DP.Nacimiento
	FROM Datos_Personales DP
	WHERE DP.Id = @IdUsuario
	-- calcular diff en años
	SET @edad = DATEDIFF(Year, @nacimiento, getDate())
	-- verificar si todavia no pasó
	IF Month(@nacimiento) > Month(getDate())
		RETURN @edad - 1
	ELSE BEGIN
		IF Month(@nacimiento) = Month(getDate()) AND
			Day(@nacimiento) < Day(getDate())
		RETURN @edad - 1
	END
	RETURN @edad
END
GO
-- test
SELECT dbo.FN_CalcularEdad(4)
GO
-- 4. Hacer una función llamada Fn_PuntajeCurso que a partir de un IDCurso
-- devuelva el promedio de puntaje en concepto de reseñas.
CREATE OR ALTER FUNCTION Fn_PuntajeCurso (
	@IDCurso bigint
)
returns decimal (3,1)
AS
BEGIN
	DECLARE @Promedio decimal (3,1)

	SELECT @Promedio = AVG(R.puntaje)
	FROM Reseñas R
		INNER JOIN Inscripciones Insc
		ON R.IDInscripcion = Insc.Id
	WHERE Insc.IDCurso = @IdCurso

	SET @Promedio = IsNull(@Promedio, 0.00)
	-- Si no hubo reseñas 

	RETURN @Promedio
END
GO

-- Test funcion
SELECT C.Id, C.Nombre, dbo.Fn_PuntajeCurso(C.Id) PuntajeTotal
FROM Cursos C

-- Test consulta
SELECT C.Id, CAST(AVG(R.puntaje) AS decimal(3,1)) AS PuntajePromedio
FROM Reseñas R
	INNER JOIN Inscripciones Insc
	ON R.IDInscripcion = Insc.Id
	INNER JOIN Cursos C
	ON C.ID = Insc.IDCurso
GROUP BY C.Id
GO

-- 5. Hacer una vista que muestre por cada usuario el apellido y nombre, una
-- columna llamada Contacto que muestre el celular, si no tiene celular el
-- teléfono, si no tiene teléfono el email, si no tiene email el domicilio.
-- También debe mostrar la edad del usuario, el total pagado y el total
-- adeudado.
CREATE OR ALTER VIEW VW_ReportexUsuario
AS
	SELECT DP.Apellidos, DP.Nombres,
		'Contacto' = CASE
			WHEN DP.Celular IS NOT NULL THEN DP.Celular
			WHEN DP.Telefono <> NULL THEN DP.Telefono
			WHEN DP.Email <> NULL THEN DP.Email
			ELSE DP.Domicilio
		END, 'Edad' = dbo.FN_CalcularEdad(DP.ID),
		'TotalPagado' = dbo.FN_PagosxUsuario(DP.ID),
		'TotalAdeudado' = dbo.FN_DeudaxUsuario(DP.ID)
	FROM Datos_Personales DP
GO

-- Test view
SELECT *
FROM VW_ReportexUsuario

-- 6. Hacer uso de la vista creada anteriormente para obtener la cantidad de
-- usuarios que adeuden más de lo que pagaron.

-- Cuenta
SELECT COUNT (CASE WHEN TotalAdeudado > TotalPagado THEN 1 END) AS AdeudaMasDeLoPagado
FROM dbo.VW_ReportexUsuario

-- Cuenta (más sencillo)
SELECT COUNT(Apellidos)
FROM dbo.VW_ReportexUsuario
WHERE TotalAdeudado > TotalPagado

-- Lista
SELECT *
FROM dbo.VW_ReportexUsuario
WHERE TotalAdeudado > TotalPagado
GO

-- 7. Hacer un procedimiento almacenado que permita dar de alta un nuevo curso.
-- Debe recibir todos los valores necesarios para poder insertar un nuevo
-- registro.
USE Univ
GO
CREATE OR ALTER PROCEDURE SP_AgregarCurso
	(
	@Nombre varchar(100),
	@Costo money,
	@CostoCertificacion money,
	@FechaEstreno date,
	@IDNivel smallint,
	@IDCategoria smallint,
	@DebeSerMayorDeEdad bit = 0
)
AS
BEGIN
	BEGIN TRY
		DECLARE @CatName varchar(100)

		SELECT @CatName = Nombre
	FROM Categorias
	WHERE Id = @IdCategoria

	IF @CatName IS NULL BEGIN
		RAISERROR('La categoría indicada no existe', 16,1);
	END

		INSERT INTO Cursos
		(Nombre, CostoCurso, CostoCertificacion, Estreno, IDNivel, DebeSerMayorDeEdad)
	VALUES
		(@Nombre, @Costo, @CostoCertificacion, @FechaEstreno, @IDNivel, @DebeSerMayorDeEdad)

		INSERT INTO Categorias_x_Curso
	VALUES
		(@@IDENTITY, @IDCategoria)

	END TRY

	BEGIN CATCH
		DECLARE @ErrorMsg nvarchar(4000)
		SELECT @ErrorMsg = 'Ocurrió un error al agregar el curso: ' + ERROR_MESSAGE()
		RAISERROR(@ErrorMsg,16,1);
	END CATCH
END

EXEC SP_AgregarCurso 'Test', 10, 100,'10/06/24', 1, 1000

--------------------
-- Limpiar tablas --
--------------------

-- Eliminar las relaciones para los cursos 'test'
DELETE CxC FROM Categorias_x_Curso CxC
	INNER JOIN Cursos C
	ON C.Id = CxC.IdCurso
	WHERE C.Nombre = 'Test'

-- Otra forma
DELETE FROM Categorias_x_Curso
	WHERE IdCurso IN 
	(
		SELECT Id
FROM Cursos
WHERE Nombre = 'test'
	)

-- Eliminar Cursos con nombre 'Test'
DELETE FROM Cursos WHERE Nombre = 'Test'
GO

-- 8. Hacer un procedimiento almacenado que permita modificar porcentualmente el
-- Costo de Cursada de todos los cursos. El procedimiento debe recibir un
-- valor numérico que representa el valor a aumentar porcentualmente. Por
-- ejemplo, si recibe un 60. Debe aumentar un 60% todos los costos.
CREATE OR ALTER PROCEDURE SP_AumentarCursada
	(
	@Porcentaje smallint
)
AS
BEGIN
	Begin TRY
	--DECLARE @PorcentajeDec decimal (3,1)
	--SET @PorcentajeDec = @Porcentaje/100.00 -- Convertir porcentaje a porc. decimal

	UPDATE Cursos
		-- Sin usar variable decimal
		--SET CostoCurso = CostoCurso + (CostoCurso * @Porcentaje)/100
		SET CostoCurso = CostoCurso + (CostoCurso * @Porcentaje/100.00) -- 100.00 para convertir en decimal

		-- Con variable decimal
		--SET CostoCurso = CostoCurso + (CostoCurso * @PorcentajeDec)
	End Try

	Begin CATCH
		DECLARE @ErrorMsg nvarchar(4000)
		SELECT @ErrorMsg = 'Error al actualizar costos: ' + ERROR_MESSAGE()
		RAISERROR(@ErrorMsg, 16, 1)
	End Catch
END

EXEC SP_AumentarCursada 40

SELECT *
FROM Cursos
GO
-- 9 Hacer un procedimiento almacenado llamado SP_PagarInscripcion que a
-- partir de un IDInscripcion permita hacer un pago de la inscripción. El
-- pago puede ser menor al costo de la inscripción o bien el total del
-- mismo. El sistema no debe permitir que el usuario pueda abonar más dinero
-- para una inscripción que el costo de la misma. Se debe registrar en la
-- tabla de pagos con la información que corresponda.
CREATE OR ALTER PROCEDURE SP_PagarInscripcion
	(
	@IDInscripcion bigint,
	@Importe money
)
AS
BEGIN
	BEGIN TRY
		DECLARE @CostoTotal money
		Declare @TotalPagos money

		SELECT @CostoTotal = Costo From Inscripciones
		WHERE Id = @IDInscripcion

		IF @CostoTotal IS NULL BEGIN
			RAISERROR('La inscripción indicada no existe', 16, 0)
		END

		Select @TotalPagos = SUM(Importe)
		From Pagos P
			INNER JOIN Inscripciones I
			on I.Id = P.IDInscripcion
			Where I.ID = @IDInscripcion
		
		if @TotalPagos = @CostoTotal Begin
			RAISERROR('El costo total de esa inscripción ya fue saldado', 16,0)
		END

		IF @Importe > @CostoTotal BEGIN
			RAISERROR('El importe no debe ser mayor al costo del curso', 16,0)
		END

		INSERT INTO Pagos
		VALUES
		(
			@IDInscripcion,
			GETDATE(),
			@Importe
		)

	END TRY

	BEGIN CATCH
		DECLARE @ErrorMsg nvarchar(4000)
		SELECT @ErrorMsg = 'Error al aplicar el pago: ' + ERROR_MESSAGE()
		RAISERROR(@ErrorMsg, 16, 0)
	END CATCH
END

-- Prueba --

Exec SP_PagarInscripcion 10, 0

Select *
	From Pagos
	Inner Join Inscripciones I
	on Pagos.IDInscripcion = I.ID
	Where I.Id = 10
GO
-- 10 Hacer un procedimiento almacenado llamado SP_InscribirUsuario que
-- reciba un IDUsuario y un IDCurso y realice la inscripción a dicho curso
-- de ese usuario. El procedimiento debe realizar las siguientes
-- comprobaciones:
-- - El usuario no debe registrar deuda para poder inscribirse.
-- - El usuario debe ser mayor de edad si el curso requiere esa condición.
--
-- En caso que estas comprobaciones sean satisfechas entonces registrar la
-- inscripción. Determinar el costo de la inscripción al valor actual del
-- curso. Si alguna comprobación no se cumple, indicarlo con un mensaje de
-- error correspondiente.

CREATE OR ALTER PROCEDURE SP_InscribirUsuario
	(
	@IdUsuario bigint,
	@IdCurso int
)
AS
BEGIN
	Begin TRY
		DECLARE @Nombre varchar(50)
		Declare @DebeSerMayorDeEdad bit
		
		SELECT @Nombre = NombreUsuario
		FROM Usuarios
		WHERE Id = @IdUsuario

		IF (
			SELECT Id
			FROM Cursos
			WHERE Id = @IdCurso
			) IS NULL BEGIN
				RAISERROR('El curso no existe', 16, 0)
		END

		IF @Nombre IS NULL BEGIN
			RAISERROR('El usuario no existe', 16,0)
		END

		IF dbo.FN_DeudaxUsuario(@IdUsuario) > 0 BEGIN
			RAISERROR('El usuario posee deuda', 16,0)
		END

		Select @DebeSerMayorDeEdad = DebeSerMayorDeEdad
		From Cursos
		Where Id = @IdCurso

		if @DebeSerMayorDeEdad = 1 And dbo.FN_CalcularEdad(@IdUsuario) < 18 BEGIN
			RAISERROR('El usuario debe ser mayor de edad', 16,0)
		END
		Print @DebeSerMayorDeEdad
		Print dbo.FN_CalcularEdad(@IdUsuario)

		Insert into Inscripciones (IDUsuario, IDCurso, Fecha, Costo)
		Values (
			@IdUsuario,
			@IdCurso,
			GETDATE(),
			(
				Select CostoCurso from Cursos
				Where Id = @IdCurso
			)
		)

	End try

	Begin CATCH
		Declare @ErrorMsg nvarchar(4000)
		Select @ErrorMsg = 'No se pudo agregar la inscripción: ' + ERROR_MESSAGE()
		RAISERROR(@ErrorMsg, 16, 0)
	End Catch
END