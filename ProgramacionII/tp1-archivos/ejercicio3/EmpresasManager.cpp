#include "EmpresasManager.h"

#include <iomanip>
#include <iostream>

#include "Empresas.h"
using namespace std;

void EmpresasManager::loadRegister(int qty) {
    int companyN, employeesQty, catN, townN;
    char companyName[30];
    bool state, validNumber;

    for (int i = 0; i < qty; i++) {
        Empresas reg;
        validNumber = false;
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
        loadString(companyName, 29);
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
            cout << "Registro agregado con exito!" << endl << endl;
        } else {
            cout << "Ocurrio un error al agregar los registros, la operacion "
                    "se cancelara."
                 << endl;
            i = qty;  // Para evitar que el for continue
        }
    }
}

void EmpresasManager::disableCompany() {
    int companyN;
    cout << "Ingrese el nro de empresa para dar de baja: ";
    cin >> companyN;
    int regPos = _file.searchPosByNumber(companyN);
    Empresas reg = _file.readFile(regPos);
    if (reg.getNumber() == 0 || regPos < 0) {
        cout << "El nro de empresa ingresado no existe o no se pudo obtener el "
                "registro."
             << endl;
        return;
    } else if (!reg.getState()) {
        cout << "El nro de empresa ingresado ya fue dado de baja previamente."
             << endl;
        return;
    }
    reg.setState(false);  // Baja logica

    if (_file.updateFile(reg, regPos)) {
        cout << "Baja efectuada correctamente! " << endl;
    } else {
        cout << "Ocurrio un error, la baja no se pudo realizar." << endl;
    }
}

void EmpresasManager::showList() {
    int totalReg = _file.getTotalRegisters();
    int listCount = 0;
    if (totalReg == 0) {
        cout << "No hay registros para mostrar." << endl;
        return;
    }
    cout << left;
    cout << setfill('-') << setw(68) << "" << setfill(' ') << endl;
    cout << setw(4) << "ID";
    cout << setw(30) << "NOMBRE DE EMPRESA";
    cout << setw(10) << "EMPLEADOS";
    cout << setw(10) << "CATEGORIA";
    cout << setw(10) << "MUNICIPIO";
    cout << setw(10) << "ESTADO";
    cout << endl;
    cout << setfill('-') << setw(68) << "" << setfill(' ') << endl;

    for (int i = 0; i < totalReg; i++) {
        Empresas reg = _file.readFile(i);

        cout << left;
        if (reg.getNumber() == 0) {
            cout << "No se pudo leer el registro # " << i + 1 << endl;
        } else if (reg.getState()) {
            cout << setw(4) << reg.getNumber();
            cout << setw(30) << reg.getName();
            cout << setw(10) << reg.getQty();
            cout << setw(10) << reg.getCategory();
            cout << setw(10) << reg.getTown();
            cout << setw(10) << reg.getState();
            cout << endl;
            listCount++;
        }
    }

    if (listCount == 0) cout << "\nNo hay empresas activas para mostrar.\n";
}

void EmpresasManager::loadString(char *word, int size) {
    int i = 0;
    fflush(stdin);
    for (i = 0; i < size; i++) {
        word[i] = cin.get();
        if (word[i] == '\n') {
            break;
        }
    }
    word[i] = '\0';
    fflush(stdin);
}

void EmpresasManager::showCompanyQtyByTown() {
    int towns[135]{};
    int totalReg = _file.getTotalRegisters();
    for (int i = 0; i < totalReg; i++) {
        towns[_file.readFile(i).getTown() - 1]++;
    }
    for (int i = 0; i < 135; i++) {
        if (towns[i] > 0) {
            cout << "Municipio #" << i + 1 << ": " << towns[i] << " empresas."
                 << endl;
        }
    }
}

void EmpresasManager::showCompanyGreaterThan(int n) {
    int totalReg = _file.getTotalRegisters();
    int total = 0;
    cout << "Empresas con mas de " << n << " empleados:" << endl;
    for (int i = 0; i < totalReg; i++) {
        if (_file.readFile(i).getQty() > n) {
            total++;
            cout << "- " << _file.readFile(i).getName() << endl;
        }
    }
    if (total == 0) cout << "No hay." << endl;
}

void EmpresasManager::showMostEmployedCat() {
    int max = 0, mostEmployed;
    int totalReg = _file.getTotalRegisters();
    cout << "La categoria con mas cantidad de empleados es la #";
    for (int i = 0; i < totalReg; i++) {
        if (_file.readFile(i).getQty() > max) {
            max = _file.readFile(i).getQty();
            mostEmployed = _file.readFile(i).getCategory();
        }
    }
    cout << mostEmployed << endl;
}
