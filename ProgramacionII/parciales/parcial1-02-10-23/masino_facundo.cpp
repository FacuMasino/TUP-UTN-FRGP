#include <cstdlib>
#include <cstring>
#include <iostream>
using namespace std;

#include "parcial1l.h"

class Docente {
private:
    int _DNI;
    char _nombre[25];
    char _apellido[30];
    Fecha _fechaInscrip;
    bool _estado;

public:
    int getDNI() { return _DNI; }
    const char *getNombre() { return _nombre; }
    const char *getApellido() { return _apellido; }
    Fecha getFechaInscrip() { return _fechaInscrip; }
    bool getEstado() { return _estado; }

    void setDNI(int DNI) { _DNI = DNI; }
    void setNombre(const char *nombre) { strcpy(_nombre, nombre); }
    void setApellido(const char *apellido) { strcpy(_apellido, apellido); }
    void setFechaInscrip(Fecha fecha) { _fechaInscrip = fecha; }
    void setEstado(bool estado) { _estado = estado; }
};

int generarDocentesCat3();
Docente crearDocente(Jugador reg);
bool escribirDocente(Docente reg);
void resolverPunto1();

int main() {
    resolverPunto1();
    system("pause");
    return 0;
}

int generarDocentesCat3() {
    ArchivoJugadores jugadores("jugadores.dat");
    ArchivoDeportes deportes("deportes.dat");
    int totalJugadores = jugadores.contarRegistros();
    int totalDeportes = deportes.contarRegistros();
    int contaDocentes = 0;

    if (totalJugadores <= 0 || totalDeportes <= 0) return -1;

    for (int i = 0; i < totalJugadores; i++) {
        Jugador regJugador = jugadores.leerRegistro(i);
        if (regJugador.getClaustro() == 1 && regJugador.getEstado()) {
            for (int j = 0; j < totalDeportes; j++) {
                Deporte regDeporte = deportes.leerRegistro(j);
                if (regJugador.getIdDeporte() == regDeporte.getIdDeporte() &&
                    regDeporte.getIdCtegoria() == 3 && regDeporte.getEstado()) {
                    bool guardarDoc = escribirDocente(crearDocente(regJugador));
                    if (!guardarDoc) return -1;
                    contaDocentes++;
                }
            }
        }
    }
    return contaDocentes;
}

Docente crearDocente(Jugador reg) {
    Docente docAux;
    docAux.setDNI(reg.getDNI());
    docAux.setNombre(reg.getNombre());
    docAux.setApellido(reg.getApellido());
    docAux.setFechaInscrip(reg.getFechaInscirpcion());
    docAux.setEstado(reg.getEstado());
    return docAux;
}

bool escribirDocente(Docente reg) {
    FILE *pDoc = fopen("docentes.dat", "ab");
    if (pDoc == NULL) return false;
    bool exito = fwrite(&reg, sizeof(Docente), 1, pDoc);
    fclose(pDoc);
    return exito;
}

void resolverPunto1() {
    cout << "Buscando jugadores docentes categoria 3...\n";
    int resultado = generarDocentesCat3();
    if (resultado == -1) {
        cout << "Ocurrio un error al acceder a los archivos.\n";
    } else if (resultado > 0) {
        cout << "Se genero el archivo docentes.dat con " << resultado
             << " docente/s.\n";
    } else {
        cout << "No hay jugadores docentes.\n";
    }
}