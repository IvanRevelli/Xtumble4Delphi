object frmMails: TfrmMails
  Left = 0
  Top = 0
  Caption = 'Mails'
  ClientHeight = 761
  ClientWidth = 1264
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
    Height = 656
    ExplicitLeft = 392
    ExplicitTop = 31
    ExplicitHeight = 395
  end
  object Panel1: TPanel
    AlignWithMargins = True
    Left = 3
    Top = 3
    Width = 1258
    Height = 41
    Align = alTop
    Caption = 'Email Marketing Campaigns'
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
    Top = 706
    Width = 1258
    Height = 52
    Align = alBottom
    TabOrder = 1
  end
  object Panel3: TPanel
    AlignWithMargins = True
    Left = 243
    Top = 57
    Width = 1011
    Height = 636
    Margins.Left = 10
    Margins.Top = 10
    Margins.Right = 10
    Margins.Bottom = 10
    Align = alClient
    TabOrder = 2
    object pnlCurrentCampaign: TPanel
      AlignWithMargins = True
      Left = 11
      Top = 11
      Width = 989
      Height = 41
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 10
      Align = alTop
      Caption = 'Current Campaign'
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
      Width = 1009
      Height = 573
      ActivePage = tsCampaignMailTemplate
      Align = alClient
      TabOrder = 1
      object tsCampaignMailTemplate: TTabSheet
        Caption = 'Campaign Mail Template'
        ImageIndex = 2
        object Label4: TLabel
          Left = 488
          Top = 264
          Width = 31
          Height = 13
          Caption = 'Label4'
        end
        object gbMailDetails: TGroupBox
          AlignWithMargins = True
          Left = 10
          Top = 64
          Width = 981
          Height = 471
          Margins.Left = 10
          Margins.Top = 0
          Margins.Right = 10
          Margins.Bottom = 10
          Align = alClient
          Caption = 'Template Mail Details'
          TabOrder = 0
          object Panel4: TPanel
            AlignWithMargins = True
            Left = 12
            Top = 25
            Width = 237
            Height = 434
            Margins.Left = 10
            Margins.Top = 10
            Margins.Right = 10
            Margins.Bottom = 10
            Align = alLeft
            TabOrder = 0
            object Label1: TLabel
              Left = 8
              Top = 5
              Width = 45
              Height = 13
              Caption = 'Mail From'
            end
            object Label2: TLabel
              Left = 8
              Top = 53
              Width = 75
              Height = 13
              Caption = 'Mail From Name'
            end
            object Label3: TLabel
              Left = 9
              Top = 103
              Width = 36
              Height = 13
              Caption = 'Subject'
            end
            object edMailFrom: TEdit
              Left = 8
              Top = 24
              Width = 216
              Height = 21
              TabOrder = 0
            end
            object edMailFromName: TEdit
              Left = 8
              Top = 72
              Width = 216
              Height = 21
              TabOrder = 1
            end
            object edSubject: TEdit
              Left = 8
              Top = 122
              Width = 216
              Height = 21
              TabOrder = 2
            end
          end
          object PageControl2: TPageControl
            AlignWithMargins = True
            Left = 259
            Top = 25
            Width = 710
            Height = 434
            Margins.Left = 0
            Margins.Top = 10
            Margins.Right = 10
            Margins.Bottom = 10
            ActivePage = tsBody
            Align = alClient
            TabOrder = 1
            object tsBody: TTabSheet
              Caption = 'Body'
              object MemoBody: TMemo
                AlignWithMargins = True
                Left = 5
                Top = 5
                Width = 692
                Height = 396
                Margins.Left = 5
                Margins.Top = 5
                Margins.Right = 5
                Margins.Bottom = 5
                Align = alClient
                Lines.Strings = (
                  'MemoBody')
                PopupMenu = popBody
                ScrollBars = ssBoth
                TabOrder = 0
              end
            end
            object tsMailAttach: TTabSheet
              Caption = 'Mail Attachments'
              ImageIndex = 1
              object lvFiles: TListView
                AlignWithMargins = True
                Left = 10
                Top = 10
                Width = 682
                Height = 386
                Margins.Left = 10
                Margins.Top = 10
                Margins.Right = 10
                Margins.Bottom = 10
                Align = alClient
                Columns = <
                  item
                    Caption = 'File Name'
                    Width = 180
                  end
                  item
                    Caption = 'File ID'
                    Width = 60
                  end
                  item
                    Caption = 'Link  Alias'
                    Width = 100
                  end>
                FlatScrollBars = True
                IconOptions.AutoArrange = True
                LargeImages = dmXtumble.VirtualImageList1
                ReadOnly = True
                RowSelect = True
                PopupMenu = popAttachments
                ShowWorkAreas = True
                SmallImages = dmXtumble.VirtualImageList1
                SortType = stText
                StateImages = dmXtumble.VirtualImageList1
                TabOrder = 0
                ViewStyle = vsReport
              end
            end
            object tsReports: TTabSheet
              Caption = 'Reports'
              ImageIndex = 2
              object ListView1: TListView
                AlignWithMargins = True
                Left = 10
                Top = 10
                Width = 682
                Height = 386
                Margins.Left = 10
                Margins.Top = 10
                Margins.Right = 10
                Margins.Bottom = 10
                Align = alClient
                Columns = <
                  item
                    Caption = 'Report Name'
                    Width = 250
                  end>
                FlatScrollBars = True
                IconOptions.AutoArrange = True
                LargeImages = dmXtumble.VirtualImageList1
                ReadOnly = True
                RowSelect = True
                PopupMenu = popReports
                ShowWorkAreas = True
                SmallImages = dmXtumble.VirtualImageList1
                SortType = stText
                StateImages = dmXtumble.VirtualImageList1
                TabOrder = 0
                ViewStyle = vsReport
              end
            end
          end
        end
        object ToolBar3: TToolBar
          AlignWithMargins = True
          Left = 10
          Top = 0
          Width = 981
          Height = 64
          Margins.Left = 10
          Margins.Top = 0
          Margins.Right = 10
          Margins.Bottom = 0
          ButtonHeight = 52
          ButtonWidth = 123
          Caption = 'ToolBar1'
          Images = dmXtumble.VirtualImageList1
          ShowCaptions = True
          TabOrder = 1
          object tsSaveMailTemplate: TToolButton
            Left = 0
            Top = 0
            Caption = 'Save template'
            ImageIndex = 20
            ImageName = 'Save_50px'
            OnClick = tsSaveMailTemplateClick
          end
          object tlBtnSaveAsSystemTemplate: TToolButton
            Left = 123
            Top = 0
            Caption = 'Save as SyS Template'
            ImageIndex = 18
            ImageName = 'Email_48px'
            OnClick = tlBtnSaveAsSystemTemplateClick
          end
          object ToolButton10: TToolButton
            Left = 246
            Top = 0
            Width = 24
            Caption = 'ToolButton6'
            ImageIndex = 18
            ImageName = 'Email_48px'
            Style = tbsSeparator
          end
          object tlBtnLoadFromSysTemplate: TToolButton
            Left = 270
            Top = 0
            Caption = 'Load from SyS Template'
            ImageIndex = 17
            ImageName = 'Download From Cloud_50px'
            OnClick = tlBtnLoadFromSysTemplateClick
          end
        end
      end
      object tsCampaignContact: TTabSheet
        Caption = 'Contacts on Campign'
        object dbgCampainContacts: TDBGrid
          AlignWithMargins = True
          Left = 10
          Top = 74
          Width = 981
          Height = 461
          Margins.Left = 10
          Margins.Top = 10
          Margins.Right = 10
          Margins.Bottom = 10
          Align = alClient
          DataSource = dsCampContacts
          PopupMenu = popCampContacts
          TabOrder = 0
          TitleFont.Charset = DEFAULT_CHARSET
          TitleFont.Color = clWindowText
          TitleFont.Height = -11
          TitleFont.Name = 'Tahoma'
          TitleFont.Style = []
          OnDrawColumnCell = dbgCampainContactsDrawColumnCell
          OnTitleClick = dbgContactsTitleClick
        end
        object ToolBar1: TToolBar
          AlignWithMargins = True
          Left = 10
          Top = 0
          Width = 981
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
            OnClick = ToolButton5Click
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
          Top = 115
          Width = 981
          Height = 420
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
          OnDrawColumnCell = dbgContactsDrawColumnCell
          OnTitleClick = dbgContactsTitleClick
        end
        object ToolBar2: TToolBar
          AlignWithMargins = True
          Left = 10
          Top = 0
          Width = 981
          Height = 64
          Margins.Left = 10
          Margins.Top = 0
          Margins.Right = 10
          Margins.Bottom = 0
          ButtonHeight = 52
          ButtonWidth = 85
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
          object tsAddToCampain: TToolButton
            Left = 24
            Top = 0
            Caption = 'Add To Campain'
            ImageIndex = 20
            ImageName = 'Save_50px'
            OnClick = tsAddToCampainClick
          end
          object tlAddToCampain: TToolButton
            Left = 109
            Top = 0
            Width = 30
            Caption = 'Add Selected to Campain'
            ImageIndex = 20
            ImageName = 'Save_50px'
            Style = tbsSeparator
          end
          object tsRefresh: TToolButton
            Left = 139
            Top = 0
            Caption = 'Refresh'
            ImageIndex = 21
            ImageName = 'Refresh_40px'
            OnClick = tsRefreshClick
          end
        end
        object pnlFilters: TPanel
          Left = 0
          Top = 64
          Width = 1001
          Height = 41
          Margins.Left = 10
          Margins.Right = 10
          Align = alTop
          TabOrder = 2
          ExplicitLeft = -2
          ExplicitTop = 61
          object lblMailingList: TLabel
            Left = 332
            Top = 6
            Width = 41
            Height = 13
            Caption = 'Mail List:'
          end
          object dblkMailingList: TDBLookupComboBox
            Left = 379
            Top = 3
            Width = 145
            Height = 21
            KeyField = 'PK_ID'
            ListField = 'DESCRIZIONE'
            ListSource = dsMailingList
            TabOrder = 0
            OnCloseUp = dblkMailingListCloseUp
          end
          object srcContacts: TSearchBox
            Left = 10
            Top = 3
            Width = 201
            Height = 21
            TabOrder = 1
            OnInvokeSearch = srcContactsInvokeSearch
          end
        end
      end
    end
  end
  object pnlLeftMenu: TPanel
    Left = 0
    Top = 47
    Width = 229
    Height = 656
    Align = alLeft
    TabOrder = 3
    object lvCampaigns: TListView
      AlignWithMargins = True
      Left = 11
      Top = 65
      Width = 207
      Height = 580
      Margins.Left = 10
      Margins.Top = 0
      Margins.Right = 10
      Margins.Bottom = 10
      Align = alClient
      Columns = <
        item
          AutoSize = True
          Caption = 'Campaign Name'
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
      PopupMenu = popCampaigns
      ShowWorkAreas = True
      SortType = stText
      TabOrder = 0
      ViewStyle = vsReport
      OnClick = lvCampaignsClick
      ExplicitLeft = 9
      ExplicitTop = 66
    end
    object ToolBar4: TToolBar
      AlignWithMargins = True
      Left = 11
      Top = 1
      Width = 207
      Height = 64
      Margins.Left = 10
      Margins.Top = 0
      Margins.Right = 10
      Margins.Bottom = 0
      ButtonHeight = 52
      ButtonWidth = 39
      Caption = 'ToolBar1'
      Images = dmXtumble.VirtualImageList1
      ShowCaptions = True
      TabOrder = 1
      object tlbtnPlay: TToolButton
        Left = 0
        Top = 0
        Caption = 'Play'
        ImageIndex = 19
        ImageName = 'Play_40px'
        OnClick = tlbtnPlayClick
      end
      object ToolButton2: TToolButton
        Left = 39
        Top = 0
        Width = 24
        Caption = 'ToolButton6'
        ImageIndex = 18
        ImageName = 'Email_48px'
        Style = tbsSeparator
      end
    end
  end
  object xtSendMail1: TxtSendMail
    active = False
    xtConnection = dmXtumble.XtConnection
    Left = 360
    Top = 16
  end
  object xtDsCampaigns: TxtDatasetEntity
    xtConnection = dmXtumble.XtConnection
    xtEntityName = 'crm_campaigns'
    xtRefreshAfterPost = False
    xtApplyUpdateAfterPost = True
    xtApplyUpdateAfterDelete = True
    xtLiveRecordInsert = True
    xtParams.Strings = (
      'fkparentfolder=-1000')
    xtMaxRecords = 10
    AfterOpen = xtDsCampaignsAfterOpen
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
    object xtDsCampaignsPK_ID: TIntegerField
      FieldName = 'PK_ID'
      Origin = 'PK_ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object xtDsCampaignsDESCRIZIONE: TStringField
      FieldName = 'DESCRIZIONE'
      Origin = 'DESCRIZIONE'
      Size = 200
    end
    object xtDsCampaignsFK_CRM_TIPO_CAMPAGNA: TIntegerField
      FieldName = 'FK_CRM_TIPO_CAMPAGNA'
      Origin = 'FK_CRM_TIPO_CAMPAGNA'
    end
    object xtDsCampaignsDB_SYNC_ID: TIntegerField
      FieldName = 'DB_SYNC_ID'
      Origin = 'DB_SYNC_ID'
    end
    object xtDsCampaignsUID: TStringField
      FieldName = 'UID'
      Origin = 'UID'
      Size = 40
    end
    object xtDsCampaignsFK_STATUS: TLargeintField
      FieldName = 'FK_STATUS'
      Origin = 'FK_STATUS'
    end
    object xtDsCampaignsSTART_DATE: TSQLTimeStampField
      FieldName = 'START_DATE'
      Origin = 'START_DATE'
    end
    object xtDsCampaignsEND_DATE: TSQLTimeStampField
      FieldName = 'END_DATE'
      Origin = 'END_DATE'
    end
    object xtDsCampaignsELIMINATA: TStringField
      FieldName = 'ELIMINATA'
      Origin = 'ELIMINATA'
      FixedChar = True
      Size = 1
    end
    object xtDsCampaignsCREATION_DATE: TSQLTimeStampField
      FieldName = 'CREATION_DATE'
      Origin = 'CREATION_DATE'
    end
    object xtDsCampaignsNAME: TStringField
      FieldName = 'NAME'
      Origin = 'NAME'
      Size = 30
    end
    object xtDsCampaignsFK_ALLEGATO_TEMPLATE: TLargeintField
      FieldName = 'FK_ALLEGATO_TEMPLATE'
      Origin = 'FK_ALLEGATO_TEMPLATE'
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
    AfterPost = xtDSContactsAfterPost
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
  object popCampaigns: TPopupMenu
    Left = 184
    Top = 232
    object Addfolder1: TMenuItem
      Caption = 'Create new Campaign'
      OnClick = Addfolder1Click
    end
    object Deletefolder1: TMenuItem
      Caption = 'Delete campaign'
      OnClick = Deletefolder1Click
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
  object xtDsCampContacts: TxtDatasetEntity
    xtConnection = dmXtumble.XtConnection
    xtEntityName = 'crm_campaign_contacts'
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
    object xtDsCampContactsPK_ID: TLargeintField
      FieldName = 'PK_ID'
      Origin = 'PK_ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object xtDsCampContactsFK_CAMPAIGN: TLargeintField
      FieldName = 'FK_CAMPAIGN'
      Origin = 'FK_CAMPAIGN'
      Visible = False
    end
    object xtDsCampContactsFK_CRM_CONTACT: TLargeintField
      FieldName = 'FK_CRM_CONTACT'
      Origin = 'FK_CRM_CONTACT'
      Visible = False
    end
    object xtDsCampContactsMAIL: TStringField
      AutoGenerateValue = arDefault
      DisplayWidth = 30
      FieldName = 'MAIL'
      Origin = 'MAIL'
      ProviderFlags = []
      ReadOnly = True
      Size = 200
    end
    object xtDsCampContactsCOMPANY_NAME: TStringField
      AutoGenerateValue = arDefault
      DisplayWidth = 30
      FieldName = 'COMPANY_NAME'
      Origin = 'COMPANY_NAME'
      ProviderFlags = []
      ReadOnly = True
      Size = 100
    end
    object xtDsCampContactsNAME: TStringField
      AutoGenerateValue = arDefault
      DisplayWidth = 30
      FieldName = 'NAME'
      Origin = 'NAME'
      ProviderFlags = []
      ReadOnly = True
      Size = 100
    end
    object xtDsCampContactsADDRESS: TStringField
      AutoGenerateValue = arDefault
      DisplayWidth = 30
      FieldName = 'ADDRESS'
      Origin = 'ADDRESS'
      ProviderFlags = []
      ReadOnly = True
      Size = 100
    end
    object xtDsCampContactsMOBILE_PHONE: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'MOBILE_PHONE'
      Origin = 'MOBILE_PHONE'
      ProviderFlags = []
      ReadOnly = True
      Size = 30
    end
    object xtDsCampContactsFK_MAIL_BATCH: TLargeintField
      FieldName = 'FK_MAIL_BATCH'
      Origin = 'FK_MAIL_BATCH'
    end
    object xtDsCampContactsUNSUBSCRIBED: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'UNSUBSCRIBED'
      Origin = 'UNSUBSCRIBED'
      ProviderFlags = []
      ReadOnly = True
      FixedChar = True
      Size = 1
    end
  end
  object dsCampContacts: TDataSource
    DataSet = xtDsCampContacts
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
      OnClick = LoadFromFile1Click
    end
    object SaveToFile1: TMenuItem
      Caption = 'Save To File'
      OnClick = SaveToFile1Click
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
      OnClick = Insertinmessagebody1Click
    end
    object MenuItem1: TMenuItem
      Caption = '-'
    end
    object Addfromyourcomputer1: TMenuItem
      Caption = 'Add from your computer'
      OnClick = Addfromyourcomputer1Click
    end
    object Addfromgallery1: TMenuItem
      Caption = 'Add from gallery'
      OnClick = Addfromgallery1Click
    end
    object MenuItem2: TMenuItem
      Caption = '-'
    end
    object Removeselected1: TMenuItem
      Caption = 'Remove selected'
      OnClick = Removeselected1Click
    end
    object RemoveAll1: TMenuItem
      Caption = 'Remove All'
      OnClick = RemoveAll1Click
    end
    object N3: TMenuItem
      Caption = '-'
    end
    object Refresh2: TMenuItem
      Caption = 'Refresh'
      OnClick = Refresh2Click
    end
  end
  object popCampContacts: TPopupMenu
    Left = 712
    Top = 400
    object Resetsentflag1: TMenuItem
      Caption = 'Reset sent flag'
      OnClick = Resetsentflag1Click
    end
  end
  object popReports: TPopupMenu
    Left = 624
    Top = 384
  end
  object xtDSMailingList: TxtDatasetEntity
    xtConnection = dmXtumble.XtConnection
    xtEntityName = 'crm_mailing_list'
    xtRefreshAfterPost = False
    xtApplyUpdateAfterPost = True
    xtApplyUpdateAfterDelete = True
    xtLiveRecordInsert = True
    xtMaxRecords = 1000
    AfterPost = xtDSContactsAfterPost
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
    Left = 312
    Top = 512
    object xtDSMailingListPK_ID: TLargeintField
      FieldName = 'PK_ID'
      Origin = 'PK_ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object xtDSMailingListDESCRIZIONE: TStringField
      FieldName = 'DESCRIZIONE'
      Origin = 'DESCRIZIONE'
      Size = 2000
    end
    object xtDSMailingListATTIVA: TStringField
      FieldName = 'ATTIVA'
      Origin = 'ATTIVA'
      Required = True
      FixedChar = True
      Size = 1
    end
    object xtDSMailingListDATA_CREAZIONE: TSQLTimeStampField
      FieldName = 'DATA_CREAZIONE'
      Origin = 'DATA_CREAZIONE'
    end
    object xtDSMailingListDATA_ULTIMA_COMUNICAZIONE: TSQLTimeStampField
      FieldName = 'DATA_ULTIMA_COMUNICAZIONE'
      Origin = 'DATA_ULTIMA_COMUNICAZIONE'
    end
    object xtDSMailingListEX_KEY: TStringField
      FieldName = 'EX_KEY'
      Origin = 'EX_KEY'
      Size = 30
    end
  end
  object dsMailingList: TDataSource
    DataSet = xtDSMailingList
    Left = 408
    Top = 520
  end
end
