#ifndef FUNCIONES_INCLUDED
#define FUNCIONES_INCLUDED
#include "Articulo.h"

void cargarVecArticulos(Articulo *, int);
void mostrarVecArticulos(Articulo *, int);
void mostrarArtValorMayorQue(Articulo *, int, float);
float pedirPrecio();
int buscarArticulo(Articulo *, char *, int);
void pedirCodigo(char *);
Articulo devolverArtBuscado(Articulo *vecArt, char *codigo, int totalArt);
int buscarStock(Articulo *, int, int);
int pedirStock();
void aumentarArticulos(Articulo *, int, float);
float pedirPorcentaje();
void coutCentrado(const char *, int);

#endif /* FUNCIONES_INCLUDED */
