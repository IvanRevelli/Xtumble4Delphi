unit uFrmMailTemplates;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ComCtrls, Vcl.ExtCtrls,
  uFrmMailTemplate, pasDmXtumble, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Param, FireDAC.Stan.Error, FireDAC.DatS, FireDAC.Phys.Intf,
  FireDAC.DApt.Intf, Data.DB, FireDAC.Comp.DataSet, FireDAC.Comp.Client,
  xtDatasetEntity, Vcl.StdCtrls, Vcl.Menus;

type
  TfrmMailTemplates = class(TForm)
    Panel1: TPanel;
    xtDsTemplates: TxtDatasetEntity;
    xtDsTemplatesPK_ID: TLargeintField;
    xtDsTemplatesTEMPLATE_NAME: TStringField;
    xtDsTemplatesSYSTEM_TEMPLATE: TStringField;
    xtDsTemplatesFK_ALLEGATO_TEMPLATE: TLargeintField;
    Panel2: TPanel;
    lvElencoTemplates: TListView;
    btnNewMailTemplate: TButton;
    Splitter1: TSplitter;
    popList: TPopupMenu;
    Refresh1: TMenuItem;
    btnNewFromFile: TButton;
    pnlSelect: TPanel;
    btnSelect: TButton;
    btnCancel: TButton;
    procedure FormCreate(Sender: TObject);
    procedure lvElencoTemplatesClick(Sender: TObject);
    procedure btnNewMailTemplateClick(Sender: TObject);
    procedure Refresh1Click(Sender: TObject);
    procedure btnNewFromFileClick(Sender: TObject);
  private
    Ftemplate_name: string;
    procedure nuovoTemplate(templateName: string);
    procedure Settemplate_name(const Value: string);
    { Private declarations }
  public
    { Public declarations }
    frmMTemplate: TfrmMailTemplate;
    property  template_name: string read Ftemplate_name write Settemplate_name;
    procedure refreshList;
  end;

var
  frmMailTemplates: TfrmMailTemplates;

implementation

{$R *.dfm}

procedure TfrmMailTemplates.btnNewFromFileClick(Sender: TObject);
var
  fname: String;
  templateName: string;
begin
 dmXtumble.OD.Filter := '*.html|*.html';
 if dmXtumble.OD.Execute then
  Begin
    fname :=  dmXtumble.OD.FileName;

    templateName := ExtractFileName(fname).Replace(ExtractFileExt(fname),'.mailxt').ToLower;
    nuovoTemplate(templateName);
    frmMTemplate.template_name := templateName;
    frmMTemplate.MemoBody.Lines.LoadFromFile(fname);
    frmMTemplate.saveMailTemplate;

  End;
end;

procedure TfrmMailTemplates.btnNewMailTemplateClick(Sender: TObject);
var
 templateName: string;
begin
 nuovoTemplate(templateName);
end;

procedure TfrmMailTemplates.FormCreate(Sender: TObject);
var
  li: TListItem;

begin
 if frmMTemplate = nil then
   frmMTemplate := TfrmMailTemplate.Create(nil);
 dmXtumble.embedForm(frmMTemplate,Panel1);
 frmMTemplate.Visible := True;
 frmMTemplate.Show;

 refreshList;

end;

procedure TfrmMailTemplates.lvElencoTemplatesClick(Sender: TObject);
begin
 if lvElencoTemplates.Selected <> nil then
  Begin
   template_name := lvElencoTemplates.Selected.Caption;
  End;
end;

procedure TfrmMailTemplates.Refresh1Click(Sender: TObject);
begin
 if xtDsTemplates.Active then
   xtDsTemplates.Close;

 refreshList;
end;

procedure TfrmMailTemplates.refreshList;
var
  li: TlistItem;
begin

 xtDsTemplates.Open;
 xtDsTemplates.First;

 lvElencoTemplates.Items.Clear;

 while not xtDsTemplates.Eof do
  Begin
   li := lvElencoTemplates.Items.Add;
   li.Caption := xtDsTemplatesTEMPLATE_NAME.AsString;
   xtDsTemplates.Next;
  End;


end;

procedure TfrmMailTemplates.Settemplate_name(const Value: string);
begin
  Ftemplate_name := Value;
  frmMTemplate.template_name := Ftemplate_name;
end;

procedure TfrmMailTemplates.nuovoTemplate(templateName: string);
begin
  if InputQuery('Template Name:', 'Template Name:', templateName) then
  begin
    xtDsTemplates.Insert;
    xtDsTemplatesTEMPLATE_NAME.AsString := templateName;
    xtDsTemplates.Post;
  end;
  xtDsTemplates.Close;
  refreshList;
end;

end.
