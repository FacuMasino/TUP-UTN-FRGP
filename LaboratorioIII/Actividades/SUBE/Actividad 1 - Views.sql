USE SUBE
GO
-- A) Realizar una vista que permita conocer los datos de los usuarios y sus
-- respectivas tarjetas. La misma debe contener: Apellido y nombre del
-- usuario, número de tarjeta SUBE, estado de la tarjeta y saldo.

CREATE OR ALTER VIEW VW_Usuario_Tarjeta
AS
	SELECT
		U.Nombres,
		U.Apellidos,
		T.NroTarjeta,
		CASE 
		WHEN T.Estado = 1 THEN 'Activa'
		ELSE 'Inactiva'
	END AS EstadoTarjeta,
		T.Saldo
	FROM Usuarios U
		INNER JOIN Tarjetas T
		ON U.IdUsuario = T.IdUsuario
GO

-- Test
SELECT *
FROM VW_Usuario_Tarjeta
GO

-- B) Realizar una vista que permita conocer los datos de los usuarios y sus
-- respectivos viajes. La misma debe contener: Apellido y nombre del
-- usuario, número de tarjeta SUBE, fecha del viaje, importe del viaje,
-- número de interno y nombre de la línea.
CREATE OR ALTER VIEW VW_Usuarios_Viajes
AS
	SELECT
		U.Apellidos,
		U.Nombres,
		T.NroTarjeta,
		FORMAT(Mov.FechaHora, 'dd/MM/yy') FechaViaje,
		Mov.Importe,
		Col.NroInterno NInternoColectivo,
		Emp.Nombre Empresa
	FROM Viajes V
		INNER JOIN Movimientos Mov
		ON V.IdMovimiento = Mov.IdMovimiento
		INNER JOIN Tarjetas T
		ON Mov.IdTarjeta = T.IdTarjeta
		INNER JOIN Usuarios U
		ON T.IdUsuario = U.IdUsuario
		INNER JOIN Colectivos Col
		ON V.IdColectivo = Col.IdColectivo
		INNER JOIN Lineas_de_Colectivos LdC
		ON Col.IdLinea = Ldc.IdLinea
		INNER JOIN Empresas Emp
		ON LdC.IdEmpresa = Emp.IdEmpresa 
GO

-- Test
SELECT *
FROM VW_Usuarios_Viajes
GO

-- C) Realizar una vista que permita conocer los datos estadísticos de cada
-- tarjeta. La misma debe contener: Apellido y nombre del usuario, número de
-- tarjeta SUBE, cantidad de viajes realizados, total de dinero acreditado
-- (históricamente), cantidad de recargas, importe de recarga promedio (en
-- pesos), estado de la tarjeta.

CREATE OR ALTER VIEW VW_Estadisticas_Tarjetas
AS
	SELECT
		U.Apellidos,
		U.Nombres,
		T.NroTarjeta,
		COUNT(V.IdViaje) CantViajesRealizados,
		IsNull(SUM (CredMov.Importe),0) TotalDineroAcreditado,
		COUNT (CredMov.IdMovimiento) CantidadRecargas,
		IsNull(AVG (CredMov.Importe),0) RecargaPromedio,
		CASE WHEN T.Estado = '1'
	THEN 'Activa'
	ELSE 'Inactiva'
	END AS EstadoTarjeta
	FROM Usuarios U
		INNER JOIN Tarjetas T
		ON T.IdUsuario = U.IdUsuario
		INNER JOIN Movimientos AllMov -- Todos los movimientos (Para obtener los viajes)
		ON AllMov.IdTarjeta = T.IdTarjeta
		INNER JOIN Viajes V
		ON V.IdMovimiento = AllMov.IdMovimiento
		LEFT JOIN Movimientos CredMov -- Solo los tipo Credito (Para F de Resumen)
		ON CredMov.IdMovimiento IN (
		SELECT IdMovimiento
		FROM Movimientos
		WHERE Tipo = 'C' AND IdTarjeta = T.IdTarjeta
	)
	GROUP BY U.Apellidos, U.Nombres, T.NroTarjeta, T.Estado	
GO

-- Alternativa con Case
CREATE OR ALTER VIEW VW_Estadisticas_Tarjetas
AS
	SELECT
		U.Apellidos,
		U.Nombres,
		T.NroTarjeta,
		COUNT(V.IdViaje) CantViajesRealizados,
		IsNull(SUM (
		CASE WHEN Mov.Tipo = 'C'
		THEN Mov.Importe
		ELSE 0
		END
	),0) TotalDineroAcreditado,
		COUNT (
		CASE WHEN Mov.Tipo = 'C'
		THEN Mov.IdMovimiento
		END
	) CantidadRecargas,
		IsNull(AVG (
		CASE WHEN Mov.Tipo = 'C'
		THEN Mov.Importe
		END
	),0) RecargaPromedio,
		CASE WHEN T.Estado = '1'
	THEN 'Activa'
	ELSE 'Inactiva'
	END AS EstadoTarjeta
	FROM Usuarios U
		INNER JOIN Tarjetas T
		ON T.IdUsuario = U.IdUsuario
		INNER JOIN Movimientos Mov -- Todos los movimientos (Para obtener los viajes)
		ON Mov.IdTarjeta = T.IdTarjeta
		INNER JOIN Viajes V
		ON V.IdMovimiento = Mov.IdMovimiento
	GROUP BY U.Apellidos, U.Nombres, T.NroTarjeta, T.Estado	
GO

-- Test
SELECT *
FROM VW_Estadisticas_Tarjetas
