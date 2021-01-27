unit uFrmLogin;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Imaging.pngimage,
  Vcl.ComCtrls, Vcl.StdCtrls, uVCLUtils, pasDmXtumble, Vcl.WinXCtrls,
  uFrmCreateXTAccount,xtCommonTypes, uFrmMain,Vcl.Themes;

type
  TfrmLogin = class(TForm)
    Image1: TImage;
    pnlBottom: TPanel;
    btnOk: TButton;
    btnClose: TButton;
    pnlLogin: TPanel;
    btnCreateNewAccount: TButton;
    cbThemes: TComboBox;
    lblServer: TLabel;
    procedure btnCloseClick(Sender: TObject);
    procedure llXtumbleClick(Sender: TObject);
    procedure llXtumbleMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure FormShow(Sender: TObject);
    procedure btnCreateNewAccountClick(Sender: TObject);
    procedure btnOkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure cbThemesCloseUp(Sender: TObject);
    procedure lblServerClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
  private
    { Private declarations }

    LoginAccPanel: TRecordEditorPanel<TLoginXTAccountParams>;
    FcurrentTheme: String;
    FStyleEnabled: Boolean;
    procedure SetcurrentTheme(const Value: String);
    procedure SetStyleEnabled(const Value: Boolean);
    property StyleEnabled : Boolean read FStyleEnabled write SetStyleEnabled;
    property currentTheme : String read FcurrentTheme write SetcurrentTheme;
    procedure themeList;

    procedure createLoginPanel;
    procedure ckLogin;
  public
    { Public declarations }
    loginParams      : TLoginXTAccountParams;

  end;

var
  frmLogin: TfrmLogin;

implementation

{$R *.dfm}
uses shellAPI;

procedure TfrmLogin.btnCloseClick(Sender: TObject);
begin
 Application.Terminate;
end;

procedure TfrmLogin.btnCreateNewAccountClick(Sender: TObject);
begin
  try
    frmCreateAccount := TfrmCreateAccount.Create(Application);
    if frmCreateAccount.ShowModal = mrOk then
    Begin
      loginParams.reg_PIVA :=
          frmCreateAccount.newAccountParams.reg_PIVA;
      loginParams.reg_username :=
          frmCreateAccount.newAccountParams.reg_username;
      loginParams.reg_password :=
          frmCreateAccount.newAccountParams.reg_password;
    End;
  finally
    FreeAndNil(frmCreateAccount);
  end;
end;

procedure TfrmLogin.btnOkClick(Sender: TObject);
begin
 ckLogin;
end;

procedure TfrmLogin.cbThemesCloseUp(Sender: TObject);
begin
 currentTheme := cbThemes.Text;
end;



procedure TfrmLogin.ckLogin;
var
  va: TValidateAccount;
  esito: Boolean;

begin

  esito := false;
  loginParams := LoginAccPanel.getData;
  if not loginParams.compilato then
    raise Exception.Create('Login form is not completed');

  dmXtumble.XtConnection.Connected := false;
  dmXtumble.XtConnection.CompanyID := loginParams.reg_PIVA;

  dmXtumble.XtConnection.userName := loginParams.reg_username;
  dmXtumble.XtConnection.password := loginParams.reg_password;


  va := dmXtumble.XtConnection.ValidateAccount;
  dmXtumble.XtConnection.Connected := True;


  if not(va.Success or va.Ok) then
  begin
    if MessageDlg('Xtumble Account was not found, check data',
      TMsgDlgType.mtError, [TMsgDlgBtn.mbRetry, TMsgDlgBtn.mbCancel], 0) = mrCancel
    then
      exit
    else
      ckLogin;
  end
  else
  Begin
    dmXtumble.companyId := loginParams.reg_PIVA;
    dmXtumble.UserName  := loginParams.reg_username;
    dmXtumble.saveSettings;
    Application.CreateForm(TfrmMain,frmMain);
    Close;
  End;
end;


procedure TfrmLogin.createLoginPanel;
begin
  LoginAccPanel := TRecordEditorPanel<TLoginXTAccountParams>.Create(Self);
  LoginAccPanel.Top := 0;
  LoginAccPanel.Left := 0;
//  LoginAccPanel.Align := TAlign.alTop;
  LoginAccPanel.Width := 400;
  LoginAccPanel.AlignWithMargins := True;


  LoginAccPanel.Margins.Top := 20;
  LoginAccPanel.Margins.Bottom := 20;

//  LoginAccPanel.DisplayLabels := ['Ragione Sociale','Partita IVA o Codice Fiscale','Nome','Cognome','Nome Utente','Password','Mail','Codice Rivenditore','Nazione (due cifre)'];
  LoginAccPanel.DisplayLabels := ['VAT Number','User name','#Password'];
  LoginAccPanel.Parent := pnlLogin;
  LoginAccPanel.Align := TAlign.alLeft;
  LoginAccPanel.Margins.Left := (pnlLogin.Width - LoginAccPanel.Width) div 2;
  LoginAccPanel.CurrentPos := LoginAccPanel.CurrentPos + 20;
  LoginAccPanel.data := loginParams;
  LoginAccPanel.Height := LoginAccPanel.Height + 200;
end;


procedure TfrmLogin.FormClose(Sender: TObject; var Action: TCloseAction);
begin
 Action := caFree;
end;

procedure TfrmLogin.FormCreate(Sender: TObject);
begin
 lblServer.Caption := //'Xtumble provider:' +
    dmXtumble.XtConnection.ConnectionParams.ServerAddress;
end;

procedure TfrmLogin.FormShow(Sender: TObject);
begin
 loginParams.reg_PIVA := dmXtumble.companyId;
 loginParams.reg_username := dmXtumble.UserName;
 createLoginPanel;
end;

procedure TfrmLogin.lblServerClick(Sender: TObject);
var
  serverAddress: string;
begin
 serverAddress := lblServer.Caption;
 if InputQuery('server address','server address',serverAddress) then
  Begin
    dmXtumble.xTumbleServerAddress := serverAddress;
    dmXtumble.saveSettings;
    lblServer.Caption := serverAddress;
  End;
end;

procedure TfrmLogin.llXtumbleClick(Sender: TObject);
begin
 ShellExecute(0,'open',PChar('https://xtumble.com'),'','',SW_NORMAL);
end;

procedure TfrmLogin.llXtumbleMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
begin
 ShellExecute(0,'open','https://xtumble.com','','',SW_NORMAL);
end;

procedure TfrmLogin.SetcurrentTheme(const Value: String);
begin
  try

  if (FCurrentTheme <> Value) then
   Begin
    if Value = 'Nessun Tema' then
     Begin
       StyleEnabled := False;
     End
    Else
     Begin
       StyleEnabled := True;

       TStyleManager.SetStyle(Value);
     End;
    FCurrentTheme := Value;
//    IDlg.SetValue('CUSTOM','MAIN_THEME',Value);
//    IDlg.SalvaModifiche;

   


   End;
  except

  end;
end;

procedure TfrmLogin.SetStyleEnabled(const Value: Boolean);
begin
FStyleEnabled := Value;
  if Value then
   Begin
//    IDlg.SetValue('User','StyleEnabled','True');
    try TStyleManager.Engine.UnRegisterStyleHook(TForm,TStyleHook); except end;
    sleep(100);
    FcurrentTheme := '';
   End
  Else
   begin
    try
//    IDlg.SetValue('User','StyleEnabled','False');
    TStyleManager.Engine.RegisterStyleHook(TForm,TStyleHook);
    sleep(100);
    TStyleManager.Engine.UnRegisterStyleHook(TForm,TStyleHook);
    sleep(100);
    TStyleManager.Engine.RegisterStyleHook(TForm,TStyleHook);
    except

    end;
   end;
//  IDlg.SalvaModifiche;

//  StyleEnabled1.Checked := Value;
end;

procedure TfrmLogin.themeList;
var
  style: string;
begin
 try
  cbThemes.Items.Clear;

  try

   cbThemes.Items.add('Nessun Tema');
   for style in TStyleManager.StyleNames do
      cbThemes.Items.add(style);

   cbThemes.ItemIndex := cbThemes.Items.IndexOf(currentTheme);
//   DlgRadioGroupGeneric.rg.ItemIndex := DlgRadioGroupGeneric.rg.Items.IndexOf(currentTheme);
//
//   If DlgRadioGroupGeneric.ShowModal = mrOk then
//     currentTheme := DlgRadioGroupGeneric.rg.Items[DlgRadioGroupGeneric.rg.ItemIndex];
  except

  end;

 finally
//  DlgRadioGroupGeneric.Free;
 end;
end;

end.
