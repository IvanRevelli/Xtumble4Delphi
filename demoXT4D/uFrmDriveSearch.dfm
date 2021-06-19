object frmDriveSearch: TfrmDriveSearch
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 492
  ClientWidth = 794
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  PixelsPerInch = 96
  TextHeight = 13
  object pnlCurrentFolder: TPanel
    AlignWithMargins = True
    Left = 10
    Top = 10
    Width = 774
    Height = 41
    Margins.Left = 10
    Margins.Top = 10
    Margins.Right = 10
    Margins.Bottom = 10
    Align = alTop
    Caption = 'Find in files'
    Font.Charset = DEFAULT_CHARSET
    Font.Color = 16727100
    Font.Height = -19
    Font.Name = 'Lucida Fax'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
    ExplicitLeft = 11
    ExplicitTop = 11
    ExplicitWidth = 762
  end
  object lvFiles: TListView
    AlignWithMargins = True
    Left = 10
    Top = 106
    Width = 774
    Height = 376
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
        Caption = 'File Size'
      end
      item
        Caption = 'Upload Date'
        Width = 100
      end
      item
        AutoSize = True
        Caption = 'File ID'
      end
      item
        Caption = 'Custom Protocol'
        Width = 110
      end
      item
        Caption = 'Full Path'
        Width = 250
      end
      item
        Caption = 'Description'
      end>
    FlatScrollBars = True
    IconOptions.AutoArrange = True
    ReadOnly = True
    RowSelect = True
    ShowWorkAreas = True
    SortType = stText
    TabOrder = 1
    ViewStyle = vsReport
    ExplicitLeft = 226
  end
  object SearchBox1: TSearchBox
    AlignWithMargins = True
    Left = 5
    Top = 66
    Width = 784
    Height = 25
    Margins.Left = 5
    Margins.Top = 5
    Margins.Right = 5
    Margins.Bottom = 5
    Align = alTop
    TabOrder = 2
    Text = 'SearchBox1'
    OnInvokeSearch = SearchBox1InvokeSearch
  end
  object xtDSFiles: TxtDatasetEntity
    xtConnection = dmXtumble.XtConnection
    xtEntityName = 'files'
    xtRefreshAfterPost = False
    xtApplyUpdateAfterPost = False
    xtApplyUpdateAfterDelete = False
    xtLiveRecordInsert = True
    xtParams.Strings = (
      'CURRENT_FOLDER=1')
    xtMaxRecords = 1000
    AfterOpen = xtDSFilesAfterOpen
    FieldDefs = <>
    IndexDefs = <>
    FetchOptions.AssignedValues = [evMode]
    FetchOptions.Mode = fmAll
    ResourceOptions.AssignedValues = [rvSilentMode]
    ResourceOptions.SilentMode = True
    UpdateOptions.AssignedValues = [uvEDelete, uvEInsert, uvEUpdate, uvCheckRequired, uvAutoCommitUpdates]
    UpdateOptions.EnableDelete = False
    UpdateOptions.EnableInsert = False
    UpdateOptions.EnableUpdate = False
    UpdateOptions.CheckRequired = False
    UpdateOptions.AutoCommitUpdates = True
    StoreDefs = True
    Left = 200
    Top = 432
    object xtDSFilesPK_ID: TIntegerField
      FieldName = 'PK_ID'
      Origin = 'PK_ID'
    end
    object xtDSFilesLOGICAL_FILENAME: TStringField
      FieldName = 'LOGICAL_FILENAME'
      Origin = 'LOGICAL_FILENAME'
      Size = 2000
    end
    object xtDSFilesFILE_SIZE: TIntegerField
      FieldName = 'FILE_SIZE'
      Origin = 'FILE_SIZE'
    end
    object xtDSFilesFK_FILE_TYPE: TIntegerField
      FieldName = 'FK_FILE_TYPE'
      Origin = 'FK_TIPO_FILE'
    end
    object xtDSFilesUPLOAD_DATE: TSQLTimeStampField
      FieldName = 'UPLOAD_DATE'
      Origin = 'DATA_INSERIMENTO'
    end
    object xtDSFilesREL_TO: TStringField
      FieldName = 'REL_TO'
      Origin = 'REL_TO'
      Size = 200
    end
    object xtDSFilesDESCRIPTION: TStringField
      FieldName = 'DESCRIPTION'
      Origin = 'DESCRIZIONE'
      Size = 2000
    end
    object xtDSFilesFK_FOLDER: TIntegerField
      FieldName = 'FK_FOLDER'
      Origin = 'FK_CARTELLA'
    end
    object xtDSFilesFK_USER_OWNER: TIntegerField
      FieldName = 'FK_USER_OWNER'
      Origin = 'FK_USERS'
    end
    object xtDSFilesREL_TO_PK: TLargeintField
      FieldName = 'REL_TO_PK'
      Origin = 'REL_TO_PK'
    end
    object xtDSFilesEXTERNAL_REVISION: TStringField
      FieldName = 'EXTERNAL_REVISION'
      Origin = 'EXTERNAL_REVISION'
      Size = 30
    end
    object xtDSFilesPRIVATE: TStringField
      FieldName = 'PRIVATE'
      Origin = 'PRIVATO'
      FixedChar = True
      Size = 1
    end
    object xtDSFilesFULL_PATH: TStringField
      FieldName = 'FULL_PATH'
      Origin = 'FULL_PATH'
      Size = 8000
    end
    object xtDSFilesFILE_NAME: TStringField
      AutoGenerateValue = arDefault
      FieldName = 'FILE_NAME'
      Origin = 'FILE_NAME'
      ProviderFlags = []
      ReadOnly = True
      Size = 10000
    end
    object xtDSFilesCONTENT_SHA256: TStringField
      FieldName = 'CONTENT_SHA256'
      Origin = 'CONTENT_SHA256'
      Size = 100
    end
  end
  object dsFiles: TDataSource
    DataSet = xtDSFiles
    Left = 264
    Top = 432
  end
end
