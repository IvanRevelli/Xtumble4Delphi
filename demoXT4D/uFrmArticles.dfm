object frmArticles: TfrmArticles
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'Articles'
  ClientHeight = 679
  ClientWidth = 997
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  WindowState = wsMaximized
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object Panel1: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 991
    Height = 41
    Align = alTop
    Caption = 'ARTICLES'
    Color = 14286845
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -19
    Font.Name = 'Century'
    Font.Style = [fsBold]
    ParentBackground = False
    ParentFont = False
    TabOrder = 0
  end
  object Panel2: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 624
    Width = 991
    Height = 52
    Align = alBottom
    TabOrder = 1
  end
  object PageControl1: TPageControl
    AlignWithMargins = True
    Left = 10
    Top = 163
    Width = 977
    Height = 448
    Margins.Left = 10
    Margins.Top = 10
    Margins.Right = 10
    Margins.Bottom = 10
    ActivePage = tsGrid
    Align = alClient
    TabOrder = 2
    object tsGrid: TTabSheet
      Caption = 'Grid'
      object Splitter1: TSplitter
        Left = 395
        Top = 25
        Width = 4
        Height = 395
        ExplicitLeft = 392
        ExplicitTop = 31
      end
      object gbArticleList: TGroupBox
        AlignWithMargins = True
        Left = 10
        Top = 35
        Width = 375
        Height = 375
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
          Width = 361
          Height = 338
          Margins.Left = 5
          Margins.Top = 10
          Margins.Right = 5
          Margins.Bottom = 10
          Align = alClient
          DataSource = dsArticles
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
        Left = 409
        Top = 35
        Width = 550
        Height = 375
        Margins.Left = 10
        Margins.Top = 10
        Margins.Right = 10
        Margins.Bottom = 10
        Align = alClient
        Caption = 'Detal'
        TabOrder = 1
        object Panel3: TPanel
          AlignWithMargins = True
          Left = 5
          Top = 18
          Width = 540
          Height = 352
          Align = alClient
          TabOrder = 0
          object Panel4: TPanel
            Left = 1
            Top = 1
            Width = 538
            Height = 200
            Margins.Left = 10
            Margins.Top = 10
            Margins.Right = 10
            Margins.Bottom = 10
            Align = alTop
            TabOrder = 0
            ExplicitLeft = -2
            ExplicitTop = 6
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
              DataSource = dsArticles
              TabOrder = 0
            end
            object DBEdit2: TDBEdit
              Left = 241
              Top = 91
              Width = 216
              Height = 21
              DataField = 'DESCRIPTION'
              DataSource = dsArticles
              TabOrder = 1
            end
            object ckEnabled: TDBCheckBox
              Left = 241
              Top = 128
              Width = 97
              Height = 17
              Caption = 'Enabled'
              DataField = 'ENABLED'
              DataSource = dsArticles
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
              DataSource = dsArticles
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
              OnClick = btnChangeImageClick
            end
          end
          object gbExtendeDscription: TGroupBox
            Left = 1
            Top = 201
            Width = 538
            Height = 120
            Align = alTop
            Caption = 'Extended description'
            TabOrder = 1
            object DBMemoExtendedDescription: TDBMemo
              AlignWithMargins = True
              Left = 12
              Top = 25
              Width = 514
              Height = 83
              Margins.Left = 10
              Margins.Top = 10
              Margins.Right = 10
              Margins.Bottom = 10
              Align = alClient
              DataField = 'EXTENDED_DESCRIPTION'
              DataSource = dsArticles
              TabOrder = 0
              ExplicitHeight = 48
            end
          end
        end
      end
      object DBNavigator1: TDBNavigator
        Left = 0
        Top = 0
        Width = 969
        Height = 25
        DataSource = dsArticles
        Align = alTop
        TabOrder = 2
      end
    end
  end
  object gbFilter: TGroupBox
    Left = 0
    Top = 47
    Width = 997
    Height = 106
    Align = alTop
    Caption = 'Funnel'
    TabOrder = 3
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
      OnKeyPress = edRecLimitKeyPress
    end
    object btnApplyFilter: TButton
      AlignWithMargins = True
      Left = 836
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
      OnClick = btnApplyFilterClick
    end
    object scDescription: TSearchBox
      Left = 314
      Top = 30
      Width = 235
      Height = 21
      TabOrder = 2
      OnKeyPress = scDescriptionKeyPress
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
  object xtArticles: TxtDatasetEntity
    xtConnection = dmXtumble.XtConnection
    xtEntityName = 'articles'
    xtRefreshAfterPost = False
    xtApplyUpdateAfterPost = True
    xtApplyUpdateAfterDelete = True
    xtLiveRecordInsert = True
    xtMaxRecords = 10
    BeforeOpen = xtArticlesBeforeOpen
    AfterClose = xtArticlesBeforeOpen
    AfterScroll = xtArticlesAfterScroll
    BeforeRefresh = xtArticlesBeforeRefresh
    FieldDefs = <
      item
        Name = 'CODE'
        Attributes = [faRequired]
        DataType = ftString
        Size = 40
      end
      item
        Name = 'DATA_AGG_DISPONIBILITA'
        DataType = ftTimeStamp
      end
      item
        Name = 'FK_CATEGORY'
        Attributes = [faRequired]
        DataType = ftLargeint
      end
      item
        Name = 'PROVIDER_CODE'
        DataType = ftString
        Size = 40
      end
      item
        Name = 'DESCRIPTION'
        DataType = ftString
        Size = 1000
      end
      item
        Name = 'INSERT_DATE'
        DataType = ftTimeStamp
      end
      item
        Name = 'MESURE_UNIT'
        DataType = ftString
        Size = 5
      end
      item
        Name = 'VAT'
        DataType = ftFMTBcd
        Precision = 18
        Size = 2
      end
      item
        Name = 'QUANTITY'
        DataType = ftInteger
      end
      item
        Name = 'MY_PRICE'
        DataType = ftFloat
        Precision = 16
      end
      item
        Name = 'END_USER_PRICE'
        DataType = ftFloat
        Precision = 16
      end
      item
        Name = 'IDARTICOLO'
        Attributes = [faRequired]
        DataType = ftLargeint
      end
      item
        Name = 'MODEL'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'VISIBLE_ON_STORE'
        DataType = ftInteger
      end
      item
        Name = 'EXTENDED_DESCRIPTION'
        DataType = ftString
        Size = 32000
      end
      item
        Name = 'FK_PICTURE_ATTACH'
        DataType = ftInteger
      end
      item
        Name = 'RECORD_REVISION'
        DataType = ftLargeint
      end
      item
        Name = 'UID'
        DataType = ftString
        Size = 40
      end
      item
        Name = 'VAT_CODE'
        DataType = ftInteger
      end
      item
        Name = 'FK_STATE'
        DataType = ftInteger
      end
      item
        Name = 'ENABLED'
        Attributes = [faFixed]
        DataType = ftFixedChar
        Size = 1
      end
      item
        Name = 'EAN_CODE'
        DataType = ftString
        Size = 13
      end
      item
        Name = 'BRAND_NAME'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'EXTERNAL_KEY'
        DataType = ftString
        Size = 100
      end
      item
        Name = 'LAST_MODIFICATION_DATE'
        DataType = ftTimeStamp
      end>
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
    Top = 624
    object xtArticlesCODE: TStringField
      DisplayLabel = 'Article code'
      FieldName = 'CODE'
      Origin = 'CODICE_ARTICOLO'
      Required = True
      Size = 40
    end
    object xtArticlesDESCRIPTION: TStringField
      FieldName = 'DESCRIPTION'
      Origin = 'DESCRIZIONE'
      Size = 1000
    end
    object xtArticlesDATA_AGG_DISPONIBILITA: TSQLTimeStampField
      FieldName = 'DATA_AGG_DISPONIBILITA'
      Origin = 'DATA_AGG_DISPONIBILITA'
    end
    object xtArticlesFK_CATEGORY: TLargeintField
      FieldName = 'FK_CATEGORY'
      Origin = 'IDTIPOLOGIA'
      Required = True
    end
    object xtArticlesPROVIDER_CODE: TStringField
      FieldName = 'PROVIDER_CODE'
      Origin = 'CODICE_FORNITORE'
      Size = 40
    end
    object xtArticlesINSERT_DATE: TSQLTimeStampField
      FieldName = 'INSERT_DATE'
      Origin = 'DATA_INSERIMENTO'
    end
    object xtArticlesMESURE_UNIT: TStringField
      FieldName = 'MESURE_UNIT'
      Origin = 'UM'
      Size = 5
    end
    object xtArticlesVAT: TFMTBCDField
      FieldName = 'VAT'
      Origin = 'IVA'
      Precision = 18
      Size = 2
    end
    object xtArticlesQUANTITY: TIntegerField
      FieldName = 'QUANTITY'
      Origin = 'QUANTITA'
    end
    object xtArticlesMY_PRICE: TFloatField
      FieldName = 'MY_PRICE'
      Origin = 'COSTO_PRODUZIONE_EURO'
    end
    object xtArticlesEND_USER_PRICE: TFloatField
      FieldName = 'END_USER_PRICE'
      Origin = 'COSTO_END_USER_EURO'
    end
    object xtArticlesIDARTICOLO: TLargeintField
      FieldName = 'IDARTICOLO'
      Origin = 'IDARTICOLO'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object xtArticlesMODEL: TStringField
      FieldName = 'MODEL'
      Origin = 'MODELLO'
      Size = 100
    end
    object xtArticlesVISIBLE_ON_STORE: TIntegerField
      FieldName = 'VISIBLE_ON_STORE'
      Origin = 'VETRINA'
    end
    object xtArticlesEXTENDED_DESCRIPTION: TStringField
      FieldName = 'EXTENDED_DESCRIPTION'
      Origin = 'DESCRIZIONE_ESTESA'
      ProviderFlags = [pfInUpdate]
      Size = 32000
    end
    object xtArticlesFK_PICTURE_ATTACH: TIntegerField
      FieldName = 'FK_PICTURE_ATTACH'
      Origin = 'FK_ALLEGATO_IMG_PREDEFINITA'
    end
    object xtArticlesRECORD_REVISION: TLargeintField
      FieldName = 'RECORD_REVISION'
      Origin = 'DB_SYNC_ID'
    end
    object xtArticlesUID: TStringField
      FieldName = 'UID'
      Origin = 'UID'
      Size = 40
    end
    object xtArticlesVAT_CODE: TIntegerField
      FieldName = 'VAT_CODE'
      Origin = 'FK_CODICE_IVA'
    end
    object xtArticlesFK_STATE: TIntegerField
      FieldName = 'FK_STATE'
      Origin = 'FK_STATO'
    end
    object xtArticlesENABLED: TStringField
      FieldName = 'ENABLED'
      Origin = 'ABILITATO'
      FixedChar = True
      Size = 1
    end
    object xtArticlesEAN_CODE: TStringField
      FieldName = 'EAN_CODE'
      Origin = 'COD_EAN'
      Size = 13
    end
    object xtArticlesBRAND_NAME: TStringField
      FieldName = 'BRAND_NAME'
      Origin = 'BRAND'
      Size = 100
    end
    object xtArticlesEXTERNAL_KEY: TStringField
      FieldName = 'EXTERNAL_KEY'
      Origin = 'EXTERNAL_KEY'
      Size = 100
    end
    object xtArticlesLAST_MODIFICATION_DATE: TSQLTimeStampField
      FieldName = 'LAST_MODIFICATION_DATE'
      Origin = 'DATA_ULTIMA_MODIFICA'
    end
  end
  object dsArticles: TDataSource
    DataSet = xtArticles
    Left = 120
    Top = 624
  end
  object xtDriveCommands: TxtDriveCommands
    active = False
    xtConnection = dmXtumble.XtConnection
    Left = 216
    Top = 624
  end
  object OPD: TOpenPictureDialog
    Left = 488
    Top = 328
  end
end
