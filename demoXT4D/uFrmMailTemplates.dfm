object frmMailTemplates: TfrmMailTemplates
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmMailTemplates'
  ClientHeight = 585
  ClientWidth = 994
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
    Left = 297
    Top = 0
    Width = 8
    Height = 585
    ExplicitLeft = 185
  end
  object Panel1: TPanel
    Left = 305
    Top = 0
    Width = 689
    Height = 585
    Align = alClient
    TabOrder = 0
    object pnlSelect: TPanel
      Left = 1
      Top = 536
      Width = 687
      Height = 48
      Align = alBottom
      TabOrder = 0
      object btnSelect: TButton
        Left = 584
        Top = 8
        Width = 75
        Height = 33
        Caption = 'Select'
        ModalResult = 1
        TabOrder = 0
      end
      object btnCancel: TButton
        Left = 480
        Top = 7
        Width = 75
        Height = 33
        Caption = 'Cancel'
        ModalResult = 2
        TabOrder = 1
      end
    end
  end
  object Panel2: TPanel
    Left = 0
    Top = 0
    Width = 297
    Height = 585
    Align = alLeft
    TabOrder = 1
    object lvElencoTemplates: TListView
      AlignWithMargins = True
      Left = 11
      Top = 91
      Width = 275
      Height = 483
      Margins.Left = 10
      Margins.Top = 0
      Margins.Right = 10
      Margins.Bottom = 10
      Align = alClient
      Columns = <
        item
          Caption = 'Template Name'
          Width = 300
        end>
      Font.Charset = DEFAULT_CHARSET
      Font.Color = clWindowText
      Font.Height = -16
      Font.Name = 'Tahoma'
      Font.Style = []
      StyleElements = [seClient, seBorder]
      ParentFont = False
      PopupMenu = popList
      TabOrder = 0
      ViewStyle = vsReport
      OnClick = lvElencoTemplatesClick
    end
    object btnNewMailTemplate: TButton
      AlignWithMargins = True
      Left = 11
      Top = 11
      Width = 275
      Height = 25
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 10
      Align = alTop
      Caption = 'New'
      TabOrder = 1
      OnClick = btnNewMailTemplateClick
      ExplicitLeft = 9
    end
    object btnNewFromFile: TButton
      AlignWithMargins = True
      Left = 11
      Top = 56
      Width = 275
      Height = 25
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 10
      Align = alTop
      Caption = 'New from File'
      TabOrder = 2
      OnClick = btnNewFromFileClick
    end
  end
  object xtDsTemplates: TxtDatasetEntity
    xtConnection = dmXtumble.XtConnection
    xtEntityName = 'mail_templates'
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
    Left = 480
    Top = 280
    object xtDsTemplatesPK_ID: TLargeintField
      FieldName = 'PK_ID'
      Origin = 'PK_ID'
      ProviderFlags = [pfInUpdate, pfInWhere, pfInKey]
      Required = True
    end
    object xtDsTemplatesTEMPLATE_NAME: TStringField
      FieldName = 'TEMPLATE_NAME'
      Origin = 'TEMPLATE_NAME'
      Size = 100
    end
    object xtDsTemplatesSYSTEM_TEMPLATE: TStringField
      FieldName = 'SYSTEM_TEMPLATE'
      Origin = 'SYSTEM_TEMPLATE'
      FixedChar = True
      Size = 1
    end
    object xtDsTemplatesFK_ALLEGATO_TEMPLATE: TLargeintField
      FieldName = 'FK_ALLEGATO_TEMPLATE'
      Origin = 'FK_ALLEGATO_TEMPLATE'
    end
  end
  object popList: TPopupMenu
    Left = 480
    Top = 336
    object Refresh1: TMenuItem
      Caption = 'Refresh'
      OnClick = Refresh1Click
    end
  end
end
