#pragma once
#include "Empleado.h"

class EmpleadoHora : Empleado {
public:
    EmpleadoHora();
    EmpleadoHora(int tipo, int legajo, std::string nombre, std::string apellido,
                 std::string mail, float valorHora, float cantHoras);
    float getValorHora();
    float getCantHoras();

    void setValorHora(float valorHora);
    void setCantHoras(float cantHoras);

private:
    float _valorHora, _cantHoras;
};