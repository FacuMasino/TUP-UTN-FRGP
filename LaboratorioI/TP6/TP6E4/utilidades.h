#ifndef UTILIDADES_H_INCLUDED
#define UTILIDADES_H_INCLUDED

#include <iostream>
#include <iomanip>
#include "rlutil.h"
using namespace std;
using namespace rlutil;

void resaltar(bool onOff, int bgColor = YELLOW, int fColor = BLACK)
{
    if(onOff) {
        setBackgroundColor(bgColor);
        setColor(fColor);
    } else {
        setBackgroundColor(BLACK);
        setColor(WHITE);
    }
}

void divisor(int color){
    setBackgroundColor(color);
    cout << endl << setw(tcols()) << "";
    setBackgroundColor(BLACK);
}

void coutCentrado(string texto, bool resaltado = false) {
    int lTexto = texto.size();
    if(resaltado) {resaltar(true);}
    cout << setw(tcols()/2-lTexto/2) << "";
    cout << texto;
    cout << setw(tcols()/2-lTexto/2-lTexto%2) << "";
    if(resaltado) {resaltar(false);}
}

#endif // UTILIDADES_H_INCLUDED
