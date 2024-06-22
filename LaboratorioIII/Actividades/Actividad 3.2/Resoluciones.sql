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


