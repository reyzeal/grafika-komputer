unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls, math;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Image1: TImage;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure Image1MouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
      );
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
  private

  public

  end;

var
  Form1: TForm1;
  penState : Boolean;
  cropState : Boolean;
  selectState : Boolean;
  mouseState : Boolean;
  mouseAwal : TPoint;
  mouseAkhir : TPoint;
  bitmap_back : TBitmap;
  bitmap_crop : TBitmap;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.Button1Click(Sender: TObject);
begin
    penState := True;
    selectState := False;
end;

procedure TForm1.Button2Click(Sender: TObject);
begin
  selectState := True;
  penState := False;
end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  Image1.Canvas.Brush.Color:=clWhite;
  Image1.Canvas.Pen.Color:=clWhite;
  Image1.Canvas.FillRect(0,0,Image1.Width,Image1.Height);
end;

procedure TForm1.Image1MouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  mouseState:=True;
  mouseAwal := TPoint.Create(X,Y);
  if penState then
  begin
     Image1.Canvas.Pen.Color:=clBlack;
     Image1.Canvas.Pen.Style:=psSolid;
     Image1.Canvas.MoveTo(X,Y);
  end;
  if cropState then
  begin
     //bitmap_back:= TBitmap.Create;
     //bitmap_back.Canvas.Clear;
     //bitmap_back.SetSize(Image1.Canvas.Width,Image1.Canvas.Height);
     // (area tujuan,dari kanvas,area yang dicopy)
     //bitmap_back.Canvas.CopyRect(TRect.Create(0,0,bitmap_back.Width,bitmap_back.Height),Image1.Canvas,TRect.Create(0,0,bitmap_back.Width,bitmap_back.Height));
  end;
  if selectState then
  begin
     bitmap_back:= TBitmap.Create;
     bitmap_back.Canvas.Clear;
     bitmap_back.SetSize(Image1.Canvas.Width,Image1.Canvas.Height);
     // (area tujuan,dari kanvas,area yang dicopy)
     bitmap_back.Canvas.CopyRect(TRect.Create(0,0,bitmap_back.Width,bitmap_back.Height),Image1.Canvas,TRect.Create(0,0,bitmap_back.Width,bitmap_back.Height));

     Image1.Canvas.Pen.Color:=clRed;
     Image1.Canvas.Pen.Style:=psDash;
     Image1.Canvas.MoveTo(X,Y);
  end;
end;

procedure TForm1.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
  if penState and mouseState then
  begin
     Image1.Canvas.LineTo(X,Y);
  end;
  if selectState and mouseState then
  begin
     Image1.Canvas.CopyRect(TRect.Create(0,0,Image1.Canvas.Width,Image1.Canvas.Height),bitmap_back.Canvas,TRect.Create(0,0,Image1.Canvas.Width,Image1.Canvas.Height));
     Image1.Canvas.Brush.Style:=bsClear;
     Image1.Canvas.Rectangle(mouseAwal.x,mouseAwal.Y,X,Y);
  end;
  if cropState and mouseState then
  begin
     Image1.Canvas.CopyRect(TRect.Create(0,0,Image1.Canvas.Width,Image1.Canvas.Height),bitmap_back.Canvas,TRect.Create(0,0,Image1.Canvas.Width,Image1.Canvas.Height));
     mouseAwal := TPoint.Create(X,Y);
     mouseAkhir := mouseAwal.Add(TPoint.Create(bitmap_crop.Canvas.Width,bitmap_crop.Canvas.Height));
     Image1.Canvas.CopyRect(TRect.Create(mouseAwal,mouseAkhir),bitmap_crop.Canvas,TRect.Create(0,0,bitmap_crop.Canvas.Width,bitmap_crop.Canvas.Height));
     Image1.Canvas.Brush.Style:=bsClear;
     Image1.Canvas.Rectangle(mouseAwal.x,mouseAwal.Y,X,Y);
  end;
end;

procedure TForm1.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  mouseAkhir := TPoint.Create(X,Y);
  mouseState:=False;
  if cropState then begin
      cropState := False;

  end;
  if selectState then
  begin
     Image1.Canvas.CopyRect(TRect.Create(0,0,Image1.Canvas.Width,Image1.Canvas.Height),bitmap_back.Canvas,TRect.Create(0,0,Image1.Canvas.Width,Image1.Canvas.Height));


     // ambil dulu
     bitmap_crop := TBitmap.Create;
     bitmap_crop.Canvas.Clear;
     bitmap_crop.SetSize(abs(mouseAwal.Subtract(mouseAkhir).x),abs(mouseAwal.Subtract(mouseAkhir).y));
     bitmap_crop.Canvas.CopyRect(TRect.Create(0,0,abs(mouseAwal.Subtract(mouseAkhir).x),abs(mouseAwal.Subtract(mouseAkhir).y)),bitmap_back.Canvas,TRect.Create(mouseAwal,mouseAkhir));

     // bersihkan area
     Image1.Canvas.Pen.Style:=psClear;
     Image1.Canvas.Pen.Color:=clWhite;
     Image1.Canvas.Brush.Style:=bsSolid;
     Image1.Canvas.Brush.Color:=clWhite;
     Image1.Canvas.Rectangle(TRect.Create(mouseAwal,mouseAkhir));

     // kembalikan
     bitmap_back.Canvas.CopyRect(TRect.Create(0,0,bitmap_back.Width,bitmap_back.Height),Image1.Canvas,TRect.Create(0,0,bitmap_back.Width,bitmap_back.Height));
     //Image1.Canvas.CopyRect(TRect.Create(mouseAwal,mouseAkhir),bitmap_back.Canvas,TRect.Create(mouseAwal,mouseAkhir));
     Image1.Canvas.CopyRect(TRect.Create(mouseAwal,mouseAkhir),bitmap_crop.Canvas,TRect.Create(0,0,bitmap_crop.Canvas.Width,bitmap_crop.Canvas.Height));
     Image1.Canvas.Pen.Style:=psDash;
     Image1.Canvas.Pen.Color:=clRed;
     Image1.Canvas.Brush.Style:=bsClear;
     Image1.Canvas.Rectangle(mouseAwal.x,mouseAwal.Y,X,Y);
     selectState := false;
     cropState := true;
  end;
end;

end.

