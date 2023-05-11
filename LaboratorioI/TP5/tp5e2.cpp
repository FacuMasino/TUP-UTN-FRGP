#include <iostream>
#include <iomanip>
using namespace std;

int main(void) {
	const int VIRREYES = 1;
	const int S_FERNANDO = 2;
	const int TIGRE = 3;

	int nCliente, nSuc, masDeMil = 0, clienteMayorExt;
	int totalTxn = 0, totalTxn1 = 0, totalTxn2 = 0, totalTxn3 = 0;
	char codTxn;
	float monto, mayorExt = 0;

	while(cliente != 0) {
		cout << "Nro. Cliente (100 al 1200): " << endl;
		cin >> nCliente;
		cout << endl << "Nro. Sucursal (1 a 3): ";
		cin >> nSuc;
		cout << endl << "Cod. Transacción (D o E): "
		cin >> codTx;
		cout << endl << "Monto: ";
		cin >> monto;

		switch(codTxn) {
			case "d":
			case "D":
				// A
				if(monto > 1000) {
					masDeMil++;
				}
				break;
			case "e":
			case "E":
				// B
				if(monto > mayorExt) {
					clienteMayorExt = nCliente;
					mayorExt = monto;
				}
				break;
			default:
				cout << "Error, código de Transacción Incorrecto. \n El programa finalizará." << endl;
				system("pause");
				return 0;
		}
		
		// C calcular transacciones para el promedio
		switch (nSuc) {
			case VIRREYES:
				totalTxn1++;
				break;
			case S_FERNANDO:
				totalTxn2++;
				break;
			case TIGRE:
				totalTxn3++;
				break;
			default:
				cout << "Error, Sucursal inexistente. \n El programa finalizará." << endl;
				system("pause");
				return 0;
		}
		
		// Calcular total de transacciones
		// Excepto que se ingrese nCliente 0
		if(nCliente != 0) {
			totalTxn++;
		}
	}	

	system("cls");
	system("pause");
	return 0;
}
