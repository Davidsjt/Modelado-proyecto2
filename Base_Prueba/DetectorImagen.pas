{$mode objfpc} // Activa el modo OO

program DetectorImagen;

uses
  SysUtils, Classes, Process;

function ObtenerRutaBase: string;
begin
  ObtenerRutaBase := ExtractFilePath(ParamStr(0));
end;

function ExisteImagen(nombreArchivo: string): boolean;
var
  rutaBase, rutaCompleta: string;
begin
  rutaBase := ObtenerRutaBase + 'IMG' + PathDelim;
  rutaCompleta := rutaBase + nombreArchivo;
  ExisteImagen := FileExists(rutaCompleta);
end;

{
 Procedimiento: VisualizarExistencia.
 Descripción: Te hace ver si el archivo está en la carpeta IMG.
 Parámetros:
   -nombreArchivo: El nombre del archivo a buscar.
}
procedure VisualizarExistencia(nombreArchivo: string);
begin
  if ExisteImagen(nombreArchivo) then
    writeln('La imagen ', nombreArchivo, ' se encuentra en la carpeta IMG.')
  else
    writeln('La imagen ', nombreArchivo, ' no se encuentra en la carpeta IMG.');
end;

{
 Procedimiento: CopiarArchivo.
 Descripción: Copia el archivo indicado.
 Parámetros:
   -archivoOrigen: El contenido archivo original.
   -archivoDestino: El contenido que copia al archivo original.
}
procedure CopiarArchivo(archivoOrigen, archivoDestino: string);
var
  fuente, destino: TFileStream;
begin
  fuente := TFileStream.Create(archivoOrigen, fmOpenRead);
  try
    destino := TFileStream.Create(archivoDestino, fmCreate);
    try
      destino.CopyFrom(fuente, fuente.Size);
      writeln('Copia de archivo completada: ', archivoDestino);
    finally
      destino.Free;
    end;
  finally
    fuente.Free;
  end;
end;

{
 Procedimiento: GuardarScriptPython.
 Descripción: Guarda el script de python en la ruta especificada.
 Parámetros:
   -rutaScript: La ruta en la que el archivo se guardará.

}
procedure GuardarScriptPython(rutaScript: string);
var
  scriptFile: TextFile;
begin
  AssignFile(scriptFile, rutaScript);
  Rewrite(scriptFile);
  WriteLn(scriptFile, 'import os');
  WriteLn(scriptFile, 'from PIL import Image');
  WriteLn(scriptFile, 'def convertir_a_blanco_y_negro(ruta_imagen):');
  WriteLn(scriptFile, '    imagen = Image.open(ruta_imagen)');
  WriteLn(scriptFile, '    imagen_byn = imagen.convert("L")');
  WriteLn(scriptFile, '    imagen_byn.save(ruta_imagen.replace(".jpg", "_byn.jpg"))');
  WriteLn(scriptFile, '    return ruta_imagen.replace(".jpg", "_byn.jpg")');
  WriteLn(scriptFile, 'if __name__ == "__main__":');
  WriteLn(scriptFile, '    ruta_base = os.path.dirname(os.path.abspath(__file__))');
  WriteLn(scriptFile, '    ruta_imagen = os.path.join(ruta_base, "copia_" + os.path.basename(ruta_imagen))');
  WriteLn(scriptFile, '    ruta_imagen_byn = convertir_a_blanco_y_negro(ruta_imagen)');
  WriteLn(scriptFile, '    print(f"Imagen convertida guardada como: {ruta_imagen_byn}")');
  CloseFile(scriptFile);
end;

{
 Procedimiento: EjecutarPythonScript.
 Descripción: Ejecuta el cript usando el comando py y espera a que el proceso termine.
 Parámetro:
   -script: El script a ejecutar.
}
procedure EjecutarPythonScript(script: string);
var
  proceso: TProcess;
begin
  proceso := TProcess.Create(nil);
  try
    proceso.Executable := 'py';  // Se usa 'py' para ejecutarlo en la terminal.
    proceso.Parameters.Add(script);
    proceso.Options := [poWaitOnExit];
    proceso.Execute;
  finally
    proceso.Free;
  end;
end;

{
 Procedimiento: CopiarImagen.
 Descripción: Verifica si la imagen original existe. Si existe lo copia.
 Parámetros:
   -nombreArchivo: El nombre del archivo a copiar.
}
procedure CopiarImagen(nombreArchivo: string);
var
  rutaBase, rutaCompleta, rutaCopia: string;
begin
  rutaBase := ObtenerRutaBase + 'IMG' + PathDelim;
  rutaCompleta := rutaBase + nombreArchivo;
  rutaCopia := rutaBase + 'copia_' + nombreArchivo;

  if FileExists(rutaCompleta) then
  begin
    CopiarArchivo(rutaCompleta, rutaCopia);
    writeln('La imagen ', nombreArchivo, ' ha sido copiada como ', 'copia_', nombreArchivo);
  end
  else
    writeln('No se pudo copiar la imagen ', nombreArchivo, ' porque no se encontró.');
end;

{
 Procedimiento: ConvertirImagenConPython
 Descripción: Se almacena el script y convierte la imagen copia a blanco y negro.
}
procedure ConvertirImagenConPython(nombreArchivo: string);
var
  rutaBase, rutaPythonScript: string;
begin
  rutaBase := ObtenerRutaBase + 'IMG' + PathDelim;
  rutaPythonScript := rutaBase + 'convertir_imagen.py';

  if FileExists(rutaBase + 'copia_' + nombreArchivo) then
  begin
    // Guarda el script en la misma carpeta
    GuardarScriptPython(rutaPythonScript);

    // Ejecuta el script
    EjecutarPythonScript(rutaPythonScript);
  end
  else
    writeln('No se pudo encontrar la imagen para convertir a blanco y negro.');
end;

var
  nombre: string;

begin
  if ParamCount < 1 then
  begin
    writeln('Uso: DetectorImagen <nombre_archivo.jpg>');
    exit;
  end;

  nombre := ParamStr(1);  // Get the image name from the command-line argument

  writeln('Haciendo una copia de la imagen...');
  CopiarImagen(nombre);

  writeln('Convirtiendo la imagen a blanco y negro...');
  ConvertirImagenConPython(nombre);

  Readln;
end.


