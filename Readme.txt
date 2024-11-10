# Segundo proyecto de Modelado y Programación. 2025-1.

Integrantes del equipo:
- Flores Arriola Rafael Edson - 423118018.
- González Lucero Alan Uriel - 320148204.
- ortega medina david - 319111866.
- Rivera Soto Aline Daniela -320333035.

Pasos para ejecutar este proyecto.
(Esta ejecución se realizó en un dispositivo Windows 10, intel de 64 bits y con python version 3.13).

Siga las siguientes indicaciones para poder ejecutar este proyecto de manera adecuada.
(Nota este proyecto en su mayoría finalizado, fue probado en un dispositivo Windows 10, python 3.13 e intel 64 bits).

Primero. Necesita tener Python instalado. Puede instalarlo desde su sitio oficial: https://www.python.org/downloads/
Nota: Recuerde agregar python a PATH.

Segundo. Necesita tener free pascal instalado. Puede instalarlo desde su sitio oficial: https://www.freepascal.org/download.html
Elija la versión acorde a su sistema operativo.

Tercero. En la terminal de su sistema, escriba el siguiente comando: pip install Pillow numpy.
Esto para tener instaladas las biblioteca que se van a usar.

Cuarto. Toda imagen que quiera comprobar, deberá estar en las carpetas Python y Pacal. 
El listado de imágenes tendrá el nombre de las imágenes disponibles en dichas carpeta.
Se le pide que actualice esa lista dependiendo de su uso para no tener que ir hasta dichas carpetas para ver que nombres pueden usar.

Quinto. En su terminal, ubíquese en la carpeta donde se encuentra el archivo cii.py.
Esto usualmente es con el comando cd nombreCarpeta\nombreCarpeta\...

Sexto. Para ejecutar el archivo, debe colocar el comando con el que se ejecutan los archivos python en su dispositivo.
Seguido de esto, el nombre de la imagen a analizar (recuerde que está en formato jpg).
Esto ÚNICAMENTE si no se va a hacer uso de una bandera.
Ejemplos:
Python cci.py ImagenNube.jpg. (Recuerde que la primer palabra esta asociada a su propio sistema operativo).

Ahora si se quiere usar con bandera, tiene que escribir lo siguiente: fpc recortar.pas && recortar.exe 11838.jpg && fpc algoritmoIN.pas && algoritmoIN.exe salida-limpio.bmp S

Con la bandera la imagen se convertirá en blanco y negro.

Las imagenes generadas con o sin bandera se crearán en este mismo directorio. Las imagenes con bandera, se generarán en la carpeta Pascal.

Problemas, solución en windows.
¿Tuvo el problema que el comando fpc no se encontró?
Siga los siguientes pasos.
1. Tener ubicado la localidad de la carpeta donde se instala free pascal.
2. Ubicar la carpeta bin\i386-win32.
3. Dirigirse a la barra de busqueda en la parte inferior izquierda y buscar: Acerca de.
4. Una vez en Acerca de, seleccione Configuración avanzada del sistema.
5. En esa pestaña elija Variables de entorno.
6. En el apartado de variables de usuario para Usuario, ubicar la variable Ruta.
7. Si instala correctamente pyhton y lo incluyo ahí, seleccione dicho rubro y darle editar.
8. Seleccione nuevo y escriba la dirección de archivo donde se encuentra fcp.
9. Cerrar las dos pestañas con aceptar e intentar ejecución de vuelta.