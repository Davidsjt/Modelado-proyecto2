program CropCircleImage;

uses
  SysUtils, Classes, FPImage, FPReadJPEG, FPWritePNG;

const
  OUTPUT_FILENAME = 'salida-limpio.png'; // Aquí es donde vamos a guardar la imagen final recortada
  IMAGE_WIDTH = 4368; // El ancho de la imagen original
  IMAGE_HEIGHT = 2912; // El alto de la imagen original
  CIRCLE_CENTER_X = 2184; // Coordenada X del centro de nuestro círculo
  CIRCLE_CENTER_Y = 1456; // Coordenada Y del centro de nuestro círculo
  CIRCLE_RADIUS = 1324; // Radio del círculo que queremos cortar
  CIRCLE_DIAMETER = CIRCLE_RADIUS * 2; // El diámetro del círculo, que será el tamaño de la imagen de salida

// Procedimiento para recortar el círculo y guardarlo con un fondo amarillo
procedure CropCircleToPNG(const inputFileName, outputFileName: string);
var
  jpegImage: TFPMemoryImage; // Imagen original en JPEG
  pngImage: TFPMemoryImage; // Imagen de salida en PNG
  reader: TFPReaderJPEG; // Lector para el archivo JPEG
  writer: TFPWriterPNG; // Escritor para el archivo PNG
  x, y: Integer; // Coordenadas de los píxeles
  pixelColor: TFPColor; // Color del píxel
  distanceFromCenter: Double; // Distancia del píxel al centro del círculo
  yellowColor: TFPColor; // Color amarillo para el fondo
begin
  // Inicializamos las imágenes y el lector/escritor
  jpegImage := TFPMemoryImage.Create(IMAGE_WIDTH, IMAGE_HEIGHT);
  reader := TFPReaderJPEG.Create;
  pngImage := TFPMemoryImage.Create(CIRCLE_DIAMETER, CIRCLE_DIAMETER); // Creamos la imagen de salida del tamaño del círculo
  writer := TFPWriterPNG.Create;

  // Cargamos la imagen JPEG que vamos a recortar
  jpegImage.LoadFromFile(inputFileName, reader);

  // Configuramos la imagen PNG para que tenga transparencia
  pngImage.UsePalette := False;

  // Definimos el color amarillo (en formato RGB)
  yellowColor.Red := $FFFF;
  yellowColor.Green := $FFFF;
  yellowColor.Blue := 0;
  yellowColor.Alpha := $FFFF;

  // Empezamos a copiar los píxeles del círculo desde la imagen original
  for y := 0 to CIRCLE_DIAMETER - 1 do
  begin
    for x := 0 to CIRCLE_DIAMETER - 1 do
    begin
      // Calculamos la distancia del píxel al centro del círculo
      distanceFromCenter := Sqrt(Sqr(x - CIRCLE_RADIUS) + Sqr(y - CIRCLE_RADIUS));

      // Si el píxel está dentro del círculo, copiamos su color de la imagen original
      if distanceFromCenter <= CIRCLE_RADIUS then
      begin
        // Ajustamos las coordenadas para que coincidan con la imagen original
        pixelColor := jpegImage.Colors[x + CIRCLE_CENTER_X - CIRCLE_RADIUS, y + CIRCLE_CENTER_Y - CIRCLE_RADIUS];
        pngImage.Colors[x, y] := pixelColor;
      end
      else
      begin
        // Si está fuera del círculo, lo pintamos de amarillo
        pngImage.Colors[x, y] := yellowColor;
      end;
    end;
  end;

  // Guardamos la imagen final en PNG
  pngImage.SaveToFile(outputFileName, writer);

  // Limpiamos todo para no dejar memoria ocupada
  reader.Free;
  writer.Free;
  jpegImage.Free;
  pngImage.Free;

  WriteLn('¡Listo! La imagen se guardó en ', outputFileName);
end;

begin
  // Si el usuario no especifica el archivo de entrada, mostramos cómo usar el programa
  if ParamCount < 1 then
  begin
    WriteLn('Uso: ', ParamStr(0), ' <archivo_entrada.jpg>');
    Halt(1);
  end;

  // Llamamos al procedimiento para recortar el círculo y guardarlo
  CropCircleToPNG(ParamStr(1), OUTPUT_FILENAME);
end.

