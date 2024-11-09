program CropCircleImage;

uses
  SysUtils, Classes, FPImage, FPReadJPEG, FPWritePNG;

{
 Este programa recorta un circulo de una ímagen JPEG y almacena el resultado.
 La imahen de salida tendrá transparencia fuera del circulo.
}

const
  OUTPUT_FILENAME = 'output_clean.png'; // Nombre del archivo donde se guardará la imagen recortada
  IMAGE_WIDTH = 4368; // Ancho de la imagen original
  IMAGE_HEIGHT = 2912; // Alto de la imagen original
  CIRCLE_CENTER_X = 2184; // Coordenada X del centro del círculo que queremos recortar
  CIRCLE_CENTER_Y = 1456; // Coordenada Y del centro del círculo
  CIRCLE_RADIUS = 1324; // Radio del círculo que queremos extraer
  CIRCLE_DIAMETER = CIRCLE_RADIUS * 2; // El diámetro del círculo, o sea, ancho y alto de la imagen de salida

{
 Procedimiento: CropCircleToPNG
 Descripción: Recorta un circulo de una ímagen JPEG y almacena el resultado en formato PNG.
 Parámetros:
            -inputFileName (const: String): Nombre del archivo de entrada JPEG.
            -outoutFileName (const: String): Nombre del archivo de salida PNG
}
procedure CropCircleToPNG(const inputFileName, outputFileName: string);
var
  jpegImage: TFPMemoryImage; // Imagen original en JPEG
  pngImage: TFPMemoryImage; // Imagen de salida en PNG
  reader: TFPReaderJPEG; // Lector para archivos JPEG
  writer: TFPWriterPNG; // Escritor para archivos PNG
  x, y: Integer; // Coordenadas de los píxeles
  pixelColor: TFPColor; // Color del píxel
  distanceFromCenter: Double; // Distancia del píxel al centro del círculo
begin
  // Crear los objetos de imagen y lector/escritor
  jpegImage := TFPMemoryImage.Create(IMAGE_WIDTH, IMAGE_HEIGHT);
  reader := TFPReaderJPEG.Create;
  pngImage := TFPMemoryImage.Create(CIRCLE_DIAMETER, CIRCLE_DIAMETER); // La imagen de salida será del tamaño del círculo
  writer := TFPWriterPNG.Create;

  // Cargar la imagen JPEG que se va a recortar
  jpegImage.LoadFromFile(inputFileName, reader);

  // Configurar la imagen PNG para que pueda tener transparencia
  pngImage.UsePalette := False;

  // Empezamos a copiar solo el círculo desde la imagen original
  for y := 0 to CIRCLE_DIAMETER - 1 do
  begin
    for x := 0 to CIRCLE_DIAMETER - 1 do
    begin
      // Calculamos qué tan lejos está el píxel actual del centro del círculo
      distanceFromCenter := Sqrt(Sqr(x - CIRCLE_RADIUS) + Sqr(y - CIRCLE_RADIUS));

      // Si el píxel está dentro del radio del círculo, copiamos el color de la imagen original
      if distanceFromCenter <= CIRCLE_RADIUS then
      begin
        // Ajustamos las coordenadas para que coincidan con la imagen original
        pixelColor := jpegImage.Colors[x + CIRCLE_CENTER_X - CIRCLE_RADIUS, y + CIRCLE_CENTER_Y - CIRCLE_RADIUS];
        pngImage.Colors[x, y] := pixelColor;
      end
      else
      begin
        // Si está fuera del círculo, lo dejamos transparente o negro
        pngImage.Colors[x, y] := colTransparent;
      end;
    end;
  end;

  // Guardamos la imagen recortada en formato PNG
  pngImage.SaveToFile(outputFileName, writer);

  // Limpiamos todo para liberar memoria
  reader.Free;
  writer.Free;
  jpegImage.Free;
  pngImage.Free;

  WriteLn('Imagen recortada guardada en ', outputFileName);
end;

begin
  // Si el usuario no especifica el archivo de entrada, mostramos un mensaje de uso
  if ParamCount < 1 then
  begin
    WriteLn('Uso: ', ParamStr(0), ' <archivo_entrada.jpg>');
    Halt(1);
  end;

  // Llamamos al procedimiento para recortar el círculo y guardarlo
  CropCircleToPNG(ParamStr(1), OUTPUT_FILENAME);
end.



