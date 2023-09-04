#include "Empleado.h"

#include <iostream>

Empleado::Empleado(int cat, float sueldo, Fecha fIngreso) {
    Persona::Cargar();
    _fechaIngreso = fIngreso;
    setCategoria(cat);
    setSueldo(sueldo);
}
void Empleado::setCategoria(int cat) {
    if (cat > 0 && cat <= 5) {
        _categoria = cat;
    } else {
        _categoria = -1;
    }
}
void Empleado::setSueldo(float sueldo) { _sueldo = sueldo; }
void Empleado::setMes(int m) { _fechaIngreso.setMes(m); }
void Empleado::setDia(int d) { _fechaIngreso.setDia(d); }
void Empleado::setAnio(int a) { _fechaIngreso.setAnio(a); }

float Empleado::getSueldo() { return _sueldo; }
Fecha Empleado::getFecha() { return _fechaIngreso; }
int Empleado::getCategoria() { return _categoria; }