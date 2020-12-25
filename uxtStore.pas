unit uxtStore;

interface

uses system.SysUtils, system.Classes, xtCommonTypes, xtConnection,
  uxtCommonComponent,  xtServiceAddress;

type
 TxtStore = class(TxtBaseComponent)
 const
    seconLevDomain = 'xtumble.store';
 private
    FwebAlias: String;
    FonWebAliasChange: TNotifyEvent;
    Fhttp_port: Integer;

    function getStoreUrl: String;
    procedure SetwebAlias(const Value: String);
    procedure SetonWebAliasChange(const Value: TNotifyEvent);
    procedure Sethttp_port(const Value: Integer);
 protected
    procedure doBeforeActivate; override;
    function getWebAlias : String;
 public
   constructor Create(AOwner: TComponent); override;
 published
   property xtConnection;

   property http_port : Integer read Fhttp_port write Sethttp_port;

   property webAlias : String read FwebAlias write SetwebAlias;
   property StoreUrl : String read getStoreUrl;

   property onWebAliasChange : TNotifyEvent read FonWebAliasChange write SetonWebAliasChange;
 end;

 procedure Register;

implementation

{ TxtStore }
uses System.Net.URLClient, System.Net.HttpClient,
     System.Net.HttpClientComponent, system.IOUtils,
     System.Net.Mime;



procedure Register;
begin
  RegisterComponents('xTumble', [TxtStore]);
end;

constructor TxtStore.Create(AOwner: TComponent);
begin
  inherited;
  FWebAlias := '';
  FonwebaliasChange := nil;
  Fhttp_port := 443;
end;

procedure TxtStore.doBeforeActivate;
begin
  inherited;
  FwebAlias := getWebAlias;
  if assigned(FonWebAliasChange) then
    FonWebAliasChange(Self);
end;

function TxtStore.getStoreUrl: String;
begin
 { TODO : Inserire la chiamata ad una nuova servlet per gestire l'impostazione relativa ai domini personalizzati }
 if FwebAlias <> '' then
  Begin
   if Fhttp_port = 443 then
     result := 'https://' + FwebAlias + '.xtumble.store'
   Else
     result := 'http://' + FwebAlias + '.xtumble.store';
  End
 else
   result := 'https://xtumble.store';

 if (Fhttp_port <> 443)AND(Fhttp_port <> 0)AND(Fhttp_port <> 80) then
  result := result + ':' + http_port.ToString;

end;

function TxtStore.getWebAlias: String;
var
 respo: IHTTPResponse;
begin
 result := '';
 respo := HTTPprov.doGet(xtConnection.ConnectionParams,TxtServices.getWebAlias,'');
 if (respo.StatusCode > 199)and(respo.StatusCode < 300) then
  Begin
   result := respo.ContentAsString();
  End
 Else
  Begin
   raise Exception.Create('getWebAlias error [' + respo.StatusCode.ToString + ']: ' + respo.ContentAsString());
  End;
end;

procedure TxtStore.Sethttp_port(const Value: Integer);
begin
  Fhttp_port := Value;
end;

procedure TxtStore.SetonWebAliasChange(const Value: TNotifyEvent);
begin
  FonWebAliasChange := Value;
end;

procedure TxtStore.SetwebAlias(const Value: String);
var
 respo: IHTTPResponse;
begin
 if FwebAlias <> Value then
  Begin
   respo := HTTPprov.doGet(xtConnection.ConnectionParams,TxtServices.setWebalias,'web_alias=' + Value.ToLower);
   if (respo.StatusCode > 199)and(respo.StatusCode < 300) then
    Begin
     FwebAlias := respo.ContentAsString();
    End
   Else
    Begin
     raise Exception.Create('getWebAlias error [' + respo.StatusCode.ToString + ']: ' + respo.ContentAsString());
    End;

   if assigned(FonWebAliasChange) then
    FonWebAliasChange(Self);
  End;

end;

end.
