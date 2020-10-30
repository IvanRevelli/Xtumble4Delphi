unit uXtDriveCommands;

interface

uses system.SysUtils, system.Classes, xtCommonTypes, xtConnection,
  uxtCommonComponent;

type

 TxtDriveCommands = class(TxtBaseComponent)
 private

 public
   constructor Create(AOwner: TComponent); override;

   function dloadFile(pk_id : Integer; aspSize: Integer = -1; retriveInformation : Boolean = False): TRecAllegatoProp;

   function uploadFile(fileName : String; LogicalFileName : String = '' ;fk_folder : Int64 = -1; Description : String = '') : Int64; overload;

   function uploadFile(AFileStream: TStream;
              AObject_name: String; AFk_directory: Integer = -1; ARelTableName: String = '';
              ARelPk_ID : Int64 = -1; AAttachment_type: Integer = -1; ADescription: String = '';
              AFk_user_owner : Integer = -1; AAccesslevel : Integer = -1;AForced_PK_ID : Int64 = -1; ARaiseException : Boolean = True
              ): int64; overload;
 published
   property xtConnection;
 end;

 procedure Register;

implementation

uses System.Net.URLClient, System.Net.HttpClient,
     System.Net.HttpClientComponent, system.IOUtils,
     System.Net.Mime, xtServiceAddress;


procedure Register;
begin
  RegisterComponents('xTumble', [TxtDriveCommands]);
end;

{ TxtDriveCommands }

constructor TxtDriveCommands.Create(AOwner: TComponent);
begin
  inherited;

end;

function TxtDriveCommands.dloadFile(pk_id, aspSize: Integer;
  retriveInformation: Boolean): TRecAllegatoProp;
var

  SS              : TStringStream;
  URL             : String;
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
    Exit;
   end
  Else
   Begin
      SS     := nil;
      try
        respo := HTTPprov.doGet(xtConnection.ConnectionParams,'DownloadAttachment','docId=' + IntToStr(pk_id));
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


function TxtDriveCommands.uploadFile(fileName : String; LogicalFileName : String = '' ;fk_folder : Int64 = -1; Description : String = '') : Int64;
var
 FS : TFileStream;

begin
 FS := TFileStream.Create(filename,fmShareDenyNone);
 try
   if LogicalFileName = '' then
    LogicalFileName := ExtractFileName(filename);


   result := uploadFile(FS,LogicalFileName,fk_folder,'',-1,-1,Description);
 finally
   FS.Free;
 end;
end;

function TxtDriveCommands.uploadFile(AFileStream: TStream;
              AObject_name: String; AFk_directory: Integer = -1; ARelTableName: String = '';
              ARelPk_ID : Int64 = -1; AAttachment_type: Integer = -1; ADescription: String = '';
              AFk_user_owner : Integer = -1; AAccesslevel : Integer = -1;AForced_PK_ID : Int64 = -1; ARaiseException : Boolean = True
              ): Int64;

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

