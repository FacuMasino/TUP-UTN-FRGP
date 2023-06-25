#include <iostream>
#include "utilidades.h"
using namespace std;

int main(void)
{
    int numero, vNums[10] {}, maxN, posMaxN;

    cout << "Ingrese 10 numeros: ";

    for(int i = 0; i < 10; i++) {
        cin >> vNums[i];
    }

    system("cls");

    // Buscar el max
    for(int i = 0; i < 10; i++ ) {
        if(i == 0 || vNums[i] > maxN) {
            maxN = vNums[i];
            posMaxN = i;
        }
    }

    cout << "Vector ingresado: ";
    for(int i = 0; i < 10; i++ ) {
        if(vNums[i] == maxN) {
            resaltar(true, RED, WHITE);
            cout << vNums[i];
            resaltar(false);
            cout << " ";
        } else {
            cout << vNums[i] << " ";
        }
    }

    // Correr 1 luagar hacia la izq todos los elementos
    // Se pierde el elemento máximo porque se sobreescribe
    for(int i = posMaxN; i < 9; i++) {
        vNums[i] = vNums[i+1];
    }

    cout << "\n\nVector modificado: ";
    for(int i = 0; i < 9; i++ ) {
        cout << vNums[i] << " ";
    }

    cout << endl;
    system("pause");
    return 0;
}
