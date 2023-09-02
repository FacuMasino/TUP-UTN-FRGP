#pragma once
#include "Persona.h"

class Empleado : public Persona {
private:
    // propiedades
    int _categoria;
    float _sueldo;
    Fecha fechaIngreso;

public:
    // metodos

    Empleado(int cat = 1, float sueldo = 1000, int dia = 1, int mes = 1,
             int anio = 2010);

    void setCategoria(int cat);
    void setSueldo(float s);
    void setDia(int d);
    void setMes(int m);
    void setAnio(int a);

    float getSueldo();
    Fecha getFecha();
    int getCategoria();
};
