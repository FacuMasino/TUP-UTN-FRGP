#include <iostream>

#include "Empleado.h"
#include "Fecha.h"

using namespace std;

int main() {
    // Prueba punto a)
    Empleado empDefault, empCustom(5, 550.5, Fecha(2, 3, 2005));

    cout << "Obj. Empleado por omision" << endl;
    cout << empDefault.getCategoria() << endl;  // Deberia ser 1
    cout << empDefault.getSueldo() << endl;     // Deberia ser 1000
    empDefault.getFecha().mostrarEnLinea();     // Deberia ser 1,1,2010

    cout << "Obj. Empleado usando constructor" << endl;
    cout << empCustom.getCategoria() << endl;  // Deberia ser 5
    cout << empCustom.getSueldo() << endl;     // Deberia ser 550.5
    empCustom.getFecha().mostrarEnLinea();     // Deberia ser 02,03,2005

    system("pause");
    return 0;
}