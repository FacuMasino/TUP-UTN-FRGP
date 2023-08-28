#include <cstring>
#include <iomanip>
#include <iostream>

#include "Articulo.h"
#include "funciones.h"

using namespace std;

int menu(int);

int main() {
    const int totalArt = 2;  // reemplazar por 10
    Articulo articulos[totalArt];
    float precio, porcentaje;
    char buscarCod[5];
    int menuOpc = -1, stock;

    while (menuOpc != 0) {
        system("cls");
        menuOpc = menu(totalArt);

        switch (menuOpc) {
            case 1:
                cargarVecArticulos(articulos, totalArt);
                break;
            case 2:
                mostrarVecArticulos(articulos, totalArt);
                system("pause");
                break;
            case 3:
                precio = pedirPrecio();
                mostrarArtValorMayorQue(articulos, totalArt, precio);
                system("pause");
                break;
            case 4:
                pedirCodigo(buscarCod);
                cout << "Posicion: "
                     << buscarArticulo(articulos, buscarCod, totalArt) << endl;
                system("pause");
                break;
            case 5:
                pedirCodigo(buscarCod);
                devolverArtBuscado(articulos, buscarCod, totalArt).mostrar();
                system("pause");
                break;
            case 6:
                stock = pedirStock();
                cout << "Total de articulos: "
                     << buscarStock(articulos, stock, totalArt) << endl;
                system("pause");
                break;
            case 7:
                porcentaje = pedirPorcentaje();
                aumentarArticulos(articulos, totalArt, porcentaje);
                cout << "Precio modificado." << endl;
                system("pause");
                break;
            default:
                break;
        }
    }

    return 0;
}

int menu(int totalArt) {
    int tCol = 55, opc = -1;

    while (opc == -1) {
        cout << char(201) << setw(tCol) << setfill(char(205)) << char(187)
             << endl;
        cout << setfill(' ') << char(186);
        coutCentrado("MENU", tCol - 1);
        cout << char(186) << endl;
        cout << char(200) << setw(tCol) << setfill(char(205)) << char(188)
             << endl;
        cout << " [1] Cargar " << totalArt << " articulos." << endl;
        cout << " [2] Mostrar los articulos. " << endl;
        cout << " [3] Mostrar articulos mayores a un precio X." << endl;
        cout << " [4] Ingresar codigo y obtener la posicion." << endl;
        cout << " [5] Ingresar codigo y mostrar el articulo." << endl;
        cout << " [6] Mostrar cantidad de articulos con stock menor a X."
             << endl;
        cout << " [7] Aumentar el precio en un porcentaje ingresado" << endl;
        cout << " [0] Salir." << endl;
        cout << endl << "Ingrese la opcion: ";
        cin >> opc;

        if (opc < 0 || opc > 8) {
            cout << "Opcion incorrecta.\n\n";
            opc = -1;
            system("pause");
            system("cls");
        }
    }

    system("cls");
    return opc;
}