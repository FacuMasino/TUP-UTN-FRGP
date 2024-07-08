Create Database ExamenIntegrador_20241C
Go
Use ExamenIntegrador_20241C
Go
Create Table Categorias(
    IDCategoria int not null primary key identity (1, 1),
    Nombre varchar(50) not null,
    SueldoBase money not null
)
Go
Create Table Empleados(
    IDEmpleado bigint not null primary key identity (1, 1),
    IDCategoria int not null foreign key references Categorias(IDCategoria),
    Nombre varchar(50) not null,
    Apellido varchar(50) not null,
    AnioIngreso int not null,
    Sueldo money not null
)
Go
Create Table Adelantos(
    IDAdelanto bigint not null primary key identity (1, 1),
    IDEmpleado bigint not null foreign key references Empleados(IDEmpleado),
    Fecha date not null,
    Monto money not null
)

SET DATEFORMAT 'YMD'

-- Insertar datos
Insert into Categorias values('Administrativo', 1500)
Insert into Categorias values('Operativo', 800)
Insert into Categorias values('Gerente', 3000)
Insert into Categorias values('Jefe', 2000)
Insert into Categorias values('Supervisor', 1800)
Insert into Categorias values('Tecnico', 1200)
Insert into Categorias values('Obrero', 1000)

Insert into Empleados values(1, 'Juan', 'Perez', 2010, 1500)
Insert into Empleados values(2, 'Pedro', 'Gomez', 2015, 800)
Insert into Empleados values(3, 'Maria', 'Lopez', 2012, 3000)
Insert into Empleados values(4, 'Jose', 'Gonzalez', 2013, 2000)
Insert into Empleados values(5, 'Ana', 'Rodriguez', 2014, 1800)
Insert into Empleados values(6, 'Carlos', 'Fernandez', 2016, 1200)
Insert into Empleados values(6, 'Miriam', 'Garcia', 2018, 1200)
Insert into Empleados values(6, 'Pablo', 'Sanchez', 2019, 1300)
Insert into Empleados values(6, 'Sofia', 'Perez', 2020, 1400)
Insert into Empleados values(6, 'Fernando', 'Gomez', 2021, 1500)
Insert into Empleados values(7, 'Laura', 'Martinez', 2017, 1000)
Insert into Empleados values(7, 'Lucia', 'Gonzalez', 2018, 1000)
Insert into Empleados values(7, 'Miguel', 'Rodriguez', 2019, 1000)
Insert into Empleados values(7, 'Ricardo', 'Fernandez', 2020, 1000)

Insert into Adelantos values(1, '2023-01-01', 400)
Insert into Adelantos values(1, '2024-02-01', 200)
Insert into Adelantos values(4, '2023-02-01', 800)
Insert into Adelantos values(3, '2024-02-01', 800)