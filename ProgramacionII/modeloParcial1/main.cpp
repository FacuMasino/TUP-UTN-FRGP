
#include <cstring>
#include <iostream>

using namespace std;

#include "parcialm1.h"

class ObrasEjecucion {
private:
    char _codObra[5];
    char _direccion[30];
    int _provincia;
    bool _activo;

public:
    void setCodObra(const char *cod) { strcpy(_codObra, cod); }
    void setDireccion(const char *dir) { strcpy(_direccion, dir); }
    void setProvincia(int prov) { _provincia = prov; }
    void setActivo(bool activo) { _activo = activo; }

    char const *getCodObra() { return _codObra; }
    char const *getDireccion() { return _direccion; }
    int getProvincia() { return _provincia; }
    bool getActivo() { return _activo; }
};

bool escribirArchivo(ObrasEjecucion reg) {
    FILE *fObrasEnEj = fopen("obrasEnEj.dat", "ab");
    if (fObrasEnEj == NULL) return false;
    bool exito = fwrite(&reg, sizeof(ObrasEjecucion), 1, fObrasEnEj);
    fclose(fObrasEnEj);
    return exito;
}

ObrasEjecucion crearObra(Obra reg) {
    ObrasEjecucion obraEnEj;
    obraEnEj.setCodObra(reg.getCodigoObra());
    obraEnEj.setDireccion(reg.getDireccion());
    obraEnEj.setProvincia(reg.getProvincia());
    obraEnEj.setActivo(reg.getActivo());
    return obraEnEj;
}

bool obtenerGuardarObras() {
    ArchivoObras archiObras("obras.dat");
    int totalObras = archiObras.contarRegistros();
    if (totalObras <= 0) return false;
    for (int i = 0; i < totalObras; i++) {
        Obra regObra = archiObras.leerRegistro(i);
        if (regObra.getEstadoEjecucion() == 3) {
            bool escribir = escribirArchivo(crearObra(regObra));
            if (!escribir) return false;
        }
    }
    return true;
}

int buscarMenorProv(int provincia[24]) {
    int menorProvincia = 0, nProveedores = 0;
    for (int i = 0; i < 24; i++) {
        if (nProveedores == 0 && provincia[i] != 0) {
            menorProvincia = i + 1;
            nProveedores = provincia[i];
        } else if (provincia[i] != 0 && provincia[i] < nProveedores) {
            menorProvincia = i + 1;
            nProveedores = provincia[i];
        }
    }
    return menorProvincia;
}

int provMenosProveedores() {
    int provincia[24]{};
    ArchivoProveedor archiProv("proveedores.dat");
    int totalReg = archiProv.contarRegistros();
    if (totalReg <= 0) return -1;
    for (int i = 0; i < totalReg; i++) {
        Proveedor reg = archiProv.leerRegistro(i);
        provincia[reg.getProvincia() - 1]++;
    }
    return buscarMenorProv(provincia);
}

void mostrarResultado1() {
    ObrasEjecucion reg;
    FILE *pObrasEj = fopen("obrasEnEj.dat", "rb");
    if (pObrasEj == NULL) return;
    while (fread(&reg, sizeof(ObrasEjecucion), 1, pObrasEj)) {
        cout << "Codigo Obra: " << reg.getCodObra() << endl;
        cout << "Direccion: " << reg.getDireccion() << endl;
        cout << "Provincia: " << reg.getProvincia() << endl;
        cout << "Activo: " << (reg.getActivo() ? "Si" : "No") << endl;
        cout << endl;
    }
    fclose(pObrasEj);
}

void punto1() {
    cout << "Obteniendo obras en ejecucion...\n";
    if (obtenerGuardarObras()) {
        cout << "Obras en ejecucion guardadas en obrasEnEj.dat\n\n";
    } else {
        cout << "Ocurrio un error, el archivo no se pudo crear\n\n";
    }
}

void punto2() {
    int prov = provMenosProveedores();
    if (prov > 0) {
        cout << "La provincia con menor cantidad de proveedores fue la #"
             << prov << endl;
    } else {
        cout << "Ocurrio un error al obtener la informacion de proveedores.\n";
    }
    cout << endl;
}

// ----------- A1 -----------

bool comprasPorMaterial() {
    ArchivoMaterial materiales("materiales.dat");
    ArchivoCompra compras("compras.dat");
    int totalMateriales = materiales.contarRegistros();
    int totalCompras = compras.contarRegistros();
    if (totalMateriales <= 0) return false;
    if (totalCompras <= 0) return false;
    for (int i = 0; i < totalMateriales; i++) {
        int cantCompras = 0;
        Material regMaterial = materiales.leerRegistro(i);
        cout << "Nombre: " << regMaterial.getNombre() << endl;
        cout << "Codigo: " << regMaterial.getCodigoMaterial() << endl;
        for (int j = 0; j < totalCompras; j++) {
            Compra regCompra = compras.leerRegistro(j);
            if (regMaterial.getCodigoMaterial() ==
                regCompra.getCodigoMaterial()) {
                cantCompras++;
            }
        }
        cout << "Cantidad de compras: " << cantCompras << endl;
    }
    return true;
}

void puntoA1() {
    cout << "Cantidad de compras por material: \n";
    if (!comprasPorMaterial()) {
        cout << "Ocurrio un error al obtener las compras y materiales.\n";
    }
}

// ----------- A2 -----------

int posMayorProveedor(float vImportes[60], int vPosReg[60]) {
    float mayorImporte = 0;
    int posReg;
    for (int i = 0; i < 60; i++) {
        if (vImportes[i] > mayorImporte) {
            mayorImporte = vImportes[i];
            posReg = vPosReg[i];
        }
    }
    return posReg;
}

int calcularMayorProveedor() {
    ArchivoProveedor proveedores("proveedores.dat");
    ArchivoCompra compras("compras.dat");
    int totalProvs = proveedores.contarRegistros();
    int totalCompras = compras.contarRegistros();
    float vImportesProv[60]{};
    int vPosRegProv[60]{};

    if (totalProvs <= 0 || totalCompras <= 0) return -1;
    for (int i = 0; i < totalProvs; i++) {
        Proveedor regProv = proveedores.leerRegistro(i);
        // guardar pos del registro correspondiente al proveedor
        vPosRegProv[regProv.getNumeroProveedor() - 1] = i;
        for (int j = 0; j < totalCompras; j++) {
            Compra regCompra = compras.leerRegistro(j);
            if (regProv.getNumeroProveedor() ==
                regCompra.getNumeroproveedor()) {
                // acumular importes
                vImportesProv[regProv.getNumeroProveedor() - 1] +=
                    regCompra.getImporte();
            }
        }
    }
    return posMayorProveedor(vImportesProv, vPosRegProv);
}

void puntoA2() {
    ArchivoProveedor proveedores("proveedores.dat");
    int pos = calcularMayorProveedor();

    cout << "Buscando mayor proveedor...\n";
    if (pos >= 0) {
        cout << "El proveedor que mayor importe obtuvo fue: ";
        cout << proveedores.leerRegistro(pos).getNombre() << endl;
    } else {
        cout << "Ocurrio un error al leer los registros.\n";
    }
}

// ----------- A3 -----------
bool cargarVecComprasXProv(int vecParaCarga[60]) {
    ArchivoCompra compras("compras.dat");
    int totalCompras = compras.contarRegistros();
    if (totalCompras <= 0) return false;
    for (int i = 0; i < totalCompras; i++) {
        Compra regCompra = compras.leerRegistro(i);
        if (regCompra.getFechaCompra().getAnio() == 2022) {
            vecParaCarga[regCompra.getNumeroproveedor() - 1]++;
        }
    }
    return true;
}

void puntoA3() {
    int vComprasXProv[60]{};
    if (cargarVecComprasXProv(vComprasXProv)) {
        cout << "Proveedores que no tuvieron compras: \n";
        for (int i = 0; i < 60; i++) {
            if (vComprasXProv[i] == 0) cout << "Proveedor #" << i + 1 << endl;
        }
    } else {
        cout << "No se pudo leer el registro de compras." << endl;
    }
}

// ----------- A4 -----------
void puntoA4() {
    ArchivoObras archObras("obras.dat");
    ArchivoCompra archCompras("compras.dat");
    ArchivoMaterial archMaterial("materiales.dat");
    int totalObras = archObras.contarRegistros();
    int totalCompras = archCompras.contarRegistros();
    int totalMat = archMaterial.contarRegistros();

    if (totalObras + totalCompras + totalMat < 3) {
        cout << "No se pudieron obtener los registros\n";
    }

    for (int x = 0; x < totalObras; x++) {
        float gasto = 0;
        Obra regObra = archObras.leerRegistro(x);
        for (int i = 0; i < totalCompras; i++) {
            Compra regCompra = archCompras.leerRegistro(i);
            if (strcmp(regCompra.getCodigoObra(), regObra.getCodigoObra()) ==
                0) {
                for (int j = 0; j < totalMat; j++) {
                    Material regMat = archMaterial.leerRegistro(j);
                    if (regMat.getCodigoMaterial() ==
                            regCompra.getCodigoMaterial() &&
                        regMat.getTipo() == 1) {
                        gasto += regCompra.getImporte();
                    }
                }
            }
        }
        cout << "Codigo de Obra " << regObra.getCodigoObra() << endl;
        cout << "Gasto Gruesa: $ " << gasto << endl;
    }
    // cout << "total obras: " << totalObras << endl;
}

// ----------- A5 -----------
void puntoA5() {
    ArchivoProveedor arPro("proveedores.dat");
    int totalRegs = arPro.contarRegistros();
    int proveedoresXProv[24]{}, total = 0;

    if (totalRegs <= 0) {
        cout << "No se pudo leer el archivo de proveedores.\n";
        return;
    }

    cout << "Provincia/s con mas de 22 proveedores:\n";
    for (int i = 0; i < totalRegs; i++) {
        Proveedor reg = arPro.leerRegistro(i);
        proveedoresXProv[reg.getProvincia() - 1]++;
    }
    for (int i = 0; i < 24; i++) {
        if (proveedoresXProv[i] > 22) {
            total++;
            cout << "Provincia #" << i + 1 << endl;
        }
    }

    if (total == 0) cout << "No hay.\n";
}

// ----------- A6 -----------
bool modificarCompras(Compra reg, int posReg) {
    FILE *pCompras = fopen("compras.dat", "rb+");
    if (pCompras == NULL) return false;
    fseek(pCompras, sizeof(Compra) * posReg, SEEK_SET);
    bool modificado = fwrite(&reg, sizeof(Compra), 1, pCompras);
    fclose(pCompras);
    return modificado;
}

void puntoA6() {
    ArchivoCompra compras("compras.dat");
    int totalCompras = compras.contarRegistros();
    int totalMod = 0;

    if (totalCompras <= 0) {
        cout << "No se pudo leer el archivo compras\n";
        return;
    }
    for (int i = 0; i < totalCompras; i++) {
        Compra reg = compras.leerRegistro(i);
        if (reg.getFechaCompra().getAnio() == 2020) {
            reg.setActivo(false);
            if (!modificarCompras(reg, i)) {
                cout << "Ocurrio un error al modificar el archivo.\n";
                return;
            }
            totalMod++;
        }
    }
    if (totalMod > 0) {
        cout << "Se dieron de baja " << totalMod << " compras\n";
    } else {
        cout << "No hubo compras en el anio 2020\n";
    }
}

// ----------- A7 -----------
bool modificarMateriales(Material reg, int posReg) {
    FILE *pMat = fopen("materiales.dat", "rb+");
    if (pMat == NULL) return false;
    fseek(pMat, sizeof(Material) * posReg, SEEK_SET);
    bool modificado = fwrite(&reg, sizeof(Material), 1, pMat);
    fclose(pMat);
    return modificado;
}

void puntoA7() {
    ArchivoMaterial mats("materiales.dat");
    int totalMat = mats.contarRegistros();
    int totalMods = 0;

    if (totalMat <= 0) {
        cout << "No se pudo leer el archivo de materiales\n";
        return;
    }

    for (int i = 0; i < totalMat; i++) {
        Material reg = mats.leerRegistro(i);
        if (reg.getTipo() == 3) {
            // cout << reg.getNombre() << " " << reg.getPU() << endl;
            reg.setPU(reg.getPU() * 1.10);
            if (!modificarMateriales(reg, i)) {
                cout
                    << "Ocurrio un error al modificar el archivo materiales.\n";
                return;
            }
            // cout << "Precio nuevo: " << reg.getPU() << endl;
            totalMods++;
        }
    }

    if (totalMods > 0) {
        cout << "Se modificaron " << totalMods << " materiales.\n";
    } else {
        cout << "No hay materiales para modificar.\n";
    }
}

int main() {
    // punto 1
    // Generar un archivo con el código de obra, la dirección y la
    // provincia, de las obras cuyo estado de ejecución sea "en ejecución".
    // punto1();

    // punto 2
    // La provincia con menos proveedores (ignorando las provincias sin
    // proveedores).
    // punto2();

    // mostrarResultado1();

    // punto a1
    // Para cada material la cantidad de compras que se hayan realizado entre
    // todas las compras
    // puntoA1();

    // El nombre del proveedor que mayor importe haya obtenido entre todas las
    // compras que se le realizaron
    // puntoA2();

    // Los número de los proveedores a los que no se les compró nada el año
    // pasado
    // puntoA3();

    // El gasto en obra gruesa para cada uno de las obras.
    // puntoA4();

    // La/s provincia/s con más de 22 proveedores
    // puntoA5();

    // Dar de baja lógica a todas las compras del año 2020
    // puntoA6();

    // Modificar el precio de las aberturas en el archivo de materiales.
    // Incrementar un 10% todos los materiales de ese tipo.
    // puntoA7();

    system("pause");
    return 0;
}