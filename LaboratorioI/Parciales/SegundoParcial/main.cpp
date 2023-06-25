// 2DO PARCIAL - LABORATORIO DE COMPUTACION
// ALUMNO: FACUNDO MASINO JOAQUIN
// LEGAJO: 28764
#include "funciones.h"
#include "rlutil.h"
#include <iostream>

using namespace std;

int main(void) {
    bool genXSuc[4][7]{};         // Pto 1
    int idAutorVentas[1000][2]{}; // Pto 2, acumula libros>1200 y recaudacion
    int ventasPrecioXGen[7][2]{}; // Pto 3, acumula ventas y costo

    mostrarCartel();
    cargarDatos(genXSuc, idAutorVentas, ventasPrecioXGen);
    coutCentrado("RESULTADOS", true);
    Punto1(genXSuc);
    divisor(rlutil::BROWN);
    Punto2(idAutorVentas);
    divisor(rlutil::BROWN);
    Punto3(ventasPrecioXGen);
    divisor(rlutil::BROWN);
    Punto4(idAutorVentas);

    cout << endl;
    cout << "Presione una tecla para salir..." << endl;
    rlutil::anykey();
    return 0;
}
