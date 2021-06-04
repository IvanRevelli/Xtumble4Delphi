unit xtConnection;

interface

uses
  SysUtils, Classes,
  DB,
  System.Net.URLClient,
  System.Net.HttpClient,
  System.Net.Mime,
  System.Net.HttpClientComponent,
  xtCommonTypes, uProviderHTTP, xtServiceAddress;

type

  TXtConnection = class(TComponent)
  private

    FConnectionParams : TConnectionParam;
    Fpassword: String;
    FuserName: String;
    FConnectionURL: String;
    FConnected: Boolean;
    Fdebug: Boolean;
    Fcachepath: String;
    FCompanyID: String;
    FReadTimeout: Integer;
    FlastQueryError : String;
    FattchmentCachePath: String;
    FAgent: String;
    FConnectionTimeout: Integer;
    FreadOnlyDatabase: Boolean;
    FValidateAccount : TValidateAccount;

    procedure SetConnectionURL(const Value: String);
    procedure Setpassword(const Value: String);
    procedure SetuserName(const Value: String);
    procedure SetConnected(const Value: Boolean);
    procedure Setdebug(const Value: Boolean);
    procedure Setcachepath(const Value: String);
    procedure SetCompanyID(const Value: String);
    procedure SetReadTimeout(const Value: Integer);
    function getLastQueryError: String;
    procedure SetattchmentCachePath(const Value: String);


    function getLastValidateAccountResult: TValidateAccount;
    procedure SetAgent(const Value: String);
    procedure SetConnectionTimeout(const Value: Integer);
    procedure SetreadOnlyDatabase(const Value: Boolean);
    function getUserLev: int64;
    function getUserId: int64;
    function getConnectionParams: TConnectionParam;
    function getUserMail: String;
    { Private declarations }
  protected
    { Protected declarations }

  public
    { Public declarations }
    OnLogMsg : TLogProcedure;

    function ValidateAccount : TValidateAccount;
    property LastValidateAccountData : TValidateAccount read getLastValidateAccountResult;
    function registerAccount(Params : TCreateXTAccountParams) : TEsitoRegistrazioneAccount;

    Property ConnectionParams: TConnectionParam read getConnectionParams;

    Procedure Open;
    Procedure Close;
    Procedure Connect;
    Procedure Disconnect;
    property lastQueryError : String read getLastQueryError;


    constructor Create(AOwner: TComponent); overload; override;
    constructor Create(AOwner: TComponent;const AConnectionParam : TConnectionParam); overload;
    procedure applyConnParams(const AConnectionParam : TConnectionParam);
    // SQL COMMON UTILITY
    procedure clearCache;
    function EntityList: TStringList;


    // PROCEDURE DI GESTIONE AVANZAMENTO UPLOAD/DOWNLOAD ALLEGATI e relativi eventi

    // PROCEDURO DI USO COMUNE


    function String2MD5(str : String) : String;
    procedure setLastError(str : String);
    function MakeHash256(SS : TStream) : String;

    procedure writeLog(msg : String);

    property UserId : int64 read getUserId;
    property UserLev : int64 read getUserLev;
    property UserMail : String read getUserMail;


  published
    { Published declarations }
    property readOnlyDatabase : Boolean read FreadOnlyDatabase write SetreadOnlyDatabase;
    property Connected : Boolean read FConnected write SetConnected;

//    ########## CONNECTION PARMAS #################
    property ConnectionURL : String read FConnectionURL write SetConnectionURL;
    property userName : String read FuserName write SetuserName;
    property password : String read Fpassword write Setpassword;
    property CompanyID : String read FCompanyID write SetCompanyID;

    property ReadTimeout : Integer read FReadTimeout write SetReadTimeout;
    property ConnectionTimeout : Integer read FConnectionTimeout write SetConnectionTimeout;
    property Agent : String read FAgent write SetAgent;



//    ##############################################
    property attchmentCachePath : String read FattchmentCachePath write SetattchmentCachePath;

    property cachepath : String read Fcachepath write Setcachepath;

    property debug : Boolean read Fdebug write Setdebug;
  end;

procedure Register;

implementation

uses
   System.IOUtils,
   System.Threading,
   StrUtils,
   System.Rtti,
   System.Hash,
   xtRTTI;

procedure Register;
begin
  RegisterComponents('xTumble', [TXtConnection]);
end;

procedure TXtConnection.writeLog(msg : String);
 begin

 end;






procedure TXtConnection.clearCache;
var
  sr: TSearchRec;
  TSElencoFile : TStringList;
  I            : Integer;
begin

  TSElencoFile := nil;
  try
  if FindFirst(cachepath + '\*.cds', faAnyFile, sr) = 0 then
    begin
      TSElencoFile := TStringList.Create;
      repeat
        TSElencoFile.Add(cachepath + '\' + sr.Name);
      until FindNext(sr) <> 0;
      sysutils.FindClose (  sr);
    end;

  if (TSElencoFile = nil) then exit;

  For I:=0 to TSElencoFile.Count-1 do
   Begin
    sysutils.DeleteFile(TSElencoFile[I]);
//      Fcache_eliminata_in_questa_sessione := True;
   End;
  finally

  try
  if TSElencoFile <> nil then
   Begin
    TSElencoFile.Clear;
    TSElencoFile.Free;
   End;
  Except

  end;
  end;
//  DeleteFile()
end;

procedure TXtConnection.Close;
begin
 try

 finally
   FConnected := false;
   FValidateAccount.init;
 end;
end;

procedure TXtConnection.Connect;
begin
 Open;
end;

constructor TXtConnection.Create(AOwner: TComponent);
begin
  inherited;
  OnLogMsg  := nil;
  Fdebug             := false;
  FConnectionTimeout := 3000;
  FlastQueryError := '';
  Fcachepath := '';


{$IF DEFINED(IOS) or DEFINED(ANDROID)}
  Fcachepath := TPath.GetDocumentsPath + PathDelim;
{$ELSE}
  Fcachepath := ExtractFileDir(ParamStr(0));
  Fcachepath := ExtractFileDir(ParamStr(0));
{$ENDIF}
  FreadOnlyDatabase := False;
  FCachePath := TPath.Combine(Fcachepath,  'dscache\');

  FReadTimeout      := 30000;
  FConnected        := False;
  FuserName         := '';
  FPassWord         := '';
  FCompanyID        := '';
  FConnectionURL := '';
  FAgent            := '';
end;

constructor TXtConnection.Create(AOwner: TComponent;const AConnectionParam : TConnectionParam);
begin
  Self.Create(AOwner);
  Self.applyConnParams(AConnectionParam);
end;

procedure TXtConnection.applyConnParams(const AConnectionParam : TConnectionParam);
begin
  Self.Connected := False;
  Self.CompanyID          := AConnectionParam.companyId;
  Self.ConnectionURL      := AConnectionParam.ServerAddress;
  Self.attchmentCachePath := AConnectionParam.attachmentCachePath;

  Self.password           := AConnectionParam.password;
  Self.userName           := AConnectionParam.userName;
  Self.ReadTimeout        := AConnectionParam.readTimeOut;
  Self.ConnectionTimeout  := AConnectionParam.connectionTimeOut;
end;

procedure TXtConnection.Disconnect;
begin
 Close;
end;

function TXtConnection.MakeHash256(SS: TStream): String;
begin
  Result := '';
  SS.Position := 0;
  Result := System.Hash.THashSHA1.GetHashString(SS);
end;

procedure TXtConnection.Open;
Var
 done : Boolean;
 VA: TValidateAccount;
begin
 if FConnected then exit;
 done := false;
 Try
  VA := ValidateAccount;

  FConnected := VA.Success and VA.Ok;

  FValidateAccount := VA;

  if not FConnected then
   raise Exception.Create('XTumble connection error: ' + VA.ResultString);

 Except
  On E:Exception do
   Begin
    done := false;
    FConnected := False;
    raise exception.Create('[TXtConnection.Open] Error: ' + E.Message);
   End;
 end;
end;





function TXtConnection.registerAccount(
  Params: TCreateXTAccountParams): TEsitoRegistrazioneAccount;
Var
  RespText : String;
  respo: IHTTPResponse;
  connPar : TConnectionParam;

begin
 try
  try
   result.registratoCorrettamente := False;
   result.errorCode               := -1000;
   result.messaggio               := 'non ancora eseguito';

   connPar.ServerAddress := FConnectionParams.ServerAddress;
   respo := TProviderHttp.doGet<TCreateXTAccountParams>(connPar,TxtServices.registeraccount,Params);
   Result.registratoCorrettamente := (respo.StatusCode > 199)and(respo.StatusCode < 300)and(respo.ContentAsString = 'OK');
   if not((respo.StatusCode > 199)and(respo.StatusCode < 300)) then
      Result.errorCode               := respo.StatusCode
   Else
      Result.errorCode               := 0;

   Result.messaggio               := RespText;
  except
   on e:exception do
    Begin
     result.registratoCorrettamente := False;
     result.errorCode               := -2000;
     result.messaggio               := e.Message;
    End;
  end;
 finally
 end;

end;

function TXtConnection.getUserId: int64;
begin
  if Connected then
   result := FValidateAccount.UserId
  else
   result := -1;

end;

function TXtConnection.getUserLev: int64;
begin
  if Connected then
   result := FValidateAccount.accesslevel
  else
   result := -1;
end;



function TXtConnection.getUserMail: String;
begin
  if Connected then
   result := FValidateAccount.userMail
  else
   result := '';


end;

procedure TXtConnection.Setcachepath(const Value: String);
begin
  Fcachepath := Value;
end;


procedure TXtConnection.SetCompanyID(const Value: String);
begin
 if FCompanyID <> Value then
  Begin
    FCompanyID := Value;
    FConnectionParams.companyId := FCompanyID;
    Connected := False;
  End;
end;

procedure TXtConnection.SetConnected(const Value: Boolean);
begin
  If Value then
   Begin
    Try
      Open;
    except
     On e:Exception do
      Begin
       FConnected := False;
       raise Exception.Create(e.Message);
      End;
    end;
   end
  Else
   Begin
    Try Close; Except FConnected := False; End;
   end;
end;

procedure TXtConnection.SetConnectionURL(const Value: String);
begin
 if FConnectionURL <> Value then
  Begin
    FConnectionURL := Value;
    Connected := False;
    FConnectionParams.ServerAddress := FConnectionURL;
  End;
end;


procedure TXtConnection.SetConnectionTimeout(const Value: Integer);
begin
  FConnectionTimeout := Value;
  FConnectionParams.connectionTimeOut := FConnectionTimeout;
end;



procedure TXtConnection.Setdebug(const Value: Boolean);
begin
  Fdebug := Value;
end;



procedure TXtConnection.setLastError(str: String);
begin
 FlastQueryError := str;
end;

procedure TXtConnection.Setpassword(const Value: String);
begin
 if Fpassword <> Value then
  Begin
    Connected := False;
    Fpassword := Value;
    FConnectionParams.password := Fpassword;
  End;

end;



procedure TXtConnection.SetreadOnlyDatabase(const Value: Boolean);
begin
  FreadOnlyDatabase := Value;
end;

procedure TXtConnection.SetReadTimeout(const Value: Integer);
begin
  FReadTimeout := Value;
  FConnectionParams.readTimeOut := FReadTimeout;
end;


procedure TXtConnection.SetuserName(const Value: String);
begin
 if (FuserName <> Value) then
  Begin
    FuserName := Value;
    FConnectionParams.userName := FuserName;
    Connected := False;
  End;
end;




function TXtConnection.getConnectionParams: TConnectionParam;
begin
 result := FConnectionParams;
end;

function TXtConnection.getLastQueryError: String;
begin
// result := '';
// try
//   If Provider <> nil then
//    result := Provider.LastQueryError
//   else
//    result := FlastQueryError; // VIENE VALORIZZATA LA VARIABILE ALLA CHIUSURA DELLA CONNESSIONE QUANDO IL PROVIDER VIENE ELIMINATO
// except
//  result := '';
// end;
end;

function TXtConnection.getLastValidateAccountResult: TValidateAccount;
begin
 if Connected then
  result := FValidateAccount
 else
  Begin
    FValidateAccount := ValidateAccount;

  End;
end;


function TXtConnection.ValidateAccount: TValidateAccount;
begin
 Result := TProviderHttp.validateAccount(FConnectionParams);
end;

procedure TXtConnection.SetAgent(const Value: String);
begin
  FAgent := Value;
  FConnectionParams.agent := FAgent;
end;


procedure TXtConnection.SetattchmentCachePath(const Value: String);
begin

  if FattchmentCachePath <> Value then
  Begin
    FattchmentCachePath := Value;

    if FattchmentCachePath <> '' then
    Begin
      if not FattchmentCachePath.EndsWith(TPath.DirectorySeparatorChar) then
        FattchmentCachePath := FattchmentCachePath +
          TPath.DirectorySeparatorChar;

      if not DirectoryExists(FattchmentCachePath) then
        ForceDirectories(FattchmentCachePath);
    End;
  End;
end;

function TXtConnection.EntityList: TStringList;
begin
 Result   := nil;
 { TODO : Implementare l'elenco delle entita disponibili }
End;

function TXtConnection.String2MD5(str: String): String;
 begin
   result := System.Hash.THashMD5.GetHashString(str);
 end;


end.
