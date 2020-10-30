unit uxtStore;

interface

uses system.SysUtils, system.Classes, xtCommonTypes, xtConnection,
  uxtCommonComponent,  xtServiceAddress;

type
 TxtStore = class(TxtBaseComponent)
 private
    FwebAlias: String;
    FonWebAliasChange: TNotifyEvent;

    function getStoreUrl: String;
    procedure SetwebAlias(const Value: String);
    procedure SetonWebAliasChange(const Value: TNotifyEvent);
 protected
    procedure doBeforeActivate; override;
    function getWebAlias : String;
 public
   constructor Create(AOwner: TComponent); override;
 published
   property xtConnection;

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
 if FwebAlias <> '' then
   result := 'https://' + FwebAlias + '.xtumble.store'
 else
   result := 'https://xtumble.store'
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
