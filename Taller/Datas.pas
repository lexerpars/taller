unit Datas;

interface

uses
  System.SysUtils, System.Classes, UniProvider, SQLServerUniProvider, Data.DB,
  MemDS, DBAccess, Uni;

type
  TDataModule1 = class(TDataModule)
    Conexion: TUniConnection;
    Query: TUniQuery;
    SQLServerUniProvider1: TSQLServerUniProvider;
    DataSource1: TDataSource;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  DataModule1: TDataModule1;

implementation

{%CLASSGROUP 'FMX.Controls.TControl'}

{$R *.dfm}

end.
