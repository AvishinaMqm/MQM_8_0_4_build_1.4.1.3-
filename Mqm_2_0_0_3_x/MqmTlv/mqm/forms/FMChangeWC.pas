unit FMChangeWC;

interface

uses
  cxButtons, Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, UMSchedContFunc,
  StdCtrls, CheckLst, Buttons, UMWkCtr, UReShape, Vcl.ExtCtrls;

type
  TChangeWc = class(TForm)
    StaticWC: TStaticText;
    CBAltWc: TComboBox;
    StaticProcess: TStaticText;
    LabelWc: TLabel;
    LabelProcess: TLabel;
    Label1: TLabel;
    BitBtn1: TcxButton;
    BitBtn2: TcxButton;
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure BitBtn1Click(Sender: TObject);
    procedure BitBtn2Click(Sender: TObject);
  private
    m_ID : TSchedID;
    m_ListAlt : TList;
    procedure Clear;
    function  CheckData(var IsWcView : boolean) : TMqmWrkCtr;
    function  ChangeWorkCenter : boolean;
    procedure InitCaption;
    procedure GetAltWcProcess;
    { Private declarations }
  public
    constructor CreateChangeWcForm(AOwner : TComponent ; Id : TSchedID);
    { Public declarations }
  end;

implementation

uses UMObjCont, UGglobal , UMGlobal, UMSchedCont, gnugettext;

{$R *.DFM}

{ TChangeWc }

//----------------------------------------------------------------------------//

procedure TChangeWc.Clear;
var
  I : Integer;
begin
  for i := 0 to m_ListAlt.count-1 do
    Dispose(PAltWkcRec(m_ListAlt[i]));
  m_ListAlt.Clear;
end;

//----------------------------------------------------------------------------//

procedure TChangeWc.BitBtn2Click(Sender: TObject);
begin
  ModalResult := mrAbort;
  Close;
end;

function TChangeWc.ChangeWorkCenter;
var
  AltRec : PAltWkcRec;
  AltWcProcess : TWorkCenterInfo;
  IsWcView : boolean;
  Wc       : TMqmWrkCtr;
  Id :     TSchedId;
  I : Integer;
begin
  Result := false;
  IsWcView := false;
  Wc := CheckData(IsWcView);
  if (Wc <> nil) then
  begin
    AltRec := PAltWkcRec(CBAltWc.items.Objects[CBAltWc.ItemIndex]);
    AltWcProcess.AlterWorkCenter := AltRec.AltWorkCenter;
    AltWcProcess.AlterProcess := AltRec.AltProcess;

    if p_sc.IsGroup(m_ID) then
    begin
      for i := 0 to p_sc.GetGrpNumSons(m_ID) - 1 do
      begin
        ID := p_sc.GetGrpSon(m_ID, i);
        p_sc.SetWcProcessAlternative(ID, wc, AltWcProcess, IsWcView);
        Result := true;
      end
    end
    else
    begin
      p_sc.SetWcProcessAlternative(m_ID, wc, AltWcProcess, IsWcView);
      Result := true;
    end;
  end
end;

//----------------------------------------------------------------------------//

constructor TChangeWc.CreateChangeWcForm(AOwner: TComponent ;Id : TSchedID);
begin
  inherited Create(AOwner);
  m_ID := Id;
  m_ListAlt := TList.Create;

  ReShape(Self);
//  ReShape(BitBtn1);
//  ReShape(BitBtn2);
end;

//----------------------------------------------------------------------------//

procedure TChangeWc.FormCreate(Sender: TObject);
begin
  InitCaption;
  GetAltWcProcess;
end;

//----------------------------------------------------------------------------//

procedure TChangeWc.GetAltWcProcess;
var
  I : Integer;
  AltRec : PAltWkcRec;
begin
  Clear;
  p_pl.FindAltWcByCode(p_sc.GetFldDescr(m_id, CSC_WkctCode, false), p_sc.GetFldDescr(m_id, CSC_WkctProc, false), m_ListAlt);
  if m_ListAlt.count > 0 then
  begin
    for I := 0 to m_ListAlt.Count -1 do
    begin
      AltRec := PAltWkcRec(m_ListAlt[I]);
      CBAltWc.Items.Add(_('Work center') + ': ' + AltRec.AltWorkCenter + '    ' +
                        _('Process') + ': ' + AltRec.AltProcess + '    ' +
                        _('Managing station') + ': ' + AltRec.WStation);


//      CBAltWc.Items.Add('Work center :'  + AltRec.AltWorkCenterDesc + ' Process :'
//                        + AltRec.AltProcessDesc + ' Station : ' + AltRec.WStation);
      CBAltWc.items.Objects[I] := TObject(AltRec);
    end;
  end
end;

//----------------------------------------------------------------------------//

procedure TChangeWc.InitCaption;
var
  WC : TMqmWrkCtr;
begin
  SetComponent(StaticWC, comp_Descr, false);
  StaticWC.Width := 90;
  StaticProcess.Width := 90;
  SetComponent(StaticProcess, comp_Descr, false);
  Self.Caption := _('Change work center');
  WC := TMqmWrkCtr(p_sc.GetWrkCtrPtr(m_id));
//  WC := TMqmWrkCtr(p_pl.FindWrkCtrByCode(p_sc.GetFldDescr(m_id, CSC_WkctCode)));
  StaticWC.Caption := WC.p_WrkCtrSDesc;
  StaticProcess.Caption := WC.GetProcDesc(p_sc.GetFldDescr(m_id, CSC_WkctProc, false));
end;

//----------------------------------------------------------------------------//

procedure TChangeWc.FormDestroy(Sender: TObject);
begin
  Clear;
  m_ListAlt.free;
end;

//----------------------------------------------------------------------------//

procedure TChangeWc.BitBtn1Click(Sender: TObject);
begin
  if not ChangeWorkCenter then
    ModalResult := mrNone
  else
    ModalResult := mrOk;
end;

//----------------------------------------------------------------------------//

function TChangeWc.CheckData(var IsWcView : boolean): TMqmWrkCtr;
var
  AltRec : PAltWkcRec;
  WC     : TMqmWrkCtr;
begin
  Result := nil;
  if (CBAltWc.Items.Count = 0) then
  begin
    Showmessage(_('No alternative work centers available'));
  end
  else if (CBAltWc.ItemIndex = -1) then
  begin
    Showmessage(_('Please choose an alternative work center'));
  end
  else
  begin
    AltRec := PAltWkcRec(CBAltWc.items.Objects[CBAltWc.ItemIndex]);
    WC := TMqmWrkCtr(p_pl.FindWrkCtrByCode(AltRec.AltWorkCenter));
    if (WC = nil) then
    begin
      MessageDlg(_('Work center was not defined'), mtWarning, [mbOk], 0);
      Exit;
    end
    else
    begin
      IsWcView := wc.p_ReadOnly;
      Result := WC
    end;

    if (AltRec.WStation <> IniAppGlobals.WkstCode) then
    begin
      if MessageDlg(_('This job will belong to another work station, are you sure ? ')
                    , mtConfirmation, [mbYes, mbNo], 0) = IDNO then
        Result := nil;
    end
  end;

end;

end.
