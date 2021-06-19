program XtumbleDemo;

uses
  Vcl.Forms,
  uFrmMain in 'uFrmMain.pas' {frmMain},
  uFrmUsers in 'uFrmUsers.pas' {frmUsers},
  uFrmContacts in 'uFrmContacts.pas' {frmContacts},
  uFrmArticles in 'uFrmArticles.pas' {frmArticles},
  uFrmDrive in 'uFrmDrive.pas' {frmDrive},
  uFrmMails in 'uFrmMails.pas' {frmMails},
  uFrmSettings in 'uFrmSettings.pas' {frmSettings},
  Vcl.Themes,
  Vcl.Styles,
  ufrmDashboard in 'ufrmDashboard.pas' {frmDashboard},
  uFrmLogin in 'uFrmLogin.pas' {frmLogin},
  pasDmXtumble in 'pasDmXtumble.pas' {dmXtumble: TDataModule},
  uVCLUtils in 'uVCLUtils.pas',
  uFrmCreateXTAccount in 'uFrmCreateXTAccount.pas' {frmCreateAccount},
  uFrmMailComposer in 'uFrmMailComposer.pas' {frmMailComposer},
  uCommon in 'uCommon.pas',
  uFrmMailTemplate in 'uFrmMailTemplate.pas' {frmMailTemplate},
  uFrmMailTemplates in 'uFrmMailTemplates.pas' {frmMailTemplates},
  uFrmMailingList in 'uFrmMailingList.pas' {frmMailingList},
  uFrmDriveSearch in 'uFrmDriveSearch.pas' {frmDriveSearch},
  uFrmSubscriptions in 'uFrmSubscriptions.pas' {frmSubscriptions},
  uFrmShopOrders in 'uFrmShopOrders.pas' {frmShopOrders};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;

  TStyleManager.TrySetStyle('Slate Classico');
  Application.Title := 'Xtumble4Delphi Demo';
  Application.CreateForm(TdmXtumble, dmXtumble);
  //  ############################################
//  IL FORM PRINCIPALE DELL'APPLICAZIONE E' IL PRIMO
//  FORM CHE VIENE CREATO CON L'ISTRUZIONE Application.CreateForm(Tfrmxxx, frmxxxx);
//  ##############################################
//  Application.CreateForm(TfrmLogin, frmLogin);
  frmLogin := TfrmLogin.Create(nil);
  frmLogin.ShowModal;
  Application.Run;
end.
