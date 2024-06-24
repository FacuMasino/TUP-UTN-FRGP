Use ModeloExamenIntegrador_20241C
Go

-- 1
Select
	Op.Apellidos ApellidosOperario,
	Op.Nombres NombresOperario,
	M.Nombre Material,
	Pie.Nombre Pieza,
	Pro.Fecha,
	Pro.Cantidad,
	Pro.Medida,
	Case When Pro.Medida BETWEEN Pie.MedidaMinima AND Pie.MedidaMaxima
	Then 'No Defectuosa'
	Else 'Defectuosa'
	END as Utilidad
From Produccion Pro
	inner join Operarios Op
	on Op.IDOperario = Pro.IDOperario
	inner join Piezas Pie
	on Pie.IDPieza = Pro.IDPieza
	inner join Materiales M
	on M.IDMaterial = Pie.IDMaterial
GO

-- 2
Select 
	Op.Apellidos ApellidosOperario,
	Op.Nombres NombresOperario
from Operarios Op
	inner join Produccion Pro
	on Pro.IDOperario = Op.IDOperario
	inner join Piezas Pie
	on Pie.IDPieza = Pro.IDPieza
	inner join Materiales M
	on M.IDMaterial = Pie.IDMaterial
Where DATEDIFF(YEAR,Pro.Fecha, getdate()) <= 5
Group By Op.Apellidos, Op.Nombres
HAVING Count (
		Case When M.Nombre = 'Zinc'
		THEN '1'
		END
		) = 0
GO

-- 3

Create or Alter Procedure SP_Material_Mas_Utilizado (
	@Anio int
)
AS
BEGIN
	Select Top 1
		Mat.Nombre NombreMaterial,
		Mat.PiezasProducidas
	from (
		Select
			M.Nombre,
			IsNull(SUM(Pro.Cantidad),0) PiezasProducidas
		from Materiales M
			inner join Piezas Pie 
			on Pie.IDMaterial = M.IDMaterial
			inner join Produccion Pro
			on Pro.IDPieza = Pie.IDPieza
		Where DATEPART(YEAR, Pro.Fecha) = @Anio
		Group by M.Nombre
	) Mat
	Order By Mat.PiezasProducidas Desc
END
GO

-- 4

Create or Alter TRIGGER TR_Registar_Produccion
on Produccion after insert
AS
BEGIN
	Begin TRY
		BEGIN TRAN
			Declare @IdOperario bigint
			Declare @IdPieza bigint
			Declare @PiezasProducidas int
			Declare @CostoUnitario money

			Set @IdOperario = (Select IDOPerario from Inserted)
			Set @IdPieza = (Select IDPieza from Inserted)

			Select
				@CostoUnitario = CostoUnitarioProduccion
			from Piezas
			Where IDPieza = @IdPieza

			if @CostoUnitario < 1000
			BEGIN
				Print 'Costo unitario < 1000, operario permitido. No requiere min. de cantidad producida.'
				COMMIT -- No necesita validar piezas producidas
			END

			Select
				@PiezasProducidas = IsNull(SUM(Pro.Cantidad), 0)
			from Produccion Pro
			Where Pro.IDOperario = @IdOperario And Pro.IDProduccion <> @@IDENTITY -- Excluir esta ultima inserción

			If @CostoUnitario > 1000 And @PiezasProducidas < 500
			BEGIN
				RAISERROR('El operario no cumple los requisitos minimos para esta produccion. Cant. Piezas Producidas < 500', 16,1)
			END

		COMMIT 
	End Try

	BEGIN CATCH
		ROLLBACK
		Declare @ErrorMsg Varchar(4000)
		Set @ErrorMsg = 'Error al registrar produccion: ' + ERROR_MESSAGE()
		RAISERROR(@ErrorMsg, 16, 1)
	END CATCH	
END
GO

-- 5

Create or Alter Procedure SP_Punto_5 (
	@NombreMaterial varchar(50)
)
AS
BEGIN
	Select
		Op.Apellidos,
		Op.Nombres
	From Operarios OP
		inner join Produccion Pro
		on Pro.IdOperario = OP.IDOperario
		inner join Piezas Pie
		on Pie.IDPieza = Pro.IdPieza
		inner join Materiales Mat
		on Mat.IDMaterial = Pie.IDMaterial
	Where Mat.Nombre = @NombreMaterial
	Group By Op.apellidos, Op.Nombres
	HAVING COUNT(Pro.IDProduccion) > 5
END