unit ufrmDashboard;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, uXtDriveCommands, Data.DB,
  FireDAC.Comp.DataSet, FireDAC.Comp.Client, xtDatasetEntity, Vcl.StdCtrls,
  Vcl.Mask, Vcl.DBCtrls, uxtStore, uxtCommonComponent, pasDmXtumble,
  Vcl.ComCtrls;

type
  TfrmDashboard = class(TForm)
    pnlHader: TPanel;
    Panel1: TPanel;
    Image1: TImage;
    pnlCompanyData: TPanel;
    Panel2: TPanel;
    dsMyCompany: TDataSource;
    xtMyCompany: TxtDatasetEntity;
    Panel3: TPanel;
    xtDriveCommands1: TxtDriveCommands;
    Label1: TLabel;
    DBEdit1: TDBEdit;
    Label2: TLabel;
    DBEdit2: TDBEdit;
    Label3: TLabel;
    DBEdit3: TDBEdit;
    btnChangeLogo: TButton;
    FileOpenDialog1: TFileOpenDialog;
    xtMyCompanyIDCONTATTO: TIntegerField;
    xtMyCompanyCODPV: TStringField;
    xtMyCompanyIDZONA: TIntegerField;
    xtMyCompanyIDPROVINCIA: TStringField;
    xtMyCompanyIDREGIONE: TIntegerField;
    xtMyCompanyIDNAZIONE: TIntegerField;
    xtMyCompanyPRIVATO: TStringField;
    xtMyCompanyNOME: TStringField;
    xtMyCompanyCOGNOME: TStringField;
    xtMyCompanyINDIRIZZO: TStringField;
    xtMyCompanyLOCALITA: TStringField;
    xtMyCompanyCAP: TStringField;
    xtMyCompanyRAGIONE_SOCIALE: TStringField;
    xtMyCompanyTELEFONO_ABITAZIONE: TStringField;
    xtMyCompanyTELEFONO_CELLULARE: TStringField;
    xtMyCompanyTELEFONO_CELLULARE2: TStringField;
    xtMyCompanyFAX_UFFICIO: TStringField;
    xtMyCompanyTELEFONO_UFFICIO1: TStringField;
    xtMyCompanyTELEFONO_UFFICIO2: TStringField;
    xtMyCompanyPOSTA_ELETTRONICA: TStringField;
    xtMyCompanySITO_INTERNET_AZIENDA: TStringField;
    xtMyCompanyDATA_REGISTRAZIONE: TSQLTimeStampField;
    xtMyCompanyCOD_FISCALE: TStringField;
    xtMyCompanyP_IVA: TStringField;
    xtMyCompanyCCIAA: TStringField;
    xtMyCompanyISCRIZIONE_TRIBUNALE: TStringField;
    xtMyCompanyDATA_ULTIMA_MODIFICA: TSQLTimeStampField;
    xtMyCompanyCAP_SOCIALE_EURO: TFloatField;
    xtMyCompanyESENTE_IVA: TStringField;
    xtMyCompanyDESCR_ESENZIONE_IVA: TStringField;
    xtMyCompanyDATA_NASCITA: TSQLTimeStampField;
    xtMyCompanyCITTA: TStringField;
    xtMyCompanyCODICEISO: TStringField;
    xtMyCompanyIDLINGUA: TIntegerField;
    xtMyCompanyIDTIPO_PROFESSIONISTA: TIntegerField;
    xtMyCompanyMAIL: TStringField;
    xtMyCompanyNATO_A: TStringField;
    xtMyCompanyNUMERO_CIVICO: TStringField;
    xtMyCompanySESSO: TStringField;
    xtMyCompanySKYPE: TStringField;
    xtMyCompanyNOTE: TStringField;
    xtMyCompanyFK_ALLEGATO_FOTO_LOGO: TIntegerField;
    xtMyCompanyDUNS_NUMBER: TStringField;
    xtMyCompanyPEC: TStringField;
    xtMyCompanyCODICE_DESTINATARIO_FE: TStringField;
    xtMyCompanyNR_REA: TStringField;
    xtMyCompanyCOD_SOCIO_UNICO: TStringField;
    xtMyCompanyCOD_STATO_LIQUIDAZIONE: TStringField;
    xtMyCompanyFACEBOOK: TStringField;
    xtMyCompanyLINKEDIN: TStringField;
    xtMyCompanyYOUTUBE: TStringField;
    xtMyCompanyTWITTER: TStringField;
    xtMyCompanyINSTAGRAM: TStringField;
    xtMyCompanyPINTEREST: TStringField;
    Label4: TLabel;
    DBEdit4: TDBEdit;
    xtStore1: TxtStore;
    pgDashBoardDetails: TPageControl;
    tsUsers: TTabSheet;
    tsWebResources: TTabSheet;
    GroupBox1: TGroupBox;
    GroupBox2: TGroupBox;
    llStoreUrl: TLabel;
    edWebAlias: TLabeledEdit;
    btnChangeWebAlias: TButton;
    GroupBox3: TGroupBox;
    Label5: TLabel;
    StaticText1: TStaticText;
    pgUsers: TPageControl;
    tsProfile: TTabSheet;
    tsOtherUsers: TTabSheet;
    StaticText2: TStaticText;
    StaticText3: TStaticText;
    procedure xtMyCompanyAfterScroll(DataSet: TDataSet);
    procedure FormShow(Sender: TObject);
    procedure btnChangeLogoClick(Sender: TObject);
    procedure llStoreUrlClick(Sender: TObject);
    procedure btnChangeWebAliasClick(Sender: TObject);
    procedure xtStore1WebAliasChange(Sender: TObject);
  private
    procedure refreshLogo(DataSet: TDataSet);
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmDashboard: TfrmDashboard;

implementation

{$R *.dfm}

uses xtCommonTypes, pngImage,Vcl.Imaging.jpeg, ShellAPI ;

procedure TfrmDashboard.btnChangeLogoClick(Sender: TObject);
var
  lpk_logo: Int64;
begin
 if FileOpenDialog1.Execute then
  Begin
   xtMyCompany.Edit;
   lpk_logo := xtDriveCommands1.uploadFile(FileOpenDialog1.FileName,'',28);
   xtMyCompany.FieldByName('FK_ALLEGATO_FOTO_LOGO').asLargeInt := lpk_logo;


   xtMyCompany.Post;
   refreshLogo(xtMyCompany);

  End;
end;

procedure TfrmDashboard.refreshLogo(DataSet: TDataSet);
var
  res: TRecAllegatoProp;
begin
  if DataSet.FieldByName('FK_ALLEGATO_FOTO_LOGO').AsInteger > 0 then
  begin
    res := xtDriveCommands1.dloadFile(DataSet.FieldByName('FK_ALLEGATO_FOTO_LOGO').AsInteger);
    res.MS.Position := 0;
    Image1.Picture.LoadFromStream(res.MS);
  end;
end;

procedure TfrmDashboard.btnChangeWebAliasClick(Sender: TObject);
var
  webAlias: string;
begin
 webAlias := xtStore1.webAlias;
 if inputquery('New web alias','New web alias',webAlias) then
  Begin
   xtStore1.webAlias := webAlias;
  End;
end;

procedure TfrmDashboard.FormShow(Sender: TObject);
begin
 xtMyCompany.Open;
 xtStore1.active := True;
end;

procedure TfrmDashboard.llStoreUrlClick(Sender: TObject);
begin
  ShellExecute(0,'open',PChar(TLabel(Sender).Caption),'','',SW_NORMAL);
end;

procedure TfrmDashboard.xtMyCompanyAfterScroll(DataSet: TDataSet);
begin
  refreshLogo(DataSet);
end;

procedure TfrmDashboard.xtStore1WebAliasChange(Sender: TObject);
begin
 edWebAlias.Text := xtStore1.webAlias;
 llStoreUrl.Caption := xtStore1.StoreUrl;
end;

end.
