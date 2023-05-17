#include <iostream>
#include <iomanip>
using namespace std;

int main(void) {
	int nLegajo, nTurno, cantHoras; // cin
	char horario; // cin
	int IndivHorasTN, IndivTotalTN; // A
	int totalHsExtra = 0; // B
	bool hizoTManiana, hizoTTarde, hizoTNoche; // C
	int totalCon3T = 0; // C
	int totalHsTM = 0, totalHsTT = 0, totalHsTN = 0; // D

	system("cls");
	cout << fixed << setprecision(1);

	cout << "#############################" << endl;
	cout << "########   CLINICA   ########" << endl;
	cout << "########  SAN SIMON  ########" << endl;
	cout << "########  PROTECTOR  ########" << endl;
	cout << "#############################" << endl;
	cout << "\n\n";

	cout << "Nro de Legajo(1000-15000): ";
	cin >> nLegajo;

	while(nLegajo > 0) {

		IndivHorasTN = 0; // A, Inicializo horas del enfermero, T.Noche
		IndivTotalTN = 0; // A, Inicializo total de Turnos del enfermero, T.Noche

		hizoTManiana = false;
		hizoTTarde = false;
		hizoTNoche = false;

		cout << "Nro de Turno: ";
		cin >> nTurno;

		while(nTurno != 0) {
			cout << "Horario (M, T, N): ";
			cin >> horario;
			cout << "Horas trabajadas: ";
			cin >> cantHoras;

			switch(horario) {
				case 'M':
				case 'm':
					// C
					if(!hizoTManiana) {
						hizoTManiana = true;
					}
					// D
					totalHsTM += cantHoras;
					break;
				case 'T':
				case 't':
					// C
					if(!hizoTTarde) {
						hizoTTarde = true;
					}
					// D
					totalHsTT += cantHoras;
					break;
				case 'N':
				case 'n':
					// A
					IndivHorasTN += cantHoras;
					IndivTotalTN++;
					// C
					if(!hizoTNoche) {
						hizoTNoche = true;
					}
					// D
					totalHsTN += cantHoras;
					break;
				default:
					cout << endl << horario << " NO ES UN HORARIO VALIDO, EL PROGRAMA SE CERRARA." << endl;

					system("pause");
					return 0;
			}

			// B
			if(cantHoras > 8) {
				totalHsExtra += cantHoras - 8;
			}

			cout << "Nro de Legajo(1000-15000): ";
			cin >> nLegajo;
			cout << "Nro de Turno: ";
			cin >> nTurno;

		}

		// A
		cout << "\n\nA) Enfermero Legajo Nro " << nLegajo << endl;
		cout << "\t Promedio de Horas x Turno Horario Noche: ";
		if(IndivHorasTN > 0) {
			cout << (float) IndivHorasTN/IndivTotalTN << endl;
		} else {
			cout << "No trabajo en este turno." << endl;
		}
		cout << "--------------------------------------------------------------------------------------" << endl;

		// C, si hizo los 3 horarios, se suma
		if(hizoTManiana && hizoTTarde && hizoTNoche) {
			totalCon3T++;
		}

		cout << endl;
		cout << "Nro de Legajo(1000-15000): ";
		cin >> nLegajo;

	}

	cout << "\n\n";
	cout << "############################" << endl;
	cout << "########            ########" << endl;
	cout << "######## RESULTADOS ########" << endl;
	cout << "########            ########" << endl;
	cout << "############################" << endl;
	cout << "\n\n";

	// B
	cout << "B) Cantidad total hs extras entre todos: " << totalHsExtra << endl;

	// C
	cout << "C) Cantidad de enfermeros con turnos en los 3 horarios: " << totalCon3T << endl;

	// D
	cout << "D) El horario con menor cantidad de horas trabajadas es: ";
	if(totalHsTM < totalHsTT && totalHsTM < totalHsTN) {
		cout << "Turno Maniana";
	} else if (totalHsTT < totalHsTM && totalHsTT < totalHsTN) {
		cout << "Turno Tarde";
	} else {
		cout << "Turno Noche";
	}
	cout << endl << endl;

	system("pause");
	return 0;
}