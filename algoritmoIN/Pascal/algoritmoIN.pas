program CloudCoverageIndex;

uses
  SysUtils, FPImage, FPReadPNG;

const
  WhiteThreshold = 20; // Umbral para considerar un píxel como nube
  YellowThreshold = 180; // Umbral para detectar el color amarillo

var
  Image: TFPMemoryImage;
  Reader: TFPReaderPNG;
  TotalPixels: Integer;
  CloudPixels: Integer;
  CoverageIndex: Real;
  X, Y: Integer;
  PixelColor: TFPColor;

begin
  // Crear la imagen y el lector de PNG
  Image := TFPMemoryImage.Create(0, 0);
  Reader := TFPReaderPNG.Create;

  // Cargar la imagen PNG
  Image.LoadFromFile('salida-limpio.png', Reader);

  // Inicializar los contadores
  TotalPixels := 0;
  CloudPixels := 0;

  // Recorrer cada píxel de la imagen
  for Y := 0 to Image.Height - 1 do
  begin
    for X := 0 to Image.Width - 1 do
    begin
      // Obtener el color del píxel
      PixelColor := Image.Colors[X, Y];

      // Ignorar los píxeles amarillos
      if (PixelColor.red > YellowThreshold) and
         (PixelColor.green > YellowThreshold) and
         (PixelColor.blue < YellowThreshold) then
      begin
        Continue; // Saltar este píxel
      end;

      // Contar este píxel
      Inc(TotalPixels);

      // Verificar si el píxel es blanco, considerando el umbral para nubes
      if (PixelColor.red > WhiteThreshold) and
         (PixelColor.green > WhiteThreshold) and
         (PixelColor.blue > WhiteThreshold) then
      begin
        Inc(CloudPixels); // Contar el píxel como nube
      end;
    end;
  end;

  // Calcular el índice de cobertura nubosa
  if TotalPixels > 0 then
    CoverageIndex := CloudPixels / TotalPixels
  else
    CoverageIndex := 0;

  // Mostrar el resultado
  WriteLn('Índice de cobertura nubosa: ', CoverageIndex:0:4);

  // Liberar recursos
  Image.Free;
  Reader.Free;

end.


