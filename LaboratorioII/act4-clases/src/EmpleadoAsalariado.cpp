#include "EmpleadoAsalariado.h"

EmpleadoAsalariado::EmpleadoAsalariado() : Empleado() { _salario = 0; }

EmpleadoAsalariado::EmpleadoAsalariado(int tipo, int legajo, std::string nombre,
                                       std::string apellido, std::string mail,
                                       float salario)
    : Empleado(tipo, legajo, nombre, apellido, mail) {
    _salario = salario;
}

float EmpleadoAsalariado::getSalario() { return _salario; }

void EmpleadoAsalariado::setSalario(float salario) { _salario = salario; }