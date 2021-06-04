unit xtCommonTypes;

interface

uses
  SysUtils, Classes, DB;

type




  TFieldNameValue = record
     Name : String;
     Value : String;
  end;

  TRcdArray = TArray<TFieldNameValue>;

  TConnectionType = (ctHTTP, ctWebSoket, ctSoket, (*old style*) ctIBO, ctWebService, ctHTTP_PHP,ctFireDac);
  // TConnectionType = ();

  TEsitoRegistrazioneAccount = record
    registratoCorrettamente : Boolean;
    errorCode               : Integer;
    messaggio               : String;
  end;

  TDBSCript = record
    scriptID: Int64;
    app_scope: String;
    psql: String;
  end;

  TNextScriptResult = record
    success : Boolean;
    MessageText : String;
    noMoreScripts : boolean;
    script : TDBScript;
  end;

  TConnectionParam = record
    ServerAddress: String;
    companyId: String;
    userName: String;
    password: String;
    attachmentCachePath: String;
    readTimeOut: Integer;
    connectionTimeOut: Integer;
    agent            : String;
    procedure init;
    class operator Initialize(out Dest: TConnectionParam);
  end;

  TValidateAccount = record
    Success: Boolean;
    Ok: Boolean;
    ResultString: String;
    UserId: Integer;
    userMail: String;
    accesslevel: Integer;
    LimitiSuperati: Boolean;
    LimitString: String;
    ErrorString: String;
    SessionID: String;
    procedure init;
    class operator Initialize(out Dest: TValidateAccount);
  end;

  // CAMPI NECESSARI PER CREARE UN ACCOUNT SYNALOGIN / XTUMBLE
  TCreateXTAccountParams = record
    reg_ragione_sociale: String;
    reg_PIVA: String;
    reg_nome: String;
    reg_cognome: String;
    reg_username: String;
    reg_password: String;
    reg_mail: String;
    reg_code_reseller: String;
    reg_naz: String;
    function compilato: Boolean;
  end;



  TLoginXTAccountParams = record
    reg_PIVA: String;
    reg_username: String;
    reg_password: String;
    function compilato: Boolean;
  end;

  // ********************** [ TDBCacheKind ] ********************
  // cdkNotUsrDBCache --> forzo che non venga usata
  // cdkStrictReadOnly      --> Legge soltanto dalla cache
  // cdkReadOnly            --> Quando effettua le modifiche le scrive anche sulla cache
  // cdkBidirectional       --> Legge e scrive sulla cache
  // cdkUseOnlyCacheSystem  --> Utilizza esclusivamente la cache

  TDBCacheKind = (cdkDisableDBCache, cdkStrictReadOnly, cdkReadOnly,
    cdkBidirectional, cdkUseOnlyCacheSystem);

  TArrayOfString = array of string;




  TRecAllegatoProp = record
    pk_id: Int64;
    OriginalFileName: String;
    DisplayFileName: String;
    FileSize: Int64;
    MS: TMemoryStream;
    CacheFileName: String; // nome file dell'allegato nella cache dir
    DestFileName: String; // nome file di destinazione scelto dall'utente
    Error: String;
    Downloaded: Boolean;
    TagString: String;
    Tag: Integer;
    TagObject: TObject;
    Content_sha2_256 : String;
    v_revision : String;
    v_path     : String;
  end;

  TRecFolderProp = record
  public
    FolderName : String;
    FolderFullPath : String;
    PK_ID : Int64;
  end;

  TFolders = TArray<TRecFolderProp>;

  TRecUploadAllegatoResult = record
    pk_id : Int64;
    Error : String;
    http_status_code : Integer;
    FileSize : Int64;
    DestFileName : String;
    function Completed : Boolean;
  end;

  TUpdateApplicationInfo = record
    prod_version  : String;
    local_version : String;
    updateAvailable : Boolean;
    RecAllegatoProp : TRecAllegatoProp;
  End;


  TUploadAttachmentParams = record
    filename : String;
    action : String;
    userid : Int64;
    fk_users : Int64;
    fk_cartella : Int64;
    forcedpkid : Int64;
    rel_tb_name : String;
    rel_pk_id   : Int64;
    attachment_type : Int64;
    description : String;
    accesslevel : Integer;
    Forced_pk_id : Int64;
    fullpath      : String;
    custom_protocol : String;
  End;


  TFunctionToFireAfterAsync = function(dataset: TDataSet): String;

  TAttchmentDloadEndProc = procedure(IDAllegato: Integer;
    OriginalFileName: String; LocalCacheFileName: String; MS: TMemoryStream;
    Error: String; DestFileName: String; Downloaded: Boolean) of object;

  TAttchmentDloadEndProcEX = procedure(IDAllegato: Integer;
    OriginalFileName: String; LocalCacheFileName: String; MS: TMemoryStream;
    Error: String; DestFileName: String; Downloaded: Boolean;
    AllegatoProp: TRecAllegatoProp) of object;

  TAttchmentUploadEndProc = procedure(IDAllegato: Integer; fileName: TFileName;
    fk_cartella: Integer = -1; relTableName: String = '';
    relPk_ID: Integer = -1; fk_Tipo_Allegati: Integer = -1;
    descrizione_libera: String = ''; user_id_owner: Integer = -1;
    accesslevel: Integer = -1; ExtraQU: String = '') of object;

  TAttachProcEnd = procedure;

  TQuEndProc = procedure(qu, Error: String);

  TLogProcedure = procedure(const text: String) of object;



  TAccountOutCome = record
    registratoCorrettamente: Boolean;
    errorCode: Integer;
    messaggio: String;
  end;

  TValidateAccountResult = record
    Success: Boolean;
    Ok: Boolean;
    ResultString: String;
    UserId: Integer;
    AccessLevel: Integer;
    LimitiSuperati: Boolean;
    LimitString: String;
    ErrorString : String;
  end;

  TMAIL_BATCH_ATTACHMENTS = record
    MIMETYPE:String;
    FILENAME:String;
    ATTACHMENT_LINK:String;
    FK_ATTACHMENTS:int64;
    ATTACHMENT_REMOTE_NAME: String;
  End;

  TMAIL_BATCH_REPORTS = record
    REPORT_NAME : String;
  End;

  TMAIL_BATCH = record
    ID: Int64;
    MAIL_TO: String;
    SUBJECT: String;
    BODY: UTF8String;
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
    TEMPLATE_NAME : String;
    TEMPLATE_PARAMS: String;
    AttachmentList : TArray<TMAIL_BATCH_ATTACHMENTS>;
    ReportList     : TArray<TMAIL_BATCH_REPORTS>;
  End;



 TConnectionProtocols = (cpSynaLogin,cpFBEmbedded,cpFBTCP,cpIBEmbedded,cpIBTCP);

 TDataBaseConnectionParam = record
    companyId           : String;
    connection_protocol : TConnectionProtocols;
    ServerAddress       : String;
    DataBaseLocation    : String;
    serverPort          : String;
    userName            : String;
    password            : String;
    attachmentCachePath : String;
    readTimeOut         : Integer;
    connectionTimeOut   : Integer;
    ConnectionType      : TConnectionType;
    class operator Initialize (out Dest: TDataBaseConnectionParam);
    function protocolAsString : String;
    function DatabaseLocationFullPath(appPath : String = '') : String;
 end;

 TAddressInfo = record
 Const
   stNonValido = -2;
   stValido    = 1;
   stErrorOSM  = 2;
   stIndefinito= -1;
 public
   Stato : Integer; // 0 --> non valido 1 --> Valido 2 --> errore parsing da openStreetMap
   Latitudine : Single;
   Longitudine : Single;
   Distanza : Single;
   Limite_km_superato : String; // S o N

   indirizzo : String;
   numero_civico : String;
   cap : String;
   localita : String;
   prov_nome_esteso : String;
   Provincia   : String;
   Nazione     : String;

   MaxDistance : Extended;
   LimiteDistanzaAttivo : Boolean;

   function FullAddress : String;
 end;

 TFieldInfo = record
    Name : String;
    dataType  : TFieldType;
    size      : Integer;
  end;

  TNamedDataSetInfo = record
    Name   : String;
    Fields : TArray<TFieldInfo>;
    Params : TArray<TFieldInfo>;
    class operator Initialize (out Dest: TNamedDataSetInfo);
  end;


implementation

{ TDataBaseConnectionParam }
uses
  System.IOUtils;


{ TDataBaseConnectionParam }



function TDataBaseConnectionParam.protocolAsString: String;
begin
 case Self.connection_protocol of
   cpSynaLogin   : result := 'synaLogin';
   cpFBEmbedded  : result := 'Local';
   cpFBTCP       : result := 'TCPIP';
   cpIBEmbedded  : result := 'Local';
   cpIBTCP       : result := 'TCPIP';
 end;
end;

function TDataBaseConnectionParam.DatabaseLocationFullPath (appPath : String = '') : String;
begin
 if appPath = '' then
  result := self.databaseLocation.Replace('.\',ExtractFileDir(paramstr(0)) + TPath.DirectorySeparatorChar).Replace('./',ExtractFileDir(paramstr(0))+ TPath.DirectorySeparatorChar)
 Else
  result := self.databaseLocation.Replace('.\',appPath + TPath.DirectorySeparatorChar).Replace('./',appPath+ TPath.DirectorySeparatorChar);

end;

class operator TDataBaseConnectionParam.Initialize (out Dest: TDataBaseConnectionParam);
begin
  Dest.readTimeOut := 20000;
  Dest.connectionTimeOut := 5000;
end;



class operator TConnectionParam.Initialize
  (out Dest: TConnectionParam);
begin
  Dest.ServerAddress := '';
  Dest.companyId     := '';
  Dest.userName      := '';
  Dest.password      := '';
  Dest.attachmentCachePath := '';
  Dest.readTimeOut   := 20000;
  Dest.connectionTimeOut := 500;
end;

procedure TConnectionParam.init;
begin
  self.ServerAddress := '';
  self.companyId     := '';
  self.userName      := '';
  self.password      := '';
  self.attachmentCachePath := '';
  self.readTimeOut   := 20000;
  self.connectionTimeOut := 500;
  self.agent := '';
end;

{ TCreateXTAccountParams }

function TCreateXTAccountParams.compilato: Boolean;
begin

  result := (reg_ragione_sociale <> '') and (reg_PIVA <> '') and
  (* (reg_nome            <> '')and
    (reg_cognome         <> '')and *)
    (reg_username <> '') and (reg_password <> '') and (reg_mail <> '');

end;

{ TLoginXTAccountParams }

function TLoginXTAccountParams.compilato: Boolean;
begin
  result := (self.reg_PIVA <> '') and (self.reg_username <> '') and
    (self.reg_password <> '');
end;

{ TValidateAccountResult }

class operator TValidateAccount.Initialize
  (out Dest: TValidateAccount);
begin
  Dest.Success := False;
  Dest.Ok := False;
  Dest.ResultString := '';
  Dest.UserId := -1;
  Dest.accesslevel := 1000000;
  Dest.LimitiSuperati := False;
  Dest.LimitString := '';
  Dest.ErrorString := '';
  Dest.SessionID := '';

end;

procedure TValidateAccount.init;
begin
  Self.Success := False;
  Self.Ok := False;
  Self.ResultString := '';
  Self.UserId := -1;
  Self.accesslevel := 1000000;
  Self.LimitiSuperati := False;
  Self.LimitString := '';
  Self.ErrorString := '';
  Self.SessionID := '';
end;

{ TRecUploadAllegatoResult }

function TRecUploadAllegatoResult.Completed: Boolean;
begin
 Result := (Error = '')and(pk_id > 0)and(http_status_code > 199)and(http_status_code < 300);
end;

{ TAddressInfo }

function TAddressInfo.FullAddress: String;
begin
  Result := self.indirizzo + ' ' +
      self.numero_civico + ' ' + self.cap
       + ' ' + self.localita + ' ' +
      self.prov_nome_esteso;
end;

{ TNamedDataSetInfo }

class operator TNamedDataSetInfo.Initialize(out Dest: TNamedDataSetInfo);
begin
 Dest.Fields := [];
 Dest.Params := [];
end;


end.

