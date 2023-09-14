#include "EmpleadoHora.h"

EmpleadoHora::EmpleadoHora() : Empleado() {
    _valorHora = 0;
    _cantHoras = 0;
}

EmpleadoHora::EmpleadoHora(int tipo, int legajo, std::string nombre,
                           std::string apellido, std::string mail,
                           float valorHora, float cantHoras)
    : Empleado(tipo, legajo, nombre, apellido, mail) {
    _valorHora = valorHora;
    _cantHoras = cantHoras;
}
