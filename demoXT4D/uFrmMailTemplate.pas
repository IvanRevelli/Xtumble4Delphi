unit uFrmMailTemplate;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ToolWin, Vcl.StdCtrls,
  Vcl.ExtCtrls, xtCommonTypes, pasDmXtumble, uxtCommonComponent, xtSendMail,
  Vcl.Menus, uCommon, uXtDriveCommands;

type

  TProcAfterSaveTemplate = procedure (id_template_attachment : Int64; MailTemplate : TMAIL_BATCH) of object;



  TfrmMailTemplate = class(TForm)
    gbMailDetails: TGroupBox;
    Panel4: TPanel;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    edMailFrom: TEdit;
    edMailFromName: TEdit;
    edSubject: TEdit;
    PageControl2: TPageControl;
    tsBody: TTabSheet;
    MemoBody: TMemo;
    tsMailAttach: TTabSheet;
    lvFiles: TListView;
    ToolBar3: TToolBar;
    tsSaveMailTemplate: TToolButton;
    ToolButton10: TToolButton;
    tlBtnSaveAsSystemTemplate: TToolButton;
    pnlHeader: TPanel;
    popAttachments: TPopupMenu;
    Insertinmessagebody1: TMenuItem;
    MenuItem1: TMenuItem;
    Addfromyourcomputer1: TMenuItem;
    Addfromgallery1: TMenuItem;
    MenuItem2: TMenuItem;
    Removeselected1: TMenuItem;
    RemoveAll1: TMenuItem;
    N3: TMenuItem;
    Refresh2: TMenuItem;
    popBody: TPopupMenu;
    LoadFromFile1: TMenuItem;
    SaveToFile1: TMenuItem;
    N2: TMenuItem;
    LoadfromURL1: TMenuItem;
    xtSendMail1: TxtSendMail;
    xtDriveCommands: TxtDriveCommands;
    tsReports: TTabSheet;
    lvReports: TListView;
    popReports: TPopupMenu;
    AddReportTemplate1: TMenuItem;
    RemoveReport1: TMenuItem;
    procedure tsSaveMailTemplateClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure tlBtnSaveAsSystemTemplateClick(Sender: TObject);
    procedure Insertinmessagebody1Click(Sender: TObject);
    procedure Addfromyourcomputer1Click(Sender: TObject);
    procedure Addfromgallery1Click(Sender: TObject);
    procedure Removeselected1Click(Sender: TObject);
    procedure RemoveAll1Click(Sender: TObject);
    procedure Refresh2Click(Sender: TObject);
    procedure LoadFromFile1Click(Sender: TObject);
    procedure SaveToFile1Click(Sender: TObject);
    procedure AddReportTemplate1Click(Sender: TObject);
    procedure RemoveReport1Click(Sender: TObject);
  private
    Fcurrent_mail_template: TMAIL_BATCH;
    Fpk_allegato_template: Int64;
    Ftemplate_name: String;
    procedure Setcurrent_mail_template(const Value: TMAIL_BATCH);
    procedure Settemplate_name(const Value: String);


    procedure refreshAttList;
    procedure refreshReportList;

    { Private declarations }
  public
    { Public declarations }
    onAfterSaveTemplate : TProcAfterSaveTemplate;
    procedure saveMailTemplate(SaveAsSystemTemplate : Boolean = True);
    property pk_allegato_template : Int64 read Fpk_allegato_template;
    property template_name : String read Ftemplate_name write Settemplate_name;
    property current_mail_template : TMAIL_BATCH read Fcurrent_mail_template write Setcurrent_mail_template;
  end;

var
  frmMailTemplate: TfrmMailTemplate;

implementation

{$R *.dfm}

{ TfrmMailTemplate }

procedure TfrmMailTemplate.Addfromgallery1Click(Sender: TObject);
var
  Ltmp : TMAIL_BATCH_ATTACHMENTS;
  pk_id: Int64;
  attachment_remote_filename: string;
begin
 if inputquery('attachment remote filename:','attachment remote filename:',attachment_remote_filename) then
  Begin
//   pk_id := xtDriveCommands.uploadFile(dmXtumble.OD.FileName,'',-1);

   Ltmp.MIMETYPE := 'application/x-binary';
   Ltmp.FILENAME := ExtractFileName(attachment_remote_filename);
   Ltmp.ATTACHMENT_LINK := '';
   Ltmp.FK_ATTACHMENTS  := -1;
   Ltmp.ATTACHMENT_REMOTE_NAME := attachment_remote_filename;
   Fcurrent_mail_template.AttachmentList := current_mail_template.AttachmentList + [Ltmp];
  End;
 refreshAttList;
end;


procedure TfrmMailTemplate.Addfromyourcomputer1Click(Sender: TObject);
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
//   ATTACHMENT_REMOTE_NAME
   Fcurrent_mail_template.AttachmentList := current_mail_template.AttachmentList + [Ltmp];
  End;
 refreshAttList;
end;

procedure TfrmMailTemplate.AddReportTemplate1Click(Sender: TObject);
var
  Ltmp : TMAIL_BATCH_REPORTS;
  pk_id: Int64;
  LReport_Name: string;
  I: Integer;
  found: Boolean;
begin
 found := False;
 if inputquery('attachment remote filename:','attachment remote filename:',LReport_Name) then
  Begin
   if LReport_Name = '' then exit;
   Ltmp.REPORT_NAME := LReport_Name;

   for I := 0 to Length(current_mail_template.ReportList)-1 do
   Begin
    If lvReports.Selected.Caption.ToLower = current_mail_template.ReportList[I].report_name.tolower then
     Begin
       found := True;
       Break;
     End;
   End;

   if not found then
     Fcurrent_mail_template.ReportList := Fcurrent_mail_template.ReportList + [Ltmp];
  End;
 refreshReportList;
end;

procedure TfrmMailTemplate.FormCreate(Sender: TObject);
begin
 onAfterSaveTemplate := nil;
 lvFiles.Items.BeginUpdate;
 lvFiles.Items.Clear;
 lvFiles.Items.EndUpdate;
end;

procedure TfrmMailTemplate.Insertinmessagebody1Click(Sender: TObject);
var
  I: Integer;
  tmp: TArray<TMAIL_BATCH_ATTACHMENTS>;
  LAlias : String;
  attList: TArray<TMAIL_BATCH_ATTACHMENTS>;

begin
 if lvFiles.Selected = nil then exit;

 LAlias := current_mail_template.AttachmentList[TFileNode(lvFiles.Selected.Data).kid].ATTACHMENT_LINK;

 if LAlias = '' then
  Begin
   If inputQuery('specify attachment alias','specify attachment alias',Lalias) then
    Begin
     attList := current_mail_template.AttachmentList;
     attList[TFileNode(lvFiles.Selected.Data).kid].ATTACHMENT_LINK := LAlias;
     Fcurrent_mail_template.AttachmentList := attList;
    End;
  End;

 MemoBody.Lines.Add('<img src="cid:' + LAlias + '">');
end;

procedure TfrmMailTemplate.LoadFromFile1Click(Sender: TObject);
begin
 if dmXtumble.OD.Execute then
  MemoBody.Lines.LoadFromFile(dmXtumble.OD.FileName);
end;

procedure TfrmMailTemplate.Refresh2Click(Sender: TObject);
begin
 refreshAttList;
end;

procedure TfrmMailTemplate.refreshAttList;
var
  lvi: TListItem;
  LfileExt: string;
  I: Integer;
begin
 lvFiles.Items.BeginUpdate;
 lvFiles.Items.Clear;

 for I := 0 to Length(Fcurrent_mail_template.AttachmentList) -1 do
  Begin
   lvi := lvFiles.Items.Add;
   lvi.Caption := Fcurrent_mail_template.AttachmentList[I].FILENAME;
   lvi.SubItems.Add(Fcurrent_mail_template.AttachmentList[I].FK_ATTACHMENTS.ToString);
   lvi.SubItems.Add(Fcurrent_mail_template.AttachmentList[I].ATTACHMENT_LINK);

   lvi.Data := TFileNode.Create;
   TFileNode(lvi.Data).pk_id := Fcurrent_mail_template.AttachmentList[I].FK_ATTACHMENTS;
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

procedure TfrmMailTemplate.refreshReportList;
var
  lvi: TListItem;
  LfileExt: string;
  I: Integer;
begin


 lvReports.Items.BeginUpdate;
 lvReports.Items.Clear;

 for I := 0 to Length(Fcurrent_mail_template.ReportList) -1 do
  Begin
   lvi := lvReports.Items.Add;
   lvi.Caption := Fcurrent_mail_template.ReportList[I].REPORT_NAME;
  End;
 lvReports.Items.EndUpdate;
end;

procedure TfrmMailTemplate.saveMailTemplate(SaveAsSystemTemplate : Boolean = True);
var
  pk_id: Int64;
begin






  Fcurrent_mail_template.MAIL_FROM := edMailFrom.Text;
  Fcurrent_mail_template.FROM_NAME := edMailFromName.Text;
  Fcurrent_mail_template.SUBJECT := edSubject.Text;
  Fcurrent_mail_template.BODY := MemoBody.Text;
  Fcurrent_mail_template.TEMPLATE_NAME := template_Name;

  if SaveAsSystemTemplate then
   Begin
    pk_id := xtSendMail1.SaveAsSystemTemplate(current_mail_template, template_Name);
    ShowMessage('Template ID:' + pk_id.ToString);
   End
  Else
   Begin
     Fpk_allegato_template :=
      xtSendMail1.saveAsTemplateAttachment(Fcurrent_mail_template,template_name);

     ShowMessage('Attachment ID:' +  Fpk_allegato_template.ToString);

     if assigned(onAfterSaveTemplate) then
      onAfterSaveTemplate(pk_allegato_template,Fcurrent_mail_template);

   End;

end;

procedure TfrmMailTemplate.RemoveAll1Click(Sender: TObject);
begin
if MessageDlg('Remove all attachment from message? Are you sure?',mtConfirmation,[mbOk,mbCancel],0) = mrOk then
  Fcurrent_mail_template.AttachmentList := [];
refreshAttList;

end;

procedure TfrmMailTemplate.RemoveReport1Click(Sender: TObject);
var
  I: Integer;
  tmp: TArray<TMAIL_BATCH_REPORTS>;

begin
 if lvReports.Selected = nil then exit;

 tmp := [];
 for I := 0 to Length(current_mail_template.ReportList)-1 do
  Begin
   If lvReports.Selected.Caption <> current_mail_template.ReportList[I].report_name then
     tmp := tmp + [current_mail_template.ReportList[I]];
  End;
 Fcurrent_mail_template.ReportList := tmp;
 refreshReportList;
end;

procedure TfrmMailTemplate.Removeselected1Click(Sender: TObject);
var
  I: Integer;
  tmp: TArray<TMAIL_BATCH_ATTACHMENTS>;

begin
 if lvFiles.Selected = nil then exit;

 tmp := [];
 for I := 0 to Length(current_mail_template.AttachmentList)-1 do
  Begin
   If TFileNode(lvFiles.Selected.Data).kid <> I then
     tmp := tmp + [current_mail_template.AttachmentList[I]];
  End;
 Fcurrent_mail_template.AttachmentList := tmp;
 refreshAttList;
end;

procedure TfrmMailTemplate.SaveToFile1Click(Sender: TObject);
begin
  if dmXtumble.FSD.Execute then
    MemoBody.Lines.SaveToFile(dmXtumble.FSD.FileName);
end;

procedure TfrmMailTemplate.Setcurrent_mail_template(const Value: TMAIL_BATCH);
begin
 Fcurrent_mail_template := Value;

 edMailFrom.Text     := Value.MAIL_FROM;
 edMailFromName.Text := Value.FROM_NAME;
 edSubject.Text      := Value.SUBJECT;
 MemoBody.Text       := Value.BODY;

 refreshAttList;
 refreshReportList;
end;

procedure TfrmMailTemplate.Settemplate_name(const Value: String);
var
  doIt: Boolean;
  MS: TMemoryStream;
begin
  IF Ftemplate_name <> Value then
   Begin
     Ftemplate_name := Value;
     pnlHeader.Caption := Ftemplate_name;
     current_mail_template := xtSendMail1.getTemplate(Ftemplate_name);
   End;
end;

procedure TfrmMailTemplate.tlBtnSaveAsSystemTemplateClick(Sender: TObject);
begin
  saveMailTemplate;
end;

procedure TfrmMailTemplate.tsSaveMailTemplateClick(Sender: TObject);
begin
 Fcurrent_mail_template.MAIL_FROM := edMailFrom.Text;
 Fcurrent_mail_template.FROM_NAME := edMailFromName.Text;
 Fcurrent_mail_template.SUBJECT   := edSubject.Text;
 Fcurrent_mail_template.BODY      := MemoBody.Text;
 Fcurrent_mail_template.TEMPLATE_NAME := template_name;

 Fpk_allegato_template :=
  xtSendMail1.saveAsTemplateAttachment(Fcurrent_mail_template,template_name);

 ShowMessage('Attachment ID:' +  Fpk_allegato_template.ToString);

 if assigned(onAfterSaveTemplate) then
  onAfterSaveTemplate(pk_allegato_template,Fcurrent_mail_template);

end;

end.
