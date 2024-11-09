import os
from PIL import Image
def convertir_a_blanco_y_negro(ruta_imagen):
    imagen = Image.open(ruta_imagen)
    imagen_byn = imagen.convert('L')
    imagen_byn.save(ruta_imagen.replace('.jpg', '_byn.jpg'))
    return ruta_imagen.replace('.jpg', '_byn.jpg')
if __name__ == "__main__":
    ruta_base = os.path.dirname(os.path.abspath(__file__))
    ruta_imagen = os.path.join(ruta_base, 'copia_NUBEPRUEBA.jpg')
    ruta_imagen_byn = convertir_a_blanco_y_negro(ruta_imagen)
    print(f"Imagen convertida guardada como: {ruta_imagen_byn}")
