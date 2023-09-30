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
        cout << " 1 - ALTA EMPRESA" << endl;
        cout << " 2 - BAJA EMPRESA" << endl;
        cout << " 3 - MODIFICAR CATEGORIA EMPRESA" << endl;
        cout << " 4 - LISTAR EMPRESAS" << endl;
        cout << " 0 - Salir" << endl;
        cout << setw(56) << setfill('#') << "" << setfill(' ') << endl;
        cout << "Ingrese una opcion: ";
        cin >> option;
        if (option < 0 || option > 4) {
            cout << "Opcion incorrecta!" << endl;
            system("pause");
            option = -1;
        }
        system("cls");
    }

    return option;
}
