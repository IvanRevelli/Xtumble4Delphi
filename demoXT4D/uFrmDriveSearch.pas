unit uFrmDriveSearch;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Vcl.StdCtrls, Vcl.WinXCtrls, Vcl.ComCtrls, Vcl.ExtCtrls,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, xtDatasetEntity,
  pasDmXtumble;

type
  TfrmDriveSearch = class(TForm)
    xtDSFiles: TxtDatasetEntity;
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
    dsFiles: TDataSource;
    pnlCurrentFolder: TPanel;
    lvFiles: TListView;
    SearchBox1: TSearchBox;
    procedure xtDSFilesAfterOpen(DataSet: TDataSet);
    procedure SearchBox1InvokeSearch(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmDriveSearch: TfrmDriveSearch;

implementation

{$R *.dfm}
uses uCommon;

procedure TfrmDriveSearch.SearchBox1InvokeSearch(Sender: TObject);
begin
 xtDSFiles.xtParams.Values['FILTRO_NOME_DESCR'] := SearchBox1.Text;
 xtDSFiles.xtParams.Values['ONLY_LAST_REVISION'] := 'S';
 if xtDSFiles.Active then
   xtDSFiles.Close;
 xtDSFiles.Open;
end;

procedure TfrmDriveSearch.xtDSFilesAfterOpen(DataSet: TDataSet);
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
   lvi.SubItems.Add(xtDSFilesFULL_PATH.AsString);
   lvi.SubItems.Add(xtDSFilesDESCRIPTION.AsString);

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

end.

