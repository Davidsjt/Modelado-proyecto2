program ContarPixelesNubes;

uses SysUtils;

type
  TRGBPixel = record
    B, G, R: Byte;
  end;

var
  BMPFile, OutFile: File;
  Pixel, OutputPixel: TRGBPixel;
  TotalPixeles, PixelesNubes: Int64; 
  Width, Height, x, y: Integer;
  DataOffset: LongInt;
  Header: array[1..54] of Byte; 
  Filename, OutFilename: String;
  Flag: Char;
  GenerarSegmentacion: Boolean;

function EsAmarillo(Color: TRGBPixel): Boolean;
begin
  EsAmarillo := (Color.R > 200) and (Color.G > 200) and (Color.B < 100);
end;

function EsBlanco(Color: TRGBPixel): Boolean;
begin
  EsBlanco := (Color.R > 200) and (Color.G > 200) and (Color.B > 200);
end;

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
    Writeln('Porcentaje de nubes: ', (PixelesNubes / TotalPixeles) * 100:0:2, '%')
  else
    Writeln('No hay píxeles para analizar.');
end.


