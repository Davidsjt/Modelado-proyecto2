import sys
from PIL import Image
import numpy as np

def calcular_indice_cobertura_nubosa(input_path, generar_imagen=False):
    '''
    Calcula el índice de cobertura nubosa en una imagen y opcionalmente genera una imagen segmentada.

    Argumentos:
        input_path (String): Ruta del archivo y de imagen de entrada.
        generar_imagen (boolean): Si es True, genera una imágen segmentada, en otro caso no.
    
    Return:
        float: Ínidce de cobertura nubosa.
        String: Ruta del archivo de la imagen segmentada (si se genera), None en caso contrario.
    '''

    #Abre la imagen para convertirla a formato RGBA.
    image = Image.open(input_path).convert("RGBA")
    data = np.array(image)

    #Se obtiene las dimensiones y el centro de la imagen.
    width, height = image.size
    center_x, center_y = width // 2, height // 2
    radius = min(center_x, center_y)

    #Se crea una máscara circular.
    y, x = np.ogrid[:height, :width]
    mask_circle = (x - center_x) ** 2 + (y - center_y) ** 2 <= radius ** 2
    circular_pixels = data[mask_circle]

    # Se calcula el brillo y la saturación.
    brightness = circular_pixels[:, :3].mean(axis=1)
    saturation = np.ptp(circular_pixels[:, :3], axis=1)
    is_cloud = (brightness > 20) & (saturation < 15) # Ajustar parametros según sea necesario.

    N = np.sum(is_cloud)  # Número de pixeles de nube.
    C = circular_pixels.shape[0] # Número total de píxeles en la máscara circular.
    cloud_coverage_index = (N / C * 100) if C > 0 else 0  # Índice de cobertura nubosa.

    output_path = None
    if generar_imagen:
        #Crear datos de segmentación.
        segmentation_data = np.zeros((height, width, 4), dtype=np.uint8)
        segmentation_data[..., 3] = data[..., 3]  # transparencia
        white, black = [255, 255, 255, 255], [0, 0, 0, 255]
        segmentation_data[mask_circle] = np.where(is_cloud[:, None], white, black)

        #Se almacena la imagen segmentada.
        output_path = input_path.replace(".png", "-seg.png")
        Image.fromarray(segmentation_data, 'RGBA').save(output_path)

    return cloud_coverage_index, output_path

if len(sys.argv) < 2:
    print("Uso: python algoritmoIN.py <ruta_de_imagen> [S]")
    sys.exit(1)

input_path = sys.argv[1]
generar_imagen = len(sys.argv) > 2 and sys.argv[2].lower() == "s"

indice_cobertura, output_path = calcular_indice_cobertura_nubosa(input_path, generar_imagen)
print(f"Índice de cobertura nubosa: {indice_cobertura:.2f}%")

if output_path:
    print(f"Imagen segmentada guardada en: {output_path}")
