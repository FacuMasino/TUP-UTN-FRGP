#include <iostream>
#include <iomanip>
using namespace std;

int main(void) {
	const int VIRREYES = 1;
	const int S_FERNANDO = 2;
	const int TIGRE = 3;

	int nCliente, nSuc, masDeMil = 0, clienteMayorExt, sucMayorExt; // cin, A y B
	char codTxn; // cin
	float monto, mayorExt = 0; // cin, B
	int totalTxn = 0, totalTxn1 = 0, totalTxn2 = 0, totalTxn3 = 0; // C
	int totalDepS1 = 0, totalDepS2 = 0, totalDepS3 = 0; // D
	int cantidadDepS1 = 0, cantidadDepS2 = 0, cantidadDepS3 = 0; // E, F
	int mayorCantDep = 0, sucMayorCantDep; // F

	system("cls");

	cout << "Nro. Cliente (100 al 1200): ";
	cin >> nCliente;

	while(nCliente != 0) {
		cout << "Nro. Sucursal (1 a 3): ";
		cin >> nSuc;
		cout << "Cod. Transaccion (D o E): ";
		cin >> codTxn;
		cout << "Monto: ";
		cin >> monto;

		switch(codTxn) {
			case 'd':
			case 'D':
				// A
				if(monto > 1000) {
					masDeMil++;
				}
				// D, E, F
				switch (nSuc) {
					case VIRREYES:
						totalDepS1 += monto; // D

						// F
						cantidadDepS1++;
						if(cantidadDepS1 > mayorCantDep) {
							mayorCantDep = cantidadDepS1;
							sucMayorCantDep = VIRREYES;
						}

						break;
					case S_FERNANDO:
						totalDepS2 += monto; // D
						
						// F
						cantidadDepS2++;
						if(cantidadDepS2 > mayorCantDep) {
							mayorCantDep = cantidadDepS2;
							sucMayorCantDep = S_FERNANDO;
						}

						break;
					case TIGRE:
						totalDepS3 += monto; // D

						// E, F
						cantidadDepS3++;
						if(cantidadDepS3 > mayorCantDep) {
							mayorCantDep = cantidadDepS3;
							sucMayorCantDep = TIGRE;
						}

						break;
				}
				break;
			case 'e':
			case 'E':
				// B
				if(monto > mayorExt) {
					clienteMayorExt = nCliente;
					mayorExt = monto;
					sucMayorExt = nSuc;
				}
				break;
			default:
				cout << "Error, código de Transaccion Incorrecto. \n El programa finalizará." << endl;
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
		}
		
		totalTxn++;

		cout << "Nro. Cliente (100 al 1200): ";
		cin >> nCliente;
	}

	cout << endl << "A) Cantidad de depositos por mas de 1000: " << masDeMil << endl;

	cout << "B) Cliente con mayor extraccion: " << endl;
	cout << "\t Nro de cliente: " << clienteMayorExt << endl;
	cout << "\t Sucursal: ";
	switch(sucMayorExt) {
		case VIRREYES:
			cout << "Sucursal 1 - Virreyes";
			break;
		case S_FERNANDO:
			cout << "Sucursal 2 - San Fernando";
			break;
		case TIGRE:
			cout << "Sucursal 3 - Tigre";
			break;
	}
	cout << endl;

	cout << "C) Porcentaje total de transacciones por sucursal: " << endl;
	cout << "\t Sucursal 1 - Virreyes: " << (float) totalTxn1 / totalTxn * 100 << endl;
	cout << "\t Sucursal 2 - San Fernando: " << (float) totalTxn2 / totalTxn * 100 << endl;
	cout << "\t Sucursal 3 - Tigre: " << (float) totalTxn3 / totalTxn * 100 << endl;

	cout << "D) Total de pesos depositados por sucursal: " << endl;
	cout << "\t Sucursal 1 - Virreyes: $" << totalDepS1 << endl;
	cout << "\t Sucursal 2 - San Fernando: $" << totalDepS2 << endl;
	cout << "\t Sucursal 3 - Tigre: $" << totalDepS3 << endl;

	cout << "E) Cantidad de depositos Sucursal 3 - Tigre: " << cantidadDepS3 << endl;

	cout << "F) Sucursal con mas cantidad de depositos: ";
	switch(sucMayorCantDep) {
		case VIRREYES:
			cout << "Sucursal 1 - Virreyes" << endl;
			break;
		case S_FERNANDO:
			cout << "Sucursal 2 - San Fernando" << endl;
			break;
		case TIGRE:
			cout << "Sucursal 3 - Tigre" << endl;
			break;
	}

	system("pause");
	return 0;
}
