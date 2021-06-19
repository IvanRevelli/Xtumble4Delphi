unit uFrmShopOrders;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, FireDAC.Stan.Intf,
  FireDAC.Stan.Option, FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS,
  FireDAC.Phys.Intf, FireDAC.DApt.Intf, Vcl.ExtDlgs, uxtCommonComponent,
  uXtDriveCommands, FireDAC.Comp.DataSet, FireDAC.Comp.Client, xtDatasetEntity,
  Vcl.StdCtrls, Vcl.WinXCtrls, Vcl.DBCtrls, Vcl.Mask, Vcl.ExtCtrls, Vcl.Grids,
  Vcl.DBGrids, Vcl.ComCtrls;

type
  TfrmShopOrders = class(TForm)
    pnlHeaders: TPanel;
    Panel2: TPanel;
    PageControl1: TPageControl;
    tsGrid: TTabSheet;
    Splitter1: TSplitter;
    gbArticleList: TGroupBox;
    DBGrid1: TDBGrid;
    gbDetail: TGroupBox;
    Panel3: TPanel;
    Panel4: TPanel;
    Image1: TImage;
    Label1: TLabel;
    Label2: TLabel;
    lblPictureError: TLabel;
    DBEdit1: TDBEdit;
    DBEdit2: TDBEdit;
    ckEnabled: TDBCheckBox;
    DBCkVisibleOnStore: TDBCheckBox;
    btnChangeImage: TButton;
    gbExtendeDscription: TGroupBox;
    DBMemoExtendedDescription: TDBMemo;
    DBNavigator1: TDBNavigator;
    gbFilter: TGroupBox;
    lblLimit: TLabel;
    lblTextFilter: TLabel;
    edRecLimit: TEdit;
    btnApplyFilter: TButton;
    scDescription: TSearchBox;
    ckOnlyImage: TCheckBox;
    xtOrdini: TxtDatasetEntity;
    dsOrdini: TDataSource;
    xtDriveCommands: TxtDriveCommands;
    OPD: TOpenPictureDialog;
    xtOrdiniIDDOC: TIntegerField;
    xtOrdiniUSER_ID: TIntegerField;
    xtOrdiniNR_DOC: TIntegerField;
    xtOrdiniDATA_DOC: TSQLTimeStampField;
    xtOrdiniTIPO_DOC: TStringField;
    xtOrdiniIDCONTATTO: TIntegerField;
    xtOrdiniIDMAGAZZINO: TIntegerField;
    xtOrdiniNR_DOC_FORNITORE: TStringField;
    xtOrdiniIDCAUSALE_TRASPORTO: TIntegerField;
    xtOrdiniIDBANCA: TIntegerField;
    xtOrdiniINDIRIZZO: TStringField;
    xtOrdiniNR_ORDINE: TIntegerField;
    xtOrdiniDATA_ORDINE: TSQLTimeStampField;
    xtOrdiniIDVALUTA: TIntegerField;
    xtOrdiniIDPAGAMENTO: TIntegerField;
    xtOrdiniIDMODALITA_PAGAMENTO: TIntegerField;
    xtOrdiniIDLISTINO_APPLICATO: TIntegerField;
    xtOrdiniIDASPETTO_ESTERIORE: TIntegerField;
    xtOrdiniRAGIONE_SOCIALE: TStringField;
    xtOrdiniCAP: TStringField;
    xtOrdiniLOCALITA: TStringField;
    xtOrdiniIDPROVINCIA: TStringField;
    xtOrdiniP_IVA_CF: TStringField;
    xtOrdiniIMP_TRASPORTO_EURO: TFloatField;
    xtOrdiniIVA_TRASPORTO: TIntegerField;
    xtOrdiniIMBALLO: TStringField;
    xtOrdiniIMP_IMBALLO_EURO: TFloatField;
    xtOrdiniIVA_IMBALLO: TFMTBCDField;
    xtOrdiniSCONTO_CASSA: TFloatField;
    xtOrdiniIMP_BOLLI_EURO: TFloatField;
    xtOrdiniTOT_DOC_EURO: TFloatField;
    xtOrdiniIMPONIBILE_EURO: TFloatField;
    xtOrdiniDESTINAZIONE_R1: TStringField;
    xtOrdiniDESTINAZIONE_R2: TStringField;
    xtOrdiniDESTINAZIONE_R3: TStringField;
    xtOrdiniTRASPORTO_MEZZO: TStringField;
    xtOrdiniVETTORE_R1: TStringField;
    xtOrdiniVETTORE_R2: TStringField;
    xtOrdiniVETTORE_R3: TStringField;
    xtOrdiniSTAMPATO: TStringField;
    xtOrdiniSCONTO_ECCEZZIONALE: TFloatField;
    xtOrdiniTOTALE_IVA_EURO: TFloatField;
    xtOrdiniNR_COLLI: TIntegerField;
    xtOrdiniPORTO: TStringField;
    xtOrdiniPESO_NETTO_TOTALE: TFloatField;
    xtOrdiniPESO_TARA_TOTALE: TFloatField;
    xtOrdiniFATTURATO: TStringField;
    xtOrdiniESENTE_IVA: TStringField;
    xtOrdiniDESCR_ESENZIONE_IVA: TStringField;
    xtOrdiniDATA_PARTENZA: TSQLTimeStampField;
    xtOrdiniORA_PARTENZA: TSQLTimeStampField;
    xtOrdiniDESCR_LEGAME_DOC: TStringField;
    xtOrdiniIDSERVIZIO: TIntegerField;
    xtOrdiniDESTINAZIONE_R4: TStringField;
    xtOrdiniIDNAZIONE: TIntegerField;
    xtOrdiniIDREGIONE: TIntegerField;
    xtOrdiniDOCCHIUSO: TIntegerField;
    xtOrdiniIDCONTATTO_COMMERCIALE: TIntegerField;
    xtOrdiniIDCONTATTO_ANALISTA: TIntegerField;
    xtOrdiniIDCONTATTO_CONSULENTE: TIntegerField;
    xtOrdiniIDCONTATTO_CONSULENTE2: TIntegerField;
    xtOrdiniOLD_KEY: TStringField;
    xtOrdiniCK_ANAG: TStringField;
    xtOrdiniCODCONTO: TStringField;
    xtOrdiniDATA_CONSEGNA: TSQLTimeStampField;
    xtOrdiniDESCRIZIONE_LIBERA: TStringField;
    xtOrdiniPERC_CASSA_PROF: TIntegerField;
    xtOrdiniIMPORTO_CASSA_PROF_EURO: TFloatField;
    xtOrdiniIVA_SU_CASSA_PROF: TFMTBCDField;
    xtOrdiniPERC_RITENUTA_ACCONTO: TFloatField;
    xtOrdiniIMPORTO_RITENUTA_ACCONTO_EURO: TFloatField;
    xtOrdiniIMPORTO_SPESE_ESENTI_ART15_EURO: TFloatField;
    xtOrdiniUM_PESO_TARA: TStringField;
    xtOrdiniUM_PESO_NETTO: TStringField;
    xtOrdiniUM_VOLUME: TStringField;
    xtOrdiniVOLUME: TFloatField;
    xtOrdiniMARCATURA_COLLI: TStringField;
    xtOrdiniPERC_RIVALSA_INPS: TFloatField;
    xtOrdiniIMPORTO_RIVALSA_INPS: TFloatField;
    xtOrdiniIVA_RIVALSA_INPS: TFMTBCDField;
    xtOrdiniTOTALI_FORZATI: TStringField;
    xtOrdiniFK_QUESTIONARIO: TIntegerField;
    xtOrdiniSALDO_SCADENZE_COMLETO: TStringField;
    xtOrdiniDATA_PROS_SCAD_PAGAMENTO: TSQLTimeStampField;
    xtOrdiniNOTE: TStringField;
    xtOrdiniFLG_FORCE_DO_NOT_UPD_SCAD: TStringField;
    xtOrdiniCOD_FISCALE: TStringField;
    xtOrdiniNUMERO_CIVICO: TStringField;
    xtOrdiniFK_SEDE: TIntegerField;
    xtOrdiniDB_SYNC_ID: TLargeintField;
    xtOrdiniUID: TStringField;
    xtOrdiniFK_STATO: TIntegerField;
    xtOrdiniFK_XML_FE: TIntegerField;
    xtOrdiniFK_STATO_FE: TIntegerField;
    xtOrdiniFK_DIVISA: TIntegerField;
    xtOrdiniCODICE_DESTINATARIO_FE: TStringField;
    xtOrdiniPEC: TStringField;
    xtOrdiniCAUSALE: TStringField;
    xtOrdiniSDI_FILENAME: TStringField;
    xtOrdiniFK_ALLEGATO_SDI: TIntegerField;
    xtOrdiniARROTONDAMENTO: TFloatField;
    xtOrdiniFK_TIPO_RITENUTA: TIntegerField;
    xtOrdiniPERC_RITENUTA_ACCONTO_SU: TFloatField;
    xtOrdiniFK_CAUSALE_RITENUTA: TIntegerField;
    xtOrdiniFORMATO_TRASMISSIONE: TStringField;
    xtOrdiniPROGRESSIVO_INVIO_FE: TLargeintField;
    xtOrdiniNR_DOC_FE: TStringField;
    xtOrdiniPRIVATO: TStringField;
    xtOrdiniNOME: TStringField;
    xtOrdiniCOGNOME: TStringField;
    xtOrdiniNETTO_A_PAGARE: TFloatField;
    xtOrdiniDESC_CONDIZIONI_ECONOMICHE: TStringField;
    xtOrdiniDATA_ULTIMA_MODIFICA: TSQLTimeStampField;
    xtOrdiniPAYPAL_ORDER: TStringField;
    xtOrdiniRESTO_EURO: TFloatField;
    xtOrdiniCODICE_CASSA: TIntegerField;
    xtOrdiniIDENTITA: TIntegerField;
    xtOrdiniFK_USER_CREATOR: TLargeintField;
    xtOrdiniCODICE_LOTTERIA: TStringField;
    xtOrdiniTRACKING_LINK: TStringField;
    xtOrdiniCODICE_COUPON: TStringField;
    xtOrdiniDESC_STATO_DOC: TStringField;
    xtOrdiniCLASS_STATO_DOC: TStringField;
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmShopOrders: TfrmShopOrders;

implementation

{$R *.dfm}

procedure TfrmShopOrders.FormShow(Sender: TObject);
begin
  xtOrdini.xtMaxRecords := string(edRecLimit.Text).toInt64;
  xtOrdini.xtParams.Clear;
//  if ckOnlyImage.Checked then
//    xtOrdini.xtParams.Values['only_with_image'] := 'Y';
//  if scDescription.Text <> '' then
//    xtOrdini.xtParams.Values['DESC_FILTER'] := scDescription.Text;
  xtOrdini.Open;
end;

end.
