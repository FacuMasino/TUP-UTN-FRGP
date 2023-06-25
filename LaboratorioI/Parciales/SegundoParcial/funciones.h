#ifndef FUNCIONES_INCLUDED
#define FUNCIONES_INCLUDED

#include <iostream> // para que reconozca tipo string
using namespace std;

int convertirIdSuc(int idSucursal, bool idOriginal = false);
void cargarDatos(bool genXSuc[][7], int idAutorVentas[][2],
                 int ventasPrecioXGen[][2]);
void Punto1(bool genXSuc[][7]);
void Punto2(int idAutorVentas[][2]);
void Punto3(int ventasPrecioXGen[][2]);
void Punto4(int idAutorVentas[][2]);
void mostrarCartel();

// FUNCIONES UTILES
void colorear(bool onOff, int bgColor, int fColor);
void coutCentrado(string texto, bool resaltado = false);
void coutColor(string texto, int bgColor, int fColor);
void divisor(int color);

#endif /* FUNCIONES_INCLUDED */
