unit Settings_u;

interface

uses
  Winapi.Windows, Winapi.Messages, Winapi.ShellApi, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs;

const
  WM_ICONTRAY = WM_USER + 100;

type
  TSettings = class(TForm)
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
  private
    TrayIconData: TNotifyIconData;
    { Private declarations }
  public
    procedure TrayMessage(var Msg: TMessage); message WM_ICONTRAY;
    { Public declarations }
  end;

var
  Settings: TSettings;

implementation

{$R *.dfm}

procedure TSettings.FormCreate(Sender: TObject);
begin
  with TrayIconData do
  begin
    cbSize := System.SizeOf(TrayIconData);
    Wnd := Handle;
    uID := 0;
    uFlags := NIF_MESSAGE + NIF_ICON + NIF_TIP;
    uCallbackMessage := WM_ICONTRAY;
    hIcon := Application.Icon.Handle;
    StrPCopy(szTip, Application.Title);
    end;
    Shell_NotifyIcon(NIM_ADD, @TrayIconData);
  end;

procedure TSettings.FormDestroy(Sender: TObject);
begin
  Shell_NotifyIcon(NIM_DELETE, @TrayIconData);
end;

procedure TSettings.TrayMessage(var Msg: TMessage);
begin
  case Msg.lParam of
  WM_LBUTTONDOWN:
    begin
      ShowMessage('Left button clicked - let''s SHOW the Form!');
      Settings.ShowModal;
    end;
  WM_RBUTTONDOWN:
    begin
      ShowMessage('Right button clicked - let''s HIDE the Form!');
      ModalResult := mrClose;
    end;
  end;
end;

end.
