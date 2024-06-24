Use ModeloExamen20232C
Go

-- Insert sample data into Vehiculos
INSERT INTO Vehiculos (Patente, AñoPatentamiento, Marca, Modelo)
VALUES 
('ABC123', 2020, 'Toyota', 'Corolla'),
('XYZ789', 2019, 'Honda', 'Civic'),
('DEF456', 2021, 'Ford', 'Focus');

-- Insert sample data into Choferes
INSERT INTO Choferes (Apellidos, Nombres, FechaRegistro, FechaNacimiento, IDVehiculo, Suspendido)
VALUES 
('Gomez', 'Juan', '2023-01-15', '1985-05-20', 1, 0),
('Rodriguez', 'Maria', '2023-02-01', '1990-11-10', 2, 0),
('Martinez', 'Carlos', '2023-03-10', '1988-07-30', 3, 1);

-- Insert sample data into Clientes
INSERT INTO Clientes (Apellidos, Nombres, Telefono, Email, TelefonoVerificado, EmailVerificado)
VALUES 
('Lopez', 'Ana', '1234567890', 'ana@email.com', 1, 1),
('Fernandez', 'Pedro', '9876543210', NULL, 1, 0),
('Garcia', 'Laura', NULL, 'laura@email.com', 0, 1);

-- Insert sample data into FormasPago
INSERT INTO FormasPago (Nombre)
VALUES 
('Efectivo'),
('Tarjeta de crédito'),
('Transferencia bancaria');

-- Insert sample data into Viajes
INSERT INTO Viajes (IDCliente, IDChofer, FormaPago, Inicio, Fin, Kms, Importe, Pagado)
VALUES 
(1, 1, 1, '2023-06-15 10:00:00', '2023-06-15 10:30:00', 10.5, 500.00, 1),
(2, 2, 2, '2023-06-16 14:00:00', '2023-06-16 14:45:00', 15.2, 750.00, 1),
(3, 1, 1, '2023-06-17 09:00:00', '2023-06-17 09:20:00', 8.0, 400.00, 0),
(1, 3, 3, '2023-06-18 18:00:00', '2023-06-18 18:40:00', 20.0, 1000.00, 1);

-- Insert sample data into Puntos
INSERT INTO Puntos (IDCliente, IDViaje, Fecha, PuntosObtenidos, FechaVencimiento)
VALUES 
(1, 1, '2023-06-15 10:30:00', 50, '2024-06-15'),
(2, 2, '2023-06-16 14:45:00', 75, '2024-06-16'),
(1, 4, '2023-06-18 18:40:00', 100, '2024-06-18');

-- Insert sample data into CalificacionesClientes
INSERT INTO CalificacionesACliente (IDViaje, Calificacion, Observacion)
VALUES 
(1, 9, 'Excelente servicio'),
(2, 8, 'Buen viaje'),
(4, 7, 'Chofer amable');

-- Insert sample data into CalificacionesChoferes
INSERT INTO CalificacionesAChofer (IDViaje, Calificacion, Observacion)
VALUES 
(1, 10, 'Cliente muy agradable'),
(2, 9, 'Sin problemas'),
(3, 6, 'Cliente un poco impaciente');