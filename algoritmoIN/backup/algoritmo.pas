program CalculoIndiceCoberturaNubosa;

uses
  SysUtils, Graph, bmp;

const
  COLOR_BORDE = $FFFF00; // Amarillo
  COLOR_NUBE = $FFFFFF;  // Blanco
  COLOR_CIELO = $0000FF; // Azul
  COLOR_NEGRO = $000000; // Negro

type
  Imagen = record
    ancho, alto: Integer;
    datos: array of array of Integer;
  end;

function CargarImagen(ruta: string): Imagen;
var
  bmp: BMPFile;
  x, y: Integer;
begin
  bmp := BMPFile.Create(ruta);
  Result.ancho := bmp.Width;
  Result.alto := bmp.Height;
  SetLength(Result.datos, Result.ancho, Result.alto);

  for y := 0 to bmp.Height - 1 do
    for x := 0 to bmp.Width - 1 do
      Result.datos[x, y] := bmp.GetPixel(x, y);

  bmp.Free;
end;

procedure GuardarImagen(ruta: string; img: Imagen);
var
  bmp: BMPFile;
  x, y: Integer;
begin
  bmp := BMPFile.CreateNew(img.ancho, img.alto);

  for y := 0 to img.alto - 1 do
    for x := 0 to img.ancho - 1 do
      bmp.PutPixel(x, y, img.datos[x, y]);

  bmp.SaveToFile(ruta);
  bmp.Free;
end;

procedure GenerarImagenBlancoNegro(var img: Imagen);
var
  x, y, color: Integer;
  centroX, centroY, radio, distancia: Integer;
begin
  centroX := img.ancho div 2;
  centroY := img.alto div 2;
  radio := Min(centroX, centroY) - 1;

  for y := 0 to img.alto - 1 do
    for x := 0 to img.ancho - 1 do
    begin
      distancia := Round(Sqrt(Sqr(x - centroX) + Sqr(y - centroY)));
      
      if distancia <= radio then
      begin
        color := img.datos[x, y];
        
        // Mantener el borde amarillo
        if color = COLOR_BORDE then
          continue
        // Cielo a negro y nubes a blanco
        else if color = COLOR_CIELO then
          img.datos[x, y] := COLOR_NEGRO
        else if color = COLOR_NUBE then
          img.datos[x, y] := COLOR_NUBE
        else
          img.datos[x, y] := COLOR_NEGRO; // Otros colores a negro
      end
      else
        img.datos[x, y] := COLOR_BORDE; // Mantener el borde amarillo
    end;
end;

var
  img: Imagen;
  rutaEntrada, rutaSalida: string;
  bandera: Char;
begin
  rutaEntrada := 'entrada.bmp';
  rutaSalida := 'salida.bmp';
  
  img := CargarImagen(rutaEntrada);
  
  Write('¿Generar imagen en blanco y negro? (S/N): ');
  ReadLn(bandera);

  if UpCase(bandera) = 'S' then
  begin
    GenerarImagenBlancoNegro(img);
    GuardarImagen(rutaSalida, img);
    WriteLn('Imagen en blanco y negro generada en ', rutaSalida);
  end;
end.





