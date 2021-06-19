unit uXtDriveCommands;

interface

uses system.SysUtils, system.Classes, xtCommonTypes, xtConnection,
     System.Net.HttpClient,
     System.Net.HttpClientComponent,
     uxtCommonComponent;

type


 TBeforeDownloadMethod = reference to function (filename, localRevision, remoteRevision : String) : Boolean;

 TBeforeDownload = reference to  procedure (filename : String; Size : Int64) ;
 TProgressProc   = reference to  procedure (position : Int64; LogStr : String);
 TEndDownload    = reference to  procedure (ErrorCount : Int64) ;


 TrcdFileCartella  = record
    pk_allegato : Int64;
    pk_cartella : Int64;
 end;

 TxtDriveCommands = class(TxtBaseComponent)
 private
   class function revisionToAbsoluteNumber(
         revisionString: String): Extended;
 public
   constructor Create(AOwner: TComponent); override;

   function buildcustomweb(fk_cartella : int64 = -1; fk_allegato : int64 = -1) : String;

   function folderExists(fullFolderPath : String; createIfNotExists : Boolean = False) : Int64;

   function getWebTemplateNames : TFolders;

   function editBaseWebFile(relativeFileName : String) : TrcdFileCartella;

   function dloadFile(pk_id : Integer; aspSize: Integer = -1; retriveInformation : Boolean = False): TRecAllegatoProp; overload;
   function dloadFile(fileName : String; aspSize: Integer = -1; retriveInformation : Boolean = False): TRecAllegatoProp; overload;

   function getFileInfo(pk_id: Int64): TRecAllegatoProp; overload;
   function getFileInfo(fname: String): TRecAllegatoProp; overload;

   class function getPublicFileInfo(ConnectionParams: TConnectionParam;fname: String): TRecAllegatoProp;
   class function dloadPublicFile(ConnectionParams: TConnectionParam;fileName : String;retriveInformation : Boolean = False; OnReceiveData: TReceiveDataEvent = nil): TRecAllegatoProp;

   class function ckPublicApplicationVersion(ConnectionParams: TConnectionParam;
      filename, currentVersion: String; autoDownloadIfNewVer: Boolean = False;
      BeforeDownload: TBeforeDownloadMethod = nil; onReciveData: TReceiveDataEvent = nil): TUpdateApplicationInfo;



   function uploadFile(fileName : String; LogicalFileName : String = '' ;fk_folder : Int64 = -1; Description : String = ''; AFullPath : String = '';ACustomProtocol : String = '') : Int64; overload;

   function uploadFile(AFileStream: TStream;
              AObject_name: String; AFk_directory: Integer = -1; ARelTableName: String = '';
              ARelPk_ID : Int64 = -1; AAttachment_type: Integer = -1; ADescription: String = '';
              AFk_user_owner : Integer = -1; AAccesslevel : Integer = -1;AForced_PK_ID : Int64 = -1; ARaiseException : Boolean = True;
              AFullPath : String = '';ACustomProtocol : String = ''): int64; overload;


   function importZipFiles(ParentFolder : String;ArcFileName: String; LogLines : TStrings = nil; progrFunc : TProgressProc = nil; beforeDload: TBeforeDownload = nil;EndDload : TEndDownload = nil): Int64;

   function deleteFile(pk_allegato : Int64) : Boolean;

   function deleteFolder(pk_folder : Int64) : Boolean;




 published
   property xtConnection;
 end;

 procedure Register;

implementation

uses System.Net.URLClient, system.IOUtils,
     System.Net.Mime, xtServiceAddress, System.Zip,
     System.Character, xtDatasetEntity;


procedure Register;
begin
  RegisterComponents('xTumble', [TxtDriveCommands]);
end;

{ TxtDriveCommands }

function TxtDriveCommands.buildcustomweb(fk_cartella : int64 = -1; fk_allegato : int64 = -1) : String;
var
  respo: IHTTPResponse;
  filtro: string;
begin
  filtro := '';
  result := '';
  if fk_cartella > 0 then
   filtro := 'fk_cartella=' + fk_cartella.ToString;

  if fk_allegato > 0 then
   filtro := 'pk_allegato=' + fk_allegato.ToString;



  respo := HTTPprov.doGet(xtConnection.ConnectionParams,TxtServices.buildcustomweb,filtro);

  if (respo.StatusCode < 200) or (respo.StatusCode > 299) then
   Begin
     raise Exception.Create('Error on building web[' + respo.StatusCode.ToString + ']: ' + respo.ContentAsString);
   End
  Else
   result := respo.ContentAsString;


end;

class function TxtDriveCommands.ckPublicApplicationVersion(
  ConnectionParams: TConnectionParam; fileName,
  currentVersion: String; autoDownloadIfNewVer : Boolean = False;
  BeforeDownload : TBeforeDownloadMethod = nil;
  onReciveData: TReceiveDataEvent = nil): TUpdateApplicationInfo;
var
  fileInfo: TRecAllegatoProp;
  absRemVer: Extended;
  absLocalVer: Extended;

begin
 Result.local_version := currentVersion;
 Result.updateAvailable := False;

 if ExtractFileDir(filename.replace('/',TPath.DirectorySeparatorChar)) = '' then
  filename := '/applications/public/' + filename;


 fileInfo := getPublicFileInfo(ConnectionParams,fileName);

 result.RecAllegatoProp := fileInfo;

 Result.prod_version := fileInfo.v_revision;

 absRemVer   := revisionToAbsoluteNumber(fileInfo.v_revision);
 absLocalVer := revisionToAbsoluteNumber(currentVersion);

 if absRemVer > absLocalVer then
  Begin
   Result.updateAvailable := True;
  End;

 result.RecAllegatoProp.MS := nil;

 if autoDownloadIfNewVer and Result.updateAvailable then
  begin
    if assigned(BeforeDownload) then
      if not BeforeDownload(fileName,Result.local_version,result.prod_version) then
        Exit;

    result.RecAllegatoProp.MS :=
      TxtDriveCommands.dloadPublicFile(ConnectionParams,filename,False,onReciveData).MS;

    result.RecAllegatoProp.Downloaded := True;
  end;

end;

constructor TxtDriveCommands.Create(AOwner: TComponent);
begin
  inherited;

end;

function TxtDriveCommands.deleteFile(pk_allegato: Int64): Boolean;
var
  TS: TStringList;
  xtDSFiles: TxtDatasetEntity;
begin
  TS := TStringList.Create;
  { TODO : sostituire con la locate su xtDSFiles oppure aggiungere un comendo sulla classe xtDrive}
  TS.Values['PK_ID'] := pk_allegato.ToString;
  TS.Values['DELETED'] := 'S';
  TS.Values['xtEntity'] := 'files';


  xtDSFiles:= TxtDatasetEntity.Create(Self);
  xtDSFiles.xtConnection := Self.xtConnection;
  xtDSFiles.xtEntityName := 'files';
  xtDSFiles.customPost(TS,nil);
//  xtDSFiles.Close;
//  xtDSFiles.Open;
  TS.Free;
  xtDSFiles.Free;
end;

function TxtDriveCommands.deleteFolder(pk_folder: Int64): Boolean;
var

  xtDSFolder: TxtDatasetEntity;
begin
  //   ((C.PK_FOLDER = :PK_FOLDER)OR(:PK_FOLDER IS NULL))

  { TODO : sostituire con la locate su xtDSFiles oppure aggiungere un comendo sulla classe xtDrive}

  xtDSFolder:= TxtDatasetEntity.Create(Self);
  xtDSFolder.xtApplyUpdateAfterDelete := True;
  xtDSFolder.xtApplyUpdateAfterPost := True;

  xtDSFolder.xtParams.Clear;

  xtDSFolder.xtParams.Values['pk_folder'] := pk_folder.ToString;

  xtDSFolder.xtConnection := Self.xtConnection;
  xtDSFolder.xtEntityName := 'folders';
  xtDSFolder.Open;
  xtDSFolder.First;

  if xtDSFolder.RecordCount < 1 then
   raise Exception.Create('Folder not found');

  xtDSFolder.Delete;
  xtDSFolder.Close;
  xtDSFolder.Free;
end;




function TxtDriveCommands.dloadFile(fileName: String; aspSize: Integer;
  retriveInformation: Boolean): TRecAllegatoProp;
var
  respo: IHTTPResponse;
begin
  if xtConnection = nil then
    raise Exception.Create('xtConnection is not defined');

  result.Downloaded := False;
  result.OriginalFileName := '';
  result.DisplayFileName := '';
  result.FileSize := -1;
  result.MS := nil;
  result.CacheFileName := '';

  respo := HTTPprov.doGet(xtConnection.ConnectionParams,
    TxtServices.DownloadAttachment, 'fname=' + fileName);

  if respo.StatusCode <> 200 then
   raise Exception.Create('Error downloading file:' + fileName + respo.ContentAsString());

  result.MS := TMemoryStream.Create;
  result.MS.LoadFromStream(respo.ContentStream);
  Result.pk_id := respo.ContentAsString.ToInt64;

  if xtConnection.attchmentCachePath <> '' then
  begin
    try
      result.MS.Position := 0;
      result.CacheFileName := xtConnection.attchmentCachePath +
        xtConnection.CompanyID + '_' + respo.ContentAsString;
      result.MS.SaveToFile(result.CacheFileName);
      result.MS.Position := 0;
    except

    end;
  end;
  result.MS.Position := 0;
end;

class function TxtDriveCommands.dloadPublicFile(ConnectionParams: TConnectionParam;fileName : String;retriveInformation : Boolean = False; OnReceiveData: TReceiveDataEvent = nil): TRecAllegatoProp;
var
  respo: IHTTPResponse;
begin

  result.Downloaded := False;
  result.OriginalFileName := '';
  result.DisplayFileName := '';
  result.FileSize := -1;
  result.MS := nil;
  result.CacheFileName := '';

  if (ConnectionParams.username = '')and(ConnectionParams.password = '') then
    Begin
     respo := HTTPprov.doGet(ConnectionParams,
        TxtServices.DownloadAttachmentPub, 'fname=' + fileName, 'application/x-binary','',OnReceiveData);
    End
   Else
    Begin
     respo := HTTPprov.doGet(ConnectionParams,
       TxtServices.DownloadAttachment, 'fname=' + fileName, 'application/x-binary','',OnReceiveData);
    End;

  if respo.StatusCode <> 200 then
   raise Exception.Create('Error downloading file:' + fileName);

  result.MS := TMemoryStream.Create;
  result.MS.LoadFromStream(respo.ContentStream);
  result.MS.Position := 0;
//  Result.pk_id := respo.ContentAsString.ToInt64;
end;

function TxtDriveCommands.dloadFile(pk_id, aspSize: Integer;
  retriveInformation: Boolean): TRecAllegatoProp;
var
  respo: IHTTPResponse;

begin
  if pk_id < 1 then
    raise Exception.Create('Specified attachment ID not exists');
  if xtConnection = nil then
    raise Exception.Create('xtConnection is not defined');



  result.Downloaded := False;
  result.OriginalFileName := '';
  result.DisplayFileName  := '';
  result.FileSize         := -1;
  result.MS := nil;
  result.CacheFileName    := '';

  If (xtConnection.attchmentCachePath <> '')and(fileExists(xtConnection.attchmentCachePath + xtConnection.CompanyID + '_' + IntToStr(pk_id))) then
   begin
    Result.ms := TMemoryStream.Create;
    result.ms.Position := 0;
    result.CacheFileName :=
        xtConnection.attchmentCachePath + xtConnection.CompanyID + '_' + IntToStr(pk_id);
    result.ms.LoadFromFile(result.CacheFileName);
    result.ms.Position := 0;
    result.FileSize := result.ms.Size;
    result.Downloaded := True;

    Exit;
   end
  Else
   Begin
      try
        respo := HTTPprov.doGet(xtConnection.ConnectionParams,TxtServices.DownloadAttachment,'docId=' + IntToStr(pk_id));

        result.Downloaded :=
         (respo.StatusCode > 199) and (respo.StatusCode < 300);


        Result.MS := TMemoryStream.Create;
        Result.MS.LoadFromStream(respo.ContentStream);


          if xtConnection.attchmentCachePath <> '' then
           begin
            try
             result.ms.Position := 0;
             result.CacheFileName := xtConnection.attchmentCachePath + xtConnection.CompanyID + '_' + IntToStr(pk_id);
             result.ms.SaveToFile(result.CacheFileName);
             result.ms.Position := 0;
            except
             result.Downloaded := False;
            end;
           end;
          (*Else
           begin
            result.ms.Position := 0;
            result.ms.SaveToFile(CompanyID + '_' + IntToStr(pk_id));
            result.ms.Position := 0;
           end; *)

//         End;

        result.ms.Position := 0;
      Finally

      End;
  End;
end;


function TxtDriveCommands.editBaseWebFile(relativeFileName : String) : TrcdFileCartella;
var
  respo: IHTTPResponse;
  values : TArray<System.string>;
begin
  respo := HTTPprov.doGet(xtConnection.ConnectionParams,TxtServices.customizewebfile,'filename=' + relativeFileName);
  if respo.StatusCode = 200 then
   Begin
    values := respo.ContentAsString.Split([',']);

    result.pk_allegato := values[0].ToInt64;
    result.pk_cartella := values[1].ToInt64;
   End
  else
    raise Exception.Create('Errore [' + respo.StatusCode.ToString +
      '] operazione di edit del file [' + relativeFileName + ']:' +
      respo.ContentAsString);

end;

function TxtDriveCommands.folderExists(fullFolderPath : String; createIfNotExists : Boolean = False) : Int64;
var
  xtFolderExists : TxtDatasetEntity;
  rFolder   : TRecFolderProp;
begin
 result := -1;
 xtFolderExists := TxtDatasetEntity.Create(Self);
 xtFolderExists.xtParams.Values['fullpath'] := fullFolderPath;
 if createIfNotExists then
   xtFolderExists.xtParams.Values['create_if_not_exists'] := 'Y';

 xtFolderExists.xtEntityName  := 'folderexists';
 xtFolderExists.xtConnection  := Self.xtConnection;
 xtFolderExists.Open;
 result := xtFolderExists.FieldByName('pk_id').AsLargeInt;
 xtFolderExists.Close;
 FreeAndNil(xtFolderExists);
end;

function TxtDriveCommands.getFileInfo(fname: String): TRecAllegatoProp;
var
  respo: IHTTPResponse;

begin
  if fname = '' then
    raise Exception.Create('Filename not specified');
  if xtConnection = nil then
    raise Exception.Create('xtConnection is not defined');

  result.Downloaded := False;
  result.OriginalFileName := '';
  result.DisplayFileName := '';
  result.FileSize := -1;
  result.MS := nil;
  result.CacheFileName := '';
  result.TagObject := NIL;

  try
    respo := HTTPprov.doHead(xtConnection.ConnectionParams,
      TxtServices.DownloadAttachment, 'fname=' + fname);
    try
      result.OriginalFileName := respo.HeaderValue['filename'];
    except

    end;
    try
      result.v_path := respo.HeaderValue['v_path'];
      IF result.v_path = '' THEN
        result.v_path := '/';
    except

    end;
    try
      result.v_revision := respo.HeaderValue['v_revision'];
      IF result.v_revision = '' THEN
        result.v_revision := '0';

    except

    end;
    try
      result.FileSize := respo.HeaderValue['filesize'].ToInt64;
    except

    end;
    try
      result.pk_id := respo.HeaderValue['pk_attachment'].ToInt64;
      if result.OriginalFileName.tolower <> fname.tolower then
        raise Exception.Create('Wrong file info');
    except

    end;
    IF respo.ContentStream <> NIL THEN
    BEGIN
      if respo.ContentStream.Size > 0 then
      Begin
        result.MS := TMemoryStream.Create;
        result.MS.LoadFromStream(respo.ContentStream);
        if xtConnection.attchmentCachePath <> '' then
        begin
          try
            result.MS.Position := 0;
            result.CacheFileName := xtConnection.attchmentCachePath +
              xtConnection.CompanyID + '_' + IntToStr(result.pk_id);
            result.MS.SaveToFile(result.CacheFileName);
            result.MS.Position := 0;
          except

          end;
        end;

        result.MS.Position := 0;
      End;
    END;
  Finally

  End;
end;

class function TxtDriveCommands.getPublicFileInfo(ConnectionParams: TConnectionParam;fname: String): TRecAllegatoProp;
var
  respo: IHTTPResponse;


begin
  if fname = '' then
    raise Exception.Create('Filename not specified');

  result.Downloaded := False;
  result.OriginalFileName := '';
  result.DisplayFileName := '';
  result.FileSize := -1;
  result.MS := nil;
  result.CacheFileName := '';
  result.TagObject := NIL;


  try
   if (ConnectionParams.username = '')and(ConnectionParams.password = '') then
    Begin
     respo := HTTPprov.doHead(ConnectionParams,
        TxtServices.DownloadAttachmentPub, 'fname=' + fname);
    End
   Else
    Begin
     respo := HTTPprov.doHead(ConnectionParams,
        TxtServices.DownloadAttachment, 'fname=' + fname);
    End;



    try
      result.OriginalFileName := respo.HeaderValue['filename'];
    except

    end;
    try
      result.v_path := respo.HeaderValue['v_path'];
      IF result.v_path = '' THEN
        result.v_path := '/';
    except

    end;
    try
      result.v_revision := respo.HeaderValue['v_revision'];
      IF result.v_revision = '' THEN
        result.v_revision := '0';

    except

    end;
    try
      result.FileSize := respo.HeaderValue['filesize'].ToInt64;
    except

    end;
    try
      result.pk_id := respo.HeaderValue['pk_attachment'].ToInt64;
      if result.OriginalFileName.tolower <> ExtractFileName(fname.replace('/',TPath.DirectorySeparatorChar)).tolower then
        raise Exception.Create('Wrong file info');
    except

    end;
    IF respo.ContentStream <> NIL THEN
    BEGIN
      if respo.ContentStream.Size > 0 then
      Begin
        result.MS := TMemoryStream.Create;
        result.MS.LoadFromStream(respo.ContentStream);
        result.MS.Position := 0;
      End;
    END;
  Finally

  End;
end;


function TxtDriveCommands.getWebTemplateNames: TFolders;
var
  xtFolders : TxtDatasetEntity;
  rFolder   : TRecFolderProp;
begin
 result := [];
 xtFolders := TxtDatasetEntity.Create(Self);
 xtFolders.xtParams.Values['FULL_PARENT_PATH'] := '/@web/custom_template';
 xtFolders.xtParams.Values['fkparentfolder'] := '-1000';
 xtFolders.xtEntityName  := 'folders';
 xtFolders.xtConnection  := Self.xtConnection;
 xtFolders.Open;
 xtFolders.First;
 while not xtFolders.Eof do
  Begin
   rFolder.PK_ID := xtFolders.FieldByName('pk_id').AsLargeInt;
   rFolder.FolderName := xtFolders.FieldByName('name').AsString;
   rFolder.FolderFullPath := xtFolders.FieldByName('FullPath').AsString;

   result := result + [rFolder];
   xtFolders.Next;
  End;
 xtFolders.Close;
 FreeAndNil(xtFolders);
end;

function TxtDriveCommands.getFileInfo(pk_id: Int64): TRecAllegatoProp;
var
  respo: IHTTPResponse;

begin
  if pk_id < 1 then
    raise Exception.Create('Specified attachment ID not exists');
  if xtConnection = nil then
    raise Exception.Create('xtConnection is not defined');

  result.Downloaded := False;
  result.OriginalFileName := '';
  result.DisplayFileName := '';
  result.FileSize := -1;
  result.MS := nil;
  result.CacheFileName := '';
  result.TagObject := NIL;

  try
    respo := HTTPprov.doHead(xtConnection.ConnectionParams,
      TxtServices.DownloadAttachment, 'docId=' + IntToStr(pk_id));
    try
      result.OriginalFileName := respo.HeaderValue['filename'];
    except

    end;
    try
      result.v_path := respo.HeaderValue['v_path'];
      IF result.v_path = '' THEN
        result.v_path := '/';
    except

    end;
    try
      result.v_revision := respo.HeaderValue['v_revision'];
      IF result.v_revision = '' THEN
        result.v_revision := '0';

    except

    end;
    try
      result.FileSize := respo.HeaderValue['filesize'].ToInt64;
    except

    end;
    try
      result.pk_id := respo.HeaderValue['pk_attachment'].ToInt64;
      if result.pk_id <> pk_id then
        raise Exception.Create('Wrong file info');
    except

    end;
    IF respo.ContentStream <> NIL THEN
    BEGIN
      if respo.ContentStream.Size > 0 then
      Begin
        result.MS := TMemoryStream.Create;
        result.MS.LoadFromStream(respo.ContentStream);
        if xtConnection.attchmentCachePath <> '' then
        begin
          try
            result.MS.Position := 0;
            result.CacheFileName := xtConnection.attchmentCachePath +
              xtConnection.CompanyID + '_' + IntToStr(pk_id);
            result.MS.SaveToFile(result.CacheFileName);
            result.MS.Position := 0;
          except

          end;
        end;

        result.MS.Position := 0;
      End;
    END;
  Finally

  End;
end;

function TxtDriveCommands.importZipFiles
    (ParentFolder : String;
     ArcFileName: String;
     LogLines : TStrings = nil;
     progrFunc : TProgressProc = nil;
     beforeDload: TBeforeDownload = nil;
     EndDload : TEndDownload = nil): Int64;
var
  zf: TZipFile;
  I: Integer;
  fname: string;
  fsize: String;
  VFNAME: string;
  VPATH: string;
  SS: TStream;
  ZipHead: TZipHeader;
  pk_id: Int64;
begin
 zf:= TZipFile.Create;
 try
   if LogLines <> nil then
     LogLines.Add('##### START ON BASE DIR ' + ParentFolder + '#####');

   if zf.IsValid(ArcFileName) then
    Begin
      zf.Open(ArcFileName,TZipMode.zmRead);

      if assigned(beforeDload) then
        beforeDload(ArcFileName,zf.FileCount);

      for I:=0 to zf.FileCount -1 do
       Begin
        zf.Read(I,SS,ZipHead);
        fname := zf.FileNames[I];
        SS.Position := 0;
        fsize := SS.Size.ToString;

        VFNAME := ExtractFileName(fname.Replace('/',TPAth.DirectorySeparatorChar));
        VPATH  := ExtractFileDir(fname.Replace('/',TPAth.DirectorySeparatorChar)).Replace('\','/');

        If (VFNAME <> '') then
         Begin
           SS.Position := 0;
           pk_id := uploadFile(SS,VFNAME,-1,'',-1,-1,'',-1,-1,-1,True,ParentFolder + '/' + VPATH);
           if LogLines <> nil then
              LogLines.Add('['+  pk_id.ToString +']' + fname + ' --> ' + fsize + 'bytes');
           SS.Free;
         End
        Else
         Begin
          if LogLines <> nil then
            LogLines.Add('### ' + fname + ' --> ' + fsize + 'bytes');
         End;

        if assigned(progrFunc) then
          progrFunc(I,'');

       End;
    End;
    if LogLines <> nil then
      LogLines.Add('##### END ' + ParentFolder + '#####');

    if assigned(EndDload) then begin
       EndDload(200); // 200 = ok
    end;

 finally
   try
    zf.Free;
   except
      if assigned(EndDload) then begin
         EndDload(401); // 401 = errore
      end;
   end;
 end;


end;

class function TxtDriveCommands.revisionToAbsoluteNumber(
  revisionString: String): Extended;
var
 revQuo: TArray<String>;
 I: Integer;
 len_revQuo: Integer;
 d : Extended;

 function myStrToInt(myStr : String) : Integer;
  var
   tmpStr : String;
    ch: Char;
  Begin
   if myStr = '' then
    Begin
      result := 0;
      exit;
    End;

   tmpStr := '';
   for ch in myStr do
    if TCharacter.IsNumber(ch) then
      tmpStr := tmpStr + ch;

   result := tmpStr.ToInteger;
  End;

begin
 if revisionString = '' then
  result := 0;

 revQuo := revisionString.split(['.']);

 len_revQuo := length(revQuo);

 result := Power10(myStrToInt(revQuo[0]), 36);
 if len_revQuo > 1 then
  result := result + Power10(myStrToInt(revQuo[1]), 30);
 if len_revQuo > 2 then
  result := result + Power10(myStrToInt(revQuo[2]), 24);
 if len_revQuo > 3 then
  result := result + Power10(myStrToInt(revQuo[3]), 18);
 if len_revQuo > 4 then
  result := result + Power10(myStrToInt(revQuo[4]), 12);
 if len_revQuo > 5 then
  result := result + Power10(myStrToInt(revQuo[5]), 6);
 if len_revQuo > 6 then
  result := result + myStrToInt(revQuo[6]);

end;

function TxtDriveCommands.uploadFile(fileName : String; LogicalFileName : String = '' ;fk_folder : Int64 = -1; Description : String = ''; AFullPath : String = '';ACustomProtocol : String = '') : Int64;
var
 FS : TFileStream;

begin
 FS := TFileStream.Create(filename,fmShareDenyNone);
 try
   if LogicalFileName = '' then
    LogicalFileName := ExtractFileName(filename);

   result := uploadFile(FS,LogicalFileName,fk_folder,'',-1,-1,Description,xtConnection.UserId,-1,-1,True,AFullPath,ACustomProtocol);
 finally
   FS.Free;
 end;
end;

function TxtDriveCommands.uploadFile(AFileStream: TStream;
              AObject_name: String; AFk_directory: Integer = -1; ARelTableName: String = '';
              ARelPk_ID : Int64 = -1; AAttachment_type: Integer = -1; ADescription: String = '';
              AFk_user_owner : Integer = -1; AAccesslevel : Integer = -1;AForced_PK_ID : Int64 = -1; ARaiseException : Boolean = True;
              AFullPath : String = '';ACustomProtocol : String = '' ): Int64;

Var
 Stringazza : String;
 MultiPartFormDataStream: TMultipartFormData;
 URL : String;
 respo: IHTTPResponse;
 Lparams : TUploadAttachmentParams;


begin
  MultiPartFormDataStream := nil;
  Result := -1;

  if xtConnection = nil then
    raise Exception.Create('xtConnection is not defined');

  if AFileStream = nil then
    raise Exception.Create('content stream is empty');

  try
    try
      MultiPartFormDataStream := TMultipartFormData.Create;

      AFileStream.Position := 0;
      MultiPartFormDataStream.AddStream('allegato',AFileStream,AObject_name);

      Lparams.filename := ExtractFileName(AObject_name);
      Lparams.action   := 'newfile';
      Lparams.userid   := xtConnection.LastValidateAccountData.UserId;
      Lparams.fk_users := xtConnection.LastValidateAccountData.UserId;
      Lparams.fk_cartella := AFk_directory;
      Lparams.forcedpkid  := AForced_PK_ID;
      Lparams.rel_tb_name := ARelTableName;
      Lparams.rel_pk_id   := ARelPk_Id;
      Lparams.attachment_type  := AAttachment_type;
      Lparams.description      := ADescription;
      Lparams.accesslevel      := AAccesslevel;
      Lparams.Forced_pk_id     := AForced_PK_ID;
      Lparams.custom_protocol  := ACustomProtocol;
      Lparams.fullpath         := AFullPath;


      respo := HTTPprov.doPostMultiPart<TUploadAttachmentParams>(
           xtConnection.ConnectionParams,TxtServices.uploadAttachment,Lparams,MultiPartFormDataStream);

      Stringazza := respo.ContentAsString();
      if (respo.StatusCode < 200) and (respo.StatusCode > 300) then
         raise Exception.Create('[TSynaConnection.uploadAllegato] ERRORE: ' + respo.ContentAsString())
      else
         result := Stringazza.ToInt64;
    Except
     On E:Exception do
      begin
       if ARaiseException then
        raise Exception.Create('[TxtDriveCommands.uploadFile] Error: ' + Stringazza + '-->' + E.Message);
      end;
    End;
  finally

   if MultiPartFormDataStream <> nil then
     Try MultiPartFormDataStream.Free; except end;
  end;
//      Result := Stringazza;
//
//
//    Except
//     On E:Exception do
//         begin
//           if RaiseException then
//            raise Exception.Create(e.Message);
//         end;
//    End;
//
//    // ASSOCIO L'ALLEGATO AD UN RECORD DI UNA SPECIFICA TABELLA
//    try
//     If ((relTableName <> '')and(relPk_ID > 0)and(Stringazza <> '')) then
//      begin
//       ExecQu('insert into ALLEGATI_RELATIONS (fk_allegati, table_name,fk_pk,fk_tipo_allegati)values(' + Stringazza + ',''' + relTableName + ''',' + IntToStr(relPk_ID) + ', ' + IntToStr(fk_Tipo_Allegati) +  ')');
//      end;
//    except
//
//    end;
//
//    // ASSOCIO UNA DESCRIZIONE MANUALE
//
//    IF ((descrizione_libera <> '')or(fk_Tipo_Allegati <> -1)) Then
//     begin
//       ExecQu('update allegati set Descrizione = '''+ StringReplace(descrizione_libera,'''','',[rfReplaceAll]) + ''',fk_tipo_allegati = ' + fk_Tipo_Allegati.ToString + ' where pk_id = ' + Stringazza, False);
//     end;
//
//    { TODO : da togliere l'update quando funzionerà correttamente la servlet recependo lo userId }
//    {IF user_id_owner > 0 Then
//     begin
//       ExecQu('update allegati set fk_users = ' + IntToStr(user_id_owner) + ' where pk_id = ' + Stringazza,False);
//     end; }
//
//  Finally
//
//   try IdHTTP.Free; except end;
//  End;
end;


end.
