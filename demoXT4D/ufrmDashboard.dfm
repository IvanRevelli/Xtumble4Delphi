object frmDashboard: TfrmDashboard
  Left = 0
  Top = 0
  Caption = 'Dashboard'
  ClientHeight = 656
  ClientWidth = 842
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
  object pnlHader: TPanel
    AlignWithMargins = True
    Left = 10
    Top = 57
    Width = 822
    Height = 216
    Margins.Left = 10
    Margins.Top = 10
    Margins.Right = 10
    Margins.Bottom = 10
    Align = alTop
    TabOrder = 0
    ExplicitWidth = 820
    object Panel1: TPanel
      AlignWithMargins = True
      Left = 11
      Top = 11
      Width = 185
      Height = 194
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 10
      Align = alLeft
      TabOrder = 0
      object Image1: TImage
        AlignWithMargins = True
        Left = 11
        Top = 11
        Width = 163
        Height = 155
        Margins.Left = 10
        Margins.Top = 10
        Margins.Right = 10
        Margins.Bottom = 10
        Align = alTop
        Center = True
        Proportional = True
        Stretch = True
        ExplicitLeft = 40
        ExplicitTop = 40
        ExplicitWidth = 105
        ExplicitHeight = 105
      end
      object btnChangeLogo: TButton
        AlignWithMargins = True
        Left = 11
        Top = 158
        Width = 163
        Height = 25
        Margins.Left = 10
        Margins.Top = 10
        Margins.Right = 10
        Margins.Bottom = 10
        Align = alBottom
        Caption = 'Change Logo'
        TabOrder = 0
        OnClick = btnChangeLogoClick
      end
    end
    object pnlCompanyData: TPanel
      AlignWithMargins = True
      Left = 216
      Top = 11
      Width = 595
      Height = 194
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 10
      Align = alClient
      TabOrder = 1
      ExplicitWidth = 593
      object Label1: TLabel
        Left = 16
        Top = 24
        Width = 95
        Height = 13
        Caption = 'RAGIONE_SOCIALE'
        FocusControl = DBEdit1
      end
      object Label2: TLabel
        Left = 16
        Top = 72
        Width = 53
        Height = 13
        Caption = 'INDIRIZZO'
        FocusControl = DBEdit2
      end
      object Label3: TLabel
        Left = 298
        Top = 24
        Width = 29
        Height = 13
        Caption = 'P_IVA'
        FocusControl = DBEdit3
      end
      object Label4: TLabel
        Left = 298
        Top = 72
        Width = 49
        Height = 13
        Caption = 'LOCALITA'
        FocusControl = DBEdit4
      end
      object DBEdit1: TDBEdit
        Left = 16
        Top = 40
        Width = 250
        Height = 21
        DataField = 'RAGIONE_SOCIALE'
        DataSource = dsMyCompany
        TabOrder = 0
      end
      object DBEdit2: TDBEdit
        Left = 16
        Top = 91
        Width = 250
        Height = 21
        DataField = 'INDIRIZZO'
        DataSource = dsMyCompany
        TabOrder = 1
      end
      object DBEdit3: TDBEdit
        Left = 298
        Top = 40
        Width = 264
        Height = 21
        DataField = 'P_IVA'
        DataSource = dsMyCompany
        TabOrder = 2
      end
      object DBEdit4: TDBEdit
        Left = 298
        Top = 91
        Width = 250
        Height = 21
        DataField = 'LOCALITA'
        DataSource = dsMyCompany
        TabOrder = 3
      end
    end
  end
  object Panel2: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 601
    Width = 836
    Height = 52
    Align = alBottom
    TabOrder = 1
    ExplicitTop = 536
    ExplicitWidth = 834
  end
  object Panel3: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 836
    Height = 41
    Align = alTop
    Caption = 'DASHBOARD'
    Color = 14286845
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Century'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    TabOrder = 2
    ExplicitWidth = 834
  end
  object pgDashBoardDetails: TPageControl
    AlignWithMargins = True
    Left = 10
    Top = 293
    Width = 822
    Height = 295
    Margins.Left = 10
    Margins.Top = 10
    Margins.Right = 10
    Margins.Bottom = 10
    ActivePage = tsWebResources
    Align = alClient
    TabOrder = 3
    ExplicitTop = 444
    ExplicitHeight = 144
    object tsWebResources: TTabSheet
      Caption = 'Web Resources'
      ImageIndex = 1
      ExplicitHeight = 116
      object GroupBox1: TGroupBox
        AlignWithMargins = True
        Left = 10
        Top = 1
        Width = 794
        Height = 157
        Margins.Left = 10
        Margins.Top = 1
        Margins.Right = 10
        Margins.Bottom = 10
        Align = alTop
        Caption = 'Web Resources'
        TabOrder = 0
        ExplicitTop = -41
        object GroupBox2: TGroupBox
          AlignWithMargins = True
          Left = 12
          Top = 35
          Width = 350
          Height = 110
          Margins.Left = 10
          Margins.Top = 20
          Margins.Right = 10
          Margins.Bottom = 10
          Align = alLeft
          Caption = 'E-Commerce'
          TabOrder = 0
          object llStoreUrl: TLabel
            AlignWithMargins = True
            Left = 7
            Top = 80
            Width = 336
            Height = 23
            Cursor = crHandPoint
            Margins.Left = 5
            Margins.Top = 5
            Margins.Right = 5
            Margins.Bottom = 5
            Align = alBottom
            Alignment = taCenter
            AutoSize = False
            Caption = 'https://xtumble.store'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -19
            Font.Name = 'Tahoma'
            Font.Style = []
            Font.Quality = fqClearType
            ParentFont = False
            StyleElements = [seClient, seBorder]
            OnClick = llStoreUrlClick
            ExplicitLeft = 22
            ExplicitTop = 67
            ExplicitWidth = 177
          end
          object edWebAlias: TLabeledEdit
            Left = 22
            Top = 40
            Width = 192
            Height = 21
            EditLabel.Width = 95
            EditLabel.Height = 13
            EditLabel.Caption = 'Company Web Alias'
            ReadOnly = True
            TabOrder = 0
          end
          object btnChangeWebAlias: TButton
            Left = 219
            Top = 40
            Width = 75
            Height = 25
            Caption = 'Change'
            TabOrder = 1
            OnClick = btnChangeWebAliasClick
          end
        end
        object GroupBox3: TGroupBox
          AlignWithMargins = True
          Left = 382
          Top = 35
          Width = 350
          Height = 110
          Margins.Left = 10
          Margins.Top = 20
          Margins.Right = 10
          Margins.Bottom = 10
          Align = alLeft
          Caption = 'Web Console ERP'
          TabOrder = 1
          object Label5: TLabel
            AlignWithMargins = True
            Left = 7
            Top = 80
            Width = 336
            Height = 23
            Cursor = crHandPoint
            Margins.Left = 5
            Margins.Top = 5
            Margins.Right = 5
            Margins.Bottom = 5
            Align = alBottom
            Alignment = taCenter
            AutoSize = False
            Caption = 'https://xtumble.com/dashboard.php'
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clBlue
            Font.Height = -19
            Font.Name = 'Tahoma'
            Font.Style = []
            Font.Quality = fqClearType
            ParentFont = False
            StyleElements = [seClient, seBorder]
            OnClick = llStoreUrlClick
            ExplicitLeft = 14
            ExplicitTop = 87
            ExplicitWidth = 171
          end
          object StaticText1: TStaticText
            AlignWithMargins = True
            Left = 12
            Top = 25
            Width = 326
            Height = 40
            Margins.Left = 10
            Margins.Top = 10
            Margins.Right = 10
            Margins.Bottom = 10
            Align = alClient
            Alignment = taCenter
            Caption = 'Gestisci il tuo ERP dal Web'
            TabOrder = 0
            ExplicitWidth = 130
            ExplicitHeight = 17
          end
        end
      end
    end
    object tsUsers: TTabSheet
      Caption = 'Users'
      ExplicitLeft = 0
      ExplicitHeight = 116
      object pgUsers: TPageControl
        AlignWithMargins = True
        Left = 10
        Top = 10
        Width = 794
        Height = 247
        Margins.Left = 10
        Margins.Top = 10
        Margins.Right = 10
        Margins.Bottom = 10
        ActivePage = tsProfile
        Align = alClient
        TabOrder = 0
        ExplicitLeft = 288
        ExplicitTop = 74
        ExplicitWidth = 289
        ExplicitHeight = 193
        object tsProfile: TTabSheet
          Caption = 'Your Profile'
          ExplicitWidth = 281
          ExplicitHeight = 165
          object StaticText3: TStaticText
            AlignWithMargins = True
            Left = 208
            Top = 83
            Width = 448
            Height = 68
            Margins.Left = 10
            Margins.Top = 10
            Margins.Right = 10
            Margins.Bottom = 10
            Align = alCustom
            Alignment = taCenter
            Caption = 'Work in progess....'
            Color = clSilver
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -53
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentColor = False
            ParentFont = False
            TabOrder = 0
            ExplicitLeft = 198
            ExplicitTop = 73
          end
        end
        object tsOtherUsers: TTabSheet
          Caption = 'Other Users'
          ImageIndex = 1
          ExplicitWidth = 281
          ExplicitHeight = 165
          object StaticText2: TStaticText
            AlignWithMargins = True
            Left = 190
            Top = 83
            Width = 448
            Height = 68
            Margins.Left = 10
            Margins.Top = 10
            Margins.Right = 10
            Margins.Bottom = 10
            Align = alCustom
            Alignment = taCenter
            Caption = 'Work in progess....'
            Color = clSilver
            Font.Charset = DEFAULT_CHARSET
            Font.Color = clWindowText
            Font.Height = -53
            Font.Name = 'Tahoma'
            Font.Style = []
            ParentColor = False
            ParentFont = False
            TabOrder = 0
            ExplicitLeft = 180
            ExplicitTop = 73
          end
        end
      end
    end
  end
  object dsMyCompany: TDataSource
    DataSet = xtMyCompany
    Left = 128
    Top = 539
  end
  object xtMyCompany: TxtDatasetEntity
    xtConnection = dmXtumble.XtConnection
    xtEntityName = 'mycompany'
    xtRefreshAfterPost = False
    xtApplyUpdateAfterPost = True
    xtApplyUpdateAfterDelete = True
    xtLiveRecordInsert = True
    xtMaxRecords = 10
    AfterScroll = xtMyCompanyAfterScroll
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
    Left = 48
    Top = 539
    object xtMyCompanyIDCONTATTO: TIntegerField
      FieldName = 'IDCONTATTO'
      Origin = 'IDCONTATTO'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object xtMyCompanyCODPV: TStringField
      FieldName = 'CODPV'
      Origin = 'CODPV'
      FixedChar = True
      Size = 5
    end
    object xtMyCompanyIDZONA: TIntegerField
      FieldName = 'IDZONA'
      Origin = 'IDZONA'
    end
    object xtMyCompanyIDPROVINCIA: TStringField
      FieldName = 'IDPROVINCIA'
      Origin = 'IDPROVINCIA'
      Size = 10
    end
    object xtMyCompanyIDREGIONE: TIntegerField
      FieldName = 'IDREGIONE'
      Origin = 'IDREGIONE'
    end
    object xtMyCompanyIDNAZIONE: TIntegerField
      FieldName = 'IDNAZIONE'
      Origin = 'IDNAZIONE'
    end
    object xtMyCompanyPRIVATO: TStringField
      FieldName = 'PRIVATO'
      Origin = 'PRIVATO'
      FixedChar = True
      Size = 1
    end
    object xtMyCompanyNOME: TStringField
      FieldName = 'NOME'
      Origin = 'NOME'
      Size = 200
    end
    object xtMyCompanyCOGNOME: TStringField
      FieldName = 'COGNOME'
      Origin = 'COGNOME'
      Size = 200
    end
    object xtMyCompanyINDIRIZZO: TStringField
      FieldName = 'INDIRIZZO'
      Origin = 'INDIRIZZO'
      Size = 200
    end
    object xtMyCompanyLOCALITA: TStringField
      FieldName = 'LOCALITA'
      Origin = 'LOCALITA'
      Size = 200
    end
    object xtMyCompanyCAP: TStringField
      FieldName = 'CAP'
      Origin = 'CAP'
      Size = 9
    end
    object xtMyCompanyRAGIONE_SOCIALE: TStringField
      FieldName = 'RAGIONE_SOCIALE'
      Origin = 'RAGIONE_SOCIALE'
      Size = 200
    end
    object xtMyCompanyTELEFONO_ABITAZIONE: TStringField
      FieldName = 'TELEFONO_ABITAZIONE'
      Origin = 'TELEFONO_ABITAZIONE'
      Size = 30
    end
    object xtMyCompanyTELEFONO_CELLULARE: TStringField
      FieldName = 'TELEFONO_CELLULARE'
      Origin = 'TELEFONO_CELLULARE'
      Size = 50
    end
    object xtMyCompanyTELEFONO_CELLULARE2: TStringField
      FieldName = 'TELEFONO_CELLULARE2'
      Origin = 'TELEFONO_CELLULARE2'
      Size = 30
    end
    object xtMyCompanyFAX_UFFICIO: TStringField
      FieldName = 'FAX_UFFICIO'
      Origin = 'FAX_UFFICIO'
      Size = 30
    end
    object xtMyCompanyTELEFONO_UFFICIO1: TStringField
      FieldName = 'TELEFONO_UFFICIO1'
      Origin = 'TELEFONO_UFFICIO1'
      Size = 30
    end
    object xtMyCompanyTELEFONO_UFFICIO2: TStringField
      FieldName = 'TELEFONO_UFFICIO2'
      Origin = 'TELEFONO_UFFICIO2'
      Size = 30
    end
    object xtMyCompanyPOSTA_ELETTRONICA: TStringField
      FieldName = 'POSTA_ELETTRONICA'
      Origin = 'POSTA_ELETTRONICA'
      Size = 200
    end
    object xtMyCompanySITO_INTERNET_AZIENDA: TStringField
      FieldName = 'SITO_INTERNET_AZIENDA'
      Origin = 'SITO_INTERNET_AZIENDA'
      Size = 30
    end
    object xtMyCompanyDATA_REGISTRAZIONE: TSQLTimeStampField
      FieldName = 'DATA_REGISTRAZIONE'
      Origin = 'DATA_REGISTRAZIONE'
    end
    object xtMyCompanyCOD_FISCALE: TStringField
      FieldName = 'COD_FISCALE'
      Origin = 'COD_FISCALE'
      Size = 16
    end
    object xtMyCompanyP_IVA: TStringField
      FieldName = 'P_IVA'
      Origin = 'P_IVA'
    end
    object xtMyCompanyCCIAA: TStringField
      FieldName = 'CCIAA'
      Origin = 'CCIAA'
      Size = 10
    end
    object xtMyCompanyISCRIZIONE_TRIBUNALE: TStringField
      FieldName = 'ISCRIZIONE_TRIBUNALE'
      Origin = 'ISCRIZIONE_TRIBUNALE'
      Size = 6
    end
    object xtMyCompanyDATA_ULTIMA_MODIFICA: TSQLTimeStampField
      FieldName = 'DATA_ULTIMA_MODIFICA'
      Origin = 'DATA_ULTIMA_MODIFICA'
    end
    object xtMyCompanyCAP_SOCIALE_EURO: TFloatField
      FieldName = 'CAP_SOCIALE_EURO'
      Origin = 'CAP_SOCIALE_EURO'
    end
    object xtMyCompanyESENTE_IVA: TStringField
      FieldName = 'ESENTE_IVA'
      Origin = 'ESENTE_IVA'
      FixedChar = True
      Size = 1
    end
    object xtMyCompanyDESCR_ESENZIONE_IVA: TStringField
      FieldName = 'DESCR_ESENZIONE_IVA'
      Origin = 'DESCR_ESENZIONE_IVA'
      Size = 100
    end
    object xtMyCompanyDATA_NASCITA: TSQLTimeStampField
      FieldName = 'DATA_NASCITA'
      Origin = 'DATA_NASCITA'
    end
    object xtMyCompanyCITTA: TStringField
      FieldName = 'CITTA'
      Origin = 'CITTA'
      Size = 200
    end
    object xtMyCompanyCODICEISO: TStringField
      FieldName = 'CODICEISO'
      Origin = 'CODICEISO'
      Size = 10
    end
    object xtMyCompanyIDLINGUA: TIntegerField
      FieldName = 'IDLINGUA'
      Origin = 'IDLINGUA'
    end
    object xtMyCompanyIDTIPO_PROFESSIONISTA: TIntegerField
      FieldName = 'IDTIPO_PROFESSIONISTA'
      Origin = 'IDTIPO_PROFESSIONISTA'
    end
    object xtMyCompanyMAIL: TStringField
      FieldName = 'MAIL'
      Origin = 'MAIL'
      Size = 200
    end
    object xtMyCompanyNATO_A: TStringField
      FieldName = 'NATO_A'
      Origin = 'NATO_A'
      Size = 50
    end
    object xtMyCompanyNUMERO_CIVICO: TStringField
      FieldName = 'NUMERO_CIVICO'
      Origin = 'NUMERO_CIVICO'
      Size = 10
    end
    object xtMyCompanySESSO: TStringField
      FieldName = 'SESSO'
      Origin = 'SESSO'
      FixedChar = True
      Size = 1
    end
    object xtMyCompanySKYPE: TStringField
      FieldName = 'SKYPE'
      Origin = 'SKYPE'
      Size = 50
    end
    object xtMyCompanyNOTE: TStringField
      FieldName = 'NOTE'
      Origin = 'NOTE'
      Size = 4000
    end
    object xtMyCompanyFK_ALLEGATO_FOTO_LOGO: TIntegerField
      FieldName = 'FK_ALLEGATO_FOTO_LOGO'
      Origin = 'FK_ALLEGATO_FOTO_LOGO'
    end
    object xtMyCompanyDUNS_NUMBER: TStringField
      FieldName = 'DUNS_NUMBER'
      Origin = 'DUNS_NUMBER'
    end
    object xtMyCompanyPEC: TStringField
      FieldName = 'PEC'
      Origin = 'PEC'
      Size = 200
    end
    object xtMyCompanyCODICE_DESTINATARIO_FE: TStringField
      FieldName = 'CODICE_DESTINATARIO_FE'
      Origin = 'CODICE_DESTINATARIO_FE'
      Size = 50
    end
    object xtMyCompanyNR_REA: TStringField
      FieldName = 'NR_REA'
      Origin = 'NR_REA'
    end
    object xtMyCompanyCOD_SOCIO_UNICO: TStringField
      FieldName = 'COD_SOCIO_UNICO'
      Origin = 'COD_SOCIO_UNICO'
      Size = 10
    end
    object xtMyCompanyCOD_STATO_LIQUIDAZIONE: TStringField
      FieldName = 'COD_STATO_LIQUIDAZIONE'
      Origin = 'COD_STATO_LIQUIDAZIONE'
      Size = 10
    end
    object xtMyCompanyFACEBOOK: TStringField
      FieldName = 'FACEBOOK'
      Origin = 'FACEBOOK'
      Size = 200
    end
    object xtMyCompanyLINKEDIN: TStringField
      FieldName = 'LINKEDIN'
      Origin = 'LINKEDIN'
      Size = 50
    end
    object xtMyCompanyYOUTUBE: TStringField
      FieldName = 'YOUTUBE'
      Origin = 'YOUTUBE'
      Size = 200
    end
    object xtMyCompanyTWITTER: TStringField
      FieldName = 'TWITTER'
      Origin = 'TWITTER'
      Size = 200
    end
    object xtMyCompanyINSTAGRAM: TStringField
      FieldName = 'INSTAGRAM'
      Origin = 'INSTAGRAM'
      Size = 200
    end
    object xtMyCompanyPINTEREST: TStringField
      FieldName = 'PINTEREST'
      Origin = 'PINTEREST'
      Size = 200
    end
  end
  object xtDriveCommands1: TxtDriveCommands
    active = False
    xtConnection = dmXtumble.XtConnection
    Left = 224
    Top = 539
  end
  object FileOpenDialog1: TFileOpenDialog
    FavoriteLinks = <>
    FileTypes = <>
    Options = []
    Left = 312
    Top = 544
  end
  object xtStore1: TxtStore
    active = False
    xtConnection = dmXtumble.XtConnection
    onWebAliasChange = xtStore1WebAliasChange
    Left = 432
    Top = 544
  end
end
