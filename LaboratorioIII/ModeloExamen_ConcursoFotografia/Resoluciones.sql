Use ModExamenIntegrador20241C
Go

-- 1
Create or Alter Procedure SP_Descalificar (
	@IdFotografía bigint
)
AS
BEGIN
	Begin TRY
		BEGIN TRAN
			Declare @ConcursoFinalizado BIT
			Declare @IdConcurso bigint

			Select @IdConcurso = IDConcurso
			From Fotografias
			Where ID = @IdFotografía

			If @IdConcurso Is Null
			BEGIN
				RAISERROR('La fotografía no existe', 16,1)
			END

			Select @ConcursoFinalizado =
				CASE WHEN getdate() >= Fin
				THEN '1'
				ELSE '0'
				END
			FROM Concursos
			Where ID = @IdConcurso

			if @ConcursoFinalizado = 1 
			BEGIN
				RAISERROR('No es posible descalificar una fotografía de un concurso finalizado', 16,1)
			END

			Update Fotografias
				Set Descalificada = 1
			Where ID = @IdFotografía

			Delete from Votaciones
			Where IDFotografia = @IdFotografía

		COMMIT
	END TRY
		
	BEGIN CATCH
		ROLLBACK
		Declare @ErrorMsg Varchar(4000)
		Set @ErrorMsg = 'Error al descalificar fotografía: ' + ERROR_MESSAGE()
		RAISERROR(@ErrorMsg, 16, 1)
	END CATCH
END
GO

-- 2
Create or Alter TRIGGER TR_Nueva_Fotografia
on Fotografias Instead of INSERT
AS
BEGIN
	Begin TRY
		BEGIN TRAN
			Declare @IdParticipante bigint
			Declare @IdConcurso bigint
			Declare @Titulo varchar(150)
			
			Declare @RankTotal decimal (5,2)
			Declare @RankRequerido decimal (5,2)
			Declare @ConcursoFinalizado bit
			Declare @ConcursoIniciado bit

			Select @IdParticipante = (Select IdParticipante from Inserted)
			Select @IdConcurso = (Select IdConcurso from inserted)
			Select @Titulo = (Select Titulo from inserted)

			Select @RankTotal = AVG(Vot.Puntaje)
			From Votaciones Vot
				Inner Join Fotografias F
				on Vot.IDFotografia = F.ID
			Where F.IDParticipante = @IdParticipante

			Select @ConcursoFinalizado =
				CASE WHEN GETDATE() >= Fin
				THEN '1'
				ELSE '0'
				END,
				@ConcursoIniciado = 
				CASE WHEN GETDATE() >= Inicio
				THEN '1'
				ELSE '0'
				END
			from Concursos
			Where ID = @IdConcurso

			Select @RankRequerido = RankingMinimo
			from Concursos
			Where ID = @IdConcurso

			if @ConcursoFinalizado = 1
			BEGIN
				RAISERROR('El concurso ya finalizó', 16,1)
			END

			if @ConcursoIniciado = 0
			BEGIN
				RAISERROR('El concurso aun no inició', 16,1)	
			END

			if @RankTotal < @RankRequerido
			BEGIN
				RAISERROR('El participante no tiene ranking suficiente', 16,1)
			END

			INSERT into Fotografias (IDParticipante, IDConcurso, Titulo, Descalificada, Publicacion)
			Values (
				@IdParticipante,
				@IdConcurso,
				@Titulo,
				0,
				GETDATE()
			)

		COMMIT 
	End Try

	BEGIN CATCH
		ROLLBACK
		Declare @ErrorMsg Varchar(4000)
		Set @ErrorMsg = 'Error al insertar fotografía: ' + ERROR_MESSAGE()
		RAISERROR(@ErrorMsg, 16, 1)
	END CATCH
END
GO

-- 3
Create or Alter TRIGGER TR_Nueva_Votacion
on Votaciones after INSERT
AS
BEGIN
	Begin TRY
		BEGIN TRAN
			Declare @IdVotante bigint
			Declare @IdFotografia bigint
			Declare @IdParticipante bigint

			Declare @IdConcurso bigint
			Declare @EstaDescalificada bit
			Declare @Votaciones int -- Guarda cuantas veces votó

			SET @IdVotante = (Select IdVotante from inserted)
			SET @IdFotografia = (Select IdFotografia from inserted)

			Select  @IdConcurso = IdConcurso,
					@IdParticipante = IDParticipante,
					@EstaDescalificada = Descalificada
			from Fotografias
			Where ID = @IdFotografia

			Select @Votaciones = Count(V.IdVotante)
			from Votaciones V
				inner join Fotografias F
				on V.IDFotografia = F.ID
			Where F.IDConcurso = @IdConcurso 
				And V.IDVotante = @IdVotante
				And V.ID <> @@IDENTITY -- Que no cuente esta votación

			If @IdVotante = @IdParticipante
			BEGIN
				RAISERROR('No puede votarse a si mismo', 16, 1)
			END

			If @Votaciones >= 1
			BEGIN
				RAISERROR('Solo puede votar 1 vez por concurso', 16, 1)
			END

			if @EstaDescalificada = 1
			BEGIN
				RAISERROR('No puede votar una fotografía descalificada', 16,1)
			END

		COMMIT 
	End Try

	BEGIN CATCH
		ROLLBACK
		Declare @ErrorMsg Varchar(4000)
		Set @ErrorMsg = 'Error al realizar votación: ' + ERROR_MESSAGE()
		RAISERROR(@ErrorMsg, 16, 1)
	END CATCH
END
GO

-- 4
Select F.IdParticipante, 
		P.Apellidos, 
		P.Nombres, 
		Count(F.ID) TotalDescalificadas
from Fotografias F
	inner join Participantes P
	on F.IDParticipante = P.ID
Where F.Descalificada = 1
group by IDParticipante, Apellidos, Nombres
HAVING Count(F.ID) >= 2
GO


-- 5
Create Table CategoriaDenuncia (
	IdCategoria tinyint NOT NULL IDENTITY(1,1) PRIMARY KEY,
	Nombre varchar(80) NOT NULL
)
GO

Create Table Denuncias (
	IdDenuncia bigint NOT NULL IDENTITY(1,1) PRIMARY KEY,
	IdDenunciante bigint NOT NULL FOREIGN KEY REFERENCES Participantes(ID),
	IdFotografia bigint NOT NULL FOREIGN KEY REFERENCES Fotografias(ID),
	IdCategoria tinyint NOT NULL FOREIGN KEY REFERENCES CategoriaDenuncia(IdCategoria),
	FechaHora datetime Not Null,
	Comentario varchar(300) NOT NULL,
	CONSTRAINT UQ_Usuario_Fotografia UNIQUE (IdDenunciante, IdFotografia)
)
GO

-- Tests
Insert into Fotografias (IDParticipante, IDConcurso, Titulo, Descalificada, Publicacion)
Values (7,2,N'TEST',0,'2024-06-05')

Insert into Votaciones (IdVotante, IDFotografia, Fecha, Puntaje)
Values (2,16, getdate(), 10)

Insert into Votaciones (IdVotante, IDFotografia, Fecha, Puntaje)
Values (1,16, getdate(), 6)

Select * from Votaciones
Select * from Fotografias

Exec SP_Descalificar 16
Go

Insert into CategoriaDenuncia (Nombre)
Values
	('Suplantacion de Identidad'),
	('Contenido Inapropiado'),
	('Infringimiento de derechos de autor')

Insert into Denuncias(IdDenunciante, IdFotografia, IdCategoria,FechaHora, Comentario)
Values
	(1,7,2,getdate(),'Comentario de prueba'),
	(2,7,2,getdate(),'Comentario de prueba 2'),
	(7,1,3,getdate(), 'Comentario de prueba 3')

-- Prueba restricción un usuario solo puede denunciar 1 fotografia 1 vez
Insert into Denuncias(IdDenunciante, IdFotografia, IdCategoria, Comentario)
Values
	(1,7,2,getdate(), 'Comentario de prueba')

Select * from Denuncias