program AlgoritmoNubosidad;

uses
  Classes, SysUtils, FPImage, FPReadJPEG, FPWriteJPEG, Math;

var
  img, imgBW: TFPMemoryImage;
  readerJPEG: TFPReaderJPEG;
  writerJPEG: TFPWriterJPEG;
  i, j, cx, cy, radio: Integer;
  cloudThreshold, ratio, CCI: Double;
  pelcolor: TFPColor;
  cloudPixels, totalPixels: Integer;
  inputFileName, outputFileName: string;
  isSegmentation: Boolean;

function IsWithinCircle(x, y, cx, cy, radius: Integer): Boolean;
begin
  IsWithinCircle := Sqr(x - cx) + Sqr(y - cy) <= Sqr(radius);
end;

begin
  if ParamCount < 1 then
  begin
    WriteLn('Error: falta el nombre del archivo de imagen como parámetro.');
    Halt(1);
  end;

  inputFileName := ParamStr(1);
  isSegmentation := (ParamCount > 1) and ((ParamStr(2) = 'S') or (ParamStr(2) = 's'));
  cloudThreshold := 1.5; 
  cx := 2184;            
  cy := 1456;             
  radio := 1324;           

  WriteLn('Inicio del programa de cálculo de nubosidad...');
  WriteLn('Umbral de nube establecido en: ', cloudThreshold:0:2);

  if not FileExists(inputFileName) then
  begin
    WriteLn('Error: el archivo de imagen no existe.');
    Halt(1);
  end;

  WriteLn('Cargando la imagen...');
  img := TFPMemoryImage.Create(0, 0);
  imgBW := TFPMemoryImage.Create(0, 0);

  readerJPEG := TFPReaderJPEG.Create;
  writerJPEG := TFPWriterJPEG.Create;

  img.LoadFromFile(inputFileName, readerJPEG);

  imgBW.SetSize(img.Width, img.Height);

  WriteLn('Imagen cargada correctamente.');

  cloudPixels := 0;
  totalPixels := 0;
  WriteLn('Analizando los píxeles de la imagen...');

  for i := Max(0, cx - radio) to Min(img.Width - 1, cx + radio) do
  begin
    for j := Max(0, cy - radio) to Min(img.Height - 1, cy + radio) do
    begin
      if IsWithinCircle(i, j, cx, cy, radio) then
      begin
        pelcolor := img.Colors[i, j];
        ratio := pelcolor.Red / (pelcolor.Blue + 1);  
        
        if ratio > cloudThreshold then
        begin
          Inc(cloudPixels);
          imgBW.Colors[i, j] := colWhite;
        end
        else
          imgBW.Colors[i, j] := colBlack;

        Inc(totalPixels);
      end
    end;
  end;

  WriteLn('Análisis completado.');

  if totalPixels > 0 then
  begin
    CCI := cloudPixels / totalPixels;
    WriteLn('Índice de cobertura nubosa (CCI): ', CCI:0:4);
  end
  else
  begin
    WriteLn('Error: no se encontraron píxeles en el círculo de la imagen.');
  end;

  if isSegmentation then
  begin
    outputFileName := ChangeFileExt(inputFileName, '-seg.jpg');
    imgBW.SaveToFile(outputFileName, writerJPEG);
    WriteLn('Imagen de segmentación guardada como: ', outputFileName);
  end;

  // Liberar recursos
  img.Free;
  imgBW.Free;
  readerJPEG.Free;
  writerJPEG.Free;

  WriteLn('Fin del programa.');
end.


