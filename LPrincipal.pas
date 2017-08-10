unit LPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Layouts,MasterDetail;

type
  TForm1 = class(TForm)
    ScaledLayout1: TScaledLayout;
    Image1: TImage;
    Image2: TImage;
    Image3: TImage;
    Image4: TImage;
    Image5: TImage;
    Image6: TImage;
    Image7: TImage;
    Image8: TImage;
    Image9: TImage;
    Image10: TImage;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    Panel4: TPanel;
    Etiqueta1: TLabel;
    Etiqueta2: TLabel;
    Etiqueta3: TLabel;
    Etiqueta4: TLabel;
    Image11: TImage;
    Image12: TImage;
    Panel5: TPanel;
    procedure Image1Click(Sender: TObject);
    procedure Image2Click(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure Image4Click(Sender: TObject);
    procedure Image5Click(Sender: TObject);
    procedure Image6Click(Sender: TObject);
    procedure Image7Click(Sender: TObject);
    procedure Image8Click(Sender: TObject);
    procedure Image9Click(Sender: TObject);
    procedure Image10Click(Sender: TObject);
    procedure Image12Click(Sender: TObject);
    procedure Image11Click(Sender: TObject);
  private
    { Private declarations }
  public
  Master : TFrame1;
  procedure almacena_clave(numero:Integer);
    { Public declarations }
  end;

var
  Form1: TForm1;
  clave: String;

implementation
Uses Datas;

{$R *.fmx}
procedure TForm1.almacena_clave(numero:Integer);
begin
   if clave.Length <= 4 then
   begin
      if (Etiqueta1.Text.Length = 1) and (Etiqueta2.Text.Length = 1)
      and (Etiqueta3.Text.Length = 1) and (Etiqueta4.Text.Length = 0)  then
      begin
        Etiqueta4.Text:='*';
        Clave := clave +IntToStr(numero);
      end;

      if (Etiqueta1.Text.Length = 1) and (Etiqueta2.Text.Length = 1)
      and (Etiqueta3.Text.Length = 0) then
      begin
        Etiqueta3.Text:='*';
        Clave := clave +IntToStr(numero);
      end;

      if (Etiqueta1.Text.Length = 1) and (Etiqueta2.Text.Length = 0) then
      begin
        Etiqueta2.Text:='*';
        Clave := clave +IntToStr(numero);
      end;


      if Etiqueta1.Text.Length = 0 then
      begin
        Etiqueta1.Text:='*';
        Clave := IntToStr(numero);
      end;
   end;
end;

procedure TForm1.Image10Click(Sender: TObject);
begin
  almacena_clave(0);
end;

procedure TForm1.Image11Click(Sender: TObject);
begin
  Clave:='';
  Etiqueta1.Text:='';
  Etiqueta2.Text:='';
  Etiqueta3.Text:='';
  Etiqueta4.Text:='';
end;

procedure TForm1.Image12Click(Sender: TObject);
var
  agente:String;
  estatus:Integer;
begin
  if clave.Length = 4 then
  begin
    try
       Datas.DataModule2.Query.SQL.Clear;
       Datas.DataModule2.Query.SQL.Add('SELECT NOMBRE,AGENTE,ESTATUS FROM MECANICO WHERE CLAVE = :CLAVE');
       Datas.DataModule2.Query.ParamByName('CLAVE').AsString:=Clave;
       Datas.DataModule2.Query.ExecSQL;
        if Datas.DataModule2.Query.RecordCount = 1 then
        begin
           agente := Datas.DataModule2.Query.FieldByName('AGENTE').AsString;
           estatus := Datas.DataModule2.Query.FieldByName('ESTATUS').AsInteger;

            if estatus = 1 then
            begin
              //ShowMessage('ERES UN USUARIO ACTIVO EN EL SISTEMA');
              Master := TFrame1.Create(Self);
              Master.Parent:= Panel5;
              Master.Visible:=True;
              Master.Nombre_Usuario.Text := Datas.DataModule2.Query.FieldByName('NOMBRE').AsString;
              Panel5.Visible:=True;
              Master.carga_ordenes;


            end
            else
            begin
              ShowMessage('Usuario dado de baja!');
            end;


        end
        else
        begin
          ShowMessage('Clave incorrecta, vuelve a intentarlo');


        end;

    finally
        Datas.DataModule2.Query.Close;
    end;
  end
  else
  begin
    ShowMessage('Debe ingresar una clave de 4 digitos');
  end;
end;

procedure TForm1.Image1Click(Sender: TObject);
begin

   almacena_clave(1);
end;

procedure TForm1.Image2Click(Sender: TObject);
begin
     almacena_clave(2);
end;

procedure TForm1.Image3Click(Sender: TObject);
begin
    almacena_clave(3);
end;

procedure TForm1.Image4Click(Sender: TObject);
begin
almacena_clave(4);
end;

procedure TForm1.Image5Click(Sender: TObject);
begin
     almacena_clave(5);
end;

procedure TForm1.Image6Click(Sender: TObject);
begin
    almacena_clave(6);
end;

procedure TForm1.Image7Click(Sender: TObject);
begin
   almacena_clave(7);
end;

procedure TForm1.Image8Click(Sender: TObject);
begin
    almacena_clave(8);
end;

procedure TForm1.Image9Click(Sender: TObject);
begin
    almacena_clave(9);
end;

end.
