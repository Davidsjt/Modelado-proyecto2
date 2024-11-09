from PIL import Image
import os

def make_black_transparent(input_file, output_file):
    """
    Función que convierte los píxeles negros de una imágen a transparentes.

    Args:
        input_file (str): Ruta del archivo de la imágen de entrada.
        output_file (str): Ruta del archiv de la ímagen de salida.
    """
    #Se abre la imágen y la convierte al modo RGBA.
    img = Image.open(input_file).convert("RGBA")
    datas = img.getdata()

    new_data = []
    for item in datas:
        # Cambiar los píxeles negros (0, 0, 0) a transparentes
        if item[0] < 50 and item[1] < 50 and item[2] < 50:  # Ajustar el valor 50 según sea necesario
            new_data.append((0, 0, 0, 0))
        else:
            new_data.append(item)
    #Actualiza los datos de la imagen con los nuevos datos.
    img.putdata(new_data)
    
    # Asegurar que la ruta de salida sea válida.
    output_file = os.path.abspath(output_file)
    # Guarda la imágen con los píxeles transparentes.
    img.save(output_file, "PNG")
    print(f"Imagen guardada con transparencia en {output_file}")

# Ejemplo de uso
if __name__ == "__main__":
    # Se ajustan las rutas de entrada y salida usando os.path
    input_file = os.path.abspath("output_clean.png")
    output_file = os.path.abspath("output_transparente.png")
    make_black_transparent(input_file, output_file)
