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
                Manager.disableCompany();
                system("pause");
                break;
            case 3:
                system("pause");
                break;
            case 4:
                Manager.showList();
                system("pause");
                break;
            default:
                break;
        }
        menuOpt = showMenu();
    }

    return 0;
}