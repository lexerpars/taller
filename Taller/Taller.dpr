program Taller;

uses
  System.StartUpCopy,
  FMX.Forms,
  LPrincipal in 'LPrincipal.pas' {Form1},
  MasterDetail in 'MasterDetail.pas' {Frame1: TFrame},
  Datas in 'Datas.pas' {DataModule1: TDataModule};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.CreateForm(TDataModule1, DataModule1);
  Application.Run;
end.
