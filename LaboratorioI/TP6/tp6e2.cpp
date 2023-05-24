#include <iostream>
using namespace std;

/*
 Hacer un programa donde se carguen 15 números enteros y luego 
 le solicite al usuario un número e indique si el mismo 
 pertenece a la lista cargada anteriormente.
*/

int main(void) {

	const int CANTIDAD = 15;
	int usrN[CANTIDAD];
	int n2;
	bool pertenece = false;

	cout << "A continuacion debe ingresar 15 nros:" << endl;
	for(int i = 0; i < CANTIDAD; i++) {
		cout << "#" << i+1 << " > ";
		cin >> usrN[i];
	}

	cout << "Ingrese otro nro: ";
	cin >> n2;
	for(int i = 0; i < CANTIDAD; i++) {
		if(usrN[i] == n2) {
			pertenece = true;
		}
	}
	if(pertenece) {
		cout << "El nro ingresado PERTENECE a la lista de 15 nros." << endl;
	} else {
		cout << "El nro ingresado NO PERTENECE a la lista de 15 nros." << endl;
	}

	cout << endl;
	system("pause");
	return 0;
}
