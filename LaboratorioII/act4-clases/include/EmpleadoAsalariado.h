#pragma once
#include "Empleado.h"

class EmpleadoAsalariado : Empleado {
public:
    EmpleadoAsalariado();
    EmpleadoAsalariado(int tipo, int legajo, std::string nombre,
                       std::string apellido, std::string mail, float salario);
    float getSalario();
    void setSalario(float salario);

private:
    float _salario;
};