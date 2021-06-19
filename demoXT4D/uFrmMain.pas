unit uFrmMain;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.ExtCtrls, Vcl.ComCtrls,
  Vcl.StdCtrls, Vcl.CategoryButtons, ufrmDashboard, uFrmContacts, uFrmArticles,
  pasDmXtumble, uFrmDrive, uFrmMails, uFrmMailTemplates, uFrmMailingList;

type
     
  TfrmMain = class(TForm)
    CategoryPanelGroup1: TCategoryPanelGroup;
    cpXtumbeERP: TCategoryPanel;
    cpxtSettings: TCategoryPanel;
    StatusBar1: TStatusBar;
    MainMenu1: TMainMenu;
    btnArticles: TButton;
    btnContacts: TButton;
    btnSettings: TButton;
    btnDashboard: TButton;
    pnlMain: TPanel;
    pnlContainer: TPanel;
    pnlLogs: TPanel;
    pgLogs: TPageControl;
    tsLog: TTabSheet;
    TabSheet2: TTabSheet;
    MemoLog: TMemo;
    Splitter1: TSplitter;
    CategoryPanel1: TCategoryPanel;
    btnDrive: TButton;
    cpCRM: TCategoryPanel;
    btnMails: TButton;
    btnMailTemplates: TButton;
    btnMailingList: TButton;
    cpxtSubscriiptions: TCategoryPanel;
    btnSubscriptions: TButton;
    btnOrders: TButton;
    procedure btnDashboardClick(Sender: TObject);
    procedure btnContactsClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure btnArticlesClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnDriveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnMails_Click(Sender: TObject);
    procedure FormCloseQuery(Sender: TObject; var CanClose: Boolean);
    procedure btnMailTemplates_Click(Sender: TObject);
    procedure btnMailingListClick(Sender: TObject);
    procedure btnOrdersClick(Sender: TObject);
  private
    
    { Private declarations }
  public
    { Public declarations }
    function test<T>(AForm : TForm) : T;
  end;

var
  frmMain: TfrmMain;

implementation

{$R *.dfm}

uses TypInfo, Rtti, uFrmShopOrders;

procedure TfrmMain.btnArticlesClick(Sender: TObject);
begin
 if frmArticles = nil then
  begin
    frmArticles := TfrmArticles.Create(nil);
    dmXtumble.embedForm(frmArticles, pnlMain);
  end
 else
    frmArticles.Show;

end;

procedure TfrmMain.btnContactsClick(Sender: TObject);
begin
  if frmContacts = nil then
  begin
    frmContacts := TfrmContacts.Create(nil);
    dmXtumble.embedForm(frmContacts, pnlMain);
  end
 else
    frmContacts.Show;
end;

procedure TfrmMain.btnDashboardClick(Sender: TObject);
begin
//  frmDashboard := test<TfrmDashboard>(nil);
  if frmDashboard = nil then
  begin
    frmDashboard := TfrmDashboard.Create(nil);
    dmXtumble.embedForm(frmDashboard,pnlMain);
  end
 else
    frmDashboard.Show;
end;

procedure TfrmMain.btnDriveClick(Sender: TObject);
begin
 if frmDrive = nil then
  begin
    frmDrive := TfrmDrive.Create(nil);
    dmXtumble.embedForm(frmDrive,pnlMain);
  end
 else
  frmDrive.Show;
end;

procedure TfrmMain.btnMailingListClick(Sender: TObject);
begin
 if frmMailingList = nil then
  begin
    frmMailingList := TfrmMailingList.Create(nil);
    dmXtumble.embedForm(frmMailingList,pnlMain);
  end
 else
  frmMailingList.Show;
end;

procedure TfrmMain.btnMails_Click(Sender: TObject);
begin
  if frmMails = nil then
  begin
    frmMails := TfrmMails.Create(nil);
    dmXtumble.embedForm(frmMails,pnlMain);
  end
 else
  frmMails.Show;
end;

procedure TfrmMain.btnMailTemplates_Click(Sender: TObject);
begin
 if frmMailTemplates = nil then
  begin
    frmMailTemplates := TfrmMailTemplates.Create(nil);
    dmXtumble.embedForm(frmMailTemplates,pnlMain);
  end
 else
  frmMailTemplates.Show;
end;


procedure TfrmMain.btnOrdersClick(Sender: TObject);
begin
 if frmShopOrders = nil then
  begin
    frmShopOrders := TfrmShopOrders.Create(nil);
    dmXtumble.embedForm(frmShopOrders, pnlMain);
  end
 else
    frmShopOrders.Show;
end;

procedure TfrmMain.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TfrmMain.FormCloseQuery(Sender: TObject; var CanClose: Boolean);
begin
  Application.Terminate;
end;

procedure TfrmMain.FormCreate(Sender: TObject);
begin
 pnlLogs.Visible := False;
 btnDashboardClick(nil);
end;

procedure TfrmMain.FormShow(Sender: TObject);
begin
 StatusBar1.Panels[0].Text := dmXtumble.XtConnection.CompanyID;
 StatusBar1.Panels[1].Text := dmXtumble.XtConnection.userName;
 StatusBar1.Panels[2].Text := dmXtumble.XtConnection.ConnectionParams.ServerAddress;
end;

function TfrmMain.test<T>(AForm : TForm) : T;
var
 ctx: TRttiContext;
  LType: TRttiType;

begin
 if AForm = nil then
  Begin
   ctx:= TRttiContext.Create;
   LType := ctx.GetType(typeInfo(T));
//   result := LType.GetMethod('create').Invoke(typeInfo(T),[nil]).AsType<T>;
   result := LType.GetMethod('create').Invoke(typeInfo(T),[nil]).AsType<T>;
   //result := embedForm(TValue.From(Result).AsType<TForm>;
   dmXtumble.embedForm(TValue.From(Result).AsType<TForm>,pnlMain);
  End
 Else
  AForm.Show;
end;

end.
