program algoritmoIN;

uses
  SysUtils, Classes, FPImage, FPReadPNG;

var
  Image: TFPMemoryImage;  // Aquí cargamos la imagen en memoria
  Reader: TFPReaderPNG;   // Esto nos ayuda a leer archivos PNG
  TotalPixels, CloudPixels: Integer;  // Contadores: total de píxeles y de píxeles nubosos
  x, y: Integer;  // Coordenadas de los píxeles
  PixelColor: TFPColor;  // Para guardar el color de cada píxel
  IndiceCobertura: Real;  // El índice final de cobertura nubosa

begin
  // Cargar la imagen en memoria
  Image := TFPMemoryImage.Create(0, 0);
  Reader := TFPReaderPNG.Create;

  // Leemos la imagen desde el archivo PNG
  Image.LoadFromFile('output_transparente.png', Reader);
  TotalPixels := Image.Width * Image.Height;  // Calculamos cuántos píxeles hay en total
  CloudPixels := 0;  // Empezamos con cero nubes contadas

  // Recorremos cada píxel de la imagen
  for y := 0 to Image.Height - 1 do
    for x := 0 to Image.Width - 1 do
    begin
      PixelColor := Image.Colors[x, y];  // Obtenemos el color del píxel actual

      // Chequeamos si el píxel es "claro", o sea, podría ser una nube
      if (PixelColor.red > 20000) and (PixelColor.green > 20000) and (PixelColor.blue > 20000) then
      begin
        // Contamos el píxel como "nuboso"
        CloudPixels := CloudPixels + 1;
      end;
    end;

  // Calculamos el índice de cobertura de nubes
  IndiceCobertura := CloudPixels / TotalPixels;
  WriteLn('Índice de cobertura nubosa: ', IndiceCobertura:0:3);  

  // Limpiamos la memoria, importante para evitar problemas
  Image.Free;
  Reader.Free;
end.

