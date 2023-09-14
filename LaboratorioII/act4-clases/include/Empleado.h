#pragma once
#include <string>

class Empleado {
public:
    Empleado();
    Empleado(int tipo, int legajo, std::string nombre, std::string apellido,
             std::string mail);
    void setTipo(int tipo);
    void setLegajo(int legajo);
    void setNombre(std::string nombre);
    void setApellido(std::string apellido);
    void setMail(std::string mail);

    int getTipo();
    int getLegajo();
    float getSalarioBase();
    std::string getNombre();
    std::string getApellido();
    std::string getMail();

protected:
    int _tipo, _legajo;
    std::string _nombre, _apellido, _mail;
};