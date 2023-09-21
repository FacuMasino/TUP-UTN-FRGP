#include "functions.h"

#include <iomanip>
#include <iostream>

using namespace std;

// Carga un vector de registros usando memoria dinamica
void loadRegister(int q) {
    int companyN, employeesQty, catN, townN;
    char companyName[30];
    bool state;
    Empresas *pEmpresas = nullptr;
    pEmpresas = new Empresas[q];

    if (pEmpresas != nullptr) {
        for (int i = 0; i < q; i++) {
            companyN = -1;

            while (companyN == -1) {
                cout << "Ingrese el numero de empresa: ";
                cin >> companyN;
                if (numberExists(companyN, pEmpresas, i + 1)) {
                    cout << "Esa empresa ya existe, ingrese otro numero."
                         << endl;
                    companyN = -1;
                    system("pause");
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
            pEmpresas[i].setNumber(companyN);
            pEmpresas[i].setName(companyName);
            pEmpresas[i].setQty(employeesQty);
            pEmpresas[i].setTown(townN);
            pEmpresas[i].setState(state);
        }
    }
    if (addRegister(pEmpresas, q)) {
        cout << "Registros agregados con exito!" << endl;
    } else {
        cout << "Ocurrio un error al agregar los registros" << endl;
    }
}

// Carga un solo registro
void loadRegister() {
    int companyN = -1, employeesQty, catN, townN;
    char companyName[30];
    bool state;
    Empresas reg;

    while (companyN == -1) {
        cout << "Ingrese el numero de empresa: ";
        cin >> companyN;
        if (numberExists(companyN)) {
            cout << "Esa empresa ya existe, ingrese otro numero." << endl;
            companyN = -1;
            system("pause");
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

    reg.setNumber(companyN);
    reg.setName(companyName);
    reg.setQty(employeesQty);
    reg.setTown(townN);
    reg.setState(state);

    if (addRegister(reg)) {
        cout << "Registro agregado!" << endl;
    } else {
        cout << "Ocurrio un error, no se pudo agregar el registro." << endl;
    }
}

void showList() {
    Empresas reg;
    FILE *pFile = fopen("Empresas.dat", "rb");
    if (pFile != NULL) {
        // Encabezado
        cout << left;
        cout << setfill('-') << setw(68) << "" << setfill(' ') << endl;
        cout << setw(4) << "ID";
        cout << setw(30) << "NOMBRE DE EMPRESA";
        cout << setw(10) << "EMPLEADOS";
        cout << setw(10) << "CATEGORIA";
        cout << setw(10) << "MUNICIPIO";
        cout << endl;
        cout << setfill('-') << setw(68) << "" << setfill(' ') << endl;
        // Filas
        while (fread(&reg, sizeof(Empresas), 1, pFile)) {
            cout << left;
            cout << setw(4) << reg.getNumber();
            cout << setw(30) << reg.getName();
            cout << setw(10) << reg.getQty();
            cout << setw(10) << reg.getCategory();
            cout << setw(10) << reg.getTown();
            cout << endl;
        }
    } else {
        cout << "No se pudo leer el archivo Empresas.dat"
             << "O no existe en el directorio." << endl;
    }
    fclose(pFile);
}

bool addRegister(Empresas reg) {
    FILE *pFile;
    pFile = fopen("Empresas.dat", "ab");
    if (pFile == NULL) {
        return false;
    }
    bool success = fwrite(&reg, sizeof(reg), 1, pFile);
    fclose(pFile);
    return success;
}

// sobrecarga de addRegister para recbir un vector y el total
bool addRegister(Empresas reg[], int total) {
    FILE *pFile;
    bool success;
    pFile = fopen("Empresas.dat", "ab");
    if (pFile == NULL) return false;
    for (int i = 0; i < total; i++) {
        success = fwrite(&reg[i], sizeof(Empresas), 1, pFile);
        if (!success) return false;
    }
    fclose(pFile);
    return success;
}

/// @brief Busca si el nro de empresa ya xiste
///
/// Si solo se le pasa n, busca solo en el archivo
/// Si se le pasa el vector y cantidad, busca tambien
/// en el vector de registros
/// @param n numero a buscar
/// @param pReg vector de registros [opcional]
/// @param regQty cantidad de registros en el vector [opcional]
/// @return verdadero si el nro de empresa existe
bool numberExists(int n, Empresas *pReg, int regQty) {
    Empresas reg;
    FILE *pFile = fopen("Empresas.dat", "rb");
    if (pFile == NULL) return false;
    // Buscar en el archivo
    while (fread(&reg, sizeof(Empresas), 1, pFile)) {
        if (reg.getNumber() == n) {
            fclose(pFile);
            return true;
        }
    }
    // Buscar en el vector, si se le paso a la funcion
    if (pReg != nullptr) {
        for (int i = 0; i < regQty; i++) {
            if (pReg[i].getNumber() == n) return true;
        }
    }
    fclose(pFile);
    return false;
}
