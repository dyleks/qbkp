program qbkp;

uses
  Vcl.Forms,
  Settings_u in 'Settings_u.pas' {Settings};

{$R *.res}

begin
  Application.Initialize;
  Application.ShowMainForm := False;
  Application.MainFormOnTaskbar := False;
  Application.CreateForm(TSettings, Settings);
  Application.Run;
end.
