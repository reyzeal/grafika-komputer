unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, ExtCtrls,
  StdCtrls,math;

type

  { TForm1 }

  TForm1 = class(TForm)
    Button1: TButton;
    Button10: TButton;
    Balok: TButton;
    ColorButton1: TColorButton;
    ColorButton2: TColorButton;
    Limas: TButton;
    Kubus: TButton;
    Button2: TButton;
    Button3: TButton;
    Button8: TButton;
    Button9: TButton;
    Lingkaran: TButton;
    Persegi: TButton;
    Segitiga: TButton;
    Jajargenjang: TButton;
    Button4: TButton;
    Button5: TButton;
    Button6: TButton;
    Button7: TButton;
    Image1: TImage;
    Label1: TLabel;
    procedure BalokClick(Sender: TObject);
    procedure Button10Click(Sender: TObject);
    procedure Image1MouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure KubusClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button8Click(Sender: TObject);
    procedure Button9Click(Sender: TObject);
    procedure FormActivate(Sender: TObject);
    procedure ClearCanvas();
    procedure LimasClick(Sender: TObject);
    procedure LingkaranClick(Sender: TObject);
    procedure PersegiClick(Sender: TObject);
    procedure SegitigaClick(Sender: TObject);
    procedure JajargenjangClick(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure Button5Click(Sender: TObject);
    procedure Button6Click(Sender: TObject);
    procedure Button7Click(Sender: TObject);
    procedure Image1MouseMove(Sender: TObject; Shift: TShiftState; X, Y: Integer
      );
    procedure Menggambar();
  private

  public

  end;

var
  Form1: TForm1;
  ObjectGambar :  Array of TPoint;
  JumlahTitik : Integer;
  isLingkaran : Boolean;
  AreaObject : TRect;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.PersegiClick(Sender: TObject);
begin
   isLingkaran:= false;
   JumlahTitik:=4;
   SetLength(ObjectGambar,JumlahTitik);
   ObjectGambar[0]:= TPoint.Create(0,0);
   ObjectGambar[1]:= TPoint.Create(0,20);
   ObjectGambar[2]:= TPoint.Create(20,20);
   ObjectGambar[3]:= TPoint.Create(20,0);
   AreaObject := TRect.Create(ObjectGambar[0],ObjectGambar[2]);
   ClearCanvas();
   Menggambar();
end;

procedure TForm1.SegitigaClick(Sender: TObject);
begin
   isLingkaran:= false;
   JumlahTitik:=3;
  SetLength(ObjectGambar,JumlahTitik);

   ObjectGambar[0]:= TPoint.Create(220,170);
   ObjectGambar[1]:= TPoint.Create(245,120);
   ObjectGambar[2]:= TPoint.Create(270,170);
   ClearCanvas();
   Menggambar();
end;

procedure TForm1.JajargenjangClick(Sender: TObject);
begin
   isLingkaran:= false;
   JumlahTitik:=4;
  SetLength(ObjectGambar,JumlahTitik);

   ObjectGambar[0]:= TPoint.Create(220,120);
   ObjectGambar[1]:= TPoint.Create(270,120);
   ObjectGambar[2]:= TPoint.Create(250,170);
   ObjectGambar[3]:= TPoint.Create(200,170);
   ClearCanvas();
   Menggambar();
end;

procedure TForm1.Menggambar();
var
  i,xmin,ymin,xmax,ymax : integer;
begin
  Image1.Canvas.MoveTo(ObjectGambar[0]);
  xmax := 0;
  ymax := 0;
  xmin := Image1.Width;
  ymin := Image1.Height;
  if isLingkaran then
    begin
      Image1.Canvas.Ellipse(ObjectGambar[0].x,ObjectGambar[0].y,ObjectGambar[1].x,ObjectGambar[1].y);
      AreaObject := TRect.Create(ObjectGambar[0],ObjectGambar[1]);
      Image1.Canvas.Brush.Color:=ColorButton2.ButtonColor;
      Image1.Canvas.FloodFill(AreaObject.CenterPoint.x,AreaObject.CenterPoint.y,Image1.Canvas.Pixels[AreaObject.CenterPoint.x,AreaObject.CenterPoint.y],fsSurface);
    end
  else
    begin
      for i:= Length(ObjectGambar)-1 downto 0 do begin
        xmin := Min(xmin,ObjectGambar[i].x);
        ymin := Min(ymin,ObjectGambar[i].y);
        xmax := Max(xmax,ObjectGambar[i].x);
        ymax := Max(ymax,ObjectGambar[i].y);
        Image1.Canvas.LineTo(ObjectGambar[i]);
      end;
      AreaObject := TRect.Create(xmin,ymin,xmax,ymax);
      Image1.Canvas.Brush.Color:=ColorButton2.ButtonColor;
      Image1.Canvas.FloodFill(AreaObject.CenterPoint.x,AreaObject.CenterPoint.y,Image1.Canvas.Pixels[AreaObject.CenterPoint.x,AreaObject.CenterPoint.y],fsSurface);
    end;

end;

procedure TForm1.FormActivate(Sender: TObject);
begin
  ClearCanvas();
end;

procedure TForm1.Button1Click(Sender: TObject);
var
  i : integer;
begin
     for i := 0 to JumlahTitik-1 do begin
       ObjectGambar[i].y := ObjectGambar[i].y - 10;
       ObjectGambar[i].x := ObjectGambar[i].x + 10;
     end;
     ClearCanvas();
     Menggambar();
end;

procedure TForm1.Button10Click(Sender: TObject);
var
  i : Integer;
begin
  for i := 0 to JumlahTitik-1 do begin
       ObjectGambar[i].y := round(ObjectGambar[i].y / 1.1);
       ObjectGambar[i].x := round(ObjectGambar[i].x / 1.1);
     end;
     ClearCanvas();
     Menggambar();
end;

procedure TForm1.Image1MouseUp(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
  Image1.Canvas.Brush.Color:=ColorButton1.ButtonColor;
  Image1.Canvas.FloodFill(X,Y,Image1.Canvas.Pixels[X,Y],fsSurface);
end;

procedure TForm1.BalokClick(Sender: TObject);
var
  i : Integer;
begin
   isLingkaran:= false;
   JumlahTitik:=16;
   SetLength(ObjectGambar,JumlahTitik);
   ObjectGambar[0]:= TPoint.Create(175,100);
   ObjectGambar[1]:= TPoint.Create(100,100);
   ObjectGambar[2]:= TPoint.Create(100,150);
   ObjectGambar[3]:= TPoint.Create(175,150);
   ObjectGambar[4]:= TPoint.Create(175,100);

   ObjectGambar[5]:= TPoint.Create(150,125);
   ObjectGambar[6]:= TPoint.Create(75,125);
   ObjectGambar[7]:= TPoint.Create(75,175);
   ObjectGambar[8]:= TPoint.Create(150,175);
   ObjectGambar[9]:= TPoint.Create(150,125);

   ObjectGambar[10]:= TPoint.Create(150,175);
   ObjectGambar[11]:= TPoint.Create(175,150);
   ObjectGambar[12]:= TPoint.Create(100,150);
   ObjectGambar[13]:= TPoint.Create(75,175);
   ObjectGambar[14]:= TPoint.Create(75,125);
   ObjectGambar[15]:= TPoint.Create(100,100);
   //ObjectGambar[16]:= TPoint.Create(175,100);

   ClearCanvas();
   Menggambar();
   //Image1.Canvas.MoveTo(ObjectGambar[0]);
   //for i:=3 downto 0 do
   //begin
   //     Image1.Canvas.LineTo(ObjectGambar[i]);
   //end;
   //Image1.Canvas.MoveTo(ObjectGambar[4]);
   //for i:=7 downto 4 do
   //begin
   //     Image1.Canvas.LineTo(ObjectGambar[i]);
   //end;
   //for i:=0 to 3 do
   //begin
   //     Image1.Canvas.MoveTo(ObjectGambar[i]);
   //     Image1.Canvas.LineTo(ObjectGambar[i+4]);
   //end;
end;

procedure TForm1.KubusClick(Sender: TObject);
var
  i : Integer;
begin
   isLingkaran:= false;
   JumlahTitik:=17;
   SetLength(ObjectGambar,JumlahTitik);

   ObjectGambar[0]:= TPoint.Create(150,100);
   ObjectGambar[1]:= TPoint.Create(100,100);
   ObjectGambar[2]:= TPoint.Create(100,150);
   ObjectGambar[3]:= TPoint.Create(150,150);
   ObjectGambar[4]:= TPoint.Create(150,100);

   ObjectGambar[5]:= TPoint.Create(125,125);
   ObjectGambar[6]:= TPoint.Create(75,125);
   ObjectGambar[7]:= TPoint.Create(75,175);
   ObjectGambar[8]:= TPoint.Create(125,175);
   ObjectGambar[9]:= TPoint.Create(125,125);

   ObjectGambar[10]:= TPoint.Create(125,175);
   ObjectGambar[11]:= TPoint.Create(150,150);
   ObjectGambar[12]:= TPoint.Create(100,150);
   ObjectGambar[13]:= TPoint.Create(75,175);
   ObjectGambar[14]:= TPoint.Create(75,125);
   ObjectGambar[15]:= TPoint.Create(100,100);
   ObjectGambar[16]:= TPoint.Create(150,100);
   ClearCanvas();
   Menggambar();
   //for i:=3 downto 0 do
   //begin
   //     Image1.Canvas.LineTo(ObjectGambar[i]);
   //end;                                  
   //Image1.Canvas.MoveTo(ObjectGambar[4]);
   //for i:=7 downto 4 do
   //begin
   //     Image1.Canvas.LineTo(ObjectGambar[i]);
   //end;
   //for i:=0 to 3 do
   //begin
   //     Image1.Canvas.MoveTo(ObjectGambar[i]);
   //     Image1.Canvas.LineTo(ObjectGambar[i+4]);
   //end;
end;

procedure TForm1.Button2Click(Sender: TObject);
var
  i : integer;
begin
     for i := 0 to JumlahTitik-1 do begin
       ObjectGambar[i].y := ObjectGambar[i].y + 10;
       ObjectGambar[i].x := ObjectGambar[i].x + 10;
     end;
     ClearCanvas();
     Menggambar();
end;

procedure TForm1.Button3Click(Sender: TObject);
var
  i : integer;
begin
     for i := 0 to JumlahTitik-1 do begin
       ObjectGambar[i].y := ObjectGambar[i].y - 10;
       ObjectGambar[i].x := ObjectGambar[i].x - 10;
     end;
     ClearCanvas();
     Menggambar();
end;

procedure TForm1.Button8Click(Sender: TObject);
var
  i : integer;
begin
     for i := 0 to JumlahTitik-1 do begin
       ObjectGambar[i].y := ObjectGambar[i].y + 10;
       ObjectGambar[i].x := ObjectGambar[i].x - 10;
     end;
     ClearCanvas();
     Menggambar();
end;

procedure TForm1.Button9Click(Sender: TObject);
var
  i : Integer;
begin
     for i := 0 to JumlahTitik-1 do begin
       ObjectGambar[i].y := round(ObjectGambar[i].y * 1.1);
       ObjectGambar[i].x := round(ObjectGambar[i].x * 1.1);
     end;
     ClearCanvas();
     Menggambar();
end;

procedure TForm1.ClearCanvas();
begin
  Image1.Canvas.Brush.Color:=clWhite;
  Image1.Canvas.FillRect(0,0,Image1.Width,Image1.Height);
end;

procedure TForm1.LimasClick(Sender: TObject);
var
  i : Integer;
begin
  isLingkaran:= false;
   JumlahTitik:=8;
   SetLength(ObjectGambar,JumlahTitik);

   ObjectGambar[0]:= TPoint.Create(150,100);
   ObjectGambar[1]:= TPoint.Create(100,100);
   ObjectGambar[2]:= TPoint.Create(100,150);
   ObjectGambar[3]:= TPoint.Create(150,150);

   ObjectGambar[4]:= TPoint.Create(125,125);
   ObjectGambar[5]:= TPoint.Create(75,125);
   ObjectGambar[6]:= TPoint.Create(75,175);
   ObjectGambar[7]:= TPoint.Create(125,175);


   ClearCanvas();

   Image1.Canvas.MoveTo(ObjectGambar[0]);
   for i:=3 downto 0 do
   begin
        Image1.Canvas.LineTo(ObjectGambar[i]);
   end;
   Image1.Canvas.MoveTo(ObjectGambar[4]);
   for i:=7 downto 4 do
   begin
        Image1.Canvas.LineTo(ObjectGambar[i]);
   end;
   for i:=0 to 3 do
   begin
        Image1.Canvas.MoveTo(ObjectGambar[i]);
        Image1.Canvas.LineTo(ObjectGambar[i+4]);
   end;
end;

procedure TForm1.LingkaranClick(Sender: TObject);
begin
   isLingkaran:= true;
   JumlahTitik:=2;
   SetLength(ObjectGambar,JumlahTitik);
   ObjectGambar[0]:= TPoint.Create(220,120);
   ObjectGambar[1]:= TPoint.Create(270,170);
   ClearCanvas();
   Menggambar();
end;

procedure TForm1.Button4Click(Sender: TObject);
var
  i : integer;
begin
     for i := 0 to JumlahTitik-1 do begin
       ObjectGambar[i].y := ObjectGambar[i].y - 10;
     end;
     ClearCanvas();
     Menggambar();
end;

procedure TForm1.Button5Click(Sender: TObject);
var
  i : integer;
begin
     for i := 0 to JumlahTitik-1 do begin
       ObjectGambar[i].x := ObjectGambar[i].x - 10;
     end;
     ClearCanvas();
     Menggambar();
end;

procedure TForm1.Button6Click(Sender: TObject);
var
  i : integer;
begin
     for i := 0 to JumlahTitik-1 do begin
       ObjectGambar[i].x := ObjectGambar[i].x + 10;
     end;
     ClearCanvas();
     Menggambar();
end;

procedure TForm1.Button7Click(Sender: TObject);
var
  i : integer;
begin
     for i := 0 to JumlahTitik-1 do begin
       ObjectGambar[i].y := ObjectGambar[i].y + 10;
     end;
     ClearCanvas();
     Menggambar();
end;



procedure TForm1.Image1MouseMove(Sender: TObject; Shift: TShiftState; X,
  Y: Integer);
begin
   Label1.Caption:='X:'+IntToStr(X)+' Y:'+IntToStr(Y);
end;



end.

