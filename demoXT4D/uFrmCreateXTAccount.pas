unit uFrmCreateXTAccount;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Imaging.pngimage, Vcl.ExtCtrls,
  Vcl.StdCtrls, uVCLUtils, pasDmXtumble, Vcl.WinXCtrls,xtCommonTypes;

type
  TfrmCreateAccount = class(TForm)
    pnlBottom: TPanel;
    btnRegister: TButton;
    btnClose: TButton;
    Image1: TImage;
    pnlCreateAccount: TPanel;
    pnlWait: TPanel;
    ActivityIndicator1: TActivityIndicator;
    procedure btnRegisterClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }

    RegAccPanel: TRecordEditorPanel<TCreateXTAccountParams>;
    procedure createRegAccountPanel;
    procedure doWait;
    procedure endWait;
    procedure afterAccountRegistration(regData: TCreateXTAccountParams; esitoReg: TEsitoRegistrazioneAccount);
  public
    { Public declarations }
    newAccountParams : TCreateXTAccountParams;
  end;

var
  frmCreateAccount: TfrmCreateAccount;

implementation

{$R *.dfm}

{ TfrmCreateAccount }

procedure TfrmCreateAccount.afterAccountRegistration(
  regData: TCreateXTAccountParams; esitoReg: TEsitoRegistrazioneAccount);
var
  regDataAcc: TLoginXTAccountParams;
begin
  //  th.OnTerminate := procedure (Sender : TObject) begin
  endWait;
  if esitoReg.registratoCorrettamente then
  begin
    regDataAcc.reg_PIVA := regData.reg_PIVA;
    regDataAcc.reg_username := regData.reg_username;
    regDataAcc.reg_password := regData.reg_password;
    if MessageDlg('Check your eMail and click on activation link ', TMsgDlgType.mtInformation, [TMsgDlgBtn.mbOK, TMsgDlgBtn.mbCancel], 0, TMsgDlgBtn.mbOK) = mrOk then
       modalResult := mrOk
    else
       btnRegister.Enabled := True;
  end
  else
  begin
    btnRegister.Enabled := True;
    MessageDlg('Registrazione non riuscita, errore: [' + esitoReg.errorCode.ToString + '] ' + esitoReg.messaggio, TMsgDlgType.mtError, [TMsgDlgBtn.mbOK], 0, TMsgDlgBtn.mbOK);
    btnRegister.Enabled := True;
  end;
end;

procedure TfrmCreateAccount.btnRegisterClick(Sender: TObject);
var
  regData: TCreateXTAccountParams;
  esitoReg: TEsitoRegistrazioneAccount;
  th: TThread;
begin
 try
  if not btnRegister.Enabled then exit;

  regData := RegAccPanel.getData;

  if not regData.compilato then
    raise Exception.Create('Non tutti i campi necessari sono stati compialti');

  btnRegister.Enabled := False;

  doWait;


  th := TThread.CreateAnonymousThread(
         procedure begin
            esitoReg := dmXtumble.XtConnection.registerAccount(regData);
            TThread.Synchronize(nil,procedure begin afterAccountRegistration(regData, esitoReg) end);
         end);
  th.FreeOnTerminate := True;
  th.Start;

//  th.OnTerminate := procedure ( Sender : TObject) of object begin
//
//     End;

 finally
  // endWait;
 end;
end;

procedure TfrmCreateAccount.createRegAccountPanel;
begin
  RegAccPanel := TRecordEditorPanel<TCreateXTAccountParams>.Create(Self);
  RegAccPanel.Top := 0;
  RegAccPanel.Left := 0;
//  RegAccPanel.Align := TAlign.alTop;
  RegAccPanel.Width := 600;


  RegAccPanel.Margins.Top := 50;
  RegAccPanel.Margins.Bottom := 50;

//  RegAccPanel.DisplayLabels := ['Ragione Sociale','Partita IVA o Codice Fiscale','Nome','Cognome','Nome Utente','Password','Mail','Codice Rivenditore','Nazione (due cifre)'];
  RegAccPanel.DisplayLabels := ['Company Name','VAT Number','#@#','#@#','User name','#Password','Mail','Reseller code','#@#'];
  RegAccPanel.Parent := pnlCreateAccount;
  RegAccPanel.Align := TAlign.alLeft;
  RegAccPanel.Margins.Left := (pnlCreateAccount.Width - Self.Width) div 2;
  RegAccPanel.CurrentPos := RegAccPanel.CurrentPos + 20;
  RegAccPanel.data := newAccountParams;

  RegAccPanel.Height := RegAccPanel.Height + 200;
end;

procedure TfrmCreateAccount.doWait;
begin
 btnClose.Enabled := False;
 btnRegister.Enabled := False;
 pnlWait.Visible := True;
 ActivityIndicator1.Animate := True;
end;

procedure TfrmCreateAccount.endWait;
begin
 pnlWait.Visible := False;
 pnlWait.BringToFront;
 ActivityIndicator1.Enabled := False;
end;

procedure TfrmCreateAccount.FormCreate(Sender: TObject);
begin
  pnlWait.Visible := False;
 createRegAccountPanel;
end;

end.
