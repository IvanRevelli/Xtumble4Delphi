unit uxtCommonComponent;

interface

uses system.SysUtils, system.Classes, xtCommonTypes, xtConnection, uProviderHTTP;

type

  TxtBaseComponent = class(TComponent)
  type
    HTTPprov = class of TProviderHttp;
  private

    FxtConnection: TXtConnection;
    Factive: Boolean;
    procedure SetxtConnection(const Value: TXtConnection);
    procedure Setactive(const Value: Boolean);

  protected

    procedure doBeforeActivate; virtual;
  public
    constructor Create(AOwner: TComponent); override;
  published

    property active: Boolean read Factive write Setactive;
    property xtConnection: TXtConnection read FxtConnection
      write SetxtConnection;
  end;

implementation

{ TxtDriveCommands }

constructor TxtBaseComponent.Create(AOwner: TComponent);
begin
  inherited;
  FxtConnection := nil;
  FActive := False;
end;

procedure TxtBaseComponent.doBeforeActivate;
begin

end;

procedure TxtBaseComponent.Setactive(const Value: Boolean);
begin
 if Factive <> Value then
  Begin
    Factive := Value;
    if Value then
      doBeforeActivate;
  End;
end;

procedure TxtBaseComponent.SetxtConnection(const Value: TXtConnection);
begin
 FxtConnection := Value;
end;

end.
