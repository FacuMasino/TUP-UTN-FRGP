#include "Empleado.h"

#include <iostream>

Empleado::Empleado(int cat, float sueldo, int dia, int mes, int anio) {
    Cargar();
    fechaIngreso.setDia(dia);
    fechaIngreso.setMes(mes);
    fechaIngreso.setAnio(anio);
    setCategoria(cat);
    setDia(dia);
    setMes(mes);
}
void Empleado::setCategoria(int cat) { _categoria = cat; }
void Empleado::setSueldo(float s) { _sueldo = s; }
void Empleado::setDia(int d) { fechaIngreso.setDia(d); }
void Empleado::setMes(int m) { fechaIngreso.setMes(m); }
void Empleado::setAnio(int a) { fechaIngreso.setAnio(a); }

float Empleado::getSueldo() { return _sueldo; }
Fecha Empleado::getFecha() { return fechaIngreso; }
int Empleado::getCategoria() { return _categoria; }