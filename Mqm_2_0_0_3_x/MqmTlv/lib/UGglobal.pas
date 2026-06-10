unit UGglobal;

interface

uses
  controls,
  stdctrls,
  sysutils,
  graphics,
  forms,
  cxTextEdit;

type

  TCompType  = (comp_Label, comp_Edit, comp_Descr, comp_AS400);

  procedure SetComponent(Obj: TControl; CompTyp: TCompType; Enab: boolean);
  procedure ScaleFormSize(Form: TForm; FormPixelPerInch: integer);
  
const

  DescrBkgr        : TColor = ($00E1E1E1);//($00DDFFFD);   // clInfoBk
  AS400Txt         : TColor = (clNavy);
  EditEnabledBkgr  : TColor = (clWhite);
  EditDisabledBkgr : TColor = ($00E1E1E1);   // very light grey
  DEFAULT_DPI      : integer = 96;
implementation

uses
  windows;

//----------------------------------------------------------------------------//

procedure SetComponent(Obj: TControl; CompTyp: TCompType; Enab: boolean);
begin
  case CompTyp of
    comp_Label:
      if (obj is TLabel) then
      begin
        with TLabel(obj) do
        begin
          AutoSize := true;
        end
      end;

    comp_AS400:
      if (obj is TLabel) then
      begin
        with TLabel(obj) do
        begin
          AutoSize := true;
          Font.Color := AS400Txt;
          Font.Style := [fsBold];
        end
      end;

    comp_Descr:
    begin
      if (obj is TStaticText) then
      begin
        with TStaticText(obj) do
          begin
          BorderStyle := sbsSunken;
          AutoSize := false;
          Color := DescrBkgr;
          end
      end else

      if (obj is TcxTextEdit) then
      begin
        with TcxTextEdit(obj) do
          begin
          AutoSize := false;
          Properties.Readonly := True;
          end
      end;
    if (obj is TMemo) then
      begin
        with TMemo(obj) do
        begin
          Color := DescrBkgr;
          ReadOnly := true;
        end
      end;
    end;
    comp_Edit:
      with TEdit(obj) do
      begin
        if enab then
        begin
          Enabled := true;
          Color := EditEnabledBkgr
        end else
        begin
          Enabled := false;
          Color := EditDisabledBkgr
        end
      end;

  end;
end;

//----------------------------------------------------------------------------//

procedure ScaleFormSize(Form: TForm; FormPixelPerInch: integer);
var
  i: integer;
begin
  //Form.Width  := Form.width * FormPixelPerInch div DEFAULT_DPI;
  //Form.Height := Form.Height * FormPixelPerInch div DEFAULT_DPI;

  for i := Form.ControlCount - 1 downto 0 do
  begin
    Form.Controls[i].Left   := Form.Controls[i].Left   * FormPixelPerInch div DEFAULT_DPI;
    Form.Controls[i].Top    := Form.Controls[i].Top    * FormPixelPerInch div DEFAULT_DPI;
    Form.Controls[i].Width  := Form.Controls[i].width  * FormPixelPerInch div DEFAULT_DPI;
    Form.Controls[i].Height := Form.Controls[i].Height * FormPixelPerInch div DEFAULT_DPI;
  end;

end;

end.
