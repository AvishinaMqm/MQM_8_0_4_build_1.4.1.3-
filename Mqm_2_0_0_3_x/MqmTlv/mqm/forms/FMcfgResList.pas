unit FMcfgResList;

interface

uses
  cxButtons, Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls,
 // TeeProcs, TeEngine, Chart,
  ComCtrls, StdCtrls, Grids , UMglobal, UMBinDefault,
  UMRes,
  Buttons, Menus, CheckLst, UMbinFunc, gnugettext, UReShape;

type
  TFConfigResList = class(TForm)
    GrbResList: TGroupBox;
    StrGrdResList: TStringGrid;
    BtnOk: TcxButton;
    BtnAbort: TcxButton;
    BtnResetList: TcxButton;
    Panel1: TPanel;
    procedure BtnAbortClick(Sender: TObject);
    procedure BtnOkClick(Sender: TObject);
    procedure BtnResetListClick(Sender: TObject);
    procedure StrGrdResListMouseDown(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    procedure StrGrdResListMouseUp(Sender: TObject; Button: TMouseButton;
      Shift: TShiftState; X, Y: Integer);
    function GetResList : TList;
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure FormDestroy(Sender: TObject);
  private
    m_ResList : TList;
//    m_ListModified : boolean;
    procedure m_InitGrid;
    procedure m_InitResList(ResList : TList);
  public
    constructor CreateCfgResList(AOwner : TComponent ; ResList: TList);
  end;

var
  FConfigResList: TFConfigResList;

implementation

uses
  UMBinTbs,
  UMbinGrid,
  UMSchedContFunc,
  UMCompat,
  UGglobal,
  UMPlan,
  UMObjCont,
  FMbin, UMPlanObj;

 {$R *.DFM}

//----------------------------------------------------------------------------//
// Constructor for TFConfigResList that prepares resources for display        //
//----------------------------------------------------------------------------//

constructor TFConfigResList.CreateCfgResList(AOwner: TComponent; ResList: TList);
begin
  inherited Create(AOwner);
  TranslateComponent(self);
  ScaleFormSize(Self, Screen.PixelsPerInch);
  GrbResList.Caption     := _('Resource List');
  BtnOk.Caption          := _('OK');
  BtnAbort.Caption       := _('Abort');
  m_InitResList(ResList);
//  m_ResList              := ResList;
  StrGrdResList.RowCount := m_ResList.Count;
  m_InitGrid;
  //StrGrdResList.ColWidths[0] := 70;
 // StrGrdResList.ColWidths[1] := 182;
  FConfigResList := self;
  ReShape(self)
end;

//----------------------------------------------------------------------------//

procedure TFConfigResList.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  StrGrdResList.ColCount := 0;
  StrGrdResList.RowCount := 0;
end;

//----------------------------------------------------------------------------//

procedure TFConfigResList.BtnAbortClick(Sender: TObject);
begin
  ModalResult := mrAbort;
  FConfigResList.Close;
end;

//----------------------------------------------------------------------------//

procedure TFConfigResList.BtnOkClick(Sender: TObject);
var
  i, j: Integer;
  resFound: boolean;
  tempList: TList;
begin
  tempList := TList.Create;
  if (StrGrdResList.RowCount > 0) then
  begin
    ModalResult := mrOk;
    for i := 0 to StrGrdResList.RowCount - 1 do
    begin
      resFound := false;
      j := 0;
      while (not resFound) and (j < m_ResList.Count) do
      begin
        resFound := StrGrdResList.Cells[0, i] = TMqmRes(m_ResList[J]).p_ResCode;
        Inc(j);
      end;
      if resFound then
        tempList.Add(TMqmRes(m_ResList[j-1]));
    end;
    m_ResList.Clear;
    for i := 0 to tempList.Count - 1 do
      m_ResList.Add(TMqmObj(TMqmRes(tempList[i])));
    tempList.Clear;
  end
  else
    ModalResult := mrAbort;
  tempList.Free;
end;

//----------------------------------------------------------------------------//

procedure TFConfigResList.BtnResetListClick(Sender: TObject);
begin
  m_InitGrid;
end;

//----------------------------------------------------------------------------//

procedure TFConfigResList.StrGrdResListMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Screen.Cursor := crDrag;
end;

//----------------------------------------------------------------------------//

procedure TFConfigResList.StrGrdResListMouseUp(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  Screen.Cursor := crDefault;
end;

//----------------------------------------------------------------------------//

procedure TFConfigResList.m_InitGrid;
var
  i,w,z: Integer;
  res : TMqmRes;
begin
  w := 0;
  z := 0;
  for i := 0 to m_ResList.Count - 1 do
  begin
    res := TMqmRes(m_ResList[I]);

    if Length(Res.p_ResCode) > w then
      w := Length(Res.p_ResCode);

    if Length(Res.p_ResSDesc) > z then
      z := Length(Res.p_ResSDesc);

    StrGrdResList.Cells[0, i] := Res.p_ResCode;
    StrGrdResList.Cells[1, i] := Res.p_ResSDesc;
  end;

  StrGrdResList.ColWidths[0] := w*10;
  StrGrdResList.ColWidths[1] := z*10;
end;

//----------------------------------------------------------------------------//

procedure TFConfigResList.m_InitResList(ResList : TList);
var
  I : Integer;
begin
  m_ResList := TList.Create;
  for I := 0 to ResList.Count - 1 do
    m_ResList.Add(TMqmRes(ResList[I]));
end;

//----------------------------------------------------------------------------//

function TFConfigResList.GetResList: TList;
var
  i: Integer;
  mqmObj: TMqmObj;
begin
  Result := TList.Create;
  for i := 0 to m_ResList.Count - 1 do
  begin
    mqmObj := p_pl.FindResByCode(TMqmRes(m_ResList[I]).p_ResCode);
    Result.Add(mqmObj);
  end;
end;

//----------------------------------------------------------------------------//

procedure TFConfigResList.FormDestroy(Sender: TObject);
begin
  if assigned(m_ResList) then
    m_ResList.Free;
end;

end.

