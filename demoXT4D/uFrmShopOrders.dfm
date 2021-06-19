object frmShopOrders: TfrmShopOrders
  Left = 0
  Top = 0
  Caption = 'E-Commerce Orders'
  ClientHeight = 732
  ClientWidth = 1206
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object pnlHeaders: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 1200
    Height = 41
    Align = alTop
    Caption = 'E-COMMERCE ORDERS'
    Color = 4204489
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Century'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    TabOrder = 0
    ExplicitLeft = -2
    ExplicitWidth = 918
  end
  object Panel2: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 677
    Width = 1200
    Height = 52
    Align = alBottom
    TabOrder = 1
    ExplicitLeft = -2
    ExplicitTop = 638
    ExplicitWidth = 918
  end
  object PageControl1: TPageControl
    AlignWithMargins = True
    Left = 10
    Top = 163
    Width = 1186
    Height = 501
    Margins.Left = 10
    Margins.Top = 10
    Margins.Right = 10
    Margins.Bottom = 10
    ActivePage = tsGrid
    Align = alClient
    TabOrder = 2
    ExplicitLeft = 5
    ExplicitWidth = 904
    ExplicitHeight = 462
    object tsGrid: TTabSheet
      Caption = 'Grid'
      object Splitter1: TSplitter
        Left = 691
        Top = 25
        Width = 4
        Height = 448
        ExplicitLeft = 392
        ExplicitTop = 31
        ExplicitHeight = 395
      end
      object gbArticleList: TGroupBox
        AlignWithMargins = True
        Left = 10
        Top = 35
        Width = 671
        Height = 428
        Margins.Left = 10
        Margins.Top = 10
        Margins.Right = 10
        Margins.Bottom = 10
        Align = alLeft
        Caption = 'List'
        TabOrder = 0
        object DBGrid1: TDBGrid
          AlignWithMargins = True
          Left = 7
          Top = 25
          Width = 657
          Height = 391
          Margins.Left = 5
          Margins.Top = 10
          Margins.Right = 5
          Margins.Bottom = 10
          Align = alClient
          DataSource = dsOrdini
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Tahoma'
          TitleFont.Style = []
        end
      end
      object gbDetail: TGroupBox
        AlignWithMargins = True
        Left = 705
        Top = 35
        Width = 463
        Height = 428
        Margins.Left = 10
        Margins.Top = 10
        Margins.Right = 10
        Margins.Bottom = 10
        Align = alClient
        Caption = 'Detal'
        TabOrder = 1
        ExplicitLeft = 409
        ExplicitWidth = 550
        ExplicitHeight = 375
        object Panel3: TPanel
          AlignWithMargins = True
          Left = 5
          Top = 18
          Width = 453
          Height = 405
          Align = alClient
          TabOrder = 0
          ExplicitWidth = 540
          ExplicitHeight = 352
          object Panel4: TPanel
            Left = 1
            Top = 1
            Width = 451
            Height = 200
            Margins.Left = 10
            Margins.Top = 10
            Margins.Right = 10
            Margins.Bottom = 10
            Align = alTop
            TabOrder = 0
            ExplicitWidth = 538
            object Image1: TImage
              AlignWithMargins = True
              Left = 11
              Top = 11
              Width = 185
              Height = 178
              Margins.Left = 10
              Margins.Top = 10
              Margins.Right = 10
              Margins.Bottom = 10
              Align = alLeft
              Proportional = True
              Stretch = True
              ExplicitLeft = 8
              ExplicitTop = -39
              ExplicitHeight = 174
            end
            object Label1: TLabel
              Left = 241
              Top = 16
              Width = 56
              Height = 13
              Caption = 'Article code'
              FocusControl = DBEdit1
            end
            object Label2: TLabel
              Left = 241
              Top = 72
              Width = 53
              Height = 13
              Caption = 'Description'
              FocusControl = DBEdit2
            end
            object lblPictureError: TLabel
              Left = 20
              Top = 72
              Width = 170
              Height = 49
              AutoSize = False
              Caption = 'Errore caricamento immagine'
              Font.Charset = DEFAULT_CHARSET
              Font.Color = clRed
              Font.Height = -13
              Font.Name = 'Tahoma'
              Font.Style = []
              ParentFont = False
              Visible = False
              WordWrap = True
              StyleElements = [seClient, seBorder]
            end
            object DBEdit1: TDBEdit
              Left = 241
              Top = 35
              Width = 216
              Height = 21
              DataField = 'CODE'
              TabOrder = 0
            end
            object DBEdit2: TDBEdit
              Left = 241
              Top = 91
              Width = 216
              Height = 21
              DataField = 'DESCRIPTION'
              TabOrder = 1
            end
            object ckEnabled: TDBCheckBox
              Left = 241
              Top = 128
              Width = 97
              Height = 17
              Caption = 'Enabled'
              DataField = 'ENABLED'
              TabOrder = 2
              ValueChecked = #39'S'#39
              ValueUnchecked = #39'N'#39
            end
            object DBCkVisibleOnStore: TDBCheckBox
              Left = 241
              Top = 160
              Width = 184
              Height = 17
              Caption = 'E-Commerce enabled'
              DataField = 'VISIBLE_ON_STORE'
              TabOrder = 3
              ValueChecked = '1'
              ValueUnchecked = '0'
            end
            object btnChangeImage: TButton
              Left = 20
              Top = 153
              Width = 175
              Height = 41
              Caption = 'Change'
              Style = bsCommandLink
              TabOrder = 4
            end
          end
          object gbExtendeDscription: TGroupBox
            Left = 1
            Top = 201
            Width = 451
            Height = 120
            Align = alTop
            Caption = 'Extended description'
            TabOrder = 1
            ExplicitWidth = 538
            object DBMemoExtendedDescription: TDBMemo
              AlignWithMargins = True
              Left = 12
              Top = 25
              Width = 427
              Height = 83
              Margins.Left = 10
              Margins.Top = 10
              Margins.Right = 10
              Margins.Bottom = 10
              Align = alClient
              DataField = 'EXTENDED_DESCRIPTION'
              TabOrder = 0
              ExplicitWidth = 514
            end
          end
        end
      end
      object DBNavigator1: TDBNavigator
        Left = 0
        Top = 0
        Width = 1178
        Height = 25
        DataSource = dsOrdini
        Align = alTop
        TabOrder = 2
        ExplicitWidth = 969
      end
    end
  end
  object gbFilter: TGroupBox
    Left = 0
    Top = 47
    Width = 1206
    Height = 106
    Align = alTop
    Caption = 'Funnel'
    TabOrder = 3
    ExplicitLeft = -5
    ExplicitWidth = 924
    object lblLimit: TLabel
      Left = 24
      Top = 33
      Width = 55
      Height = 13
      Caption = 'Limit result:'
    end
    object lblTextFilter: TLabel
      Left = 250
      Top = 33
      Width = 47
      Height = 13
      Caption = 'Text filter'
    end
    object edRecLimit: TEdit
      Left = 85
      Top = 30
      Width = 76
      Height = 21
      NumbersOnly = True
      TabOrder = 0
      Text = '100'
    end
    object btnApplyFilter: TButton
      AlignWithMargins = True
      Left = 1045
      Top = 30
      Width = 139
      Height = 59
      Margins.Left = 20
      Margins.Top = 15
      Margins.Right = 20
      Margins.Bottom = 15
      Align = alRight
      Caption = 'Apply Filter'
      TabOrder = 1
      ExplicitLeft = 836
    end
    object scDescription: TSearchBox
      Left = 314
      Top = 30
      Width = 235
      Height = 21
      TabOrder = 2
    end
    object ckOnlyImage: TCheckBox
      Left = 24
      Top = 73
      Width = 163
      Height = 17
      Caption = 'Only Articles with image'
      TabOrder = 3
    end
  end
  object xtOrdini: TxtDatasetEntity
    xtConnection = dmXtumble.XtConnection
    xtEntityName = 'ShopOrders'
    xtRefreshAfterPost = False
    xtApplyUpdateAfterPost = True
    xtApplyUpdateAfterDelete = True
    xtLiveRecordInsert = True
    xtMaxRecords = 10
    FieldDefs = <>
    CachedUpdates = True
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    StoreDefs = True
    Left = 43
    Top = 546
    object xtOrdiniIDDOC: TIntegerField
      FieldName = 'IDDOC'
      Origin = 'IDDOC'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object xtOrdiniNR_DOC: TIntegerField
      FieldName = 'NR_DOC'
      Origin = 'NR_DOC'
      Required = True
    end
    object xtOrdiniNR_ORDINE: TIntegerField
      FieldName = 'NR_ORDINE'
      Origin = 'NR_ORDINE'
    end
    object xtOrdiniRAGIONE_SOCIALE: TStringField
      DisplayWidth = 30
      FieldName = 'RAGIONE_SOCIALE'
      Origin = 'RAGIONE_SOCIALE'
      Size = 200
    end
    object xtOrdiniNOME: TStringField
      DisplayWidth = 30
      FieldName = 'NOME'
      Origin = 'NOME'
      Size = 200
    end
    object xtOrdiniCOGNOME: TStringField
      DisplayWidth = 30
      FieldName = 'COGNOME'
      Origin = 'COGNOME'
      Size = 200
    end
    object xtOrdiniINDIRIZZO: TStringField
      DisplayWidth = 30
      FieldName = 'INDIRIZZO'
      Origin = 'INDIRIZZO'
      Size = 100
    end
    object xtOrdiniCAP: TStringField
      FieldName = 'CAP'
      Origin = 'CAP'
      Size = 10
    end
    object xtOrdiniLOCALITA: TStringField
      FieldName = 'LOCALITA'
      Origin = 'LOCALITA'
      Size = 200
    end
    object xtOrdiniIDPROVINCIA: TStringField
      FieldName = 'IDPROVINCIA'
      Origin = 'IDPROVINCIA'
      Size = 10
    end
    object xtOrdiniP_IVA_CF: TStringField
      FieldName = 'P_IVA_CF'
      Origin = 'P_IVA_CF'
    end
    object xtOrdiniUSER_ID: TIntegerField
      FieldName = 'USER_ID'
      Origin = 'USER_ID'
      Required = True
    end
    object xtOrdiniDATA_DOC: TSQLTimeStampField
      FieldName = 'DATA_DOC'
      Origin = 'DATA_DOC'
      Required = True
    end
    object xtOrdiniDESTINAZIONE_R1: TStringField
      FieldName = 'DESTINAZIONE_R1'
      Origin = 'DESTINAZIONE_R1'
      Size = 100
    end
    object xtOrdiniDESTINAZIONE_R2: TStringField
      FieldName = 'DESTINAZIONE_R2'
      Origin = 'DESTINAZIONE_R2'
      Size = 45
    end
    object xtOrdiniDESTINAZIONE_R3: TStringField
      FieldName = 'DESTINAZIONE_R3'
      Origin = 'DESTINAZIONE_R3'
      Size = 45
    end
    object xtOrdiniTIPO_DOC: TStringField
      FieldName = 'TIPO_DOC'
      Origin = 'TIPO_DOC'
      Required = True
      FixedChar = True
      Size = 1
    end
    object xtOrdiniDATA_ORDINE: TSQLTimeStampField
      FieldName = 'DATA_ORDINE'
      Origin = 'DATA_ORDINE'
    end
    object xtOrdiniIMPONIBILE_EURO: TFloatField
      FieldName = 'IMPONIBILE_EURO'
      Origin = 'IMPONIBILE_EURO'
    end
    object xtOrdiniTOT_DOC_EURO: TFloatField
      FieldName = 'TOT_DOC_EURO'
      Origin = 'TOT_DOC_EURO'
    end
    object xtOrdiniIMP_TRASPORTO_EURO: TFloatField
      FieldName = 'IMP_TRASPORTO_EURO'
      Origin = 'IMP_TRASPORTO_EURO'
    end
    object xtOrdiniIVA_TRASPORTO: TIntegerField
      FieldName = 'IVA_TRASPORTO'
      Origin = 'IVA_TRASPORTO'
    end
    object xtOrdiniIMBALLO: TStringField
      FieldName = 'IMBALLO'
      Origin = 'IMBALLO'
      FixedChar = True
      Size = 1
    end
    object xtOrdiniIMP_IMBALLO_EURO: TFloatField
      FieldName = 'IMP_IMBALLO_EURO'
      Origin = 'IMP_IMBALLO_EURO'
    end
    object xtOrdiniIVA_IMBALLO: TFMTBCDField
      FieldName = 'IVA_IMBALLO'
      Origin = 'IVA_IMBALLO'
      Precision = 18
      Size = 2
    end
    object xtOrdiniSCONTO_CASSA: TFloatField
      FieldName = 'SCONTO_CASSA'
      Origin = 'SCONTO_CASSA'
    end
    object xtOrdiniIMP_BOLLI_EURO: TFloatField
      FieldName = 'IMP_BOLLI_EURO'
      Origin = 'IMP_BOLLI_EURO'
    end
    object xtOrdiniTRASPORTO_MEZZO: TStringField
      FieldName = 'TRASPORTO_MEZZO'
      Origin = 'TRASPORTO_MEZZO'
      FixedChar = True
      Size = 1
    end
    object xtOrdiniVETTORE_R1: TStringField
      FieldName = 'VETTORE_R1'
      Origin = 'VETTORE_R1'
      Size = 30
    end
    object xtOrdiniVETTORE_R2: TStringField
      FieldName = 'VETTORE_R2'
      Origin = 'VETTORE_R2'
      Size = 30
    end
    object xtOrdiniVETTORE_R3: TStringField
      FieldName = 'VETTORE_R3'
      Origin = 'VETTORE_R3'
      Size = 30
    end
    object xtOrdiniSTAMPATO: TStringField
      FieldName = 'STAMPATO'
      Origin = 'STAMPATO'
      FixedChar = True
      Size = 1
    end
    object xtOrdiniSCONTO_ECCEZZIONALE: TFloatField
      FieldName = 'SCONTO_ECCEZZIONALE'
      Origin = 'SCONTO_ECCEZZIONALE'
    end
    object xtOrdiniTOTALE_IVA_EURO: TFloatField
      FieldName = 'TOTALE_IVA_EURO'
      Origin = 'TOTALE_IVA_EURO'
    end
    object xtOrdiniNR_COLLI: TIntegerField
      FieldName = 'NR_COLLI'
      Origin = 'NR_COLLI'
    end
    object xtOrdiniPORTO: TStringField
      FieldName = 'PORTO'
      Origin = 'PORTO'
      FixedChar = True
      Size = 1
    end
    object xtOrdiniPESO_NETTO_TOTALE: TFloatField
      FieldName = 'PESO_NETTO_TOTALE'
      Origin = 'PESO_NETTO_TOTALE'
    end
    object xtOrdiniPESO_TARA_TOTALE: TFloatField
      FieldName = 'PESO_TARA_TOTALE'
      Origin = 'PESO_TARA_TOTALE'
    end
    object xtOrdiniFATTURATO: TStringField
      FieldName = 'FATTURATO'
      Origin = 'FATTURATO'
      FixedChar = True
      Size = 1
    end
    object xtOrdiniESENTE_IVA: TStringField
      FieldName = 'ESENTE_IVA'
      Origin = 'ESENTE_IVA'
      FixedChar = True
      Size = 1
    end
    object xtOrdiniDESCR_ESENZIONE_IVA: TStringField
      FieldName = 'DESCR_ESENZIONE_IVA'
      Origin = 'DESCR_ESENZIONE_IVA'
      Size = 100
    end
    object xtOrdiniDATA_PARTENZA: TSQLTimeStampField
      FieldName = 'DATA_PARTENZA'
      Origin = 'DATA_PARTENZA'
    end
    object xtOrdiniORA_PARTENZA: TSQLTimeStampField
      FieldName = 'ORA_PARTENZA'
      Origin = 'ORA_PARTENZA'
    end
    object xtOrdiniDESCR_LEGAME_DOC: TStringField
      FieldName = 'DESCR_LEGAME_DOC'
      Origin = 'DESCR_LEGAME_DOC'
      Size = 2000
    end
    object xtOrdiniIDBANCA: TIntegerField
      FieldName = 'IDBANCA'
      Origin = 'IDBANCA'
    end
    object xtOrdiniIDCAUSALE_TRASPORTO: TIntegerField
      FieldName = 'IDCAUSALE_TRASPORTO'
      Origin = 'IDCAUSALE_TRASPORTO'
    end
    object xtOrdiniNR_DOC_FORNITORE: TStringField
      FieldName = 'NR_DOC_FORNITORE'
      Origin = 'NR_DOC_FORNITORE'
    end
    object xtOrdiniIDMAGAZZINO: TIntegerField
      FieldName = 'IDMAGAZZINO'
      Origin = 'IDMAGAZZINO'
      Required = True
    end
    object xtOrdiniIDCONTATTO: TIntegerField
      FieldName = 'IDCONTATTO'
      Origin = 'IDCONTATTO'
      Required = True
    end
    object xtOrdiniIDSERVIZIO: TIntegerField
      FieldName = 'IDSERVIZIO'
      Origin = 'IDSERVIZIO'
    end
    object xtOrdiniIDASPETTO_ESTERIORE: TIntegerField
      FieldName = 'IDASPETTO_ESTERIORE'
      Origin = 'IDASPETTO_ESTERIORE'
    end
    object xtOrdiniIDLISTINO_APPLICATO: TIntegerField
      FieldName = 'IDLISTINO_APPLICATO'
      Origin = 'IDLISTINO_APPLICATO'
    end
    object xtOrdiniIDMODALITA_PAGAMENTO: TIntegerField
      FieldName = 'IDMODALITA_PAGAMENTO'
      Origin = 'IDMODALITA_PAGAMENTO'
    end
    object xtOrdiniIDPAGAMENTO: TIntegerField
      FieldName = 'IDPAGAMENTO'
      Origin = 'IDPAGAMENTO'
    end
    object xtOrdiniIDVALUTA: TIntegerField
      FieldName = 'IDVALUTA'
      Origin = 'IDVALUTA'
    end
    object xtOrdiniDESTINAZIONE_R4: TStringField
      FieldName = 'DESTINAZIONE_R4'
      Origin = 'DESTINAZIONE_R4'
      Size = 45
    end
    object xtOrdiniIDNAZIONE: TIntegerField
      FieldName = 'IDNAZIONE'
      Origin = 'IDNAZIONE'
    end
    object xtOrdiniIDREGIONE: TIntegerField
      FieldName = 'IDREGIONE'
      Origin = 'IDREGIONE'
    end
    object xtOrdiniDOCCHIUSO: TIntegerField
      FieldName = 'DOCCHIUSO'
      Origin = 'DOCCHIUSO'
    end
    object xtOrdiniIDCONTATTO_COMMERCIALE: TIntegerField
      FieldName = 'IDCONTATTO_COMMERCIALE'
      Origin = 'IDCONTATTO_COMMERCIALE'
    end
    object xtOrdiniIDCONTATTO_ANALISTA: TIntegerField
      FieldName = 'IDCONTATTO_ANALISTA'
      Origin = 'IDCONTATTO_ANALISTA'
    end
    object xtOrdiniIDCONTATTO_CONSULENTE: TIntegerField
      FieldName = 'IDCONTATTO_CONSULENTE'
      Origin = 'IDCONTATTO_CONSULENTE'
    end
    object xtOrdiniIDCONTATTO_CONSULENTE2: TIntegerField
      FieldName = 'IDCONTATTO_CONSULENTE2'
      Origin = 'IDCONTATTO_CONSULENTE2'
    end
    object xtOrdiniOLD_KEY: TStringField
      FieldName = 'OLD_KEY'
      Origin = 'OLD_KEY'
      Size = 30
    end
    object xtOrdiniCK_ANAG: TStringField
      FieldName = 'CK_ANAG'
      Origin = 'CK_ANAG'
      FixedChar = True
      Size = 1
    end
    object xtOrdiniCODCONTO: TStringField
      FieldName = 'CODCONTO'
      Origin = 'CODCONTO'
      Size = 10
    end
    object xtOrdiniDATA_CONSEGNA: TSQLTimeStampField
      FieldName = 'DATA_CONSEGNA'
      Origin = 'DATA_CONSEGNA'
    end
    object xtOrdiniDESCRIZIONE_LIBERA: TStringField
      FieldName = 'DESCRIZIONE_LIBERA'
      Origin = 'DESCRIZIONE_LIBERA'
      Size = 200
    end
    object xtOrdiniPERC_CASSA_PROF: TIntegerField
      FieldName = 'PERC_CASSA_PROF'
      Origin = 'PERC_CASSA_PROF'
    end
    object xtOrdiniIMPORTO_CASSA_PROF_EURO: TFloatField
      FieldName = 'IMPORTO_CASSA_PROF_EURO'
      Origin = 'IMPORTO_CASSA_PROF_EURO'
    end
    object xtOrdiniIVA_SU_CASSA_PROF: TFMTBCDField
      FieldName = 'IVA_SU_CASSA_PROF'
      Origin = 'IVA_SU_CASSA_PROF'
      Precision = 18
      Size = 2
    end
    object xtOrdiniPERC_RITENUTA_ACCONTO: TFloatField
      FieldName = 'PERC_RITENUTA_ACCONTO'
      Origin = 'PERC_RITENUTA_ACCONTO'
    end
    object xtOrdiniIMPORTO_RITENUTA_ACCONTO_EURO: TFloatField
      FieldName = 'IMPORTO_RITENUTA_ACCONTO_EURO'
      Origin = 'IMPORTO_RITENUTA_ACCONTO_EURO'
    end
    object xtOrdiniIMPORTO_SPESE_ESENTI_ART15_EURO: TFloatField
      FieldName = 'IMPORTO_SPESE_ESENTI_ART15_EURO'
      Origin = 'IMPORTO_SPESE_ESENTI_ART15_EURO'
    end
    object xtOrdiniUM_PESO_TARA: TStringField
      FieldName = 'UM_PESO_TARA'
      Origin = 'UM_PESO_TARA'
      Size = 10
    end
    object xtOrdiniUM_PESO_NETTO: TStringField
      FieldName = 'UM_PESO_NETTO'
      Origin = 'UM_PESO_NETTO'
      Size = 10
    end
    object xtOrdiniUM_VOLUME: TStringField
      FieldName = 'UM_VOLUME'
      Origin = 'UM_VOLUME'
      Size = 10
    end
    object xtOrdiniVOLUME: TFloatField
      FieldName = 'VOLUME'
      Origin = 'VOLUME'
    end
    object xtOrdiniMARCATURA_COLLI: TStringField
      FieldName = 'MARCATURA_COLLI'
      Origin = 'MARCATURA_COLLI'
      Size = 2000
    end
    object xtOrdiniPERC_RIVALSA_INPS: TFloatField
      FieldName = 'PERC_RIVALSA_INPS'
      Origin = 'PERC_RIVALSA_INPS'
    end
    object xtOrdiniIMPORTO_RIVALSA_INPS: TFloatField
      FieldName = 'IMPORTO_RIVALSA_INPS'
      Origin = 'IMPORTO_RIVALSA_INPS'
    end
    object xtOrdiniIVA_RIVALSA_INPS: TFMTBCDField
      FieldName = 'IVA_RIVALSA_INPS'
      Origin = 'IVA_RIVALSA_INPS'
      Precision = 18
      Size = 2
    end
    object xtOrdiniTOTALI_FORZATI: TStringField
      FieldName = 'TOTALI_FORZATI'
      Origin = 'TOTALI_FORZATI'
      FixedChar = True
      Size = 1
    end
    object xtOrdiniFK_QUESTIONARIO: TIntegerField
      FieldName = 'FK_QUESTIONARIO'
      Origin = 'FK_QUESTIONARIO'
    end
    object xtOrdiniSALDO_SCADENZE_COMLETO: TStringField
      FieldName = 'SALDO_SCADENZE_COMLETO'
      Origin = 'SALDO_SCADENZE_COMLETO'
      FixedChar = True
      Size = 1
    end
    object xtOrdiniDATA_PROS_SCAD_PAGAMENTO: TSQLTimeStampField
      FieldName = 'DATA_PROS_SCAD_PAGAMENTO'
      Origin = 'DATA_PROS_SCAD_PAGAMENTO'
    end
    object xtOrdiniNOTE: TStringField
      FieldName = 'NOTE'
      Origin = 'NOTE'
      Size = 2000
    end
    object xtOrdiniFLG_FORCE_DO_NOT_UPD_SCAD: TStringField
      FieldName = 'FLG_FORCE_DO_NOT_UPD_SCAD'
      Origin = 'FLG_FORCE_DO_NOT_UPD_SCAD'
      FixedChar = True
      Size = 1
    end
    object xtOrdiniCOD_FISCALE: TStringField
      FieldName = 'COD_FISCALE'
      Origin = 'COD_FISCALE'
    end
    object xtOrdiniNUMERO_CIVICO: TStringField
      FieldName = 'NUMERO_CIVICO'
      Origin = 'NUMERO_CIVICO'
      Size = 10
    end
    object xtOrdiniFK_SEDE: TIntegerField
      FieldName = 'FK_SEDE'
      Origin = 'FK_SEDE'
    end
    object xtOrdiniDB_SYNC_ID: TLargeintField
      FieldName = 'DB_SYNC_ID'
      Origin = 'DB_SYNC_ID'
    end
    object xtOrdiniUID: TStringField
      FieldName = 'UID'
      Origin = 'UID'
      Size = 40
    end
    object xtOrdiniFK_STATO: TIntegerField
      FieldName = 'FK_STATO'
      Origin = 'FK_STATO'
    end
    object xtOrdiniFK_XML_FE: TIntegerField
      FieldName = 'FK_XML_FE'
      Origin = 'FK_XML_FE'
    end
    object xtOrdiniFK_STATO_FE: TIntegerField
      FieldName = 'FK_STATO_FE'
      Origin = 'FK_STATO_FE'
    end
    object xtOrdiniFK_DIVISA: TIntegerField
      FieldName = 'FK_DIVISA'
      Origin = 'FK_DIVISA'
    end
    object xtOrdiniCODICE_DESTINATARIO_FE: TStringField
      FieldName = 'CODICE_DESTINATARIO_FE'
      Origin = 'CODICE_DESTINATARIO_FE'
      Size = 50
    end
    object xtOrdiniPEC: TStringField
      FieldName = 'PEC'
      Origin = 'PEC'
      Size = 200
    end
    object xtOrdiniCAUSALE: TStringField
      FieldName = 'CAUSALE'
      Origin = 'CAUSALE'
      Size = 4000
    end
    object xtOrdiniSDI_FILENAME: TStringField
      FieldName = 'SDI_FILENAME'
      Origin = 'SDI_FILENAME'
      Size = 200
    end
    object xtOrdiniFK_ALLEGATO_SDI: TIntegerField
      FieldName = 'FK_ALLEGATO_SDI'
      Origin = 'FK_ALLEGATO_SDI'
    end
    object xtOrdiniARROTONDAMENTO: TFloatField
      FieldName = 'ARROTONDAMENTO'
      Origin = 'ARROTONDAMENTO'
    end
    object xtOrdiniFK_TIPO_RITENUTA: TIntegerField
      FieldName = 'FK_TIPO_RITENUTA'
      Origin = 'FK_TIPO_RITENUTA'
    end
    object xtOrdiniPERC_RITENUTA_ACCONTO_SU: TFloatField
      FieldName = 'PERC_RITENUTA_ACCONTO_SU'
      Origin = 'PERC_RITENUTA_ACCONTO_SU'
    end
    object xtOrdiniFK_CAUSALE_RITENUTA: TIntegerField
      FieldName = 'FK_CAUSALE_RITENUTA'
      Origin = 'FK_CAUSALE_RITENUTA'
    end
    object xtOrdiniFORMATO_TRASMISSIONE: TStringField
      FieldName = 'FORMATO_TRASMISSIONE'
      Origin = 'FORMATO_TRASMISSIONE'
      Size = 5
    end
    object xtOrdiniPROGRESSIVO_INVIO_FE: TLargeintField
      FieldName = 'PROGRESSIVO_INVIO_FE'
      Origin = 'PROGRESSIVO_INVIO_FE'
    end
    object xtOrdiniNR_DOC_FE: TStringField
      FieldName = 'NR_DOC_FE'
      Origin = 'NR_DOC_FE'
    end
    object xtOrdiniPRIVATO: TStringField
      FieldName = 'PRIVATO'
      Origin = 'PRIVATO'
      FixedChar = True
      Size = 1
    end
    object xtOrdiniNETTO_A_PAGARE: TFloatField
      FieldName = 'NETTO_A_PAGARE'
      Origin = 'NETTO_A_PAGARE'
    end
    object xtOrdiniDESC_CONDIZIONI_ECONOMICHE: TStringField
      FieldName = 'DESC_CONDIZIONI_ECONOMICHE'
      Origin = 'DESC_CONDIZIONI_ECONOMICHE'
      Size = 4000
    end
    object xtOrdiniDATA_ULTIMA_MODIFICA: TSQLTimeStampField
      FieldName = 'DATA_ULTIMA_MODIFICA'
      Origin = 'DATA_ULTIMA_MODIFICA'
    end
    object xtOrdiniPAYPAL_ORDER: TStringField
      FieldName = 'PAYPAL_ORDER'
      Origin = 'PAYPAL_ORDER'
      Size = 50
    end
    object xtOrdiniRESTO_EURO: TFloatField
      FieldName = 'RESTO_EURO'
      Origin = 'RESTO_EURO'
    end
    object xtOrdiniCODICE_CASSA: TIntegerField
      FieldName = 'CODICE_CASSA'
      Origin = 'CODICE_CASSA'
    end
    object xtOrdiniIDENTITA: TIntegerField
      FieldName = 'IDENTITA'
      Origin = 'IDENTITA'
    end
    object xtOrdiniFK_USER_CREATOR: TLargeintField
      FieldName = 'FK_USER_CREATOR'
      Origin = 'FK_USER_CREATOR'
    end
    object xtOrdiniCODICE_LOTTERIA: TStringField
      FieldName = 'CODICE_LOTTERIA'
      Origin = 'CODICE_LOTTERIA'
    end
    object xtOrdiniTRACKING_LINK: TStringField
      FieldName = 'TRACKING_LINK'
      Origin = 'TRACKING_LINK'
      Size = 1000
    end
    object xtOrdiniCODICE_COUPON: TStringField
      FieldName = 'CODICE_COUPON'
      Origin = 'CODICE_COUPON'
      Size = 10
    end
    object xtOrdiniDESC_STATO_DOC: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'DESC_STATO_DOC'
      Origin = 'DESCRIZIONE'
      ProviderFlags = []
      ReadOnly = True
      Size = 50
    end
    object xtOrdiniCLASS_STATO_DOC: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'CLASS_STATO_DOC'
      Origin = 'CLASS_STATO_DOC'
      ProviderFlags = []
      ReadOnly = True
      FixedChar = True
      Size = 7
    end
  end
  object dsOrdini: TDataSource
    DataSet = xtOrdini
    Left = 115
    Top = 546
  end
  object xtDriveCommands: TxtDriveCommands
    active = False
    xtConnection = dmXtumble.XtConnection
    Left = 211
    Top = 546
  end
  object OPD: TOpenPictureDialog
    Left = 483
    Top = 328
  end
end
