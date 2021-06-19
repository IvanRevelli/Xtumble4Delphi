unit xtSendMail;

interface


uses system.SysUtils, system.Classes, xtCommonTypes, xtConnection,
  uxtCommonComponent,  xtServiceAddress, xtDatasetEntity;

type


 TxtSendMail = class(TxtBaseComponent)
 private

    FonBeforeSend: TNotifyEvent;
    FonAfterSend: TNotifyEvent;
    procedure SetonAfterSend(const Value: TNotifyEvent);
    procedure SetonBeforeSend(const Value: TNotifyEvent);
    function getSystemTemplateFromSystemPath(template_name: string) : TMAIL_BATCH;

 protected
    procedure doBeforeActivate; override;
 public
   constructor Create(AOwner: TComponent); override;
   function enqueMailMessage(msg : TMAIL_BATCH) : Int64;

   procedure SaveToFile(msg : TMAIL_BATCH; FileName : TFileName);
   class function LoadFromFile(FileName : TFileName) : TMAIL_BATCH;
   function LoadFromStream(AStream : TStream) : TMAIL_BATCH;
   function SaveAsSystemTemplate(msg : TMAIL_BATCH; template_name : String) : Int64;
   function getTemplate(template_name : String) : TMAIL_BATCH;

   function saveAsTemplateAttachment(msg : TMAIL_BATCH; template_name : String) : Int64;

   function LoadTemplateAttachment(pk_attachment : Int64) : TMAIL_BATCH;

   class procedure ParamReplacer(var contentHtml: String; mail_params: String);
   class function  ParamsToUrlParams(mail_params: String) : String;


 published
   property xtConnection;
   property onBeforeSend : TNotifyEvent read FonBeforeSend write SetonBeforeSend;
   property onAfterSend : TNotifyEvent read FonAfterSend write SetonAfterSend;
 end;

 procedure Register;

implementation

{ TxtStore }
uses System.Net.URLClient, System.Net.HttpClient,
     System.Net.HttpClientComponent, system.IOUtils,
     System.Net.Mime,system.JSON, xtJSON, uProviderHTTP, uXtDriveCommands;

procedure Register;
begin
  RegisterComponents('xTumble', [TxtSendMail]);
end;


{ TxtSendMail }

constructor TxtSendMail.Create(AOwner: TComponent);
begin
  inherited;

end;

procedure TxtSendMail.doBeforeActivate;
begin
  inherited;

end;

function TxtSendMail.enqueMailMessage(msg: TMAIL_BATCH): Int64;
var
  Ljobj: TJSONOBject;
  MS : TStream;
  b: TBytes;
  respo: IHTTPResponse;

  MSS : TMemoryStream;
  FS  : TFileStream;
begin
 if xtConnection = nil then
   raise Exception.Create('xtConnection not defined');
 Ljobj := TJSONOBject(xtJSON.TJSONPersistence.ToJSON<TMAIL_BATCH>(msg));

 MS := TJSONHelper.JSONToStream(LJOBJ);

 respo := HTTPprov.doPost(xtConnection.ConnectionParams,
      xtServiceAddress.TxtServices.mailout,'',MS);

 if (respo.StatusCode >199) and (respo.StatusCode < 300) then
  Begin
    result := respo.ContentAsString.ToInt64;
  End
 Else
  Begin
    raise Exception.Create('[TxtSendMail.enqueMailMessage] Error: (HTTP:' + respo.StatusCode.ToString + ')' + respo.ContentAsString);
  End;
end;

function TxtSendMail.getTemplate(template_name: String): TMAIL_BATCH;
var
  jobj : TJSONObject;
  xtDs: TxtDatasetEntity;
  pk_allegato_template: Int64;
begin
  xtDs := TxtDatasetEntity.Create(self);
  xtDS.xtConnection := Self.xtConnection;
  xtDS.xtApplyUpdateAfterPost := True;
  xtDS.CachedUpdates := True;
  xtDS.xtLiveRecordInsert := True;

  if ExtractFileExt(template_name) = ''  then
    template_name := template_name + '.mailxt';

  xtDS.xtEntityName := 'mail_templates';
  xtDS.xtParams.Text := 'tname=' + template_name;
  xtDS.Open;
  if xtDS.Bof and xtDs.Eof then
    Begin
     Result := getSystemTemplateFromSystemPath(template_name);
     xtDS.Insert;
     xtDS.FieldByName('template_name').AsString := template_name;
     xtDS.Post;
    End
  Else if xtDS.FieldByName('system_template').AsString = 'S' then
    Begin
     Result := getSystemTemplateFromSystemPath(template_name);
    End
  Else if xtDS.FieldByName('fk_allegato_template').AsLargeInt > 0 then
    Begin
     Result := LoadTemplateAttachment(xtDS.FieldByName('fk_allegato_template').AsLargeInt);
    End
  Else
    Begin
 //    raise Exception.Create('[TxtSendMail.getTemplate] HTTP Error : Template' + template_name + ' not found ');
    End;

  pk_allegato_template := xtDS.FieldByName('pk_id').AsLargeInt;
  xtDS.Close;

  FreeAndNil(xtDS);


end;

class function TxtSendMail.LoadFromFile(FileName: TFileName): TMAIL_BATCH;
var
  Ljobj: TJSONObject;
  MS : TStringStream;
begin
  Ljobj := TJSONObject.Create;

  MS := TStringStream.Create;
  MS.LoadFromFile(FileName);

  MS.Position := 0;

  Ljobj := TJSONObject(TJSONObject.ParseJSONValue(MS.DataString));


  result := xtJSON.TJSONPersistence.FromJSON<TMAIL_BATCH>(Ljobj);
  Ljobj.Free;

  MS.Free;
end;

function TxtSendMail.LoadFromStream(AStream: TStream): TMAIL_BATCH;
var
  Ljobj: TJSONObject;
  MS : TStringStream;
begin
  Ljobj := TJSONObject.Create;
  AStream.Position := 0;

  MS := TStringStream.Create;
  MS.LoadFromStream(AStream);

  MS.Position := 0;

  Ljobj := TJSONObject(TJSONObject.ParseJSONValue(MS.DataString));


  result := xtJSON.TJSONPersistence.FromJSON<TMAIL_BATCH>(Ljobj);
  Ljobj.Free;

  MS.Free;
end;


function TxtSendMail.LoadTemplateAttachment(pk_attachment: Int64): TMAIL_BATCH;
var
  LDRV: TxtDriveCommands;
  LAttRec: TRecAllegatoProp;
begin
  LDRV := uXtDriveCommands.TxtDriveCommands.Create(Self);
  try
    LDRV.xtConnection := Self.xtConnection;
    LAttRec := LDRV.dloadFile(pk_attachment);

  //  if not LAttRec.Downloaded then
  //    raise Exception.Create('Error during loading template attachments:' + LAttRec.Error);

    if LAttRec.MS = nil then
      raise Exception.Create('Error during loading template attachments:' + LAttRec.Error);

    LAttRec.MS.Position := 0;
    result := TJSONPersistence.FromJSON<TMAIL_BATCH>(LAttRec.MS);
  finally
   try
     if LAttRec.MS <> NIL then
       FreeAndNil(LAttRec.MS);

     FreeAndNil(LDRV);
   except

   end;
  end;



end;

class procedure TxtSendMail.ParamReplacer(var contentHtml: String;
  mail_params: String);
Var
  TS : TStringList;
  I: Integer;
  S : String;
  Name,Value : String;
begin
 TS := TStringList.Create;
 try
   TS.CommaText := mail_params;

   for I := 0 to TS.Count-1 do
    Begin
      Name := '';
      Value := '';


      if (TS[I].indexof('=') >= 0)and(TS[I].indexof('#') = 0) then
        Begin

         Name := TS[I].substring(1,TS[I].indexof('='));
         Value := TS[I].substring(TS[I].indexof('='));

        End
      Else
        Value := TS[I];



//      TEncoding.UTF8.de

      contentHtml := contentHtml.Replace('{*' + I.ToString + '*}', UTF8Decode(Value) );

      if Name <> '' then
       begin
        contentHtml := contentHtml.Replace('{*' + Name.toUpper + '*}', UTF8Decode(Value) );
       end;

    End;
//    contentHtml := UTF8Decode(contentHtml);
 finally
   TS.Free;
 end;

end;

class function TxtSendMail.ParamsToUrlParams(mail_params: String): String;
Var
  TS : TStringList;
  I: Integer;
  S : String;
  Name,Value : String;
begin
 Result := '';
 TS := TStringList.Create;
 try
   TS.CommaText := mail_params;

   for I := 0 to TS.Count-1 do
    Begin
      if TS[I].indexof('=') > 0 then
        Begin
         if Result = '' then
           Result := TS[I]
         Else
           Result := Result + '&' + TS[I]
        End;
    End;
 finally
   TS.Free;
 end;
end;

function TxtSendMail.getSystemTemplateFromSystemPath(template_name: string) : TMAIL_BATCH;
var
  respo: IHTTPResponse;
begin
  respo := HTTPprov.doGet(xtConnection.ConnectionParams, xtServiceAddress.TxtServices.downloadtemplate, 'reportname=' + template_name);


  if (respo.StatusCode <> 200)or(respo.ContentStream = nil) then
    raise Exception.Create('[TxtSendMail.getTemplate] HTTP Error (' + respo.StatusCode.ToString + '): ' + respo.ContentAsString);


  respo.ContentStream.Position := 0;
  result := TJSONPersistence.FromJSON<TMAIL_BATCH>(respo.ContentStream);
end;

function TxtSendMail.SaveAsSystemTemplate(msg : TMAIL_BATCH; template_name : String) : Int64;
var
 xtDs : TxtDatasetEntity;
 respo: IHTTPResponse;
 MS: TMemoryStream;
  Ljobj: TJSONObject;
begin
 try
   xtDs := TxtDatasetEntity.Create(self);
   xtDS.xtConnection := Self.xtConnection;
   xtDS.xtApplyUpdateAfterPost := True;
   xtDS.CachedUpdates := True;
   xtDS.xtLiveRecordInsert := True;

   template_name := template_name.ToLower;

   if ExtractFileExt(template_name) = '' then
     template_name := template_name + '.mailxt';

   xtDS.xtEntityName := 'mail_templates';
   xtDS.xtParams.Text := 'tname=' + template_name;
   xtDS.Open;
   if xtDS.Bof and xtDs.Eof then
    Begin
     xtDS.Insert;
     xtDS.FieldByName('template_name').AsString := template_name;
     xtDS.FieldByName('SYSTEM_TEMPLATE').AsString := 'S';
     xtDS.Post;
    End
   Else
    Begin
     xtDS.Edit;
     xtDS.FieldByName('SYSTEM_TEMPLATE').AsString := 'S';
     xtDS.Post;
    End;
   result := xtDS.FieldByName('pk_id').AsLargeInt;
   xtDS.Close;

   Ljobj := TJSONOBject(xtJSON.TJSONPersistence.ToJSON<TMAIL_BATCH>(msg));
   MS := TJSONHelper.JSONToStream(LJOBJ);
   ms.Position := 0;

   respo := HTTPprov.doPost(xtConnection.ConnectionParams,
        xtServiceAddress.TxtServices.uploadrawtemplate,'template_name=' + template_name,MS);

   if respo.StatusCode <> 200 then
    raise Exception.Create(respo.ContentAsString());
 finally
   FreeAndNil(MS);
   FreeAndNil(xtDS);
   Ljobj.Free;
 end;

end;

function TxtSendMail.saveAsTemplateAttachment(msg: TMAIL_BATCH;
  template_name: String): Int64;
var
  Ljobj: TJSONObject;
  MS: TStringStream;
  LDRV: TxtDriveCommands;
begin
  Ljobj := TJSONOBject(xtJSON.TJSONPersistence.ToJSON<TMAIL_BATCH>(msg));
  MS := TJSONHelper.JSONToStream(LJOBJ);
  ms.Position := 0;
  LDRV              := uXtDriveCommands.TxtDriveCommands.Create(Self);
  try
    LDRV.xtConnection := Self.xtConnection;
    result            := LDRV.uploadFile(MS,template_name,1);
  finally
   MS.Free;
   LDRV.Free;
  end;
end;

procedure TxtSendMail.SaveToFile(msg: TMAIL_BATCH; FileName: TFileName);
var
  Ljobj: TJSONObject;
  MS: TStringStream;
begin
  Ljobj := TJSONOBject(xtJSON.TJSONPersistence.ToJSON<TMAIL_BATCH>(msg));
  MS := TJSONHelper.JSONToStream(LJOBJ);
  MS.SaveToFile(FileName);
  MS.Free;
end;

procedure TxtSendMail.SetonAfterSend(const Value: TNotifyEvent);
begin
  FonAfterSend := Value;
end;

procedure TxtSendMail.SetonBeforeSend(const Value: TNotifyEvent);
begin
  FonBeforeSend := Value;
end;

end.
