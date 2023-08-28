#include "funciones.h"

#include <iomanip>
#include <iostream>

using namespace std;

/**
 * @brief Devuelve la posicion en el vector del articulo buscado
 *
 * @param vecArt Vector de articulos
 * @param codigo codigo a buscar
 * @param totalArt Total de articulos en el vector
 * @return int posicion devuelta, -1 = no encontrado
 */
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
    int count = 0;
    cout << "Articulos con precio mayor a $ " << vMayor << endl;
    for (int i = 0; i < total; i++) {
        if (vecArt[i].getPrecio() > vMayor) {
            vecArt[i].mostrar();
            count++;
            cout << endl;
        }
    }
    if (count == 0) {
        cout << "No se encontraron articulos con precio mayor a $ " << vMayor
             << endl;
    }
}

float pedirPrecio() {
    float p;
    cout << "Ingrese el precio: ";
    cin >> p;
    return p;
}

void pedirCodigo(char *charDestino) {
    char cod[5];
    cout << "Ingrese el codigo: ";
    cin >> cod;
    strcpy(charDestino, cod);
}

float pedirPorcentaje() {
    float p;
    cout << "Ingrese el porcentaje a aumentar (Ej. 22.50): ";
    cin >> p;
    return p;
}

int pedirStock() {
    int s;
    cout << "Ingrese la cantidad de stock: ";
    cin >> s;
    return s;
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

/**
 * @brief Incrementa el precio de los articulos
 *
 * @param vecArt Vector de articulos.
 * @param totalArt Total articulos.
 * @param porc Porcentje a aumentar. Ej. 22.5
 */
void aumentarArticulos(Articulo *vecArt, int totalArt, float porc) {
    for (int i = 0; i < totalArt; i++) {
        float pActual = vecArt[i].getPrecio();
        vecArt[i].setPrecio(pActual + pActual * (porc / 100));
    }
}

void coutCentrado(const char *texto, int tCols) {
    int lTexto = strlen(texto);

    cout << setw(tCols / 2 - lTexto / 2) << " ";
    cout << texto;
    cout << setw(tCols / 2 - lTexto / 2 - lTexto % 2) << " ";
}