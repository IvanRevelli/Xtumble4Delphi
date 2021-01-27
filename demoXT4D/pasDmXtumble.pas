unit pasDmXtumble;

interface

uses
  System.SysUtils, System.Classes, xtConnection, FireDAC.Stan.StorageJSON,
  System.ImageList, Vcl.ImgList, Vcl.VirtualImageList, Vcl.BaseImageCollection,
  Vcl.ImageCollection, Vcl.Dialogs, Vcl.Forms,Vcl.Controls, uxtCommonComponent,
  uXtDriveCommands;

type

  TdmXtumble = class(TDataModule)
    XtConnection: TXtConnection;
    FDStanStorageJSONLink1: TFDStanStorageJSONLink;
    ImageCollection1: TImageCollection;
    VirtualImageList1: TVirtualImageList;
    OD: TOpenDialog;
    FSD: TFileSaveDialog;
    xtDriveCommands1: TxtDriveCommands;
    procedure DataModuleCreate(Sender: TObject);
  private
    { Private declarations }
    iniFileName : String;
    FxTumbleServerAddress: String;
    procedure SetxTumbleServerAddress(const Value: String);
    function getxTumbleServerAddress: String;
  public
    { Public declarations }
    appPath : String;
    companyId : String;
    UserName  : String;
    tmpDir: string;
    function embedForm(myForm: TForm; ParentControl: TWinControl): TForm;
    property xTumbleServerAddress : String read getxTumbleServerAddress write SetxTumbleServerAddress;

    procedure loadSettings;
    procedure saveSettings;
  end;

var
  dmXtumble: TdmXtumble;

implementation

{%CLASSGROUP 'Vcl.Controls.TControl'}

{$R *.dfm}
uses system.IOUtils;

procedure TdmXtumble.DataModuleCreate(Sender: TObject);

begin
 appPath := TPath.Combine(TPath.GetDocumentsPath,'XtumbleDemo');
 if not DirectoryExists(appPAth) then
  ForceDirectories(appPath);

 iniFileName := appPath + TPath.DirectorySeparatorChar + 'xtumble.ini';


 XtConnection.cachepath := TPath.Combine(appPath,'dsCache');
 if not DirectoryExists(XtConnection.cachepath) then
  ForceDirectories(XtConnection.cachepath);

 tmpDir := TPath.Combine(TPath.GetDocumentsPath,'tmp');
 if not DirectoryExists(tmpDir) then
  ForceDirectories(tmpDir);

 XtConnection.attchmentCachePath := TPath.Combine(appPath,'AttCache');
 if not DirectoryExists(XtConnection.attchmentCachePath) then
  ForceDirectories(XtConnection.attchmentCachePath);


 loadSettings;
end;

function TdmXtumble.embedForm(myForm: TForm; ParentControl: TWinControl): TForm;
begin
  myForm.Parent := ParentControl;
  myForm.BorderStyle := bsNone;
  myForm.WindowState := TWindowState.wsMaximized;
  myForm.Align := TAlign.alClient;
  myForm.Show;
  result := myForm;
end;

function TdmXtumble.getxTumbleServerAddress: String;
begin
 if FxTumbleServerAddress = '' then
  begin
   FxTumbleServerAddress := 'https://public.xtumble.store';
   XtConnection.ConnectionURL := FxTumbleServerAddress;
  end;

 result := FxTumbleServerAddress;

end;

procedure TdmXtumble.loadSettings;
var TS : TStringList;
begin
 if FileExists(iniFileName) then
  Begin
   try
     TS := TStringList.Create;
     TS.LoadFromFile(iniFileName);
     companyId := TS.Values['VATNumber'];
     UserName  := TS.Values['username'];
     xTumbleServerAddress := TS.Values['XURL'];
   finally
     TS.Free;
   end;
  End;
end;

procedure TdmXtumble.saveSettings;
var TS : TStringList;
begin
  try
    TS := TStringList.Create;
    TS.Values['XURL'] := xTumbleServerAddress;
    TS.Values['VATNumber'] := companyId;
    TS.Values['username']  := UserName;
    TS.SaveToFile(iniFileName);
  finally
    TS.Free;
  end;

end;

procedure TdmXtumble.SetxTumbleServerAddress(const Value: String);
begin
 if value = '' then
  begin
   FxTumbleServerAddress := 'https://public.xtumble.store';
   XtConnection.ConnectionURL := FxTumbleServerAddress;
  end
 Else if FxTumbleServerAddress <> Value then
  Begin
    XtConnection.Connected := False;
    FxTumbleServerAddress := Value;
    XtConnection.ConnectionURL := FxTumbleServerAddress;
  End;
end;

end.
