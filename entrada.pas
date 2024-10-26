program CloudCoverage;

uses
  SysUtils, Classes, Graphics, JPEG;

var 
  gname: string;
  flag: boolean;
  image: TJPEGImage;
  inputFileName: string;

begin
    flag := False;

    //Verfica si se pasaron argumentos
    if ParamCount < 1 then
    begin
      Writeln('Usage: CloudCoverage <imageFile> s(optional)')
    end;

    inputFileName := ParamStr(1);
    //Eliminar la extensión del archivo
    gname := ChangeFileExt(inputFileName, '');


    //Verficar si la imagen esta en el formato correcto
    if LowerCase(ExtractFileExt(inputFileName)) <> '.jpg' then
    begin
      Writeln('Error: La imagen debe ser JPEG, es decir, (.jpg)')
      Exit;
    end;
    
    //Comprobar si hay bandera "s"
    if ParamCount > 1 then
    begin
    if ParamStr(2) = 's' then
      flag := True;
    end;

    //Cargar la imagen
    image := TJPEGImage.Create;
    try
        image.LoadFromFile(inputFileName);

        //Aquí se 'limpia' la imagen y se aplica el filtro b/n

        //Si hay bandera
        if flag then
        begin
        //Guardar la imagen con el filtro b/n
        //imagen.SaveToFile(gname + '-seg.jpg');
        end;

    except
      on E: Exception do
      begin
        Writeln('Error en la carga de la imagen: ', E.Message);
        Exit;
      end;
    end;

    
end.