#pragma once

#include "EmpresasFile.h"
class EmpresasManager {
public:
    EmpresasManager();
    void loadRegister(int qty = 0);

private:
    EmpresasFile _file;
};