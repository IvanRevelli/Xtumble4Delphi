object frmMailComposer: TfrmMailComposer
  Left = 0
  Top = 0
  Caption = 'Mail Composer'
  ClientHeight = 505
  ClientWidth = 544
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object pnlFooter: TPanel
    Left = 0
    Top = 464
    Width = 544
    Height = 41
    Align = alBottom
    TabOrder = 0
    object btnSendMail: TButton
      Left = 336
      Top = 6
      Width = 75
      Height = 25
      Caption = 'Send Mail'
      TabOrder = 0
      OnClick = btnSendMailClick
    end
    object btnCancel: TButton
      Left = 440
      Top = 6
      Width = 75
      Height = 25
      Caption = 'Cancel'
      ModalResult = 2
      TabOrder = 1
    end
  end
  object pnlMailData: TPanel
    Left = 0
    Top = 0
    Width = 544
    Height = 257
    Align = alTop
    PopupMenu = popMailMsg
    TabOrder = 1
  end
  object PageControl1: TPageControl
    AlignWithMargins = True
    Left = 10
    Top = 267
    Width = 524
    Height = 187
    Margins.Left = 10
    Margins.Top = 10
    Margins.Right = 10
    Margins.Bottom = 10
    ActivePage = tsMailBody
    Align = alClient
    TabOrder = 2
    object tsMailBody: TTabSheet
      Caption = 'MailBody'
      object MemoBody: TMemo
        Left = 0
        Top = 0
        Width = 516
        Height = 159
        Align = alClient
        Lines.Strings = (
          '')
        TabOrder = 0
      end
    end
    object tsAttachments: TTabSheet
      Caption = 'Attachments'
      ImageIndex = 1
      ExplicitLeft = 0
      ExplicitTop = 0
      ExplicitWidth = 0
      ExplicitHeight = 0
      object lvFiles: TListView
        AlignWithMargins = True
        Left = 10
        Top = 10
        Width = 496
        Height = 139
        Margins.Left = 10
        Margins.Top = 10
        Margins.Right = 10
        Margins.Bottom = 10
        Align = alClient
        Columns = <
          item
            AutoSize = True
            Caption = 'File Name'
          end
          item
            AutoSize = True
            Caption = 'File ID'
          end
          item
            Caption = 'Attach msg Alias for Link'
            Width = 200
          end>
        FlatScrollBars = True
        IconOptions.AutoArrange = True
        ReadOnly = True
        RowSelect = True
        PopupMenu = popAttachments
        ShowWorkAreas = True
        SortType = stText
        TabOrder = 0
        ViewStyle = vsReport
      end
    end
  end
  object xtSendMail1: TxtSendMail
    active = False
    xtConnection = dmXtumble.XtConnection
    Left = 336
    Top = 352
  end
  object popAttachments: TPopupMenu
    Left = 432
    Top = 352
    object Insertinmessagebody1: TMenuItem
      Caption = 'Insert in message body'
      OnClick = Insertinmessagebody1Click
    end
    object N2: TMenuItem
      Caption = '-'
    end
    object Addfromyourcomputer1: TMenuItem
      Caption = 'Add from your computer'
      OnClick = Addfromyourcomputer1Click
    end
    object Addfromgallery1: TMenuItem
      Caption = 'Add from gallery'
      Enabled = False
    end
    object N1: TMenuItem
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
  end
  object xtDriveCommands: TxtDriveCommands
    active = False
    xtConnection = dmXtumble.XtConnection
    Left = 232
    Top = 352
  end
  object popMailMsg: TPopupMenu
    Left = 280
    Top = 152
    object Saveasmailtemplate1: TMenuItem
      Caption = 'Save to file'
      OnClick = Saveasmailtemplate1Click
    end
    object OpenMailTemplate1: TMenuItem
      Caption = 'Open From File'
      OnClick = OpenMailTemplate1Click
    end
    object SaveasTemplate1: TMenuItem
      Caption = 'Save as Template'
      OnClick = SaveasTemplate1Click
    end
  end
end
