#include "EmpresasManager.h"

#include <iostream>
using namespace std;

void EmpresasManager::loadRegister(int qty) {
    int companyN, employeesQty, catN, townN;
    char companyName[30];
    bool state, validNumber = false;

    for (int i = 0; i < qty; i++) {
        Empresas reg;

        while (!validNumber) {
            cout << "Ingrese el numero de empresa: ";
            cin >> companyN;
            if (_file.searchNumber(companyN)) {
                cout << "Esa empresa ya existe, ingrese otro numero." << endl;
                validNumber = false;
                system("pause");
            } else {
                validNumber = true;
            }
        }

        cout << "Ingrese el nombre: ";
        cin >> companyName;
        cout << "Ingrese la cantidad de empleados: ";
        cin >> employeesQty;
        cout << "Ingrese la categoria[1-80]: ";
        cin >> catN;
        cout << "Ingrese el nro de municipio[1-135]: ";
        cin >> townN;
        cout << "Estado [1-Activo, 0-Inactivo]: ";
        cin >> state;
        cout << endl;

        reg.loadData(companyN, companyName, employeesQty, catN, townN, state);

        if (_file.writeFile(reg)) {
            cout << "Registro agregado con exito!" << endl;
        } else {
            cout << "Ocurrio un error al agregar los registros, la operacion "
                    "se cancelara."
                 << endl;
            i = qty;  // Para evitar que el for continue
        }
    }
}
