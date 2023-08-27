#ifndef ARTICULO_INCLUDED
#define ARTICULO_INCLUDED

#include <cstring>
#include <iostream>

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

  void cargarCadena(char *palabra, int tamano) {
    int i = 0;
    std::fflush(stdin);
    for (i = 0; i < tamano; i++) {
      palabra[i] = std::cin.get();
      if (palabra[i] == '\n') {
        break;
      }
    }
    palabra[i] = '\0';
    std::fflush(stdin);
  }

  void cargar() {
    char cCodigo[5], cDescripcion[30];
    int cStock;
    float cPrecio;
    bool cEstado;

    std::cout << "Ingresar codigo (hasta 4 caracteres): ";
    cargarCadena(cCodigo, 5);
    std::cout << "Ingresar descripcion (hasta 29 caracteres): ";
    cargarCadena(cDescripcion, 30);
    std::cout << "Ingresar precio: ";
    std::cin >> cPrecio;
    std::cout << "Ingresar stock: ";
    std::cin >> cStock;
    std::cout << "Ingresar estado (1. Disponible, 0. No disponible): ";
    std::cin >> cEstado;

    setCodigo(cCodigo);
    setDescripcion(cDescripcion);
    setPrecio(cPrecio);
    setStock(cStock);
    setEstado(cEstado);
  }

  void mostrar() {
    std::cout << "Codigo: " << codigo << "\n";
    std::cout << "Descripcion: " << descripcion << "\n";
    std::cout << "Precio: $ " << precio << "\n";
    std::cout << "Stock: " << stock << "\n";
    std::cout << "Estado: " << (estado ? "Disponible" : "No disponible")
              << "\n";
  }

  char *getCodigo() { return codigo; }
  char *getDescripcion() { return descripcion; }
  bool getEstado() { return estado; }
  int getPrecio() { return precio; }
  int getStock() { return stock; }

  void setCodigo(const char codigo[]) { strcpy(this->codigo, codigo); }
  void setDescripcion(const char descripcion[]) {
    strcpy(this->descripcion, descripcion);
  }
  void setPrecio(float pPrecio) {
    precio = pPrecio;
    // this -> precio = pPrecio;
    // This es un puntero que contiene la direccion del objeto que llama al
    // método.
  }
  void setEstado(bool estado) { this->estado = estado; }
  void setStock(int stock) { this->stock = stock; }
};

#endif /* ARTICULO_INCLUDED */
