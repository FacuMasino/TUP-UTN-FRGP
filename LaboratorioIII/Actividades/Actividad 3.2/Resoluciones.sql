USE Univ 
GO
-- 1 Hacer un trigger que no permita la inscripción de un usuario a un curso
-- si el usuario:
-- - Registra deuda
-- - Es el instructor del curso
--
-- En caso de falla mostrar un mensaje aclaratorio pertinente. Sino insertar
-- la inscripción teniendo en cuenta que el costo de la misma debe ser el
-- costo actual del curso en cuestión. 

CREATE OR ALTER TRIGGER tr_inscribir_curso
ON Inscripciones Instead Of INSERT 
AS 
BEGIN
	BEGIN Try
		Begin Tran
		Declare @IdUsuario Bigint
		Declare @IdCurso Bigint
		
		Select @IdUsuario = IdUsuario from inserted
		Select @IdCurso = IdCurso from inserted

		if (select IdUsuario
			from Instructores_x_Curso
			Where IdUsuario = @IdUsuario
			And IDCurso = @IdCurso) Is Not Null
		Begin
			RAISERROR('No se puede inscribir al insctructor', 16,1)
		END

		IF dbo.FN_DeudaxUsuario(@IdUsuario) > 0
		BEGIN
			RAISERROR('Posee deuda.',16,1)
		END
		
		Declare @Costo money
		Select @Costo = CostoCurso from Cursos Where Id = @IdCurso

		Insert into Inscripciones (IdUsuario, IdCurso, Fecha, Costo)
		Values (@IdUsuario, @IdCurso, getdate(), @Costo)

		Commit Tran
	End Try

	Begin Catch
		ROLLBACK
		Declare @ErrorMsg varchar(4000)
		Select @ErrorMsg = Concat('Ocurrió un error al inscribir el usuario: ', ERROR_MESSAGE())
		RAISERROR(@ErrorMsg, 16, 1)	
	End Catch
END
Go

-- test posee deuda
insert into Inscripciones
Values (1, 25, GETDATE(), 0)

-- test es instructor
insert into Inscripciones
Values (7,9,GETDATE(),0)

-- test exitoso
insert into Inscripciones
Values (10,1, GETDATE(), 0)
Go

-- 2 Hacer un trigger que no permita que se ingrese un nuevo curso cuyo costo
-- de certificación sea un valor mayor a 10 veces más que el costo de
-- certificación más caro. En caso de falla mostrar un mensaje aclaratorio
-- de lo contrario registrar el curso.

Create or Alter TRIGGER tr_Nuevo_Curso
On cursos
Instead of Insert
As
BEGIN
	Begin Try
		Begin Tran

		Declare @CostoCertMayor money
		Declare @CostoCertNuevo money

		Declare @IdNivel tinyint = (Select IdNivel from Inserted)
		Declare @Nombre varchar(100) = (Select Nombre from Inserted)
		Declare @CostoCurso money = (Select CostoCurso from Inserted)
		Set @CostoCertNuevo = (Select CostoCertificacion from Inserted)
		Declare @Estreno date = (Select Estreno from inserted)
		Declare @DebeSerMayorDeEdad bit = (Select DebeSerMayorDeEdad from inserted)

		Select @CostoCertMayor = Max(CostoCertificacion) from Cursos 
		-- Set @CostoMayor = (Select top 1 CostoCurso from Cursos Order By CostoCurso Desc) -- alternativa

		if @CostoCertNuevo > (@CostoCertMayor * 10)
		BEGIN
			Declare @Msg varchar(4000)
			Set @Msg = Concat('Costo certificación no puede ser 10 veces mayor que el costo de certificacion más caro -> $', @CostoCertMayor * 10) 
			RAISERROR( @Msg, 16, 1)
		END

		-- La columna DebeSerMayorDeEdad admite valores Null y su valor por defecto es 0
		Insert into Cursos (IDNivel, Nombre, CostoCurso, CostoCertificacion, Estreno, DebeSerMayorDeEdad)
		Values (
			@IdNivel, @Nombre, @CostoCurso, @CostoCertNuevo, @Estreno,
			Case When @DebeSerMayorDeEdad Is Null 
			Then Null
			Else @DebeSerMayorDeEdad
			END 
		)

		Commit
	End Try

	Begin Catch
		ROLLBACK
		Declare @ErrorMsg varchar(4000)
		Select @ErrorMsg = Concat('Ocurrió un error al agregar el curso: ', ERROR_MESSAGE())
		RAISERROR(@ErrorMsg, 16, 1)	
	End Catch
END
Go

Select Max(CostoCertificacion) from Cursos
Go

-- test
insert into Cursos (IdNivel, Nombre, CostoCurso, CostoCertificacion, Estreno)
Values (1, 'Test', 1234, 350001, DATEADD(DAY, 1, getdate()))

-- mostrar y limpiar
Select * from Cursos
Delete from Cursos Where Nombre = 'Test'
Go

-- 3 Hacer un trigger que no permita registrar una certificación si el
-- usuario no realizó todos los pagos correspondientes para cubrir el costo
-- de la inscripción. En caso de falla mostrar un mensaje aclaratorio de lo
-- contrario registrar la certificación.

Create or Alter Trigger tr_Registrar_Certificacion
on Certificaciones After Insert
AS
BEGIN
	Begin TRY
		BEGIN TRAN
			Declare @TotalPago money
			Declare @IdInscripcion bigint = (Select IdInscripcion from inserted)
			Declare @CostoInscripcion money = (Select Costo from Inscripciones
											   Where ID = @IdInscripcion)

			Select @TotalPago = IsNull(Sum(Importe), 0)
			from Pagos P
				Inner Join Inscripciones Insc
				on Insc.ID = P.IDInscripcion
				Where P.IDInscripcion = @IdInscripcion

			if @TotalPago < @CostoInscripcion
			BEGIN
				RAISERROR('El usuario no pagó el total de la inscripción', 16,1)
			END

		COMMIT 
	End Try

	BEGIN CATCH
		ROLLBACK
		Declare @ErrorMsg varchar(4000)
		Set @ErrorMsg = 'Ocurrió un error al registrar la certificación: ' + ERROR_MESSAGE()
		RAISERROR(@ErrorMsg, 16,1)
	END CATCH
END
GO

-- Tests
--------------------------------------------------------------------------
Select * from Inscripciones where ID = 1
Select * from Certificaciones where IDInscripcion = 1
Select * from Cursos Where Id = 1

Select Insc.Id IdInscripcion, Insc.Costo, SUM(Importe) TotalPago
from Inscripciones Insc
	inner join Pagos P
	on P.IDInscripcion = insc.ID
Group By Insc.Id, Insc.Costo
Having Insc.Costo <> SUM(Importe)

Update Inscripciones Set Costo = 14000 Where Id = 1

Delete from Certificaciones Where IDInscripcion = 1

Insert into Certificaciones Values (1, GETDATE(), (select CostoCertificacion
												   from Cursos C
												   inner join Inscripciones Insc
												   on Insc.IdCurso = C.Id
												   Where Insc.Id = 1))

Select * from Certificaciones
GO
-----------------------------------------------------------------------

-- 4 Hacer un trigger que al eliminar una reseña no la elimine permanentemente
-- sino que la marque como inapropiada.

Create or Alter TRIGGER tr_Eliminar_Reseña
on Reseñas instead of delete
AS
BEGIN
	BEGIN TRY
		BEGIN TRAN
			Declare @IdInscripcion bigint = (Select IdInscripcion from deleted)

			Update Reseñas
				Set Inapropiada = 1
			Where IDInscripcion = @IdInscripcion
		COMMIT
	END TRY

	BEGIN CATCH
		ROLLBACK
		Declare @ErrorMsg varchar(4000)
		Set @ErrorMsg = 'Ocurrió un error al eliminar la reseña: ' + ERROR_MESSAGE()
		RAISERROR(@ErrorMsg, 16,1)	
	END CATCH
END
GO

-- Test
Update Reseñas Set Inapropiada = 0 Where IDInscripcion = 5
Select * from Reseñas Where IDInscripcion = 5
Delete from Reseñas Where IDInscripcion = 5
Select * from Reseñas Where IDInscripcion = 5
Go

-- 5 Hacer un trigger que al ingresar un pago verifique que el usuario no esté
-- abonando, en total, más dinero que el costo total de la inscripción que
-- está abonando. Es decir, si la inscripción tiene un costo de $10000 y el
-- usuario está abonando un pago de $5000 el trigger debe validar que dichos
-- $5000 más todos los pagos realizados para esa inscripción no superen los
-- $10000.
--
-- En caso de superar el importe indicarlo con un mensaje aclaratorio y no
-- permitir el pago, de lo contrario, registrar el pago.

Create or Alter TRIGGER tr_Ingresar_Pago
on Pagos after INSERT
AS
BEGIN
	Begin Try
		Begin Tran
		Declare @IdInscripcion bigint = (Select IdInscripcion from inserted)
		Declare @CostoInscripcion money
		Declare @TotalPagos money

		-- Obtener el total de pagos (incluye esta ultima insersión)
		Select @TotalPagos = IsNull(SUM(Importe),0)
		from Pagos
		Where IDInscripcion = @IdInscripcion

		-- Obtener costo de inscripcion
		Select @CostoInscripcion = Costo from Inscripciones
		Where Id = @IdInscripcion

		-- No hace falta sumar el importe porque ya está incluido (por ser after insert)
		if (@TotalPagos) > @CostoInscripcion
		BEGIN
			RAISERROR('Está intentando pagar más de lo adeudado', 16, 1)
		END

		Commit
	End Try

	Begin Catch
		ROLLBACK -- No permitir el insert
		Declare @ErrorMsg varchar(4000)
		Set @ErrorMsg = 'Ocurrió un error al registrar el pago: ' + ERROR_MESSAGE()
		RAISERROR(@ErrorMsg, 16,1)		
	End Catch
END
GO

-- Alternativa Instead of
Create or Alter TRIGGER tr_Ingresar_Pago
on Pagos instead of INSERT
AS
BEGIN
	Begin Try
		Begin Tran
		Declare @IdInscripcion bigint = (Select IdInscripcion from inserted)
		Declare @Importe money = (Select Importe from Inserted)
		Declare @CostoInscripcion money
		Declare @TotalPagos money

		-- Obtener el total de pagos
		Select @TotalPagos = IsNull(SUM(Importe),0)
		from Pagos
		Where IDInscripcion = @IdInscripcion

		-- Obtener costo de inscripcion
		Select @CostoInscripcion = Costo from Inscripciones
		Where Id = @IdInscripcion

		if (@TotalPagos + @Importe) > @CostoInscripcion
		BEGIN
			RAISERROR('Está intentando pagar más de lo adeudado', 16, 1)
		END

		Insert into Pagos
		Values (@IdInscripcion,
				(Select Fecha from Inserted),
				@Importe)

		Commit
	End Try

	Begin Catch
		ROLLBACK
		Declare @ErrorMsg varchar(4000)
		Set @ErrorMsg = 'Ocurrió un error al registrar el pago: ' + ERROR_MESSAGE()
		RAISERROR(@ErrorMsg, 16,1)		
	End Catch
END
GO

-- Tests
Select SUM(Importe) from Pagos Where IDInscripcion = 2

Select * from Inscripciones where Id = 2

Insert into Pagos (IDInscripcion, Fecha, Importe)
Values (2, getdate(), 10000)

Select * from pagos order by fecha desc