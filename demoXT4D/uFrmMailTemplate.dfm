object frmMailTemplate: TfrmMailTemplate
  Left = 0
  Top = 0
  BorderStyle = bsNone
  Caption = 'frmMailTemplate'
  ClientHeight = 566
  ClientWidth = 905
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
  object gbMailDetails: TGroupBox
    AlignWithMargins = True
    Left = 10
    Top = 133
    Width = 885
    Height = 423
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
      Height = 386
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
      Width = 614
      Height = 386
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
          Width = 596
          Height = 348
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
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object lvFiles: TListView
          AlignWithMargins = True
          Left = 10
          Top = 10
          Width = 586
          Height = 338
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
        ExplicitLeft = 0
        ExplicitTop = 0
        ExplicitWidth = 0
        ExplicitHeight = 0
        object lvReports: TListView
          AlignWithMargins = True
          Left = 10
          Top = 10
          Width = 586
          Height = 338
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
    Top = 69
    Width = 885
    Height = 64
    Margins.Left = 10
    Margins.Top = 0
    Margins.Right = 10
    Margins.Bottom = 0
    ButtonHeight = 52
    ButtonWidth = 112
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
    object ToolButton10: TToolButton
      Left = 112
      Top = 0
      Width = 24
      Caption = 'ToolButton6'
      ImageIndex = 18
      ImageName = 'Email_48px'
      Style = tbsSeparator
    end
    object tlBtnSaveAsSystemTemplate: TToolButton
      Left = 136
      Top = 0
      Caption = 'Save as Sys Template'
      ImageIndex = 18
      ImageName = 'Email_48px'
      OnClick = tlBtnSaveAsSystemTemplateClick
    end
  end
  object pnlHeader: TPanel
    AlignWithMargins = True
    Left = 10
    Top = 10
    Width = 885
    Height = 49
    Margins.Left = 10
    Margins.Top = 10
    Margins.Right = 10
    Margins.Bottom = 10
    Align = alTop
    Caption = '-'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -27
    Font.Name = 'Tahoma'
    Font.Style = []
    ParentFont = False
    TabOrder = 2
  end
  object popAttachments: TPopupMenu
    Left = 501
    Top = 248
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
  object xtSendMail1: TxtSendMail
    active = False
    xtConnection = dmXtumble.XtConnection
    Left = 360
    Top = 336
  end
  object xtDriveCommands: TxtDriveCommands
    active = False
    xtConnection = dmXtumble.XtConnection
    Left = 400
    Top = 432
  end
  object popReports: TPopupMenu
    Left = 624
    Top = 384
    object AddReportTemplate1: TMenuItem
      Caption = 'Add Report'
      OnClick = AddReportTemplate1Click
    end
    object RemoveReport1: TMenuItem
      Caption = 'Remove Report'
      OnClick = RemoveReport1Click
    end
  end
end
