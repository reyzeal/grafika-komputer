unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, math;

type

  { TForm1 }

  TForm1 = class(TForm)
    Clockwise: TButton;
    CounterClockwise: TButton;
    degree: TEdit;
    GroupBox1: TGroupBox;
    Label1: TLabel;
    RadioButton1: TRadioButton;
    RadioButton2: TRadioButton;
    RadioButton3: TRadioButton;
    RadioButton4: TRadioButton;
    zoomOut: TButton;
    zoomIn: TButton;
    persegi: TButton;
    segitiga: TButton;
    lingkaran: TButton;
    Image1: TImage;
    procedure ClockwiseClick(Sender: TObject);
    procedure CounterClockwiseClick(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure lingkaranClick(Sender: TObject);
    procedure persegiClick(Sender: TObject);
    procedure ClearCanvas();
    procedure DrawCanvas();
    procedure RadioButton1Change(Sender: TObject);
    procedure RadioButton2Change(Sender: TObject);
    procedure RadioButton3Change(Sender: TObject);
    procedure RadioButton4Change(Sender: TObject);
    procedure segitigaClick(Sender: TObject);
    procedure zoomInClick(Sender: TObject);
    procedure zoomOutClick(Sender: TObject);
  private

  public

  end;

  ObjectGambar = record
    Coordinate : array of TPoint;
    TransCoord : array of TPoint;
    BeingTransform : boolean;
    name : string;
    area : TRect;
  end;

var
  Form1: TForm1;
  ObjGambar : ObjectGambar;
  ImageCenter : TPoint;
  CurrentDegree : real;
  Center : string;

implementation

{$R *.lfm}

{ TForm1 }
procedure TForm1.ClearCanvas();
begin
  Image1.Canvas.Brush.Color:=clWhite;
  Image1.Canvas.FillRect(0,0,Image1.Width,Image1.Height);
end;

procedure TForm1.DrawCanvas();
var
  area : TRect;
begin


  case ObjGambar.name of
       'persegi','segitiga':
         begin
           if ObjGambar.BeingTransform then
           Image1.Canvas.Polygon(ObjGambar.TransCoord)
           else
           Image1.Canvas.Polygon(ObjGambar.Coordinate);
         end;
       'lingkaran':
         begin

           if ObjGambar.BeingTransform then
           begin
               Image1.Canvas.EllipseC(ObjGambar.TransCoord[0].x,ObjGambar.TransCoord[0].y,25,25);
           end

           else
           begin
             Image1.Canvas.EllipseC(ObjGambar.Coordinate[0].x,ObjGambar.Coordinate[0].y,25,25);
           end;
         end;

  end;
  Label1.Caption:=FloatToStr(CurrentDegree);
end;

procedure TForm1.RadioButton1Change(Sender: TObject);
begin
  Center := 'Canvas';
end;

procedure TForm1.RadioButton2Change(Sender: TObject);
begin
  Center := 'Object';
end;

procedure TForm1.RadioButton3Change(Sender: TObject);
begin
  Center := 'Coordinate';
end;

procedure TForm1.RadioButton4Change(Sender: TObject);
begin
  Center:= 'Origin';
end;

procedure TForm1.segitigaClick(Sender: TObject);
begin
  CurrentDegree:=0;
  ObjGambar.name := 'segitiga';
  ObjGambar.BeingTransform:=false;
  SetLength(ObjGambar.Coordinate,3);
  SetLength(ObjGambar.TransCoord,3);
  ObjGambar.Coordinate[0]:=TPoint.Create(ImageCenter.x,ImageCenter.y-25);
  ObjGambar.Coordinate[1]:=TPoint.Create(ImageCenter.x+25,ImageCenter.y+25);
  ObjGambar.Coordinate[2]:=TPoint.Create(ImageCenter.x-25,ImageCenter.y+25);
  ObjGambar.area:=TRect.Create(ObjGambar.Coordinate[1].Subtract(TPoint.Create(50,50)),ObjGambar.Coordinate[1]);
  ClearCanvas();
  DrawCanvas();
end;

procedure TForm1.zoomInClick(Sender: TObject);
var
  i : integer;
begin

     for i:=0 to length(ObjGambar.Coordinate) do
      begin
         ObjGambar.Coordinate[i] := ObjGambar.Coordinate[i].Subtract(ImageCenter);
         ObjGambar.Coordinate[i].x := round(ObjGambar.Coordinate[i].x*1.1);
         ObjGambar.Coordinate[i].y := round(ObjGambar.Coordinate[i].y*1.1);
         ObjGambar.Coordinate[i] := ObjGambar.Coordinate[i].Add(ImageCenter);
      end;
      ClearCanvas();
      DrawCanvas();


end;

procedure TForm1.zoomOutClick(Sender: TObject);
var
  i : integer;
begin
  if ObjGambar.Coordinate[0].Distance(ObjGambar.Coordinate[1]) > 50 then
  begin
    for i:=0 to length(ObjGambar.Coordinate) do
    begin
       ObjGambar.Coordinate[i] := ObjGambar.Coordinate[i].Subtract(ImageCenter);
       ObjGambar.Coordinate[i].x := round(ObjGambar.Coordinate[i].x*0.9);
       ObjGambar.Coordinate[i].y := round(ObjGambar.Coordinate[i].y*0.9);
       ObjGambar.Coordinate[i] := ObjGambar.Coordinate[i].Add(ImageCenter);
    end;
    ClearCanvas();
    DrawCanvas();
  end;


end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  ClearCanvas;
  ImageCenter := TPoint.Create(round(Image1.Width/2),round(Image1.Height/2));
  Label1.Caption:=FloatToStr(CurrentDegree);
end;

procedure TForm1.CounterClockwiseClick(Sender: TObject);
var
  numDeg,C,S,dx,dy : real;
  i : integer;
  CoordCenter : TPoint;
begin
  CurrentDegree:=round(CurrentDegree+StrToFloat(degree.Text)) mod 360;
  numDeg:= CurrentDegree * pi / 180;

  C := cos(numDeg);
  S := sin(numDeg);
  ObjGambar.BeingTransform:=true;
  case Center of
       'Canvas':
         CoordCenter:= ImageCenter;
       'Object':
         CoordCenter:= ObjGambar.area.CenterPoint;
       'Coordinate':
         CoordCenter:= ObjGambar.Coordinate[0];
       'Origin':
         CoordCenter:= TPoint.Create(0,0);
  end;
  for i:=0 to length(ObjGambar.Coordinate)-1 do
      begin
         dx := ObjGambar.Coordinate[i].x - CoordCenter.x;
         dy := ObjGambar.Coordinate[i].y - CoordCenter.y;
         ObjGambar.TransCoord[i] := TPoint.Create(0,0);
         ObjGambar.TransCoord[i].x := round(dx*C+dy*S) + CoordCenter.x;
         ObjGambar.TransCoord[i].y := round(-dx*S+dy*C) + CoordCenter.y;
      end;
      ClearCanvas();
      DrawCanvas();
end;

procedure TForm1.ClockwiseClick(Sender: TObject);
var
  numDeg,C,S,dx,dy : real;
  i : integer;
  CoordCenter : TPoint;
begin
  CurrentDegree:=round(CurrentDegree+StrToFloat(degree.Text)) mod 360;
  numDeg:= CurrentDegree * pi / 180;

  case Center of
       'Canvas':
         CoordCenter:= ImageCenter;
       'Object':
         CoordCenter:= ObjGambar.area.CenterPoint;
       'Coordinate':
         CoordCenter:= ObjGambar.Coordinate[0];
       'Origin':
         CoordCenter:= TPoint.Create(0,0);
  end;
  C := cos(numDeg);
  S := sin(numDeg);
  ObjGambar.BeingTransform:=true;

  for i:=0 to length(ObjGambar.Coordinate)-1 do
      begin
         dx := ObjGambar.Coordinate[i].x - CoordCenter.x;
         dy := ObjGambar.Coordinate[i].y - CoordCenter.y;
         ObjGambar.TransCoord[i] := TPoint.Create(0,0);
         ObjGambar.TransCoord[i].x := round(dx*C-dy*S) + CoordCenter.x;
         ObjGambar.TransCoord[i].y := round(dx*S+dy*C) + CoordCenter.y;
      end;
      ClearCanvas();
      DrawCanvas();
end;

procedure TForm1.lingkaranClick(Sender: TObject);
begin
  CurrentDegree:=0;
  ObjGambar.name := 'lingkaran';
  ObjGambar.BeingTransform:=false;
  SetLength(ObjGambar.Coordinate,1);
  SetLength(ObjGambar.TransCoord,1);
  ObjGambar.Coordinate[0]:=TPoint.Create(ImageCenter.x,ImageCenter.y);
  ObjGambar.area := TRect.Create(ImageCenter.Subtract(TPoint.Create(25,25)),50,50);
  ClearCanvas();
  DrawCanvas();
end;

procedure TForm1.persegiClick(Sender: TObject);
begin
  CurrentDegree:=0;
  ObjGambar.name := 'persegi';
  ObjGambar.BeingTransform:=false;
  SetLength(ObjGambar.Coordinate,4);
  SetLength(ObjGambar.TransCoord,4);
  ObjGambar.Coordinate[0]:=TPoint.Create(ImageCenter.x-25,ImageCenter.y-25);
  ObjGambar.Coordinate[1]:=TPoint.Create(ImageCenter.x+25,ImageCenter.y-25);
  ObjGambar.Coordinate[2]:=TPoint.Create(ImageCenter.x+25,ImageCenter.y+25);
  ObjGambar.Coordinate[3]:=TPoint.Create(ImageCenter.x-25,ImageCenter.y+25);
  ObjGambar.area := TRect.Create(ObjGambar.Coordinate[0],ObjGambar.Coordinate[2]);
  ClearCanvas();
  DrawCanvas();
end;

end.

