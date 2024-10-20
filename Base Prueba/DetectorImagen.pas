program DetectorImagen;
uses
    SysUtils;

function ObtenerRutaBase: string;
begin
    ObtenerRutaBase := ExtractFilePath(ParamStr(0))
end;

function ExisteImagen(nombreArchivo: string): boolean;
var
    rutaBase, rutaCompleta: string;
begin
    rutaBase := ObtenerRutaBase + 'IMG' + PathDeLim;
    rutaCompleta := rutaBase + nombreArchivo;
    ExisteImagen := FileExists(rutaCompleta);
end;

procedure VisualizarExistencia(nombreArchivo: string);
begin
  if ExisteImagen(nombreArchivo) then
    writeln('La imagen ', nombreArchivo, ' se encuentra en la carpeta IMG.')
  else 
    writeln('La imagen ' , nombreArchivo, ' no se encuentra en la carpeta IMG.');
end;

var
    nombre, nombreReal: string;
begin
  nombre := 'NUBESPRUEBA.jpg';
  nombreReal := 'NUBEPRUEBA.jpg';
  VisualizarExistencia(nombre);
  VisualizarExistencia(nombreReal);
end.