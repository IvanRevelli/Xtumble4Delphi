unit uProviderHTTP;

interface

uses System.Classes,System.Net.URLClient, System.Net.HttpClient,
     System.Net.HttpClientComponent,xtCommonTypes, xtServiceAddress;

type
  TProviderHttp = class(TObject)
  private
    class procedure ValidateServerCertificate(const Sender: TObject; const ARequest: TURLRequest; const Certificate: TCertificate; var Accepted: Boolean);
  public

    class function validateAccount(account : TConnectionParam) : TValidateAccount; overload;

    class function dloadFromUrl(url: String;readTimeOut : Integer = 20000; connectionTimeOut : Integer = 10000): TMemoryStream;

    class function doGet<Tin,Tout>(account: TConnectionParam;service : String;params : Tin;returnValues : Tout;ContentType : String = 'application/json';AcceptCharSet  : String = 'utf-8') : IHTTPResponse; overload;
    class function doGet<Tin>(account: TConnectionParam;service : String;params : Tin;ContentType : String = 'application/json';AcceptCharSet  : String = 'utf-8') : IHTTPResponse; overload;
    class function doGet(account: TConnectionParam;service : String;params : TStrings;ContentType : String = 'application/json';AcceptCharSet : String = 'utf-8') : IHTTPResponse; overload;
    class function doGet(account: TConnectionParam;service : String;params : String;ContentType : String = 'application/json';AcceptCharSet : String = 'utf-8') : IHTTPResponse; overload;

    class function doPost<Tin,Tout>(account: TConnectionParam;service : String;params : Tin;returnValues : Tout;postStream : TStream;ContentType : String = 'application/json';AcceptCharSet : String = 'utf-8') : IHTTPResponse; overload;
    class function doPost(account: TConnectionParam;service : String;params : TStrings;postStream : TStream;ContentType : String = 'application/json';AcceptCharSet : String = 'utf-8') : IHTTPResponse; overload;


    class function getDomain(const URI: string): string;
    class function EncodeStringToUrl(qu: String): String;
  end;

implementation

{ TProviderHttp }
uses System.SysUtils,System.Rtti, xtRTTI,IdURI;


class function TProviderHttp.doGet(account: TConnectionParam; service: String;
  params: TStrings;ContentType : String = 'application/json';AcceptCharSet : String = 'utf-8'): IHTTPResponse;


  function ParamsToUrlParams(params : TStrings) : string;
  var
    I: Integer;
    tmp: string;
   begin
     result := '';
     if params = nil then exit;



     for I := 0 to params.count -1 do
      begin
       tmp := params.names[I] + '=' + params.values[params.names[I]];
       if result = '' then
        result := tmp
       else
        result := result + '&' + tmp;
      end;
   end;


begin
 result := TProviderHttp.doGet(account,service, ParamsToUrlParams(params), ContentType, AcceptCharSet);
end;

class function TProviderHttp.dloadFromUrl(url: String;readTimeOut : Integer = 20000; connectionTimeOut : Integer = 10000): TMemoryStream;
var
  LIdHTTP: TNetHTTPClient;
  MSSource: TMemoryStream;
  SS: TStringStream;
  Errore: string;
  respo: IHTTPResponse;
begin
  LIdHTTP := TNetHTTPClient.Create(nil);
  try
    LIdHTTP.ResponseTimeout := readTimeout;
//    LIdHTTP.OnValidateServerCertificate := ValidateServerCertificate;
//    LIdHTTP.SecureProtocols := [THTTPSecureProtocol.SSL2,THTTPSecureProtocol.SSL3,THTTPSecureProtocol.TLS1,THTTPSecureProtocol.TLS11,THTTPSecureProtocol.TLS12,THTTPSecureProtocol.TLS13];
    LIdHTTP.ConnectionTimeout := ConnectionTimeout;
    Errore                := '';
    SS := nil;

    Result := TMemoryStream.Create;
    Result.Position := 0;
    MSSource := TMemoryStream.Create;
    MSSource.Position := 0;
    try
      respo := LIdHTTP.post(url, MSSource, Result);
    except
     on e:exception do
      Begin
       Result.Free;
       Result := nil;
       Errore := '[TSynaConnection.dloadFromUrl] : ' + e.Message;
       raise Exception.Create(Errore);

      End;
    end;
    Result.Position := 0;
//    <!-- android:networkSecurityConfig="@xml/network_security_config"  -->
  Finally
    try
      LIdHTTP.Free;
    except
    end;
    LIdHTTP := nil;
  End;
end;


class function TProviderHttp.doGet(account: TConnectionParam; service, params,
  ContentType, AcceptCharSet: String): IHTTPResponse;
var
  httpCli: TNetHTTPClient;
  xtHeaders : TNetHeaders;
  xtHeader : TNetHeader;
  url: string;
  baseUrl: String;
begin
 httpCli := nil;
 try

  xtHeaders := [
                 TNetHeader.Create('CID',account.companyId),
                 TNetHeader.Create('username',account.username),
                 TNetHeader.Create('password',account.password)
               ];


  baseUrl := account.ServerAddress;
  if not baseUrl.endsWith('/') then
   baseUrl := baseUrl + '/';

  url := baseUrl + service + '?' + params;

  httpCli := TNetHTTPClient.Create(nil);
  httpCli.OnValidateServerCertificate := ValidateServerCertificate;


  httpCli.SendTimeout        := account.readTimeout;
  httpCli.ResponseTimeout    := account.readTimeout;
  httpCli.ConnectionTimeout  := account.connectionTimeOut;
  httpCli.ContentType := ContentType;
  httpCli.AcceptCharSet := AcceptCharSet;


  result := httpCli.Get(url,nil,xtHeaders);
 finally
  FreeAndNil(httpCli);
 end;

end;

class function TProviderHttp.doGet<Tin, Tout>(account: TConnectionParam;
  service: String; params: Tin; returnValues: Tout;ContentType : String = 'application/json';AcceptCharSet : String = 'utf-8'): IHTTPResponse;
begin

end;

class function TProviderHttp.doGet<Tin>(account: TConnectionParam;
  service: String; params: Tin; ContentType,
  AcceptCharSet: String): IHTTPResponse;
var
 paramList : String;
begin
   paramList := '';

   TRecordHelper<Tin>.ForEachField(Params,
       procedure(var ARecord: Tin; const AField: TRttiField; var AStop: Boolean)
       begin
        if paramList <> '' then
         paramList := paramList + '&';

        paramList := paramList + AField.Name + '=' + AField.GetValue(@ARecord).ToString;
       end
       );

   result := TProviderHttp.doGet(account,service, paramList, ContentType, AcceptCharSet);
end;

class function TProviderHttp.doPost(account: TConnectionParam; service: String;
  params: TStrings;
  postStream: TStream;ContentType : String = 'application/json';AcceptCharSet : String = 'utf-8'): IHTTPResponse;
begin

end;


class function TProviderHttp.doPost<Tin, Tout>(account: TConnectionParam;
  service: String;
  params: Tin; returnValues: Tout;
  postStream: TStream;ContentType : String = 'application/json';AcceptCharSet : String = 'utf-8'): IHTTPResponse;
begin

end;

class function TProviderHttp.EncodeStringToUrl(qu: String): String;
begin
     qu := StringReplace(Trim(qu),'%','%25',[rfReplaceAll]);
     qu := StringReplace(Trim(qu),'/','%2F',[rfReplaceAll]);
     qu := StringReplace(Trim(qu),'\','%5C',[rfReplaceAll]);
     qu := StringReplace(Trim(qu),' ','%20',[rfReplaceAll]);
     qu := StringReplace(Trim(qu),'&','%26',[rfReplaceAll]);

     qu := StringReplace(Trim(qu),#10,'%20',[rfReplaceAll]);
     qu := StringReplace(Trim(qu),#13,'%20',[rfReplaceAll]);
     qu := StringReplace(Trim(qu),#9,'%20',[rfReplaceAll]);


     qu := StringReplace(Trim(qu),'#','%23',[rfReplaceAll]);
     qu := StringReplace(Trim(qu),'$','%24',[rfReplaceAll]);

     qu := StringReplace(Trim(qu),'<','%3C',[rfReplaceAll]);
     qu := StringReplace(Trim(qu),'>','%3E',[rfReplaceAll]);
     qu := StringReplace(Trim(qu),'?','%3F',[rfReplaceAll]);
     qu := StringReplace(Trim(qu),'@','%40',[rfReplaceAll]);
     qu := StringReplace(Trim(qu),'+','%2B',[rfReplaceAll]);

     Result := qu;
end;

class function TProviderHttp.getDomain(const URI: string): string;
var
  IdURI: TIdURI;
begin
  IdURI := TIdURI.Create(URI);
  try
    Result := IdURI.Protocol + '://' + IdURI.Host + '/';
  finally
    IdURI.Free;
  end;
end;


class function TProviderHttp.validateAccount(
  account: TConnectionParam): TValidateAccount;
var
  respo: IHTTPResponse;
  TS: TStringList;
  tmpStr: string;
begin
  try
    TS := TStringList.Create;
    respo := doGet(account, TxtServices.validateAccount, nil);
    tmpStr := respo.ContentAsString();
    TS.Delimiter := ';';
    TS.QuoteChar := '"';
    result.ResultString := '"' + tmpStr.Replace(';', '";"') + '"';
    TS.DelimitedText := result.ResultString;
    if tmpStr.ToLower.StartsWith('ok;') then
    begin
      result.Success := True;
      result.Ok := True;
    end;

    if TS.count > 6 then
    Begin
      result.UserId := TS[5].ToInteger();
      result.AccessLevel := TS[6].ToInteger();
      result.LimitiSuperati := (TS[1].ToLower = 'true');
      result.LimitString := TS[4];
      if not result.Ok then
        result.ErrorString := tmpStr;
    End
    Else if (not result.Ok) then
      result.ErrorString := result.ErrorString + tmpStr;
  finally
    try
      FreeAndNil(TS);
    except

    end;
  end;
end;

class procedure TProviderHttp.ValidateServerCertificate(const Sender: TObject;
  const ARequest: TURLRequest; const Certificate: TCertificate;
  var Accepted: Boolean);
begin
 Accepted := True;
end;



end.
