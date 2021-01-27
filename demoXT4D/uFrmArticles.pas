unit uFrmArticles;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Data.DB, Vcl.ExtCtrls,
  Vcl.Grids, Vcl.DBGrids, pasDmXtumble, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Vcl.DBCtrls, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  xtDatasetEntity, uXtDriveCommands, Vcl.ComCtrls, Vcl.Mask, Vcl.WinXCtrls,
  uxtCommonComponent, Vcl.ExtDlgs;

type
  TfrmArticles = class(TForm)
    Panel1: TPanel;
    Panel2: TPanel;
    xtArticles: TxtDatasetEntity;
    dsArticles: TDataSource;
    xtDriveCommands: TxtDriveCommands;
    PageControl1: TPageControl;
    tsGrid: TTabSheet;
    Splitter1: TSplitter;
    xtArticlesCODE: TStringField;
    xtArticlesDATA_AGG_DISPONIBILITA: TSQLTimeStampField;
    xtArticlesFK_CATEGORY: TLargeintField;
    xtArticlesPROVIDER_CODE: TStringField;
    xtArticlesDESCRIPTION: TStringField;
    xtArticlesINSERT_DATE: TSQLTimeStampField;
    xtArticlesMESURE_UNIT: TStringField;
    xtArticlesVAT: TFMTBCDField;
    xtArticlesQUANTITY: TIntegerField;
    xtArticlesMY_PRICE: TFloatField;
    xtArticlesEND_USER_PRICE: TFloatField;
    xtArticlesIDARTICOLO: TLargeintField;
    xtArticlesMODEL: TStringField;
    xtArticlesVISIBLE_ON_STORE: TIntegerField;
    xtArticlesEXTENDED_DESCRIPTION: TStringField;
    xtArticlesFK_PICTURE_ATTACH: TIntegerField;
    xtArticlesRECORD_REVISION: TLargeintField;
    xtArticlesUID: TStringField;
    xtArticlesVAT_CODE: TIntegerField;
    xtArticlesFK_STATE: TIntegerField;
    xtArticlesENABLED: TStringField;
    xtArticlesEAN_CODE: TStringField;
    xtArticlesBRAND_NAME: TStringField;
    xtArticlesEXTERNAL_KEY: TStringField;
    xtArticlesLAST_MODIFICATION_DATE: TSQLTimeStampField;
    gbArticleList: TGroupBox;
    gbDetail: TGroupBox;
    DBGrid1: TDBGrid;
    Panel3: TPanel;
    DBNavigator1: TDBNavigator;
    gbFilter: TGroupBox;
    edRecLimit: TEdit;
    lblLimit: TLabel;
    btnApplyFilter: TButton;
    scDescription: TSearchBox;
    ckOnlyImage: TCheckBox;
    Panel4: TPanel;
    Image1: TImage;
    Label1: TLabel;
    DBEdit1: TDBEdit;
    lblTextFilter: TLabel;
    Label2: TLabel;
    DBEdit2: TDBEdit;
    ckEnabled: TDBCheckBox;
    DBCkVisibleOnStore: TDBCheckBox;
    gbExtendeDscription: TGroupBox;
    DBMemoExtendedDescription: TDBMemo;
    lblPictureError: TLabel;
    btnChangeImage: TButton;
    OPD: TOpenPictureDialog;
    procedure xtArticlesAfterScroll(DataSet: TDataSet);
    procedure edRecLimitKeyPress(Sender: TObject; var Key: Char);
    procedure xtArticlesBeforeRefresh(DataSet: TDataSet);
    procedure xtArticlesBeforeOpen(DataSet: TDataSet);
    procedure btnApplyFilterClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure btnChangeImageClick(Sender: TObject);
    procedure scDescriptionKeyPress(Sender: TObject; var Key: Char);
    procedure FormCreate(Sender: TObject);
  private
    procedure setArticlesParams;
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmArticles: TfrmArticles;

implementation

{$R *.dfm}

uses xtCommonTypes, pngImage,Vcl.Imaging.jpeg ;

procedure TfrmArticles.btnApplyFilterClick(Sender: TObject);
begin
 setArticlesParams;
 xtArticles.Refresh;

end;

procedure TfrmArticles.btnChangeImageClick(Sender: TObject);
var
 pk_id: Int64;
begin
 if OPD.Execute then
  Begin
   pk_id := xtDriveCommands.uploadFile(OPD.FileName,'',-1);
   xtArticles.Edit;
   xtArticlesFK_PICTURE_ATTACH.AsLargeInt := pk_id;
   xtArticles.Post;
   Image1.Picture.LoadFromFile(OPD.FileName);
  End;
end;

procedure TfrmArticles.edRecLimitKeyPress(Sender: TObject; var Key: Char);
begin
 if key = #13 then
  Begin
   xtArticles.Refresh;
  End;
end;

procedure TfrmArticles.FormCreate(Sender: TObject);
begin
  DBMemoExtendedDescription.Lines.DefaultEncoding :=
    TEncoding.UTF8;

//  TStrings.DefaultEncoding :=
//    TEncoding.UTF8;

end;

procedure TfrmArticles.FormShow(Sender: TObject);
begin
  setArticlesParams;
  xtArticles.Open;
end;

procedure TfrmArticles.xtArticlesAfterScroll(DataSet: TDataSet);
var
 res: TRecAllegatoProp;

begin
 lblPictureError.Visible := False;



 try
   Image1.Picture := nil;
   if DataSet.FieldByName('FK_PICTURE_ATTACH').AsInteger > 0 then
    begin
     res := xtDriveCommands.dloadFile(DataSet.FieldByName('FK_PICTURE_ATTACH').AsInteger);
     res.MS.Position := 0;
     Image1.Picture.LoadFromStream(res.MS);
    end;
 except
  on e:exception do
   Begin
    lblPictureError.Caption := 'Errore caricamento immagine:' + e.Message;
    lblPictureError.Visible := True;
    lblPictureError.BringToFront;
   End;
 end;
end;

procedure TfrmArticles.xtArticlesBeforeOpen(DataSet: TDataSet);
begin
  setArticlesParams;
end;

procedure TfrmArticles.scDescriptionKeyPress(Sender: TObject; var Key: Char);
begin
 if Key = #13 then
  btnApplyFilterClick(nil);

end;

procedure TfrmArticles.setArticlesParams;
begin
  xtArticles.xtMaxRecords := string(edRecLimit.Text).toInt64;
  xtArticles.xtParams.Clear;
  if ckOnlyImage.Checked then
    xtArticles.xtParams.Values['only_with_image'] := 'Y';
  if scDescription.Text <> '' then
    xtArticles.xtParams.Values['DESC_FILTER'] := scDescription.Text;
end;

procedure TfrmArticles.xtArticlesBeforeRefresh(DataSet: TDataSet);
begin
 setArticlesParams;
end;

end.
