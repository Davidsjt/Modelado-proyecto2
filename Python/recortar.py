from PIL import Image, ImageDraw
import sys

def circulo_a_transparente(ruta_entrada):
    # Abrir la imagen usando la ruta de entrada y convertirla a modo RGBA (para agregar transparencia)
    imagen = Image.open(ruta_entrada).convert("RGBA")

    # Definir las dimensiones de la imagen y las coordenadas del centro del círculo
    ancho, altura = 4368, 2912
    centro_x, centro_y = 2184, 1456
    radio = 1324

    # Crear una máscara en escala de grises (L) con el mismo tamaño que la imagen
    # Esta máscara se usará para definir el área del círculo que queremos dejar visible
    mascara = Image.new("L", (ancho, altura), 0)
    dibujar = ImageDraw.Draw(mascara)
    
    # Dibujar un círculo blanco (relleno con 255) en la máscara que representa la zona visible
    dibujar.ellipse((centro_x - radio, centro_y - radio, centro_x + radio, centro_y + radio), fill=255)

    # Aplicar la máscara de transparencia a la imagen (lo que esté fuera del círculo será transparente)
    imagen.putalpha(mascara)

    # Guardar la imagen resultante en un archivo PNG llamado "salida-limpio.png"
    ruta_salida = "salida-limpio.png"
    imagen.save(ruta_salida, "PNG")
    print(f"Imagen guardada en {ruta_salida}")

# Verificar si el usuario proporcionó el archivo de entrada
if len(sys.argv) < 2:
    print("Uso: python recortar.py <archivo_entrada.jpg>")
else:
    # Obtener la ruta del archivo de entrada desde los argumentos de la línea de comandos
    ruta_entrada = sys.argv[1]
    circulo_a_transparente(ruta_entrada)


