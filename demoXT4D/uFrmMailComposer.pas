unit uFrmMailComposer;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, uVCLUtils, pasDmXtumble,
  uxtCommonComponent, xtSendMail, Vcl.StdCtrls, Vcl.ComCtrls, uCommon, Vcl.Menus,
  uXtDriveCommands, xtCommonTypes;

type
  TMailMsg = record
    Mail_From : String;
    Mail_To   : String;
    CC        : String;
    BCC       : String;
    Subject   : String;
  end;


  TfrmMailComposer = class(TForm)
    pnlFooter: TPanel;
    pnlMailData: TPanel;
    xtSendMail1: TxtSendMail;
    btnSendMail: TButton;
    btnCancel: TButton;
    PageControl1: TPageControl;
    tsMailBody: TTabSheet;
    tsAttachments: TTabSheet;
    MemoBody: TMemo;
    lvFiles: TListView;
    popAttachments: TPopupMenu;
    Addfromyourcomputer1: TMenuItem;
    Addfromgallery1: TMenuItem;
    N1: TMenuItem;
    Removeselected1: TMenuItem;
    RemoveAll1: TMenuItem;
    xtDriveCommands: TxtDriveCommands;
    N2: TMenuItem;
    Insertinmessagebody1: TMenuItem;
    popMailMsg: TPopupMenu;
    Saveasmailtemplate1: TMenuItem;
    OpenMailTemplate1: TMenuItem;
    SaveasTemplate1: TMenuItem;
    procedure FormCreate(Sender: TObject);
    procedure btnSendMailClick(Sender: TObject);
    procedure RemoveAll1Click(Sender: TObject);
    procedure Removeselected1Click(Sender: TObject);
    procedure Addfromyourcomputer1Click(Sender: TObject);
    procedure Insertinmessagebody1Click(Sender: TObject);
    procedure Saveasmailtemplate1Click(Sender: TObject);
    procedure OpenMailTemplate1Click(Sender: TObject);
    procedure SaveasTemplate1Click(Sender: TObject);
  private
    FAttachmentList: TArray<TMAIL_BATCH_ATTACHMENTS>;
    procedure SetAttachmentList(const Value: TArray<TMAIL_BATCH_ATTACHMENTS>);
    { Private declarations }
  public
    { Public declarations }
    MailMSG : TMAIL_BATCH;
    MailComposerPanel: TRecordEditorPanel<TMailMsg>;
    property AttachmentList : TArray<TMAIL_BATCH_ATTACHMENTS> read FAttachmentList write SetAttachmentList;
  end;

var
  frmMailComposer: TfrmMailComposer;

implementation

{$R *.dfm}

procedure TfrmMailComposer.Addfromyourcomputer1Click(Sender: TObject);
var
  Ltmp : TMAIL_BATCH_ATTACHMENTS;
  pk_id: Int64;
begin
 if dmXtumble.od.execute then
  Begin
   pk_id := xtDriveCommands.uploadFile(dmXtumble.OD.FileName,'',-1);

   Ltmp.MIMETYPE := 'application/x-binary';
   Ltmp.FILENAME := ExtractFileName(dmXtumble.OD.FileName);
   Ltmp.ATTACHMENT_LINK := '';
   Ltmp.FK_ATTACHMENTS  := pk_id;
   AttachmentList := AttachmentList + [Ltmp];
  End;
end;

procedure TfrmMailComposer.btnSendMailClick(Sender: TObject);
var
 LMainMsg : TMAIL_BATCH;
 LMailPartial: TMailMsg;

begin
 LMailPartial := MailComposerPanel.data;

 LMainMsg.ID := -1;
 LMainMsg.MAIL_TO := LMailPartial.Mail_To;
 LMainMsg.SUBJECT := LMailPartial.Subject;
 LMainMsg.BODY    := MemoBody.Text;
 LMainMsg.MAIL_FROM := LMailPartial.Mail_From;
 LMainMsg.IS_HTML := 'S';
 LMainMsg.HAVE_ATTACHMENTS := 'S';
 LMainMsg.AttachmentList := AttachmentList;
 LMainMsg.FROM_NAME := LMailPartial.Mail_From;
 LMainMsg.FK_CUSTOM_MAIL_TEMPLATE := 0;
 LMainMsg.FK_USER := dmXtumble.XtConnection.UserId;

 ShowMessage(xtSendMail1.enqueMailMessage(LMainMsg).ToString);
 ModalResult := mrOk;
end;

procedure TfrmMailComposer.FormCreate(Sender: TObject);
var
 Lmsg : TMailMsg;
begin
  Lmsg.Mail_From := dmXtumble.XtConnection.UserMail;

  MailComposerPanel := TRecordEditorPanel<TMailMsg>.Create(Self);
  MailComposerPanel.Top := 0;
  MailComposerPanel.Left := 0;
//  MailComposerPanel.Align := TAlign.alTop;
  MailComposerPanel.Width := 600;

  MailComposerPanel.Margins.Top := 50;
  MailComposerPanel.Margins.Bottom := 50;

//  MailComposerPanel.DisplayLabels := ['#@#','Mail to','VAT Number','#@#','#@#','User name','#Password','Mail','Reseller code','#@#'];
  MailComposerPanel.Parent := pnlMailData;
  MailComposerPanel.Align := TAlign.alLeft;
  MailComposerPanel.Margins.Left := (MailComposerPanel.Width - Self.Width) div 2;
  MailComposerPanel.CurrentPos := MailComposerPanel.CurrentPos + 20;
  MailComposerPanel.data := Lmsg;
//  MailComposerPanel.refreshFields;

  MailComposerPanel.Height := MailComposerPanel.Height + 200;
end;

procedure TfrmMailComposer.Insertinmessagebody1Click(Sender: TObject);
var
  I: Integer;
  tmp: TArray<TMAIL_BATCH_ATTACHMENTS>;
  LAlias : String;
  attList: TArray<TMAIL_BATCH_ATTACHMENTS>;

begin
 if lvFiles.Selected = nil then exit;


 LAlias := AttachmentList[TFileNode(lvFiles.Selected.Data).kid].ATTACHMENT_LINK;

 if LAlias = '' then
  Begin
   If inputQuery('specify attachment alias','specify attachment alias',Lalias) then
    Begin
     attList := AttachmentList;
     attList[TFileNode(lvFiles.Selected.Data).kid].ATTACHMENT_LINK := LAlias;
     AttachmentList := attList;
    End;
  End;

 MemoBody.Lines.Add('<img src="cid:' + LAlias + '">');
End;


procedure TfrmMailComposer.OpenMailTemplate1Click(Sender: TObject);
var
 LMainMsg : TMAIL_BATCH;
 LMailPartial: TMailMsg;

begin
 if dmXtumble.OD.Execute then
  Begin
   LMainMsg := xtSendMail1.LoadFromFile(dmXtumble.OD.FileName);



   LMailPartial.Mail_To:=     LMainMsg.MAIL_TO             ;
   LMailPartial.Subject:=     LMainMsg.SUBJECT             ;
   MemoBody.Text:=            LMainMsg.BODY                ;
   LMailPartial.Mail_From:=   LMainMsg.MAIL_FROM           ;
   LMailPartial.Mail_From  := LMainMsg.FROM_NAME           ;

   // ##############################################
   MailComposerPanel.data := LMailPartial;
   AttachmentList    := LMainMsg.AttachmentList;
  End;
end;

procedure TfrmMailComposer.RemoveAll1Click(Sender: TObject);
begin
 if MessageDlg('Remove all attachment from message? Are you sure?',mtConfirmation,[mbOk,mbCancel],0) = mrOk then
  AttachmentList := [];

end;

procedure TfrmMailComposer.Removeselected1Click(Sender: TObject);
var
  I: Integer;
  tmp: TArray<TMAIL_BATCH_ATTACHMENTS>;

begin
 if lvFiles.Selected = nil then exit;

 tmp := [];
 for I := 0 to Length(AttachmentList)-1 do
  Begin
   If TFileNode(lvFiles.Selected.Data).kid <> I then
     tmp := tmp + [AttachmentList[I]];
  End;
 AttachmentList := tmp;
end;

procedure TfrmMailComposer.Saveasmailtemplate1Click(Sender: TObject);
var
 LMainMsg : TMAIL_BATCH;
 LMailPartial: TMailMsg;

begin

 if dmXtumble.FSD.Execute then
  Begin
     LMailPartial := MailComposerPanel.data;

     LMainMsg.ID := -1;
     LMainMsg.MAIL_TO := LMailPartial.Mail_To;
     LMainMsg.SUBJECT := LMailPartial.Subject;
     LMainMsg.BODY    := MemoBody.Text;
     LMainMsg.MAIL_FROM := LMailPartial.Mail_From;
     LMainMsg.IS_HTML := 'S';
     LMainMsg.HAVE_ATTACHMENTS := 'S';
     LMainMsg.AttachmentList := AttachmentList;
     LMainMsg.FROM_NAME := LMailPartial.Mail_From;
     LMainMsg.FK_CUSTOM_MAIL_TEMPLATE := 0;
     LMainMsg.FK_USER := dmXtumble.XtConnection.UserId;

     xtSendMail1.SaveToFile(LMainMsg,dmXtumble.FSD.FileName);
  End;
end;

procedure TfrmMailComposer.SaveasTemplate1Click(Sender: TObject);
var
 LMainMsg : TMAIL_BATCH;
 LMailPartial: TMailMsg;
  template_name: string;

begin
  if InputQuery('template_name','template_name',template_name) then
   Begin
     LMailPartial := MailComposerPanel.data;

     LMainMsg.ID := -1;
     LMainMsg.MAIL_TO := LMailPartial.Mail_To;
     LMainMsg.SUBJECT := LMailPartial.Subject;
     LMainMsg.BODY    := MemoBody.Text;
     LMainMsg.MAIL_FROM := LMailPartial.Mail_From;
     LMainMsg.IS_HTML := 'S';
     LMainMsg.HAVE_ATTACHMENTS := 'S';
     LMainMsg.AttachmentList := AttachmentList;
     LMainMsg.FROM_NAME := LMailPartial.Mail_From;
     LMainMsg.FK_CUSTOM_MAIL_TEMPLATE := 0;
     LMainMsg.FK_USER := dmXtumble.XtConnection.UserId;

     xtSendMail1.SaveAsSystemTemplate(LMainMsg,template_name);
   End;
end;

procedure TfrmMailComposer.SetAttachmentList(
  const Value: TArray<TMAIL_BATCH_ATTACHMENTS>);
var
  lvi: TListItem;
  LfileExt: string;
  I: Integer;

begin
 FAttachmentList := Value;

 lvFiles.Items.BeginUpdate;
 lvFiles.Items.Clear;

 for I := 0 to Length(FAttachmentList) -1 do
  Begin
   lvi := lvFiles.Items.Add;
   lvi.Caption := FAttachmentList[I].FILENAME;
//   lvi.SubItems.Add(xtDSFilesFILE_SIZE.asString + ' Bytes');
   lvi.SubItems.Add(FAttachmentList[I].FK_ATTACHMENTS.ToString);
   lvi.SubItems.Add(FAttachmentList[I].ATTACHMENT_LINK);

   lvi.Data := TFileNode.Create;
   TFileNode(lvi.Data).pk_id := FAttachmentList[I].FK_ATTACHMENTS;
   TFileNode(lvi.Data).isPublic := false;
   TFileNode(lvi.Data).kid := I;

   LfileExt := ExtractFileExt(lvi.Caption).Replace('.','').ToLower;

   if LfileExt = 'dfm' then
     lvi.ImageIndex := 1
   else if LfileExt = 'html' then
     lvi.ImageIndex := 2
   else if LfileExt = 'js' then
     lvi.ImageIndex := 3
   else if LfileExt = 'json' then
     lvi.ImageIndex := 4
   else if (LfileExt = 'xls')or(LfileExt = 'xlsx') then
     lvi.ImageIndex := 5
   else if LfileExt = 'pas' then
     lvi.ImageIndex := 6
   else if LfileExt = 'pdf' then
     lvi.ImageIndex := 7
   else if LfileExt = 'php' then
     lvi.ImageIndex := 8
   else if (LfileExt = 'doc')or(LfileExt = 'docx') then
     lvi.ImageIndex := 9
   else if (LfileExt = 'jpg')or(LfileExt = 'jpeg')or(LfileExt = 'png')or(LfileExt = 'bmp')or(LfileExt = 'gif') then
     lvi.ImageIndex := 16
   else
     lvi.ImageIndex := 0;



  End;
 lvFiles.Items.EndUpdate;
end;


end.
