#include <iostream>
#include "utilidades.h"
using namespace std;

int main(void)
{
    int nVenta;
    float impVenta, vDias[31] {}, maxRec = 0.00;
    int nDia, diaMaxRec;

    cout << "Nro. de venta:";
    cin >> nVenta;

    while (nVenta != 0) {
        cout << "Importe de venta: ";
        cin >> impVenta;
        cout << "Nro. de dia: ";
        cin >> nDia;

        vDias[nDia - 1] += impVenta;

        cout << "Nro. de venta: ";
        cin >> nVenta;
    }

    cls();
    maxRec = vDias[0];

    //resaltar(true, YELLOW);
    coutCentrado("RECAUDACION X DIA   ", true);
    coutCentrado("Hola soy otra linea centrada", true);
    //resaltar(false);

    for (int i = 0; i<31; i++) {
        if (vDias[i] > maxRec) {
            maxRec = vDias[i];
            diaMaxRec = i + 1;
        }
        if(vDias[i] != 0) {
            cout << "\n \t - Dia #" << i+1 << " $ " << vDias[i];
        }
    }

    divisor(YELLOW);
    //resaltar(true);
    coutCentrado("Dia con mayor recaudacion: Dia #" + to_string(diaMaxRec) + " con $ " + to_string(maxRec),true);
    //resaltar(false);
    cout << endl;
    anykey();
    return 0;
}
