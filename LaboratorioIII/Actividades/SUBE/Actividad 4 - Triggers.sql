Use SUBE
GO

-- 1) Realizar un trigger que al agregar un viaje:
-- - Verifique que la tarjeta se encuentre activa.
-- - Verifique que el saldo de la tarjeta sea suficiente para realizar el
--   viaje.
-- - Registre el viaje.
-- - Registre el movimiento.
-- - Descuente el saldo de la tarjeta.

-- Se modifica consigna por la estructura de la DB
-- El trigger se dispara al agregar un movimiento

Create or Alter TRIGGER tr_Agregar_Movimiento
on Movimientos After Insert
AS
BEGIN
	BEGIN TRY
		BEGIN TRAN
			Declare @IdTarjeta bigint = (Select IdTarjeta from inserted)
			Declare @ImporteMov money = (Select Importe from inserted)
			Declare @SaldoTarjeta money

			Declare @EstadoTarjeta bit  = (
				Select Estado from Tarjetas
				Where IdTarjeta = @IdTarjeta
			)

			if @EstadoTarjeta = 0
			BEGIN
				RAISERROR('La tarjeta que intenta utilizar ya no está activa', 16, 1)
			END

			Select @SaldoTarjeta = Saldo
			from Tarjetas
			Where IdTarjeta = @IdTarjeta

			
			if (Select Tipo from Inserted) = 'D'
			BEGIN -- Movimiento Debito
				if @SaldoTarjeta < @ImporteMov
				BEGIN
					RAISERROR('Saldo insuficiente', 16, 1)
				END

				Update Tarjetas -- Descontar saldo
					Set Saldo = Saldo - @ImporteMov
				Where IdTarjeta = @IdTarjeta
			END
			ELSE
			BEGIN -- Movimiento Crédito
				Update Tarjetas -- Acreditar saldo
					Set Saldo = Saldo + @ImporteMov
				Where IdTarjeta = @IdTarjeta	
			END

		COMMIT
	END TRY

	BEGIN CATCH
		ROLLBACK
		Declare @ErrorMsg Varchar(4000)
		Set @ErrorMsg = 'Error al registrar movimiento: ' + ERROR_MESSAGE()
		RAISERROR(@ErrorMsg, 16, 1)
	END CATCH
END
GO

-- Tests
Select * from Movimientos
Select * from Tarjetas where Estado = 1

Insert into Movimientos (FechaHora, Idtarjeta, Importe, Tipo)
Values (
	getdate(),
	2,
	1000,
	'D'
)
GO
-- 2) Realizar un trigger que al registrar un nuevo usuario:
-- - Registre el usuario.
-- - Registre una tarjeta a dicho usuario.

Create or alter TRIGGER tr_Registrar_Usuario
on Usuarios after INSERT
AS
BEGIN
	BEGIN TRY
		Begin TRAN
			Declare @IdUsuario bigint = (Select IdUsuario from Inserted)
			Declare @DNI varchar(8) = (Select DNI from Inserted)	
			Insert into Tarjetas
			Values (
				Concat(@DNI, Format(getdate(), 'yyyymmss')),
				@IdUsuario,
				getdate(),
				0,
				1
			)
		COMMIT
	END TRY

	BEGIN CATCH
		ROLLBACK
		Declare @ErrorMsg Varchar(4000)
		Set @ErrorMsg = 'Error al registrar usuario: ' + ERROR_MESSAGE()
		RAISERROR(@ErrorMsg, 16, 1)
	END CATCH
END
GO

-- Test
insert into Usuarios (Nombres, Apellidos, DNI, Domicilio, FechaNacimiento)
values (
	'Tester',
	'Apellido tester',
	'00110011',
	'Un domicilio tester 123',
	'1990-03-14'
)

Select * from Usuarios
Go

-- 3) Realizar un trigger que al registrar una nueva tarjeta:
-- - Le realice baja lógica a la última tarjeta del cliente.
-- - Le asigne a la nueva tarjeta el saldo de la última tarjeta del cliente.
-- - Registre la nueva tarjeta para el cliente (con el saldo de la vieja
--   tarjeta, la fecha de alta de la tarjeta deberá ser la del sistema).

Create or Alter TRIGGER tr_Nueva_Tarjeta
on Tarjetas instead of Insert
AS
BEGIN
	BEGIN TRY
		BEGIN TRAN
			Declare @NroTarjeta varchar(16)
			Declare @IdUsuario bigint
			Declare @IdUltTarjeta bigint
			Declare @SaldoActual money

			Select @NroTarjeta = NroTarjeta,
				   @IdUsuario = IdUsuario
			from Inserted

			Select @IdUltTarjeta = IdTarjeta,
				   @SaldoActual = Saldo
			from Tarjetas
			Where IdUsuario = @IdUsuario AND Estado = 1

			if @IdUltTarjeta is Not NULL
			BEGIN
				Update Tarjetas
					Set Estado = 0,
						Saldo = 0
				Where Idtarjeta = @IdUltTarjeta
			END

			Insert into Tarjetas (NroTarjeta, IdUsuario, FechaAlta, Saldo, Estado)
			Values (
				@NroTarjeta,
				@IdUsuario,
				getdate(),
				IsNull(@SaldoActual,0),
				1
			)
		COMMIT
	END TRY
	
	BEGIN CATCH
		ROLLBACK
		Declare @ErrorMsg Varchar(4000)
		Set @ErrorMsg = 'Error al agregar Tarjeta: ' + ERROR_MESSAGE()
		RAISERROR(@ErrorMsg, 16, 1)
	END CATCH
END
GO

-- Test
Insert into Tarjetas (NroTarjeta, IdUsuario, FechaAlta, Saldo)
Values ('0987654432987651',
		1,
		'2024-06-20',
		0)

Select * from Tarjetas