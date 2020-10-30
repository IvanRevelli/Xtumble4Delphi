unit xtSendMail;

interface


uses system.SysUtils, system.Classes, xtCommonTypes, xtConnection,
  uxtCommonComponent,  xtServiceAddress;

type
  TMAIL_BATCH_ATTACHMENTS = record
    MIMETYPE:String;
    FILENAME:String;
    ATTACHMENT_LINK:String;
    FK_ATTACHMENTS:Integer;
  End;

  TMAIL_BATCH = record
    ID: Int64;
    MAIL_TO: String;
    SUBJECT: String;
    BODY: String;
    SENT: TDateTime;
    SENT_FLAG: CHAR;
    MAIL_FROM: String;
    IS_HTML: CHAR;
    HAVE_ATTACHMENTS: CHAR;
    FOREIGN_ID: Integer;
    FOREIGN_TABLE: String;
    IDMAIL_STATUS: Integer;
    MIMETYPE: String;
    DATA_INSERIMENTO: TDateTime;
    DATA_ULTIMA_MODIFICA: TDateTime;
    DB_SYNC_ID: Integer;
    UID: String;
    CCN: String;
    CC: String;
    FK_IDDOC: Int64;
    FROM_NAME: String;
    FK_USER: Int64;
    FK_CUSTOM_MAIL_TEMPLATE: Int64;
    TEMPLATE_PARAMS: String;
    AttachmentList : TArray<TMAIL_BATCH_ATTACHMENTS>;
  End;

 TxtSendMail = class(TxtBaseComponent)
 private
    FonBeforeSend: TNotifyEvent;
    FonAfterSend: TNotifyEvent;
    procedure SetonAfterSend(const Value: TNotifyEvent);
    procedure SetonBeforeSend(const Value: TNotifyEvent);

 protected
    procedure doBeforeActivate; override;
 public
   constructor Create(AOwner: TComponent); override;
   function enqueMailMessage(msg : TMAIL_BATCH) : Int64;

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
     System.Net.Mime,system.JSON, xtJSON, uProviderHTTP;

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

procedure TxtSendMail.SetonAfterSend(const Value: TNotifyEvent);
begin
  FonAfterSend := Value;
end;

procedure TxtSendMail.SetonBeforeSend(const Value: TNotifyEvent);
begin
  FonBeforeSend := Value;
end;

end.
