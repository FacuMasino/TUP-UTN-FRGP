use ModeloExamenIntegrador_20241C
Go

CREATE OR ALTER TRIGGER TR_ProdNueva ON Produccion
INSTEAD OF INSERT
AS
BEGIN
	BEGIN TRY
		BEGIN TRANSACTION

			Declare @IDOperario bigint, @IDPieza bigint, @Fecha date,
			@Medida decimal(5,3), @Cantidad int, @CostoTotal money

			Declare @Antiguedad int
			Declare @CostoUProd money

			Select @IDOperario = IDOperario, @IDPieza = IDPieza, @Fecha = Fecha,
			@Medida = Medida, @Cantidad = Cantidad, @CostoTotal = CostoTotal from inserted
			
			IF (Select Fecha from inserted)	> GETDATE() BEGIN

				Select @Antiguedad = datediff(YEAR, O.AnioAlta, GETDATE())
					from inserted Ins
					INNER JOIN Operarios O
					ON Ins.IDOperario = O.IDOperario

				Select @CostoUProd = Piezas.CostoUnitarioProduccion
				from Inserted Ins
				inner join Piezas
				on Piezas.IDPieza = Ins.IDPieza

				if @Antiguedad < 5 And @CostoUProd > 15 BEGIN
					RAISERROR('El empleado debe tener experiencia mayor a 5 años para esta producción', 16,1 )
				END

			-- Calcular siempre? o solo cuando la fecha sea mayor a la actual?
			Set @CostoTotal = @Cantidad * @CostoUProd

			END

			Insert into Produccion (IDOperario, IDPieza, Fecha, Medida, Cantidad, CostoTotal)
			Values (
				@IDOperario,
				@IDPieza,
				@Fecha,
				@Medida,
				@Cantidad,
				@CostoTotal
			)

		COMMIT TRANSACTION
	END TRY

	BEGIN CATCH
		Declare @ErrorMsg varchar(4000)
		Select @ErrorMsg = (Select 'Ocurrió un error: ' + ERROR_MESSAGE())
		ROLLBACK TRANSACTION
		RAISERROR (ERROR_MESSAGE(), 16, 1)
	END CATCH
END

-- 2. Hacer un listado que permita visualizar el nombre del material, el nombre de la pieza
-- y la cantidad de operarios que nunca produjeron esta pieza.

Select M.Nombre, Pieza.Nombre,
	( 
		Select COUNT(IDOperario) from
		(
			Select IDOperario from Operarios
			where IDOperario not in	
				(Select OP.IDOperario from Operarios OP
					inner join Produccion Prod
					on OP.IDOperario = Prod.IDOperario
					inner join Piezas
					on Prod.IDPieza = Piezas.IDPieza
					where Piezas.IDPieza = Pieza.IDPieza 
				)
		) as IDOperario
	)
	as CantOpNuncaProdujeron from Piezas Pieza
	inner join Materiales M
	on M.IDMaterial = Pieza.IDMaterial

-- Alternativa
SELECT m.Nombre, p.Nombre,
    COUNT(o.IDOperario) AS CantidadOperariosQueNuncaProdujeron
FROM Materiales m
	INNER JOIN Piezas p 
	ON m.IDMaterial = p.IDMaterial
	INNER JOIN  Operarios o 
	ON o.IDOperario NOT IN (
        SELECT pr.IDOperario 
        FROM Produccion pr 
        WHERE pr.IDPieza = p.IDPieza
    )
GROUP BY 
    m.Nombre, p.Nombre
GO

-- 3. Hacer un procedimiento almacenado llamado Punto_3 que reciba el nombre de
-- un material y un valor porcentual (admite 2 decimales) y modifique el
-- precio unitario de producción a partir de este valor porcentual a todas
-- las piezas que sean de este material.

CREATE OR ALTER PROCEDURE SP_Punto_3 (
	@NombreMaterial varchar(50),
	@Porcentaje decimal(6,2)
)
AS
BEGIN
	BEGIN TRY
		IF @Porcentaje < -99.99 BEGIN
			RAISERROR('No se puede realizar un porc. de descuento igual o mayor al 100',16,1)
		END

		IF @Porcentaje > 1000.00 BEGIN
			RAISERROR('No se puede realizar un porc. de aumento mayor al 1000', 16,1 )
		END

		Declare @IdMaterial smallint

		Select @IdMaterial = IdMaterial from Materiales
		WHERE Nombre = @NombreMaterial 

		UPDATE Piezas
			SET CostoUnitarioProduccion += CostoUnitarioProduccion * (@Porcentaje/100.00)
			Where IDMaterial = @IdMaterial 
		
	END TRY

	BEGIN CATCH
		Declare @ErrorMsg varchar(4000)
		Select @ErrorMsg = (Select 'Ocurrió un error: ' + ERROR_MESSAGE())
		RAISERROR (@ErrorMsg, 16, 1)
	END CATCH
END
GO

-- 4 Hacer un procedimiento almacenado llamado Punto_4 que reciba dos fechas y
-- calcule e informe el costo total de todas las producciones que se
-- registraron entre esas fechas.

CREATE OR ALTER PROCEDURE SP_Punto_4 (
	@FechaInicio date,
	@FechaFin date
)
AS
BEGIN
	BEGIN TRY
		Select IsNull(SUM(CostoTotal),0) as CostoTotalProducciones from Produccion
		Where Fecha BETWEEN @FechaInicio AND @FechaFin
		Print 'Costo total entre las fechas: ' + CAST(@FechaInicio as varchar) + ' al ' + CAST(@FechaFin as varchar)
	END TRY

	BEGIN CATCH
		Declare @ErrorMsg varchar(4000)
		Select @ErrorMsg = (Select 'Ocurrió un error: ' + ERROR_MESSAGE())
		RAISERROR (@ErrorMsg, 16, 1)
	END CATCH
END
GO
-- test
Exec SP_Punto_4 '2023-01-14', '2023-03-05'

-- 5 Hacer un listado que permita visualizar el nombre de cada material y el
-- costo total de las producciones estropeadas de ese material. Sólo listar
-- aquellos registros que totalicen un costo total mayor a $100.

Select M.Nombre Material, Sum(CostoTotal) CostoTotalEstropeadas from Materiales M
	inner join Piezas
	on Piezas.IDMaterial = M.IDMaterial
	inner join Produccion P
	on P.IDPieza = Piezas.IDPieza
	Where P.Medida NOT BETWEEN Piezas.MedidaMinima AND Piezas.MedidaMaxima
Group By M.Nombre
HAVING Sum(CostoTotal) > 100

-- Alternativa sin having (no recomendada)
Select * from (
	Select M.Nombre Material, Sum(CostoTotal) CostoTotalEstropeadas from Materiales M
		inner join Piezas
		on Piezas.IDMaterial = M.IDMaterial
		inner join Produccion P
		on P.IDPieza = Piezas.IDPieza
		Where P.Medida NOT BETWEEN Piezas.MedidaMinima AND Piezas.MedidaMaxima
	Group By M.Nombre
) ProduccionEstropeada
where CostoTotalEstropeadas > 100
