#pragma once

#include "Fecha.h"
#include "Funciones.h"

class Persona {
protected:
    char nombre[30], apellido[30], direccion[30];
    char email[30], telefono[30];
    int DNI;
    Fecha fechaNacimiento;

public:
    void Cargar();
    void Mostrar();
    void setDNI(int d) { DNI = d; }

    int getDNI() { return DNI; }
};
