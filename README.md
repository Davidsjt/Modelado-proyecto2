# Cloud Coverage

## Integrantes del Equipo
* Flores Arriola Rafael Edson - 423118018.
* González Lucero Alan Uriel - 320148204.
* Ortega Medina David - 319111866.
* Rivera Soto Aline Daniela -320333035.

## Descripción
Esta es un programa desarrollado con PASCAL y Python que permite a los usuarios conocer el porcentaje de indice nuboso en la imagen dada y si lo requiere obtener la imagen con filtrada en blanco y negro.

## Explicación 
Originalmente el proyecto fué pensado en Pascal, sin embargo, nos topamos con muchas dificultades al usar las bibliotecas de Pascal. Muchas solo eran disponibles con el IDE Lazarus, nunca lo pudimos hacer funcionar en Linux, y en Windows funcionaba parcialmente. 

Logramos hacer una versión en Pascal que funciona bien (el índice lo calcula en 47.57%, cuando el que nos dio Ximena de ejemplo en 44.51%), pero la imagen la segmentada lo genera de una manera ineficiente. Para lograr el índice tuvimos que transformar la imagen en .bmp un tipo de archivo muy pesado, de otra manera no generaba la imagen correctamente. 

Por eso también hicimos una versión en Python que lo hace de una mejor manera en todos los aspectos, tanto en ejeccución, legibilidad del código y eficiencia del mismo. Logra calcular el índice de una manera más precisa y la imagen segmentada está más cerca de los requerimientos del proyecto.

## Estructura 
El proyecto se organiza en los siguientes archivos:

### -- Readme.md

### -- Readme.txt

### -- Python

### -- Pascal

La carpeta Python contiene:
   - algoritmoIN.py
   - recortar.py
   - 11838.jpg
La carpeta Pascal contiene:
   - algoritmoIN.pas
   - recortar.pas
   - 11838.jpg
### test
Podemos encontrar pruebas unitarias del código que se encarga de procesar la imagen y de calcular el indice nuboso.

## Requisitos

Leer Readme.txt para más información.

## Uso
Para ejecutar la aplicación, se debe tener  PASCAL y Python instalado. Luego, sigue estos pasos:

1. Clona el repositorio desde la terminal:

```bash
   $ git clone https://github.com/Davidsjt/Modelado-proyecto2.git
```

2. -- Sigue las instrucciones de el archivo Readme.txt

## Funcionalidades Principales
La aplicación en terminal ofrece las siguientes funcionalidades:

- Calculo del porcentaje de indice nuboso de la imagen dada (Pascal y Python).
- Aplicación de filtrado de blanco y negro a la imagen dada (Pascal y Python).

## Documentación: 

- PASCAL : https://www.freepascal.org/docs.html
- Python : https://docs.python.org/es/3/

# Roles de trabajo

* Daniela. Entrada 
* David. Implementación de Algoritmo
* Alan. Test
* Edson. Manejo de errores.

