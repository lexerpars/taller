unit LPrincipal;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, FMX.Dialogs,
  FMX.Controls.Presentation, FMX.StdCtrls, FMX.Objects, FMX.Layouts,MasterDetail,
  FMXTee.Engine, FMXTee.Chart.Functions, FMXTee.Series, FMXTee.Procs,
  FMXTee.Chart, FMX.Controls3D, FMXTee.Chart3D;

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
    Label3: TLabel;
    Image13: TImage;
    Label1: TLabel;
    Label2: TLabel;
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
    procedure Image13Click(Sender: TObject);
  private
    { Private declarations }
  public
  Master : TFrame1;
  procedure almacena_clave(numero:Integer);
  procedure libera_frame();
  procedure recarga_informacion;
  procedure reset();
    { Public declarations }
  end;

var
  Form1: TForm1;
  clave: String;
  estatus,agente:String;
  id_user,condicional,id_td : integer;
  mi_id:integer;

implementation
Uses Datas;

{$R *.fmx}

procedure TForm1.reset;
begin
     Clave:='';
     Etiqueta1.Text:='';
     Etiqueta2.Text:='';
     Etiqueta3.Text:='';
     Etiqueta4.Text:='';
     Image13.Visible:=True;
     Label3.Visible:=True;
end;

procedure TForm1.recarga_informacion;
begin
  panel5.Visible:=False;
  Master.Free;
  clave:='1234';
  Form1.Image2Click(self);

end;

procedure TForm1.libera_frame;
begin
  panel5.Visible:=False;
  Master.Free;
  //Form1.Visible:=True;
end;
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
 reset();
end;

procedure TForm1.Image12Click(Sender: TObject);

begin
  if clave.Length = 4 then
  begin
    try
       Datas.DataModule1.Query.SQL.Clear;
       Datas.DataModule1.Query.SQL.Add('SELECT NOMBRE,AGENTE,UPPER(ESTATUS) AS ESTATUS FROM AGENTE WHERE CLAVE = :CLAVE AND TIPO=:TIPO');
       Datas.DataModule1.Query.ParamByName('CLAVE').AsString:=Clave;
       Datas.DataModule1.Query.ParamByName('TIPO').AsString:='Mecanico';
       Datas.DataModule1.Query.ExecSQL;
        if Datas.DataModule1.Query.RecordCount = 1 then
        begin
           agente := Datas.DataModule1.Query.FieldByName('AGENTE').AsString;
           estatus := Datas.DataModule1.Query.FieldByName('ESTATUS').AsString;

          // id_user := Datas.DataModule1.Query.FieldByName('ID').AsInteger;
          estatus:=uppercase(estatus);

            if estatus = 'ALTA' then
            begin
              //ShowMessage('ERES UN USUARIO ACTIVO EN EL SISTEMA');
              Clave:='';
              Etiqueta1.Text:='';
              Etiqueta2.Text:='';
              Etiqueta3.Text:='';
              Etiqueta4.Text:='';
              Image13.Visible:=False;
              Label3.Visible:=False;
              Label2.Visible:=False;
              Label1.Visible:=False;


              Master := TFrame1.Create(Self);
              Master.Parent:= Panel5;
              Master.Visible:=True;
              Master.Name:='';
              Master.Nombre_Usuario.Text := Datas.DataModule1.Query.FieldByName('NOMBRE').AsString;
              Panel5.Visible:=True;
              condicional:=10;

            end
            else
            begin
              ShowMessage('Usuario dado de baja!');
              reset();
            end;


        end
        else
        begin
          ShowMessage('Clave incorrecta, vuelve a intentarlo');
          reset();


        end;



    finally
        Datas.DataModule1.Query.Close;
    end;
  end
  else
  begin
    ShowMessage('Debe ingresar una clave de 4 digitos');
  end;

  if condicional = 10 then
  begin
       Datas.DataModule1.Query.SQL.Clear;
       Datas.DataModule1.Query.SQL.Add('select t.id as ID, orden,tarea as actividad, cte.nombre as cliente,v.fecharequerida as fecha from actividad_taller t '+
       'left join venta v on v.id = t.orden '+
       'left join cte on cte.cliente = v.cliente where t.agente=:agente and t.estatus=:estatus ');
       Datas.DataModule1.Query.ParamByName('agente').AsString:=agente;
       Datas.DataModule1.Query.ParamByName('estatus').AsString:='TRABAJANDO';
       Datas.DataModule1.Query.ExecSQL;

       if Datas.DataModule1.Query.RecordCount > 0 then
       begin
       id_td := Datas.DataModule1.Query.FieldByName('orden').AsInteger;
       mi_id := Datas.DataModule1.Query.FieldByName('ID').AsInteger;
       Master.Actividad_Panel.Visible:=True;
       Master.BotonInicia.Enabled:=False;
       Master.BotonPendiente.Enabled:=True;
       Master.BotonFinaliza.Enabled:=True;
       Master.Cliente.Text := 'Cliente :'+ Datas.DataModule1.Query.FieldByName('cliente').AsString + ' Fecha Requerida: ' + Datas.DataModule1.Query.FieldByName('fecha').AsString;
       Master.Label1.Text:=Datas.DataModule1.Query.FieldByName('actividad').AsString;
       condicional:=40;
       end
       else
       begin
        Master.carga_ordenes;
       end;
  end;
end;

procedure TForm1.Image13Click(Sender: TObject);
begin
application.Terminate;
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
