#include <iostream>
using namespace std;

/*
 * Hacer un programa para ingresar por teclado la cantidad de asientos 
 * disponibles en un avión y la cantidad de pasajes ocupados y luego 
 * calcular e informar el porcentaje de ocupación y el porcentaje de 
 * no ocupación del mismo.
*/

int main () {
	int asientos, pasajes;
	float pOcupados, pDisponibles;

	cout << "Ingrese la cantidad de asientos disponibles: ";
	cin >> asientos;
	cout << "Ingrese la cantidad de pasajes vendidos: ";
	cin >> pasajes;
	pOcupados = (float) pasajes / asientos * 100;
	pDisponibles = 100 - pOcupados;
	
	cout << endl;
	cout << "Porcentaje de ocupados:" << pOcupados << "%" << endl;
	cout << "Porcentaje disponibles: " << pDisponibles << "%" << endl;
	cout << endl;
	system("pause");

	return 0;
}
