unit uFrmMailingList;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, uXtDriveCommands, Vcl.Menus,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, xtDatasetEntity,
  uxtCommonComponent, xtSendMail, Vcl.ComCtrls, Vcl.ToolWin, Vcl.Grids,
  Vcl.DBGrids, Vcl.ExtCtrls;

type
  TfrmMailingList = class(TForm)
    Splitter1: TSplitter;
    Panel1: TPanel;
    Panel2: TPanel;
    Panel3: TPanel;
    pnlCurrentMailingList: TPanel;
    PageControl1: TPageControl;
    tsMailingContacts: TTabSheet;
    dbgMailingContacts: TDBGrid;
    ToolBar1: TToolBar;
    ToolButton5: TToolButton;
    tsAvailableContacts: TTabSheet;
    dbgContacts: TDBGrid;
    ToolBar2: TToolBar;
    ToolButton7: TToolButton;
    tsAddToList: TToolButton;
    tlAddToCampain: TToolButton;
    tsRefresh: TToolButton;
    pnlLeftMenu: TPanel;
    lvMailingList: TListView;
    xtSendMail1: TxtSendMail;
    xtDsMailing: TxtDatasetEntity;
    xtDSContacts: TxtDatasetEntity;
    xtDSContactsPK_ID: TLargeintField;
    xtDSContactsMAIL: TStringField;
    xtDSContactsNAME: TStringField;
    xtDSContactsCOMPANY_NAME: TStringField;
    xtDSContactsADDRESS: TStringField;
    xtDSContactsEXTERNAL_KEY: TStringField;
    xtDSContactsOFFICE_PHONE: TStringField;
    xtDSContactsMOBILE_PHONE: TStringField;
    xtDSContactsCITY: TStringField;
    xtDSContactsPOSTAL_CODE: TStringField;
    xtDSContactsROLE: TStringField;
    xtDSContactsFK_GROUP: TLargeintField;
    xtDSContactsFK_STATUS: TLargeintField;
    xtDSContactsUNSUBSCRIBED: TStringField;
    xtDSContactsATTIVO: TStringField;
    xtDSContactsFK_IDCONTATTO: TLargeintField;
    popMailing: TPopupMenu;
    Addfolder1: TMenuItem;
    Deletefolder1: TMenuItem;
    N1: TMenuItem;
    Refresh1: TMenuItem;
    xtDriveCommands: TxtDriveCommands;
    dsContacts: TDataSource;
    xtDsMailingContacts: TxtDatasetEntity;
    dsMailingContacts: TDataSource;
    popContacts: TPopupMenu;
    popBody: TPopupMenu;
    LoadFromFile1: TMenuItem;
    SaveToFile1: TMenuItem;
    N2: TMenuItem;
    LoadfromURL1: TMenuItem;
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
    popReports: TPopupMenu;
    xtDsMailingPK_ID: TLargeintField;
    xtDsMailingDESCRIZIONE: TStringField;
    xtDsMailingATTIVA: TStringField;
    xtDsMailingDATA_CREAZIONE: TSQLTimeStampField;
    xtDsMailingDATA_ULTIMA_COMUNICAZIONE: TSQLTimeStampField;
    xtDsMailingEX_KEY: TStringField;
    xtDsMailingContactsPK_ID: TLargeintField;
    xtDsMailingContactsMAIL: TStringField;
    xtDsMailingContactsATTIVO: TStringField;
    xtDsMailingContactsFK_IDCONTATTO: TLargeintField;
    xtDsMailingContactsEXTERNAL_KEY: TStringField;
    xtDsMailingContactsNAME: TStringField;
    xtDsMailingContactsADDRESS: TStringField;
    xtDsMailingContactsOFFICE_PHONE: TStringField;
    xtDsMailingContactsMOBILE_PHONE: TStringField;
    xtDsMailingContactsCITY: TStringField;
    xtDsMailingContactsPOSTAL_CODE: TStringField;
    xtDsMailingContactsROLE: TStringField;
    xtDsMailingContactsCOMPANY_NAME: TStringField;
    xtDsMailingContactsFK_GROUP: TLargeintField;
    xtDsMailingContactsFK_STATUS: TLargeintField;
    xtDsMailingContactsUNSUBSCRIBED: TStringField;
    procedure FormCreate(Sender: TObject);
    procedure xtDsMailingAfterOpen(DataSet: TDataSet);
    procedure lvMailingListClick(Sender: TObject);
    procedure tsAvailableContactsShow(Sender: TObject);
    procedure tsRefreshClick(Sender: TObject);
  private
    Fcurrent_mlist: Int64;
    Fcurrent_mlist_name: string;
    procedure Setcurrent_mlist(const Value: Int64);
    procedure Setcurrent_mlist_name(const Value: string);
    procedure refreshAvailableContacts;
    { Private declarations }
  public
    { Public declarations }
    property current_mlist_name : string read Fcurrent_mlist_name write Setcurrent_mlist_name;
    property current_mlist: Int64 read Fcurrent_mlist write Setcurrent_mlist;
    procedure refreshMailing;
  end;

var
  frmMailingList: TfrmMailingList;

implementation

{$R *.dfm}
uses uCommon;

procedure TfrmMailingList.FormCreate(Sender: TObject);
begin
 xtDsMailing.Open;
end;

procedure TfrmMailingList.lvMailingListClick(Sender: TObject);
begin
 if lvMailingList.selected = nil then exit;

 current_mlist :=
     TEntityNode(lvMailingList.selected.Data).pk_id;
end;

procedure TfrmMailingList.refreshMailing;
var
  lvi: TListItem;
  LfileExt: string;
begin
 if not xtDsMailing.Active  then
   xtDsMailing.Open;
 xtDsMailing.First;

 lvMailingList.Items.BeginUpdate;
 lvMailingList.Items.Clear;
// xtDsCampaigns.DisableControls;
 while not xtDsMailing.Eof do
  Begin
   lvi := lvMailingList.Items.Add;
   lvi.Caption := xtDsMailingDESCRIZIONE.AsString;
   lvi.SubItems.Add(xtDsMailingDATA_CREAZIONE.asString);
   lvi.Data := TFileNode.Create;
   TEntityNode(lvi.Data).pk_id := xtDsMailingPK_ID.AsLargeInt;
   xtDsMailing.Next;
  End;
end;

procedure TfrmMailingList.refreshAvailableContacts;
begin
  //
  if xtDSContacts.Active then
    xtDSContacts.Close;
  xtDSContacts.xtParams.Clear;
  xtDSContacts.xtParams.Values['FK_CRM_MAILING_LIST_EXCLUDE'] := Fcurrent_mlist.ToString;
  xtDSContacts.Open;
end;

procedure TfrmMailingList.Setcurrent_mlist(const Value: Int64);
begin
  if Fcurrent_mlist <> Value then
  Begin
    Fcurrent_mlist := Value;

    if not xtDsMailing.Locate('PK_ID',Value) then
     raise Exception.Create('Mail list ID ('+ Value.ToString +') not found');

    Fcurrent_mlist_name := xtDsMailingDESCRIZIONE.AsString;

    pnlCurrentMailingList.Caption := 'Select List: ' + xtDsMailingDESCRIZIONE.AsString;


    if xtDsMailingContacts.Active then
      xtDsMailingContacts.Close;

    xtDsMailingContacts.xtParams.Clear;
    xtDsMailingContacts.xtParams.Values['FK_CRM_MAILING_LIST'] := Fcurrent_mlist.ToString;
    xtDsMailingContacts.Open;

    refreshAvailableContacts;


  End;

end;

procedure TfrmMailingList.Setcurrent_mlist_name(const Value: string);
begin
  Fcurrent_mlist_name := Value;
end;

procedure TfrmMailingList.tsAvailableContactsShow(Sender: TObject);
begin
  refreshAvailableContacts;


end;

procedure TfrmMailingList.tsRefreshClick(Sender: TObject);
begin
 if xtDSContacts.Active then
   xtDSContacts.Close;

 xtDSContacts.Open;
end;

procedure TfrmMailingList.xtDsMailingAfterOpen(DataSet: TDataSet);
begin
 refreshMailing;
end;

end.
