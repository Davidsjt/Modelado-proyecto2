program ContarPixelesNubes;

uses
  SysUtils;
{
  Programa enfocado al conteo de pixeles nubosos en una imagen BMP.
}

type
  TRGBPixel = record
    B, G, R: Byte;
  end;

var
  BMPFile, OutFile: File; //Archivos de entrada y salida BMP.
  Pixel, OutputPixel: TRGBPixel;  //Pixeles de entrada y salida.
  TotalPixeles, PixelesNubes: Int64; //Contadores de pixeles totales y de nubes.
  Width, Height, x, y: Integer; //Dimensiones y coordenadas de la imagen.   
  DataOffset: LongInt;  //Offset donde comeinzan los datos de la imagen.
  Header: array[1..54] of Byte; // Encabezado del archivo BMP.
  Filename, OutFilename: String; // Nombres de los archivos de entrada y salida.
  Flag: Char; // Bandera de opciones.
  GenerarSegmentacion: Boolean; // Indica si se debe generar la imagen segmentada.

{
  Función: EsAmarillo.
  Descripción: Verificia si un pixel es de color amarillo.
  Parámetros:
         - Color (TRGBPixel): El color del píxel a verificar.
  Return:
         - Boolean: Verdadero si el pixel es amarillo, falso en caso contrario.
}
function EsAmarillo(Color: TRGBPixel): Boolean;
begin
  EsAmarillo := (Color.R > 200) and (Color.G > 200) and (Color.B < 100);
end;

{
 Función: EsBlanco.
 Descripción: Verifica si un pixel es de color blanco.
 Parámetros:
            -Color (TRGBPixel): El color de píxel a verificar.
 Retorno:
            -Boolean: Verdadero si el píxel es blanco, falso en caso contrario.
}
function EsBlanco(Color: TRGBPixel): Boolean;
begin
  EsBlanco := (Color.R > 200) and (Color.G > 200) and (Color.B > 200);
end;

{
 Procedimiento: CargarDimensiones.
 Descripción: Carga las dimensiones de la imagen BMP.
}
procedure CargarDimensiones;
var
  bfType: Word;
begin
  Seek(BMPFile, 0);
  BlockRead(BMPFile, bfType, 2);
  
  if bfType <> $4D42 then
  begin
    Writeln('El archivo no es un BMP válido.');
    Halt;
  end;

  Seek(BMPFile, 10);
  BlockRead(BMPFile, DataOffset, 4);

  Seek(BMPFile, 18);
  BlockRead(BMPFile, Width, 4);
  BlockRead(BMPFile, Height, 4);
end;

{
 Procedimiento: ProcesarImagen.
 Descripción: Procesa la imagen BMP, contando los pixeles nubosos y genera la imagen segmentada si es necesario.
}
procedure ProcesarImagen;
begin
  Seek(BMPFile, DataOffset);
  if GenerarSegmentacion then
    Seek(OutFile, DataOffset);
  
  for y := 0 to Height - 1 do
  begin
    for x := 0 to Width - 1 do
    begin
      BlockRead(BMPFile, Pixel, 3);

      if not EsAmarillo(Pixel) then
      begin
        Inc(TotalPixeles);
        if EsBlanco(Pixel) then
        begin
          Inc(PixelesNubes);
          OutputPixel.R := 255;
          OutputPixel.G := 255;
          OutputPixel.B := 255;
        end
        else
        begin
          OutputPixel.R := 0;
          OutputPixel.G := 0;
          OutputPixel.B := 0;
        end;
      end
      else
      begin
        OutputPixel := Pixel;
      end;

      if GenerarSegmentacion then
        BlockWrite(OutFile, OutputPixel, 3);
    end;

    if (Width * 3) mod 4 <> 0 then
    begin
      Seek(BMPFile, FilePos(BMPFile) + (4 - (Width * 3) mod 4));
      if GenerarSegmentacion then
        Seek(OutFile, FilePos(OutFile) + (4 - (Width * 3) mod 4));
    end;
  end;
end;

begin
  //Se verifica si se ha proporcionado el nombre del archivo BMP.
  if ParamCount < 1 then
  begin
    Writeln('Uso: ContarPixelesNubes <archivo.bmp> [bandera]');
    Halt;
  end;

  Filename := ParamStr(1);
  if ParamCount >= 2 then
    Flag := ParamStr(2)[1]
  else
    Flag := 'N';  

  GenerarSegmentacion := (Flag = 'S') or (Flag = 's');
  OutFilename := ChangeFileExt(Filename, '-seg.bmp');

  Assign(BMPFile, Filename);
  {$I-}
  Reset(BMPFile, 1);
  {$I+}
  if IOResult <> 0 then
  begin
    Writeln('Error al abrir el archivo BMP.');
    Halt;
  end;

  if GenerarSegmentacion then
  begin
    Assign(OutFile, OutFilename);
    Rewrite(OutFile, 1);
    
    Seek(BMPFile, 0);
    BlockRead(BMPFile, Header, SizeOf(Header));
    BlockWrite(OutFile, Header, SizeOf(Header));
  end;

  CargarDimensiones;

  TotalPixeles := 0;
  PixelesNubes := 0;

  ProcesarImagen;

  Close(BMPFile);
  if GenerarSegmentacion then
    Close(OutFile);

  if TotalPixeles > 0 then
  Writeln(#27'[32mPorcentaje de nubes: ', (PixelesNubes / TotalPixeles) * 100:0:2, '%', #27'[0m')
  else
    Writeln('No hay píxeles para analizar.');
end.
