unit xtDatasetEntity;
interface


uses
{$IFDEF MSWINDOWS}
  Winapi.Windows,
{$ENDIF}
  System.Classes, System.SysUtils, Data.DB, System.Generics.Collections, System.SyncObjs,
  FireDAC.Stan.Intf, FireDAC.Stan.Param, FireDAC.Stan.Util, FireDAC.Stan.Error,
  FireDAC.DatS,
  FireDAC.UI.Intf,
  FireDAC.Phys.Intf,
  FireDAC.DApt.Column, FireDAC.DApt.Intf,
  FireDAC.Comp.DataSet, FireDAC.Comp.UI, FireDAC.Stan.Option,FireDAC.Comp.Client,
  xtConnection, uProviderHTTP, xtServiceAddress,System.Net.HttpClient, xtCommonTypes;

type
//  __TFDDataSet = class
//  private
//    procedure InternalLoadFromStorage;
//  end;

  TFDDataSetHelper = class helper for TFDDataSet
  private
  public
    procedure helpInternalLoadFromStorage;
    function HelperResetAtLoading: Boolean;
  end;


  TxtDatasetEntity = class(TFDCustomMemTable)
  private
    FxtConnection: TXtConnection;
    FxtEntityName: String;
    FxtApplyUpdateAfterPost: Boolean;
    FxtApplyUpdateAfterDelete: Boolean;
    FxtParams: TStringList;
    FxtMaxRecords: int64;
    FxtRefreshAfterPost: Boolean;
    FxtLiveRecordInsert: Boolean;
    procedure SetxtConnection(const Value: TXtConnection);
    procedure SetxtEntityName(const Value: String);
    procedure SetxtApplyUpdateAfterDelete(const Value: Boolean);
    procedure SetxtApplyUpdateAfterPost(const Value: Boolean);
    procedure SetxtParams(const Value: TStringList);
    procedure SetxtMaxRecords(const Value: int64);
    procedure SetxtRefreshAfterPost(const Value: Boolean);
    procedure SetxtLiveRecordInsert(const Value: Boolean);
  protected
    procedure DoBeforeOpen; override;
    procedure DoBeforeInsert; override;
    procedure DoAfterInsert; override;
    procedure DoAfterOpen; override;
    procedure DoAfterPost; override;
    procedure DoBeforeDelete; override;

    procedure DoAfterDelete; override;
    procedure SetActive(Value: Boolean); override;
    procedure DoBeforeRefresh; override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure customPost(params : TStrings;contentStream : TMemoryStream);

    procedure xtApplyUpdates;

    function getDataSetInfo : TNamedDataSetInfo;
  published
    {xtConnection}
    property xtConnection : TXtConnection read FxtConnection write SetxtConnection;
    property xtEntityName : String read FxtEntityName write SetxtEntityName;
    property xtRefreshAfterPost : Boolean read FxtRefreshAfterPost write SetxtRefreshAfterPost;
    property xtApplyUpdateAfterPost   : Boolean read FxtApplyUpdateAfterPost write SetxtApplyUpdateAfterPost;
    property xtApplyUpdateAfterDelete : Boolean read FxtApplyUpdateAfterDelete write SetxtApplyUpdateAfterDelete;
    property xtLiveRecordInsert : Boolean  read FxtLiveRecordInsert write SetxtLiveRecordInsert;
    property xtParams : TStringList read FxtParams write SetxtParams;
    property xtMaxRecords : int64 read FxtMaxRecords write SetxtMaxRecords;

    property ActiveStoredUsage;
    { TDataSet }
    property Active;
    property AutoCalcFields;
    property BeforeOpen;
    property AfterOpen;
    property BeforeClose;
    property AfterClose;
    property BeforeInsert;
    property AfterInsert;
    property BeforeEdit;
    property AfterEdit;
    property BeforePost;
    property AfterPost;
    property BeforeCancel;
    property AfterCancel;
    property BeforeDelete;
    property AfterDelete;
    property BeforeScroll;
    property AfterScroll;
    property BeforeRefresh;
    property AfterRefresh;
    property OnCalcFields;
    property OnDeleteError;
    property OnEditError;
    property OnNewRecord;
    property OnPostError;
    property FieldOptions;
    property Filtered;
    property FilterOptions;
    property Filter;
    property OnFilterRecord;
    property ObjectView default True;
    property Constraints;
    property DataSetField;
    property FieldDefs stored FStoreDefs;
    { TFDDataSet }
    property CachedUpdates;
    property FilterChanges;
    property IndexDefs stored FStoreDefs;
    property Indexes;
    property IndexesActive;
    property IndexName;
    property IndexFieldNames;
    property Aggregates;
    property AggregatesActive;
    property ConstraintsEnabled;
    property MasterSource;
    property MasterFields;
    property DetailFields;
    property OnUpdateRecord;
    property OnUpdateError;
    property OnReconcileError;
    property BeforeApplyUpdates;
    property AfterApplyUpdates;
    property BeforeGetRecords;
    property AfterGetRecords;
    property AfterGetRecord;
    property BeforeRowRequest;
    property AfterRowRequest;
    property BeforeExecute;
    property AfterExecute;
    property FetchOptions;
    property FormatOptions;
    property ResourceOptions;
    property UpdateOptions;
    { TFDAdaptedDataSet }
    property LocalSQL;
    property ChangeAlerter;
    property ChangeAlertName;
    { TFDCustomMemTable }
    property Adapter;
    property StoreDefs;
  end;

procedure Register;

implementation

uses System.NetEncoding,system.JSON, xtJSON;

procedure Register;
begin
  RegisterComponents('xTumble', [TxtDatasetEntity]);
end;


{ TxtDatasetEntity }

constructor TxtDatasetEntity.Create(AOwner: TComponent);
begin

  FxtConnection:= nil;;
  FxtEntityName:= '';
  FxtApplyUpdateAfterPost:= False;
  FxtApplyUpdateAfterDelete:= False;
  FxtRefreshAfterPost         := False;
  FxtParams := TStringList.Create;
  FxtLiveRecordInsert := True;
  FxtMaxRecords := 10;
  inherited;

end;

procedure TxtDatasetEntity.customPost(params: TStrings;
  contentStream: TMemoryStream);
var
 respo: IHTTPResponse;
begin
 respo := TProviderHttp.doPost(xtConnection.ConnectionParams,TxtServices.jdataset,params,contentStream);
 if respo.StatusCode <> 200 then
  raise Exception.Create('Error ' + respo.ContentAsString);
end;

procedure TxtDatasetEntity.DoAfterDelete;
begin
  inherited;
  if xtApplyUpdateAfterDelete then
   Begin
    xtApplyUpdates;
   End;
end;

procedure TxtDatasetEntity.DoAfterInsert;
var
  respo: IHTTPResponse;
  ts: TStringList;
begin
  inherited;
  if FindField('pk_id') <> nil then
   begin
      ts := TStringList.Create;
      ts.Add(xtParams.Text);
      ts.Values['xtEntity'] := FxtEntityName;
      ts.Values['max_records'] := FxtMaxRecords.ToString;

      respo := TProviderHttp.doGet(xtConnection.ConnectionParams,
        TxtServices.entitypk, ts);
      ts.Free;
      if respo.StatusCode = 200 then
       Begin
        FindField('pk_id').AsLargeInt := respo.ContentAsString.ToInt64;
       End
      Else
       Begin
        raise Exception.Create('Error on insert record: ' + respo.ContentAsString());
       End;
   end;
end;

procedure TxtDatasetEntity.DoAfterOpen;
begin

  inherited;
  FStorage := nil;
  StopWait;
  EnableControls;

end;

procedure TxtDatasetEntity.DoAfterPost;
begin
  inherited;
  if xtApplyUpdateAfterPost then
   Begin
    xtApplyUpdates;
   End;
end;

procedure TxtDatasetEntity.DoBeforeDelete;
var
  TS: TStringList;
begin
  inherited;

  if not active then
   raise Exception.Create('dataset is not active');



  if FxtEntityName.ToLower = 'files' then
   Begin
      TS := TStringList.Create;

      TS.Values['PK_ID'] := FieldByName('pk_id').AsString;
      TS.Values['DELETED'] := 'S';
      TS.Values['xtEntity'] := FxtEntityName;

      customPost(TS,nil);
      TS.Free;
      Abort;
   End;
end;

procedure TxtDatasetEntity.DoBeforeInsert;

begin
  inherited;


end;

procedure TxtDatasetEntity.DoBeforeOpen;
begin
  inherited;
  if xtApplyUpdateAfterDelete or xtApplyUpdateAfterPost then
    Self.CachedUpdates := True;

end;


procedure TxtDatasetEntity.DoBeforeRefresh;
var bk : TBytes;
begin
//  inherited;

 if not active then exit;

 bk := GetBookmark;
 Close;
 Open;
 try
   GotoBookmark(bk);
 except

 end;



end;

function TxtDatasetEntity.getDataSetInfo: TNamedDataSetInfo;
var
  T1: TDateTime;
  respo: IHTTPResponse;
  MS: TStream;
  JOBJ: TJSONObject;
  miaStringa: string;
begin
  if xtConnection = nil then
  Begin
    raise Exception.Create('connection is not defined');
  End;

  T1 := now;
  respo := TProviderHttp.doHead(xtConnection.ConnectionParams,
    TxtServices.jdataset, 'xtEntity=' + FxtEntityName);

//  MS := respo.contentStream;
//  MS.Position := 0;
//
//  JOBJ := TJSONHelper.StreamToJSON(MS);

//  miaStringa := respo.ContentAsString;

  miaStringa :=  TBase64Encoding.Base64.Decode(
                                respo.HeaderValue['dsetinfo']);
//  AResponseInfo.CustomHeaders.Values['dsetinfo']



  result := TJSONPersistence.FromJSON<TNamedDataSetInfo>(miaStringa);

end;

procedure TxtDatasetEntity.SetActive(Value: Boolean);
var
  respo: IHTTPResponse;
  MS : TStream;
  T1,T2 : TDateTime;
  url: String;
  pp: TFDMemTable;
  ts : TStringList;
begin
  // FIREDAC SARA' PURE TANTO FIGO MA NON AVERE IL PARAMETRO "AUTO ACTIVATE"
  // NELLA LOADFROM STREAM MI SEMBRA NA CACATA PAZZESCA
  // NON HO FREQUENTATO OXFORD SE A QUALCUNO VENISSE IL DUBBIO... IVAN DA ROBBIANO

  if not Value then
    inherited
  Else
   Begin
      if xtConnection = nil then
       Begin
        raise Exception.Create('connection is not defined');
       End;

      T1 := now;
      ts := TStringList.Create;
      ts.Add('xtEntity=' + FxtEntityName);
      ts.Add('max_records=' + FxtMaxRecords.ToString);
      ts.Add(xtParams.Text);
      respo := TProviderHttp.doGet(xtConnection.ConnectionParams,TxtServices.jdataset,ts);

      if (respo.StatusCode < 200)or(respo.StatusCode > 299) then
       Begin
         raise Exception.Create('[TxtDatasetEntity.SetActive] Error on open query: ' + respo.ContentAsString );
       End;


      ts.Free;
      MS := respo.ContentStream;
      MS.Position := 0;

      ASSERT(DatSManager <> nil);
      DisableControls;
      StartWait;
      try
        if TFDDataSet(Self).HelperResetAtLoading then
          DoResetAtLoading
        else
          CheckBrowseMode;
        FStorage := ResourceOptions.GetStorage('', TFDStorageFormat.sfJSON);
//        try
        try
          FStorage.Open(ResourceOptions, FEncoder, '', MS, smRead);
          if TFDDataSet(Self).HelperResetAtLoading then
            inherited
          else begin
            TFDDataSet(Self).helpInternalLoadFromStorage;
            Resync([]);
          end;
        except
         on e:exception do
          begin
           FStorage := nil;
           StopWait;
           EnableControls;
           raise Exception.Create(e.message + '[' + respo.ContentAsString + ']');
          end;
        end;
//        finally
//          FStorage := nil;
//        end;
      finally
//        StopWait;
//        EnableControls;
      end;
   End;
end;

procedure TxtDatasetEntity.SetxtEntityName(const Value: String);
begin
  FxtEntityName := Value;
end;

procedure TxtDatasetEntity.SetxtLiveRecordInsert(const Value: Boolean);
begin
  FxtLiveRecordInsert := Value;
end;

procedure TxtDatasetEntity.SetxtMaxRecords(const Value: int64);
begin
  FxtMaxRecords := Value;
end;

procedure TxtDatasetEntity.SetxtParams(const Value: TStringList);
begin
  FxtParams.Assign(Value);
//  FxtParams := Value;
end;

procedure TxtDatasetEntity.SetxtRefreshAfterPost(const Value: Boolean);
begin
  FxtRefreshAfterPost := Value;
end;

procedure TxtDatasetEntity.xtApplyUpdates;
var
  respo: IHTTPResponse;
  MS : TStream;
  T1,T2 : TDateTime;
  url: String;
  bk : TBytes;
  FDMemTbDelta: TFDMemTable;
  ts: TStringList;
begin
 if not Active then exit;
 If Self.ChangeCount < 1 then exit;

 if CachedUpdates then
  Begin

   T1 := now;
   bk := Self.GetBookmark;
   FDMemTbDelta := TFDMemTable.Create(nil);
   FDMemTbDelta.Data := Self.Delta;


   MS := TMemoryStream.Create;
   FDMemTbDelta.SaveToStream(MS, TFDStorageFormat.sfJSON);
   MS.Position := 0;
   ts := TStringList.Create;
   ts.Add('xtEntity=' + FxtEntityName);
   ts.Add('max_records=' + FxtMaxRecords.ToString);
   ts.Add(xtParams.Text);
   respo := TProviderHttp.doPost(xtConnection.ConnectionParams,TxtServices.jdataset,ts,MS);
   MS.Free;
   ts.Free;

   if xtRefreshAfterPost then
    Begin
     MS := respo.ContentStream;
     MS.Position := 0;
     Self.LoadFromStream(MS,TFDStorageFormat.sfJSON);
    End;

   Self.MergeChangeLog;
   Self.GotoBookmark(bk);

   T2 := now;
  End
 Else
  Begin
//   T1 := now;
//   bk := Self.GetBookmark;
//   FDMemTbDelta := TFDMemTable.Create(nil);
//   FDMemTbDelta.Data := Self.Delta;
//
//
//   MS := TMemoryStream.Create;
//   FDMemTbDelta.SaveToStream(MS, TFDStorageFormat.sfJSON);
//   MS.Position := 0;
//   ts := TStringList.Create;
//   ts.Add('xtEntity=' + FxtEntityName);
//   ts.Add('max_records=' + FxtMaxRecords.ToString);
//   ts.Add(xtParams.Text);
//   respo := TProviderHttp.doPost(xtConnection.ConnectionParams,TxtServices.jdataset,ts,MS);
//   MS.Free;
//   ts.Free;
//
//
//   MS := respo.ContentStream;
//   MS.Position := 0;
//   Self.LoadFromStream(MS,TFDStorageFormat.sfJSON);
//   Self.MergeChangeLog;
//   Self.GotoBookmark(bk);
//
//   T2 := now;

  End;
end;

procedure TxtDatasetEntity.SetxtApplyUpdateAfterDelete(const Value: Boolean);
begin
  FxtApplyUpdateAfterDelete := Value;
end;

procedure TxtDatasetEntity.SetxtApplyUpdateAfterPost(const Value: Boolean);
begin
  FxtApplyUpdateAfterPost := Value;
  Self.CachedUpdates := True;
end;

procedure TxtDatasetEntity.SetxtConnection(const Value: TXtConnection);
begin
  FxtConnection := Value;
end;

{ TFDDataSetHelper }

function TFDDataSetHelper.HelperResetAtLoading: Boolean;
var
    P : function : Boolean of object;
begin
    TMethod(P).Code := @TFDDataSet.ResetAtLoading;
    TMethod(P).Data := Self;
    result := P; // Call UsefullButHidden;
end;

procedure TFDDataSetHelper.helpInternalLoadFromStorage;
var
    P : procedure of object;
begin
// HO DOVUTO FARE STA CAGATA PERCHE' GLI HELPER
//  NON TI FANNO PIù VEDERE I PRIVATI DEGLI ANCESTOR DI STO CAZZO
    TMethod(P).Code := @TFDDataSet.InternalLoadFromStorage;
    TMethod(P).Data := Self;
    P;
end;

end.
