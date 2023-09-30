#pragma once

#include "Empresas.h"

class EmpresasFile {
public:
    EmpresasFile();
    EmpresasFile(char* fileName);
    Empresas readFile(int regNumber);
    bool readFile(Empresas reg[], int total);
    int getTotalRegisters();
    bool writeFile(Empresas reg);
    bool writeFile(Empresas reg[], int total);
    bool updateFile(Empresas reg, int pos);
    bool searchNumber(int n);
    int searchPosByNumber(int n);

private:
    char _fileName[30];
};