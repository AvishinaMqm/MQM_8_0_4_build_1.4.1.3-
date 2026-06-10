unit FMAutoSchedWorkCenterCfg;

interface

uses
  cxButtons, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, UMAutoSchedCfg, UMSchedContFunc, UReShape,
  Vcl.ExtCtrls;

type

  SlotDuration = (SL_Daily, SL_Weekly, SL_MONTHLY);

  TWorkcenterCfg = Record
    WorkCenterCode : string;
    AutoSchedCfg   : string;
    SlotDur        : SlotDuration;
  end;
  PTWorkcenterCfg = ^TWorkcenterCfg;

  TFAutoSchedWcCfg = class(TForm)
    GroupBox3: TGroupBox;
    LblAutoSchedCfg: TLabel;
    SB_Frames: TScrollBox;
    LblWorkCnter: TLabel;
    Label1: TLabel;
    BitBtn1: TcxButton;
    BitAbort: TcxButton;
    procedure BitBtn1Click(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure BitAbortClick(Sender: TObject);
  private
    m_ArryFrame : Array of TFrame;
    m_ListWcCode : TStringList;

    procedure initialComponnents;
    procedure FillDataToFrames;
    procedure SaveDataToDb;
    { Private declarations }
  public
    constructor CreateAutoSchedWcCfg(AOwner: Tcomponent);
    procedure   createNewFrame(var BaseFrame: Tframe; Index: Integer; WorkCenterDesc : string);
  end;

  procedure LoadFromDBSchedWcCfg;
  function  CheckCfgDefinitionForAllWorkCenters : boolean;
  function  GetCfgByWorkCenter(PlannedWc : string; StartDate : TDateTime; var SlotStart : TDateTime; var SlotEnd : TDateTime) : PTAutoSchedCfg;
  function ChangeAutoSeqConfigurationByWorkCenter(Id : TSchedId; StartDate : TDateTime; var SlotStart : TDateTime; var SlotEnd : TDateTime) : PTAutoSchedCfg;

const

DEFAULT_DPI : integer = 96;

implementation

uses UMWkCtr, UMObjCont, UGglobal, UGSlotCal, gnugettext, DMsrvPc, UMTblDesc, UMglobal, UMCommon;

{$R *.dfm}

var
  m_ListWcCfg : TList;

{ TFAutoSchedWcCfg }

procedure TFAutoSchedWcCfg.BitBtn1Click(Sender: TObject);
begin
  SaveDataToDb;
  Close;
end;

//----------------------------------------------------------------------------//

procedure TFAutoSchedWcCfg.BitAbortClick(Sender: TObject);
begin
  Close;
end;

constructor TFAutoSchedWcCfg.CreateAutoSchedWcCfg(AOwner: Tcomponent);
begin
  inherited create(AOwner);
  LoadFromDBSchedWcCfg;
  initialComponnents;
  FillDataToFrames;

  ReSHape(Self);
//  ReShape(BitBtn1);
//  ReShape(BitAbort);
end;

//----------------------------------------------------------------------------//

procedure TFAutoSchedWcCfg.initialComponnents;
var
  WC : TMqmWrkCtr;
  I : Integer;
  ListWcDesc : TStringList;
begin
  m_ListWcCode := TStringList.Create;
  ListWcDesc := TStringList.Create;
  for i := 0 to p_pl.p_WrkCtrsCount - 1 do
  begin
    WC := TMqmWrkCtr(p_pl.p_WrkCtr[i]);
    if (WC.p_ReadOnly) then
       Continue;
    m_ListWcCode.Add(WC.p_WrkCtrCode);
    ListWcDesc.Add(WC.p_WrkCtrLDesc);
  end;

  SetLength(m_ArryFrame, m_ListWcCode.Count);

  for I := 0 to m_ListWcCode.Count - 1 do
  begin
    createNewFrame(m_ArryFrame[I], I, ListWcDesc.Strings[I]);
    m_ArryFrame[I].parent := SB_Frames;
    m_ArryFrame[I].left:= -3;
    m_ArryFrame[I].top:= I * 30;
    m_ArryFrame[I].name := 'Frm' + IntToStr(I);
  end;
  FillDataToFrames;
  ListWcDesc.Free;
end;

//----------------------------------------------------------------------------//

procedure ClearWorkcenterCfgList;
var
  I : integer;
begin
  for I := m_ListWcCfg.Count - 1 downto 0 do
    dispose(PTWorkcenterCfg(m_ListWcCfg[I]));
  m_ListWcCfg.clear;
end;

//----------------------------------------------------------------------------//

procedure TFAutoSchedWcCfg.SaveDataToDb;
var
  I, J, W : Integer;
  ComboBoxCfg, ComboBoxSlotDur : TComboBox;
  WorkCnterCode : string;
  SqlInsert, SqlDelete : string;
  WorkcenterCfg : PTWorkcenterCfg;
  qry    : TMqmQuery;
  tbInfo: ^TTblInfo;
begin
  qry := CreateQuery(Cfg_DB);
  Qry.Transaction := CreateTransaction(Cfg_DB);
  Qry.Transaction.StartTransaction;

  tbInfo := @tblInfo[tbl_cfg_AutoSchedWorkCenter];
  ClearWorkcenterCfgList;

  qry.SQL.Clear;
  SqlDelete := 'delete from ' + tbInfo.GetTableName;
  SqlDelete := SqlDelete + ' where ' + CreateFld(tbInfo.pfx, fli_wkstCode) + '=''' + IniAppGlobals.WkstCode + '''';
  SqlDelete := SqlDelete + AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_identifier));
  qry.SQL.Text := SqlDelete;
  qry.ExecSQL;

  SqlInsert := SqlInsert + 'insert into ' + tbInfo.GetTableName + '(';
  SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_IDENTIFIER) + ',';
  SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_wkstCode) + ',';
  SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_wkCtrCode) + ',';
  SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_CfgName) + ',';
  SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_StandardSlotDuration);
  SqlInsert := SqlInsert + ') values (';
  SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_IDENTIFIER) + ',';
  SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_wkstCode) + ',';
  SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_wkCtrCode) + ',';
  SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_CfgName) + ',';
  SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_StandardSlotDuration);
  SqlInsert := SqlInsert + ')';
  qry.sql.Text  := SqlInsert;

  for J := 0 to m_ListWcCode.Count - 1 do
  begin
    WorkCnterCode := m_ListWcCode.Strings[J];
    ComboBoxCfg := TComboBox(m_ArryFrame[J].Components[1]);
    ComboBoxSlotDur := TComboBox(m_ArryFrame[J].Components[2]);
    qry.ParamByName(CreateFld(tbInfo.pfx,fli_IDENTIFIER)).AsString        := IniAppGlobals.Identifier;
    qry.ParamByName(CreateFld(tbInfo.pfx,fli_wkstCode)).AsString          := IniAppGlobals.WkstCode;
    qry.ParamByName(CreateFld(tbInfo.pfx,fli_wkCtrCode)).AsString         := WorkCnterCode;

    qry.ParamByName(CreateFld(tbInfo.pfx,fli_CfgName)).AsString := ComboBoxCfg.Items.Strings[ComboBoxCfg.ItemIndex];
    case ComboBoxSlotDur.ItemIndex of
      0 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_StandardSlotDuration)).AsString := '1';
      1 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_StandardSlotDuration)).AsString := '2';
      2 : qry.ParamByName(CreateFld(tbInfo.pfx,fli_StandardSlotDuration)).AsString := '3';
      else
        qry.ParamByName(CreateFld(tbInfo.pfx,fli_StandardSlotDuration)).AsString := '1';
    end;
    qry.ExecSQL;

    new(WorkcenterCfg);
    WorkcenterCfg.WorkCenterCode := WorkCnterCode;
    WorkcenterCfg.AutoSchedCfg   := ComboBoxCfg.Items.Strings[ComboBoxCfg.ItemIndex];
    case ComboBoxSlotDur.ItemIndex of
      0 : WorkcenterCfg.SlotDur := SL_Daily;
      1 : WorkcenterCfg.SlotDur := SL_Weekly;
      2 : WorkcenterCfg.SlotDur := SL_MONTHLY;
      else
        WorkcenterCfg.SlotDur := SL_Daily;
    end;
    m_ListWcCfg.Add(WorkcenterCfg)

  end;

  Qry.Transaction.Commit;
  Qry.Free

end;

//----------------------------------------------------------------------------//

procedure TFAutoSchedWcCfg.FillDataToFrames;
var
  I, J, W : Integer;
  WorkcenterCfg : PTWorkcenterCfg;
  WorkCnterCode : string;
  ComboBoxCfg, ComboBoxSlotDur : TComboBox;
begin
  for I := 0 to m_ListWcCfg.Count - 1 do
  begin
    WorkCnterCode := PTWorkcenterCfg(m_ListWcCfg[I]).WorkCenterCode;
    for J := 0 to m_ListWcCode.Count - 1 do
    begin
      if not (m_ListWcCode.Strings[J] = WorkCnterCode) then continue;
      ComboBoxCfg := TComboBox(m_ArryFrame[J].Components[1]);
      for W := 0 to ComboBoxCfg.Items.Count - 1 do
      begin
        if ComboBoxCfg.Items.Strings[W] = PTWorkcenterCfg(m_ListWcCfg[I]).AutoSchedCfg then
        begin
          ComboBoxCfg.ItemIndex := W;
          break
        end;
      end;

      ComboBoxSlotDur := TComboBox(m_ArryFrame[J].Components[2]);
      if PTWorkcenterCfg(m_ListWcCfg[I]).SlotDur = SL_Daily then
         ComboBoxSlotDur.ItemIndex := 0
      else if PTWorkcenterCfg(m_ListWcCfg[I]).SlotDur = SL_Weekly then
         ComboBoxSlotDur.ItemIndex := 1
      else if PTWorkcenterCfg(m_ListWcCfg[I]).SlotDur = SL_MONTHLY then
         ComboBoxSlotDur.ItemIndex := 2;
      break;
    end;
  end;

end;

//----------------------------------------------------------------------------//

procedure TFAutoSchedWcCfg.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  m_ListWcCode.Free;
  Action := caFree
end;

//----------------------------------------------------------------------------//

procedure TFAutoSchedWcCfg.createNewFrame(var BaseFrame: Tframe; Index: Integer; WorkCenterDesc : string);
var
  CombBoxCfg, CombBoxSlotDur : TComboBox;
  StaticTextWc : TStaticText;
  Edit_Heading: TEdit;
  Edit_From: TEdit;
  Edit_To: TEdit;
  I : Integer;
  Cfg: PTAutoSchedCfg;
begin
  BaseFrame := TFrame.Create(self);
  BaseFrame.parent := self;
  BaseFrame.Width := 415 * Screen.PixelsPerInch div DEFAULT_DPI;
  BaseFrame.Height := 31 * Screen.PixelsPerInch div DEFAULT_DPI;
  BaseFrame.TabOrder := 0;

  StaticTextWc := TStaticText.Create(BaseFrame);
  SetComponent(StaticTextWc, comp_Descr, false);
  StaticTextWc.Parent := BaseFrame;
  StaticTextWc.Left := 8 * Screen.PixelsPerInch div DEFAULT_DPI;
  StaticTextWc.Top := 8 * Screen.PixelsPerInch div DEFAULT_DPI;
  StaticTextWc.Width := 115 * Screen.PixelsPerInch div DEFAULT_DPI;
  StaticTextWc.Height := 17 * Screen.PixelsPerInch div DEFAULT_DPI;
  StaticTextWc.Caption := WorkCenterDesc;
  StaticTextWc.Name := 'StaticTextWc' + inttostr(index);

  CombBoxCfg := TComboBox.Create(BaseFrame);
  CombBoxCfg.Parent := BaseFrame;
  CombBoxCfg.Left := 139 * Screen.PixelsPerInch div DEFAULT_DPI;
  CombBoxCfg.Top := 8 * Screen.PixelsPerInch div DEFAULT_DPI;
  CombBoxCfg.Width := 115 * Screen.PixelsPerInch div DEFAULT_DPI;
  CombBoxCfg.Height := 21 * Screen.PixelsPerInch div DEFAULT_DPI;
  CombBoxCfg.Style := csDropDownList;
  CombBoxCfg.Name   := 'CombBoxCfg' + inttostr(index);
  CombBoxCfg.Text := '';
  CombBoxCfg.Color := $00E1E1E1;

  for i := 0 to AutoSchedCfgList.Count - 1 do
  begin
    Cfg := AutoSchedCfgList[i];
    CombBoxCfg.Items.Add(Cfg.m_CfgName);
  end;
  CombBoxCfg.ItemIndex := 0;

  CombBoxSlotDur := TComboBox.Create(BaseFrame);
  CombBoxSlotDur.Parent := BaseFrame;
  CombBoxSlotDur.Left := 148 + 148 * Screen.PixelsPerInch div DEFAULT_DPI;
  CombBoxSlotDur.Top := 8 * Screen.PixelsPerInch div DEFAULT_DPI;
  CombBoxSlotDur.Width := 115 * Screen.PixelsPerInch div DEFAULT_DPI;
  CombBoxSlotDur.Height := 21 * Screen.PixelsPerInch div DEFAULT_DPI;
  CombBoxSlotDur.Style := csDropDownList;
  CombBoxSlotDur.Name   := 'CombBoxSlotDur' + inttostr(index);
  CombBoxSlotDur.Color := $00E1E1E1;

  CombBoxSlotDur.Text := '';
  CombBoxSlotDur.Items.Add(_('Daily'));
  CombBoxSlotDur.Items.Add(_('Weekly'));
  CombBoxSlotDur.Items.Add(_('Monthly'));
  CombBoxSlotDur.ItemIndex := 1;


end;

//----------------------------------------------------------------------------//

procedure LoadFromDBSchedWcCfg;
var
  WorkcenterCfg : PTWorkcenterCfg;
  sqlStr : string;
  qry    : TMqmQuery;
  tbInfo: ^TTblInfo;
begin
  if not assigned(m_ListWcCfg) then
    m_ListWcCfg := TList.Create
  else
    ClearWorkcenterCfgList;
  qry := CreateQuery(Cfg_DB);

  tbInfo := @tblInfo[tbl_cfg_AutoSchedWorkCenter];
  sqlStr := 'Select * from ' + tbInfo.GetTableName + ' where ' + CreateFld(tbInfo.pfx, fli_wkstCode) + '=''' + IniAppGlobals.WkstCode + '''' +
            AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_identifier));
  sqlStr := sqlStr + ' Order by ' + CreateFld(tbInfo.pfx, fli_wkCtrCode);

  qry.SQL.Clear;
  qry.SQL.Text := sqlStr;
  qry.open;

  while not Qry.Eof do
  begin
    new(WorkcenterCfg);
    WorkcenterCfg.WorkCenterCode := qry.FieldByName(CreateFld(tbInfo.pfx, fli_wkCtrCode)).AsString;
    WorkcenterCfg.AutoSchedCfg   := qry.FieldByName(CreateFld(tbInfo.pfx, fli_CfgName)).AsString;
    WorkcenterCfg.SlotDur        := SL_Daily;
    if qry.FieldByName(CreateFld(tbInfo.pfx, fli_StandardSlotDuration)).AsString = '1' then
      WorkcenterCfg.SlotDur        := SL_Daily
    else if qry.FieldByName(CreateFld(tbInfo.pfx, fli_StandardSlotDuration)).AsString = '2' then
      WorkcenterCfg.SlotDur        := SL_Weekly
    else if qry.FieldByName(CreateFld(tbInfo.pfx, fli_StandardSlotDuration)).AsString = '3' then
      WorkcenterCfg.SlotDur        := SL_MONTHLY;
    m_ListWcCfg.Add(WorkcenterCfg);
    qry.next
  end;
  qry.free
end;

//----------------------------------------------------------------------------//

function CheckCfgDefinitionForAllWorkCenters : boolean;
var
  I : Integer;
  ListWcStr : TStringList;
  WC : TMqmWrkCtr;
begin
  Result := false;
  if not Assigned(m_ListWcCfg) then
    LoadFromDBSchedWcCfg;

  ListWcStr := TStringList.Create;
  for i := 0 to p_pl.p_WrkCtrsCount - 1 do
  begin
    WC := TMqmWrkCtr(p_pl.p_WrkCtr[i]);
    if (WC.p_ReadOnly) then
       Continue;
    ListWcStr.Add(WC.p_WrkCtrCode);
  end;

  if m_ListWcCfg.Count <> ListWcStr.Count then
  begin
    ListWcStr.Free;
    exit
  end;

  Result := true;
  ListWcStr.Free;

end;

//----------------------------------------------------------------------------//

function GetCfgByWorkCenter(PlannedWc : string; StartDate : TDateTime; var SlotStart : TDateTime; var SlotEnd : TDateTime) : PTAutoSchedCfg;
var
  I : Integer;
  SlotScale : string;
begin
  Result := nil;
  if not Assigned(m_ListWcCfg) then
    LoadFromDBSchedWcCfg;

  for I := m_ListWcCfg.Count - 1 downto 0 do
  begin
    if PTWorkcenterCfg(m_ListWcCfg[I]).WorkCenterCode = PlannedWc then
    begin
      Result := GetAutoSchedCfg(PTWorkcenterCfg(m_ListWcCfg[I]).AutoSchedCfg);
      if PTWorkcenterCfg(m_ListWcCfg[I]).SlotDur = SL_Daily then
        SlotScale := 'CL_DAILY'
      else if PTWorkcenterCfg(m_ListWcCfg[I]).SlotDur = SL_Weekly then
        SlotScale := 'CL_WEEKLY'
      else
        SlotScale := 'CL_MONTHLY';
      GetSlotLimitDate(SlotScale, StartDate, SlotStart, SlotEnd);
      break;
    end;
  end;
end;

//*---------------------------------------------------------------------------------------

function ChangeAutoSeqConfigurationByWorkCenter(Id : TSchedId; StartDate : TDateTime; var SlotStart : TDateTime; var SlotEnd : TDateTime) : PTAutoSchedCfg;
var
  PlanedWorkCenter : variant;
  dataType: CBinColValType;
  CurrentSchedCfg : PTAutoSchedCfg;
begin
  p_sc.GetFldValue(id, CSC_PlanWkctCode, PlanedWorkCenter, dataType);
  CurrentSchedCfg := GetCfgByWorkCenter(PlanedWorkCenter, StartDate, SlotStart, SlotEnd);
  if CurrentSchedCfg <> nil then
  begin
    SetAutoSchedParams(CurrentSchedCfg, true);
    SetOverrideParams;
    result := AutoSchedCfg;
  end;
  AutoSchedCfg.m_PushToThePreferedDateMode := false;
  AutoSchedCfg.m_FindFirstFreeInifiniteCapacityResource := false;
end;

end.
