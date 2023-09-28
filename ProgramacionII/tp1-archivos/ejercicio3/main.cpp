#include <iostream>

#include "Empresas.h"
#include "EmpresasManager.h"
#include "functions.h"
using namespace std;

int main() {
    EmpresasManager Manager;
    int menuOpt = showMenu();
    while (menuOpt != 0) {
        switch (menuOpt) {
            case 1:
                Manager.loadRegister();
                break;
            case 2:
                int nReg;
                cout << "Ingrese la cantidad de registros: ";
                cin >> nReg;
                system("cls");
                Manager.loadRegister(nReg);
                break;
            case 3:
                Manager.showList();
                system("pause");
                break;
            case 4:
                Manager.showCompanyQtyByTown();
                system("pause");
                break;
            case 5:
                Manager.showCompanyGreaterThan(200);
                system("pause");
                break;
            case 6:
                Manager.showMostEmployedCat();
                system("pause");
                break;
            default:
                break;
        }
        menuOpt = showMenu();
    }

    return 0;
}