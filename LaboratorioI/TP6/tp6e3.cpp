#include <iostream>
using namespace std;
int main(void) {
  const int TOTAL = 3;
  int numeros[TOTAL] {};
  int menor;
  int repetido = 0;
  
  for(int i=0;i<TOTAL;i++) {
    cout << "["<<i+1<<"/"<<TOTAL<<"] Ingrese un número: ";
    cin >> numeros[i];
  }
  
  for(int i=0;i<TOTAL;i++) {
    if(i==0 || numeros[i] < menor) {
        menor = numeros[i];
    } else if (numeros[i] == menor) {
      repetido++;
    }
  }
  cout << "El menor fue el nro: " << menor << endl;
  if(repetido>0) {
    cout << "Total de veces repetido: " << repetido << endl;
  }
  return 0;
}
