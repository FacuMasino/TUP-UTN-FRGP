#include <iostream>
using namespace std;

/*
 Hacer un programa que le pida al usuario una lista de 10 
 números enteros y luego de ingresarlos muestre cuáles de 
 ellos fueron positivos.
*/

int main(void) {

	int usrN[10];
	bool hayPositivo = false;

	cout << "A continuacion debe ingresar 10 nros:" << endl;
	for(int i = 0; i < 10; i++) {
		cout << "#" << i+1 << " > ";
		cin >> usrN[i];
	}

	cout << "Nros positivos: ";
	for(int i = 0; i < 10; i++) {
		if(usrN[i] > 0) {
			hayPositivo = true;
			cout << usrN[i] << " ";
		}
	}
	if(!hayPositivo) {
		cout << "No hay." << endl;
	}

	cout << endl;
	system("pause");
	return 0;
}
