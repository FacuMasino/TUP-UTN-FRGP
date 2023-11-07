# Programacion II - Parcial 2 - Memoria Dinamica y Sobrecarga de operadores

## Punto 1
Generar un archivo con las ventas realizadas para el código de tour 11. Cada registro debe tener el número de venta, el número de cliente y el nombre del cliente.

## Punto 2
Hacer una función que cree un vector dinámico para cargar los registros del archivo generado en el punto 1.

Mostrar los registros del vector.

## Punto 3
Hacer una sobrecarga de operador para la clase nueva del punto 1 que sea útil para la resolución de alguno de los puntos.

## Punto 4
Teniendo en cuenta que los objetos Pila y Cola del programa tienen un funcionamiento idéntico al definido para ese tipo de estructura de datos Informar que imprime por pantalla el siguiente código. Colocar en la respuesta TODOS LOS NUMEROS JUNTOS SIN ESPACIOS NI SEPARADORES
```cpp
int main(){
    Pila a(5);
    Pila b(3);
    int x, val;
    x=1;

    while(a.Agregar(x))x++;
    while(a.Sacar(val)){
        b.Agregar(val);
    }
    while(b.Sacar(x))cout<<x;

	cout<<endl;
	system("pause");
	return 0;
}
```

Respuesta correcta: 345