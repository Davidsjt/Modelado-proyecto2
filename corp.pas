program CropCircleImage;

uses
  SysUtils, Classes, FPImage, FPReadJPEG, FPWritePNG;

const
  OUTPUT_FILENAME = 'output_clean.png'; // Nombre del archivo de salida PNG
  IMAGE_WIDTH = 4368; // Ancho de la imagen de entrada
  IMAGE_HEIGHT = 2912; // Alto de la imagen de entrada
  CIRCLE_CENTER_X = 2184; // Coordenada X del centro del círculo en la imagen original
  CIRCLE_CENTER_Y = 1456; // Coordenada Y del centro del círculo en la imagen original
  CIRCLE_RADIUS = 1324; // Radio del círculo
  CIRCLE_DIAMETER = CIRCLE_RADIUS * 2; // Diámetro del círculo

procedure CropCircleToPNG(const inputFileName, outputFileName: string);
var
  jpegImage: TFPMemoryImage;
  pngImage: TFPMemoryImage;
  reader: TFPReaderJPEG;
  writer: TFPWriterPNG;
  x, y: Integer;
  pixelColor: TFPColor;
  distanceFromCenter: Double;
begin
  // Crear objetos de imagen y lector/escritor
  jpegImage := TFPMemoryImage.Create(IMAGE_WIDTH, IMAGE_HEIGHT);
  reader := TFPReaderJPEG.Create;
  pngImage := TFPMemoryImage.Create(CIRCLE_DIAMETER, CIRCLE_DIAMETER); // Tamaño de la imagen de salida igual al diámetro del círculo
  writer := TFPWriterPNG.Create;

  // Cargar la imagen JPEG de entrada
  jpegImage.LoadFromFile(inputFileName, reader);

  // Configurar PNG para soporte de transparencia
  pngImage.UsePalette := False;

  // Copiar el círculo visible desde la imagen de entrada y hacer los bordes transparentes
  for y := 0 to CIRCLE_DIAMETER - 1 do
  begin
    for x := 0 to CIRCLE_DIAMETER - 1 do
    begin
      // Calcular la distancia del píxel al centro del círculo en la imagen de salida
      distanceFromCenter := Sqrt(Sqr(x - CIRCLE_RADIUS) + Sqr(y - CIRCLE_RADIUS));

      // Si el píxel está dentro del círculo, copiar el color desde la imagen de entrada
      if distanceFromCenter <= CIRCLE_RADIUS then
      begin
        // Trasladar las coordenadas al sistema de la imagen original
        pixelColor := jpegImage.Colors[x + CIRCLE_CENTER_X - CIRCLE_RADIUS, y + CIRCLE_CENTER_Y - CIRCLE_RADIUS];
        pngImage.Colors[x, y] := pixelColor;
      end
      else
      begin
        // Poner color negro fuera del círculo
        pngImage.Colors[x, y] := FPColor(0, 0, 0, 65535); // Negro opaco
      end;
    end;
  end;

  // Guardar la imagen PNG de salida con bordes negros
  pngImage.SaveToFile(outputFileName, writer);

  // Liberar memoria
  reader.Free;
  writer.Free;
  jpegImage.Free;
  pngImage.Free;

  WriteLn('Imagen recortada guardada en ', outputFileName);
end;

begin
  if ParamCount < 1 then
  begin
    WriteLn('Uso: ', ParamStr(0), ' <archivo_entrada.jpg>');
    Halt(1);
  end;

  CropCircleToPNG(ParamStr(1), OUTPUT_FILENAME);
end.


