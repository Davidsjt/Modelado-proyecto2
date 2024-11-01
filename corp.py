from PIL import Image

def make_black_transparent(input_file, output_file):
    img = Image.open(input_file).convert("RGBA")
    datas = img.getdata()

    new_data = []
    for item in datas:
        # Cambiar los píxeles negros (0, 0, 0) a transparentes
        if item[0] == 0 and item[1] == 0 and item[2] == 0:
            # Reemplazar con transparencia
            new_data.append((0, 0, 0, 0))
        else:
            new_data.append(item)

    img.putdata(new_data)
    img.save(output_file, "PNG")
    print(f"Imagen guardada con transparencia en {output_file}")

# Ejemplo de uso
if __name__ == "__main__":
    make_black_transparent("output_clean.png", "output_transparente.png")

