#pragma once

class Fecha {
private:
    int dia, mes, anio;

public:
    Fecha(int d = 1, int m = 1, int a = 2000);
    void Cargar();
    void Mostrar();
    void mostrarEnLinea();
    void setDia(int d);
    void setMes(int m);
    void setAnio(int a);
    int getDia();
    int getMes();
    int getAnio();
};
