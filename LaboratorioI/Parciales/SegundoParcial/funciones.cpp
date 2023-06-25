#include "rlutil.h"
#include <iomanip>
#include <iostream>

using namespace std;
using namespace rlutil;

#include "funciones.h"

void mostrarCartel() {
    coutCentrado("BIENVENIDO!", true);
    coutCentrado("#################", false);
    coutCentrado("### EDITORIAL ###", false);
    coutCentrado("#VELEZ BOOKS LAB#", false);
    coutCentrado("#################", false);
    divisor(BROWN);
    cout << endl << endl;
}

void cargarDatos(bool genXSuc[][7], int idAutorVentas[][2],
                 int ventasPrecioXGen[][2]) {
    int idVenta, idAutor, idGen, precio, pagLibro, idSuc;

    cout << "ID de Venta: ";
    cin >> idVenta;

    while (idVenta != 0) {
        cout << "ID de Autor [500-1499] : ";
        cin >> idAutor;
        cout << "ID de Genero Literario [1-7]: ";
        cin >> idGen;
        cout << "Precio: ";
        cin >> precio;
        cout << "Paginas del libro: ";
        cin >> pagLibro;
        cout << "ID de Sucursal: ";
        cin >> idSuc;

        // cargar info en vectores
        genXSuc[convertirIdSuc(idSuc)][idGen - 1] = true;
        if (pagLibro > 1200) {
            idAutorVentas[idAutor - 500][0]++; // acumular lib>1.2k
        }
        idAutorVentas[idAutor - 500][1] += precio; // acumula recaudacion total
        ventasPrecioXGen[idGen - 1][0]++; // acumula total ventas del genero
        ventasPrecioXGen[idGen - 1][1] += precio; // acumula rec. del genero

        cout << "ID de Venta: ";
        cin >> idVenta;
    }

    system("cls"); // limpiar al terminar carga
    mostrarCartel();
}

void Punto1(bool genXSuc[][7]) {
    cout << "1) Suc. que no hayan vendido genero Terror ni Ciencia Ficcion \n";
    for (int i = 0; i < 4; i++) {
        if (!genXSuc[i][0] && !genXSuc[i][3]) {
            cout << "\t- Sucursal ID #" << convertirIdSuc(i, true) << endl;
        }
    }
}

void Punto2(int idAutorVentas[][2]) {
    int cantidad = 0;

    for (int i = 0; i < 1000; i++) {
        if (idAutorVentas[i][0] > 0) {
            cantidad++;
        }
    }

    cout << "2) Cantidad de autores con al menos 1 venta de 1 libro con "
         << "pag>1200: ";
    cout << cantidad;
}

void Punto3(int ventasPrecioXGen[][2]) {
    string generos[7] = {"Terror",   "Biografia", "Novela", "Ciencia Ficcion",
                         "Historia", "Ciencia",   "Salud"};
    cout << "3) Precio promedio por genero:";
    for (int i = 0; i < 7; i++) {
        cout << "\n\t - #" << i + 1 << " " << generos[i];
        if (ventasPrecioXGen[i][0] > 0) {
            cout << " - $ " << ventasPrecioXGen[i][1] / ventasPrecioXGen[i][0];
        } else {
            cout << " - Sin ventas.";
        }
    }
}

void Punto4(int idAutorVentas[][2]) {
    int maxRec = 0;
    int maxId;

    for (int i = 0; i < 1000; i++) {
        if (idAutorVentas[i][1] > maxRec) {
            maxRec = idAutorVentas[i][1];
            maxId = i + 500;
        }
    }

    cout << "\n4) ID Autor con mayor recaudacion: #" << maxId << endl;
}

int convertirIdSuc(int idSucursal, bool idOriginal) {
    int id;
    if (idOriginal) {
        switch (idSucursal) {
        case 0:
            id = 1000;
            break;
        case 1:
            id = 2000;
            break;
        case 2:
            id = 3000;
            break;
        case 3:
            id = 4000;
            break;
        }
    } else {
        switch (idSucursal) {
        case 1000:
            id = 0;
            break;
        case 2000:
            id = 1;
            break;
        case 3000:
            id = 2;
            break;
        case 4000:
            id = 3;
            break;
        }
    }
    return id;
}

// FUNCIONES UTILES

void colorear(bool onOff, int bgColor, int fColor) {
    if (onOff) {
        setBackgroundColor(bgColor);
        setColor(fColor);
    } else {
        setBackgroundColor(BLACK);
        setColor(WHITE);
    }
}

void divisor(int color) {
    setBackgroundColor(color);
    cout << endl << setw(tcols()) << "";
    setBackgroundColor(BLACK);
}

void coutColor(string texto, int bgColor, int fColor) {
    colorear(true, bgColor, fColor);
    cout << texto;
    colorear(false, bgColor, fColor);
}

void coutCentrado(string texto, bool resaltado) {
    int lTexto = texto.size();
    if (resaltado) {
        colorear(true, BROWN, BLACK);
    }
    cout << setw(tcols() / 2 - lTexto / 2) << "";
    cout << texto;
    cout << setw(tcols() / 2 - lTexto / 2 - lTexto % 2) << "";
    if (resaltado) {
        colorear(false, BROWN, BLACK);
    }
}