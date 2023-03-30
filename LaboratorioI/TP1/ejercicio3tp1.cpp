#include <iostream>
#include <cstdlib>
using namespace std;

/*
  Una concesionaria de autos paga a los vendedores
  un sueldo fijo de   $ 15.000 más $ 2.000 de premio
  por cada auto vendido. Hacer un programa que permita
  ingresar por teclado la cantidad de autos vendidos por
  un vendedor y luego informar por pantalla el sueldo
  total a pagar.
*/

int main() {
  const int SUELDO = 15000;
  const int PREMIO = 2000;
  int cantidadAutos, sueldoTotal;

  cout << "Ingrese la cantidad de autos vendidos: ";
  cin >> cantidadAutos;

  sueldoTotal = SUELDO + PREMIO * cantidadAutos;

  cout << "El sueldo total es de: " << sueldoTotal << endl;

  cout << endl;
  system ("pause");
  return 0;
}
