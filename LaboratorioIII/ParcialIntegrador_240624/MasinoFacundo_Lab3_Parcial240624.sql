-- Legajo: 28764
-- Apellido: Masino
-- Nombre: Facundo Joaquín

Use ExamenIntegrador_20241C
GO

-- Punto A

Create or Alter Trigger TR_Registrar_Adelanto
on Adelantos after insert
AS
BEGIN
	Begin TRY
		BEGIN TRAN
			Declare @IdEmpleado bigint
			Declare @SueldoEmpleado money
			Declare @Antiguedad tinyint
			Declare @YaPidioAdelanto bit
			Declare @MontoAdelanto money
			Declare @FechaAdelanto date

			Set @IdEmpleado = (Select IDEmpleado from inserted)
			Set @MontoAdelanto = (Select Monto from inserted)
			Set @FechaAdelanto = (Select Fecha from inserted)

			-- Antes de realizar consultas comprobar que cumpla esta condición básica
			If @MontoAdelanto <= 0
			BEGIN
				RAISERROR('El monto no puede ser $ 0 o negativo.', 16,1)
			END

			Select
				@SueldoEmpleado = Sueldo,
				@Antiguedad = DATEPART(YEAR, GETDATE()) - AnioIngreso
			from Empleados
			Where IDEmpleado = @IdEmpleado

			-- Ver si existe el ID en adelantos pedidos de este año
			-- Excluyendo esta ultima insercion
			SELECT
				@YaPidioAdelanto = CASE WHEN @IdEmpleado IN
					(
					SELECT IDEmpleado
					FROM Adelantos
					WHERE DATEPART(YEAR, Fecha) = DATEPART(YEAR, @FechaAdelanto) AND IDAdelanto <> @@IDENTITY
					)
				THEN 1
				ELSE 0
				END

			If @MontoAdelanto > (@SueldoEmpleado * 0.6)
			BEGIN
				RAISERROR('El monto no puede superar el 60 porciento del sueldo del empleado', 16,1)
			END

			If @Antiguedad <= 5
			BEGIN
				RAISERROR('No cumple con la antiguedad requerida, debe ser mayor a 5 años', 16,1)
			END

			if @YaPidioAdelanto = 1
			BEGIN
				RAISERROR('Solo puede pedir 1 adelanto en un mismo año', 16,1)
			END

		COMMIT 
	End Try

	BEGIN CATCH
		ROLLBACK -- Cancelar adelanto
		Declare @ErrorMsg Varchar(4000)
		Set @ErrorMsg = 'Error al registrar adelanto: ' + ERROR_MESSAGE()
		RAISERROR(@ErrorMsg, 16, 1)
	END CATCH
END
GO

-- B
Create or Alter Procedure SP_PuntoB (
	@Inicio date,
	@Fin date
)
AS
BEGIN
	Select
		Cat.Nombre NombreCategoria,
		Count(E.IdEmpleado) CantidadEmpleados
	from Categorias Cat
		inner join (
			Select
			A.IdEmpleado,
			E.IDCategoria IdCatEmpleado
			from Adelantos A
			inner join Empleados E
			on E.IDEmpleado = A.IDEmpleado
			Where A.Fecha Between @Inicio and @Fin
			Group by A.IDEmpleado, E.IDCategoria
			Having Count(A.IDEmpleado) >= 1) E
		on E.IdCatEmpleado = Cat.IDCategoria
	Group By Cat.Nombre
END

GO

-- C

Select
	E.Nombre,
	E.Apellido
from Empleados E
	inner join Adelantos A
	on A.IDEmpleado = E.IDEmpleado
Where DATEPART(YEAR, A.Fecha) = DATEPART(YEAR, GETDATE())
GROUP BY E.Nombre, E.Apellido
HAVING IsNull(SUM(A.Monto),0) > 500

-- D

Create Table DictamenesAdelantos (
	IdDictamen bigint NOT NULL IDENTITY(1,1) PRIMARY KEY,
	IDAdelanto bigint NOT NULL Foreign key References Adelantos(IDAdelanto),
	IDDictaminador bigint NOT NULL foreign key references Empleados(IDEmpleado),
	Autorizado bit NOT NULL,
	Fecha date NOT NULL,
	Descripcion varchar(max) -- Usaria el tipo text pero esta en desuso
	CONSTRAINT UQ_Dictamen_Adelanto UNIQUE (IDAdelanto) -- No puede haber mas de un dictamen por adelanto
)