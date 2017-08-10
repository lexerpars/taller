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
    procedure ListaChange(Sender: TObject);
  private
    { Private declarations }
  public
  procedure carga_ordenes();
    { Public declarations }
  end;

implementation
uses datas;
{$R *.fmx}

procedure TFrame1.carga_ordenes;
var
  listit : TListViewItem;
begin
  try
    Datas.DataModule2.Query.SQL.Clear;
    Datas.DataModule2.Query.SQL.Add('SELECT VALOR FROM TEST');
    Datas.DataModule2.Query.ExecSQL;

    if Datas.DataModule2.Query.RecordCount > 0 then
    begin
      with Datas.DataModule2.Query do
        begin
          while not Datas.DataModule2.Query.Eof do
          begin
            Listit := Lista.Items.Add;
            Listit.Text := Datas.DataModule2.Query.FieldByName('VALOR').AsString;
            Listado_interno.Lines.Add(Datas.DataModule2.Query.FieldByName('VALOR').AsString);
            next;
          end;
        end;
    end;

  finally
    Datas.DataModule2.Query.Close;
  end;
end;

procedure TFrame1.ListaChange(Sender: TObject);
begin
  if lista.Selected <> nil then
  begin
    showMessage(Listado_interno.Lines.Strings[Lista.ItemIndex]);

  end;
end;

end.
