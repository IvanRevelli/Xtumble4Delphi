unit uCommon;

interface
uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  pasDmXtumble, FireDAC.Stan.Intf, FireDAC.Stan.Option, FireDAC.Stan.Param,
  FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf, FireDAC.DApt.Intf,
  Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client, xtDatasetEntity, Vcl.Menus,
  uXtDriveCommands, Vcl.Grids, Vcl.DBGrids, System.ImageList, Vcl.ImgList,
  Vcl.VirtualImageList, Vcl.BaseImageCollection, Vcl.ImageCollection,
  Vcl.ToolWin, uxtCommonComponent, Vcl.WinXCtrls;

type
  TEntityNode = class
  private
    Fpk_id: Int64;
    FfullPath: String;
    procedure Setpk_id(const Value: Int64);
    procedure SetfullPath(const Value: String);
  public
    item : TTreeNode;
    property pk_id : Int64 read Fpk_id write Setpk_id;
    property fullPath : String read FfullPath write SetfullPath;
  end;

  TFileNode = class
  private
    Fpk_id: Int64;
    FisPublic: Boolean;
    Ffull_filename: String;
    Fcustom_protocol: String;
    procedure Setpk_id(const Value: Int64);
    procedure SetisPublic(const Value: Boolean);
    procedure Setfull_filename(const Value: String);
    procedure Setcustom_protocol(const Value: String);
    function getOnlyFileName: String;
  public
    kid : Integer;

    property onlyFileName : String read getonlyFileName;

    property pk_id : Int64 read Fpk_id write Setpk_id;
    property full_filename : String read Ffull_filename write Setfull_filename;

    property custom_protocol : String read Fcustom_protocol write Setcustom_protocol;
    property isPublic : Boolean read FisPublic write SetisPublic;
  end;

implementation

{ TFolderNode }
uses System.IOUtils;

procedure TEntityNode.SetfullPath(const Value: String);
begin
  FfullPath := Value;
end;

procedure TEntityNode.Setpk_id(const Value: Int64);
begin
 Fpk_id := Value;
end;

{ TFileNode }

function TFileNode.getOnlyFileName: String;
begin
 Result := ExtractFileName(Ffull_filename.Replace('/',TPath.DirectorySeparatorChar));
end;

procedure TFileNode.Setcustom_protocol(const Value: String);
begin
  Fcustom_protocol := Value;
end;

procedure TFileNode.Setfull_filename(const Value: String);
begin
  Ffull_filename := Value;
end;

procedure TFileNode.SetisPublic(const Value: Boolean);
begin
  FisPublic := Value;
end;

procedure TFileNode.Setpk_id(const Value: Int64);
begin
  Fpk_id := value;
end;

end.
