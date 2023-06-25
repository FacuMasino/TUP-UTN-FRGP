#include <iostream>
using namespace std;

int main(void) {
    const int vTam = 10; // Cambiar a 100
    float nCarga, pos[vTam]{}, nega[vTam]{};
    int ultIndicePos = 0, ultIndiceNeg = 0;

    cout << "Cargar " << vTam << " nros:";

    for(int i = 0; i < vTam; i++) {
        cin >> nCarga;
        if(nCarga > 0) {
            pos[ultIndicePos] = nCarga;
            ultIndicePos++;
        } else {
            nega[ultIndiceNeg] = nCarga;
            ultIndiceNeg++;
        }
    }

    cout << endl;
    cout << "Cantidad de elementos vector positivos: " << ultIndicePos << endl;
    cout << "Cantidad de elementos vector negativos: " << ultIndiceNeg << endl;

    cout << "Elementos del vector positivos: ";
    for (int i = 0; i < ultIndicePos; i++) {
        cout << pos[i] << " ";
    }
    cout << endl;

    cout << "Elementos del vector negativos: ";
    for (int i = 0; i < ultIndiceNeg; i++) {
        cout << nega[i] << " ";
    }
    cout << endl;

    system("pause");
    return 0;

}
