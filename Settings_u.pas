unit Settings_u;

interface

uses
  Winapi.Windows, Winapi.Messages, Winapi.ShellApi, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

const
  WM_ICONTRAY = WM_USER + 100;

type
  TC4CVer = record
    public
      VersionA: Byte;
      VersionB: Byte;
      BuildA: Word;
      BuildB: Word;
  end;
  TSettings = class(TForm)
    Button1: TButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    TrayIconData: TNotifyIconData;
    function GetFmtFileVersion(const FileName: string = ''): TC4CVer;
    { Private declarations }
  public
    procedure TrayMessage(var Msg: TMessage); message WM_ICONTRAY;
    { Public declarations }
  end;

var
  Settings: TSettings;

implementation

{$R *.dfm}

procedure TSettings.Button1Click(Sender: TObject);
begin
  VCL.Forms.Application.Terminate;
end;

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
var
  AppVer: TC4CVer;
begin
  AppVer := GetFmtFileVersion(ParamStr(0));
  Settings.Caption := 'Quick-backup - settings v'+ IntToStr(AppVer.VersionA) + '.' + IntToStr(AppVer.VersionB) + '.' + IntToStr(AppVer.BuildA) + '.' + IntToStr(AppVer.BuildB);

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

function TSettings.GetFmtFileVersion(const FileName: string = ''): TC4CVer;
var
  sFileName: String;
  iBufferSize: DWORD;
  iDummy: DWORD;
  pBuffer: Pointer;
  pFileInfo: Pointer;
begin
  Result.VersionA := 0;
  Result.VersionB := 0;
  Result.BuildA := 0;
  Result.BuildB := 0;
  // get filename of exe/dll if no filename is specified
  sFileName := FileName;
  if (sFileName = '') then
  begin
    // prepare buffer for path and terminating #0
    SetLength(sFileName, MAX_PATH + 1);
    SetLength(sFileName, GetModuleFileName(hInstance, PChar(sFileName), MAX_PATH + 1));
  end;
  // get size of version info (0 if no version info exists)
  iBufferSize := GetFileVersionInfoSize(PChar(sFileName), iDummy);
  if (iBufferSize > 0) then
  begin
    GetMem(pBuffer, iBufferSize);
    try
    // get fixed file info (language independent)
    GetFileVersionInfo(PChar(sFileName), 0, iBufferSize, pBuffer);
    VerQueryValue(pBuffer, '\', pFileInfo, iDummy);
    // read version blocks
    Result.VersionA := HiWord(PVSFixedFileInfo(pFileInfo)^.dwFileVersionMS);
    Result.VersionB := LoWord(PVSFixedFileInfo(pFileInfo)^.dwFileVersionMS);
    Result.BuildA := HiWord(PVSFixedFileInfo(pFileInfo)^.dwFileVersionLS);
    Result.BuildB := LoWord(PVSFixedFileInfo(pFileInfo)^.dwFileVersionLS);
    finally
      FreeMem(pBuffer);
    end;
  end;
end;

end.
