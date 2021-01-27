unit uFrmDrive;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  pasDmXtumble, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, xtDatasetEntity, Vcl.Menus,
  uXtDriveCommands, Vcl.Grids, Vcl.DBGrids, System.ImageList, Vcl.ImgList,
  Vcl.VirtualImageList, Vcl.BaseImageCollection, Vcl.ImageCollection,
  Vcl.ToolWin, uxtCommonComponent, Vcl.WinXCtrls, uFrmMailComposer, uCommon;

type

  TfrmDrive = class(TForm)
    Panel1: TPanel;
    tvFolders: TTreeView;
    Panel2: TPanel;
    Splitter1: TSplitter;
    Panel3: TPanel;
    pnlCurrentFolder: TPanel;
    xtDsFolders: TxtDatasetEntity;
    xtDSFiles: TxtDatasetEntity;
    popFolders: TPopupMenu;
    Addfolder1: TMenuItem;
    Deletefolder1: TMenuItem;
    OD: TOpenDialog;
    xtDriveCommands: TxtDriveCommands;
    dsFiles: TDataSource;
    lvFiles: TListView;
    ImageCollection1: TImageCollection;
    VirtualImageList1: TVirtualImageList;
    ToolBar1: TToolBar;
    ToolButton1: TToolButton;
    ToolButton5: TToolButton;
    tlbtnUpload: TToolButton;
    tlBtnDownload: TToolButton;
    FSD: TFileSaveDialog;
    gbDetail: TGroupBox;
    pnlSelectedFile: TPanel;
    lblPublicURL: TLabel;
    swPrivate: TToggleSwitch;
    lblfileName: TLabel;
    lblFName: TLabel;
    ToolButton6: TToolButton;
    tlBtnSendAsMail: TToolButton;
    N1: TMenuItem;
    Refresh1: TMenuItem;
    stFileName: TStaticText;
    popFiles: TPopupMenu;
    Download2: TMenuItem;
    FileInfo1: TMenuItem;
    btnImportZip: TToolButton;
    xtDsFoldersPK_ID: TIntegerField;
    xtDsFoldersNAME: TStringField;
    xtDsFoldersFKPARENTDIRECTORY: TIntegerField;
    xtDsFoldersFULLPATH: TStringField;
    ToolButton8: TToolButton;
    DeleteFile1: TMenuItem;
    N2: TMenuItem;
    Setcustomrevision1: TMenuItem;
    N3: TMenuItem;
    estComparetorevision1: TMenuItem;
    Renamefolder1: TMenuItem;
    xtDSFilesPK_ID: TIntegerField;
    xtDSFilesLOGICAL_FILENAME: TStringField;
    xtDSFilesFILE_SIZE: TIntegerField;
    xtDSFilesFK_FILE_TYPE: TIntegerField;
    xtDSFilesUPLOAD_DATE: TSQLTimeStampField;
    xtDSFilesREL_TO: TStringField;
    xtDSFilesDESCRIPTION: TStringField;
    xtDSFilesFK_FOLDER: TIntegerField;
    xtDSFilesFK_USER_OWNER: TIntegerField;
    xtDSFilesREL_TO_PK: TLargeintField;
    xtDSFilesEXTERNAL_REVISION: TStringField;
    xtDSFilesPRIVATE: TStringField;
    xtDSFilesFULL_PATH: TStringField;
    xtDSFilesFILE_NAME: TStringField;
    xtDSFilesCONTENT_SHA256: TStringField;
    popListStyle: TPopupMenu;
    Icon1: TMenuItem;
    SmallIcon1: TMenuItem;
    List1: TMenuItem;
    Report1: TMenuItem;
    Comparecontentwithlocalfile1: TMenuItem;
    popCopiaLink: TPopupMenu;
    CopyLinkorText1: TMenuItem;
    lblPublicURLbyName: TLabel;
    procedure FormCreate(Sender: TObject);
    procedure Addfolder1Click(Sender: TObject);
    procedure Deletefolder1Click(Sender: TObject);
    procedure tvFoldersChange(Sender: TObject; Node: TTreeNode);
    procedure xtDSFilesAfterOpen(DataSet: TDataSet);
    procedure ToolButton1Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure tlbtnUploadClick(Sender: TObject);
    procedure lvFilesDblClick(Sender: TObject);
    procedure tlBtnDownloadClick(Sender: TObject);
    procedure swPrivateClick(Sender: TObject);
    procedure lvFilesCustomDrawItem(Sender: TCustomListView; Item: TListItem;
      State: TCustomDrawState; var DefaultDraw: Boolean);
    procedure lvFilesSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure lblPublicURLClick(Sender: TObject);
    procedure tlBtnSendAsMailClick(Sender: TObject);
    procedure Refresh1Click(Sender: TObject);
    procedure FileInfo1Click(Sender: TObject);
    procedure btnImportZipClick(Sender: TObject);
    procedure DeleteFile1Click(Sender: TObject);
    procedure Setcustomrevision1Click(Sender: TObject);
    procedure pnlCurrentFolderClick(Sender: TObject);
    procedure estComparetorevision1Click(Sender: TObject);
    procedure Renamefolder1Click(Sender: TObject);
    procedure Comparecontentwithlocalfile1Click(Sender: TObject);
    procedure CopyLinkorText1Click(Sender: TObject);
  private
    FCURRENT_PK_ID: Int64;
    FcurrentFolder: TEntityNode;
    onCreatingFolderTree : Boolean;
    procedure recourseOnSingleDataset(Afk_parent_Folder : Int64;maxDeepLevel : Integer; parentItem : TTreeNode = nil);
    procedure SetCURRENT_PK_ID(const Value: Int64);
    procedure SetcurrentFolder(const Value: TEntityNode);
    { Private declarations }

  public
    { Public declarations }
    property CURRENT_PK_ID : Int64 read FCURRENT_PK_ID write SetCURRENT_PK_ID;

    property currentFolder : TEntityNode read FcurrentFolder write SetcurrentFolder;


    procedure refreshFolders(autoUpdateFiles : Boolean = True);
  end;

var
  frmDrive: TfrmDrive;

implementation

{$R *.dfm}
uses xtCommonTypes,xtSendMail, ShellAPI,uProviderHTTP,xtJSON, System.Zip,
    uFrmMain, System.IOUtils, System.Hash,ClipBrd;

procedure TfrmDrive.Addfolder1Click(Sender: TObject);
var
  LmyNd: Int64;
  folderName: String;
  idx: TEntityNode;
  BK: tbYTES;
begin
 if tvFolders.Selected = nil then exit;

 LmyNd := TEntityNode(tvFolders.Selected.data).pk_id;

 IF LmyNd = 0 then
  Begin
   refreshFolders;
   raise Exception.Create('riprovare...');
  End;

 if not  InputQuery('Folder Name','Folder Name',folderName) then exit;

 xtDsFolders.Insert;

 xtDsFolders.FieldByName('Name').asString := folderName;
 xtDsFolders.FieldByName('FKParentDirectory').AsLargeInt := LmyNd;
 BK := xtDsFolders.GetBookmark;
 xtDsFolders.Post;

 showmessage(xtDsFolders.FieldByName('pk_id').AsString + xtDsFolders.FieldByName('fullpath').AsString);
 idx := TEntityNode.Create;
 idx.item := tvFolders.Items.AddChild(tvFolders.Selected, folderName);
 idx.fullPath := xtDsFolders.FieldByName('fullpath').AsString;

 idx.item.Data := idx;
 xtDsFolders.GotoBookmark(BK);

 idx.pk_id := xtDsFolders.FIELDBYNAME('PK_ID').AsInteger;

end;

procedure TfrmDrive.btnImportZipClick(Sender: TObject);
var
  ArcFileName : TFileName;
  zf          : TZipFile;
  I: Integer;
  SS : TStream;
  ZipHead: TZipHeader;
  fname: String;
  fsize: string;
  VFNAME: string;
  VPATH: String;
  pk_id: Int64;
  logLines : TStrings;
begin
 frmMain.pnlLogs.Visible := True;
 frmMain.pnlLogs.Top := frmMain.Height;

 od.Filter := '*.zip|*.zip';
 od.FileName := '*.zip';
 if not od.Execute then exit;

 ArcFileName := od.FileName;
 xtDriveCommands.importZipFiles(currentFolder.fullPath,ArcFileName,frmMain.MemoLog.Lines);
end;

procedure TfrmDrive.Comparecontentwithlocalfile1Click(Sender: TObject);
var
  lviSelected: TListItem;
  res: TRecAllegatoProp;
  pk_file: Int64;
  RemoteHash, LocalHash: string;
  MS: TMemoryStream;
  Values : Tarray<System.string>;
Begin
  if lvFiles.Selected = nil then exit;

  if not od.Execute then exit;

  MS := TMemoryStream.Create;
  MS.LoadFromFile(od.FileName);
  MS.Position := 0;

  localHash := System.Hash.THashSHA2.GetHashString(MS);
  MS.Free;

  pk_file := TFileNode(lvFiles.Selected.data).pk_id;

  if xtDSFiles.Locate('pk_id',pk_file) then
   Begin
    remoteHash := xtDSFilesCONTENT_SHA256.AsString;
   End;

  if remoteHash.Equals(LocalHash) then
    Showmessage('Content of files are equals!!')
  Else
   Begin
    SetLength(Values,2);
    Values[0] := RemoteHash;
    Values[1] := LocalHash;
    InputQuery('Hash results',['Remote File Hash','Local File Hash'],Values);
   End;
End;

procedure TfrmDrive.CopyLinkorText1Click(Sender: TObject);
begin
// if Sender is TLabel then
  Clipboard.AsText :=
    lblPublicURL.Caption;
//     TLabel(Sender).Caption;

end;

procedure TfrmDrive.DeleteFile1Click(Sender: TObject);
var
  LmyNd: Int64;
  TS : TStringList;
  BK: TBytes;
  lviSelected: TListItem;
begin
  if lvFiles.Selected = nil then exit;

  if MessageDlg('Delete selected file [' +lvFiles.Selected.Caption + '] ?',mtConfirmation,[mbOk,mbCancel],0) = mrCancel then exit;

  lviSelected := lvFiles.Selected;
  TS := TStringList.Create;

  TS.Values['PK_ID'] := TFileNode(lvFiles.Selected.data).pk_id.ToString;
  TS.Values['DELETED'] := 'S';
  TS.Values['xtEntity'] := 'files';
  xtDSFiles.customPost(TS,nil);
  xtDSFiles.Close;
  xtDSFiles.Open;

  TS.Free;


end;

procedure TfrmDrive.Deletefolder1Click(Sender: TObject);
var
  LmyNd: Int64;
  nome: String;
begin
  if tvFolders.Selected = nil then exit;

  nome := tvFolders.Selected.Text;


  if MessageDlg('Delete folder "' + nome + '" ?',mtConfirmation,[mbYes,mbNo],0) = mrNo
   then exit;

  If tvFolders.Selected.Count > 0 then
   raise Exception.Create('there are subfolder, delete that first');


  LmyNd := TEntityNode(tvFolders.Selected.data).pk_id;

  IF LmyNd = 0 then
   raise Exception.Create('riprovare...');

  if xtDsFolders.Locate('PK_ID',LmyNd) then
   xtDsFolders.Delete;

  tvFolders.Selected.Delete;
end;

procedure TfrmDrive.estComparetorevision1Click(Sender: TObject);
var
  local_rev: string;
  parms: TConnectionParam;
  updData: TUpdateApplicationInfo;
begin
 if lvFiles.Selected = nil then exit;
 if inputquery('manual revision to compare','manual rev to compare',local_rev) then
  begin

   parms.ServerAddress := dmXtumble.XtConnection.ConnectionParams.ServerAddress;
   parms.companyId     := dmXtumble.XtConnection.ConnectionParams.companyId;

   updData := xtDriveCommands.ckPublicApplicationVersion(parms,
         TFileNode(lvFiles.Selected.data).onlyFileName,local_rev,False);

   if updData.updateAvailable then
    ShowMessage('update disponibile')
   Else
    ShowMessage('hai l''ultima versione ');

  end;
end;

procedure TfrmDrive.FileInfo1Click(Sender: TObject);
var
  lviSelected: TListItem;
  res: TRecAllegatoProp;
  pk_file: Int64;
  fileHash: string;
begin
  if lvFiles.Selected = nil then exit;

  pk_file := TFileNode(lvFiles.Selected.data).pk_id;

  res := xtDriveCommands.getFileInfo(pk_file);

  if xtDSFiles.Locate('pk_id',pk_file) then
   Begin
    fileHash := xtDSFilesCONTENT_SHA256.AsString;
   End;

  ShowMessage(TJSONPersistence.ToJSON<TRecAllegatoProp>(res).Format + #10#13 + 'Hash256:' + fileHash);



end;

procedure TfrmDrive.FormCreate(Sender: TObject);
begin
 FcurrentFolder := NIL;
 CURRENT_PK_ID := -1;
 xtDsFolders.xtRefreshAfterPost := False;
 refreshFolders(False);
 onCreatingFolderTree := False;
end;

procedure TfrmDrive.FormShow(Sender: TObject);
begin
 refreshFolders;
end;

procedure TfrmDrive.lblPublicURLClick(Sender: TObject);
begin
 if sender is TLabel then
  Begin
   Clipboard.AsText := TLabel(Sender).Caption;
   ShellExecute(0,'open',PChar(TLabel(Sender).Caption),'','',SW_NORMAL);
  End;
end;

procedure TfrmDrive.lvFilesCustomDrawItem(Sender: TCustomListView;
  Item: TListItem; State: TCustomDrawState; var DefaultDraw: Boolean);
begin
 if TFileNode(Item.Data).isPublic then
  Begin
    Sender.Canvas.Brush.Color := clLime;
//    Sender.Canvas.Font.Color  := clYellow;
  End;
end;

procedure TfrmDrive.lvFilesDblClick(Sender: TObject);
var
  rct: TRecAllegatoProp;
  LdestFName: string;
begin
 if lvFiles.Selected = nil then exit;

 rct := xtDriveCommands.dloadFile(TFileNode(lvFiles.Selected.Data).pk_id,-1,true);
 if rct.MS <> nil then
  Begin
    LdestFName := dmXtumble.tmpDir + '\' + lvFiles.Selected.Caption;
    rct.MS.SaveToFile(LDestFName );
    ShellExecute(0,'open',PChar(LdestFName),'','',SW_NORMAL);
  End;
end;

procedure TfrmDrive.lvFilesSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
if item <> nil then
 Begin
  swPrivate.OnClick := nil;
  if not TFileNode(Item.Data).isPublic then
   Begin
    swPrivate.state := tssOff;
    lblPublicURL.Visible := False;
    lblPublicURLbyName.Visible := False;
   End
  else
   Begin
    swPrivate.state := tssOn;
//    https://public.xtumble.store/downloadattachmentpub?cid=05830520960&&docId=4025
    lblPublicURL.Caption := dmXtumble.XtConnection.ConnectionURL + '/downloadattachmentpub?cid=' + dmXtumble.XtConnection.CompanyID + '&&docId=' + TFileNode(Item.Data).pk_id.ToString;
    lblPublicURL.Visible := True;

    lblPublicURLbyName.Caption := dmXtumble.XtConnection.ConnectionURL + '/downloadattachmentpub?cid=' + dmXtumble.XtConnection.CompanyID + '&&fname=' + TFileNode(Item.Data).full_filename;
    lblPublicURLbyName.Visible := True;



   End;
  stFileName.Caption := TFileNode(Item.Data).full_filename;
  lblFName.Caption   := TFileNode(Item.Data).full_filename;
  swPrivate.OnClick := swPrivateClick;
 End;
End;

procedure TfrmDrive.pnlCurrentFolderClick(Sender: TObject);
begin
 ShowMessage(Power10(6, 20).ToString);
end;

procedure TfrmDrive.refreshFolders(autoUpdateFiles : Boolean = True);
var
  idx: TTreeNode;
begin
  onCreatingFolderTree := True;
  try
    if xtDsFolders.Active then
      xtDsFolders.Close;

    xtDsFolders.Open;
    tvFolders.Items.Clear;
    tvFolders.Visible := False;
    tvFolders.Enabled := False;

    idx := tvFolders.Items.AddChild(nil, 'root');
    idx.Data := TEntityNode.Create;

    TEntityNode(idx.Data).pk_id := 1;
    TEntityNode(idx.Data).item  := idx;
    TEntityNode(idx.Data).fullpath := '/';

    recourseOnSingleDataset(1,0,idx);

  finally
    onCreatingFolderTree := False;
    tvFolders.Visible := True;
    tvFolders.Enabled := True;
    tvFolders.Selected := idx;
    idx.Expand(False);

  end;

 if autoUpdateFiles then
  if currentFolder = nil then
   if tvFolders.Items.Count > 0 then
    currentFolder := TEntityNode(tvFolders.Items[0].data);

end;

procedure TfrmDrive.Renamefolder1Click(Sender: TObject);
var
  LmyNd: Int64;
  folderName: String;
begin
  if tvFolders.Selected = nil then exit;

  folderName := tvFolders.Selected.Text;
  LmyNd := TEntityNode(tvFolders.Selected.data).pk_id;

  if not  InputQuery('Rename folder?','New name',folderName) then exit;

  IF LmyNd = 0 then
   raise Exception.Create('riprovare...');

  if xtDsFolders.Locate('PK_ID',LmyNd) then
   Begin
    xtDsFolders.Edit;
    xtDsFoldersNAME.AsString := folderName;
    xtDsFolders.Post;
    tvFolders.Selected.Text := folderName;
   End;
end;

Procedure TfrmDrive.SetcurrentFolder(const Value: TEntityNode);
begin
 if FcurrentFolder <> Value then
  Begin
    FcurrentFolder := Value;
    if FcurrentFolder = nil then
     begin
      CURRENT_PK_ID := -1;
      pnlCurrentFolder.Caption := 'No folder selected';
     end
    else
     Begin
      CURRENT_PK_ID := FcurrentFolder.pk_id;

      pnlCurrentFolder.Caption := '(' + FcurrentFolder.pk_id.ToString + ') ' + FcurrentFolder.item.Text + ' [' +
          xtDSFiles.RecordCount.ToString + ' files]';
     End;
  End;
End;

procedure TfrmDrive.SetCURRENT_PK_ID(const Value: Int64);
begin
  if FCURRENT_PK_ID <> Value then
  Begin
    FCURRENT_PK_ID := Value;

    if FCURRENT_PK_ID > 0 then
     Begin
      xtDSFiles.xtParams.Values['CURRENT_FOLDER'] := FCURRENT_PK_ID.ToString;
      xtDSFiles.xtParams.Values['ONLY_LAST_REVISION'] := 'S';
      if xtDSFiles.Active then
        xtDSFiles.Close;
      xtDSFiles.Open;
     End;
  End;
End;

procedure TfrmDrive.Setcustomrevision1Click(Sender: TObject);
Var
  LmyNd: Int64;
  TS : TStringList;
  BK: TBytes;
  lviSelected: TListItem;
  Lprotocol: String;
Begin
  if lvFiles.Selected = nil then exit;

  Lprotocol := TFileNode(lvFiles.Selected.data).custom_protocol;

  if InputQuery('Your file protocol','Your file protocol',Lprotocol) then
   Begin
      lviSelected := lvFiles.Selected;
      TS := TStringList.Create;

      TS.Values['PK_ID'] := TFileNode(lvFiles.Selected.data).pk_id.ToString;
      TS.Values['CUSTOM_PROTOCOL'] := Lprotocol;
      TS.Values['xtEntity'] := 'files';
      xtDSFiles.customPost(TS,nil);
      xtDSFiles.Close;
      xtDSFiles.Open;

      TS.Free;
   End;
End;

procedure TfrmDrive.tlBtnDownloadClick(Sender: TObject);
var
  rct: TRecAllegatoProp;
  LdestFName: string;
  LPK_ID: Int64;
begin
 if lvFiles.Selected = nil then exit;

 FSD.FileName := lvFiles.Selected.Caption;
 LPK_ID := TFileNode(lvFiles.Selected.data).pk_id;

 if FSD.Execute then
  Begin
   LDestFName := FSD.FileName;
   rct := xtDriveCommands.dloadFile(LPK_ID,-1,true);
   if rct.MS <> nil then
    Begin
      rct.MS.SaveToFile(LDestFName );
      ShellExecute(0,'open',PChar(ExtractFilePath(LdestFName)),'','',SW_NORMAL);
    End;
  End;
End;

procedure TfrmDrive.tlBtnSendAsMailClick(Sender: TObject);
var
  att : TMAIL_BATCH_ATTACHMENTS;
  id : int64;
begin
 if frmMailComposer = nil then
  frmMailComposer := TfrmMailComposer.Create(Application);

 frmMailComposer.AttachmentList := [];

 if lvFiles.Selected <> nil then
  Begin
    id := TFileNode(lvFiles.Selected.Data).pk_id;

    att.FILENAME := lvFiles.Selected.Caption;
    att.FK_ATTACHMENTS := id;
    att.MIMETYPE := 'appliction-xbinary';

    frmMailComposer.AttachmentList := [att];
  End;

 frmMailComposer.ShowModal;

 FreeAndNil(frmMailComposer);
end;

procedure TfrmDrive.tlbtnUploadClick(Sender: TObject);
var
  pk_id: Int64;
begin
 if OD.Execute then
  Begin
   pk_id := xtDriveCommands.uploadFile(OD.FileName,'',CURRENT_PK_ID);
   xtDSFiles.Refresh;
  End;
end;

procedure TfrmDrive.swPrivateClick(Sender: TObject);
var
  LmyNd: Int64;
  TS : TStringList;
  BK: TBytes;
  lviSelected: TListItem;
begin
  if lvFiles.Selected = nil then exit;

  lviSelected := lvFiles.Selected;
  TS := TStringList.Create;

  TS.Values['PK_ID'] := TFileNode(lvFiles.Selected.data).pk_id.ToString;
  if swPrivate.IsOn then
    TS.Values['PRIVATE'] := 'N'
  else
    TS.Values['PRIVATE'] := 'S';

  TS.Values['xtEntity'] := 'files';

  BK := xtDSFiles.GetBookmark;
  xtDSFiles.customPost(TS,nil);
  xtDSFiles.Close;
  xtDSFiles.Open;
  xtDSFiles.GotoBookmark(bk);

  TS.Free;

  lblPublicURL.Caption :=
     dmXtumble.XtConnection.ConnectionURL + '/downloadattachmentpub?cid=' +
     dmXtumble.XtConnection.CompanyID + '&&docId=' + TFileNode(lviSelected.data).pk_id.ToString;

  lblPublicURL.Visible := swPrivate.IsOn;
end;

procedure TfrmDrive.ToolButton1Click(Sender: TObject);
begin
  case TToolButton(Sender).tag of
    0 : lvFiles.ViewStyle := vsIcon;
    1 : lvFiles.ViewStyle := vsSmallIcon;
    2 : lvFiles.ViewStyle := vsList;
    3 : lvFiles.ViewStyle := vsReport;
  end;

end;

procedure TfrmDrive.tvFoldersChange(Sender: TObject; Node: TTreeNode);
begin
 if not onCreatingFolderTree then
    currentFolder := TEntityNode(Node.data);
end;

procedure TfrmDrive.xtDSFilesAfterOpen(DataSet: TDataSet);
var
  lvi: TListItem;
  LfileExt: string;

begin
 lvFiles.Items.BeginUpdate;
 lvFiles.Items.Clear;
 Dataset.DisableControls;
 Dataset.First;
 while not Dataset.Eof do
  Begin
   lvi := lvFiles.Items.Add;
   lvi.Caption := xtDSFilesLOGICAL_FILENAME.AsString;
   lvi.SubItems.Add(xtDSFilesFILE_SIZE.asString + ' Bytes');
   lvi.SubItems.Add(xtDSFilesUPLOAD_DATE.AsString);
   lvi.SubItems.Add(xtDSFilesPK_ID.AsString);
   lvi.SubItems.Add(xtDSFilesEXTERNAL_REVISION.AsString);

   lvi.Data := TFileNode.Create;
   TFileNode(lvi.Data).pk_id := xtDSFilesPK_ID.AsLargeInt;
   TFileNode(lvi.Data).isPublic := xtDSFilesPRIVATE.AsString.ToUpper = 'N';
   TFileNode(lvi.Data).full_filename := xtDSFilesFILE_NAME.AsString;
   TFileNode(lvi.Data).custom_protocol := xtDSFilesEXTERNAL_REVISION.AsString;

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

   Dataset.Next;
  End;
 Dataset.EnableControls;
 lvFiles.Items.EndUpdate;
end;

procedure TfrmDrive.recourseOnSingleDataset(Afk_parent_Folder : Int64;maxDeepLevel : Integer; parentItem : TTreeNode = nil);
var
  bk: TBytes;
  idx: TTreeNode;
  ds: IFDDataSetReference;
begin
  xtDsFolders.First;
  if (parentItem <> nil)and(maxDeepLevel > 0) then
    if (parentItem.Level > maxDeepLevel) then exit;

  while not xtDsFolders.Eof do
  begin
    if xtDsFolders.FieldByName('FKParentDirectory').AsLargeInt = Afk_parent_Folder then
     Begin
      idx := tvFolders.Items.AddChild(parentItem, xtDsFolders.FieldByName('Name').AsString);
      idx.Data := TEntityNode.Create;

      TEntityNode(idx.Data).pk_id := xtDsFolders.FieldByName('PK_ID').AsLargeInt;
      TEntityNode(idx.Data).fullpath := xtDsFolders.FieldByName('fullpath').AsString;
      TEntityNode(idx.Data).item := idx;

      bk := xtDsFolders.GetBookmark;

      // avoid circular links on the same folder
      if Afk_parent_Folder <> xtDsFolders.FieldByName('PK_ID').AsLargeInt then
        recourseOnSingleDataset(TEntityNode(idx.Data).pk_id,maxDeepLevel,idx);
      xtDsFolders.GotoBookmark(bk);
      Application.ProcessMessages;
     End;
    xtDsFolders.Next;
  end;
end;


procedure TfrmDrive.Refresh1Click(Sender: TObject);
begin
 refreshFolders(False);
end;

end.
