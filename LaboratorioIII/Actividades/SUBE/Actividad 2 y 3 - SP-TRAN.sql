USE SUBE
GO

-- A) Realizar un procedimiento almacenado llamado sp_Agregar_Usuario que
-- permita registrar un usuario en el sistema. El procedimiento debe recibir
-- como parámetro DNI, Apellido, Nombre, Fecha de nacimiento y los datos del
-- domicilio del usuario.

CREATE OR ALTER PROCEDURE sp_Agregar_Usuario
	(
	@DNI varchar(8),
	@Apellidos varchar(100),
	@Nombres varchar(100),
	@FechaNacimiento date,
	@Domicilio varchar(200)
)
AS
BEGIN
	INSERT INTO Usuarios
		(DNI, Apellidos, Nombres, FechaNacimiento, Domicilio)
	VALUES
		(
			@DNI,
			@Apellidos,
			@Nombres,
			@FechaNacimiento,
			@Domicilio
	)
END

-- test
EXEC sp_Agregar_Usuario '33999000', 'Carrano Gomez', 'Carlos  Eliseo', '1982-09-10', 'Libertador 1200, Las Flores'
GO

-- B) Realizar un procedimiento almacenado llamado sp_Agregar_Tarjeta que dé
-- de alta una tarjeta. El procedimiento solo debe recibir el DNI del
-- usuario. Como el sistema sólo permite una tarjeta activa por usuario, el
-- procedimiento debe:
-- Dar de baja la última tarjeta del usuario (si corresponde).
-- Dar de alta la nueva tarjeta del usuario.
-- Traspasar el saldo de la vieja tarjeta a la nueva tarjeta (si corresponde).

CREATE OR ALTER PROCEDURE sp_Agregar_Tarjeta
	(
	@DNI varchar(8)
)
AS
BEGIN
	DECLARE @IdUsuario bigint
	DECLARE @SaldoAnterior money
	DECLARE @IdTarjetaAnterior bigint

	SELECT @IdUsuario = IdUsuario
	FROM Usuarios
	WHERE DNI =  @DNI

	SELECT @IdTarjetaAnterior = IdTarjeta
	FROM Tarjetas
	WHERE IdUsuario = @IdUsuario AND Estado = 1

	Begin TRY
	BEGIN TRANSACTION

	IF @IdTarjetaAnterior IS NOT NULL 
	BEGIN
		SELECT
			@SaldoAnterior = IsNull(SUM(Saldo),0)
		FROM Tarjetas
		WHERE IdTarjeta = @IdTarjetaAnterior

		UPDATE Tarjetas
				SET Estado = 0
		WHERE IdTarjeta = @IdTarjetaAnterior
	END

	INSERT INTO Tarjetas
		(NroTarjeta, IdUsuario, FechaAlta, Saldo, Estado)
	VALUES
		(
			Concat(@DNI, CAST(FORMAT(getdate(), 'ddMMmmss') AS varchar(8))),
			@IdUsuario,
			getdate(),
			0,
			1
		)

	IF @SaldoAnterior > 0
	BEGIN
		DECLARE @IdTarjetaNueva bigint

		SELECT @IdTarjetaNueva = @@IDENTITY

		INSERT INTO Movimientos
			(FechaHora, IdTarjeta, Importe, Tipo)
		VALUES
			( -- Se debita el saldo anterior de tarjeta vieja
				GETDATE(),
				@IdTarjetaAnterior,
				@SaldoAnterior,
				'D'
			),
			( -- Se acredita el saldo anterior en tarjeta nueva
				getdate(),
				@IdTarjetaNueva,
				@SaldoAnterior,
				'C'
			)

		-- Actualizar saldos
		UPDATE Tarjetas
				SET Saldo = 0
		WHERE IdTarjeta = @IdTarjetaAnterior

		UPDATE Tarjetas
				SET Saldo = @SaldoAnterior
		WHERE IdTarjeta = @IdTarjetaNueva
	END

		COMMIT TRANSACTION
	End Try

	Begin CATCH
		ROLLBACK TRANSACTION
		RAISERROR('Ocurrió un error al insertar la nueva tarjeta', 16, 1)
	End Catch

END

-- test
EXEC sp_Agregar_Tarjeta '12345678'
go

-- C) Realizar un procedimiento almacenado llamado sp_Agregar_Viaje que
-- registre un viaje a una tarjeta en particular. El procedimiento debe
-- recibir: Número de tarjeta, importe del viaje, nro de interno y nro de
-- línea.
-- El procedimiento deberá:
-- Descontar el saldo.
-- Registrar el viaje.
-- Registrar el movimiento de débito.
--
-- NOTA: Una tarjeta no puede tener una deuda que supere los $2000.

Create or Alter Procedure sp_Agregar_Viaje (
	@NroTarjeta varchar(16),
	@Importe money,
	@NroInterno int,
	@NroLinea int
)
AS
BEGIN
	Declare @IdTarjeta bigint
	Declare @SaldoActual money
	Declare @IdColectivo bigint
	Declare @EstadoTarjeta bit

	BEGIN TRY
		Select 
			@IdTarjeta = IdTarjeta,
			@SaldoActual = Saldo,
			@EstadoTarjeta = Estado
		From Tarjetas
		Where NroTarjeta = @NroTarjeta

		if @EstadoTarjeta = 0
		BEGIN
			RAISERROR('La tarjeta que intenta utilizar ya no está activa', 16, 1)
		END	

		if (@SaldoActual - @Importe <= -2000)
		BEGIN
			RAISERROR('Saldo Insuficiente, supera deuda máxima permitida', 16,1)
		END

	BEGIN TRANSACTION

		UPDATE Tarjetas
			Set Saldo = @SaldoActual - @Importe
		Where IdTarjeta = @IdTarjeta

		Insert into Movimientos
		Values (
			GETDATE(),
			@IdTarjeta,
			@Importe,
			'D'
		)

		Select @IdColectivo = IdColectivo
		from Colectivos C
			Inner Join Lineas_de_Colectivos LdC
			on C.IdLinea = LdC.IdLinea 
		Where C.NroInterno = @NroInterno And LdC.NroLinea = @NroLinea

		Insert into Viajes
		Values (@IdColectivo, @@IDENTITY) -- Id Colectivo y Ult. Id de movimiento insertado
	
	COMMIT TRANSACTION
	END TRY

	BEGIN CATCH
		ROLLBACK TRANSACTION

		Declare @ErrorMsg varchar(4000)
		Select @ErrorMsg = Concat('Ocurrió un error al registrar el viaje: ', ERROR_MESSAGE())
		RAISERROR(@ErrorMsg, 16, 1)
	END CATCH
END

-- test
Exec sp_Agregar_Viaje '1234567821062729', 2000, 101, 1
Go

Select * from Tarjetas
Go

-- D) Realizar un procedimiento almacenado llamado sp_Agregar_Saldo que
-- registre un movimiento de crédito a una tarjeta en particular. El
-- procedimiento debe recibir: El número de tarjeta y el importe a recargar.
-- Modificar el saldo de la tarjeta.

Create or Alter Procedure sp_Agregar_Saldo (
	@NroTarjeta varchar(16),
	@Importe money
)
AS
BEGIN
	Declare @IdTarjeta bigint

	BEGIN TRY
		Select @IdTarjeta = IdTarjeta
		From Tarjetas
		Where NroTarjeta = @NroTarjeta

		IF @IdTarjeta Is Null
		BEGIN
			RAISERROR('La tarjeta ingresada no existe',16,1)
		END

		IF @Importe <= 0
		BEGIN
			RAISERROR('El importe no puede ser 0 o negativo', 16,1)
		END

	BEGIN TRANSACTION

		Insert into Movimientos
		VALUES (
			GETDATE(),
			@IdTarjeta,
			@Importe,
			'C'
		)

		Update Tarjetas
			Set Saldo = Saldo + @Importe
		Where IdTarjeta = @IdTarjeta
	
	COMMIT TRANSACTION
	END TRY

	BEGIN CATCH
		ROLLBACK TRANSACTION
		
		Declare @ErrorMsg varchar(4000)
		Select @ErrorMsg = Concat('Ocurrió un error al agregar el saldo: ', ERROR_MESSAGE())
		RAISERROR(@ErrorMsg, 16, 1)	
	END CATCH
END

-- test
Exec sp_Agregar_Saldo '1234567821062729', 2000

Select * from tarjetas
Select * from Movimientos
GO

-- E) Realizar un procedimiento almacenado llamado sp_Baja_Fisica_Usuario que
-- elimine un usuario del sistema. La eliminación deberá ser 'en cascada'.
-- Esto quiere decir que para cada usuario primero deberán eliminarse todos
-- los viajes y recargas de sus respectivas tarjetas. Luego, todas sus
-- tarjetas y por último su registro de usuario.

Create or Alter Procedure sp_Baja_Fisica_Usuario (
	@IdUsuario bigint
)
AS
BEGIN
	Begin Try

		if (Select IdUsuario
			From Usuarios
			Where IdUsuario = @IdUsuario) is Null
		BEGIN
			RAISERROR('El usuario no existe', 16,1)
		END

		Delete V
		from Viajes V
		inner join Movimientos M
			on V.IdMovimiento = M.IdMovimiento
		inner join Tarjetas T
			on T.IdTarjeta = M.IdTarjeta
		inner join Usuarios U
			on U.IdUsuario = T.IdUsuario
		Where U.IdUsuario = @IdUsuario

		Delete M
		from Movimientos M
		inner join Tarjetas T
			on M.IdTarjeta = T.IdTarjeta
		inner join Usuarios U
			on U.IdUsuario = T.IdUsuario
		where U.IdUsuario = @IdUsuario

		Delete T
		from Tarjetas T
		where IdUsuario = @IdUsuario

		Delete from Usuarios Where IdUsuario = @IdUsuario

	End Try

	Begin Catch
		Declare @ErrorMsg varchar(4000)
		Select @ErrorMsg = Concat('Ocurrió un error al eliminar el usuario: ', ERROR_MESSAGE())
		RAISERROR(@ErrorMsg, 16, 1)	
	End Catch
END

-- test
Exec sp_Baja_Fisica_Usuario 5
Select * from Usuarios
go