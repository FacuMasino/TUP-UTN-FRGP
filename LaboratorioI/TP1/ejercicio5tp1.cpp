#include <iostream>
using namespace std;

/*
 *Un comercio vende tres marcas de alfajores distintas A, B y C. Hacer un
 *programa para ingresar por teclado la cantidad de alfajores vendidos de
 *cada una de las tres marcas y luego se informe el porcentaje de ventas
 *para cada una de ellas.
*/

int main () {
	int a, b, c, total,percA, percB, percC;

	cout << "Ingrese la cantidad de alfajores vendidos." << endl ;
	cout << "Marca A: ";
	cin >> a;
	cout << "Marca B: ";
	cin >> b;
	cout << "Marca C: ";
	cin >> c;

	total = a + b + c;
	percA = ((float)a / total) * 100;
	percB = ((float)b / total) * 100;
	percC = ((float)c / total) * 100;

	cout << endl;
	cout << "Porcentaje de ventas por marca:" << endl;
	cout << "Marca A: " << percA << "%" << endl;
	cout << "Marca B: " << percB << "%" << endl;
	cout << "Marca C: " << percC << "%" << endl;

	system("pause");
	return 0;
}
