#include <iostream>
using namespace std;

void cargarCadena(char *palabra, int tamano) {
    int i = 0;
    fflush(stdin);
    for (i = 0; i < tamano; i++) {
        palabra[i] = cin.get();

        if (palabra[i] == '\n') {
            break;
        }
    }
    palabra[i] = '\0';
    fflush(stdin);
}