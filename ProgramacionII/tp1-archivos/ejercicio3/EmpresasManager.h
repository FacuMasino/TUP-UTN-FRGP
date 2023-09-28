#pragma once

#include "EmpresasFile.h"
class EmpresasManager {
public:
    void loadRegister(int qty = 1);
    void showList();
    void showCompanyQtyByTown();
    void showCompanyGreaterThan(int n);
    void showMostEmployedCat();

private:
    void loadString(char *word, int size);
    EmpresasFile _file;
};