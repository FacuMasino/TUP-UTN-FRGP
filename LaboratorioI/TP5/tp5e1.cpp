#include <iostream>
using namespace std;

int main(void) {
	const int SUELDO_CAT_1 = 38000;
	const int SUELDO_CAT_2 = 70000;
	const int SUELDO_CAT_3 = 105000;
	const int BONIF_ANTIGUEDAD = 1200;
	const int EMPLEADOS = 6; // Cambiar por 50
	int empCat, empAnt;
	int empCat1 = 0, empCat2 = 0, empCat3 = 0;
	int tSueldos = 0, tSueldos1 = 0, tSueldos2 = 0, tSueldos3 = 0, sueldoPromedio;
	int catSueldoMax, sueldoMax = 0;

	system("cls");

	for(int i = 0; i<EMPLEADOS; i++) {
		int sueldoEmpleado;

		cout << "Categoria [1,2 o 3]: ";
		cin >> empCat;
		cout << "Antiguedad: ";
		cin >> empAnt;

		// Empleados para cada categoría
		// Total sueldos en $ por categoría
		// Total sueldos para calcular promedio
		switch(empCat){
			case 1:
				sueldoEmpleado = SUELDO_CAT_1 + (empAnt * BONIF_ANTIGUEDAD);
				empCat1++;
				tSueldos1 += sueldoEmpleado;
				tSueldos += sueldoEmpleado;
				break;
			case 2:
				sueldoEmpleado = SUELDO_CAT_2 + (empAnt * BONIF_ANTIGUEDAD);
				empCat2++;
				tSueldos2 += sueldoEmpleado;
				tSueldos += sueldoEmpleado;
				break;
			case 3:
				sueldoEmpleado = SUELDO_CAT_3 + (empAnt * BONIF_ANTIGUEDAD);
				empCat3++;
				tSueldos3 += sueldoEmpleado;
				tSueldos += sueldoEmpleado;
				break;
			default:
				cout << "La categoria ingresada no existe!" << endl;
				cout << "El programa se cerrará" << endl;
				system("pause");
				return 0;
		}

		// Sueldo Maximo y Categoria
		if(sueldoEmpleado > sueldoMax) {
			sueldoMax = sueldoEmpleado;
			catSueldoMax = empCat;
		}
	}

	sueldoPromedio = tSueldos / EMPLEADOS;

	cout << endl << "-------------------------------" << endl;
	cout << "\tRESULTADOS" << endl;
	cout << "-------------------------------" << endl;
	cout << "CANTIDAD DE EMPLEADOS" << endl;
	cout << "\t Categoria 1: " << empCat1 << endl;
	cout << "\t Categoria 2: " << empCat2 << endl;
	cout << "\t Categoria 3: " << empCat3 << endl;
	cout << "-------------------------------" << endl;
	cout << "SUELDOS POR CATEGORIA" << endl;
	cout << "\t Categoria 1: $" << tSueldos1 << endl;
	cout << "\t Categoria 2: $" << tSueldos2 << endl;
	cout << "\t Categoria 3: $" << tSueldos3 << endl;
	cout << "-------------------------------" << endl;
	cout << "SUELDO PROMEDIO" << endl;
	cout << "\t $" << sueldoPromedio << endl;
	cout << "-------------------------------" << endl;
	cout << "SUELDO MAXIMO" << endl;
	cout << "\t $" << sueldoMax << endl;
	cout << "\t Categoria: " << catSueldoMax << endl;
	cout << endl;

	system("pause");
	return 0;
	
}
