#include "EmpresasFile.h"

EmpresasFile::EmpresasFile() { strcpy(_fileName, "Empresas.dat"); }

EmpresasFile::EmpresasFile(char *fileName) { strcpy(_fileName, fileName); }

Empresas EmpresasFile::readFile(int regNumber) {
    Empresas reg;
    FILE *pFile;
    pFile = fopen(_fileName, "rb");
    if (pFile == NULL) return reg;
    // SEEK_SET = 0, posicionar pFile desde el inicio
    fseek(pFile, sizeof(Empresas) * regNumber, SEEK_SET);
    fread(&reg, sizeof(Empresas), 1, pFile);
    return reg;
}

bool EmpresasFile::readFile(Empresas reg[], int total) {
    FILE *pFile;
    pFile = fopen(_fileName, "rb");
    if (pFile == NULL) return false;
    int totalRead = fread(reg, sizeof(Empresas), total, pFile);
    return (totalRead == total ? true : false);
}

int EmpresasFile::getTotalRegisters() {
    FILE *pFile;
    pFile = fopen(_fileName, "rb");
    if (pFile == NULL) return 0;
    fseek(pFile, 0, SEEK_END);      // Posicionar el puntero al final
    int totalBytes = ftell(pFile);  // Guardar posicion actual
    fclose(pFile);
    // 1 posicion = 1 byte
    // calcular cantidad de registros
    return totalBytes / sizeof(Empresas);
}

bool EmpresasFile::writeFile(Empresas reg) {
    FILE *pFile;
    pFile = fopen(_fileName, "ab");
    if (pFile == NULL) return false;
    bool success = fwrite(&reg, sizeof(Empresas), 1, pFile);
    fclose(pFile);
    return success;
}

bool EmpresasFile::writeFile(Empresas reg[], int total) {
    FILE *pFile;
    pFile = fopen(_fileName, "ab");
    if (pFile == NULL) return false;
    bool totalWritten = fwrite(&reg, sizeof(Empresas), total, pFile);
    fclose(pFile);
    return totalWritten == total ? true : false;
}

bool EmpresasFile::searchNumber(int n) {
    int totalReg = getTotalRegisters();
    if (totalReg == 0) return false;
    for (int i = 0; i < totalReg; i++) {
        if (readFile(i).getNumber() == n) return true;
    }
    return false;
}