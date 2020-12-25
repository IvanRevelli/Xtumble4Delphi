unit synaJSON;

interface

uses
  Classes, SysUtils, TypInfo, Rtti, Generics.Collections, System.JSON, DB;

type

  TWriteLog = reference to procedure(msg : String;e: exception = nil);

  JSONPersistAttribute = class(TCustomAttribute)
  private
    FValue: Boolean;
  protected
  public
    constructor Create(const AValue: Boolean = True);
    property Value: Boolean read FValue;
  end;

  JSONBase64Attribute = class(TCustomAttribute)
  end;

  JSONNameAttribute = class(TCustomAttribute)
  private
    FName: string;
  public
    constructor Create(const AName: string);
    property Name: string read FName;
  end;

  TJSONPersistence = class
  private
  protected
    class function GetActualName(const AObj: TRttiNamedObject): string;
    class function GetActualPersist(const AObj: TRttiNamedObject): Boolean;
  public
    class function ArrayToJSONArray(const AArray: TValue): TJSONArray;
    class function ObjectToJSON(const AInstance: TObject): TJSONObject;
    class function RecordToJSON(const ARecord: TValue; const AType: TRttiType): TJSONObject;
    class function SetToJSONArray(const ASet: TValue; const AType: TRttiType): TJSONArray;
    class function JSONArrayToSet(const AJSON: TJSONArray; const AType: TRttiType): TValue;

    class function TValueToJSONValue(const AValue: TValue; const AType: TRttiType;
      const ADestination: TRttiNamedObject = nil): TJSONValue;

    class function JSONValueToTValue(const AJSON: TJSONValue; const AType: TRttiType;
      const ADestination: TRttiNamedObject = nil; const AInstance: Pointer = nil): TValue;

    class procedure JSONToObject(const AInstance: TObject; const AJSON: TJSONObject);
    class function JSONToRecord(const AJSON: TJSONObject; const AType: TRttiType): TValue; overload;
    class function JSONToRecordDefinition(const AJSON: TJSONObject) : String;

    class function JSONArrayToArray(const AJSON: TJSONArray; const AType: TRttiType): TValue;

//    class function JSONToRecord<R: record>(var ARecord: ; const AJSON: TJSONObject): TValue;
//    class procedure JSONToRecord<R: record>(var ARecord: R; const AJSON: TJSONObject);

    class function ToJSON(const AValue: TObject): TJSONValue; overload; inline;
    class function ToJSON<R{: record}>(const ARecord: R): TJSONValue; overload; inline;
    class function ToJSON<R: record>(const AArray: TArray<R>): TJSONArray; overload; inline;

    class procedure FromJSON(const AInstance: TObject; const AJSON: TJSONObject); overload; inline;
    class function FromJSON<R{: record}>(const AJSONString: String): R; overload; inline;
    class function FromJSON<R{: record}>(const AJSON: TJSONObject): R; overload; inline;
    class function FromJSON<R{: record}>(const AJSON: TJSONArray): TArray<R>; overload; inline;
  end;

  TJSONHelper = class
  public
   class function BooleanToTJSON(AValue: Boolean): TJSONValue;

   class function stringToJSONArray(JArrayAsString : String) : TJSONArray;

   class function ExtractSingleValueFromJSONArray(JArray : TJSONArray;index : Integer;fieldname : String) : String; overload;

   class function ExtractSingleValueFromJSONArray(JArrayAsString : String;Index : Int64;FieldName : String) : String; overload;

   // esempio--> Query: purchase_units[0].payments.captures[0].id
   class function ExtractSingleValueByJSONQueryAsString(myJVAL : String;Query : String) : String;

  end;


  TJSON2Dataset = class
  public
    class function BooleanToTJSON(AValue: Boolean): TJSONValue;
    class function DateToJSON(const ADate: TDateTime; AInputIsUTC: Boolean = False): string;
    class function NumericFieldToJSON(const AField: TField): TJSONValue;
    class function DateFieldToJSON(const AField: TField; const AInputIsUTC: Boolean = False): string;


    class function RecordToJSONObject(const ADataSet: TDataSet; const ARootPath: string = ''): TJSONObject;
    class function DataSetToJSONArray(const ADataSet: TDataSet): TJSONArray; overload;
    class function DataSetToJSONArray(const ADataSet: TDataSet; const AAcceptFunc: TFunc<Boolean>): TJSONArray; overload;
    class function DataSetToJSONOBject(const ADataSet: TDataSet): TJSONOBject;

    class function JSONObjectToDataSetRecord(
    const AJSONObject: TJSONObject; var ADataSet: TDataSet;
     shortDateFormat : String;DateSeparator: char;TimeSeparator : char): Integer;
  end;

function DataSetToCSV(const ADataSet: TDataSet; separator : String = ','; qualifier : String = '"') : String;

implementation

uses
  StrUtils, DateUtils, NetEncoding, Math , synaRTTI;

{ TJSONPersistence }


class function TJSON2Dataset.JSONObjectToDataSetRecord(
  const AJSONObject: TJSONObject; var ADataSet: TDataSet;
     shortDateFormat : String;DateSeparator: char;TimeSeparator : char): Integer;
var
  I: Integer;
  Elementi: Int64;
  fld: TField;
  ForS: TFormatSettings;
  fieldName :String;
  strVal: string;
  valore : Double;
  msg : String;
  tipo: string;
  valD : Double;
Begin

  ForS:=TFormatSettings.Create;
  ForS.ShortDateFormat:= shortDateFormat;
  ForS.DateSeparator:=DateSeparator;
  ForS.TimeSeparator:=':';

  if AJSONObject = nil then
    raise Exception.Create('[JSONObjectToDataSetRecord] ERRORE AJSONObject--> null');

  if ADataSet = nil then
    raise Exception.Create('[JSONObjectToDataSetRecord] ERRORE ADataSet--> null');


  Elementi := AJSONObject.count;
  for I := 0 to Elementi - 1 do
  Begin
   fieldName := AJSONObject.Pairs[I].JsonString.Value;
   if fieldName <> '' then
    Begin
      try
       tipo := 'undefined';
       fld := ADataSet.FindField(FieldName);
       if fld <> nil then
        Begin
        strVal := AJSONObject.Pairs[I].JSonValue.AsType<String>;
        if (fld.datatype in [ftFloat,ftExtended,ftSingle ]) then
         Begin
          tipo := 'float';
          TryJsonToFloat(strVal.replace('.',','),valD);
          fld.asExtended := valD;
         End
        Else if (fld.datatype in [ftBCD,ftFMTBcd ]) then
         Begin
          tipo := 'BCD';
          if strVal <> '' then
           try
            TFMTBCDField(fld).asFloat := StrToFloat(strVal);
           except
            TFMTBCDField(fld).asFloat := StrToFloat(strVal.replace('.',','));
           end;
         End
        Else if (fld.datatype in [ftInteger, ftWord]) then
         Begin
          tipo := 'int';

          if strVal <> '' then
           fld.asInteger :=
            StrToInt(strVal.Replace('.',','));
         End
        Else if (fld.datatype in [ftTimeStamp,ftDateTime,ftDate]) then
          Begin
           tipo := 'date';
           if strVal <> '' then
             fld.asDateTime :=
                 StrToDateTime(strVal,ForS);
          End
        Else
         Begin
          tipo := 'str';
          fld.asString := strVal;
         End;

        End;

      except
       on e:exception do
        Begin
         msg := msg+ ',' + FieldName +'('+ tipo + ') -->' + StrVal;
         raise Exception.Create('errore di mappatura del field: '+ fieldName + ' ' + msg);

        End;
      end;
    End;


  End;
End;

class function TJSONPersistence.ArrayToJSONArray(const AArray: TValue): TJSONArray;
var
  LIndex: Integer;
  LElement: TValue;
  LType: TRttiType;
begin
  Result := TJSONArray.Create;
  try
    for LIndex := 0 to AArray.GetArrayLength-1 do
    begin
      LElement := AArray.GetArrayElement(LIndex);
      LType := TRttiContext.Create.GetType(LElement.TypeInfo);
      Result.AddElement( TValueToJSONValue(LElement, LType) );
    end;
  except
    FreeAndNil(Result);
    raise;
  end;
end;

class procedure TJSONPersistence.FromJSON(const AInstance: TObject;
  const AJSON: TJSONObject);
begin
  JSONToObject(AInstance, AJSON);
end;

class function TJSONPersistence.FromJSON<R>(const AJSON: TJSONArray): TArray<R>;
var
  LContext: TRttiContext;
  LType: TRttiType;
begin
  LContext := TRttiContext.Create;
  LType := LContext.GetType(TypeInfo(TArray<R>));
  Result := JSONArrayToArray(AJSON, LType).AsType<TArray<R>>;
end;

class function TJSONPersistence.FromJSON<R>(const AJSONString: String): R;
Var
  JVal : TJSONValue;
begin
  JVal := TJSONObject.ParseJSONValue(AJSONString);
  result := FromJSON<R>(TJSONObject(JVal));

end;

class function TJSONPersistence.FromJSON<R>(const AJSON: TJSONObject): R;
var
  LType: TRttiType;
begin
  LType := TRttiContext.Create.GetType(TypeInfo(R));
  Result := JSONToRecord(AJSON, LType).AsType<R>;
end;

class function TJSONPersistence.GetActualName(const AObj: TRttiNamedObject): string;
var
  LName: string;
begin
  LName := AObj.Name;

  AObj.HasAttribute<JSONNameAttribute>(
    procedure (AJSONName: JSONNameAttribute)
    begin
      LName := AJSONName.Name;
    end
  );

  Result := LName;
end;

class function TJSONPersistence.GetActualPersist(
  const AObj: TRttiNamedObject): Boolean;
var
  LPersist: Boolean;
begin
  LPersist := True;

  AObj.HasAttribute<JSONPersistAttribute>(
    procedure (AJSONPersist: JSONPersistAttribute)
    begin
      LPersist := AJSONPersist.Value;
    end
  );

  Result := LPersist;
end;

class function TJSONPersistence.JSONArrayToArray(const AJSON: TJSONArray;
  const AType: TRttiType): TValue;
var
  LElement: TJSONValue;
  LElementType: TRttiType;
  LArray: TArray<TValue>;
  LValue: TValue;
begin
  if AType is TRttiArrayType then
    LElementType := TRttiArrayType(AType).ElementType
  else if AType is TRttiDynamicArrayType then
    LElementType := TRttiDynamicArrayType(AType).ElementType
  else
    raise Exception.CreateFmt('Type %s is not an array type', [AType.Name]);

  LArray := [];
  for LElement in AJSON do
  begin
    LValue := JSONValueToTValue(LElement, LElementType);
    LArray := LArray + [LValue];
  end;

  Result := TValue.FromArray(AType.Handle, LArray);
end;

class function TJSONPersistence.JSONArrayToSet(const AJSON: TJSONArray;
  const AType: TRttiType): TValue;
var
  LSetString: string;
  LElement: TJSONValue;
begin
  Result := 0;
  if not AType.IsSet then
    raise Exception.CreateFmt('Type %s is not a Set', [AType.Name]);

  LSetString := '';
  for LElement in AJSON do
  begin
    if LElement is TJSONString then
    begin
      if not LSetString.IsEmpty then
        LSetString := LSetString + ',';
      LSetString := LSetString + TJSONString(LElement).Value;
    end;
  end;
  TValue.Make(StringToSet(AType.Handle, LSetString), AType.Handle, Result);
end;

class procedure TJSONPersistence.JSONToObject(const AInstance: TObject;
  const AJSON: TJSONObject);
var
  LContext: TRttiContext;
  LType: TRttiType;
  LProperties: TArray<TRttiProperty>;
  LProperty: TRttiProperty;
  LJSONValue: TJSONValue;
  LVisibilityFilter: set of TMemberVisibility;
  LJSONName: string;
  LValue: TValue;
begin
  if not Assigned(AInstance) then
    Exit;
  if not Assigned(AJSON) then
    Exit;

  LContext := TRttiContext.Create;
  LType := LContext.GetType(AInstance.ClassType);
  LVisibilityFilter := [TMemberVisibility.mvPublic, TMemberVisibility.mvPublished];

  LProperties := LType.GetProperties;
  for LProperty in LProperties do
  begin
    if not (LProperty.Visibility in LVisibilityFilter) then
      Continue;

    if not GetActualPersist(LProperty) then
      Continue;

    LJSONName := GetActualName(LProperty);
    if LJSONName.IsEmpty then
      Continue;

    if not LProperty.IsWritable then
      Continue;

    LValue := TValue.Empty;
    if AJSON.TryGetValue<TJSONValue>(LJSONName, LJSONValue) then
      LValue := JSONValueToTValue(LJSONValue, LProperty.PropertyType, LProperty, AInstance);

    LProperty.SetValue(AInstance, LValue);
  end;
end;

class function TJSONPersistence.JSONToRecord(const AJSON: TJSONObject;
  const AType: TRttiType): TValue;
var
  LFields: TArray<TRttiField>;
  LField: TRttiField;
  LVisibilityFilter: set of TMemberVisibility;
  LJSONName: string;
  LJSONValue: TJSONValue;
  LValue: TValue;
begin
  TValue.Make(nil, AType.Handle, Result);
  if not Assigned(AJSON) then
    Exit;

  LVisibilityFilter := [TMemberVisibility.mvPublic, TMemberVisibility.mvPublished];

  LFields := AType.GetFields;
  for LField in LFields  do
  begin
    if not (LField.Visibility in LVisibilityFilter) then
      Continue;

    if not GetActualPersist(LField) then
      Continue;

    LJSONName := GetActualName(LField);
    if LJSONName.IsEmpty then
      Continue;

    LValue := TValue.Empty;
    if AJSON.TryGetValue<TJSONValue>(LJSONName, LJSONValue) then
      LValue := JSONValueToTValue(LJSONValue, LField.FieldType, LField);
    LField.SetValue(Result.GetReferenceToRawData, LValue);
  end;
end;

class function TJSONPersistence.JSONToRecordDefinition(
  const AJSON: TJSONObject): String;
begin

end;

class function TJSONPersistence.JSONValueToTValue(const AJSON: TJSONValue;
  const AType: TRttiType; const ADestination: TRttiNamedObject; const AInstance: Pointer): TValue;
var
  LInstance: TObject;
  LChar: Char;
  LLenght, LArrayLenght, I: Integer;
begin
  TValue.Make(nil, AType.Handle, Result);
  if not Assigned(AJSON) then
    Exit;

  // string support
  if AType.TypeKind in [tkString, tkLString, tkWString, tkUString, tkChar, tkWChar] then
  begin
    if AJSON is TJSONString then
      Result := TJSONString(AJSON).Value;
  end
  // Date and time support
  else if (AType.Handle = TypeInfo(TDateTime)) or (AType.Handle = TypeInfo(TDate)) or (AType.Handle = TypeInfo(TTime)) then
  begin
    if AJSON is TJSONString then
      Result := ISO8601ToDate(TJSONString(AJSON).Value);
  end
  // Boolean and enum support
  else if AType.TypeKind in [tkEnumeration] then
  begin
    if AType.Handle = TypeInfo(Boolean) then
    begin
      if AJSON is TJSONBool then
        Result := TJSONBool(AJSON).AsBoolean;
    end
    else if AType is TRttiEnumerationType then
    begin
      if AJSON is TJSONString then
        Result := TValue.FromOrdinal(AType.Handle, GetEnumValue(AType.Handle, TJSONString(AJSON).Value));
    end;
  end
  // Integer support
  else if AType.TypeKind in [tkInteger] then
  begin
    if AJSON is TJSONNumber then
      Result := TJSONNumber(AJSON).AsInt;
  end
  // Int64 support
  else if AType.TypeKind in [tkInt64] then
  begin
    if AJSON is TJSONNumber then
      Result := TJSONNumber(AJSON).AsInt64;
  end
  // Float support
  else if AType.TypeKind in [tkFloat] then
  begin
    if AJSON is TJSONNumber then
      Result := TJSONNumber(AJSON).AsDouble;
  end
  // Set
  else if AType.IsSet then
  begin
    if AJSON is TJSONArray then
      Result := JSONArrayToSet(TJSONArray(AJSON), AType)
  end
  // Record
  else if AType.IsRecord then
  begin
    if AJSON is TJSONObject then
      Result := JSONToRecord(TJSONObject(AJSON), AType)
  end
  // Array
  else if AType.TypeKind in [tkArray] then
  begin
    if (AType.Handle = TypeInfo(TBytes)) and ADestination.HasAttribute<JSONBase64Attribute> then
    begin
      if AJSON is TJSONString then
        Result := TValue.From<TBytes>(TNetEncoding.Base64.DecodeStringToBytes
          (TJSONString(AJSON).Value));
    end

    // IVAN 2019 GESTISCO COME INPUT ANCHE GLI ARRAY OF CHAR E LI CONVERTO IN STRING
    // CONTROLLARE DA MANI PIU' ESPERTE SE QUESTO COMPORTA PROBLEMI

    else if TRttiArrayType(AType).ElementType.TypeKind in [TTypeKind.tkChar, TTypeKind.tkWChar] then
    begin
      //myStr := TJSONString(AJSON).Value;
      //mystr := '';
      //"TValue.Make" -> COSTRUISCE UN VALUE DEL TIPO SPECIFICATO
      //TValue.Make(@myStr, AType.Handle, Result);
      //TValue.Make(nil, AType.Handle, Result);
      LChar := ' ';
      LLenght := Length(TJSONString(AJSON).Value);
      LArrayLenght := Result.GetArrayLength;
      //MILLE SMANACCIAMENTI PER ACCORGERSI CHE
      //IL METODO "SetArrayElement" E' ESTREMAMENTE' LENTO
      //AL CHE HO ELIMINATO IL CICLO CHE INIZIALIZZA L'ARRAY IN USCITA
      //SOSTITUENDOLO CON CIO' CHE SEGUE
      if LLenght >= LArrayLenght then
      begin
        for I := 0 to LLenght-1 do
        begin
          if LArrayLenght > I then
            //LChar := TJSONString(AJSON).Value.Chars[I];
            Result.SetArrayElement(I, TJSONString(AJSON).Value.Chars[I]);
        end;
      end
      else
      begin
        for I := 0 to LArrayLenght-1 do
        begin
          if LLenght > I then
            //LChar := TJSONString(AJSON).Value.Chars[I];
            Result.SetArrayElement(I, TJSONString(AJSON).Value.Chars[I])
          else
            Result.SetArrayElement(I, LChar);
        end;
      end;
    end
    else
      Result := JSONArrayToArray(AJSON as TJSONArray, AType);
  end
  // IVAN 2019 SUDDIVISA LA GESTIONE TRA DYNARRAY E ARRAY
  else if AType.TypeKind in [tkDynArray] then
  begin
    if (AType.Handle = TypeInfo(TBytes)) and ADestination.HasAttribute<JSONBase64Attribute> then
    begin
      if AJSON is TJSONString then
        Result := TValue.From<TBytes>(TNetEncoding.Base64.DecodeStringToBytes(TJSONString(AJSON).Value));
    end
    else
      Result := JSONArrayToArray(AJSON as TJSONArray, AType);
  end
  // Objects
  else if AType.IsInstance then
  begin
    LInstance := nil;
    if ADestination is TRttiProperty then
      LInstance := TRttiProperty(ADestination).GetValue(AInstance).AsObject
    else if ADestination is TRttiField then
      LInstance := TRttiField(ADestination).GetValue(AInstance).AsObject;

    JSONToObject(LInstance, AJSON as TJSONObject);
    Result := LInstance;
  end;
end;

class function TJSONPersistence.RecordToJSON(const ARecord: TValue;
  const AType: TRttiType): TJSONObject;
var
  LFields: TArray<TRttiField>;
  LField: TRttiField;
  LVisibilityFilter: set of TMemberVisibility;
  LJSONName: string;
  LJSONValue: TJSONValue;
begin
  Result := nil;
  LVisibilityFilter := [TMemberVisibility.mvPublic, TMemberVisibility.mvPublished];

  LFields := AType.GetFields;
  for LField in LFields  do
  begin
    if not (LField.Visibility in LVisibilityFilter) then
      Continue;

    if not GetActualPersist(LField) then
      Continue;

    LJSONName := GetActualName(LField);
    if LJSONName.IsEmpty then
      Continue;

    LJSONValue := TValueToJSONValue(LField.GetValue(ARecord.GetReferenceToRawData), LField.FieldType, LField);
    if not Assigned(LJSONValue) then
      Continue;

    if not Assigned(Result) then
      Result := TJSONObject.Create;
    Result.AddPair(LJSONName, LJSONValue);
  end;
end;

class function TJSONPersistence.SetToJSONArray(const ASet: TValue;
  const AType: TRttiType): TJSONArray;
var
  LSetString: string;
  LValue: TValue;
begin
  Result := nil;
  if not AType.IsSet then
    raise Exception.CreateFmt('Type %s is not a Set', [AType.Name]);
  LSetString := SetToString(AType.Handle, ASet.GetReferenceToRawData);
  if not LSetString.IsEmpty then
  begin
    LValue := TValue.From<TArray<string>>(LSetString.Split([',']));
    Result := ArrayToJSONArray(LValue);
  end;
end;

class function TJSONPersistence.ObjectToJSON(const AInstance: TObject): TJSONObject;
var
  LContext: TRttiContext;
  LType: TRttiType;
  LProperties: TArray<TRttiProperty>;
  LProperty: TRttiProperty;
  LJSONValue: TJSONValue;
  LVisibilityFilter: set of TMemberVisibility;
  LJSONName: string;
begin
  Result := nil;
  if not Assigned(AInstance) then
    Exit;

  LContext := TRttiContext.Create;
  LType := LContext.GetType(AInstance.ClassType);
  LVisibilityFilter := [TMemberVisibility.mvPublic, TMemberVisibility.mvPublished];

  LProperties := LType.GetProperties;
  for LProperty in LProperties do
  begin
    if not (LProperty.Visibility in LVisibilityFilter) then
      Continue;

    if not GetActualPersist(LProperty) then
      Continue;

    LJSONName := GetActualName(LProperty);
    if LJSONName.IsEmpty then
      Continue;

    if not LProperty.IsReadable then
      Continue;

    LJSONValue := TValueToJSONValue(LProperty.GetValue(AInstance), LProperty.PropertyType, LProperty);
    if not Assigned(LJSONValue) then
      Continue;

    if not Assigned(Result) then
      Result := TJSONObject.Create;
    Result.AddPair(LJSONName, LJSONValue);
  end;
end;

class function TJSONPersistence.ToJSON<R>(const ARecord: R): TJSONValue;
var
  LValue: TValue;
begin
  LValue := TValue.From<R>(ARecord);
  Result := RecordToJSON(LValue, TRttiContext.Create.GetType(LValue.TypeInfo));
end;

class function TJSONPersistence.ToJSON(const AValue: TObject): TJSONValue;
begin
  Result := ObjectToJSON(AValue);
end;

class function TJSONPersistence.ToJSON<R>(const AArray: TArray<R>): TJSONArray;
begin
  Result := ArrayToJSONArray(TValue.From<TArray<R>>(AArray));
end;

class function TJSONPersistence.TValueToJSONValue(const AValue: TValue; const AType: TRttiType;
  const ADestination: TRttiNamedObject): TJSONValue;
var
  LValue: TValue;
  LStr: string;
  I, LArrayLength: Integer;
begin
  Result := nil;
  if AValue.IsEmpty then
    Exit;

  // string support
  if AType.TypeKind in [tkString, tkLString, tkWString, tkUString, tkChar, tkWChar] then
  begin
    if not AValue.AsString.IsEmpty then
      Result := TJSONString.Create(AValue.AsString)
  end
  // Date and time support
  else if AType.Handle = TypeInfo(TDateTime)then
  begin
    if not IsNullDate(AValue.AsType<TDateTime>) then
      Result := TJSONString.Create(DateToISO8601(AValue.AsType<TDateTime>))
  end
  else if AType.Handle = TypeInfo(TDate) then
  begin
    if not IsNullDate(AValue.AsType<TDate>) then
      Result := TJSONString.Create(DateToISO8601(AValue.AsType<TDate>).Substring(0, 10))
  end
  else if AType.Handle = TypeInfo(TTime) then
  begin
    if AValue.AsType<TTime> <> 0 then
      Result := TJSONString.Create(DateToISO8601(AValue.AsType<TTime>))
  end
  // Boolean and enum support
  else if AType.TypeKind in [tkEnumeration] then
  begin
    if AType.Handle = TypeInfo(Boolean) then
      Result := TJSONBool.Create(AValue.AsBoolean)
    else if AType is TRttiEnumerationType then
      Result := TJSONString.Create(
        GetEnumName(AType.Handle, AValue.AsOrdinal)
        );
  end
  // Integer support
  else if AType.TypeKind in [tkInteger] then
  begin
    if AValue.AsInteger <> 0 then
      Result := TJSONNumber.Create(AValue.AsInteger)
  end
  // Int64 support
  else if AType.TypeKind in [tkInt64] then
  begin
    if AValue.AsInt64 <> 0 then
      Result := TJSONNumber.Create(AValue.AsInt64)
  end
  // Float support
  else if AType.TypeKind in [tkFloat] then
  begin
    if not SameValue(AValue.AsExtended, 0) then
      Result := TJSONNumber.Create(AValue.AsExtended)
  end
  // TValue unboxing
  else if AType.Handle = TypeInfo(TValue) then
  begin
    LValue := AValue.AsType<TValue>;
    Result := TValueToJSONValue(LValue, TRttiContext.Create.GetType(LValue.TypeInfo));
  end
  // Set
  else if AType.IsSet then
    Result := SetToJSONArray(AValue, AType)
  // Record
  else if AType.IsRecord then
    Result := RecordToJSON(AValue, AType)
  // Array
  else if AValue.IsArray then
  begin
    // IVAN 2019 VALORIZZO I DATI SOLO SE L'ARRAY SORGENTE HA ALMENO UN ELEMENTO
    if AValue.GetArrayLength > 0 then
    begin
      if (AType.Handle = TypeInfo(TBytes)) and ADestination.HasAttribute<JSONBase64Attribute> then
        Result := TJSONString.Create(TNetEncoding.Base64.EncodeBytesToString(AValue.AsType<TBytes>))
      //IVAN 2019 GESTISCO COME INPUT ANCHE GLI ARRAY OF CHAR E LI CONVERTO IN STRING
      //CONTROLLARE DA MANI PIU' ESPERTE SE QUESTO COMPORTA PROBLEMI
      else if AValue.GetArrayElement(0).TypeInfo.Kind in [TTypeKind.tkChar, TTypeKind.tkWChar] then
      begin
        LStr := ''; // blank string
        LArrayLength := AValue.GetArrayLength;
        // Davide gen-2020: Non si capisce perchè sia ciclato al contrario, lo ciclo per dritto
        //for I := LArrayLength - 1 downto 0 do
        //  LStr := AValue.GetArrayElement(I).AsString + LStr;
        for I := 0 to LArrayLength - 1 do
          LStr := LStr + AValue.GetArrayElement(I).AsString;
        Result := TJSONString.Create(LStr.Trim);
      end
      else
        Result := ArrayToJSONArray(AValue);
    end;
  end
  // Objects
  else if AValue.IsObjectInstance then
    Result := ToJSON(AValue.AsObject);
end;

{ JSONPersistAttribute }

constructor JSONPersistAttribute.Create(const AValue: Boolean);
begin
  inherited Create;
  FValue := AValue;
end;

{ JSONNameAttribute }

constructor JSONNameAttribute.Create(const AName: string);
begin
  inherited Create;
  FName := AName;
end;


class function TJSON2Dataset.RecordToJSONObject(const ADataSet: TDataSet;
  const ARootPath: string): TJSONObject;
var
  LField: TField;
  LPairName: string;
begin
  if not Assigned(ADataSet) then
    raise Exception.Create('DataSet not assigned');
  if not ADataSet.Active then
    raise Exception.Create('DataSet is not active');
  if ADataSet.IsEmpty then
    raise Exception.Create('DataSet is empty');




  Result := TJSONObject.Create;
  try
    for LField in ADataSet.Fields do
    begin
      if (ARootPath = '') or StartsStr(ARootPath + '.', LField.FieldName) then
      begin
        LPairName := LField.FieldName;
        if ARootPath <> '' then
          LPairName := LeftStr(LPairName, Length(ARootPath) + 1);

        if ContainsStr(LPairName, '.') then
          Continue;

        case LField.DataType of
  //        ftUnknown: ;

          ftString: Result.AddPair(LPairName, LField.AsString);
          ftSmallint: Result.AddPair(LPairName, NumericFieldToJSON(LField));
          ftInteger: Result.AddPair(LPairName, NumericFieldToJSON(LField));
          ftWord: Result.AddPair(LPairName, NumericFieldToJSON(LField));
          ftBoolean: Result.AddPair(LPairName, TJSONHelper.BooleanToTJSON(LField.AsBoolean));
          ftFloat: Result.AddPair(LPairName, NumericFieldToJSON(LField));
          ftCurrency: Result.AddPair(LPairName, NumericFieldToJSON(LField) (* TJSONNumber.Create(LField.AsCurrency) *));
          ftBCD: Result.AddPair(LPairName, NumericFieldToJSON(LField));
          ftDate: Result.AddPair(LPairName, DateFieldToJSON(LField));
          ftTime: Result.AddPair(LPairName, DateFieldToJSON(LField));
          ftDateTime: Result.AddPair(LPairName, DateFieldToJSON(LField));
  //        ftBytes: ;
  //        ftVarBytes: ;
          ftAutoInc: Result.AddPair(LPairName, NumericFieldToJSON(LField));
  //        ftBlob: ;
          ftMemo: Result.AddPair(LPairName, LField.AsString);
  //        ftGraphic: ;
  //        ftFmtMemo: ;
  //        ftParadoxOle: ;
  //        ftDBaseOle: ;
  //        ftTypedBinary: ;
  //        ftCursor: ;
          ftFixedChar: Result.AddPair(LPairName, LField.AsString);
          ftWideString: Result.AddPair(LPairName, LField.AsWideString);
          ftLargeint: Result.AddPair(LPairName, NumericFieldToJSON(LField));
  //        ftADT: ;
  //        ftArray: ;
  //        ftReference: ;
  //        ftDataSet: ;
  //        ftOraBlob: ;
  //        ftOraClob: ;
          ftVariant: Result.AddPair(LPairName, LField.AsString);
  //        ftInterface: ;
  //        ftIDispatch: ;
          ftGuid: Result.AddPair(LPairName, LField.AsString);
          ftTimeStamp: Result.AddPair(LPairName, DateFieldToJSON(LField));
          ftFMTBcd: Result.AddPair(LPairName, NumericFieldToJSON(LField));
          ftFixedWideChar: Result.AddPair(LPairName, LField.AsString);
          ftWideMemo: Result.AddPair(LPairName, LField.AsString);
  //        ftOraTimeStamp: ;
  //        ftOraInterval: ;
          ftLongWord: Result.AddPair(LPairName, NumericFieldToJSON(LField));
          ftShortint: Result.AddPair(LPairName, NumericFieldToJSON(LField));
          ftByte: Result.AddPair(LPairName, NumericFieldToJSON(LField));
          ftExtended: Result.AddPair(LPairName, NumericFieldToJSON(LField));
  //        ftConnection: ;
  //        ftParams: ;
  //        ftStream: ;
  //        ftTimeStampOffset: ;
  //        ftObject: ;
          ftSingle: Result.AddPair(LPairName, NumericFieldToJSON(LField));
        end;
      end;
    end;
  except
    Result.Free;
    raise;
  end;
end;

class function TJSON2Dataset.DataSetToJSONArray(const ADataSet: TDataSet): TJSONArray;
begin
  Result := DataSetToJSONArray(ADataSet, nil);
end;



class function TJSON2Dataset.DataSetToJSONOBject(const ADataSet: TDataSet): TJSONOBject;
begin
  Result := TJSONObject.create;
  Result.AddPair('dataset', DataSetToJSONArray(ADataSet, nil));
end;

class function TJSON2Dataset.BooleanToTJSON(AValue: Boolean): TJSONValue;
begin
  result := TJSONHelper.BooleanToTJSON(AValue);
end;

class function TJSON2Dataset.DateFieldToJSON(const AField: TField;
  const AInputIsUTC: Boolean): string;
var
  LDisplayFormat: string;
begin
  LDisplayFormat := '';
  if AField is TSQLTimeStampField then
    LDisplayFormat := TSQLTimeStampField(AField).DisplayFormat
  else if AField is TDateTimeField then // TDateField and TTimeField are subclasses of TDateTimeField
    LDisplayFormat := TDateTimeField(AField).DisplayFormat;

  if LDisplayFormat <> '' then
    Result := AField.DisplayText
  else
    Result := DateToJSON(AField.AsDateTime, AInputIsUTC);
end;


class function TJSON2Dataset.DateToJSON(const ADate: TDateTime;
  AInputIsUTC: Boolean): string;
begin
  Result := '';
  if ADate <> 0 then
    Result := DateToISO8601(ADate, AInputIsUTC);
end;




class function TJSON2Dataset.NumericFieldToJSON(
  const AField: TField): TJSONValue;
var
  LDisplayFormat: string;
begin
  LDisplayFormat := '';
  if AField is TNumericField then
    LDisplayFormat := TNumericField(AField).DisplayFormat;

  if LDisplayFormat <> '' then
   Begin

    // And use it in the thread safe form of CurrToStrF
   //      CurrToStrF(AField.AsCurrency, ffCurrency, 2, formatSettings);
    //    Result := TJSONString.Create(AField.DisplayText)


     formatSettings.currencyString := '';


     Result := TJSONString.Create(CurrToStrF(AField.AsCurrency, ffCurrency, 2, formatSettings))
   End
  else
  begin
    if AField.DataType in [ftSmallint, ftInteger, ftWord, ftLongWord, ftShortint, ftByte, ftAutoInc]
    then
      Result := TJSONNumber.Create(AField.AsInteger)
    else if AField.DataType in [ftLargeInt] then
      Result := TJSONNumber.Create(AField.AsLargeInt)
    else if AField.DataType in [ftSingle, ftExtended, ftFloat, ftBCD, ftFMTBcd] then
      Result := TJSONNumber.Create(AField.AsFloat)
    else if AField.DataType in [ftCurrency] then
      Result := TJSONNumber.Create(AField.AsCurrency)
    else
      Result := TJSONNumber.Create(AField.AsFloat)
  end;
end;


class function TJSON2Dataset.DataSetToJSONArray(const ADataSet: TDataSet;
  const AAcceptFunc: TFunc<Boolean>): TJSONArray;
var
  LBookmark: TBookmark;
begin
  Result := TJSONArray.Create;
  if not Assigned(ADataSet) then
    Exit;
  try
    if not ADataSet.Active then
      ADataSet.Open;

    ADataSet.DisableControls;
    try
      LBookmark := ADataSet.Bookmark;
      try
        ADataSet.First;
        while not ADataSet.Eof do
        try
          if (not Assigned(AAcceptFunc)) or (AAcceptFunc()) then
            Result.AddElement(RecordToJSONObject(ADataSet));
        finally
          ADataSet.Next;
        end;
      finally
        ADataSet.GotoBookmark(LBookmark);
      end;
    finally
      ADataSet.EnableControls;
    end;
  except
    Result.Free;
    raise;
  end;
end;

class function TJSONHelper.BooleanToTJSON(AValue: Boolean): TJSONValue;
begin
  if AValue then
    Result := TJSONTrue.Create
  else
    Result := TJSONFalse.Create;
end;


class function TJSONHelper.ExtractSingleValueFromJSONArray(JArray: TJSONArray;
  index: Integer; fieldname: String): String;
begin
 result := TJSONObject(JArray[index]).GetValue(FieldName).asType<string>;
end;

class function TJSONHelper.ExtractSingleValueByJSONQueryAsString(myJVAL,
  Query: String): String;
var
  JsonValue: TJSONValue;
begin
    //st := '{"data":{"results":[{"Branch":"ACCT590003"}]}}';
   JsonValue := TJSonObject.ParseJSONValue(myJVAL);
   //   Branch := JsonValue.GetValue<string>('data.results[0].Branch');
   Result := JsonValue.GetValue<string>(query);
   JsonValue.Free;

end;

class function TJSONHelper.ExtractSingleValueFromJSONArray(
  JArrayAsString: String; Index: Int64; FieldName: String): String;
var
  myArray : TJSONArray;

begin
  try
    myArray := stringToJSONArray(JArrayAsString);
    result := ExtractSingleValueFromJSONArray(myArray,index,FieldName);
  finally
   myArray.Free;
  end;
end;


class function TJSONHelper.stringToJSONArray(
  JArrayAsString: String): TJSONArray;
var
  JSONValue: TJSONValue;
begin
 result := nil;
 JSONValue := TJSONObject.ParseJSONValue(JArrayAsString);
 if JSONValue is TJSONArray then
      result := TJSONArray(JSONValue)
 else
   raise Exception.Create('Argument is not a valid json array');
end;


function DataSetToCSV(const ADataSet: TDataSet; separator : String = ','; qualifier : String = '"') : String;
var
  i: Integer;
  OutLine: string;
  sTemp: string;
  TS : TStringList;
  FieldCount: Integer;

begin
  try
   Result := '';
   ADataSet.first;
   OutLine := '';

//   DisableControls;
   FieldCount := ADataSet.FieldCount;
   TS := TStringList.Create;

   TS.Text := '';
   for i := 0 to FieldCount - 1 do
      begin
        sTemp := ADataSet.Fields[i].FieldName;
        if i < FieldCount-1 then
          OutLine := OutLine + sTemp + separator
        Else
          OutLine := OutLine + sTemp;
      end;
   TS.Add(OutLine.toLower);

    while not ADataSet.Eof do
    begin
      // You'll need to add your special handling here where OutLine is built
      OutLine := '';

      for i := 0 to FieldCount - 1 do
      begin
        sTemp := qualifier + ADataset.Fields[i].AsString.Replace(qualifier,qualifier + qualifier).replace('&&','&') + qualifier;
        if i < FieldCount-1 then
          OutLine := OutLine + sTemp + separator
        Else
          OutLine := OutLine + sTemp;
      end;
      TS.Add(OutLine);
      ADataSet.Next;
    end;
//    Result := TStringStream.Create('',TEncoding.UTF8);
    Result := TS.Text;
//    TS.SaveToStream(Result,TEncoding.UTF8);
//    Result.Position := 0;
  finally
//   EnableControls;
   FreeAndNil(TS);
  end;
end;


end.
