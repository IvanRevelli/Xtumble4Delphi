object frmMailingList: TfrmMailingList
  Left = 0
  Top = 0
  Caption = 'Mailing List'
  ClientHeight = 708
  ClientWidth = 997
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Splitter1: TSplitter
    Left = 229
    Top = 47
    Width = 4
    Height = 603
    ExplicitLeft = 392
    ExplicitTop = 31
    ExplicitHeight = 395
  end
  object Panel1: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 991
    Height = 41
    Align = alTop
    Caption = 'Mailing List'
    Color = 10354492
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
    Top = 653
    Width = 991
    Height = 52
    Align = alBottom
    TabOrder = 1
  end
  object Panel3: TPanel
    AlignWithMargins = True
    Left = 243
    Top = 57
    Width = 744
    Height = 583
    Margins.Left = 10
    Margins.Top = 10
    Margins.Right = 10
    Margins.Bottom = 10
    Align = alClient
    TabOrder = 2
    object pnlCurrentMailingList: TPanel
      AlignWithMargins = True
      Left = 11
      Top = 11
      Width = 722
      Height = 41
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 10
      Align = alTop
      Caption = 'Current Mailing List'
      Font.Charset = DEFAULT_CHARSET
      Font.Color = 16727100
      Font.Height = -19
      Font.Name = 'Lucida Fax'
      Font.Style = []
      ParentFont = False
      TabOrder = 0
    end
    object PageControl1: TPageControl
      Left = 1
      Top = 62
      Width = 742
      Height = 520
      ActivePage = tsMailingContacts
      Align = alClient
      TabOrder = 1
      object tsMailingContacts: TTabSheet
        Caption = 'Contacts on Mailing'
        object dbgMailingContacts: TDBGrid
          AlignWithMargins = True
          Left = 10
          Top = 74
          Width = 714
          Height = 408
          Margins.Left = 10
          Margins.Top = 10
          Margins.Right = 10
          Margins.Bottom = 10
          Align = alClient
          DataSource = dsMailingContacts
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Tahoma'
          TitleFont.Style = []
        end
        object ToolBar1: TToolBar
          AlignWithMargins = True
          Left = 10
          Top = 0
          Width = 714
          Height = 64
          Margins.Left = 10
          Margins.Top = 0
          Margins.Right = 10
          Margins.Bottom = 0
          ButtonHeight = 52
          ButtonWidth = 45
          Caption = 'ToolBar1'
          Images = dmXtumble.VirtualImageList1
          ShowCaptions = True
          TabOrder = 1
          object ToolButton5: TToolButton
            Left = 0
            Top = 0
            Caption = 'Refresh'
            ImageIndex = 21
            ImageName = 'Refresh_40px'
          end
        end
      end
      object tsAvailableContacts: TTabSheet
        Caption = 'Avilable Contacts List'
        ImageIndex = 1
        OnShow = tsAvailableContactsShow
        object dbgContacts: TDBGrid
          AlignWithMargins = True
          Left = 10
          Top = 74
          Width = 714
          Height = 408
          Margins.Left = 10
          Margins.Top = 10
          Margins.Right = 10
          Margins.Bottom = 10
          Align = alClient
          DataSource = dsContacts
          Options = [dgEditing, dgTitles, dgIndicator, dgColumnResize, dgColLines, dgTabs, dgAlwaysShowSelection, dgConfirmDelete, dgCancelOnExit, dgMultiSelect, dgTitleClick, dgTitleHotTrack]
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Tahoma'
          TitleFont.Style = []
        end
        object ToolBar2: TToolBar
          AlignWithMargins = True
          Left = 10
          Top = 0
          Width = 714
          Height = 64
          Margins.Left = 10
          Margins.Top = 0
          Margins.Right = 10
          Margins.Bottom = 0
          ButtonHeight = 52
          ButtonWidth = 60
          Caption = 'ToolBar1'
          Images = dmXtumble.VirtualImageList1
          ShowCaptions = True
          TabOrder = 1
          object ToolButton7: TToolButton
            Left = 0
            Top = 0
            Width = 24
            Caption = 'ToolButton7'
            ImageIndex = 19
            ImageName = 'Play_40px'
            Style = tbsSeparator
          end
          object tsAddToList: TToolButton
            Left = 24
            Top = 0
            Caption = 'Add To List'
            ImageIndex = 20
            ImageName = 'Save_50px'
          end
          object tlAddToCampain: TToolButton
            Left = 84
            Top = 0
            Width = 30
            Caption = 'Add Selected to Campain'
            ImageIndex = 20
            ImageName = 'Save_50px'
            Style = tbsSeparator
          end
          object tsRefresh: TToolButton
            Left = 114
            Top = 0
            Caption = 'Refresh'
            ImageIndex = 21
            ImageName = 'Refresh_40px'
            OnClick = tsRefreshClick
          end
        end
      end
    end
  end
  object pnlLeftMenu: TPanel
    Left = 0
    Top = 47
    Width = 229
    Height = 603
    Align = alLeft
    TabOrder = 3
    object lvMailingList: TListView
      AlignWithMargins = True
      Left = 11
      Top = 1
      Width = 207
      Height = 591
      Margins.Left = 10
      Margins.Top = 0
      Margins.Right = 10
      Margins.Bottom = 10
      Align = alClient
      Columns = <
        item
          AutoSize = True
          Caption = 'Mailing list '
        end
        item
          AutoSize = True
          Caption = 'Creation Date'
        end>
      FlatScrollBars = True
      IconOptions.AutoArrange = True
      LargeImages = dmXtumble.VirtualImageList1
      ReadOnly = True
      RowSelect = True
      PopupMenu = popMailing
      ShowWorkAreas = True
      SortType = stText
      TabOrder = 0
      ViewStyle = vsReport
      OnClick = lvMailingListClick
      ExplicitTop = 65
      ExplicitHeight = 527
    end
  end
  object xtSendMail1: TxtSendMail
    active = False
    xtConnection = dmXtumble.XtConnection
    Left = 360
    Top = 16
  end
  object xtDsMailing: TxtDatasetEntity
    xtConnection = dmXtumble.XtConnection
    xtEntityName = 'crm_mailing_list'
    xtRefreshAfterPost = False
    xtApplyUpdateAfterPost = True
    xtApplyUpdateAfterDelete = True
    xtLiveRecordInsert = True
    xtParams.Strings = (
      'fkparentfolder=-1000')
    xtMaxRecords = 10
    AfterOpen = xtDsMailingAfterOpen
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
    Top = 432
    object xtDsMailingPK_ID: TLargeintField
      FieldName = 'PK_ID'
      Origin = 'PK_ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object xtDsMailingDESCRIZIONE: TStringField
      FieldName = 'DESCRIZIONE'
      Origin = 'DESCRIZIONE'
      Size = 2000
    end
    object xtDsMailingATTIVA: TStringField
      FieldName = 'ATTIVA'
      Origin = 'ATTIVA'
      Required = True
      FixedChar = True
      Size = 1
    end
    object xtDsMailingDATA_CREAZIONE: TSQLTimeStampField
      FieldName = 'DATA_CREAZIONE'
      Origin = 'DATA_CREAZIONE'
    end
    object xtDsMailingDATA_ULTIMA_COMUNICAZIONE: TSQLTimeStampField
      FieldName = 'DATA_ULTIMA_COMUNICAZIONE'
      Origin = 'DATA_ULTIMA_COMUNICAZIONE'
    end
    object xtDsMailingEX_KEY: TStringField
      FieldName = 'EX_KEY'
      Origin = 'EX_KEY'
      Size = 30
    end
  end
  object xtDSContacts: TxtDatasetEntity
    xtConnection = dmXtumble.XtConnection
    xtEntityName = 'crm_contacts'
    xtRefreshAfterPost = False
    xtApplyUpdateAfterPost = True
    xtApplyUpdateAfterDelete = True
    xtLiveRecordInsert = True
    xtMaxRecords = 1000
    FieldDefs = <>
    CachedUpdates = True
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvEDelete, uvEInsert, uvEUpdate, uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    StoreDefs = True
    Left = 184
    Top = 432
    object xtDSContactsPK_ID: TLargeintField
      FieldName = 'PK_ID'
      Origin = 'PK_ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object xtDSContactsMAIL: TStringField
      DisplayWidth = 30
      FieldName = 'MAIL'
      Origin = 'MAIL'
      Size = 200
    end
    object xtDSContactsNAME: TStringField
      DisplayWidth = 30
      FieldName = 'NAME'
      Origin = 'NAME'
      Size = 100
    end
    object xtDSContactsCOMPANY_NAME: TStringField
      DisplayWidth = 30
      FieldName = 'COMPANY_NAME'
      Origin = 'COMPANY_NAME'
      Size = 100
    end
    object xtDSContactsADDRESS: TStringField
      DisplayWidth = 30
      FieldName = 'ADDRESS'
      Origin = 'ADDRESS'
      Size = 100
    end
    object xtDSContactsEXTERNAL_KEY: TStringField
      FieldName = 'EXTERNAL_KEY'
      Origin = 'EXTERNAL_KEY'
      Size = 30
    end
    object xtDSContactsOFFICE_PHONE: TStringField
      FieldName = 'OFFICE_PHONE'
      Origin = 'OFFICE_PHONE'
      Size = 30
    end
    object xtDSContactsMOBILE_PHONE: TStringField
      FieldName = 'MOBILE_PHONE'
      Origin = 'MOBILE_PHONE'
      Size = 30
    end
    object xtDSContactsCITY: TStringField
      DisplayWidth = 30
      FieldName = 'CITY'
      Origin = 'CITY'
      Size = 50
    end
    object xtDSContactsPOSTAL_CODE: TStringField
      FieldName = 'POSTAL_CODE'
      Origin = 'POSTAL_CODE'
      Size = 10
    end
    object xtDSContactsROLE: TStringField
      FieldName = 'ROLE'
      Origin = '"ROLE"'
      Size = 30
    end
    object xtDSContactsFK_GROUP: TLargeintField
      FieldName = 'FK_GROUP'
      Origin = 'FK_GROUP'
    end
    object xtDSContactsFK_STATUS: TLargeintField
      FieldName = 'FK_STATUS'
      Origin = 'FK_STATUS'
    end
    object xtDSContactsUNSUBSCRIBED: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'UNSUBSCRIBED'
      Origin = 'UNSUBSCRIBED'
      ProviderFlags = []
      ReadOnly = True
      FixedChar = True
      Size = 1
    end
    object xtDSContactsATTIVO: TStringField
      FieldName = 'ATTIVO'
      Origin = 'ATTIVO'
      FixedChar = True
      Size = 1
    end
    object xtDSContactsFK_IDCONTATTO: TLargeintField
      FieldName = 'FK_IDCONTATTO'
      Origin = 'FK_IDCONTATTO'
      Visible = False
    end
  end
  object popMailing: TPopupMenu
    Left = 184
    Top = 232
    object Addfolder1: TMenuItem
      Caption = 'Create new Campaign'
    end
    object Deletefolder1: TMenuItem
      Caption = 'Delete campaign'
    end
    object N1: TMenuItem
      Caption = '-'
    end
    object Refresh1: TMenuItem
      Caption = 'Refresh'
    end
  end
  object xtDriveCommands: TxtDriveCommands
    active = False
    xtConnection = dmXtumble.XtConnection
    Left = 400
    Top = 432
  end
  object dsContacts: TDataSource
    DataSet = xtDSContacts
    Left = 296
    Top = 432
  end
  object xtDsMailingContacts: TxtDatasetEntity
    xtConnection = dmXtumble.XtConnection
    xtEntityName = 'crm_contacts'
    xtRefreshAfterPost = False
    xtApplyUpdateAfterPost = True
    xtApplyUpdateAfterDelete = True
    xtLiveRecordInsert = True
    xtMaxRecords = 1000
    FieldDefs = <>
    CachedUpdates = True
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvEDelete, uvEInsert, uvEUpdate, uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    StoreDefs = True
    Left = 184
    Top = 368
    object xtDsMailingContactsPK_ID: TLargeintField
      FieldName = 'PK_ID'
      Origin = 'PK_ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object xtDsMailingContactsMAIL: TStringField
      FieldName = 'MAIL'
      Origin = 'MAIL'
      Size = 200
    end
    object xtDsMailingContactsATTIVO: TStringField
      FieldName = 'ATTIVO'
      Origin = 'ATTIVO'
      FixedChar = True
      Size = 1
    end
    object xtDsMailingContactsFK_IDCONTATTO: TLargeintField
      FieldName = 'FK_IDCONTATTO'
      Origin = 'FK_IDCONTATTO'
    end
    object xtDsMailingContactsEXTERNAL_KEY: TStringField
      FieldName = 'EXTERNAL_KEY'
      Origin = 'EXTERNAL_KEY'
      Size = 30
    end
    object xtDsMailingContactsNAME: TStringField
      FieldName = 'NAME'
      Origin = 'NAME'
      Size = 100
    end
    object xtDsMailingContactsADDRESS: TStringField
      FieldName = 'ADDRESS'
      Origin = 'ADDRESS'
      Size = 100
    end
    object xtDsMailingContactsOFFICE_PHONE: TStringField
      FieldName = 'OFFICE_PHONE'
      Origin = 'OFFICE_PHONE'
      Size = 30
    end
    object xtDsMailingContactsMOBILE_PHONE: TStringField
      FieldName = 'MOBILE_PHONE'
      Origin = 'MOBILE_PHONE'
      Size = 30
    end
    object xtDsMailingContactsCITY: TStringField
      FieldName = 'CITY'
      Origin = 'CITY'
      Size = 50
    end
    object xtDsMailingContactsPOSTAL_CODE: TStringField
      FieldName = 'POSTAL_CODE'
      Origin = 'POSTAL_CODE'
      Size = 10
    end
    object xtDsMailingContactsROLE: TStringField
      FieldName = 'ROLE'
      Origin = '"ROLE"'
      Size = 30
    end
    object xtDsMailingContactsCOMPANY_NAME: TStringField
      FieldName = 'COMPANY_NAME'
      Origin = 'COMPANY_NAME'
      Size = 100
    end
    object xtDsMailingContactsFK_GROUP: TLargeintField
      FieldName = 'FK_GROUP'
      Origin = 'FK_GROUP'
    end
    object xtDsMailingContactsFK_STATUS: TLargeintField
      FieldName = 'FK_STATUS'
      Origin = 'FK_STATUS'
    end
    object xtDsMailingContactsUNSUBSCRIBED: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'UNSUBSCRIBED'
      Origin = 'UNSUBSCRIBED'
      ProviderFlags = []
      ReadOnly = True
      FixedChar = True
      Size = 1
    end
  end
  object dsMailingContacts: TDataSource
    DataSet = xtDsMailingContacts
    Left = 296
    Top = 368
  end
  object popContacts: TPopupMenu
    Left = 712
    Top = 304
  end
  object popBody: TPopupMenu
    Left = 528
    Top = 296
    object LoadFromFile1: TMenuItem
      Caption = 'Load From File'
    end
    object SaveToFile1: TMenuItem
      Caption = 'Save To File'
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object LoadfromURL1: TMenuItem
      Caption = 'Load from URL'
      Enabled = False
    end
  end
  object popAttachments: TPopupMenu
    Left = 832
    Top = 320
    object Insertinmessagebody1: TMenuItem
      Caption = 'Insert in message body'
    end
    object MenuItem1: TMenuItem
      Caption = '-'
    end
    object Addfromyourcomputer1: TMenuItem
      Caption = 'Add from your computer'
    end
    object Addfromgallery1: TMenuItem
      Caption = 'Add from gallery'
    end
    object MenuItem2: TMenuItem
      Caption = '-'
    end
    object Removeselected1: TMenuItem
      Caption = 'Remove selected'
    end
    object RemoveAll1: TMenuItem
      Caption = 'Remove All'
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object Refresh2: TMenuItem
      Caption = 'Refresh'
    end
  end
  object popCampContacts: TPopupMenu
    Left = 712
    Top = 400
  end
  object popReports: TPopupMenu
    Left = 624
    Top = 384
  end
end
