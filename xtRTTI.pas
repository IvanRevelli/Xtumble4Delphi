unit xtRTTI;

interface

uses
  Generics.Collections, Generics.Defaults, TypInfo, Rtti, SysUtils, Classes,
  DB ;


type
 TDateDefaults = class
  public
    const
      Null = 0;
      Min = 1;
      Max = 401769;
  end;

const
 NULL_DATE: TDateTime = TDateDefaults.Null;      // corrisponde a '30/12/1899' impostata così storicamente, potrebbe essere

type

  TRTTIVarFunc<T> = reference to function (var X: T): Boolean;

  TRTTIArray = class
  public
    class procedure Swap<T>(var AValue1, AValue2: T);
    class function Reverse<T>(AValue: TArray<T>): TArray<T>;
    class function Filter<T>(const ASource: TArray<T>; const AFilterFunc: TRTTIVarFunc<T>): TArray<T>;
    class procedure Exclude<T: class>(var ASource: TArray<T>; const AValue: T);
  end;


  TMemberVisibility = TypInfo.TMemberVisibility;
  TMemberVisibilitySet = set of TMemberVisibility;
// Imposta la proprietà APropertyName di tutti i componenti che hanno l'owner
// indicato al valore AProperyValue.
procedure SetPropertyOnAllComponents(const AOwner: TComponent; const APropertyName: string;
                                     const APropertyValue: TValue;
                                     const APropertyVisibility: TMemberVisibilitySet = [mvPublic, mvPublished]);

type
  /// <summary>
  ///  Operazioni sui campi dei record.
  /// </summary>
  TRecordHelper<T{: record}> = record
  strict private
    /// <summary>
    ///  Restituisce array con tutti i campi visibili, cioè ignora i campi il cui nome inizia per _.
    /// </summary>
    class function GetVisibleFields(const AType: TRttiType): TArray<TRttiField>; static;
  public
    type
      TWriteRecordFieldProc = reference to procedure(var ARecord: T; const AField: TRttiField; var AStop: Boolean);
    /// <summary>
    ///  Enumera tutti i campi. NB ignora i campi il cui nome inizia per _.
    /// </summary>
    class procedure ForEachField(var ARecord: T; const AProc: TWriteRecordFieldProc);  overload; static;

    type
      TReadRecordFieldProc = reference to procedure(const ARecord: T; const AField: TRttiField; var AStop: Boolean);
    /// <summary>
    ///  Enumera tutti i campi. NB ignora i campi il cui nome inizia per _.
    /// </summary>
    class procedure ForEachField(const ARecord: T; const AProc: TReadRecordFieldProc); overload; static;

    class function FieldNames: TArray<string>; static;

    /// <summary>
    ///  Imposta tutti i campi a TValue.Empty.
    /// </summary>
    class procedure Clear(var ARecord: T); static;

    /// <summary>
    ///  Restituisce un record con tutti i campi impostati a TValue.Empty.
    /// </summary>
    class function Empty: T; static;

    /// <summary>
    ///  True se tutti i campi sono TValue.Empty o TValue.Make(nil).
    /// </summary>
    class function IsEmpty(const ARecord: T): Boolean; static;

    /// <summary>
    ///  True se tutti i campi sono non vuoti (cioè con un valore diverso da TValue.Make(nil)).
    /// </summary>
    class function IsComplete(const ARecord: T): Boolean; static;

    /// <summary>
    ///  Crea un record con tutti i campi valorizzati in base ai campi omonimi di AFields,
    ///  che devono esistere tutti.
    /// </summary>
    class function CreateFromFields(const AFields: TFields): T; overload; static;
    /// <summary>
    ///  Crea un record con tutti i campi indicati valorizzati in base ai campi omonimi di AFields,
    ///  che devono esistere tutti.
    /// </summary>
    class function CreateFromFields(const AFields: TFields; const AFieldNames: TArray<string>): T; overload; static;
    /// <summary>
    ///  Valorizza tutti i campi in base ai campi omonimi di AFields,
    ///  che devono esistere tutti.
    /// </summary>
    class procedure FromFields(var ARecord: T; const AFields: TFields); overload; static;
    /// <summary>
    ///  Valorizza tutti i campi in base ai campi di AFields specificati,
    ///  che devono essere indicati nello stesso numero e ordine dei campi di ARecord.
    /// </summary>
    class procedure FromFields(var ARecord: T; const AFields: TFields; const AFieldNames: TArray<string>); overload; static;
    /// <summary>
    ///  Copia i valori del record sui campi omonimi di AFields,
    ///  che devono esistere tutti.
    /// </summary>
    class procedure ToFields(const ARecord: T; const AFields: TFields); overload; static;
    /// <summary>
    ///  Copia i valori del record sui campi specificati di AFields,
    ///  che devono essere indicati nello stesso numero e ordine dei campi di ARecord.
    /// </summary>
    class procedure ToFields(const ARecord: T; const AFields: TFields; const AFieldNames: TArray<string>); overload; static;

    class function Compare(const AFirst, ASecond: T): Integer; static;

    /// <summary>
    ///  True se tutti i campi hanno lo stesso valore in AFirst e ASecond.
    /// </summary>
    class function Equal(const AFirst, ASecond: T): Boolean; static;

    /// <summary>
    ///  Restituisce i valori di tutti i campi del record (in ordine)
    ///  come variant array (utile per TDataSet.Locate).
    /// </summary>
    class function GetValuesAsVariantArray(const ARecord: T): Variant; overload; static;
    /// <summary>
    ///  Restituisce i valori dei campi del record indicati (in ordine)
    ///  come variant array (utile per TDataSet.Locate).
    /// </summary>
    class function GetValuesAsVariantArray(const ARecord: T; const AFieldNames: TArray<string>): Variant; overload; static;

    /// <summary>
    ///  Copia i valori di tutti i campi di ADestination dai campi omonimi di
    ///  ASource, che devono esistere tutti. Si usa quando i campi di
    ///  ASource sono un sottoinsieme di quelli di ADestination.
    ///  Se AStrict è False, i campi di ADestination non trovati in ASource
    ///  vengono ignorati (non consigliato) altrimenti viene sollevata un'eccezione.
    /// </summary>
    class procedure CopyFrom<TSource: record>(const ASource: TSource; var ADestination: T;
      const AStrict: Boolean = True); static;

    /// <summary>
    ///  Copia i valori di tutti i campi di ASource nei campi omonimi di
    ///  ADestination, che devono esistere tutti. Si usa quando i campi di
    ///  ASource sono un sottoinsieme di quelli di ADestination.
    ///  Se AStrict è False, i campi di ASource non trovati in ADestination
    ///  vengono ignorati (non consigliato) altrimenti viene sollevata un'eccezione.
    /// </summary>
    class procedure CopyTo<TDestination: record>(const ASource: T; var ADestination: TDestination;
      const AStrict: Boolean = True); static;
  end;

  /// <summary>
  ///  Comparer da passare obbligatoriamente al costruttore di un
  ///  TDictionary che abbia un record come chiave, perché altrimenti
  ///  i duplicati non vengono gestiti.

  ///
  ///  Da utilizzare anche per ordinare gli array e liste

  /// </summary>
  TRecordHelperComparer<T: record> = class(TCustomComparer<T>)
  public
    function Equals(const Left, Right: T): Boolean; override;
    function GetHashCode(const Value: T): Integer; override;
  end;

  TRecordHelperAscendingComparer<T: record> = class(TRecordHelperComparer<T>)
  strict private
    class var
      FOrdinal: TRecordHelperAscendingComparer<T>;
  public
    class destructor Destroy;
    class function Ordinal: TRecordHelperAscendingComparer<T>;
    function Compare(const Left, Right: T): Integer; override;
  end;

  TRecordHelperDescendingComparer<T: record> = class(TRecordHelperComparer<T>)
  strict private
    class var
      FOrdinal: TRecordHelperDescendingComparer<T>;
  public
    class destructor Destroy;
    class function Ordinal: TRecordHelperDescendingComparer<T>;
    function Compare(const Left, Right: T): Integer; override;
  end;

  TValueHelper = record helper for TValue
  private
    function GetRttiType: TRttiType;
  public
    function Compare(const AOtherValue: TValue): Integer;
    function Equals(const AOtherValue: TValue): Boolean;
    function IsFloat: Boolean;
    function IsNumeric: Boolean;
    function IsPointer: Boolean;
    function IsString: Boolean;
    function IsBoolean: Boolean;
    function IsByte: Boolean;
    function IsCardinal: Boolean;
    function IsCurrency: Boolean;
    function IsDate: Boolean;
    function IsDateTime: Boolean;
    function IsDouble: Boolean;
    function IsInteger: Boolean;
    function IsInt64: Boolean;
    function IsShortInt: Boolean;
    function IsSingle: Boolean;
    function IsSmallInt: Boolean;
    function IsTime: Boolean;
    function IsUInt64: Boolean;
    function IsVariant: Boolean;
    function IsWord: Boolean;
    function IsLongWord: Boolean;
  	function IsGuid: Boolean;
    function AsDouble: Double;
    function AsFloat: Extended;
    function AsSingle: Single;
    function AsPointer: Pointer;
    property RttiType: TRttiType read GetRttiType;
    /// <summary>
    ///  Come AsVariant ma restituisce un Variant di tipo varDate e non varDouble
    ///  per i TDate e TDateTime.
    /// </summary>
    function AsActualVariant: Variant;
  end;

  /// <summary>
  ///  Un wrapper per TValue che limita la conversione implicit ai tipi
  ///  supportati, aggiungendo rispetto a TValue anche il TDateTime.
  /// </summary>
  TSynaValue = record
  public
    Value: TValue;
    class operator Implicit(const AValue: Boolean): TSynaValue; overload; static;
    class operator Implicit(const AValue: Integer): TSynaValue; overload; static;
    class operator Implicit(const AValue: Int64): TSynaValue; overload; static;
    class operator Implicit(const AValue: string): TSynaValue; overload; static;
    class operator Implicit(const AValue: TDateTime): TSynaValue; overload; static;
    class operator Implicit(const AValue: Double): TSynaValue; overload; static;
    class operator Implicit(const AValue: TValue): TSynaValue; overload; static;
  end;

  TRttiTypeHelper = class helper for TRttiObject
    function FindAttribute<T: TCustomAttribute>: T;
    function HasAttribute<T: TCustomAttribute>: Boolean; overload;
    function HasAttribute<T: TCustomAttribute>(const AProc: TProc<T>): Boolean; overload;
  end;

/// <summary>
///  True se AField ha un attributo del tipo indicato.
/// </summary>
function HasAttribute(const AField: TRttiField; const AAttributeClass: TClass): Boolean; overload;
/// <summary>
///  True se AType ha un attributo del tipo indicato.
/// </summary>
function HasAttribute(const AType: TRttiType; const AAttributeClass: TClass): Boolean; overload;

/// <summary>
///  IsNullDate Torna True de la data passata è considerata nulla
///  si condiderano nulli i valori NullDate di DevExpress e le date -1, 0 e 1 che storicamente vengono usate in DocFinance
///  </summary>
function IsNullDate(const ADate: TDateTime): Boolean;

implementation

uses
  Math, Hash, Variants;

var
  _Context : TRttiContext;

function IsNullDate(const ADate: TDateTime): Boolean;
begin
  Result := (ADate = -1) or (ADate = 0) or (ADate = NULL_DATE);
end;


procedure SetPropertyOnAllComponents(const AOwner: TComponent; const APropertyName: string;
                                     const APropertyValue: TValue;
                                     const APropertyVisibility: TMemberVisibilitySet = [mvPublic, mvPublished]);
var
  I: Integer;
  LInstance: TComponent;
  LType: TRttiType;
  LProperty: TRttiProperty;
begin
  for I := 0 to Pred(AOwner.ComponentCount) do
  begin
    LInstance := AOwner.Components[I];
    LType := _Context.GetType(LInstance.ClassType);
    LProperty := LType.GetProperty(APropertyName);
    if Assigned(LProperty) and (LProperty.Visibility in APropertyVisibility) then
      LProperty.SetValue(LInstance, APropertyValue);
  end;
end;

// Adattato da https://github.com/VSoftTechnologies/Delphi-Mocks/blob/master/Delphi.Mocks.Helpers.pas

function CompareValue(const Left, Right: TValue): Integer;
begin
  if Left.IsOrdinal and Right.IsOrdinal then
  begin
    Result := Math.CompareValue(Left.AsOrdinal, Right.AsOrdinal);
  end else
  if Left.IsFloat and Right.IsFloat then
  begin
    Result := Math.CompareValue(Left.AsFloat, Right.AsFloat);
  end else
  if Left.IsString and Right.IsString then
  begin
    Result := SysUtils.CompareStr(Left.AsString, Right.AsString);
  end else
  begin
    Result := 0;
  end;
end;

function SameValue(const Left, Right: TValue): Boolean;
begin
  if Left.IsNumeric and Right.IsNumeric then
  begin
    if Left.IsOrdinal then
    begin
      if Right.IsOrdinal then
      begin
        Result := Left.AsOrdinal = Right.AsOrdinal;
      end else
      if Right.IsSingle then
      begin
        Result := Math.SameValue(Left.AsOrdinal, Right.AsSingle);
      end else
      if Right.IsDouble then
      begin
        Result := Math.SameValue(Left.AsOrdinal, Right.AsDouble);
      end
      else
      begin
        Result := Math.SameValue(Left.AsOrdinal, Right.AsExtended);
      end;
    end else
    if Left.IsSingle then
    begin
      if Right.IsOrdinal then
      begin
        Result := Math.SameValue(Left.AsSingle, Right.AsOrdinal);
      end else
      if Right.IsSingle then
      begin
        Result := Math.SameValue(Left.AsSingle, Right.AsSingle);
      end else
      if Right.IsDouble then
      begin
        Result := Math.SameValue(Left.AsSingle, Right.AsDouble);
      end
      else
      begin
        Result := Math.SameValue(Left.AsSingle, Right.AsExtended);
      end;
    end else
    if Left.IsDouble then
    begin
      if Right.IsOrdinal then
      begin
        Result := Math.SameValue(Left.AsDouble, Right.AsOrdinal);
      end else
      if Right.IsSingle then
      begin
        Result := Math.SameValue(Left.AsDouble, Right.AsSingle);
      end else
      if Right.IsDouble then
      begin
        Result := Math.SameValue(Left.AsDouble, Right.AsDouble);
      end
      else
      begin
        Result := Math.SameValue(Left.AsDouble, Right.AsExtended);
      end;
    end
    else
    begin
      if Right.IsOrdinal then
      begin
        Result := Math.SameValue(Left.AsExtended, Right.AsOrdinal);
      end else
      if Right.IsSingle then
      begin
        Result := Math.SameValue(Left.AsExtended, Right.AsSingle);
      end else
      if Right.IsDouble then
      begin
        Result := Math.SameValue(Left.AsExtended, Right.AsDouble);
      end
      else
      begin
        Result := Math.SameValue(Left.AsExtended, Right.AsExtended);
      end;
    end;
  end else
  if Left.IsString and Right.IsString then
  begin
    Result := Left.AsString = Right.AsString;
  end else
  if Left.IsClass and Right.IsClass then
  begin
    Result := Left.AsClass = Right.AsClass;
  end else
  if Left.IsObject and Right.IsObject then
  begin
    Result := Left.AsObject = Right.AsObject;
  end else
  if Left.IsPointer and Right.IsPointer then
  begin
    Result := Left.AsPointer = Right.AsPointer;
  end else
  if Left.IsVariant and Right.IsVariant then
  begin
    Result := Left.AsVariant = Right.AsVariant;
  end else
  if Left.IsGuid and Right.IsGuid then
  begin
    Result := IsEqualGuid( Left.AsType<TGUID>, Right.AsType<TGUID> );
  end else
  if Left.TypeInfo = Right.TypeInfo then
  begin
    Result := Left.AsPointer = Right.AsPointer;
  end else
  begin
    Result := False;
  end;
end;

{ TRecordHelper }

class procedure TRecordHelper<T>.Clear(var ARecord: T);
var
  LField: TRttiField;
begin
  // Non uso ForEachField in questo caso perché devo pulire anche i campi invisibili.
  for LField in TRttiContext.Create.GetType(TypeInfo(T)).GetFields do
    LField.SetValue(@ARecord, TValue.Empty);
end;

class procedure TRecordHelper<T>.ForEachField(var ARecord: T; const AProc: TWriteRecordFieldProc);
var
  LType: TRttiType;
  LField: TRttiField;
  LStop: Boolean;
begin
  if Assigned(AProc) then
  begin
    LStop := False;
    LType := TRttiContext.Create.GetType(TypeInfo(T));
    for LField in GetVisibleFields(LType) do
    begin
      AProc(ARecord, LField, LStop);
      if LStop then
        Break;
    end;
  end;
end;

class function TRecordHelper<T>.Compare(const AFirst, ASecond: T): Integer;
var
  LResult: Integer;
  LType: TRttiType;
begin
  LResult := 0;
  LType := TRttiContext.Create.GetType(TypeInfo(T));

  ForEachField(AFirst,
    procedure (const ARecord: T; const AField: TRttiField; var AStop: Boolean)
    var
      LSecondValue: TValue;
    begin
      LSecondValue := LType.GetField(AField.Name).GetValue(@ASecond);
      LResult := AField.GetValue(@AFirst).Compare(LSecondValue);
      if LResult <> 0 then
        AStop := True;
    end);
  Result := LResult;
end;

class procedure TRecordHelper<T>.CopyFrom<TSource>(const ASource: TSource;
  var ADestination: T; const AStrict: Boolean = True);
var
  LDestinationPointer: Pointer;
  LSourceType: TRttiType;
begin
  LDestinationPointer := @ADestination;
  LSourceType := TRttiContext.Create.GetType(TypeInfo(TSource));
  TRecordHelper<T>.ForEachField(ADestination,
    procedure(const ADestination: T; const ADestinationField: TRttiField; var AStop: Boolean)
    var
      LSourceField: TRttiField;
    begin
      LSourceField := LSourceType.GetField(ADestinationField.Name);
      if Assigned(LSourceField) then
        ADestinationField.SetValue(LDestinationPointer, LSourceField.GetValue(@ASource))
      else if AStrict then
        raise Exception.CreateFmt('Field %s not found in record', [ADestinationField.Name]);
    end);
end;

class procedure TRecordHelper<T>.CopyTo<TDestination>(const ASource: T;
  var ADestination: TDestination; const AStrict: Boolean = True);
var
  LDestinationPointer: Pointer;
  LDestinationType: TRttiType;
begin
  LDestinationPointer := @ADestination;
  LDestinationType := TRttiContext.Create.GetType(TypeInfo(TDestination));
  TRecordHelper<T>.ForEachField(ASource,
    procedure(const ASource: T; const ASourceField: TRttiField; var AStop: Boolean)
    var
      LDestinationField: TRttiField;
    begin
      LDestinationField := LDestinationType.GetField(ASourceField.Name);
      if Assigned(LDestinationField) then
        LDestinationField.SetValue(LDestinationPointer, ASourceField.GetValue(@ASource))
      else if AStrict then
        raise Exception.CreateFmt('Field %s not found in record', [ASourceField.Name]);
    end);
end;

class function TRecordHelper<T>.CreateFromFields(const AFields: TFields): T;
begin
  FromFields(Result, AFields);
end;

class function TRecordHelper<T>.CreateFromFields(const AFields: TFields; const AFieldNames: TArray<string>): T;
begin
  FromFields(Result, AFields, AFieldNames);
end;

//class function TMtRecord<T>.CreateFromParams(const AParams: TMtParams): T;
//begin
//  FromParams(Result, AParams);
//end;

class function TRecordHelper<T>.Empty: T;
begin
  Clear(Result);
end;

class function TRecordHelper<T>.Equal(const AFirst, ASecond: T): Boolean;
var
  LEquals: Boolean;
  LType: TRttiType;
begin
  LEquals := True;
  LType := TRttiContext.Create.GetType(TypeInfo(T));

  ForEachField(AFirst,
    procedure (const ARecord: T; const AField: TRttiField; var AStop: Boolean)
    var
      LSecondValue: TValue;
    begin
      LSecondValue := LType.GetField(AField.Name).GetValue(@ASecond);
      if not AField.GetValue(@AFirst).Equals(LSecondValue) then
      begin
        LEquals := False;
        AStop := True;
      end;
    end);
  Result := LEquals;
end;

class function TRecordHelper<T>.FieldNames: TArray<string>;
var
  LType: TRttiType;
  LField: TRttiField;
begin
  Result := [];
  LType := TRttiContext.Create.GetType(TypeInfo(T));
  for LField in GetVisibleFields(LType) do
    Result := Result + [LField.Name];
end;

class procedure TRecordHelper<T>.ForEachField(const ARecord: T; const AProc: TReadRecordFieldProc);
var
  LType: TRttiType;
  LField: TRttiField;
  LStop: Boolean;
begin
  if Assigned(AProc) then
  begin
    LStop := False;
    LType := TRttiContext.Create.GetType(TypeInfo(T));
    for LField in GetVisibleFields(LType) do
    begin
      AProc(ARecord, LField, LStop);
      if LStop then
        Break;
    end;
  end;
end;

class procedure TRecordHelper<T>.FromFields(var ARecord: T; const AFields: TFields);
begin
  Clear(ARecord);
  ForEachField(ARecord,
    procedure (var ARecord: T; const AField: TRttiField; var AStop: Boolean)
    begin
      AField.SetValue(@ARecord, TValue.FromVariant(AFields.FieldByName(AField.Name).Value));
    end);
end;

class procedure TRecordHelper<T>.FromFields(var ARecord: T; const AFields: TFields; const AFieldNames: TArray<string>);
var
  I: Integer;
begin
  Assert(Length(AFieldNames) = Length(FieldNames));

  Clear(ARecord);
  I := 0;
  ForEachField(ARecord,
    procedure (var ARecord: T; const AField: TRttiField; var AStop: Boolean)
    begin
      AField.SetValue(@ARecord, TValue.FromVariant(AFields.FieldByName(AFieldNames[I]).Value));
      Inc(I);
    end);
end;

//class procedure TMtRecord<T>.FromParams(var ARecord: T; const AParams: TMtParams; const AParamNames: TArray<string>);
//var
//  I: Integer;
//begin
//  Assert(Length(AParamNames) = Length(FieldNames));
//
//  Clear(ARecord);
//  I := 0;
//  ForEachField(ARecord,
//    procedure (var ARecord: T; const AField: TRttiField; var AStop: Boolean)
//    begin
//      AField.SetValue(@ARecord, TValue.FromVariant(AParams.ParamByName(AParamNames[I]).Value));
//      Inc(I);
//    end);
//end;

//class procedure TMtRecord<T>.FromParams(var ARecord: T; const AParams: TMtParams);
//begin
//  Clear(ARecord);
//  ForEachField(ARecord,
//    procedure (var ARecord: T; const AField: TRttiField; var AStop: Boolean)
//    begin
//      AField.SetValue(@ARecord, TValue.FromVariant(AParams.ParamByName(AField.Name).Value));
//    end);
//end;

class function TRecordHelper<T>.GetValuesAsVariantArray(const ARecord: T; const AFieldNames: TArray<string>): Variant;
var
  LType: TRttiType;
  LFields: TArray<TRttiField>;
  AFieldName: string;
  I: Integer;
  LField: TRttiField;
begin
  LType := TRttiContext.Create.GetType(TypeInfo(T));

  LFields := [];
  for AFieldName in AFieldNames do
    LFields := LFields + [LType.GetField(AFieldName)];

  Result := VarArrayCreate([0, Length(LFields) - 1], varVariant);
  I := 0;
  for LField in LFields do
  begin
    Result[I] := LField.GetValue(@ARecord).AsVariant;
    Inc(I);
  end;
end;

class function TRecordHelper<T>.GetVisibleFields(const AType: TRttiType): TArray<TRttiField>;
begin
  Result := TRTTIArray.Filter<TRttiField>(AType.GetFields,
    function (var AField: TRttiField): Boolean
    begin
      Result := not AField.Name.StartsWith('_');
    end);
end;

class function TRecordHelper<T>.GetValuesAsVariantArray(const ARecord: T): Variant;
var
  LType: TRttiType;
  LFields: TArray<TRttiField>;
  I: Integer;
  LField: TRttiField;
begin
  LType := TRttiContext.Create.GetType(TypeInfo(T));
  LFields := GetVisibleFields(LType);
  Result := VarArrayCreate([0, Length(LFields) - 1], varVariant);
  I := 0;
  for LField in LFields do
  begin
    Result[I] := LField.GetValue(@ARecord).AsVariant;
    Inc(I);
  end;
end;

class function TRecordHelper<T>.IsComplete(const ARecord: T): Boolean;
var
  LIsComplete: Boolean;
begin
  LIsComplete := True;
  ForEachField(ARecord,
    procedure (const ARecord: T; const AField: TRttiField; var AStop: Boolean)
    var
      LNullValue: TValue;
      LFieldValue: TValue;
    begin
      TValue.Make(nil, AField.FieldType.Handle, LNullValue);
      LFieldValue := AField.GetValue(@ARecord);
      if LFieldValue.Equals(LNullValue) then
      begin
        LIsComplete := False;
        AStop := True;
      end;
    end);
  Result := LIsComplete;
end;

class function TRecordHelper<T>.IsEmpty(const ARecord: T): Boolean;
var
  LIsEmpty: Boolean;
begin
  LIsEmpty := True;
  ForEachField(ARecord,
    procedure (const ARecord: T; const AField: TRttiField; var AStop: Boolean)
    var
      LNullValue: TValue;
      LFieldValue: TValue;
    begin
      TValue.Make(nil, AField.FieldType.Handle, LNullValue);
      LFieldValue := AField.GetValue(@ARecord);
      if not LFieldValue.IsEmpty and not LFieldValue.Equals(LNullValue) then
      begin
        LIsEmpty := False;
        AStop := True;
      end;
    end);
  Result := LIsEmpty;
end;

class procedure TRecordHelper<T>.ToFields(const ARecord: T; const AFields: TFields);
begin
  ForEachField(ARecord,
    procedure (const ARecord: T; const AField: TRttiField; var AStop: Boolean)
    begin
      AFields.FieldByName(AField.Name).Value := AField.GetValue(@ARecord).AsActualVariant;
    end);
end;

class procedure TRecordHelper<T>.ToFields(const ARecord: T; const AFields: TFields; const AFieldNames: TArray<string>);
var
  I: Integer;
begin
  Assert(Length(AFieldNames) = Length(FieldNames));

  I := 0;
  ForEachField(ARecord,
    procedure (const ARecord: T; const AField: TRttiField; var AStop: Boolean)
    begin
      AFields.FieldByName(AFieldNames[I]).Value := AField.GetValue(@ARecord).AsActualVariant;
      Inc(I);
    end);
end;

//class procedure TMtRecord<T>.ToParams(const ARecord: T; const AParams: TMtParams; const AParamNames: TArray<string>);
//var
//  I: Integer;
//begin
//  Assert(Length(AParamNames) = Length(FieldNames));
//
//  I := 0;
//  ForEachField(ARecord,
//    procedure (const ARecord: T; const AField: TRttiField; var AStop: Boolean)
//    begin
//      AParams.ParamByName(AParamNames[I]).Value := AField.GetValue(@ARecord).AsActualVariant;
//      Inc(I);
//    end);
//end;

//class procedure TMtRecord<T>.ToParams(const ARecord: T; const AParams: TMtParams);
//begin
//  ForEachField(ARecord,
//    procedure (const ARecord: T; const AField: TRttiField; var AStop: Boolean)
//    begin
//      AParams.ParamByName(AField.Name).Value := AField.GetValue(@ARecord).AsActualVariant;
//    end);
//end;

{ TMtRecordComparer<T> }

function TRecordHelperComparer<T>.Equals(const Left, Right: T): Boolean;
begin
  Result := TRecordHelper<T>.Equal(Left, Right);
end;

function TRecordHelperComparer<T>.GetHashCode(const Value: T): Integer;
var
  LHashCode: Integer;
begin
  LHashCode := 0;
  TRecordHelper<T>.ForEachField(Value,
    procedure(const ARecord: T; const AField: TRttiField; var AStop: Boolean)
    var
      LValue: TValue;
      LData: Pointer;
    begin
      LValue := AField.GetValue(@ARecord);
      LData := LValue.GetReferenceToRawData;
      LHashCode := THashBobJenkins.GetHashValue(LData, LValue.DataSize, LHashCode);
    end);
  Result := LHashCode;
end;

{ TValueHelper }

function TValueHelper.Equals(const AOtherValue: TValue): Boolean;
begin
  Result := IsEmpty = AOtherValue.IsEmpty;
  if not Result or IsEmpty then
    Exit;
  Result := SameValue(Self, AOtherValue);
end;

function TValueHelper.AsActualVariant: Variant;
begin
  if IsDateTime then
    Result := AsType<TDateTime>
  else if IsDate then
    Result := AsType<TDate>
  else
    Result := AsVariant;
end;

function TValueHelper.AsDouble: Double;
begin
  Result := AsType<Double>;
end;

function TValueHelper.AsFloat: Extended;
begin
  Result := AsType<Extended>;
end;

function TValueHelper.AsPointer: Pointer;
begin
  ExtractRawDataNoCopy(@Result);
end;

function TValueHelper.AsSingle: Single;
begin
  Result := AsType<Single>;
end;

function TValueHelper.Compare(const AOtherValue: TValue): Integer;
begin
  Result := CompareValue(Self, AOtherValue);
end;

function TValueHelper.GetRttiType: TRttiType;
begin
   Result := _Context.GetType(TypeInfo);
end;

function TValueHelper.IsBoolean: Boolean;
begin
  Result := TypeInfo = System.TypeInfo(Boolean);
end;

function TValueHelper.IsByte: Boolean;
begin
  Result := TypeInfo = System.TypeInfo(Byte);
end;

function TValueHelper.IsCardinal: Boolean;
begin
  Result := TypeInfo = System.TypeInfo(Cardinal);
end;

function TValueHelper.IsCurrency: Boolean;
begin
  Result := TypeInfo = System.TypeInfo(Currency);
end;

function TValueHelper.IsDate: Boolean;
begin
  Result := TypeInfo = System.TypeInfo(TDate);
end;

function TValueHelper.IsDateTime: Boolean;
begin
  Result := TypeInfo = System.TypeInfo(TDateTime);
end;

function TValueHelper.IsDouble: Boolean;
begin
  Result := TypeInfo = System.TypeInfo(Double);
end;

function TValueHelper.IsFloat: Boolean;
begin
  Result := Kind = tkFloat;
end;

function TValueHelper.IsInt64: Boolean;
begin
  Result := TypeInfo = System.TypeInfo(Int64);
end;

function TValueHelper.IsInteger: Boolean;
begin
  Result := TypeInfo = System.TypeInfo(Integer);
end;

function TValueHelper.IsLongWord: Boolean;
begin
  Result := TypeInfo = System.TypeInfo(LongWord);
end;

function TValueHelper.IsNumeric: Boolean;
begin
  Result := Kind in [tkInteger, tkChar, tkEnumeration, tkFloat, tkWChar, tkInt64];
end;

function TValueHelper.IsPointer: Boolean;
begin
  Result := Kind = tkPointer;
end;

function TValueHelper.IsShortInt: Boolean;
begin
  Result := TypeInfo = System.TypeInfo(ShortInt);
end;

function TValueHelper.IsSingle: Boolean;
begin
  Result := TypeInfo = System.TypeInfo(Single);
end;

function TValueHelper.IsSmallInt: Boolean;
begin
  Result := TypeInfo = System.TypeInfo(SmallInt);
end;

function TValueHelper.IsString: Boolean;
begin
  Result := Kind in [tkChar, tkString, tkWChar, tkLString, tkWString, tkUString];
end;

function TValueHelper.IsTime: Boolean;
begin
  Result := TypeInfo = System.TypeInfo(TTime);
end;

function TValueHelper.IsUInt64: Boolean;
begin
  Result := TypeInfo = System.TypeInfo(UInt64);
end;

function TValueHelper.IsVariant: Boolean;
begin
  Result := TypeInfo = System.TypeInfo(Variant);
end;

function TValueHelper.IsWord: Boolean;
begin
  Result := TypeInfo = System.TypeInfo(Word);
end;

function TValueHelper.IsGuid: Boolean;
begin
  Result := TypeInfo = System.TypeInfo(TGUID);
end;

{ TMtRecordAscendingComparer<T> }

function TRecordHelperAscendingComparer<T>.Compare(const Left, Right: T): Integer;
begin
  Result := TRecordHelper<T>.Compare(Left, Right);
end;

class destructor TRecordHelperAscendingComparer<T>.Destroy;
begin
  FreeAndNil(FOrdinal);
end;

class function TRecordHelperAscendingComparer<T>.Ordinal: TRecordHelperAscendingComparer<T>;
begin
  if not Assigned(FOrdinal) then
    FOrdinal := TRecordHelperAscendingComparer<T>.Create;
  Result := FOrdinal;
end;

{ TMtRecordDescendingComparer<T> }

function TRecordHelperDescendingComparer<T>.Compare(const Left, Right: T): Integer;
begin
  Result := -TRecordHelper<T>.Compare(Left, Right);
end;

class destructor TRecordHelperDescendingComparer<T>.Destroy;
begin
  FreeAndNil(FOrdinal);
end;

class function TRecordHelperDescendingComparer<T>.Ordinal: TRecordHelperDescendingComparer<T>;
begin
  if not Assigned(FOrdinal) then
    FOrdinal := TRecordHelperDescendingComparer<T>.Create;
  Result := FOrdinal;
end;

{ TMtValue }

class operator TSynaValue.Implicit(const AValue: Integer): TSynaValue;
begin
  Result.Value := TValue.From<Integer>(AValue);
end;

class operator TSynaValue.Implicit(const AValue: string): TSynaValue;
begin
  Result.Value := TValue.From<string>(AValue);
end;

class operator TSynaValue.Implicit(const AValue: Int64): TSynaValue;
begin
  Result.Value := TValue.From<Int64>(AValue);
end;

class operator TSynaValue.Implicit(const AValue: TDateTime): TSynaValue;
begin
  Result.Value := TValue.From<TDateTime>(AValue);
end;

class operator TSynaValue.Implicit(const AValue: TValue): TSynaValue;
begin
  Result.Value := AValue;
end;

class operator TSynaValue.Implicit(const AValue: Boolean): TSynaValue;
begin
  Result.Value := TValue.From<Boolean>(AValue);
end;

class operator TSynaValue.Implicit(const AValue: Double): TSynaValue;
begin
  Result.Value := TValue.From<Double>(AValue);
end;

function HasAttribute(const AField: TRttiField; const AAttributeClass: TClass): Boolean;
var
  LAttribute: TCustomAttribute;
begin
  for LAttribute in AField.GetAttributes do
    if LAttribute.ClassType = AAttributeClass then
      Exit(True);
  Result := False;
end;

function HasAttribute(const AType: TRttiType; const AAttributeClass: TClass): Boolean;
var
  LAttribute: TCustomAttribute;
begin
  for LAttribute in AType.GetAttributes do
    if LAttribute.ClassType = AAttributeClass then
      Exit(True);
  Result := False;
end;

{ TRttiTypeHelper }

function TRttiTypeHelper.FindAttribute<T>: T;
var
  LAttribute: TCustomAttribute;
begin
  Result := nil;
  for LAttribute in GetAttributes do
    if LAttribute is T then
      Exit(T(LAttribute));
end;

function TRttiTypeHelper.HasAttribute<T>: Boolean;
begin
  Result := FindAttribute<T> <> nil;
end;

function TRttiTypeHelper.HasAttribute<T>(const AProc: TProc<T>): Boolean;
var
  LAttribute: T;
begin
  Result := False;
  LAttribute := FindAttribute<T>;
  if Assigned(LAttribute) then
  begin
    Result := True;
    if Assigned(AProc) then
      AProc(LAttribute);
  end;
end;

{ TMtArray }

class procedure TRTTIArray.Exclude<T>(var ASource: TArray<T>; const AValue: T);
begin
  ASource := Filter<T>(ASource,
    function (var AElement: T): Boolean
    begin
      Result := AElement <> AValue;
    end);
end;

class function TRTTIArray.Filter<T>(const ASource: TArray<T>;
  const AFilterFunc: TRTTIVarFunc<T>): TArray<T>;
var
  LItem: T;
  LNewItem: T;
begin
  Result := [];
  for LItem in ASource do
  begin
    LNewItem := LItem;
    if Assigned(AFilterFunc) and AFilterFunc(LNewItem) then
      Result := Result + [LNewItem];
  end;
end;

class function TRTTIArray.Reverse<T>(AValue: TArray<T>): TArray<T>;
var
  I: Integer;
begin
  Result := AValue;
  if Length(Result) > 0 then
    for I := Low(Result) to High(Result) div 2 do
      Swap<T>(Result[I], Result[High(Result) - I]);
end;


class procedure TRTTIArray.Swap<T>(var AValue1, AValue2: T);
var
  LTemp: T;
begin
  LTemp := AValue1;
  AValue1 := AValue2;
  AValue2 := LTemp;
end;

end.

