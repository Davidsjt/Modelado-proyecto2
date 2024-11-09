program algoritmoIN;

uses
  SysUtils, Classes, FPImage, FPReadPNG;
{
 Programa que calcula el indice de cobertura nubosa en una imagen.
 La imagen debe ser un archivo PNG con las nubes ya segmentadas.
}
const
  Color_Reset = #27'[0m';
  Color_Verde = #27'[32m';
var
  Image: TFPMemoryImage;  // Aquí se carga la imagen en memoria.
  Reader: TFPReaderPNG;   // Esto ayuda a leer archivos PNG.
  TotalPixels, CloudPixels: Integer;  // Contadores: total de píxeles y de píxeles nubosos.
  x, y: Integer;  // Coordenadas de los píxeles.
  PixelColor: TFPColor;  // Almacena el color de cada pixel.
  IndiceCobertura: Real;  // El índice final de cobertura nubosa.

begin
  // Se crea la imagen en memoria y el lector PNG.
  Image := TFPMemoryImage.Create(0, 0);
  Reader := TFPReaderPNG.Create;

  // Se lee la imagen desde el archivo png.
  Image.LoadFromFile('output_transparente.png', Reader);
  TotalPixels := Image.Width * Image.Height;  // Calculamos cuántos píxeles hay en total
  CloudPixels := 0;  // Empezamos con cero nubes contadas

  // Se recorren los pixeles de la imagen.
  for y := 0 to Image.Height - 1 do
    for x := 0 to Image.Width - 1 do
    begin
      PixelColor := Image.Colors[x, y];  // Se obtiene el color del pixel actual.

      // Se verifica si el pixel es claro (posiblemente una nube).
      if (PixelColor.red > 20000) and (PixelColor.green > 20000) and (PixelColor.blue > 20000) then
      begin
        // Se cuenta el píxel como "nuboso"
        CloudPixels := CloudPixels + 1;
      end;
    end;

  // Calcula el índice de cobertura nubosa.
  IndiceCobertura := CloudPixels / TotalPixels;
  WriteLn(Color_Verde, 'Índice de cobertura nubosa: ', IndiceCobertura:0:3, Color_Reset);

  // Se limpia la memoria usada, importante para evitar problemas
  Image.Free;
  Reader.Free;
end.

