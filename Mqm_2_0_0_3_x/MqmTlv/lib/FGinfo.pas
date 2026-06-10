unit FGinfo;

interface

uses
  cxButtons, Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls, Buttons, ToolWin, ComCtrls, UReShape;

type

  TInfoType = (titNone,    // no information for the line type available
               titDbErr,   // problems in db consistency
               titIntlErr, // internal consistency error
               titInfo);   // just for information

  TInfoForm = class(TForm)
    InfoMemo: TMemo;
    PrintDialog: TPrintDialog;
    NoteBar: TToolBar;
    SpeedFore: TSpeedButton;
    SpeedClear: TSpeedButton;
    SpeedPrint: TSpeedButton;
    ToolButton1: TToolButton;
    Button1: TcxButton;
    procedure SpeedClearClick(Sender: TObject);
    procedure SpeedPrintClick(Sender: TObject);
    procedure SpeedForeClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure btnSendReportClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
    m_count:  integer;
  public
    procedure AddLine(tType: TInfoType; s: string);
    procedure AddLines(sl: TStrings);
  end;

  procedure ShowStringsInInfoForm(AOwner: TComponent; str: TStringList);
  procedure CreateInfoForm(AOwner: TComponent);
  procedure DestroyInfoForm;
  procedure ShowInfoForm(ShowRepSend : boolean);
  procedure AddInfo(tType: TInfoType; s: string);
  procedure CleanLog;
  function  IsInfoEmpty : boolean;

implementation

{$R *.DFM}

uses
  gnugettext,
  Printers,
  FMShowMaterials,
  UMSchedContFunc;

var
  InfoForm: TInfoForm;

// -------------------------------------------------------------------------- //

procedure ShowStringsInInfoForm(AOwner: TComponent; str: TStringList);
var
  info: TInfoForm;
begin
  info := TInfoForm.Create(AOwner);
  info.AddLines(str);
  info.ShowModal;
  info.Free;


end;

// -------------------------------------------------------------------------- //

procedure CreateInfoForm(AOwner: TComponent);
begin
  Assert(not Assigned(InfoForm));
  InfoForm := TInfoForm.Create(AOwner)
end;

// -------------------------------------------------------------------------- //

procedure DestroyInfoForm;
begin
  if Assigned(InfoForm) then
  begin
    InfoForm.Free;
    InfoForm := nil
  end
end;

// -------------------------------------------------------------------------- //

procedure ShowInfoForm(ShowRepSend : boolean);
begin
  Assert(Assigned(InfoForm));
  if ShowRepSend then
    InfoForm.btnSendReportClick(nil);
  InfoForm.ShowModal
end;

// -------------------------------------------------------------------------- //

procedure AddInfo(tType: TInfoType; s: string);
begin
  if Assigned(InfoForm) then InfoForm.AddLine(tType, s)
end;

// -------------------------------------------------------------------------- //

procedure CleanLog;
begin
  InfoForm.InfoMemo.Clear;
  InfoForm.m_count := 0;
end;

// -------------------------------------------------------------------------- //

function IsInfoEmpty : boolean;
begin
  // Return if Info Form is empty or not
  if InfoForm.InfoMemo.Lines.Count > 0 then
    Result := False
  else Result := True;
end;

// -------------------------------------------------------------------------- //

procedure TInfoForm.FormCreate(Sender: TObject);
begin
  TranslateComponent (self);
  m_count := 0;

{$ifndef DEVELOP}
  Button1.Visible := false;
{$endif}

  ReShape(Self);

end;

// -------------------------------------------------------------------------- //

procedure TInfoForm.AddLine(tType: TInfoType; s: string);
begin
  if tType = titNone then
    InfoMemo.Lines.Add(Format('        %s', [s]))
  else
  begin
    Inc(m_count);
    InfoMemo.Lines.Add(Format('%3d) %s', [m_count, s]))
  end
end;

// -------------------------------------------------------------------------- //

procedure TInfoForm.AddLines(sl: TStrings);
var
  i: integer;
begin
  for i := 0 to sl.Count-1 do
  begin
    Inc(m_count);
    InfoMemo.Lines.Add(Format('%3d) %s', [m_count, sl[i]]))
  end;
end;

// -------------------------------------------------------------------------- //

procedure TInfoForm.SpeedClearClick(Sender: TObject);
begin
  InfoMemo.Clear
end;

// -------------------------------------------------------------------------- //

procedure TInfoForm.SpeedPrintClick(Sender: TObject);
var
  Line:      integer;
  PrintText: TextFile;
begin
  if PrintDialog.Execute then
  begin
    AssignPrn(PrintText);	// associate text file to printer device
    Rewrite(PrintText);	  // create and open output file
    try
      for Line := 0 to InfoMemo.Lines.Count - 1 do
        Writeln(PrintText, InfoMemo.Lines[Line])
    finally
      CloseFile(PrintText)
    end
  end
end;

// -------------------------------------------------------------------------- //

procedure TInfoForm.SpeedForeClick(Sender: TObject);
begin
  if FormStyle = fsStayOnTop then
    FormStyle := fsNormal
  else
    FormStyle := fsStayOnTop
end;

// -------------------------------------------------------------------------- //

procedure TInfoForm.btnSendReportClick(Sender: TObject);
begin
{ // MARIO
  if FileExists(AppGlobals.AppDir + '\ReportSendLog.txt') then
  begin
    InfoMemo.Lines.Clear;
    InfoMemo.Lines.LoadFromFile(AppGlobals.AppDir + '\ReportSendLog.txt');
  end;
}
end;

// -------------------------------------------------------------------------- //

procedure TInfoForm.Button1Click(Sender: TObject);
var
  FrmMat: TFShowMaterials;
begin
  FrmMat := TFShowMaterials.CreateFrmShowMat(self, CSchedIDnull, nil, nil, nil, nil, nil);
  FrmMat.ShowModal;
  FrmMat.Free;
end;

// -------------------------------------------------------------------------- //

initialization

  InfoForm := nil;
  CreateInfoForm(nil)

// -------------------------------------------------------------------------- //

finalization

  DestroyInfoForm

// -------------------------------------------------------------------------- //
end.
