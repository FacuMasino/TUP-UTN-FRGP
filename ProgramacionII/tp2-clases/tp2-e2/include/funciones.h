#ifndef FUNCIONES_INCLUDED
#define FUNCIONES_INCLUDED
#include "Articulo.h"

void cargarVecArticulos(Articulo *, int);
void mostrarVecArticulos(Articulo *, int);
void mostrarArtValorMayorQue(Articulo *, int, float);
int buscarArticulo(Articulo *, char *, int);
Articulo devolverArtBuscado(Articulo *vecArt, char *codigo, int totalArt);
int buscarStock(Articulo *, int, int);

#endif /* FUNCIONES_INCLUDED */
