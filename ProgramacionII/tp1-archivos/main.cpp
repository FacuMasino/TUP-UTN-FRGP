#include <iostream>

#include "Empresas.h"
#include "functions.h"
using namespace std;

int main() {
    int menuOpt = showMenu();
    while (menuOpt != 0) {
        switch (menuOpt) {
            case 1:
                loadRegister();
                break;
            case 2:
                int nReg;
                cout << "Ingrese la cantidad de registros: ";
                cin >> nReg;
                system("cls");
                loadRegister(nReg);
                break;
            case 3:
                showList();
                system("pause");
                break;
            default:
                break;
        }
        menuOpt = showMenu();
    }

    return 0;
}