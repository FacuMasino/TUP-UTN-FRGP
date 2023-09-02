
#include "Persona.h"

#include <iostream>

/* Persona::Persona(char nom[29] = "pablito", char apell[29] = "lezcano",
                 char dir[29] = "Obelisco",
                 char correo[29] = "no@no.com" char tel[29] = "01100000",
                 int doc = 1000000, int diaNac = 10, int mesNac = 10,
                 int anioNac = 2010) {
    strcpy(nombre, nom);
    strcpy(apellido, apell);
    strcpy(direccion, dir);
    strcpy(email, correo);
    strcpy(telefono, tel);
    DNI = doc;
    fechaNacimiento.setDia(diaNac);
    fechaNacimiento.setMes(mesNac);
    fechaNacimiento.setAnio(anioNac)
} */

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