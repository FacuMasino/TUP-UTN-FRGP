/*
Empresas.dat
Número de empresa (Número entero. No se repite en el archivo. Es único para cada
empresa) Nombre (char[30]) Cantidad de empleados Categoría (1 a 80) Número de
municipio al que pertenece (1 a 135) Estado (bool)
*/

#ifndef EMPRESAS_INCLUDED
#define EMPRESAS_INCLUDED

class Empresas {
public:
    Empresas(int number = 1, const char *name = "Test", int employesQty = 10,
             int nCat = 1, int nTown = 1, bool state = true);

    void setNumber(int n);
    void setName(char *n);
    void setQty(int n);
    void setCategory(int n);
    void setTown(int n);
    void setState(bool state);

    int getNumber();
    const char *getName();
    int getQty();
    int getCategory();
    int getTown();
    bool getState();

private:
    int _number;
    char _name[30];
    int _qty;
    int _category;
    int _townNumber;
    int _state;
};

#endif /* EMPRESAS_INCLUDED */
