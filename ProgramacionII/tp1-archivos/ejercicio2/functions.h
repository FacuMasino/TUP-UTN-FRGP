#ifndef FUNCTIONS_INCLUDED
#define FUNCTIONS_INCLUDED
#include "Empresas.h"

int showMenu();
void loadRegister(int q);
void loadRegister();
bool addRegister(Empresas reg);
bool addRegister(Empresas reg[], int total);
bool numberExists(int n, Empresas* pReg = nullptr, int regQty = 0);
void showRegisters();
void showList();

#endif /* FUNCTIONS_INCLUDED */
