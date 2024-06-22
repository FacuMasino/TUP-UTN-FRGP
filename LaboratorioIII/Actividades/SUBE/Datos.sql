Use SUBE
GO

INSERT INTO Localidades (Nombre) VALUES
('Palermo'),
('Recoleta'),
('Belgrano'),
('Caballito'),
('Villa Urquiza');

INSERT INTO Usuarios (Nombres, Apellidos, DNI, Domicilio, FechaNacimiento, Estado) VALUES
('Juan', 'Pérez', '12345678', 'Calle Falsa 123, Palermo', '1985-04-12', 1),
('María', 'Gómez', '23456789', 'Avenida Siempre Viva 742, Recoleta', '1990-07-23', 1),
('Carlos', 'López', '34567890', 'Pasaje La Merced 456, Belgrano', '1975-11-15', 1),
('Ana', 'Martínez', '45678901', 'Boulevard San Juan 789, Caballito', '1988-01-30', 1),
('Luis', 'Rodríguez', '56789012', 'Calle Las Rosas 321, Villa Urquiza', '1995-05-05', 1);

INSERT INTO Tarjetas(NroTarjeta, IdUsuario, FechaAlta, Saldo, Estado) VALUES
('1234567812345678', 1, '2024-01-01', 500.00, 1),
('2345678923456789', 2, '2024-01-05', 300.00, 1),
('3456789034567890', 3, '2024-01-10', 1000.00, 1),
('4567890145678901', 4, '2024-01-15', 150.00, 1),
('5678901256789012', 5, '2024-01-20', 800.00, 1);

INSERT INTO Empresas(Nombre, Domicilio, IdLocalidad) VALUES
('Empresa Uno', 'Calle Empresa 123, Palermo', 1),
('Empresa Dos', 'Avenida Empresa 456, Recoleta', 2),
('Empresa Tres', 'Boulevard Empresa 789, Belgrano', 3),
('Empresa Cuatro', 'Pasaje Empresa 101, Caballito', 4),
('Empresa Cinco', 'Callejón Empresa 202, Villa Urquiza', 5);

INSERT INTO Lineas_de_Colectivos (NroLinea, IdEmpresa) VALUES
(1, 1),
(2, 2),
(3, 3),
(4, 4),
(5, 5);

INSERT INTO Colectivos (NroInterno, IdLinea) VALUES
(101, 1),
(102, 2),
(103, 3),
(104, 4),
(105, 5);

-- Recargas
INSERT INTO Movimientos (FechaHora, IdTarjeta, Importe, Tipo) VALUES ('2024-01-01 08:00:00', 1, 200.00, 'C');
INSERT INTO Movimientos (FechaHora, IdTarjeta, Importe, Tipo) VALUES ('2024-01-02 09:00:00', 2, 150.00, 'C');
INSERT INTO Movimientos (FechaHora, IdTarjeta, Importe, Tipo) VALUES ('2024-01-03 10:00:00', 3, 300.00, 'C');
INSERT INTO Movimientos (FechaHora, IdTarjeta, Importe, Tipo) VALUES ('2024-01-04 11:00:00', 4, 100.00, 'C');
INSERT INTO Movimientos (FechaHora, IdTarjeta, Importe, Tipo) VALUES ('2024-01-05 12:00:00', 5, 250.00, 'C');

-- Viajes (Débitos)
INSERT INTO Movimientos (FechaHora, IdTarjeta, Importe, Tipo) VALUES ('2024-01-06 08:00:00', 1, 30.00, 'D');
INSERT INTO Movimientos (FechaHora, IdTarjeta, Importe, Tipo) VALUES ('2024-01-07 09:00:00', 2, 25.00, 'D');
INSERT INTO Movimientos (FechaHora, IdTarjeta, Importe, Tipo) VALUES ('2024-01-08 10:00:00', 3, 35.00, 'D');
INSERT INTO Movimientos (FechaHora, IdTarjeta, Importe, Tipo) VALUES ('2024-01-09 11:00:00', 4, 20.00, 'D');
INSERT INTO Movimientos (FechaHora, IdTarjeta, Importe, Tipo) VALUES ('2024-01-10 12:00:00', 5, 40.00, 'D');

-- Viajes 
INSERT INTO Viajes (IdColectivo, IdMovimiento) VALUES (1, 6);
INSERT INTO Viajes (IdColectivo, IdMovimiento) VALUES (2, 7);
INSERT INTO Viajes (IdColectivo, IdMovimiento) VALUES (3, 8);
INSERT INTO Viajes (IdColectivo, IdMovimiento) VALUES (4, 9);
INSERT INTO Viajes (IdColectivo, IdMovimiento) VALUES (5, 10);
