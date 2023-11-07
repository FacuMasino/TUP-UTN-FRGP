#include <cstdlib>
#include <cstring>
#include <iostream>

using namespace std;

#include "parcial2.h"

class VentasTour {
private:
    int _nVenta;
    char _codCliente[5], _nombreCliente[30];

public:
    void setNVenta(int nv) { _nVenta = nv; }
    void setCodCliente(const char *cc) { strcpy(_codCliente, cc); }
    void setNombreCliente(const char *nc) { strcpy(_nombreCliente, nc); }

    int getNVenta() { return _nVenta; }
    const char *getCodCliente() { return _codCliente; }
    const char *getNombreCliente() { return _nombreCliente; }

    /**
     * @brief Asigna directamente el nro de venta
     *
     * @param nv nro de venta
     */
    void operator=(int nv) { _nVenta = nv; }

    /**
     * @brief Compara el codigo de cliente
     *
     * @param _cc Codigo de cliente
     * @return true si el cliente es el mismo
     * @return false si el cliente es diferente
     */
    bool operator==(const char _cc[5]) {
        if (strcmp(_codCliente, _cc) == 0) return true;
        return false;
    }
};

VentasTour crearRegVT(int nVenta, const char *codC, const char *nCliente);
bool agregarRegistroVT(VentasTour reg);
VentasTour leerRegistrosVT(int pos);
int contarRegistrosVT();
int obtenerTour11();
void mostrarVecVentasT11(VentasTour *vecVT, int total);
void Punto2();
void Punto1();

int main() {
    Punto1();
    Punto2();
    system("pause");
    return 0;
}

VentasTour crearRegVT(int nVenta, const char *codC, const char *nCliente) {
    VentasTour auxReg;
    auxReg.setCodCliente(codC);
    auxReg.setNombreCliente(nCliente);
    auxReg.setNVenta(nVenta);
    return auxReg;
}

bool agregarRegistroVT(VentasTour reg) {
    FILE *pFile = fopen("ventasTour11.dat", "ab");
    if (pFile == NULL) return false;
    bool exito = fwrite(&reg, sizeof(VentasTour), 1, pFile);
    fclose(pFile);
    return exito;
}

VentasTour leerRegistrosVT(int pos) {
    VentasTour reg;
    FILE *pFile = fopen("ventasTour11.dat", "rb");
    if (pFile == NULL) return reg;
    fseek(pFile, sizeof(reg) * pos, 0);
    fread(&reg, sizeof(reg), 1, pFile);
    fclose(pFile);
    return reg;
}

int contarRegistrosVT() {
    FILE *pFile = fopen("ventasTour11.dat", "rb");
    if (pFile == NULL) return -1;
    fseek(pFile, 0, 2);
    int tam = ftell(pFile);
    fclose(pFile);
    return tam / sizeof(VentasTour);
}

int obtenerTour11() {
    ArchivoVentas fVentas("Ventas.dat");
    ArchivoClientes fClientes("clientes.dat");
    int totalVentas = fVentas.contarRegistros();
    int totalClientes = fClientes.contarRegistros();
    int totalTours = 0;

    if (totalVentas <= 0 || totalClientes <= 0) return -1;

    for (int i = 0; i < totalVentas; i++) {
        Venta auxVenta = fVentas.leerRegistro(i);
        if (auxVenta.getEstado() && auxVenta.getCodigoTour() == 11) {
            for (int j = 0; j < totalClientes; j++) {
                Cliente auxCliente = fClientes.leerRegistro(j);
                // Se corrije la linea 112 con strcmp() ya que se estaban
                // comparando las dir. de memoria de los vectores char y no las
                // cadenas.
                if (auxCliente.getEstado() &&
                    strcmp(auxCliente.getCodigoCliente(),
                           auxVenta.getNumeroDeCliente()) == 0) {
                    VentasTour auxRegVT;
                    auxRegVT = crearRegVT(auxVenta.getNumeroVenta(),
                                          auxCliente.getCodigoCliente(),
                                          auxCliente.getNombre());
                    if (!agregarRegistroVT(auxRegVT)) return -1;
                    totalTours++;
                    j = totalClientes;  // si ya encontre el cliente, detener
                                        // for.
                }
            }
        }
    }
    return totalTours;
}

void mostrarVecVentasT11(VentasTour *vecVT, int total) {
    cout << "\n Ventas del tour cod. 11: \n";
    for (int i = 0; i < total; i++) {
        cout << "N Venta: " << vecVT[i].getNVenta() << endl;
        cout << "Cod. Cliente: " << vecVT[i].getCodCliente() << endl;
        cout << "Nombre Cliente: " << vecVT[i].getNombreCliente() << endl;
    }
}

void Punto2() {
    cout << "\n\nCargando ventas del tour cod. 11...\n";
    int totalRegs = contarRegistrosVT();
    if (totalRegs < 0) {
        cout << "Ocurrio un error al leer los registros de ventas del tour cod."
                "11.\n";
        return;
    } else if (totalRegs == 0) {
        cout << "No hay registros de ventas del tour cod. 11";
        return;
    }

    VentasTour *regsVentas = new VentasTour[totalRegs];
    if (regsVentas == NULL) {
        cout << "No hay memoria suficiente.";
        return;
    }
    for (int i = 0; i < totalRegs; i++) {
        regsVentas[i] = leerRegistrosVT(i);
    }
    mostrarVecVentasT11(regsVentas, totalRegs);
    delete[] regsVentas;
}

void Punto1() {
    cout << "Buscando Tours con codigo 11...\n";
    int resultado = obtenerTour11();
    if (resultado < 0) {
        cout << "Ocurrio un error al leer los archivos o no hay registros.\n";
    } else if (resultado == 0) {
        cout << "No se encontraron tours con codigo 11.\n";
    } else {
        cout << "Se encontraron y grabaron " << resultado << " tours.\n";
    }
}