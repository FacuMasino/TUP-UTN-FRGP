#include "Empleado.h"

Empleado::Empleado() {
    _tipo = 1;
    _legajo = 0;
    _nombre = "";
    _apellido = "";
    _mail = "";
}

Empleado::Empleado(int tipo, int legajo, std::string nombre,
                   std::string apellido, std::string mail) {
    _tipo = tipo;
    _legajo = legajo;
    _nombre = nombre;
    _apellido = apellido;
    _mail = mail;
}

int Empleado::getTipo() { return _tipo; }
int Empleado::getLegajo() { return _legajo; }
std::string Empleado::getNombre() { return _nombre; }
std::string Empleado::getApellido() { return _apellido; }

void Empleado::setTipo(int tipo) { _tipo = tipo; }
void Empleado::setLegajo(int legajo) { _legajo = legajo; }
void Empleado::setNombre(std::string nombre) { _nombre = nombre; }
void Empleado::setApellido(std::string apellido) { _apellido = apellido; }
void Empleado::setMail(std::string mail) { _mail = mail; }