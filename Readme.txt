#Segundo Proyecto MYP 2025-1.
Proyecto que calcula el índice de cobertura nubosa a partir de imágenes.

Realizado por:
	- Flores Arriola Rafael Edson 423118018.
	- González Lucero Alan Uriel 320148204.
	- Ortega Medina David 319111866.
	- Rivera Soto Aline Daniela 320333035.

Siga las siguientes indicaciones para poder ejecutar este proyecto de manera adecuada.
(Nota este proyecto en su mayoría finalizado, fue probado en un dispositivo Windows 10, python 3.13 e intel 64 bits).

Primero. Necesita tener python instalado. Puede instalarlo desde su sitio oficial: https://www.python.org/downloads/
Nota: Recuerde agregar python a PATH.

Segundo. Necesita tener free pascal instalado. Puede instalarlo desde su sitio oficial: https://www.freepascal.org/download.html
Escoger la versión acorde a su sistema operativo.

Tercero. En la terminal de su sistema, escribir el siguiente comando: pip install Pillow.
Esto para tener instalado la biblioteca que se va a usar.

Cuarto. Toda imagen que quiera comprobar, deberá estar en la carpeta IMG. Ubicada en: Base_Prueba\IMG.
El listado de ímagenes tendrá el nombre de las imágenes disponibles en dicha carpeta.
Se le pide que actualice esa lista dependiendo de su uso para no tener que ir hasta IMG para ver el nombre del/los archivos.

Quinto. Dirigirse a la carpeta Base_Prueba y abrir el archivo DetectorImagen.pas.
Ir a la línea 75 y modificar el texto acorde a su sistema operativo.
(El comando con el que se ejecuta los archivos python en su dispositivo).

Sexto. En su terminal, ubicarse en la carpeta donde se encuentra el archivo cii.py.
Esto usualmente es con el comando cd nombreCarpeta\nombreCarpeta\...

Septimo. Para ejecutar el archivo, debe colocar el comando con el que se ejecutan los archivos python en su dispositivo.
Seguido de esto, el nombre de la ímagen a analizar (recuerde que es en formato jpg).
Finalmente, que es opcional, una bandera s o S. 
Ejemplos:
python cci.py ImagenNube.jpg
py cci.py ImagenNube2.jpg s
python cci.py ImagenNube3.jpg S.
Cualquier formato es valido.
Con la bandera la ímagen se convertira en blanco y negro.
Dicha imágen en blanco y negro será almacenada en IMG.
Las ímagenes png se crearán en esta misma carpeta.

Problemas, solución en windows.
¿Tuvo el problema que el comando fpc no se encontró?
Siga los siguientes pasos.
1. Tener ubicado la localidad de la carpeta donde se instalo free pascal.
2. Ubicar la carpeta bin\i386-win32. 
3. Dirigirse a la barra de busqueda en la parte inferior izquierda y buscar: Acerca de. 
4. Una vez en Acerca de, seleccionar Configuración avanzada del sistema.
5. En esa pestaña elegir Variables de entorno.
6. En el apartado de variables de usuario para Usuario, ubicar la variable Path.
7. Si instalo correctamente pyhton y lo incluyo ahí, seleccionar dicho rubro y darle editar.
8. Seleccionar nuevo y escribir la dirección de archivo donde se encuentra fcp.
9. Cerrar las dos pestañas con aceptar e intentar ejecución de vuelta.