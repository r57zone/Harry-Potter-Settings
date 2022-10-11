unit Unit1;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ShlObj, IniFiles;

type
  TMain = class(TForm)
    GameCB: TComboBox;
    SelectGameLbl: TLabel;
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
    SettingsReadOnlyCB: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure GameCBChange(Sender: TObject);
    procedure ApplyBtnClick(Sender: TObject);
    procedure CloseBtnClick(Sender: TObject);
    procedure AboutBtnClick(Sender: TObject);
    procedure ResolutionsCBChange(Sender: TObject);
    procedure ResolutionsWndCBChange(Sender: TObject);
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
  Main: TMain;
  HP3DocPath: string;

  IDS_NO_GAMES_FOUND, IDS_DONE, IDS_DONE_HP1_2, IDS_DONE_HP3, IDS_HARDWARE_ACCELERATION, IDS_DIRECTX, IDS_WARNING_HW_DISABLED, IDS_LAST_UPDATE: string;

implementation

{$R *.dfm}
{$R UAC.RES} // Права для редактирования атрибутов файлов

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

procedure TMain.FormCreate(Sender: TObject);
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

  // Ищем и добавляем установленные игры
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
    HP3DocPath:='Harry Potter and the Prisoner of Azkaban'
  else if DirectoryExists(DocumentsPath + '\' + 'Гарри Поттер и узник Азкабана') then // Russian
    HP3DocPath:='Гарри Поттер и узник Азкабана'
  else if DirectoryExists(DocumentsPath + '\' + 'Harry Potter™ e il prigioniero di Azkaban') then // Italian
    HP3DocPath:='Harry Potter™ e il prigioniero di Azkaban'
  else if DirectoryExists(DocumentsPath + '\' + 'Harry Potter och Fången från Azkaban') then // Swedish
    HP3DocPath:='Harry Potter och Fången från Azkaban'
  else if DirectoryExists(DocumentsPath + '\' + 'Harry Potter™ en de Gevangene van Azkaban') then // Dutch
    HP3DocPath:='Harry Potter™ en de Gevangene van Azkaban'
  else if DirectoryExists(DocumentsPath + '\' + 'Harry Potter et le prisonnier d''Azkaban') then // French
    HP3DocPath:='Harry Potter et le prisonnier d''Azkaban'
  else if DirectoryExists(DocumentsPath + '\' + 'Harry Potter und der Gefangene von Askaban') then // German
    HP3DocPath:='Harry Potter und der Gefangene von Askaban'
  else if DirectoryExists(DocumentsPath + '\' + 'Harry Potter a vězeň z Azkabanu') then // Czech
    HP3DocPath:='Harry Potter a vězeň z Azkabanu'
  else if DirectoryExists(DocumentsPath + '\' + 'Harry Potter i więzień Azkabanu') then // Polish
    HP3DocPath:='Harry Potter i więzień Azkabanu'
  else if DirectoryExists(DocumentsPath + '\' + 'Harry Potter og fangen fra Azkaban') then // Danish
    HP3DocPath:='Harry Potter og fangen fra Azkaban'
  else if DirectoryExists(DocumentsPath + '\' + 'Harry Potter og Fangen fra Azkaban') then // Norwegian
    HP3DocPath:='Harry Potter og Fangen fra Azkaban'
  else if DirectoryExists(DocumentsPath + '\' + 'Harry Potter y el prisionero de Azkaban') then // Spanish
    HP3DocPath:='Harry Potter y el prisionero de Azkaban'
  else if DirectoryExists(DocumentsPath + '\' + 'Harry Potter(tm) e o Prisioneiro de Azkaban') then // Portuguese (Brazil)
    HP3DocPath:='Harry Potter(tm) e o Prisioneiro de Azkaban'
  else if DirectoryExists(DocumentsPath + '\' + 'Harry Potter e o Prisioneiro de Azkaban') then // Portuguese (Portugal)
    HP3DocPath:='Harry Potter e o Prisioneiro de Azkaban'
  else if DirectoryExists(DocumentsPath + '\' + 'ハリー・ポッターとアズカバンの囚人') then // Japanese
    HP3DocPath:='ハリー・ポッターとアズカバンの囚人'
  else if DirectoryExists(DocumentsPath  + '\' + 'แฮร์รี่ พอตเตอร์กับนักโทษแห่งอัซคาบัน') then // Thai
    HP3DocPath:='แฮร์รี่ พอตเตอร์กับนักโทษแห่งอัซคาบัน'
  else if DirectoryExists(DocumentsPath  + '\' + '哈利·波特和阿兹卡班的囚徒') then // Chinese (Simplified)
    HP3DocPath:='哈利·波特和阿兹卡班的囚徒'
  else if DirectoryExists(DocumentsPath  + '\' + '哈利波特－阿茲卡班的囚犯') then // Chinese (Traditional)
    HP3DocPath:='哈利波特－阿茲卡班的囚犯';

  if FileExists(DocumentsPath + '\' + HP3DocPath + '\' + HP3MainConfig) then
    GameCB.Items.Add('Harry Potter III');

  // Если игр не найдено, то блокируем выбор игры
  if GameCB.Items.Count = 0 then begin
    GameCB.Text:='...';
    GameCB.Enabled:=false;
  end else
    GameCB.ItemIndex:=0;

  UpdateSettings;

  // Перевод
  if DirectoryExists(ExtractFilePath(ParamStr(0)) + 'Languages') then begin
    if FileExists(ExtractFilePath(ParamStr(0)) + 'Languages\' + GetLocaleInformation(LOCALE_SENGLANGUAGE) + '.ini') then
      Ini:=TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'Languages\' + GetLocaleInformation(LOCALE_SENGLANGUAGE) + '.ini')
    else
      Ini:=TIniFile.Create(ExtractFilePath(ParamStr(0)) + 'Languages\English.ini');

    SelectGameLbl.Caption:=Ini.ReadString('Main', 'IDS_SELECT_GAME', '');
    GameGB.Caption:=Ini.ReadString('Main', 'IDS_GAME', '');
    WindowModeCB.Caption:=Ini.ReadString('Main', 'IDS_RUN_IN_WINDOW', '');
    IDS_HARDWARE_ACCELERATION:=Ini.ReadString('Main', 'IDS_HARDWARE_ACCELERATION', '');
    HardwareAccelerationCB.Caption:=IDS_HARDWARE_ACCELERATION; //Используется из-за HP3 OpenGL / DirectX
    DebugMenuCB.Caption:=Ini.ReadString('Main', 'IDS_DEBUG_MODE', '');
    SettingsReadOnlyCB.Caption:=Ini.ReadString('Main', 'IDS_SETTINGS_READ_ONLY', '');
    VideoGB.Caption:=Ini.ReadString('Main', 'IDS_VIDEO', '');
    ResolutionLbl.Caption:=Ini.ReadString('Main', 'IDS_FULLSCREEN_RESOLUTION', '');
    ResolutionWndLbl.Caption:=Ini.ReadString('Main', 'IDS_WINDOW_RESOLUTION', '');
    FOVLbl.Caption:=Ini.ReadString('Main', 'IDS_FOV', '');
    ApplyBtn.Caption:=Ini.ReadString('Main', 'IDS_APPLY', '');
    IDS_NO_GAMES_FOUND:=Ini.ReadString('Main', 'IDS_NO_GAMES_FOUND', '');
    IDS_DONE:=Ini.ReadString('Main', 'IDS_DONE', '');
    IDS_DONE_HP1_2:=Ini.ReadString('Main', 'IDS_DONE_HP1_2', '');
    IDS_DONE_HP3:=Ini.ReadString('Main', 'IDS_DONE_HP3', '');
    IDS_DIRECTX:=Ini.ReadString('Main', 'IDS_DIRECTX', '');
    IDS_WARNING_HW_DISABLED:=Ini.ReadString('Main', 'IDS_WARNING_HW_DISABLED', '');
    IDS_LAST_UPDATE:=Ini.ReadString('Main', 'IDS_LAST_UPDATE', '');
    CloseBtn.Caption:=Ini.ReadString('Main', 'IDS_CLOSE', '');

    Ini.Free;
  end;
end;

procedure TMain.UpdateSettings;
var
  Ini: TIniFile;
  MainConfigPath, SubConfigPath: string;
begin
  if GameCB.Text = '...' then Exit;

  HardwareAccelerationCB.Caption:=IDS_HARDWARE_ACCELERATION;

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

  if GameCB.Text = 'Harry Potter III' then begin
    MainConfigPath:=DocumentsPath + '\' + HP3DocPath + '\' + HP3MainConfig;
    SubConfigPath:=DocumentsPath + '\' + HP3DocPath + '\User.ini';
  end;

  Ini:=TIniFile.Create(MainConfigPath);
  // Запуск в окне
  WindowModeCB.Checked:=Ini.ReadString('WinDrv.WindowsClient', 'StartupFullscreen', 'True') <> 'True';

  // Аппаратное ускорение
  if GameCB.Text <> 'Harry Potter III' then
    HardwareAccelerationCB.Checked:=not Ini.ReadBool('FirstRun', 'ForceSoftware', False)
  else begin
    HardwareAccelerationCB.Caption:=IDS_DIRECTX;
    HardwareAccelerationCB.Checked:=Ini.ReadString('Engine.Engine', 'RenderDevice', '') = 'D3DDrv.D3DRenderDevice';
  end;

  // Режим отладки
  if GameCB.Text = 'Harry Potter I' then
    DebugMenuCB.Checked:=(Ini.ReadString('HPBase.baseConsole', 'bDebugMode', 'False') = 'True') and (Ini.ReadString('HPMenu.HPConsole', 'bShowConsole', 'False') = 'True');

  if (GameCB.Text = 'Harry Potter II') or (GameCB.Text = 'Harry Potter II - Demo 1') or (GameCB.Text = 'Harry Potter II - Demo 2') then
    DebugMenuCB.Checked:=(Ini.ReadString('HGame.HPConsole', 'bDebugMode', 'False') = 'True') and (Ini.ReadString('HGame.HPConsole', 'bshowconsole', 'False') = 'True') and (Ini.ReadString('HGame.baseConsole', 'bDebugMode', 'False') = 'True');

  if GameCB.Text = 'Harry Potter II Prototype' then
    DebugMenuCB.Checked:=(Ini.ReadString('HGame.baseConsole', 'bDebugMode', 'False') = 'True') and (Ini.ReadString('HGame.HPConsole', 'bShowConsole', 'False') = 'True');

  // Разрешение в полноэкранном режиме
  ResolutionsCB.Text:=IntToStr(Ini.ReadInteger('WinDrv.WindowsClient', 'FullscreenViewportX', 640)) + 'x' + IntToStr(Ini.ReadInteger('WinDrv.WindowsClient', 'FullscreenViewportY', 480));

  //Разрешение в окне
  ResolutionsWndCB.Text:=IntToStr(Ini.ReadInteger('WinDrv.WindowsClient', 'WindowedViewportX', 640)) + 'x' + IntToStr(Ini.ReadInteger('WinDrv.WindowsClient', 'WindowedViewportY', 480));

  if GameCB.Text = 'Harry Potter III' then
    FOVCB.Text:=Ini.ReadString('Engine.PlayerController', 'DesiredFOV', '90');

  Ini.Free;

  Ini:=TIniFile.Create(SubConfigPath);
  if GameCB.Text <> 'Harry Potter III' then
    FOVCB.Text:=Ini.ReadString('Engine.PlayerPawn', 'DesiredFOV', '90')
  else //Режим отладки
    DebugMenuCB.Checked:=(Ini.ReadString('Engine.Input', 'F10', '') = 'set kwgame.kwversion bdebugenabled true');

  Ini.Free;
end;

procedure TMain.GameCBChange(Sender: TObject);
begin
  DefaultSettings;
  UpdateSettings;
end;

procedure TMain.DefaultSettings;
begin
  WindowModeCB.Checked:=false;
  HardwareAccelerationCB.Enabled:=true;
  HardwareAccelerationCB.Checked:=false;
  DebugMenuCB.Checked:=false;
  ResolutionsCB.Text:='640x480';
  ResolutionsWndCB.Text:=ResolutionsCB.Text;
  FOVCB.Text:='90 (4:3)';
end;

procedure TMain.ApplyBtnClick(Sender: TObject);
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

  if GameCB.Text = 'Harry Potter III' then begin
    MainConfigPath:=DocumentsPath + '\' + HP3DocPath + '\' + HP3MainConfig;
    SubConfigPath:=DocumentsPath + '\' + HP3DocPath + '\User.ini';
  end;

  if MainConfigPath = '' then begin
    Application.MessageBox(PChar(IDS_NO_GAMES_FOUND), PChar(Caption), MB_ICONWARNING);
    Exit;
  end;

  // Атрибуты для редактирования
  if FileGetAttr(MainConfigPath) = faReadOnly then
    FileSetAttr(MainConfigPath, FileGetAttr(MainConfigPath) and not faReadOnly);
  if FileGetAttr(SubConfigPath) = faReadOnly then
    FileSetAttr(SubConfigPath, FileGetAttr(SubConfigPath) and not faReadOnly);

  Ini:=TIniFile.Create(MainConfigPath);
  // Запуск в окне
  if WindowModeCB.Checked then
    Ini.WriteString('WinDrv.WindowsClient', 'StartupFullscreen', 'False')
  else
    Ini.WriteString('WinDrv.WindowsClient', 'StartupFullscreen', 'True');

  // Аппаратное ускорение
  if GameCB.Text <> 'Harry Potter III' then
    Ini.WriteBool('FirstRun', 'ForceSoftware', not HardwareAccelerationCB.Checked);

  // Режим отладки
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

  // Улучшения, исправляющие проблемы
  if (GameCB.Text = 'Harry Potter I') or (GameCB.Text = 'Harry Potter II Prototype')
  or (GameCB.Text = 'Harry Potter II - Demo 1') or (GameCB.Text = 'Harry Potter II - Demo 2')
  or (GameCB.Text = 'Harry Potter II') then begin
    Ini.WriteInteger('WinDrv.WindowsClient', 'WindowedColorBits', 32);
    Ini.WriteInteger('WinDrv.WindowsClient', 'FullscreenColorBits', 32);
    Ini.WriteString('D3DDrv.D3DRenderDevice', 'UsePrecache', 'False');
  end;

  // Разрешение в полноэкранном режиме
  ResWidth:=StrToIntDef(Copy(ResolutionsCB.Text, 1, Pos('x', ResolutionsCB.Text) - 1), 640);
  ResHeight:=StrToIntDef(Copy(ResolutionsCB.Text, Pos('x', ResolutionsCB.Text) + 1, Length(ResolutionsCB.Text)), 480);
  Ini.WriteInteger('WinDrv.WindowsClient', 'FullscreenViewportX', ResWidth);
  Ini.WriteInteger('WinDrv.WindowsClient', 'FullscreenViewportY', ResHeight);

  // Разрешение в окне
  ResWidth:=StrToIntDef(Copy(ResolutionsWndCB.Text, 1, Pos('x', ResolutionsWndCB.Text) - 1), 640);
  ResHeight:=StrToIntDef(Copy(ResolutionsWndCB.Text, Pos('x', ResolutionsWndCB.Text) + 1, Length(ResolutionsWndCB.Text)), 480);
  Ini.WriteInteger('WinDrv.WindowsClient', 'WindowedViewportX', ResWidth);
  Ini.WriteInteger('WinDrv.WindowsClient', 'WindowedViewportY', ResHeight);

  FOV:=FOVCB.Text;
  if Pos('(', FOV) > 0 then
    FOV:=Copy(FOV, 1, Pos(' ', FOV) - 1);

  if GameCB.Text = 'Harry Potter III' then begin
    // OpenGL иногда вылетает, а иногда решает проблемы с совместимостью
    if HardwareAccelerationCB.Checked then
      Ini.WriteString('Engine.Engine', 'RenderDevice', 'D3DDrv.D3DRenderDevice')
    else
      Ini.WriteString('Engine.Engine', 'RenderDevice', 'OpenGLDrv.OpenGLRenderDevice');
  end;

  Ini.Free;

  Ini:=TIniFile.Create(SubConfigPath);
  if (GameCB.Text <> 'Harry Potter III') then begin
    Ini.WriteString('Engine.PlayerPawn', 'DesiredFOV', FOV);
    Ini.WriteString('Engine.PlayerPawn', 'DefaultFOV', FOV);
    Ini.WriteString('Engine.Input', 'F10', 'flush'); // Исправление проблем с прозрачностью текстур
  end else begin
    Ini.WriteString('Engine.PlayerController', 'DesiredFOV', FOV);
    Ini.WriteString('Engine.PlayerController', 'DefaultFOV', FOV);

    if DebugMenuCB.Checked then
      Ini.WriteString('Engine.Input', 'F10', 'set kwgame.kwversion bdebugenabled true') // Режим отладки для HP3
    else
      Ini.WriteString('Engine.Input', 'F10', 'set kwgame.kwversion bdebugenabled false');
  end;
  Ini.Free;

  // Атрибуты только для чтения
  if SettingsReadOnlyCB.Checked then begin
    FileSetAttr(MainConfigPath, faReadOnly);
    FileSetAttr(SubConfigPath, faReadOnly);
  end;

  if (GameCB.Text = 'Harry Potter I') and (HardwareAccelerationCB.Checked = false) then
    Application.MessageBox(PChar(StringReplace(IDS_WARNING_HW_DISABLED, '\n', #13#10, [rfReplaceAll])), PChar(Caption), MB_ICONWARNING);

  if (GameCB.Text <> 'Harry Potter III') then
    Application.MessageBox(PChar(IDS_DONE + #13#10 + #13#10 + StringReplace(IDS_DONE_HP1_2, '\n', #13#10, [rfReplaceAll])), PChar(Caption), MB_ICONINFORMATION)
  else
    Application.MessageBox(PChar(IDS_DONE + #13#10 + #13#10 + StringReplace(IDS_DONE_HP3, '\n', #13#10, [rfReplaceAll])), PChar(Caption), MB_ICONINFORMATION);

  Close;
end;

procedure TMain.AboutBtnClick(Sender: TObject);
begin
  Application.MessageBox(PChar(Caption + ' 1.0.9' + #13#10 +
  IDS_LAST_UPDATE + ' 11.10.2022' + #13#10 +
  'https://r57zone.github.io' + #13#10 +
  'r57zone@gmail.com'), PChar(Caption), MB_ICONINFORMATION);
end;

procedure TMain.CloseBtnClick(Sender: TObject);
begin
  Close;
end;

procedure SelectFOV(ResWidth, ResHeight: integer);
var
  i, ARWidth, ARHeight: integer; AspectRatio: string; AspectFound: boolean;
begin
  AspectFound:=false;
  for i:=0 to Main.FOVCB.Items.Count - 1 do begin
    AspectRatio:=Copy(Main.FOVCB.Items.Strings[i], Pos('(', Main.FOVCB.Items.Strings[i]) + 1, Length(Main.FOVCB.Items.Strings[i]) - Pos('(', Main.FOVCB.Items.Strings[i]) - 1);
    ARWidth:=StrToIntDef(Copy(AspectRatio, 1, Pos(':', AspectRatio) - 1), 4);
    ARHeight:=StrToIntDef(Copy(AspectRatio, Pos(':', AspectRatio) + 1, Length(AspectRatio)), 3);
    //if Round((ResWidth / ResHeight) * 100) = Round((ARWidth / ARHeight) * 100) then begin
    if (Round((ResWidth / ResHeight) * 100) div 10) = (Round((ARWidth / ARHeight) * 100)  div 10) then begin
      AspectFound:=true;
      Main.FOVCB.ItemIndex:=i;
      break;
    end;
  end;
  if AspectFound = false then
    Main.FOVCB.ItemIndex:=0;
end;

procedure TMain.ResolutionsCBChange(Sender: TObject);
var
  ResWidth, ResHeight: integer;
begin
  ResWidth:=StrToIntDef(Copy(ResolutionsCB.Text, 1, Pos('x', ResolutionsCB.Text) - 1), 640);
  ResHeight:=StrToIntDef(Copy(ResolutionsCB.Text, Pos('x', ResolutionsCB.Text) + 1, Length(ResolutionsCB.Text)), 480);
  SelectFOV(ResWidth, ResHeight);
end;

procedure TMain.ResolutionsWndCBChange(Sender: TObject);
var
  ResWidth, ResHeight: integer;
begin
  ResWidth:=StrToIntDef(Copy(ResolutionsWndCB.Text, 1, Pos('x', ResolutionsWndCB.Text) - 1), 640);
  ResHeight:=StrToIntDef(Copy(ResolutionsWndCB.Text, Pos('x', ResolutionsWndCB.Text) + 1, Length(ResolutionsWndCB.Text)), 480);
  SelectFOV(ResWidth, ResHeight)
end;

end.
