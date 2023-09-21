#include "Empresas.h"

#include <cstring>
#include <iostream>

Empresas::Empresas(int number, const char *name, int employesQty, int nCat,
                   int nTown, bool state) {
    _number = number;
    std::strcpy(_name, name);
    _qty = employesQty;
    _category = nCat;
    _townNumber = nTown;
    _state = state;
}

void Empresas::setNumber(int n) { _number = n; }
void Empresas::setName(char *n) { strcpy(n, _name); }
void Empresas::setQty(int n) { _qty = n; }
void Empresas::setCategory(int n) { _category = n; }
void Empresas::setTown(int n) { _townNumber = n; }
void Empresas::setState(bool state) { _state = state; }

int Empresas::getNumber() { return _number; }
const char *Empresas::getName() { return _name; }
int Empresas::getQty() { return _qty; }
int Empresas::getCategory() { return _category; }
int Empresas::getTown() { return _townNumber; }
bool Empresas::getState() { return _state; }
