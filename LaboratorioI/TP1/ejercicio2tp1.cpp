#include <iostream>
#include <cstdlib>
using namespace std;

/*
Hacer un programa que solicite por teclado que se ingresen dos 
números y luego guardarlos en dos variables distintas. A 
continuación se deben intercambiar mutuamente los valores en ambas 
variables y mostrarlos por pantalla.
*/

int main () {
  int a,b,c;
  cout << "Ingrese el valor para la variable A:";
  cin >> a;
  cout << "Ingrese el valor para la variable B:";
  cin >> b;
  
  c = a;
  a = b;
  b = c;

  cout << endl << "Variable A = " << a << endl;
  cout << "Variable B = " << b << endl;

  cout << endl;
  system("pause");
  return 0;
}
