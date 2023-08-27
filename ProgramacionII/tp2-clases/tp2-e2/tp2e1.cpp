#include <cstring>
#include <iostream>

#include "Articulo.h"
#include "funciones.h"

using namespace std;

int main() {
    const int totalArt = 2;  // reemplazar por 10
    Articulo articulos[totalArt];
    float precio;
    char buscarCod[5];

    // Test Punto 2 A B
    cargarVecArticulos(articulos, totalArt);
    mostrarVecArticulos(articulos, totalArt);

    /*     // Test Punto 2 C
        cout << "Ingrese un precio para mostrar los articulos mayores que este:
       $ "; cin >> precio; cout << endl; mostrarArtValorMayorQue(articulos,
       totalArt, precio); */

    // Test Punto 2 D
    /* cout << "Codigo de articulo a buscar: ";
    cin >> buscarCod;
    cout << "Posicion del articulo: "
         << buscarArticulo(articulos, buscarCod, totalArt); */

    // Test Punto 2 E
    cout << "Codigo de articulo a buscar: ";
    cin >> buscarCod;
    cout << "Articulo devuelto:" << endl;
    Articulo artResult;
    artResult = devolverArtBuscado(articulos, buscarCod, totalArt);
    cout << artResult.getCodigo() << endl;
    cout << artResult.getStock() << endl;

    cout << endl;
    system("pause");
    return 0;
}
