#include <iostream>
using namespace std;

// Los datos de ejemplo estan disponibles en el excel

int minAHoras(int &min);
void mostrarNoRealizados(int vec[], int tiposEntre);

int main(void) {
  const int CLIENTES = 5;
  const int TIPOS_ENTRE = 10;
  int nEntre, nCliente, tipoEntre, tiempoEntre;

  // nFila = Cliente, nColumna = Tipo Entr., contenido = minutos
  int totalEntre[CLIENTES][TIPOS_ENTRE]{};
  int entreRealizados[TIPOS_ENTRE]{};

  cout << "Nro de entrenamiento: ";
  cin >> nEntre;

  while (nEntre != 0) {
    cout << "Nro Cliente [101-" << CLIENTES + 100 << "]: ";
    cin >> nCliente;
    cout << "Tipo de Entrenamiento [1-10]:";
    cin >> tipoEntre;
    cout << "Tiempo del Entrenamiento (minutos):";
    cin >> tiempoEntre;

    totalEntre[nCliente - 101][tipoEntre - 1] += tiempoEntre;

    cout << "Nro de entrenamiento: ";
    cin >> nEntre;
  }

  for (int i = 0; i < CLIENTES; i++) {
    int minEntrenados = 0;
    cout << "Cliente #" << i + 101 << endl;
    for (int j = 0; j < TIPOS_ENTRE; j++) {
      if (totalEntre[i][j] != 0) {
        cout << "\tTipo de Entrenamiento #" << j + 1 << " " << totalEntre[i][j]
             << " minutos" << endl;
        minEntrenados += totalEntre[i][j];
        entreRealizados[j]++;
      }
    }
    if (minEntrenados == 0) {
      cout << "\tEl cliente no realizo entrenamientos" << endl;
    } else {
      cout << "\tTiempo total entrenado: ";
      cout << minAHoras(minEntrenados) << " HS ";
      cout << minEntrenados << " min" << endl;
    }
    minEntrenados = 0; // resetear p/prox. cliente
  }

  cout << endl;
  cout << endl;
  mostrarNoRealizados(entreRealizados, TIPOS_ENTRE);

  system("pause");
  return 0;
}

int minAHoras(int &min) {
  int horas;
  horas = min / 60;

  // Como Se recibe la variable por referencia
  // Se modifica su valor segun los minutos que sobren
  min = min % 60;

  return horas;
}

// Recorrer Realizados para listar los que no se realizaron
void mostrarNoRealizados(int vec[], int tiposEntre) {
  cout << "Los entrenamientos que no realizo ningun cliente son:" << endl;
  for (int i = 0; i < tiposEntre; i++) {
    if (vec[i] == 0) {
      cout << "\t #" << i + 1 << endl;
    }
  }
}
