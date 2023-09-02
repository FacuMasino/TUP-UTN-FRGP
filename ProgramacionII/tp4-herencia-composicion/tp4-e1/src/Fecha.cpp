#include "Fecha.h"

#include <iostream>

Fecha::Fecha(int d, int m, int a) {
    setDia(d);
    setMes(m);
    setAnio(a);
}

void Fecha::Cargar() {
    std::cout << "DIA: ";
    std::cin >> dia;
    std::cout << "MES: ";
    std::cin >> mes;
    std::cout << "ANIO: ";
    std::cin >> anio;
}
void Fecha::Mostrar() {
    std::cout << "DIA: " << dia << std::endl;
    std::cout << "MES: " << mes << std::endl;
    std::cout << "ANIO: " << anio << std::endl;
}
void Fecha::mostrarEnLinea() {
    std::cout << dia << "/" << mes << "/" << anio << std::endl;
}

void Fecha::setDia(int d) {
    if (d >= 1 && d <= 31)
        dia = d;
    else
        dia = -1;
}

void Fecha::setMes(int m) {
    if (m > 0 && m <= 12) {
        mes = m;
    } else {
        mes = -1;
    }
}

void Fecha::setAnio(int a) {
    if (a >= 1900)
        anio = a;
    else
        anio = -1;
}

int Fecha::getDia() { return dia; }
int Fecha::getMes() { return mes; }
int Fecha::getAnio() { return anio; }