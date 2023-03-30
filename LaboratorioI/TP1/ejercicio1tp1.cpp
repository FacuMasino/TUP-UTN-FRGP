#include <iostream>
#include <cstdlib>
using namespace std;

/*
Hacer un programa para ingresar por teclado la cantidad de horas 
trabajadas por un operario y el valor que se le paga por hora 
trabajada y listar por pantalla el sueldo que le corresponda.
*/

int main() {
  int horas, valorHora;

  cout << "Ingrese la cantidad de horas trabajadas:";
  cin >> horas;
  cout << "Ingrese el valor cobrado por hora:";
  cin >> valorHora;
  cout << endl << "El sueldo es de: $" << horas*valorHora << endl;
  cout << endl;
  system("pause");

  return 0;
}
