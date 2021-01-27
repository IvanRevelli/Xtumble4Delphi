object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'Xtumble4Delphi Demo - https://xtumble.com'
  ClientHeight = 721
  ClientWidth = 1132
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  Position = poScreenCenter
  Visible = True
  OnClose = FormClose
  OnCloseQuery = FormCloseQuery
  OnCreate = FormCreate
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object CategoryPanelGroup1: TCategoryPanelGroup
    Left = 0
    Top = 0
    Height = 702
    VertScrollBar.Tracking = True
    HeaderFont.Charset = DEFAULT_CHARSET
    HeaderFont.Color = clWindowText
    HeaderFont.Height = -11
    HeaderFont.Name = 'Tahoma'
    HeaderFont.Style = []
    TabOrder = 0
    object cpXtumbeERP: TCategoryPanel
      Top = 0
      Height = 178
      Caption = 'Xtumble ERP'
      TabOrder = 0
      object btnArticles: TButton
        AlignWithMargins = True
        Left = 10
        Top = 80
        Width = 174
        Height = 25
        Margins.Left = 10
        Margins.Top = 10
        Margins.Right = 10
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Articles'
        TabOrder = 0
        OnClick = btnArticlesClick
      end
      object btnContacts: TButton
        AlignWithMargins = True
        Left = 10
        Top = 45
        Width = 174
        Height = 25
        Margins.Left = 10
        Margins.Top = 10
        Margins.Right = 10
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Contacts'
        TabOrder = 1
        OnClick = btnContactsClick
      end
      object btnDashboard: TButton
        AlignWithMargins = True
        Left = 10
        Top = 10
        Width = 174
        Height = 25
        Margins.Left = 10
        Margins.Top = 10
        Margins.Right = 10
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Dashboard'
        TabOrder = 2
        OnClick = btnDashboardClick
      end
    end
    object XtumbleSettings: TCategoryPanel
      Top = 488
      Height = 120
      Caption = 'Settings'
      TabOrder = 1
      ExplicitTop = 329
      object btnSettings: TButton
        AlignWithMargins = True
        Left = 10
        Top = 10
        Width = 174
        Height = 25
        Margins.Left = 10
        Margins.Top = 10
        Margins.Right = 10
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Settings'
        TabOrder = 0
      end
    end
    object CategoryPanel1: TCategoryPanel
      Top = 337
      Height = 151
      Caption = 'Cloud Tools'
      TabOrder = 2
      ExplicitTop = 172
      ExplicitWidth = 185
      object btnDrive: TButton
        AlignWithMargins = True
        Left = 10
        Top = 10
        Width = 174
        Height = 25
        Margins.Left = 10
        Margins.Top = 10
        Margins.Right = 10
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Drive'
        TabOrder = 0
        OnClick = btnDriveClick
      end
    end
    object cpCRM: TCategoryPanel
      Top = 178
      Height = 159
      Caption = 'CRM Tools'
      TabOrder = 3
      object btnMails: TButton
        AlignWithMargins = True
        Left = 10
        Top = 45
        Width = 174
        Height = 25
        Margins.Left = 10
        Margins.Top = 10
        Margins.Right = 10
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Mails / CRM'
        TabOrder = 0
        OnClick = btnMails_Click
        ExplicitTop = 80
      end
      object btnMailTemplates: TButton
        AlignWithMargins = True
        Left = 10
        Top = 80
        Width = 174
        Height = 25
        Margins.Left = 10
        Margins.Top = 10
        Margins.Right = 10
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Mail Templates'
        TabOrder = 1
        OnClick = btnMailTemplates_Click
        ExplicitTop = 106
      end
      object btnMailingList: TButton
        AlignWithMargins = True
        Left = 10
        Top = 10
        Width = 174
        Height = 25
        Margins.Left = 10
        Margins.Top = 10
        Margins.Right = 10
        Margins.Bottom = 0
        Align = alTop
        Caption = 'Mailing Contacts / Lists'
        TabOrder = 2
        OnClick = btnMailingListClick
        ExplicitLeft = 18
        ExplicitTop = 53
      end
    end
  end
  object StatusBar1: TStatusBar
    Left = 0
    Top = 702
    Width = 1132
    Height = 19
    Panels = <
      item
        Width = 250
      end
      item
        Width = 250
      end
      item
        Width = 250
      end>
  end
  object pnlContainer: TPanel
    Left = 200
    Top = 0
    Width = 932
    Height = 702
    Align = alClient
    Caption = 'Panel1'
    ShowCaption = False
    TabOrder = 2
    object Splitter1: TSplitter
      Left = 1
      Top = 515
      Width = 930
      Height = 5
      Cursor = crVSplit
      Align = alBottom
      ExplicitTop = 564
    end
    object pnlMain: TPanel
      AlignWithMargins = True
      Left = 11
      Top = 11
      Width = 910
      Height = 494
      Margins.Left = 10
      Margins.Top = 10
      Margins.Right = 10
      Margins.Bottom = 10
      Align = alClient
      TabOrder = 0
    end
    object pnlLogs: TPanel
      AlignWithMargins = True
      Left = 11
      Top = 520
      Width = 910
      Height = 171
      Margins.Left = 10
      Margins.Top = 0
      Margins.Right = 10
      Margins.Bottom = 10
      Align = alBottom
      Caption = 'Logs'
      TabOrder = 1
      object pgLogs: TPageControl
        Left = 1
        Top = 1
        Width = 908
        Height = 169
        ActivePage = tsLog
        Align = alClient
        TabOrder = 0
        object tsLog: TTabSheet
          Caption = 'Log'
          object MemoLog: TMemo
            Left = 0
            Top = 0
            Width = 900
            Height = 141
            Align = alClient
            Lines.Strings = (
              'MemoLog')
            ScrollBars = ssBoth
            TabOrder = 0
          end
        end
        object TabSheet2: TTabSheet
          Caption = 'TabSheet2'
          ImageIndex = 1
        end
      end
    end
  end
  object MainMenu1: TMainMenu
    Left = 88
    Top = 544
  end
end
