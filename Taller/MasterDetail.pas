unit MasterDetail;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Layouts, FMX.Objects, FMX.ListView.Types,
  FMX.ListView.Appearances, FMX.ListView.Adapters.Base, FMX.ListView,
  FMX.TreeView, FMX.ScrollBox, FMX.Memo;

type
  TFrame1 = class(TFrame)
    ScaledLayout1: TScaledLayout;
    Panel1: TPanel;
    Rectangle1: TRectangle;
    Image2: TImage;
    Listado_interno: TMemo;
    Lista: TListView;
    Nombre_Usuario: TLabel;
    ids: TMemo;
    ListaDetalle: TListView;
    Detall: TMemo;
    Cliente: TLabel;
    Clientes: TMemo;
    Panel2: TPanel;
    Actividad_Panel: TPanel;
    Rectangle2: TRectangle;
    Label1: TLabel;
    Memo1: TMemo;
    Label2: TLabel;
    BotonInicia: TButton;
    BotonPendiente: TButton;
    BotonFinaliza: TButton;
    DetaillName: TMemo;
    estatusdetalle: TMemo;
    Image1: TImage;
    Label3: TLabel;
    Image3: TImage;
    Label4: TLabel;
    procedure ListaChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure ListaDetalleChange(Sender: TObject);
    procedure BotonIniciaClick(Sender: TObject);
    procedure BotonPendienteClick(Sender: TObject);
    procedure BotonFinalizaClick(Sender: TObject);
    procedure Image1Click(Sender: TObject);
    procedure Image3Click(Sender: TObject);
    procedure Label4Click(Sender: TObject);
    procedure Label3Click(Sender: TObject);
  private
    { Private declarations }
  public
  procedure carga_ordenes();
    { Public declarations }
  end;

implementation
uses datas,lprincipal;
{$R *.fmx}

procedure TFrame1.BotonFinalizaClick(Sender: TObject);
begin
       Datas.DataModule1.Query.SQL.Clear;
       Datas.DataModule1.Query.SQL.Add('update actividad_taller set fecha_fin=getdate(),estatus=:estat where ID=:id');
       Datas.DataModule1.Query.ParamByName('estat').AsString:='FINALIZADO';
       Datas.DataModule1.Query.ParamByName('id').AsInteger:=lprincipal.mi_id;
       Datas.DataModule1.Query.ExecSQL;



       Datas.DataModule1.Query.SQL.Clear;
       Datas.DataModule1.Query.SQL.Add('select distinct orden from actividad_taller where estatus in (:E1,:E2) AND AGENTE=:AGENTE AND ORDEN=:ORDEN');
       Datas.DataModule1.Query.ParamByName('E1').AsString:='PENDIENTE';
       Datas.DataModule1.Query.ParamByName('E2').AsString:='NO INICIADA';
       Datas.DataModule1.Query.ParamByName('ORDEN').AsInteger:=lprincipal.id_td;
       Datas.DataModule1.Query.ParamByName('AGENTE').AsString:=lprincipal.agente;
       Datas.DataModule1.Query.ExecSQL;

       if Datas.DataModule1.Query.RecordCount = 0 then
       begin
       Datas.DataModule1.Query.SQL.Clear;
       Datas.DataModule1.Query.SQL.Add('INSERT INTO TALLER_ORDEN (ORDEN,AGENTE) VALUES (:ORDEN,:AGENTE)');
       Datas.DataModule1.Query.ParamByName('ORDEN').AsInteger:=lprincipal.id_td;
       Datas.DataModule1.Query.ParamByName('AGENTE').AsString:=lprincipal.agente;
       Datas.DataModule1.Query.ExecSQL;
       end;

    ListaDetalle.items.Clear;
    Lista.Items.Clear;
    ids.Lines.Clear;
    Listado_interno.Lines.Clear;
    Clientes.Lines.Clear;
    Detall.Lines.Clear;
    estatusdetalle.Lines.Clear;
    DetaillName.Lines.Clear;
    Memo1.Lines.Clear;
    Cliente.Text:='Cliente';
    carga_ordenes;
    actividad_panel.Visible:=False;
    Label2.Visible:=False;
    Memo1.Visible:=False;
    botonfinaliza.Enabled:=False;
    botonpendiente.Enabled:=False;
    botoninicia.Enabled:=True;
end;

procedure TFrame1.BotonIniciaClick(Sender: TObject);
var
  nuevo_id : integer;
  estat : string;
begin
    //VERIFICAR QUE NO EXISTA NINGUNA TAREA PENDIENTE INGRESADA PENDIENTE
    try
       Datas.DataModule1.Query.SQL.Clear;
       Datas.DataModule1.Query.SQL.Add('select ID,ESTATUS AS ESTA from actividad_taller where orden=:id and agente=:agente and tarea=:tarea and estatus in (:estatus,:estatus1)');
       Datas.DataModule1.Query.ParamByName('id').AsInteger:=StrToInt(IDS.Lines.Strings[Lista.ItemIndex]);
       Datas.DataModule1.Query.ParamByName('estatus').AsString:='PENDIENTE';
       Datas.DataModule1.Query.ParamByName('estatus1').AsString:='NO INICIADA';
       Datas.DataModule1.Query.ParamByName('agente').AsString:=lprincipal.agente;
       Datas.DataModule1.Query.ParamByName('tarea').AsString:=label1.Text;
       Datas.DataModule1.Query.ExecSQL;

       if Datas.DataModule1.Query.RecordCount > 0 then
       begin

        estat := Datas.DataModule1.Query.FieldByName('ESTA').AsString;
        nuevo_id := Datas.DataModule1.Query.FieldByName('ID').AsInteger;
            if (estat = 'PENDIENTE') OR (estat = 'NO INICIADA')  then
            BEGIN
                  Datas.DataModule1.Query.SQL.Clear;
                  Datas.DataModule1.Query.SQL.Add('update actividad_taller set fecha_inicio=getdate(),estatus=:estat where ID=:orden and agente=:agente and estatus=:estatus');
                  Datas.DataModule1.Query.ParamByName('estat').AsString:='TRABAJANDO';
                  Datas.DataModule1.Query.ParamByName('orden').AsInteger:=nuevo_id;
                  Datas.DataModule1.Query.ParamByName('estatus').AsString:=estat;
                  Datas.DataModule1.Query.ParamByName('agente').AsString:=lprincipal.agente;
                  Datas.DataModule1.Query.ExecSQL;


            END;


       end
       else
       begin
          Datas.DataModule1.Query.SQL.Clear;
          Datas.DataModule1.Query.SQL.Add('insert into actividad_taller(orden,agente,tarea,fecha_inicio,estatus) values (:orden,:agente,:tarea,getdate(),:estatus)');
          Datas.DataModule1.Query.ParamByName('orden').AsInteger:=StrToInt(IDS.Lines.Strings[Lista.ItemIndex]);
          Datas.DataModule1.Query.ParamByName('agente').AsString:=lprincipal.agente;
          Datas.DataModule1.Query.ParamByName('tarea').AsString:=label1.Text;
          Datas.DataModule1.Query.ParamByName('estatus').AsString:='TRABAJANDO';
          Datas.DataModule1.Query.ExecSQL;
          showmessage('no hay registros');
       end;
    finally

    end;
    Lprincipal.Form1.Label3.Visible:=True;
  Lprincipal.Form1.Label2.Visible:=True;
  Lprincipal.Form1.Label1.Visible:=True;
     lprincipal.Form1.libera_frame;

end;

procedure TFrame1.BotonPendienteClick(Sender: TObject);
begin

       if (memo1.Visible = True) and (Memo1.Text.Length < 10) then

    begin
      ShowMessage('Debe ingresar una justificacion mayor a 10 caracteres');
    end;

          Label2.Visible:=True;
    Memo1.Visible:=True;


    if Memo1.Text.Length >= 10 then
    begin
    try
    Datas.DataModule1.Query.SQL.Clear;
    Datas.DataModule1.Query.SQL.Add('update actividad_taller set justificacion=:justi,estatus=:estatus, fecha_fin=getdate() where id=:id');
    Datas.DataModule1.Query.ParamByName('id').AsInteger:=Lprincipal.mi_id;
    Datas.DataModule1.Query.ParamByName('justi').AsString:=Memo1.Text;
    Datas.DataModule1.Query.ParamByName('estatus').AsString:='FINALIZADO';
    Datas.DataModule1.Query.ExecSQL;

    Datas.DataModule1.Query.SQL.Clear;
    Datas.DataModule1.Query.SQL.Add('insert into actividad_taller(orden,agente,tarea,estatus) values (:orden,:agente,:tarea,:estatus)');
                  Datas.DataModule1.Query.ParamByName('orden').AsInteger:=Lprincipal.id_td;
                  Datas.DataModule1.Query.ParamByName('agente').AsString:=lprincipal.agente;
                  Datas.DataModule1.Query.ParamByName('tarea').AsString:= Label1.Text;
                  Datas.DataModule1.Query.ParamByName('estatus').AsString:='PENDIENTE';
                  Datas.DataModule1.Query.ExecSQL;
    ListaDetalle.items.Clear;
    Lista.Items.Clear;
    ids.Lines.Clear;
    Listado_interno.Lines.Clear;
    Clientes.Lines.Clear;
    Detall.Lines.Clear;
    estatusdetalle.Lines.Clear;
    DetaillName.Lines.Clear;
    Memo1.Lines.Clear;
    Cliente.Text:='Cliente';
    carga_ordenes;
    actividad_panel.Visible:=False;
    Label2.Visible:=False;
    Memo1.Visible:=False;
    BotonPendiente.Enabled:=False;
    BotonFinaliza.Enabled:=False;
    BotonInicia.Enabled:=True;


    finally
    Datas.DataModule1.Query.Close;
    end;

    end ;


end;

procedure TFrame1.Button1Click(Sender: TObject);
begin
ListaDetalle.items.Clear;
end;

procedure TFrame1.carga_ordenes;
var
  listit : TListViewItem;
begin
  try
    Datas.DataModule1.Query.SQL.Clear;
    Datas.DataModule1.Query.SQL.Add('select DISTINCT V.ID as id, MOVID, cte.nombre as nombre, v.fecharequerida as requerida from venta v '+
    'left join ventad vd on vd.id=v.id '+
    'left join cte on cte.cliente = v.cliente '+
    'where YEAR(v.fechaemision)>=2017 and vd.agente=:agente and movid not like :guion and mov=:Servicio and v.estatus=:PENDIENTE AND V.ID NOT IN (SELECT DISTINCT ORDEN FROM TALLER_ORDEN WHERE agente=:AAG)');
    Datas.DataModule1.Query.ParamByName('agente').AsString:=LPrincipal.agente;
    Datas.DataModule1.Query.ParamByName('AAG').AsString:=LPrincipal.agente;
    Datas.DataModule1.Query.ParamByName('guion').AsString:='%'+'-'+'%';
    Datas.DataModule1.Query.ParamByName('PENDIENTE').AsString:='PENDIENTE';
    Datas.DataModule1.Query.ParamByName('Servicio').AsString:='Servicio';
    Datas.DataModule1.Query.ExecSQL;

    if Datas.DataModule1.Query.RecordCount > 0 then
    begin
      with Datas.DataModule1.Query do
        begin
          while not Datas.DataModule1.Query.Eof do
          begin
            Listit := Lista.Items.Add;
            Listit.Text := 'Orden' + ' - '+ Datas.DataModule1.Query.FieldByName('MOVID').AsString;
            //Listado_interno.Lines.Add(Datas.DataModule1.Query.FieldByName('ORDEN').AsString);
            IDS.Lines.Add(Datas.DataModule1.Query.FieldByName('id').AsString);
            Clientes.Lines.Add(Datas.DataModule1.Query.FieldByName('nombre').AsString + ' Fecha Requerida '+ Datas.DataModule1.Query.FieldByName('requerida').AsString);
            next;
          end;
        end;
    end;

  finally
    Datas.DataModule1.Query.Close;
  end;
end;

procedure TFrame1.Image1Click(Sender: TObject);
begin
  LPrincipal.Form1.reset;
  Lprincipal.Form1.Label3.Visible:=True;
  Lprincipal.Form1.Label2.Visible:=True;
  Lprincipal.Form1.Label1.Visible:=True;
  Lprincipal.Form1.libera_frame;
end;

procedure TFrame1.Image3Click(Sender: TObject);
begin
  Actividad_Panel.Visible:=False;
end;



procedure TFrame1.Label3Click(Sender: TObject);
begin
  LPrincipal.Form1.reset;
  Lprincipal.Form1.Label3.Visible:=True;
  Lprincipal.Form1.Label2.Visible:=True;
  Lprincipal.Form1.Label1.Visible:=True;
  Lprincipal.Form1.libera_frame;

end;

procedure TFrame1.Label4Click(Sender: TObject);
begin
  Actividad_Panel.Visible:=False;
  Label4.Visible:=False;
  Image3.Visible:=False;
end;

procedure TFrame1.ListaChange(Sender: TObject);
var
  listit : TListViewItem;
begin

    if lista.Selected <> nil then
  begin

    //VERIFICAR EXISTENCIA DE REGISTROS DE ORDEN EN ACTIVIDAD TALLER

    Listadetalle.items.Clear;
    Detall.Lines.Clear;
    DetaillName.Lines.Clear;
    EstatusDetalle.Lines.Clear;
    listado_interno.Lines.Clear;
    Datas.DataModule1.Query.SQL.Clear;
    Datas.DataModule1.Query.SQL.Add('SELECT * FROM actividad_taller WHERE ORDEN = :id');
    Datas.DataModule1.Query.ParamByName('id').AsInteger:=StrToInt(ids.Lines.Strings[Lista.ItemIndex]);
    Datas.DataModule1.Query.ExecSQL;

    //NO HAY NINGUN REGISTRO, ENTONCES SE CREAN
    if Datas.DataModule1.Query.RecordCount = 0 then
    begin
     Datas.DataModule1.Query.SQL.Clear;
     Datas.DataModule1.Query.SQL.Add('INSERT INTO ACTIVIDAD_TALLER(orden,agente,tarea,estatus) '+
     'select V.ID AS ID,VD.agente as agente, AR.DESCRIPCION1 AS TAREA, :es from venta v '+
     'left join ventad vd on vd.id = v.id '+
     'LEFT JOIN art ar on ar.ARTICULO = vd.articulo '+
     'left join agente a on a.agente = vd.agente '+
     'where a.tipo=:tipo and v.estatus=:estat  and ar.CATEGORIA=:cat and vd.id=:id');
     Datas.DataModule1.Query.ParamByName('tipo').AsString:='Mecanico';
     Datas.DataModule1.Query.ParamByName('estat').AsString:='PENDIENTE';
     Datas.DataModule1.Query.ParamByName('es').AsString:='NO INICIADA';
     Datas.DataModule1.Query.ParamByName('cat').AsString:='24-MANO DE OBRA';
     Datas.DataModule1.Query.ParamByName('id').AsInteger:= StrToInt(ids.Lines.Strings[Lista.ItemIndex]);
     Datas.DataModule1.Query.ExecSQL;

    end ;

    {if Datas.DataModule1.Query.RecordCount = 0 then
    begin
    Datas.DataModule1.Query.SQL.Clear;
    Datas.DataModule1.Query.SQL.Add('select a.descripcion1 as tarea from ventad vd '+
    'left join art a on vd.articulo=a.ARTICULO '+
    'where vd.agente=:agente and vd.id=:id');
    Datas.DataModule1.Query.ParamByName('id').AsInteger:=StrToInt(ids.Lines.Strings[Lista.ItemIndex]);
    Datas.DataModule1.Query.ParamByName('agente').AsString:=LPrincipal.agente;
    Datas.DataModule1.Query.ExecSQL;
    Cliente.Text := 'Cliente :'+ Clientes.Lines.Strings[lista.ItemIndex];
    end }


    Datas.DataModule1.Query.SQL.Clear;
    Datas.DataModule1.Query.SQL.Add('SELECT DISTINCT TAREA FROM actividad_taller WHERE ORDEN = :id AND AGENTE=:agente AND ESTATUS <> :estat');
    Datas.DataModule1.Query.ParamByName('id').AsInteger:=StrToInt(ids.Lines.Strings[Lista.ItemIndex]);
//    Datas.DataModule1.Query.ParamByName('idss').AsInteger:=StrToInt(ids.Lines.Strings[Lista.ItemIndex]);
    Datas.DataModule1.Query.ParamByName('agente').AsString:=LPrincipal.agente;
    Datas.DataModule1.Query.ParamByName('estat').AsString:='FINALIZADO';

    Datas.DataModule1.Query.ExecSQL;
    Cliente.Text := 'Cliente :'+ Clientes.Lines.Strings[lista.ItemIndex];



    try

   // if Datas.DataModule1.Query.RecordCount > 0 then
    begin
      with Datas.DataModule1.Query do
        begin
          while not Datas.DataModule1.Query.Eof do
          begin
            Listit := Listadetalle.Items.Add;
            Listit.Text := Datas.DataModule1.Query.FieldByName('tarea').AsString;
            //Detall.Lines.Add(Datas.DataModule1.Query.FieldByName('id').AsString);
            DetaillName.Lines.Add(Datas.DataModule1.Query.FieldByName('tarea').AsString);
            //estatusdetalle.Lines.Add(Datas.DataModule1.Query.FieldByName('estatus').AsString);

            next;
          end;
        end;
    end;

  finally
    Datas.DataModule1.Query.Close;
  end;

  end;


end;

procedure TFrame1.ListaDetalleChange(Sender: TObject);
begin
        if listadetalle.Selected <> nil then
        begin
             label1.Text:=DetaillName.Lines.Strings[Listadetalle.ItemIndex];
             Actividad_panel.Visible:=True;
              BotonInicia.Enabled:=True;
              Label4.Visible:=True;
              Image3.Visible:=True;
         {    if estatusdetalle.Lines.Strings[Listadetalle.ItemIndex] = 'NO INICIADA' then
             begin

             end;
                 }
        end;
end;

end.
