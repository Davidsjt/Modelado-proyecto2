program CropCircleImage;

uses
  SysUtils, Classes, FPImage, FPReadJPEG, FPWriteBMP;

const
  OUTPUT_FILENAME = 'salida-limpio.bmp';
  IMAGE_WIDTH = 4368; 
  IMAGE_HEIGHT = 2912; 
  CIRCLE_CENTER_X = 2184;
  CIRCLE_CENTER_Y = 1456; 
  CIRCLE_RADIUS = 1324; 
  CIRCLE_DIAMETER = CIRCLE_RADIUS * 2; 

procedure CropCircleToBMP(const inputFileName, outputFileName: string);
var
  jpegImage: TFPMemoryImage; 
  bmpImage: TFPMemoryImage;
  reader: TFPReaderJPEG; 
  writer: TFPWriterBMP; 
  x, y: Integer; 
  pixelColor: TFPColor; 
  distanceFromCenter: Double; 
  yellowColor: TFPColor; 
begin
  jpegImage := TFPMemoryImage.Create(IMAGE_WIDTH, IMAGE_HEIGHT);
  reader := TFPReaderJPEG.Create;
  bmpImage := TFPMemoryImage.Create(CIRCLE_DIAMETER, CIRCLE_DIAMETER); 
  writer := TFPWriterBMP.Create;

  jpegImage.LoadFromFile(inputFileName, reader);

  bmpImage.UsePalette := False;

  yellowColor.Red := $FFFF;
  yellowColor.Green := $FFFF;
  yellowColor.Blue := 0;
  yellowColor.Alpha := $FFFF;


  for y := 0 to CIRCLE_DIAMETER - 1 do
  begin
    for x := 0 to CIRCLE_DIAMETER - 1 do
    begin

      distanceFromCenter := Sqrt(Sqr(x - CIRCLE_RADIUS) + Sqr(y - CIRCLE_RADIUS));


      if distanceFromCenter <= CIRCLE_RADIUS then
      begin
        
        pixelColor := jpegImage.Colors[x + CIRCLE_CENTER_X - CIRCLE_RADIUS, y + CIRCLE_CENTER_Y - CIRCLE_RADIUS];
        bmpImage.Colors[x, y] := pixelColor;
      end
      else
      begin

        bmpImage.Colors[x, y] := yellowColor;
      end;
    end;
  end;

  bmpImage.SaveToFile(outputFileName, writer);

  reader.Free;
  writer.Free;
  jpegImage.Free;
  bmpImage.Free;

  WriteLn('¡Listo! La imagen se guardó en ', outputFileName);
end;

begin

  if ParamCount < 1 then
  begin
    WriteLn('Uso: ', ParamStr(0), ' <archivo_entrada.jpg>');
    Halt(1);
  end;

  CropCircleToBMP(ParamStr(1), OUTPUT_FILENAME);
end.




