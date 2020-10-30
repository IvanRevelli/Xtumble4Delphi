unit xtSettingsManager;

interface

type

// TAfterSettingsLoaded = procedure <R>(settingsData : R) of object;

 TSettingsManager<R{ : record}> = record
  private
    FfileName: String;
    procedure SetfileName(const Value: String);
  public
    Data : R;
    property fileName : String read FfileName write SetfileName;
    procedure loadFromFile;
    procedure saveToFile;
  end;

implementation

uses
  System.Classes,System.SysUtils, System.JSON, xtRTTI;


procedure TSettingsManager<R>.loadFromFile;
var
  TS: TStringList;
  JVal: TJSONValue;
begin
  TS   := nil;
  JVal := nil;
  try
    TS := TStringList.Create;
    if FileExists(Self.FfileName) then
     Begin
       TS.LoadFromFile(Self.FfileName);

       JVal := TJSONObject.ParseJSONValue(TS.Text);

       Self.Data := TJSONPersistence.FromJSON<R>(TJSONOBject(JVal));
     End
  finally
   if JVal <> nil then FreeAndNil(JVal);
   if TS <> nil then FreeAndNil(TS);
  end;
end;

procedure TSettingsManager<R>.saveToFile;
var
  TS: TStringList;
  JVal: TJSONValue;
begin
  TS := nil;
  JVal := nil;
  try
    TS := TStringList.Create;
    JVal := synaJSON.TJSONPersistence.ToJSON<R>(Self.Data);
    TS.Text := JVal.Format;
    TS.saveToFile(Self.FfileName);
  finally
    if JVal <> nil then
      FreeAndNil(JVal);
    if TS <> nil then
      FreeAndNil(TS);
  end;
end;

procedure TSettingsManager<R>.SetfileName(const Value: String);
begin
 if FfileName <> Value then
  Begin
    FfileName := Value;
    loadFromFile;
  End;
end;
end.
