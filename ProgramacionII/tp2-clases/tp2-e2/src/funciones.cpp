#include "funciones.h"

#include <iostream>

using namespace std;

int buscarArticulo(Articulo *vecArt, char *codigo, int totalArt) {
    for (int i = 0; i < totalArt; i++) {
        if (strcmp(vecArt[i].getCodigo(), codigo) == 0) {
            return i;
        }
    }
    return -1;
}
/**
 * @brief Devuelve el articulo con el codigo buscado
 *
 * Devuelve un articulo que coincida con el codigo buscado o
 * devuelve un articulo con stock -1 si no lo encuentra
 *
 * @param vecArt Vector de Articulos
 * @param codigo Codigo a buscar
 * @param totalArt Total del vector articulos
 * @return Articulo encontrado
 */
Articulo devolverArtBuscado(Articulo *vecArt, char *codigo, int totalArt) {
    Articulo notFound;
    notFound.setStock(-1);

    int pos = buscarArticulo(vecArt, codigo, totalArt);
    if (pos >= 0) {
        return vecArt[pos];
    }
    return notFound;
}

void cargarVecArticulos(Articulo *vecArt, int total) {
    for (int i = 0; i < total; i++) {
        cout << "Datos para el Articulo #" << i + 1 << endl;
        vecArt[i].cargar();
        cout << endl;
    }
}

void mostrarVecArticulos(Articulo *vecArt, int total) {
    for (int i = 0; i < total; i++) {
        cout << "Articulo #" << i + 1 << endl;
        vecArt[i].mostrar();
        cout << endl;
    }
}

/**
 * @brief Imprime articulos con precio mayor al param. vMayor.
 *
 * @param vecArt Vector de articulos.
 * @param total Total de articulos en el vector.
 * @param vMayor Precio a comparar.
 */
void mostrarArtValorMayorQue(Articulo *vecArt, int total, float vMayor) {
    cout << "Articulos con precio mayor a $ " << vMayor << endl;
    for (int i = 0; i < total; i++) {
        if (vecArt[i].getPrecio() > vMayor) {
            vecArt[i].mostrar();
            cout << endl;
        }
    }
}

/**
 * @brief Busca articulos con stock menor al parametro stock.
 *
 * @param vecArt Vector de articulos.
 * @param stock limite de stock.
 * @param totalArt Cantidad de articulos del vector.
 * @return total de articulos que cumplen la condicion.
 */
int buscarStock(Articulo *vecArt, int stock, int totalArt) {
    int total = 0;
    for (int i = 0; i < totalArt; i++) {
        if (vecArt[i].getStock() < stock) {
            total++;
        }
    }
    return total;
}
