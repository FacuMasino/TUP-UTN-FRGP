#pragma once
#include "Persona.h"

class Empleado : public Persona {
private:
    // propiedades
    int _categoria;
    float _sueldo;
    Fecha _fechaIngreso;

public:
    // metodos

    Empleado(int cat = 1, float sueldo = 1000,
             Fecha _fIngreso = Fecha(1, 1, 2010));

    void setCategoria(int cat);
    void setSueldo(float sueldo);
    void setDia(int d);
    void setMes(int m);
    void setAnio(int a);

    float getSueldo();
    Fecha getFecha();
    int getCategoria();
};
