Pasos para ejecutar el archivo detector imagen de manera correcta.
Nota: Esta ejecucición se realizó en un dispositivo Windows 10.

Paso 1: Tener instalado / Instalar Lazarus, una IDE que soporta Pascal. 
Puede ser descargado desde su sitio oficial: https://www.lazarus-ide.org/ 
Eliga la versión de su dispositivo.

Paso 2: Tener instalado / Instalar Python, lenguaje de programación.
Puede ser descargado desde su sitio oficial: https://www.python.org/downloads/
Elegir la versión más actual (3.13 hasta el momento).
Asegurarse de marcar la casilla: "Add Python to PATH"

Paso 3: Dirigirse a la terminal de su dispotivo y escribir: pip install Pillow

Paso 4: Abrir Lazarus y cerrar el primer proyecto que abre por default. 
Seleccionar Archivo --> Abrir y buscar el archivo DetectorImagen.pas
Al abrirlo se te abrira una pestaña preguntandote que tipo es.
Seleccionar: programa.

Paso 5: Una vez abierto el proyecto, ejecutar el archivo dandole click en la flecha verde.
Saldra una ventana preguntando la forma de compilación, 
por favor seleccione: Enable Dwarf 2 with sets

Paso 6: El programa se ejecutara, hará una copia de la imagén deseada a analizar
y convertira esa imágen en blanco y negro.

Paso 7: Si se quiere usar para diferente imagenes, debera modificar el archivo hasta abajo.
En donde dice nombre, colocar el nombre de la imagen a analizar.

Gracias.


