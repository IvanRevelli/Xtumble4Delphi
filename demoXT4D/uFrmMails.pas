unit uFrmMails;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, pasDmXtumble,
  uxtCommonComponent, xtSendMail, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, System.ImageList, Vcl.ImgList, Vcl.VirtualImageList,
  Vcl.BaseImageCollection, Vcl.ImageCollection, Data.DB, uXtDriveCommands,
  Vcl.Menus, FireDAC.Comp.DataSet, FireDAC.Comp.Client, xtDatasetEntity,
  Vcl.WinXCtrls, Vcl.ComCtrls, Vcl.ToolWin, Vcl.ExtCtrls, uCommon, Vcl.Grids,
  Vcl.DBGrids, xtCommonTypes, Vcl.DBCtrls, uFrmMailTemplates;

type
  TfrmMails = class(TForm)
    xtSendMail1: TxtSendMail;
    Splitter1: TSplitter;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    pnlCurrentCampaign: TPanel;
    xtDsCampaigns: TxtDatasetEntity;
    xtDSContacts: TxtDatasetEntity;
    popCampaigns: TPopupMenu;
    Addfolder1: TMenuItem;
    Deletefolder1: TMenuItem;
    N1: TMenuItem;
    Refresh1: TMenuItem;
    xtDriveCommands: TxtDriveCommands;
    dsContacts: TDataSource;
    xtDsCampContacts: TxtDatasetEntity;
    dsCampContacts: TDataSource;
    PageControl1: TPageControl;
    tsCampaignContact: TTabSheet;
    dbgCampainContacts: TDBGrid;
    tsAvailableContacts: TTabSheet;
    dbgContacts: TDBGrid;
    ToolBar2: TToolBar;
    ToolButton7: TToolButton;
    tlAddToCampain: TToolButton;
    tsAddToCampain: TToolButton;
    popContacts: TPopupMenu;
    tsRefresh: TToolButton;
    tsCampaignMailTemplate: TTabSheet;
    gbMailDetails: TGroupBox;
    ToolBar3: TToolBar;
    tsSaveMailTemplate: TToolButton;
    ToolButton10: TToolButton;
    xtDsCampaignsPK_ID: TIntegerField;
    xtDsCampaignsDESCRIZIONE: TStringField;
    xtDsCampaignsFK_CRM_TIPO_CAMPAGNA: TIntegerField;
    xtDsCampaignsDB_SYNC_ID: TIntegerField;
    xtDsCampaignsUID: TStringField;
    xtDsCampaignsFK_STATUS: TLargeintField;
    xtDsCampaignsSTART_DATE: TSQLTimeStampField;
    xtDsCampaignsEND_DATE: TSQLTimeStampField;
    xtDsCampaignsELIMINATA: TStringField;
    xtDsCampaignsCREATION_DATE: TSQLTimeStampField;
    xtDsCampaignsNAME: TStringField;
    xtDsCampaignsFK_ALLEGATO_TEMPLATE: TLargeintField;
    Panel4: TPanel;
    Label1: TLabel;
    edMailFrom: TEdit;
    Label2: TLabel;
    edMailFromName: TEdit;
    Label3: TLabel;
    edSubject: TEdit;
    popBody: TPopupMenu;
    LoadFromFile1: TMenuItem;
    SaveToFile1: TMenuItem;
    N2: TMenuItem;
    LoadfromURL1: TMenuItem;
    PageControl2: TPageControl;
    tsBody: TTabSheet;
    tsMailAttach: TTabSheet;
    MemoBody: TMemo;
    lvFiles: TListView;
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
    popCampContacts: TPopupMenu;
    ToolBar1: TToolBar;
    ToolButton5: TToolButton;
    xtDsCampContactsPK_ID: TLargeintField;
    xtDsCampContactsFK_CAMPAIGN: TLargeintField;
    xtDsCampContactsFK_CRM_CONTACT: TLargeintField;
    xtDsCampContactsMAIL: TStringField;
    xtDsCampContactsNAME: TStringField;
    xtDsCampContactsADDRESS: TStringField;
    xtDsCampContactsMOBILE_PHONE: TStringField;
    xtDsCampContactsCOMPANY_NAME: TStringField;
    xtDsCampContactsFK_MAIL_BATCH: TLargeintField;
    xtDsCampContactsUNSUBSCRIBED: TStringField;
    xtDSContactsPK_ID: TLargeintField;
    xtDSContactsMAIL: TStringField;
    xtDSContactsATTIVO: TStringField;
    xtDSContactsFK_IDCONTATTO: TLargeintField;
    xtDSContactsEXTERNAL_KEY: TStringField;
    xtDSContactsNAME: TStringField;
    xtDSContactsADDRESS: TStringField;
    xtDSContactsOFFICE_PHONE: TStringField;
    xtDSContactsMOBILE_PHONE: TStringField;
    xtDSContactsCITY: TStringField;
    xtDSContactsPOSTAL_CODE: TStringField;
    xtDSContactsROLE: TStringField;
    xtDSContactsCOMPANY_NAME: TStringField;
    xtDSContactsFK_GROUP: TLargeintField;
    xtDSContactsFK_STATUS: TLargeintField;
    xtDSContactsUNSUBSCRIBED: TStringField;
    tlBtnSaveAsSystemTemplate: TToolButton;
    pnlLeftMenu: TPanel;
    lvCampaigns: TListView;
    ToolBar4: TToolBar;
    tlbtnPlay: TToolButton;
    ToolButton2: TToolButton;
    tsReports: TTabSheet;
    ListView1: TListView;
    popReports: TPopupMenu;
    Resetsentflag1: TMenuItem;
    pnlFilters: TPanel;
    lblMailingList: TLabel;
    xtDSMailingList: TxtDatasetEntity;
    xtDSMailingListPK_ID: TLargeintField;
    xtDSMailingListDESCRIZIONE: TStringField;
    xtDSMailingListATTIVA: TStringField;
    xtDSMailingListDATA_CREAZIONE: TSQLTimeStampField;
    xtDSMailingListDATA_ULTIMA_COMUNICAZIONE: TSQLTimeStampField;
    xtDSMailingListEX_KEY: TStringField;
    dsMailingList: TDataSource;
    dblkMailingList: TDBLookupComboBox;
    Label4: TLabel;
    srcContacts: TSearchBox;
    tlBtnLoadFromSysTemplate: TToolButton;
    Sendtoselectedaddress1: TMenuItem;
    tlBtnAggiungiIndirizzo: TToolButton;
    procedure xtDsCampaignsAfterOpen(DataSet: TDataSet);
    procedure Addfolder1Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure lvCampaignsClick(Sender: TObject);
    procedure tsAvailableContactsShow(Sender: TObject);
    procedure xtDSContactsAfterPost(DataSet: TDataSet);
    procedure tsRefreshClick(Sender: TObject);
    procedure tsAddToCampainClick(Sender: TObject);
    procedure tsSaveMailTemplateClick(Sender: TObject);
    procedure LoadFromFile1Click(Sender: TObject);
    procedure SaveToFile1Click(Sender: TObject);
    procedure Insertinmessagebody1Click(Sender: TObject);
    procedure Addfromyourcomputer1Click(Sender: TObject);
    procedure Removeselected1Click(Sender: TObject);
    procedure RemoveAll1Click(Sender: TObject);
    procedure Refresh2Click(Sender: TObject);
    procedure dbgCampainContactsDrawColumnCell(Sender: TObject;
      const Rect: TRect; DataCol: Integer; Column: TColumn;
      State: TGridDrawState);
    procedure tlbtnPlayClick(Sender: TObject);
    procedure ToolButton5Click(Sender: TObject);
    procedure dbgContactsDrawColumnCell(Sender: TObject; const Rect: TRect;
      DataCol: Integer; Column: TColumn; State: TGridDrawState);
    procedure dbgContactsTitleClick(Column: TColumn);
    procedure tlBtnSaveAsSystemTemplateClick(Sender: TObject);
    procedure Addfromgallery1Click(Sender: TObject);
    procedure Resetsentflag1Click(Sender: TObject);
    procedure dblkMailingListCloseUp(Sender: TObject);
    procedure srcContactsInvokeSearch(Sender: TObject);
    procedure Deletefolder1Click(Sender: TObject);
    procedure tlBtnLoadFromSysTemplateClick(Sender: TObject);
    procedure Sendtoselectedaddress1Click(Sender: TObject);
    procedure tlBtnAggiungiIndirizzoClick(Sender: TObject);
  private
    Fcurrent_campaign_name : String;
    Fcurrent_campaign_id: Int64;
    Fcurrent_mail_template: TMAIL_BATCH;
    procedure Setcurrent_campaign_id(const Value: Int64);
    procedure Setcurrent_mail_template(const Value: TMAIL_BATCH);
    procedure refreshAttList;
    procedure openAvailableContacts;
    { Private declarations }
  public
    { Public declarations }
    emptyMailTemplate : TMAIL_BATCH;
    procedure refreshCampains;
    property current_campaign_name : String read Fcurrent_campaign_name;
    property current_campaign_id : Int64 read Fcurrent_campaign_id write Setcurrent_campaign_id;
    property current_mail_template : TMAIL_BATCH read Fcurrent_mail_template write Setcurrent_mail_template;
  end;

var
  frmMails: TfrmMails;

implementation

{$R *.dfm}

procedure TfrmMails.Addfolder1Click(Sender: TObject);
var
  campName: string;
begin
  if inputQuery('Campaign name','Campaign Name',campName) then
   Begin
    xtDsCampaigns.Insert;
    xtDsCampaignsNAME.AsString := campName;
    xtDsCampaigns.Post;
    xtDsCampaigns.xtApplyUpdates;
   End;
  refreshCampains;
end;

procedure TfrmMails.Addfromgallery1Click(Sender: TObject);
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

procedure TfrmMails.Addfromyourcomputer1Click(Sender: TObject);
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

procedure TfrmMails.dbgCampainContactsDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
 if xtDsCampContactsUNSUBSCRIBED.AsString = 'S' then
  Begin
   dbgCampainContacts.Canvas.Brush.Color:= $00A4A4FF;
  End
 else if xtDsCampContactsFK_MAIL_BATCH.IsNull then
  Begin
    dbgCampainContacts.Canvas.Brush.Color:=$00D9FFD9;
//    dbgCampainContacts.Canvas.Font.Color:=fg;
  End;
  dbgCampainContacts.DefaultDrawColumnCell(Rect,Column.Index, Column,State);
end;

procedure TfrmMails.dbgContactsDrawColumnCell(Sender: TObject;
  const Rect: TRect; DataCol: Integer; Column: TColumn; State: TGridDrawState);
begin
 if xtDsContactsUNSUBSCRIBED.AsString = 'S' then
  Begin
   dbgContacts.Canvas.Brush.Color:= $00A4A4FF;
  End;
  dbgContacts.DefaultDrawColumnCell(Rect,Column.Index, Column,State);
end;

procedure TfrmMails.dbgContactsTitleClick(Column: TColumn);
begin
 if TFDMemTable(Column.Field.DataSet).IndexFieldNames <> Column.Field.FieldName then
  TFDMemTable(Column.Field.DataSet).IndexFieldNames := Column.Field.FieldName
 Else
  TFDMemTable(Column.Field.DataSet).IndexFieldNames := Column.Field.FieldName;
end;

procedure TfrmMails.dblkMailingListCloseUp(Sender: TObject);
begin
 openAvailableContacts;
end;

procedure TfrmMails.Deletefolder1Click(Sender: TObject);
var
  tmp_camp_id: Int64;
begin
 if lvCampaigns.selected = nil then exit;

 tmp_camp_id :=
     TEntityNode(lvCampaigns.selected.Data).pk_id;

 if MessageDlg('Do you really want to delete selected ['+ lvCampaigns.selected.Caption +'] campaign? ',mtConfirmation,mbYesNo,0) = mrYes then
  Begin
   if xtDsCampaigns.Locate('pk_id',tmp_camp_id) then
    Begin
      xtDsCampaigns.Delete;
      refreshCampains;
    End;

  End;

end;

procedure TfrmMails.FormCreate(Sender: TObject);
begin
 xtDsCampaigns.Open;
// refreshCampains;
end;

procedure TfrmMails.Insertinmessagebody1Click(Sender: TObject);
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

procedure TfrmMails.LoadFromFile1Click(Sender: TObject);
begin
 if dmXtumble.OD.Execute then
  MemoBody.Lines.LoadFromFile(dmXtumble.OD.FileName);
end;

procedure TfrmMails.lvCampaignsClick(Sender: TObject);
begin
 if lvCampaigns.selected = nil then exit;

 current_campaign_id :=
     TEntityNode(lvCampaigns.selected.Data).pk_id;
end;

procedure TfrmMails.Refresh2Click(Sender: TObject);
begin
 refreshAttList;
end;

procedure TfrmMails.refreshAttList;
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

procedure TfrmMails.refreshCampains;
var
  lvi: TListItem;
  LfileExt: string;
begin
 if not xtDsCampaigns.Active  then
   xtDsCampaigns.Open;
 xtDsCampaigns.First;

 lvCampaigns.Items.BeginUpdate;
 lvCampaigns.Items.Clear;
// xtDsCampaigns.DisableControls;
 while not xtDsCampaigns.Eof do
  Begin
   lvi := lvCampaigns.Items.Add;
   lvi.Caption := xtDsCampaignsNAME.AsString;
   lvi.SubItems.Add(xtDsCampaignsCREATION_DATE.asString);
   lvi.Data := TFileNode.Create;
   TEntityNode(lvi.Data).pk_id := xtDsCampaignsPK_ID.AsLargeInt;
   xtDsCampaigns.Next;
  End;
end;

procedure TfrmMails.openAvailableContacts;
begin
  if xtDSContacts.Active then
    xtDSContacts.Close;
  if not xtDSMailingList.Active then
    xtDSMailingList.Open;
  xtDSContacts.xtParams.Text := '';
  if current_campaign_id > 0 then
    xtDSContacts.xtParams.Add('FK_CAMPAIGN=' + current_campaign_id.ToString);
  if xtDSMailingList.RecordCount > 0 then
    xtDSContacts.xtParams.Add('FK_CRM_MAILING_LIST=' + xtDSMailingListPK_ID.AsInteger.ToString);
  xtDSContacts.Open;
end;

procedure TfrmMails.RemoveAll1Click(Sender: TObject);
begin
if MessageDlg('Remove all attachment from message? Are you sure?',mtConfirmation,[mbOk,mbCancel],0) = mrOk then
  Fcurrent_mail_template.AttachmentList := [];
refreshAttList;

end;

procedure TfrmMails.Removeselected1Click(Sender: TObject);
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

procedure TfrmMails.Resetsentflag1Click(Sender: TObject);
begin

 if not (xtDsCampContacts.State in [dsInsert,dsEdit]) then
   xtDsCampContacts.Edit;

 xtDsCampContactsFK_MAIL_BATCH.Clear;
 xtDsCampContacts.Post;






end;

procedure TfrmMails.SaveToFile1Click(Sender: TObject);
begin
  if dmXtumble.FSD.Execute then
    MemoBody.Lines.SaveToFile(dmXtumble.FSD.FileName);
end;

procedure TfrmMails.Sendtoselectedaddress1Click(Sender: TObject);
var
  LtmpMsg: TMAIL_BATCH;
  pk_mail_batch: Int64;
begin
  LtmpMsg := current_mail_template;
  LtmpMsg.MAIL_TO := xtDsCampContactsMAIL.AsString;
  pk_mail_batch := xtSendMail1.enqueMailMessage(LtmpMsg);
  xtDsCampContacts.Edit;
  xtDsCampContactsFK_MAIL_BATCH.AsLargeInt := pk_mail_batch;
  xtDsCampContacts.Post;
end;

procedure TfrmMails.Setcurrent_campaign_id(const Value: Int64);
begin
 if Fcurrent_campaign_id <> Value then
  Begin
    Fcurrent_campaign_id := Value;

    if not xtDsCampaigns.Locate('PK_ID',Value) then
     raise Exception.Create('Campaign ID ('+ Value.ToString +') not found');

    Fcurrent_campaign_name := xtDsCampaignsNAME.AsString;

    pnlCurrentCampaign.Caption := 'Campaign: ' + xtDsCampaignsNAME.AsString;

    if xtDsCampaignsFK_ALLEGATO_TEMPLATE.AsLargeInt > 0 then
     current_mail_template :=
      xtSendMail1.LoadTemplateAttachment(xtDsCampaignsFK_ALLEGATO_TEMPLATE.AsLargeInt)
    Else
     current_mail_template := emptyMailTemplate;

    if xtDsCampContacts.Active then
      xtDsCampContacts.Close;

    xtDsCampContacts.xtParams.Values['FK_CAMPAIGN'] := Fcurrent_campaign_id.ToString;
    xtDsCampContacts.Open;

    if PageControl1.ActivePage = tsAvailableContacts then
     Begin
       openAvailableContacts;
     End;
  End;
end;

procedure TfrmMails.Setcurrent_mail_template(const Value: TMAIL_BATCH);



begin
  Fcurrent_mail_template := Value;

  edMailFrom.Text := Value.MAIL_FROM;
  edMailFromName.Text := Value.FROM_NAME;
  edSubject.Text      := Value.SUBJECT;
  MemoBody.Text := Value.BODY;


  refreshAttList;


end;

procedure TfrmMails.srcContactsInvokeSearch(Sender: TObject);
var
  srcStr: String;
begin
 xtDSContacts.Filtered := False;
 srcStr := String(srcContacts.Text).toUpper;
 if srcContacts.Text <> '' then
  Begin
   xtDSContacts.Filter := '(upper(mail) like ''%' + srcStr + '%'')or(upper(name) like ''%' + srcStr + '%'')or(upper(company_name) like ''%' + srcStr + '%'')';
   xtDSContacts.Filtered := True;
  End;

end;

procedure TfrmMails.tlBtnAggiungiIndirizzoClick(Sender: TObject);
var
  mailAdd: string;
begin
 if inputQuery('mail address:','reciver mail address:',mailAdd) then
  Begin
   xtDsCampContacts.Append;
   xtDsCampContactsFK_CAMPAIGN.AsLargeInt := Fcurrent_campaign_id;
   xtDsCampContactsADDRESS.AsString := mailAdd;
   xtDsCampContacts.Post;
  End;
end;

procedure TfrmMails.tlBtnLoadFromSysTemplateClick(Sender: TObject);
var
  mt: TfrmMailTemplates;
begin
  mt := TfrmMailTemplates.Create(nil);
  mt.BorderStyle := TFormBorderStyle.bsSingle;
  If mt.ShowModal = mrOk then
   Begin
     current_mail_template := xtSendMail1.getTemplate(mt.template_name);
   End;
end;

procedure TfrmMails.tlbtnPlayClick(Sender: TObject);
var
  LtmpMsg: TMAIL_BATCH;
  pk_mail_batch: Int64;
begin
 xtDsCampContacts.First;
 while not xtDsCampContacts.Eof do
  begin
   if xtDsCampContactsFK_MAIL_BATCH.IsNull and (xtDsCampContactsUNSUBSCRIBED.AsString <> 'S') then
    Begin
     LtmpMsg := current_mail_template;
     LtmpMsg.MAIL_TO := xtDsCampContactsMAIL.AsString;
     pk_mail_batch := xtSendMail1.enqueMailMessage(LtmpMsg);
     xtDsCampContacts.Edit;
     xtDsCampContactsFK_MAIL_BATCH.AsLargeInt := pk_mail_batch;
     xtDsCampContacts.Post;
    End;
   xtDsCampContacts.Next;
  end;
end;

procedure TfrmMails.tlBtnSaveAsSystemTemplateClick(Sender: TObject);
var
  templateName: string;
begin
 If InputQuery('Template Name:','Template Name:',templateName) then
  Begin
   Fcurrent_mail_template.MAIL_FROM := edMailFrom.Text;
   Fcurrent_mail_template.FROM_NAME := edMailFromName.Text;
   Fcurrent_mail_template.SUBJECT   := edSubject.Text;
   Fcurrent_mail_template.BODY      := MemoBody.Text;
   Fcurrent_mail_template.TEMPLATE_NAME :=  templateName;

   xtSendMail1.SaveAsSystemTemplate(current_mail_template,templateName);
  End;

end;

procedure TfrmMails.ToolButton5Click(Sender: TObject);
begin
 xtDsCampContacts.Refresh;
end;

procedure TfrmMails.tsAddToCampainClick(Sender: TObject);
var
  bk: TBookmark;
  I: Integer;
begin
  for I:=0 to dbgContacts.SelectedRows.Count -1 do
   begin
    bk := dbgContacts.SelectedRows[I];
    xtDSContacts.GotoBookmark(bk);

    xtDsCampContacts.Insert;
    xtDsCampContactsFK_CAMPAIGN.AsLargeInt := Fcurrent_campaign_id;
    xtDsCampContactsFK_CRM_CONTACT.AsLargeInt := xtDSContactsPK_ID.AsLargeInt;
    xtDsCampContacts.Post;
   end;
  xtDSContacts.Close;
  xtDSContacts.Open;
  xtDsCampContacts.Close;
  xtDsCampContacts.OPen;
end;

procedure TfrmMails.tsAvailableContactsShow(Sender: TObject);
begin
  if not xtDSMailingList.Active then
    xtDSMailingList.Open
  Else
    xtDSMailingList.Refresh;


  openAvailableContacts;
end;

procedure TfrmMails.tsRefreshClick(Sender: TObject);
begin
  xtdsContacts.Refresh;
end;

procedure TfrmMails.tsSaveMailTemplateClick(Sender: TObject);
begin
 xtDsCampaigns.Edit;
 Fcurrent_mail_template.MAIL_FROM := edMailFrom.Text;
 Fcurrent_mail_template.FROM_NAME := edMailFromName.Text;
 Fcurrent_mail_template.SUBJECT   := edSubject.Text;
 Fcurrent_mail_template.BODY      := MemoBody.Text;

 xtDsCampaignsFK_ALLEGATO_TEMPLATE.AsLargeInt :=
    xtSendMail1.saveAsTemplateAttachment(current_mail_template,current_campaign_name);

 xtDsCampaigns.Post;
 xtDsCampaigns.xtApplyUpdates;
end;

procedure TfrmMails.xtDsCampaignsAfterOpen(DataSet: TDataSet);
begin
 refreshCampains;
end;

procedure TfrmMails.xtDSContactsAfterPost(DataSet: TDataSet);
begin
  xtDSContacts.xtApplyUpdates;
end;

end.
