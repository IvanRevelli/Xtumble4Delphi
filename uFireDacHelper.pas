unit uFireDacHelper;

interface

uses
  System.SysUtils, System.Classes, Data.FMTBcd,Data.DB,
  FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, FireDAC.Stan.StorageJSON,
  FireDAC.Comp.BatchMove.DataSet, FireDAC.Comp.BatchMove,
  FireDAC.Comp.BatchMove.Text, System.ImageList, xtCommonTypes;

type

  TFireDacHelper = class
    class function StringToParams(paramsString: String): TStringList;

    class procedure stdFieldDispW(ds : TDataSet);

    class Function OpenQu(FDConn : TFDConnection;Qu : String;
Params : TStrings = nil;AutoOpen : Boolean = True;LocaleSettings : String = 'it';NumericDisplayFormat : String = '0.00';maxFieldDisplaySize : Integer = 40; onlyPrepareDS : Boolean = false) : TDataSet;

    class Function OpenQuByName(FDConn: TFDConnection; QuName: String;
      fk_custom_report: Int64; Params: TStrings = nil; AutoOpen: Boolean = True;
      LocaleSettings: String = 'it'; NumericDisplayFormat: String = '0.00';
      maxFieldDisplaySize: Integer = 40): TDataSet;

    class function quReadFirstField(FDConn: TFDConnection; Qu: String;
      raiseExceptionIfNoRecordsFound: Boolean = False): String;

    class Function QuReadFirstRecord(FDConn: TFDConnection; Qu: String;
      Params: TStrings = nil): TrcdArray;

    class function ExecQu(FDConn: TFDConnection; Qu: String;
      SollevaEccezione: Boolean = True): Boolean;

    class function CreateFDConnection(DataBaseConnectionParam
      : TDataBaseConnectionParam; autoActivate: Boolean = True): TFDConnection;

    class procedure applyFDConnSettings(FDConn: TFDConnection;
      DataBaseConnectionParam: TDataBaseConnectionParam;
      autoActivate: Boolean = True; appPath: String = '');

    class function GenValue(FDConn: TFDConnection; generatorName: String;
      Increment: Int64 = 1): Int64;

    // FUNZIONI SPECIFICHE XTUMBLE
    class function GetImpostazioneAsExtended(FDConn: TFDConnection;
      costante, DefaultValue: String): Extended;

    class function GetImpostazioneAsInteger(FDConn: TFDConnection;
  costante : String; DefaultValue: Integer): Integer;

    class function GetImpostazione(FDConn: TFDConnection; costante: String;
      DefaultValue: String = ''): String;

    class function SetImpostazione(FDConn: TFDConnection; costante: String;
      Value: String = ''): String;

    class function DestroyConnection(var FDConn: TFDConnection) : Boolean;

  end;

implementation

{ TFireDacHelper }
uses System.IOUtils
 , xtDatasetEntity
 , xtJSON
{$IFDEF IOS}
 ,Macapi.CoreFoundation
{$ENDIF}
;

class procedure TFireDacHelper.applyFDConnSettings(FDConn: TFDConnection;
  DataBaseConnectionParam: TDataBaseConnectionParam; autoActivate : Boolean = True; appPath : String = '');
var
  DatabaseLocationFullPath: String;
begin
  if FDConn.Connected then
    FDConn.Close;

   If (DataBaseConnectionParam.DatabaseLocationFullPath.StartsWith('.' + TPath.DirectorySeparatorChar))
      and
      (appPath <> '')
   then
    begin
     DatabaseLocationFullPath :=
       DataBaseConnectionParam.DatabaseLocationFullPath.Replace('.' + TPath.DirectorySeparatorChar,
                       appPath  + TPath.DirectorySeparatorChar,[]);
    end
   Else
    DatabaseLocationFullPath :=
      DataBaseConnectionParam.DatabaseLocationFullPath(appPath);

   DatabaseLocationFullPath :=
     DatabaseLocationFullPath.Replace(TPath.DirectorySeparatorChar + TPath.DirectorySeparatorChar, TPath.DirectorySeparatorChar);



  {$IF DEFINED(iOS) or DEFINED(ANDROID)}
    FDConn.DriverName := 'FB';
    FDConn.LoginPrompt := False;
    FDConn.Params.Clear;
    FDConn.Params.add('');
    FDConn.Params.add('User_Name=' + DataBaseConnectionParam.userName);
    FDConn.Params.add('Password=' + DataBaseConnectionParam.password);
  //  FDConn.Params.Values['Protocol'] := DataBaseConnectionParam.protocolAsString;
    FDConn.Params.Values['Database'] := DatabaseLocationFullPath;
    FDConn.Params.add('DriverID=IBLite');
  {$ELSE}


    if DataBaseConnectionParam.connection_protocol = cpIBEmbedded then
     Begin
      FDConn.DriverName := 'IBLite';
      FDConn.LoginPrompt := False;
      FDConn.Params.Clear;
      FDConn.Params.add('');
      FDConn.Params.add('User_Name=' + DataBaseConnectionParam.userName);
      FDConn.Params.add('Password=' + DataBaseConnectionParam.password);
//      FDConn.Params.Values['Protocol'] := DataBaseConnectionParam.protocolAsString;
      FDConn.Params.Values['Database'] := DatabaseLocationFullPath;
      FDConn.Params.add('DriverID=IBLite');
     End
    Else if DataBaseConnectionParam.connection_protocol  = cpIBTCP then
     Begin
        FDConn.DriverName := 'IB';
        FDConn.LoginPrompt := False;
        FDConn.Params.Clear;
        FDConn.Params.add('');
        FDConn.Params.add('User_Name=' + DataBaseConnectionParam.userName);
        FDConn.Params.add('Password=' + DataBaseConnectionParam.password);
        FDConn.Params.Values['Protocol'] := DataBaseConnectionParam.protocolAsString;
        FDConn.Params.Values['Server'] := DataBaseConnectionParam.ServerAddress;
        FDConn.Params.Values['Port'] := DataBaseConnectionParam.serverPort;
      //  FDConn.Params.Values['Database'] :=  TPath.Combine(dmmain.appPath, 'xtumble.gdb');
        FDConn.Params.Values['Database'] :=  DatabaseLocationFullPath;
        FDConn.Params.add('DriverID=IB');
     End
    Else if DataBaseConnectionParam.connection_protocol  = cpFBTCP then
     Begin
        FDConn.DriverName := 'FB';
        FDConn.LoginPrompt := False;
        FDConn.Params.Clear;
        FDConn.Params.add('');
        FDConn.Params.add('User_Name=' + DataBaseConnectionParam.userName);
        FDConn.Params.add('Password=' + DataBaseConnectionParam.password);
        FDConn.Params.Values['Protocol'] := DataBaseConnectionParam.protocolAsString;
        FDConn.Params.Values['Server'] := DataBaseConnectionParam.ServerAddress;
        FDConn.Params.Values['Port'] := DataBaseConnectionParam.serverPort;
      //  FDConn.Params.Values['Database'] :=  TPath.Combine(dmmain.appPath, 'xtumble.gdb');
        FDConn.Params.Values['Database'] :=  DatabaseLocationFullPath;
        FDConn.Params.add('DriverID=FB');
     End
    Else if DataBaseConnectionParam.connection_protocol  = cpFBEmbedded then
     Begin
        FDConn.DriverName := 'FBEmbedded';
        FDConn.LoginPrompt := False;
        FDConn.Params.Clear;
        FDConn.Params.add('');
        FDConn.Params.add('User_Name=' + DataBaseConnectionParam.userName);
//        FDConn.Params.add('Password=' + DataBaseConnectionParam.password);
//        FDConn.Params.Values['Protocol'] := 'local';
//        FDConn.Params.Values['Server'] := '';
//        FDConn.Params.Values['Port'] := '';
//        FDConn.Params.Values['Server'] := DataBaseConnectionParam.ServerAddress;
//        FDConn.Params.Values['Port'] := DataBaseConnectionParam.serverPort;
      //  FDConn.Params.Values['Database'] :=  TPath.Combine(dmmain.appPath, 'xtumble.gdb');
        FDConn.Params.Values['Database'] :=  DatabaseLocationFullPath;
        FDConn.Params.add('DriverID=FBEmbedded');
     End
    Else
     Begin
        FDConn.DriverName := 'IB';
        FDConn.LoginPrompt := False;
        FDConn.Params.Clear;
        FDConn.Params.add('');
        FDConn.Params.add('User_Name=' + DataBaseConnectionParam.userName);
        FDConn.Params.add('Password=' + DataBaseConnectionParam.password);
        FDConn.Params.Values['Protocol'] := DataBaseConnectionParam.protocolAsString;
        FDConn.Params.Values['Server'] := DataBaseConnectionParam.ServerAddress;
        FDConn.Params.Values['Port'] := DataBaseConnectionParam.serverPort;
      //  FDConn.Params.Values['Database'] :=  TPath.Combine(dmmain.appPath, 'xtumble.gdb');
        FDConn.Params.Values['Database'] :=  DatabaseLocationFullPath;
        FDConn.Params.add('DriverID=IB');
     End;

  {$ENDIF}

//  FDConn.Params.add('Protocol=TCPIP');
//  FDConn.Params.add('CharacterSet=win1251');
  FDConn.Connected := True;
end;

class function TFireDacHelper.CreateFDConnection(
  DataBaseConnectionParam: TDataBaseConnectionParam;autoActivate : Boolean = true): TFDConnection;
begin
  Result := TFDConnection.Create(nil);
  applyFDConnSettings(Result,DataBaseConnectionParam,autoActivate);

end;

class function TFireDacHelper.DestroyConnection(
  var FDConn: TFDConnection): Boolean;
begin
 Try
   if FDConn <> nil then
    Begin
      if FDConn.Connected then
        FDConn.Close;
    End;
 Except

 End;

 Try
   FreeAndNil(FDConn);
 Except

 End;
end;

class function TFireDacHelper.ExecQu(FDConn: TFDConnection; Qu: String;
  SollevaEccezione: Boolean): Boolean;
var
  IBQ: TFDQuery;
  StrTmp: string;
begin
  ibq := nil;
  result := False;
  Try
    If not FDConn.Connected then
      FDConn.Open;
    Try
      IBQ := TFDQuery.Create(nil);
      IBQ.SQL.Text := qu;
      IBQ.Connection  := FDConn;
      IBQ.ExecSQL;
    Except
      On E: exception do
      Begin
        StrTmp := 'Errore : ' + E.Message + ' --> ' + qu;
        result := False;
        If SollevaEccezione then
          raise exception.Create(StrTmp);
      End;
    End;
  Finally
   if ibq <> nil then
    try ibq.Free; Except end;
  End;

end;


class function TFireDacHelper.GenValue(FDConn : TFDConnection;generatorName: String;
  Increment: Int64 = 1): Int64;
begin
 result := TFireDacHelper.quReadFirstField(FDConn,'select gen_id(' + generatorName + ',' + Increment.ToString + ') from rdb$database').ToInt64;
end;

class function TFireDacHelper.GetImpostazione(FDConn: TFDConnection;
  costante: String;DefaultValue : String = ''): String;
var
  ds: TdataSet;
begin
 ds := nil;
 try
  ds := OpenQu(FDConn,'select result from GET_IMPOSTAZIONE('''+ costante + ''','''+ DefaultValue + ''',''STRING'')');
  result := ds.Fields[0].AsString;
  ds.Close;
 finally
  if ds <> nil then
    try ds.free; except end;
 end;
end;

class function TFireDacHelper.GetImpostazioneAsExtended(FDConn: TFDConnection;
  costante, DefaultValue: String): Extended;
var
  ds: TdataSet;
begin
 ds := nil;
 result := 0;
 try
    ds := OpenQu(FDConn, 'select cast(result as float) from GET_IMPOSTAZIONE('''
      + costante + ''',''' + DefaultValue + ''',''NUMERIC'')');
    ds.Open;
    if ds.Fields[0].IsNull then
      Result := 0
    Else
      Result := ds.Fields[0].AsExtended;

    ds.Close;
 finally
  if ds <> nil then
    try ds.free; except end;
 end;
end;

class function TFireDacHelper.GetImpostazioneAsInteger(FDConn: TFDConnection;
  costante : String; DefaultValue: Integer): Integer;
var
  ds: TdataSet;
begin
 ds := nil;
 result := 0;
 try
    ds := OpenQu(FDConn, 'select cast(result as integer) from GET_IMPOSTAZIONE('''
      + costante + ''',''' + DefaultValue.ToString + ''',''NUMERIC'')');
    ds.Open;
    if ds.Fields[0].IsNull then
      Result := 0
    Else
      Result := ds.Fields[0].AsInteger;

    ds.Close;
 finally
  if ds <> nil then
    try ds.free; except end;
 end;
end;


class Function TFireDacHelper.OpenQu(FDConn : TFDConnection;Qu : String;
Params : TStrings = nil;AutoOpen : Boolean = True;LocaleSettings : String = 'it';NumericDisplayFormat : String = '0.00';maxFieldDisplaySize : Integer = 40; onlyPrepareDS : Boolean = false) : TDataSet;
var
  FDQu: TFDQuery;
  I: Integer;
  m: Integer;
  strVal: string;
  FormatIT: TFormatSettings;
begin

  FDQu := TFDQuery.Create(nil);
  FDQu.Connection := FDConn;
  FDQu.SQL.Text := qu;
  FDQu.Prepare;

  if onlyPrepareDS then
   Begin
     result := FDQu;
     exit;
   End;



//
//  FormatIT := System.SysUtils.FormatSettings;


  if qu = '' then
   begin
     result := nil;
     raise Exception.Create('Query non specificata');
   end;



//  FDQu.Prepare;
  try
    if LocaleSettings <> '' then
     {$IFDEF MSWINDOWS}
      GetLocaleFormatSettings(1040, formatSettings);
     {$ELSE}
       {$IFDEF IOS}
         //Macapi.CoreFoundation.LOCALE
         //GetLocaleFormatSettings(CFLocaleRef 1040, formatSettings);
         formatSettings := TFormatSettings.Create('it_IT');
       {$ELSE}
//         GetLocaleFormatSettings('it', formatSettings);
       {$ENDIF}
     {$ENDIF}
  except

  end;



  If (FDQu.ParamCount > 0) then
   Begin


    for I := 0 to FDQu.ParamCount-1 do
     Begin
      FDQu.Params[I].Clear;
      FDQu.Params[I].Bound := True;
     End;



    if Params <> nil then
     for I := 0 to FDQu.ParamCount-1 do
     Begin
      m := Params.IndexOfName(FDQu.Params[I].Name.toLower);

      if m >= 0 then
       Begin

        try
          strVal := Params.ValueFromIndex[m].Replace(#10,'').Replace(#13,'').Trim; // [FDQu.Params[I].Name.toLower];


          if (FDQu.Params[I].DataType in [
            ftSmallint, ftInteger, ftWord, // 0..4
            ftFloat, ftCurrency,
            ftLargeint, ftShortint, ftByte,ftBCD,ftFMTBCD, ftExtended, ftSingle]) then
            begin
             if strVal <> '' then
              Begin
                strVal :=
                  strVal.replace('.',formatSettings.DecimalSeparator).replace(',',formatSettings.DecimalSeparator);

                FDQu.Params[I].value := strVal;
              End
             Else
              FDQu.Params[I].Clear;
            end
          Else
            FDQu.Params[I].Value := strVal;
        except
          on e:exception do
           Begin
             raise Exception.Create('[TFireDacHelper.OpenQu] Error Message:' + e.message);
           End;
        end;
//         on e:exception do
//          Begin
////            if FDQu.Params[I].DataType in [
////            dtInt16, dtInt32, dtInt64,                     // signed int
////            dtByte, dtUInt16, dtUInt32, dtUInt64,                   // unsinged int
////            dtSingle, dtDouble, dtExtended,                         // float point numbers
////            dtCurrency] then
////            begin
////
////            end
//
//          End;
//        end;
//        writelog(FDQu.Params[I].Name.toLower + '-->' + FDQu.Params[I].AsString,'');
       End;
     End;


   End;

  try
    FDQu.Active := True;
    FDQu.FetchAll;

    for I := 0 to FDQu.Fieldcount-1 do
     Begin
      if FDQu.Fields[I].DataType in [ftSingle, ftExtended, ftFloat, ftBCD, ftFMTBcd, ftCurrency]  then
       Begin
        TNumericField(FDQu.Fields[I]).DisplayFormat :=
         NumericDisplayFormat;
       End
      Else if FDQu.Fields[I].DataType in [ftString]  then
       Begin
        if TStringField(FDQu.Fields[I]).DisplayWidth > maxFieldDisplaySize then
          TStringField(FDQu.Fields[I]).DisplayWidth := maxFieldDisplaySize;
       End;
     End;
  except
   on e:exception do
    Begin
     raise Exception.Create('errore apertura query[' +qu + ']' + e.message);
    End;
  end;


  Result := FDQu;
end;


class Function TFireDacHelper.OpenQuByName(FDConn : TFDConnection;QuName : String;fk_custom_report : Int64;Params : TStrings = nil;AutoOpen : Boolean = True;LocaleSettings : String = 'it';NumericDisplayFormat : String = '0.00';maxFieldDisplaySize : Integer = 40) : TDataSet;
var
  query: string;
begin
  { TODO : Inserire l'apertura di dataset provenienti da external provider }
  QuName := QuName.toupper;

  query := TFireDacHelper.quReadFirstField(FDConn,
    'Select QUERY from CUSTOM_FR_DYN_DATASET where ((FK_CUSTOM_REPORT = ' +
    fk_custom_report.ToString + ')or(' + fk_custom_report.ToString +
    '=-1))and(upper(NOME) = ''' + QuName + ''')');

  if query = '' then
   raise Exception.Create('custom query named [' + quName + ']');

  result := TFireDacHelper.OpenQu(FDConn,query,Params,AutoOpen,LocaleSettings,NumericDisplayFormat,maxFieldDisplaySize);
end;

class function TFireDacHelper.quReadFirstField(FDConn: TFDConnection;
  Qu: String; raiseExceptionIfNoRecordsFound : Boolean = False): String;
var
  ds: TDataSet;
begin
 Result := '';
 ds := nil;
 try
   ds := OpenQu(FDConn,Qu,nil);
   if ds.RecordCount > 0 then
   Begin
      if ds.FieldCount > 0 then
       Begin
        Result := ds.Fields[0].AsString;
       End
      Else
       Begin
        if raiseExceptionIfNoRecordsFound  then
          raise Exception.Create('Error field not found on query: ' + Qu);
       End;
   End
   Else
   Begin
      if raiseExceptionIfNoRecordsFound  then
        raise Exception.Create('Error no record found for query: ' + Qu);
   End;
 finally
   try
    if ds <> nil then
      ds.Close;
   except

   end;
   try
    if ds <> nil then
      ds.Free;
    ds := nil;
   except

   end;
 end;
end;

class function TFireDacHelper.QuReadFirstRecord(FDConn: TFDConnection;
  Qu: String; Params: TStrings): TrcdArray;
Var
  ds: TDataSet;
  I: Integer;
begin
  ds := OpenQu(FDConn,Qu, Params);
  Try
    SetLength(result, ds.FieldCount);
    for I := 0 to ds.FieldCount - 1 do
    begin
      result[I].Value := ds.Fields[I].AsString;
      result[I].Name := ds.Fields[I].FieldName;
    end;
  Finally
    try
      ds.Close;
    except
    end;
    try
      ds.Free;
    except
    end;
  End;
end;

class function TFireDacHelper.SetImpostazione(FDConn: TFDConnection; costante,
  Value: String): String;
begin
 try
  ExecQu(FDConn,'execute procedure SET_IMPOSTAZIONE(''' + costante + ''', '''+ Value +''', ''STRING'')' );
 finally
 end;
end;

class procedure TFireDacHelper.stdFieldDispW(ds: TDataSet);
var
  I: Integer;
begin
 for I := 0 to ds.FieldCount-1 do
  if ds.Fields[I].DisplayWidth > 30 then
   ds.Fields[I].DisplayWidth := 30;


end;

class function TFireDacHelper.StringToParams(paramsString: String): TStringList;
begin
  result := TStringList.Create;
  result.Delimiter := '&';
  result.DelimitedText := paramsString;
End;

end.
