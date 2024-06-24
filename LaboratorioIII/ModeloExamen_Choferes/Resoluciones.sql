use ModeloExamen20232C
Go

-- 1
Create Table CalificacionesAChofer (
	Id bigint NOT NULL IDENTITY(1,1) PRIMARY KEY,
	IdViaje bigint NOT NULL FOREIGN KEY REFERENCES Viajes(ID),
	Calificacion tinyint NOT NULL,
	Observacion varchar(300),
	-- restriccion calificacion
	CONSTRAINT CHK_Calif_AChofer CHECK (Calificacion BETWEEN 1 AND 10),
	-- restriccion 1 por viaje
	CONSTRAINT UQ_UnicaCalif_AChofer UNIQUE (IdViaje)
)
Go

Create Table CalificacionesACliente (
	Id bigint NOT NULL IDENTITY(1,1) PRIMARY KEY,
	IdViaje bigint NOT NULL FOREIGN KEY REFERENCES Viajes(ID),
	Calificacion tinyint NOT NULL,
	Observacion varchar(300),
	-- restriccion calificacion
	CONSTRAINT CHK_Calif_ACliente CHECK (Calificacion BETWEEN 1 AND 10),
	-- restriccion 1 por viaje
	CONSTRAINT UQ_UnicaCalif_ACliente UNIQUE (IdViaje)
)
Go

-- 2
Create or Alter VIEW VW_ClientesDeudores
AS
Select C.Apellidos,
		C.Nombres,
		Coalesce(C.Email, C.Telefono, 'Sin datos de contacto') as Contacto,
		Count (V.Id) CantViajes,
		Count(
			CASE WHEN V.Pagado = 0
			Then 1
			End
		) ViajesNoAbonados,
		IsNull(SUM (
			CASE WHEN V.Pagado = 0
			THEN V.Importe
			ELSE 0
			END
		),0) TotalAdeudado
From Clientes C
	inner join Viajes V
	on C.Id = V.IDCliente
Group By C.Apellidos, C.Nombres, Coalesce(C.Email, C.Telefono, 'Sin datos de contacto')
Having Count(
			CASE WHEN V.Pagado = 0
			Then 1
			End
		) > (Count (V.Id)/2)
Go

-- 3
Create or Alter Procedure SP_ChoferesEfectivo (
	@Anio int
)
AS
BEGIN
	Select
		Filtro.Apellidos,
		Filtro.Nombres
	from (
		Select
			C.Apellidos,
			C.Nombres,
			Count (V.Id) TotalViajes,
			Count (
				Case When FP.Nombre = 'Efectivo'
				THEN 1
				END
			) TotalEnEfectivo
		from Choferes C
			inner join Viajes V
			on C.Id = V.IDChofer
			inner join FormasPago FP
			on FP.ID = V.FormaPago
		Where Datepart(year, Inicio) = @Anio
		Group by C.Apellidos, C.Nombres
	) as Filtro
	Where Filtro.TotalViajes = Filtro.TotalEnEfectivo
END
GO

Create or Alter TRIGGER TR_Borrar_Cliente
on Clientes Instead of Delete
AS
BEGIN
	Begin TRY
		BEGIN TRAN
			Declare @IdCliente bigint

			Set @IdCliente = (Select ID from deleted)

			Delete from Puntos
			Where IdCliente = @IdCliente

			Update Viajes
				Set IDCliente = NULL
			Where IDCliente = @IdCliente

			Delete from Clientes
			Where ID = @IdCliente
		COMMIT 
	End Try

	BEGIN CATCH
		ROLLBACK
		Declare @ErrorMsg Varchar(4000)
		Set @ErrorMsg = 'Error al eliminar cliente: ' + ERROR_MESSAGE()
		RAISERROR(@ErrorMsg, 16, 1)
	END CATCH
END
Go

-- 5
Create or Alter TRIGGER TR_Calificar_Chofer
on CalificacionesAChofer After Insert
AS
BEGIN
	Begin TRY
		BEGIN TRAN
			Declare @EstaPago bit
			Declare @IdViaje bigint = (Select IdViaje From inserted)

			Select @EstaPago = Pagado
			from Viajes
			Where ID = @IdViaje

			If @EstaPago = 0
			BEGIN
				RAISERROR('Debe pagar el viaje antes de calificarlo', 16,1)
			END
		COMMIT 
	End Try

	BEGIN CATCH
		ROLLBACK
		Declare @ErrorMsg Varchar(4000)
		Set @ErrorMsg = 'Error al agregar calificación: ' + ERROR_MESSAGE()
		RAISERROR(@ErrorMsg, 16, 1)	
	END CATCH
END