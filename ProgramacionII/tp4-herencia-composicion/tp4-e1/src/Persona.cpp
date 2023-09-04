
#include "Persona.h"

#include <iostream>

void Persona::Cargar() {
    std::cout << "NOMBRE: ";
    cargarCadena(nombre, 29);
    std::cout << "APELLIDO: ";
    cargarCadena(apellido, 29);
    std::cout << "DIRECCION: ";
    cargarCadena(direccion, 29);
    std::cout << "EMAIL: ";
    cargarCadena(email, 29);
    std::cout << "TELEFONO: ";
    cargarCadena(telefono, 29);
    std::cout << "DNI: ";
    std::cin >> DNI;
    std::cout << "FECHA DE NACIMIENTO " << std::endl;
    fechaNacimiento.Cargar();
}

void Persona::Mostrar() {
    std::cout << nombre << std::endl;
    std::cout << "APELLIDO: ";
    std::cout << apellido << std::endl;
    std::cout << "DIRECCION: ";
    std::cout << "NOMBRE: ";
    std::cout << direccion << std::endl;
    std::cout << "EMAIL: ";
    std::cout << email << std::endl;
    std::cout << "TELEFONO: ";
    std::cout << telefono << std::endl;
    std::cout << "DNI: ";
    std::cout << DNI << std::endl;
    std::cout << "FECHA DE NACIMIENTO " << std::endl;
    fechaNacimiento.Mostrar();
}