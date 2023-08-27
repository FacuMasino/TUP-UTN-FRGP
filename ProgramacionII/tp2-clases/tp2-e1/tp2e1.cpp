/*
Hacer una clase de nombre Articulo con las siguientes propiedades:
Código (char[5]), Descripción (char[30])
Precio (float), Stock(int), Estado(bool)

Y los siguientes métodos:
Cargar()
Mostrar()
Gets() para todas las propiedades
Sets() para todas las propiedades
Un constructor con parámetros por omisión
Un constructor para asignar valor sólo a la descripción
*/

#include <cstring>
#include <iostream>

using namespace std;

class Articulo {
private:
  char codigo[5] = "0000";
  char descripcion[30]{};
  float precio = 0.00;
  int stock = 0;
  bool estado = false;

public:
  Articulo() {
    setCodigo("AAA0");
    setDescripcion("Descripcion Inicial");
    setPrecio(1000);
    setStock(100);
    setEstado(false);
  }

  Articulo(const char *descripcion) { setDescripcion(descripcion); }

  void Cargar() {
    char cCodigo[5], cDescripcion[30];
    int cStock;
    float cPrecio;
    bool cEstado;

    cout << "Ingresar codigo (hasta 4 caracteres): ";
    cin.getline(cCodigo, 5);
    cout << "Ingresar descripcion (hasta 29 caracteres): ";
    cin.getline(cDescripcion, 30);
    cout << "Ingresar precio: ";
    cin >> cPrecio;
    cout << "Ingresar stock: ";
    cin >> cStock;
    cout << "Ingresar estado (1. Disponible, 0. No disponible): ";
    cin >> cEstado;

    setCodigo(cCodigo);
    setDescripcion(cDescripcion);
    setPrecio(cPrecio);
    setStock(cStock);
    setEstado(cEstado);
  }

  void Mostrar() {
    cout << "Codigo: " << codigo << endl;
    cout << "Descripcion: " << descripcion << endl;
    cout << "Precio: " << precio << endl;
    cout << "Stock: " << stock << endl;
    cout << "Estado: " << (estado ? "Disponible" : "No disponible") << endl;
  }

  char *getCodigo() { return codigo; }
  char *getDescripcion() { return descripcion; }
  bool getEstado() { return estado; }
  int getPrecio() { return precio; }
  int getStock() { return stock; }

  void setCodigo(const char codigo[]) { strcpy(this->codigo, codigo); }
  void setDescripcion(const char descripcion[]) { strcpy(this->descripcion, descripcion); }
  void setPrecio(float pPrecio) {
    precio = pPrecio;
    // this -> precio = pPrecio;
    // This es un puntero que contiene la direccion del objeto que llama al
    // método. 
  }
  void setEstado(bool estado) { this->estado = estado; }
  void setStock(int stock) { this->stock = stock; }
};

int main() {
  Articulo art1, art2("Articulo vacio");

  art1.Cargar();
  art1.Mostrar();
  cout << endl;
  art2.Mostrar();

  system("pause");
  return 0;
}