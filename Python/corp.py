from PIL import Image, ImageDraw

def circle_to_transparent(input_path, output_path):
    image = Image.open(input_path).convert("RGBA")

    width, height = 4368, 2912
    center_x, center_y = 2184, 1456
    radius = 1324

    mask = Image.new("L", (width, height), 0)
    draw = ImageDraw.Draw(mask)
 
    draw.ellipse((center_x - radius, center_y - radius, center_x + radius, center_y + radius), fill=255)    

    image.putalpha(mask)

    image.save(output_path, "PNG")
    print(f"Imagen guardada en {output_path}")


input_path = "11838.jpg"
output_path = "salida-limpio.png"

circle_to_transparent(input_path, output_path)

