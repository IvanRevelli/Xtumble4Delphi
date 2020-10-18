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
  xtConnection, uProviderHTTP, xtServiceAddress,System.Net.HttpClient;

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


  TxtDatasetEntity = class(TFDMemTable)
  private
    FxtConnection: TXtConnection;
    FEntityName: String;
    procedure SetxtConnection(const Value: TXtConnection);
    procedure SetEntityName(const Value: String);
  protected
    procedure DoBeforeOpen; override;
    procedure DoAfterOpen; override;
    procedure SetActive(Value: Boolean); override;
  published

    property ActiveStoredUsage;
    {xtConnection}
    property xtConnection : TXtConnection read FxtConnection write SetxtConnection;
    property EntityName : String read FEntityName write SetEntityName;

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

    { TFDDataSet }
    property CachedUpdates;
    property FilterChanges;

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
  end;

procedure Register;

implementation


procedure Register;
begin
  RegisterComponents('xTumble', [TxtDatasetEntity]);
end;


{ TxtDatasetEntity }

procedure TxtDatasetEntity.DoAfterOpen;
begin

  inherited;
  FStorage := nil;
  StopWait;
  EnableControls;

end;

procedure TxtDatasetEntity.DoBeforeOpen;
begin
  inherited;
end;


procedure TxtDatasetEntity.SetActive(Value: Boolean);
var
  respo: IHTTPResponse;
  MS : TStream;
  T1,T2 : TDateTime;
  url: String;
  pp: TFDMemTable;
begin
  // FIREDAC SARA' PURE TANTO FIGO MA NON AVERE IL PARAMETRO "AUTO ACTIVATE"
  // NELLA LOADFROM STREAM MI SEMBRA NA CACATA PAZZESCA
  // NON HO FREQUENTATO OXFORD SE A QUALCUNO NE VENISSE IL DUBBIO... IVAN DA ROBBIANO

  if not Value then
    inherited
  Else
   Begin


      T1 := now;
      respo := TProviderHttp.doGet(xtConnection.ConnectionParams,TxtServices.jdataset,'xtEntity=' + FEntityName + '&max_records=10');
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
           raise Exception.Create(e.message);
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

procedure TxtDatasetEntity.SetEntityName(const Value: String);
begin
  FEntityName := Value;
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
