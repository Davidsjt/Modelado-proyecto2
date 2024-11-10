program RecortarImagenCircular;

uses
  SysUtils, Classes, FPImage, FPReadJPEG, FPWriteBMP;
{
 Programa que colorea los pixeles fuera del circulo del color amarillo.
}

const
  NOMBRE_ARCHIVO_SALIDA = 'salida-limpio.bmp'; // Nombre del archivo de salida en formato BMP
  ANCHO_IMAGEN = 4368; // Ancho original de la imagen JPEG
  ALTURA_IMAGEN = 2912; // Altura original de la imagen JPEG
  CENTRO_CIRCULO_X = 2184; // Coordenada X del centro del círculo
  CENTRO_CIRCULO_Y = 1456; // Coordenada Y del centro del círculo
  RADIO_CIRCULO = 1324; // Radio del círculo que queremos recortar
  DIAMETRO_CIRCULO = RADIO_CIRCULO * 2; // Diámetro del círculo para el tamaño de la imagen recortada

{
 Procedimiento: RecortarCirculoBMP.
 Descripción: Recorta una imagen en un circulo y la guarda en formato BMP.
 Parámetros:
            -nombreArchivoEntrada (String): Nombre del archivo JPEG de entrada.
            -nombreArchivoSalida (String): Nombre del archivo BMP de salida.
}
procedure RecortarCirculoBMP(const nombreArchivoEntrada, nombreArchivoSalida: string);
var
  imagenJPEG: TFPMemoryImage; // Imagen JPEG original
  imagenBMP: TFPMemoryImage; // Imagen de salida en formato BMP
  lector: TFPReaderJPEG; // Lector de archivos JPEG
  escritor: TFPWriterBMP; // Escritor para archivos BMP
  x, y: Integer; // Variables para recorrer las coordenadas de la imagen
  colorPixel: TFPColor; // Color de cada pixel
  distanciaAlCentro: Double; // Distancia de un pixel al centro del círculo
  colorAmarillo: TFPColor; // Color amarillo para el fondo fuera del círculo
begin
  // Crear objetos para la imagen original, el lector JPEG y la imagen BMP de salida
  imagenJPEG := TFPMemoryImage.Create(ANCHO_IMAGEN, ALTURA_IMAGEN);
  lector := TFPReaderJPEG.Create;
  imagenBMP := TFPMemoryImage.Create(DIAMETRO_CIRCULO, DIAMETRO_CIRCULO); 
  escritor := TFPWriterBMP.Create;

  // Cargar la imagen JPEG desde el archivo
  imagenJPEG.LoadFromFile(nombreArchivoEntrada, lector);

  // Configurar la imagen BMP para no usar paleta de colores
  imagenBMP.UsePalette := False;

  // Definir el color amarillo (usado como fondo fuera del círculo)
  colorAmarillo.Red := $FFFF;
  colorAmarillo.Green := $FFFF;
  colorAmarillo.Blue := 0;
  colorAmarillo.Alpha := $FFFF;

  // Recorrer cada pixel dentro del área del círculo
  for y := 0 to DIAMETRO_CIRCULO - 1 do
  begin
    for x := 0 to DIAMETRO_CIRCULO - 1 do
    begin
      // Calcular la distancia del pixel actual al centro del círculo
      distanciaAlCentro := Sqrt(Sqr(x - RADIO_CIRCULO) + Sqr(y - RADIO_CIRCULO));

      // Si el pixel está dentro del círculo
      if distanciaAlCentro <= RADIO_CIRCULO then
      begin
        // Copiar el color del pixel desde la imagen JPEG original
        colorPixel := imagenJPEG.Colors[x + CENTRO_CIRCULO_X - RADIO_CIRCULO, y + CENTRO_CIRCULO_Y - RADIO_CIRCULO];
        imagenBMP.Colors[x, y] := colorPixel;
      end
      else
      begin
        // Si el pixel está fuera del círculo, asignar el color amarillo
        imagenBMP.Colors[x, y] := colorAmarillo;
      end;
    end;
  end;

  // Guardar la imagen recortada en el archivo BMP de salida
  imagenBMP.SaveToFile(nombreArchivoSalida, escritor);

  // Liberar memoria para los objetos creados
  lector.Free;
  escritor.Free;
  imagenJPEG.Free;
  imagenBMP.Free;

  WriteLn('La imagen se guardó en -> ', nombreArchivoSalida);
end;

begin
  // Verificar si el usuario proporcionó el nombre del archivo de entrada
  if ParamCount < 1 then
  begin
    WriteLn('Uso: ', ParamStr(0), ' <archivo_entrada.jpg>');
    Halt(1);
  end;

  // Llamar al procedimiento para recortar la imagen circular
  RecortarCirculoBMP(ParamStr(1), NOMBRE_ARCHIVO_SALIDA);
end.
