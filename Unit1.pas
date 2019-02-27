unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, XPMan, ShlObj, IniFiles;

type
  TForm1 = class(TForm)
    GameCB: TComboBox;
    SelectGameLbl: TLabel;
    XPManifest: TXPManifest;
    GameGB: TGroupBox;
    WindowModeCB: TCheckBox;
    VideoGB: TGroupBox;
    DebugMenuCB: TCheckBox;
    ResolutionsCB: TComboBox;
    ResolutionLbl: TLabel;
    FOVLbl: TLabel;
    FOVCB: TComboBox;
    ApplyBtn: TButton;
    CloseBtn: TButton;
    AboutBtn: TButton;
    ResolutionWndLbl: TLabel;
    ResolutionsWndCB: TComboBox;
    HardwareAccelerationCB: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure GameCBChange(Sender: TObject);
    procedure ApplyBtnClick(Sender: TObject);
    procedure CloseBtnClick(Sender: TObject);
    procedure AboutBtnClick(Sender: TObject);
  private
    procedure DefaultSettings;
    procedure UpdateSettings;
    { Private declarations }
  public
    { Public declarations }
  end;

const
  HP1DocPath = 'Harry Potter';
  HP2DocPath = 'Harry Potter II';
  HP2PrototypeDocPath = 'Harry Potter and the Chamber of Secrets';
  HP2Demo1DocPath = 'Harry Potter II - Demo 1';
  HP2Demo2DocPath = 'Harry Potter II - Demo 2';
  HP1MainConfig = 'HP.ini';
  HP2MainConfig = 'Game.ini';
  HP3MainConfig = 'hppoa.ini';

var
  Form1: TForm1;
  HP3DocPath: string;

  IDS_DONE: string;

implementation

{$R *.dfm}
{$R UAC.RES} //Права для редактирования атрибутов файлов

function DocumentsPath: string;
var
  SpecialDir: PItemIdList;
begin
  SetLength(Result, MAX_PATH);
  SHGetSpecialFolderLocation(Application.Handle, CSIDL_PERSONAL, SpecialDir);
  SHGetPathFromIDList(SpecialDir, PChar(Result));
  SetLength(Result, lStrLen(PChar(Result)));
end;

function GetLocaleInformation(flag: integer): string;
var
  pcLCA: array [0..20] of Char;
begin
  if GetLocaleInfo(LOCALE_SYSTEM_DEFAULT, flag, pcLCA, 19) <= 0 then
    pcLCA[0]:=#0;
  Result:=pcLCA;
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  Ini: TIniFile;
begin
  Application.Title:=Caption;

  if FileExists(ExtractFilePath(ParamStr(0)) + 'Resolutions.txt') then begin
    ResolutionsCB.Items.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'Resolutions.txt');
    ResolutionsWndCB.Items.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'Resolutions.txt');
  end;

  if FileExists(ExtractFilePath(ParamStr(0)) + 'FOVs.txt') then
    FOVCB.Items.LoadFromFile(ExtractFilePath(ParamStr(0)) + 'FOVs.txt');

  //Ищем и добавляем установленные игры
  if FileExists(DocumentsPath + '\' + HP1DocPath + '\' + HP1MainConfig) and FileExists(DocumentsPath + '\' + HP1DocPath + '\User.ini') then
    GameCB.Items.Add('Harry Potter I');

  if FileExists(DocumentsPath + '\' + HP2DocPath + '\' + HP2MainConfig) and FileExists(DocumentsPath + '\' + HP2DocPath + '\User.ini') then
    GameCB.Items.Add('Harry Potter II');

  if FileExists(DocumentsPath + '\' + HP2PrototypeDocPath + '\' + HP2MainConfig) and FileExists(DocumentsPath + '\' + HP2PrototypeDocPath + '\User.ini') then
    GameCB.Items.Add('Harry Potter II Prototype');

  if FileExists(DocumentsPath + '\' + HP2Demo1DocPath + '\' + HP2MainConfig) and FileExists(DocumentsPath + '\' + HP2Demo1DocPath + '\User.ini') then
    GameCB.Items.Add('Harry Potter II - Demo 1');

  if FileExists(DocumentsPath + '\' + HP2Demo2DocPath + '\' + HP2MainConfig) and FileExists(DocumentsPath + '\' + HP2Demo2DocPath + '\User.ini') then
    GameCB.Items.Add('Harry Potter II - Demo 2');

  if DirectoryExists(DocumentsPath + '\' + 'Harry Potter and the Prisoner of Azkaban') then
    HP3DocPath:='Harry Potter and the Prisoner of Azkaban';
  if DirectoryExists(DocumentsPath + '\' + 'Гарри Поттер и узник Азкабана') then
    HP3DocPath:='Гарри Поттер и узник Азкабана';

  if FileExists(DocumentsPath + '\' + HP3DocPath + '\' + HP3MainConfig) then
    GameCB.Items.Add('Harry Potter III');

  //Если игр не найдено, то блокируем выбор игры
  if GameCB.Items.Count = 0 then begin
    GameCB.Text:='...';
    GameCB.Enabled:=false;
  end else
    GameCB.ItemIndex:=0;

  UpdateSettings;

  //Перевод
  if DirectoryExists(ExtractFilePath(ParamStr(0)) + 'Languages') then begin
    if FileExists(ExtractFilePath(ParamStr(0)) + 'Languages\' + GetLocaleInformation(LOCALE_SENGLANGUAGE) + '.ini') then
      Ini:=TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'Languages\' + GetLocaleInformation(LOCALE_SENGLANGUAGE) + '.ini')
    else
      Ini:=TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'Languages\English.ini');

    SelectGameLbl.Caption:=Ini.ReadString('Main', 'ID_SELECT_GAME', '');
    GameGB.Caption:=Ini.ReadString('Main', 'ID_GAME', '');
    WindowModeCB.Caption:=Ini.ReadString('Main', 'ID_RUN_IN_WINDOW', '');
    HardwareAccelerationCB.Caption:=Ini.ReadString('Main', 'ID_HARDWARE_ACCELERATION', '');
    DebugMenuCB.Caption:=Ini.ReadString('Main', 'ID_DEBUG_MODE', '');
    VideoGB.Caption:=Ini.ReadString('Main', 'ID_VIDEO', '');
    ResolutionLbl.Caption:=Ini.ReadString('Main', 'ID_FULLSCREEN_RESOLUTION', '');
    ResolutionWndLbl.Caption:=Ini.ReadString('Main', 'ID_WINDOW_RESOLUTION', '');
    FOVLbl.Caption:=Ini.ReadString('Main', 'ID_FOV', '');
    ApplyBtn.Caption:=Ini.ReadString('Main', 'ID_APPLY', '');
    IDS_DONE:=Ini.ReadString('Main', 'ID_DONE', '');
    CloseBtn.Caption:=Ini.ReadString('Main', 'ID_CLOSE', '');

    Ini.Free;
  end;
end;

procedure TForm1.UpdateSettings;
var
  Ini: TIniFile;
  MainConfigPath, SubConfigPath: string;
begin
  if GameCB.Text = '...' then Exit;

  if GameCB.Text = 'Harry Potter I' then begin
    MainConfigPath:=DocumentsPath + '\' + HP1DocPath + '\' + HP1MainConfig;
    SubConfigPath:=DocumentsPath + '\' + HP1DocPath + '\User.ini';
  end;

  if GameCB.Text = 'Harry Potter II' then begin
    MainConfigPath:=DocumentsPath + '\' + HP2DocPath + '\' + HP2MainConfig;
    SubConfigPath:=DocumentsPath + '\' + HP2DocPath + '\User.ini';
  end;

  if GameCB.Text = 'Harry Potter II Prototype' then begin
    MainConfigPath:=DocumentsPath + '\' + HP2PrototypeDocPath + '\' + HP2MainConfig;
    SubConfigPath:=DocumentsPath + '\' + HP2PrototypeDocPath + '\User.ini';
  end;

  if GameCB.Text = 'Harry Potter II - Demo 1' then begin
    MainConfigPath:=DocumentsPath + '\' + HP2Demo1DocPath + '\' + HP2MainConfig;
    SubConfigPath:=DocumentsPath + '\' + HP2Demo1DocPath + '\User.ini';
  end;

  if GameCB.Text = 'Harry Potter II - Demo 2' then begin
    MainConfigPath:=DocumentsPath + '\' + HP2Demo2DocPath + '\' + HP2MainConfig;
    SubConfigPath:=DocumentsPath + '\' + HP2Demo2DocPath + '\User.ini';
  end;

  if GameCB.Text = 'Harry Potter III' then
    MainConfigPath:=DocumentsPath + '\' + HP3DocPath + '\' + HP3MainConfig;

  Ini:=TIniFile.Create(MainConfigPath);
  //Запуск в окне
  WindowModeCB.Checked:=Ini.ReadString('WinDrv.WindowsClient', 'StartupFullscreen', 'True') <> 'True';

  //Аппаратное ускорение
  if GameCB.Text <> 'Harry Potter III' then
    HardwareAccelerationCB.Checked:=not Ini.ReadBool('FirstRun', 'ForceSoftware', False)
  else begin
    HardwareAccelerationCB.Checked:=true;
    HardwareAccelerationCB.Enabled:=false;
  end;

  //Режим отладки
  if GameCB.Text = 'Harry Potter I' then
    DebugMenuCB.Checked:=(Ini.ReadString('HPBase.baseConsole', 'bDebugMode', 'False') = 'True') and (Ini.ReadString('HPMenu.HPConsole', 'bShowConsole', 'False') = 'True');

  if (GameCB.Text = 'Harry Potter II') or (GameCB.Text = 'Harry Potter II - Demo 1') or (GameCB.Text = 'Harry Potter II - Demo 2') then
    DebugMenuCB.Checked:=(Ini.ReadString('HGame.HPConsole', 'bDebugMode', 'False') = 'True') and (Ini.ReadString('HGame.HPConsole', 'bshowconsole', 'False') = 'True') and (Ini.ReadString('HGame.baseConsole', 'bDebugMode', 'False') = 'True');

  if GameCB.Text = 'Harry Potter II Prototype' then
    DebugMenuCB.Checked:=(Ini.ReadString('HGame.baseConsole', 'bDebugMode', 'False') = 'True') and (Ini.ReadString('HGame.HPConsole', 'bShowConsole', 'False') = 'True');

  if GameCB.Text = 'Harry Potter III' then
    DebugMenuCB.Checked:=(Ini.ReadString('HGame.baseConsole', 'bDebugMode', 'False') = 'True');

  //Разрешение в полноэкранном режиме
  ResolutionsCB.Text:=IntToStr(Ini.ReadInteger('WinDrv.WindowsClient', 'FullscreenViewportX', 640)) + 'x' + IntToStr(Ini.ReadInteger('WinDrv.WindowsClient', 'FullscreenViewportY', 480));

  //Разрешение в окне
  ResolutionsWndCB.Text:=IntToStr(Ini.ReadInteger('WinDrv.WindowsClient', 'WindowedViewportX', 640)) + 'x' + IntToStr(Ini.ReadInteger('WinDrv.WindowsClient', 'WindowedViewportY', 480));

  if GameCB.Text = 'Harry Potter III' then
    FOVCB.Text:=Ini.ReadString('Engine.PlayerController', 'DesiredFOV', '90');

  Ini.Free;

  if GameCB.Text <> 'Harry Potter III' then begin
    Ini:=TIniFile.Create(SubConfigPath);
    FOVCB.Text:=Ini.ReadString('Engine.PlayerPawn', 'DesiredFOV', '90');
    Ini.Free;
  end;
end;

procedure TForm1.GameCBChange(Sender: TObject);
begin
  DefaultSettings;
  UpdateSettings;
end;

procedure TForm1.DefaultSettings;
begin
  WindowModeCB.Checked:=false;
  HardwareAccelerationCB.Enabled:=true;
  HardwareAccelerationCB.Checked:=false;
  DebugMenuCB.Checked:=false;
  ResolutionsCB.Text:='640x480';
  ResolutionsWndCB.Text:=ResolutionsCB.Text;
  FOVCB.Text:='90 (4:3)';
end;

procedure TForm1.ApplyBtnClick(Sender: TObject);
var
  Ini: TIniFile;
  ResWidth, ResHeight: integer;
  FOV: string;
  MainConfigPath, SubConfigPath: string;
begin
  if GameCB.Text = 'Harry Potter I' then begin
    MainConfigPath:=DocumentsPath + '\' + HP1DocPath + '\' + HP1MainConfig;
    SubConfigPath:=DocumentsPath + '\' + HP1DocPath + '\User.ini';
  end;

  if GameCB.Text = 'Harry Potter II' then begin
    MainConfigPath:=DocumentsPath + '\' + HP2DocPath + '\' + HP2MainConfig;
    SubConfigPath:=DocumentsPath + '\' + HP2DocPath + '\User.ini';
  end;

  if GameCB.Text = 'Harry Potter II Prototype' then begin
    MainConfigPath:=DocumentsPath + '\' + HP2PrototypeDocPath + '\' + HP2MainConfig;
    SubConfigPath:=DocumentsPath + '\' + HP2PrototypeDocPath + '\User.ini';
  end;

  if GameCB.Text = 'Harry Potter II - Demo 1' then begin
    MainConfigPath:=DocumentsPath + '\' + HP2Demo1DocPath + '\' + HP2MainConfig;
    SubConfigPath:=DocumentsPath + '\' + HP2Demo1DocPath + '\User.ini';
  end;

  if GameCB.Text = 'Harry Potter II - Demo 2' then begin
    MainConfigPath:=DocumentsPath + '\' + HP2Demo2DocPath + '\' + HP2MainConfig;
    SubConfigPath:=DocumentsPath + '\' + HP2Demo2DocPath + '\User.ini';
  end;

  if GameCB.Text = 'Harry Potter III' then
    MainConfigPath:=DocumentsPath + '\' + HP3DocPath + '\' + HP3MainConfig;

  //Атрибы для редактирования
  if FileGetAttr(MainConfigPath) = faReadOnly then
    FileSetAttr(MainConfigPath, not faReadOnly);
  if FileGetAttr(SubConfigPath) = faReadOnly then
    FileSetAttr(SubConfigPath, not faReadOnly);

  Ini:=TIniFile.Create(MainConfigPath);
  //Запуск в окне
  if WindowModeCB.Checked then
    Ini.WriteString('WinDrv.WindowsClient', 'StartupFullscreen', 'False')
  else
    Ini.WriteString('WinDrv.WindowsClient', 'StartupFullscreen', 'True');

  //Аппаратное ускорение
  if GameCB.Text <> 'Harry Potter III' then
    Ini.WriteBool('FirstRun', 'ForceSoftware', not HardwareAccelerationCB.Checked);

  //Режим отладки
  if GameCB.Text = 'Harry Potter I' then
    if DebugMenuCB.Checked then begin
      Ini.WriteString('HPBase.baseConsole', 'bDebugMode', 'True');
      Ini.WriteString('HPMenu.HPConsole', 'bShowConsole', 'True');
    end else begin
      Ini.WriteString('HPBase.baseConsole', 'bDebugMode', 'False');
      Ini.WriteString('HPMenu.HPConsole', 'bShowConsole', 'False');
    end;

  if (GameCB.Text = 'Harry Potter II') or (GameCB.Text = 'Harry Potter II - Demo 1') or (GameCB.Text = 'Harry Potter II - Demo 2') then
    if DebugMenuCB.Checked then begin
      Ini.WriteString('HGame.HPConsole', 'bDebugMode', 'True');
      Ini.WriteString('HGame.HPConsole', 'bshowconsole', 'True');
      Ini.WriteString('HGame.baseConsole', 'bDebugMode', 'True');
    end else begin
      Ini.WriteString('HGame.HPConsole', 'bDebugMode', 'False');
      Ini.WriteString('HGame.HPConsole', 'bshowconsole', 'False');
      Ini.WriteString('HGame.baseConsole', 'bDebugMode', 'False');
    end;

  if (GameCB.Text = 'Harry Potter II Prototype') then
    if DebugMenuCB.Checked then begin
      Ini.WriteString('HGame.baseConsole', 'bDebugMode', 'True');
      Ini.WriteString('HGame.HPConsole', 'bShowConsole', 'True');
    end else begin
      Ini.WriteString('HGame.baseConsole', 'bDebugMode', 'False');
      Ini.WriteString('HGame.HPConsole', 'bShowConsole', 'False');
    end;

  if (GameCB.Text = 'Harry Potter III') then
    if DebugMenuCB.Checked then begin
      Ini.WriteString('HGame.baseConsole', 'bDebugMode', 'True');
      Ini.WriteString('HGame.baseConsole', 'bUseSystemFonts', 'True');
    end else
      Ini.WriteString('HGame.baseConsole', 'bDebugMode', 'False');

  if (GameCB.Text = 'Harry Potter I') or (GameCB.Text = 'Harry Potter II Prototype')
  or (GameCB.Text = 'Harry Potter II - Demo 1') or (GameCB.Text = 'Harry Potter II - Demo 2') then
    Ini.WriteInteger('WinDrv.WindowsClient', 'FullscreenColorBits', 32); //По умолчанию стоит 16
  if GameCB.Text = 'Harry Potter II - Demo 2' then
    Ini.WriteInteger('WinDrv.WindowsClient', 'WindowedColorBits', 32); //По умолчанию стоит 16

  //Разрешение в полноэкранном режиме
  ResWidth:=StrToIntDef(Copy(ResolutionsCB.Text, 1, Pos('x', ResolutionsCB.Text) - 1), 640);
  ResHeight:=StrToIntDef(Copy(ResolutionsCB.Text, Pos('x', ResolutionsCB.Text) + 1, Length(ResolutionsCB.Text)), 480);
  Ini.WriteInteger('WinDrv.WindowsClient', 'FullscreenViewportX', ResWidth);
  Ini.WriteInteger('WinDrv.WindowsClient', 'FullscreenViewportY', ResHeight);

  //Разрешение в окне
  ResWidth:=StrToIntDef(Copy(ResolutionsWndCB.Text, 1, Pos('x', ResolutionsWndCB.Text) - 1), 640);
  ResHeight:=StrToIntDef(Copy(ResolutionsWndCB.Text, Pos('x', ResolutionsWndCB.Text) + 1, Length(ResolutionsWndCB.Text)), 480);
  Ini.WriteInteger('WinDrv.WindowsClient', 'WindowedViewportX', ResWidth);
  Ini.WriteInteger('WinDrv.WindowsClient', 'WindowedViewportY', ResHeight);

  FOV:=FOVCB.Text;
  if Pos('(', FOV) > 0 then
    FOV:=Copy(FOV, 1, Pos(' ', FOV) - 1);

  if GameCB.Text = 'Harry Potter III' then begin
    Ini.WriteString('Engine.PlayerController', 'DesiredFOV', FOV);
    Ini.WriteString('Engine.PlayerController', 'DefaultFOV', FOV);
    Ini.WriteString('Engine.Engine', 'RenderDevice', 'OpenGLDrv.OpenGLRenderDevice'); //Исправление Windows 10? На Windows 7 не работает
  end;

  Ini.Free;

  if (GameCB.Text <> 'Harry Potter III') then begin
    Ini:=TIniFile.Create(SubConfigPath);
    Ini.WriteString('Engine.PlayerPawn', 'DesiredFOV', FOV);
    Ini.WriteString('Engine.PlayerPawn', 'DefaultFOV', FOV);
    Ini.WriteString('Engine.Input', 'F10', 'flush'); //Исправление проблем с прозрачностью текстур
    Ini.Free;
  end;

  //Атрибы только для чтения
  FileSetAttr(MainConfigPath, faReadOnly);
  FileSetAttr(SubConfigPath, faReadOnly);

  Application.MessageBox(PChar(IDS_DONE), PChar(Caption), MB_ICONINFORMATION);
end;

procedure TForm1.AboutBtnClick(Sender: TObject);
begin
  Application.MessageBox(PChar(Caption + ' 1.0' + #13#10 +
  'Последнее обновление: 27.02.2019' + #13#10 +
  'https://r57zone.github.io' + #13#10 +
  'r57zone@gmail.com' + #13#10 + #13#10 +
  'Клавиши:' + #13#10 +
  'F10 - исправление проблем с текстурами;'
  ), PChar(Caption), MB_ICONINFORMATION);
end;

procedure TForm1.CloseBtnClick(Sender: TObject);
begin
  Close();
end;

end.
