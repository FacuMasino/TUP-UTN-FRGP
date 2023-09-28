#include "functions.h"

#include <iomanip>
#include <iostream>

using namespace std;

int showMenu() {
    int option = -1;
    while (option == -1) {
        system("cls");
        cout << setw(25) << setfill('#') << "" << setfill(' ');
        cout << " MENU ";
        cout << setw(25) << setfill('#') << "" << setfill(' ') << endl;
        cout << " 1 - Cargar 1 registro" << endl;
        cout << " 2 - Cargar X registros" << endl;
        cout << " 3 - Mostrar registros" << endl;
        cout << " 4 - Cantidad de empresas x municipio" << endl;
        cout << " 5 - Mostrar empresas con mas de 200 empleados" << endl;
        cout << " 6 - Mostrar la categoria con mas empleados" << endl;
        cout << " 0 - Salir" << endl;
        cout << setw(56) << setfill('#') << "" << setfill(' ') << endl;
        cout << "Ingrese una opcion: ";
        cin >> option;
        if (option < 0 || option > 6) {
            cout << "Opcion incorrecta!" << endl;
            system("pause");
            option = -1;
        }
        system("cls");
    }

    return option;
}
