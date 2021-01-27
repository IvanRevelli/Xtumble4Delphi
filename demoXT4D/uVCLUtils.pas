unit uVCLUtils;

interface

uses
 System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants
 , Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Imaging.pngimage,
  Vcl.ComCtrls, Vcl.StdCtrls, Vcl.WinXCtrls, System.Rtti,System.TypInfo;

type
 TRcdEditor<T> = class
  public
    type
     TWriteRecordFieldProc = reference to procedure (var ARecord: T; const AField: TRttiField; var AStop: Boolean; displayLabel : String);

    class procedure ForEachField (var ARecord: T; const AProc: TWriteRecordFieldProc; ADisplayLabels : Tarray<string> = [] );
    class function GetVisibleFields(const AType: TRttiType): TArray<TRttiField>; static;

    class procedure setFieldValue(var ARecord: T; const FieldName: String; AValue: String);
    class function getFieldValue(var ARecord: T; const FieldName: String) : TValue;

  end;


 TxtEdit = class(Tedit)
 public
//   constructor Create
   tagObject : TObject;
   TagString : String;
   constructor Create(AOwner: TComponent); override;
 end;

 TxtToggleSwitch = class(TToggleSwitch)
 public
   TagString : String;
   tagObject : TObject;
   constructor Create(AOwner: TComponent); override;
 end;

 TRecordEditorPanel<T> = class(TPanel)
  private
   Fdata: T;
//   FImageLink: TGlyphImageLink;
//   [Weak] FImages: TCustomImageList;

   procedure Setdata(const Value: T);
   procedure onEditChange(Sender: TObject);
   procedure clickShowHidePassword(Sender: TObject);
  public
   currentTabOrder : Integer;
   CurrentPos : Single;
   DisplayLabels : TArray<string>;
   ImageList : TImageList;


   PasswordImageIndex : Integer;
   function getData : T;
   property data : T read getData write Setdata;



   constructor Create(AOwner: TComponent); override;

   procedure refreshFields;

   procedure addControl(cnt: TControl; VerticalSpacing : Single = 40; controlHeigth : Single = 60);
  published
  end;

implementation

{ TRecordEditorPanel<T> }

procedure TRecordEditorPanel<T>.addControl(cnt: TControl; VerticalSpacing,
  controlHeigth: Single);
begin

end;

procedure TRecordEditorPanel<T>.clickShowHidePassword(Sender: TObject);
var
 btn : TButton;
begin
  if Sender = nil then exit;

  if not (Sender is TControl) then exit;

  btn := TButton(Sender);

  if btn.Parent = nil then exit;
  if not (btn.Parent is TEdit) then exit;

  if TEdit(btn.Parent).PasswordChar = '' then
   TEdit(btn.Parent).PasswordChar := '#'
  else
   TEdit(btn.Parent).PasswordChar := #0;

//  TEdit(btn.Parent).PasswordChar := not TEdit(btn.Parent).Password;

end;

constructor TRecordEditorPanel<T>.Create(AOwner: TComponent);
begin
  inherited;

  currentTabOrder := 0;
  ImageList := nil;
  self.Height := 100;


  DisplayLabels := [];
end;

function TRecordEditorPanel<T>.getData: T;
var
  I: Integer;
  ed: TxtEdit;
  sw: TxtToggleSwitch;
  tmpVal: string;
begin
 for I := 0 to self.ComponentCount-1 do
  begin
   if self.Components[I] is TEdit then
    Begin
     ed := TxtEdit(self.Components[I]);
     TRcdEditor<T>.setFieldValue(Result,ed.TagString,ed.Text);
     Fdata := Result;
    End
   Else if self.Components[I] is TToggleSwitch then
    Begin
     sw := TxtToggleSwitch(self.Components[I]);


     if sw.IsOn then
       tmpVal := 'True'
     Else
       tmpVal := 'False';



     TRcdEditor<T>.setFieldValue(Result,sw.TagString,tmpVal);
     Fdata := Result;
    End
  end;


end;

procedure TRecordEditorPanel<T>.onEditChange(Sender: TObject);
var
 ed : TxtEdit;
begin
 if Sender = nil then exit;
 If not(Sender is TEdit) then exit;

 ed := TxtEdit(Sender);
 if ed.Text <> '' then
  ed.TextHint := ''
 Else
  Begin
   if ed.TagObject <> nil then
    if ed.TagObject is TLabel then
     ed.TextHint := TLabel(ed.TagObject).Caption;
  End;
End;

procedure TRecordEditorPanel<T>.refreshFields;
begin
//  self.CurrentPos := 0;
  self.currentTabOrder := 0;

//  self.Width := 100;
  TRcdEditor<T>.ForEachField(Fdata,
    procedure(var ARecord: T; const AField: TRttiField; var AStop: Boolean;
      LdisplayLabel: String)
    var
      ed: TxtEdit;
      lbl: TLabel;
      btnShowPw: TButton;
      sw : TxtToggleSwitch;
    isBoolean: Boolean;
    begin
      if AField.FieldType.TypeKind in [tkInteger, tkChar, tkEnumeration,
        tkFloat, tkString,
      // tkSet,
      // tkClass,
      // tkMethod,
      // tkWChar,
      // tkLString,
      // tkWString,
      // tkVariant,
      // tkArray,
      // tkRecord,
      // tkInterface,
      tkInt64,
      // tkDynArray,
      tkUString
      // tkClassRef,
      // tkPointer,
      // tkProcedure,
      // tkMRecord
        ] then
      Begin
        lbl := nil;
        ed  := nil;
        sw  := nil;
        if LdisplayLabel <> '#@#' then // non renderizzo la prop del record
        Begin
          Self.currentTabOrder := Self.currentTabOrder +1;

          lbl := Tlabel(Self.FindComponent('lbl' + AField.Name));

          if lbl = nil then
           Begin
            lbl := TLabel.Create(Self);
            lbl.Parent := self;
            lbl.Name := 'lbl' + AField.Name;

            if LdisplayLabel <> '' then
              lbl.Caption := LdisplayLabel.Replace('#','')
            Else
              lbl.Caption := AField.Name;

            lbl.Width := 250;
//            lbl.TextSettings.Font.Size := 15;
            lbl.Left := 50; //(self.Width - lbl.Width)/2 - lbl.Width;
            lbl.Top := round(self.CurrentPos) ;
//            self.CurrentPos := self.CurrentPos + lbl.Height + 4;

            lbl.Visible := True;
           End;

          isBoolean := False;
          if AField.FieldType.TypeKind in [tkEnumeration] then
            begin
              if AField.FieldType.Handle = TypeInfo(Boolean) then
               Begin
                isBoolean := True;
               End;
            End;

          if isBoolean then
           Begin
              sw := TxtToggleSwitch(Self.FindComponent('sw' + AField.Name));
              if sw = nil then
               Begin
                  sw := TxtToggleSwitch.Create(self);
                  sw.Parent := self;
                  sw.Name := 'sw' + AField.Name;
                  sw.Top := round(self.CurrentPos) ;
                  sw.Width := 60;
                  lbl.Height := sw.Height;
                  sw.TabOrder := Self.currentTabOrder;
                  sw.Left := lbl.Width; //(self.Width - sw.Width)/2;

                  self.CurrentPos := self.CurrentPos + 40;
                  sw.TagString := AField.Name;
                  sw.TagObject := lbl;

                  self.Height := self.Height + 45;
               End;

              if AField.GetValue(@ARecord).AsType<Boolean> then
                 sw.State := tssOn
              else
                 sw.State := tssOff;

//              sw.IsOn := ;
           End
          Else
           Begin


              ed := TxtEdit(Self.FindComponent('ed' + AField.Name));
              if ed = nil then
               Begin
                  ed := TxtEdit.Create(self);
                  ed.Parent := self;
        //          ed.Align := TAlignLayout.HorzCenter;
        //          ed.Position.X := 300;

                  ed.Name := 'ed' + AField.Name;
                  ed.top := round(self.CurrentPos);
                  ed.Width := 300;
                  lbl.Height := ed.Height;
                  ed.TabOrder := Self.currentTabOrder;
                  ed.Left := lbl.Width; //(self.Width - ed.Width)/2;
                  if LdisplayLabel.StartsWith('#') then
                   Begin
                     ed.PasswordChar := '#'; // Password := true;
                     btnShowPw := TButton.Create(Self);
                     btnShowPw.Parent := ed;
                     btnShowPw.Align  := TAlign.alRight;
                     btnShowPw.Width  := 30;
                     btnShowPw.OnClick := clickShowHidePassword;
                     btnShowPw.caption    := '...';

                    // btnShowPw.StyleLookup := 'detailstoolbutton';
                     btnShowPw.Images      := ImageList;
                     btnShowPw.ImageIndex := PasswordImageIndex;
                   End;

                  ed.TextHint := lbl.Caption;
                  self.CurrentPos := self.CurrentPos + 40;
                  ed.TagString := AField.Name;
                  ed.TagObject := lbl;
                  ed.OnChange := onEditChange;
                  self.Height := self.Height + 45;
               End;

              ed.Text := AField.GetValue(@ARecord).ToString;
          End;



        End;
      End
    end, DisplayLabels);

    self.CurrentPos := self.CurrentPos + 40;
    self.Height := self.Height + 100;

end;

procedure TRecordEditorPanel<T>.Setdata(const Value: T);
begin
  Fdata := Value;
  refreshFields;
end;

{ TxtEdit }

constructor TxtEdit.Create(AOwner: TComponent);
begin
  tagObject := nil;
  TagString := '';
  inherited;
end;

{ TRcdEditor<T> }

class procedure TRcdEditor<T>.ForEachField(var ARecord: T;
  const AProc: TWriteRecordFieldProc; ADisplayLabels: Tarray<string>);
var
  LType: TRttiType;
  LField: TRttiField;
  LStop: Boolean;
  LdisplayLabel: string;
  Lidx : Integer;
  LDisplayLabelLength: Integer;
begin
  if Assigned(AProc) then
  begin
    LStop := False;
    Lidx  := 0;

    LType := TRttiContext.Create.GetType(TypeInfo(T));
    LDisplayLabelLength := Length(ADisplayLabels);


    for LField in GetVisibleFields(LType) do
    begin
      LdisplayLabel := '';
      if LDisplayLabelLength > Lidx then
        LdisplayLabel := ADisplayLabels[Lidx];


      AProc(ARecord, LField, LStop,LdisplayLabel);
      Lidx := Lidx +1;
      if LStop then
        Break;
    end;
  end;
end;

class function TRcdEditor<T>.getFieldValue(var ARecord: T;
  const FieldName: String): TValue;
var
  LType: TRttiType;
begin
 LType  := TRttiContext.Create.GetType(TypeInfo(T));
 Result := LType.GetField(FieldName).GetValue(@ARecord);
end;

class function TRcdEditor<T>.GetVisibleFields(
  const AType: TRttiType): TArray<TRttiField>;
begin
//    Result := TMtArray.Filter<TRttiField>(AType.GetFields,
//    function (var AField: TRttiField): Boolean
//    begin
//      Result := not AField.Name.StartsWith('_');
//    end);
  Result := AType.GetFields;
end;

class procedure TRcdEditor<T>.setFieldValue(var ARecord: T;
  const FieldName: String; AValue: String);
var
  LType: TRttiType;
  LValue : TValue;
  LTypeKind : System.TTypeKind;
  LField : TRttiField;
begin
 if FieldName = '' then exit;


 LType := TRttiContext.Create.GetType(TypeInfo(T));

 LField := LType.GetField(FieldName);

 if LField = nil then exit;


 LTypeKind := LField.FieldType.TypeKind;

 case LTypeKind of
        tkInteger:LField.SetValue(@ARecord,AValue.ToInteger);
        tkChar:LField.SetValue(@ARecord,AValue);
        tkEnumeration:Begin

           LField.SetValue(@ARecord,TValue.FromOrdinal(LField.FieldType.Handle, GetEnumValue(LField.FieldType.Handle, AValue)));
//           LField.SetValue(@ARecord,TRttiEnumerationType.GetValue<LField.FieldType>(AValue));
        End;
        tkFloat:LField.SetValue(@ARecord,AValue.ToExtended);
        tkString:LField.SetValue(@ARecord,AValue);
//        tkSet:;
//        tkClass:;
//        tkMethod:;
//        tkWChar:;
//        tkLString:;
//        tkWString:;
//        tkVariant:;
//        tkArray:;
//        tkRecord:;
//        tkInterface:;
        tkInt64:LField.SetValue(@ARecord,AValue.ToInt64);
//        tkDynArray:;
        tkUString: LField.SetValue(@ARecord,AValue);
//        tkClassRef:;
//        tkPointer:;
//        tkProcedure:;
//        tkMRecord:;
 end;



end;

{ TxtToggleSwitch }

constructor TxtToggleSwitch.Create(AOwner: TComponent);
begin
  TagString := '';
  tagObject := nil;
  inherited;

end;

end.
