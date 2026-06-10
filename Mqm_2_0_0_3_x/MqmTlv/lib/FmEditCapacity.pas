unit FmEditCapacity;

interface

uses
  cxButtons, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, Grids, Menus, UGshiftCal, UMRes, UMSchedContFunc, UReShape;

type
  TEditCapacity = class(TForm)
    PopupMenu1: TPopupMenu;
    MiUpdate: TMenuItem;
    MiInsert: TMenuItem;
    MIDelete: TMenuItem;
    SGRowDetails: TStringGrid;
    PanBtn: TPanel;
    BtnOk: TcxButton;
    procedure BtnOkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure SGRowDetailsSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure MiUpdateClick(Sender: TObject);
    procedure MiInsertClick(Sender: TObject);
    procedure MIDeleteClick(Sender: TObject);

  private
    m_cal : TPGCALshift;
    m_calCode : string;
    m_ResCode : string;
    m_Res     : TMqmRes;
    m_calResEfficiency : TPGCALshift;
    m_calWcEfficiency_List : TList;
    m_calWcEfficiency_ResName : TStringList;
    m_CalShiftList : TList;
    m_RowSelected : integer;
    m_EfficiencyOnLevel : CEfficiencyOnLevel;
    procedure RefreshCalShiftGrid;
    procedure ReadCalShiftData;

    { Private declarations }
  public
    constructor CreateEditCapacity(AOwner: TComponent; res : TMqmVisibleRes);
    { Public declarations }
  end;

var
  EditCapacity: TEditCapacity;

implementation

{$R *.dfm}

uses UMObjCont,gnugettext,DMsrvPc,UMTblDesc,FmCalShiftEffic, UMWkCtr, UMCOmmon, UMGlobal;
{ TEditCapacity }

//----------------------------------------------------------------------------//

function SortByStartDate(Item1, Item2: Pointer) : integer;
var
  RowDate1  : PTShiftEffic;
  RowDate2  : PTShiftEffic;
begin

  RowDate1 := PTShiftEffic(Item1);
  RowDate2 := PTShiftEffic(Item2);

  if RowDate1 = RowDate2 then
  begin
    Result := 0;
    Exit
  end;

  if RowDate1.StartDate < RowDate2.StartDate then
     Result := -1
  else if (RowDate1.StartDate = RowDate2.StartDate) then
  begin
    if (RowDate1.EndDate < RowDate2.EndDate) then
      Result := -1
    else if (RowDate1.EndDate = RowDate2.EndDate) then
      Result := 1
    else
      Result := 1;
  end
  else
    Result := 1;
end;

//----------------------------------------------------------------------------//

procedure TEditCapacity.BtnOkClick(Sender: TObject);
var
  I : Integer;
  calResEfficiency : TPGCALshift;
  VisRes : TMqmVisibleRes;
begin
  if m_CalShiftList.Count > 0 then
  begin
    if m_EfficiencyOnLevel = EffLvl_Wc then
    begin
      for I := 0 to m_calWcEfficiency_List.Count - 1 do
      begin
        calResEfficiency := TPGCALshift(m_calWcEfficiency_List[I]);
        calResEfficiency.UpdateShiftEffic(m_CalShiftList)
      end;
      m_calWcEfficiency_List.Clear;
    end
    else if (m_EfficiencyOnLevel = EffLvl_Res) or (m_EfficiencyOnLevel = Eff_And_Cal_Both_Lvl_Res) then
    begin
      if (m_ResCode <> '') and Assigned(m_calResEfficiency) then
      begin
        if Assigned(m_Res) and m_Res.p_isMultiRes then
        begin
          for i := 0 to m_Res.p_VisResList.count - 1 do
          begin
            VisRes := TMqmVisibleRes(m_Res.p_VisResList[i]);
            m_calResEfficiency := TPGCALshift(TMqmVisibleRes(VisRes).p_Calendar);
            m_calResEfficiency.UpdateShiftEffic(m_CalShiftList)
          end;
        end
        else
          m_calResEfficiency.UpdateShiftEffic(m_CalShiftList)
      end;
    end
    else
      m_Cal.UpdateShiftEffic(m_CalShiftList);
    p_pl.ReorganizeAll(nil, nil);
  end;

  MOdalResult := mrOk;
//  CLose;
end;

//----------------------------------------------------------------------------//

constructor TEditCapacity.CreateEditCapacity(AOwner: TComponent; res : TMqmVisibleRes);
var
  I : integer;
  wkc : TMqmWrkCtr;
  ResTemp : TMqmRes;
begin
  inherited Create(AOwner);
  m_CalShiftList := TList.Create;
  m_calWcEfficiency_List := TList.Create;
  m_calWcEfficiency_ResName := TStringList.Create;

  if IniAppGlobals.DownloadTo = '1' then
    m_ResCode := ' '
  else
    m_ResCode := '';

  if TMqmVisibleRes(res).p_EfficiencyOnLevel = EffLvl_Wc then
  begin
    m_Cal := TPGCALshift(TMqmVisibleRes(res).p_CalendarReal);
    m_ResCode := TMqmRes(res.p_father).p_ResCode;
    m_calCode := Res.p_CalCodReal;
    wkc := TMqmWrkCtr(TMqmRes(res.p_father).p_Father);
    m_calWcEfficiency_ResName.Clear;
    for i := 0 to wkc.p_ResCount - 1 do
    begin
      ResTemp := TMqmRes(Wkc.p_Res[I]);
      TMqmVisibleRes(ResTemp.p_VisRes[0]).p_Calendar;
      if TMqmVisibleRes(ResTemp.p_VisRes[0]).p_CalCodReal = m_calCode then
      begin
        m_calWcEfficiency_List.Add(TPGCALshift(TMqmVisibleRes(ResTemp.p_VisRes[0]).p_Calendar));
        m_calWcEfficiency_ResName.Add(ResTemp.p_ResCode);
      end;
    end;
    m_EfficiencyOnLevel := EffLvl_Wc;
  end

  else if (TMqmVisibleRes(res).p_EfficiencyOnLevel = EffLvl_Res) or
     (TMqmVisibleRes(res).p_EfficiencyOnLevel = Eff_And_Cal_Both_Lvl_Res) then
  begin
    m_Cal := TPGCALshift(TMqmVisibleRes(res).p_CalendarReal);
    m_Res     := TMqmRes(res.p_father);
    m_ResCode := TMqmRes(res.p_father).p_ResCode;
    m_calCode := Res.p_CalCod;
    //m_calCode := Res.p_CalCodReal;
    m_calResEfficiency := TPGCALshift(TMqmVisibleRes(res).p_Calendar);
    m_EfficiencyOnLevel := EffLvl_Res
  end
  else
  begin
    m_calCode := Res.p_CalCod;
    m_Cal := TPGCALshift(Res.GetCalendar);
    m_EfficiencyOnLevel := EffLvl_Non
  end;

  ReShape(Self);
//  ReShape(BtnOk);
end;

//----------------------------------------------------------------------------//

procedure TEditCapacity.FormCreate(Sender: TObject);
begin
  if (m_EfficiencyOnLevel = EffLvl_Res) or (m_EfficiencyOnLevel = Eff_And_Cal_Both_Lvl_Res) then
  begin
    m_EfficiencyOnLevel := EffLvl_Res;
    caption := m_ResCode
  end
  else
    caption := m_calCode;
  ReadCalShiftData;
  if m_CalShiftList.Count > 0 then
    m_RowSelected := 1;
  m_CalShiftList.Sort(SortByStartDate);
  RefreshCalShiftGrid;
end;

//----------------------------------------------------------------------------//

procedure TEditCapacity.FormDestroy(Sender: TObject);
var
  I : Integer;
begin
  for I := m_CalShiftList.Count -1 downto 0 do
    Dispose(PTShiftEffic(m_CalShiftList[I]));
  m_calWcEfficiency_ResName.Free;
  m_calWcEfficiency_List.Free;
end;

//----------------------------------------------------------------------------//

procedure TEditCapacity.MIDeleteClick(Sender: TObject);
var
  qry:    TMqmQuery;
  tbInfo: ^TTblInfo;
  SqlDelete : string;
  year, month, day : word;
  DateStr : string;
  I : Integer;
  calResEfficiency : TPGCALshift;
  VisRes : TMqmVisibleRes;
begin
  if ((m_RowSelected - 1) >= 0) and (m_CalShiftList.Count > 0) then
  begin
    qry := CreateQuery(Main_DB);
    qry.Transaction := CreateTransaction(Main_DB);
    qry.Transaction.StartTransaction;

    tbInfo := @tblInfo[tbl_calShiftEffic];
    qry.SQL.Clear;

    DecodeDate(PTShiftEffic(m_CalShiftList[m_RowSelected - 1]).StartDate, year, month, day);
    DateStr := ConvertDateFormatDb2Oracle(PTShiftEffic(m_CalShiftList[m_RowSelected - 1]).StartDate, true, true);

    if m_EfficiencyOnLevel = EffLvl_Wc then
    begin
      for I := 0 to m_calWcEfficiency_ResName.Count - 1 do
      begin
        SqlDelete := 'delete from ' + tbInfo.GetTableName;
        SqlDelete := SqlDelete + ' Where ' + CreateFld(tbInfo.pfx, fli_CalCod) + '=''' + m_calCode + '''';
        SqlDelete := SqlDelete + ' And ' + CreateFld(tbInfo.pfx, fli_rsc) + '=''' + m_calWcEfficiency_ResName.Strings[I] + '''';
        SqlDelete := SqlDelete + ' And ' + CreateFld(tbInfo.pfx, fli_CalStartDate) + '=' + DateStr;
        SqlDelete := SqlDelete + AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_identifier));
        qry.sql.Text := SqlDelete;
        Qry.ExecSQL;
      end;
    end
    else
    begin
      SqlDelete := 'delete from ' + tbInfo.GetTableName;
      SqlDelete := SqlDelete + ' Where ' + CreateFld(tbInfo.pfx, fli_CalCod) + '=''' + m_calCode + '''';
      if m_EfficiencyOnLevel = EffLvl_Res then
        SqlDelete := SqlDelete + ' And ' + CreateFld(tbInfo.pfx, fli_rsc) + '=''' + m_ResCode + ''''
      else
      begin
        if IniAppGlobals.DownloadTo = '1' then // oracle
          SqlDelete := SqlDelete + ' And ' + CreateFld(tbInfo.pfx, fli_rsc) + '=''' + ' ' + ''''
        else
          SqlDelete := SqlDelete + ' And ' + CreateFld(tbInfo.pfx, fli_rsc) + '=''' + '' + '''';
      end;
      SqlDelete := SqlDelete + ' And ' + CreateFld(tbInfo.pfx, fli_CalStartDate) + '=' + DateStr;
      SqlDelete := SqlDelete + AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_identifier));
      qry.sql.Text := SqlDelete;
      Qry.ExecSQL;
    end;

    Qry.Transaction.Commit;

    m_CalShiftList.Delete(m_RowSelected - 1);
    if m_EfficiencyOnLevel = EffLvl_Wc then
    begin
      for I := 0 to m_calWcEfficiency_List.Count - 1 do
      begin
        calResEfficiency := TPGCALshift(m_calWcEfficiency_List[I]);
        calResEfficiency.UpdateShiftEffic(m_CalShiftList)
      end;
      m_calWcEfficiency_List.Clear;
    end
    else if m_EfficiencyOnLevel = EffLvl_Res then
    begin

      if Assigned(m_Res) and m_Res.p_isMultiRes then
      begin
        for i := 0 to m_Res.p_VisResList.count - 1 do
        begin
          VisRes := TMqmVisibleRes(m_Res.p_VisResList[i]);
          m_calResEfficiency := TPGCALshift(TMqmVisibleRes(VisRes).p_Calendar);
          m_calResEfficiency.UpdateShiftEffic(m_CalShiftList)
        end;
      end
      else
        if (m_ResCode <> '') and Assigned(m_calResEfficiency) then
          m_calResEfficiency.UpdateShiftEffic(m_CalShiftList)
    end
    else
      m_Cal.UpdateShiftEffic(m_CalShiftList);

    m_CalShiftList.Sort(SortByStartDate);
    RefreshCalShiftGrid;
    qry.Free;
  end;
end;

//----------------------------------------------------------------------------//

procedure TEditCapacity.MiInsertClick(Sender: TObject);
var
  CalShiftEffic : TCalShiftEffic;
  RowDate       : PTShiftEffic;
  StarDate,EndDate : TDate;
  SH1_start,SH1_End,SH2_start,SH2_End,SH3_start,SH3_End,SH4_start,SH4_End : TTime;
  Effic1, Effic2, Effic3, Effic4 : double;
  qry:    TMqmQuery;
  tbInfo: ^TTblInfo;
  SqlInsert : string;
  temp : double;
  I : Integer;
begin
  CalShiftEffic := TCalShiftEffic.CreateCalShiftEffic(self, m_CalShiftList);
  if CalShiftEffic.ShowModal = mrOk then
  begin
    qry := CreateQuery(Main_DB);
    qry.Transaction := CreateTransaction(Main_DB);
    qry.Transaction.StartTransaction;
    tbInfo := @tblInfo[tbl_calShiftEffic];
    qry.SQL.Clear;
    CalShiftEffic.GetUpdatedCalShift(StarDate,EndDate, SH1_start, SH1_End,Effic1, SH2_start,
    SH2_End, Effic2, SH3_start, SH3_End, Effic3, SH4_start, SH4_End, Effic4);
    new(RowDate);

    RowDate.StartDate    := StarDate;
    RowDate.EndDate      := EndDate;
    Temp :=  SH1_start * 24 * 60;
    RowDate.StartMinute1   := trunc(Temp);

    Temp :=  SH1_End * 24 * 60;
    RowDate.EndMinute1   := trunc(Temp);
    RowDate.Effic1       := Effic1;

    Temp :=  SH2_start * 24 * 60;
    RowDate.StartMinute2   := trunc(Temp);

    Temp :=  SH2_End * 24 * 60;
    RowDate.EndMinute2   := trunc(Temp);
    RowDate.Effic2       := Effic2;

    Temp :=  SH3_start * 24 * 60;
    RowDate.StartMinute3   := trunc(Temp);

    Temp :=  SH3_End * 24 * 60;
    RowDate.EndMinute3   := trunc(Temp);

    RowDate.Effic3       := Effic3;

    Temp :=  SH4_start * 24 * 60;
    RowDate.StartMinute4   := trunc(Temp);

    Temp :=  SH4_End * 24 * 60;
    RowDate.EndMinute4   := trunc(Temp);

    RowDate.Effic4       := Effic4;
    m_CalShiftList.Add(RowDate);
    m_CalShiftList.Sort(SortByStartDate);
    RefreshCalShiftGrid;

    SqlInsert := SqlInsert + 'insert into ' + tbInfo.GetTableName + '(';
    SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_identifier) + ',';
    SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_CalCod) + ',';
    SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_rsc)    + ',';
    SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_CalStartDate) + ',';
    SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_CalEndDate) + ',';
    SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_SH1_start) + ',';
    SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_SH1_end) + ',';
    SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_SH1_EFFIC) + ',';
    SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_SH2_start) + ',';
    SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_SH2_end) + ',';
    SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_SH2_EFFIC) + ',';
    SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_SH3_start) + ',';
    SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_SH3_end) + ',';
    SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_SH3_EFFIC) + ',';
    SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_SH4_start) + ',';
    SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_SH4_end) + ',';
    SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_SH4_EFFIC);
    SqlInsert := SqlInsert + ') values (';
    SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_identifier) + ',';
    SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_CalCod) + ',';
    SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_rsc)    + ',';
    SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_CalStartDate) + ',';
    SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_CalEndDate) + ',';
    SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_SH1_start) + ',';
    SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_SH1_end) + ',';
    SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_SH1_EFFIC) + ',';
    SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_SH2_start) + ',';
    SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_SH2_end) + ',';
    SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_SH2_EFFIC) + ',';
    SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_SH3_start) + ',';
    SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_SH3_end) + ',';
    SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_SH3_EFFIC) + ',';
    SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_SH4_start) + ',';
    SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_SH4_end) + ',';
    SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_SH4_EFFIC);
    SqlInsert := SqlInsert + ')';
    qry.sql.Text  := SqlInsert;

    if m_EfficiencyOnLevel = EffLvl_Wc then
    begin
      for I := 0 to m_calWcEfficiency_ResName.Count - 1 do
      begin
        qry.ParamByName(CreateFld(tbInfo.pfx,fli_identifier)).AsString      := IniAppGlobals.Identifier;
        qry.ParamByName(CreateFld(tbInfo.pfx,fli_CalCod)).AsString          := m_calCode;
        qry.ParamByName(CreateFld(tbInfo.pfx,fli_rsc)).AsString             := m_calWcEfficiency_ResName.Strings[I];
        qry.ParamByName(CreateFld(tbInfo.pfx,fli_CalStartDate)).AsDateTime  := StarDate;
        qry.ParamByName(CreateFld(tbInfo.pfx,fli_CalEndDate)).AsDateTime    := EndDate;
        qry.ParamByName(CreateFld(tbInfo.pfx,fli_SH1_start)).AsInteger      := RowDate.StartMinute1;
        qry.ParamByName(CreateFld(tbInfo.pfx,fli_SH1_End)).AsInteger        := RowDate.EndMinute1;
        qry.ParamByName(CreateFld(tbInfo.pfx,fli_SH1_EFFIC)).AsFloat        := Effic1;
        qry.ParamByName(CreateFld(tbInfo.pfx,fli_SH2_start)).AsInteger      := RowDate.StartMinute2;
        qry.ParamByName(CreateFld(tbInfo.pfx,fli_SH2_End)).AsInteger        := RowDate.EndMinute2;
        qry.ParamByName(CreateFld(tbInfo.pfx,fli_SH2_EFFIC)).AsFloat        := Effic2;
        qry.ParamByName(CreateFld(tbInfo.pfx,fli_SH3_start)).AsInteger      := RowDate.StartMinute3;
        qry.ParamByName(CreateFld(tbInfo.pfx,fli_SH3_End)).AsInteger        := RowDate.EndMinute3;
        qry.ParamByName(CreateFld(tbInfo.pfx,fli_SH3_EFFIC)).AsFloat        := Effic3;
        qry.ParamByName(CreateFld(tbInfo.pfx,fli_SH4_start)).AsInteger      := RowDate.StartMinute4;
        qry.ParamByName(CreateFld(tbInfo.pfx,fli_SH4_End)).AsInteger        := RowDate.EndMinute4;
        qry.ParamByName(CreateFld(tbInfo.pfx,fli_SH4_EFFIC)).AsFloat        := Effic4;
        Qry.ExecSQL;
      end
    end
    else
    begin
      qry.ParamByName(CreateFld(tbInfo.pfx,fli_identifier)).AsString      := IniAppGlobals.Identifier;
      qry.ParamByName(CreateFld(tbInfo.pfx,fli_CalCod)).AsString          := m_calCode;

      if m_EfficiencyOnLevel = EffLvl_Res then
        qry.ParamByName(CreateFld(tbInfo.pfx,fli_rsc)).AsString           := m_ResCode
      else
      begin
        if IniAppGlobals.DownloadTo = '1' then
           qry.ParamByName(CreateFld(tbInfo.pfx,fli_rsc)).AsString           := ' '  // Oracle
        else
          qry.ParamByName(CreateFld(tbInfo.pfx,fli_rsc)).AsString           := '';
      end;

      qry.ParamByName(CreateFld(tbInfo.pfx,fli_CalStartDate)).AsDateTime  := StarDate;
      qry.ParamByName(CreateFld(tbInfo.pfx,fli_CalEndDate)).AsDateTime    := EndDate;
      qry.ParamByName(CreateFld(tbInfo.pfx,fli_SH1_start)).AsInteger      := RowDate.StartMinute1;
      qry.ParamByName(CreateFld(tbInfo.pfx,fli_SH1_End)).AsInteger        := RowDate.EndMinute1;
      qry.ParamByName(CreateFld(tbInfo.pfx,fli_SH1_EFFIC)).AsFloat        := Effic1;
      qry.ParamByName(CreateFld(tbInfo.pfx,fli_SH2_start)).AsInteger      := RowDate.StartMinute2;
      qry.ParamByName(CreateFld(tbInfo.pfx,fli_SH2_End)).AsInteger        := RowDate.EndMinute2;
      qry.ParamByName(CreateFld(tbInfo.pfx,fli_SH2_EFFIC)).AsFloat        := Effic2;
      qry.ParamByName(CreateFld(tbInfo.pfx,fli_SH3_start)).AsInteger      := RowDate.StartMinute3;
      qry.ParamByName(CreateFld(tbInfo.pfx,fli_SH3_End)).AsInteger        := RowDate.EndMinute3;
      qry.ParamByName(CreateFld(tbInfo.pfx,fli_SH3_EFFIC)).AsFloat        := Effic3;
      qry.ParamByName(CreateFld(tbInfo.pfx,fli_SH4_start)).AsInteger      := RowDate.StartMinute4;
      qry.ParamByName(CreateFld(tbInfo.pfx,fli_SH4_End)).AsInteger        := RowDate.EndMinute4;
      qry.ParamByName(CreateFld(tbInfo.pfx,fli_SH4_EFFIC)).AsFloat        := Effic4;
      Qry.ExecSQL;

    end;
    Qry.Transaction.Commit;
    qry.Free;
  end;
end;

//----------------------------------------------------------------------------//

procedure TEditCapacity.MiUpdateClick(Sender: TObject);
var
  CalShiftEffic : TCalShiftEffic;
  RowDate       : PTShiftEffic;
  StarDate,EndDate : TDate;
  SH1_start,SH1_End,SH2_start,SH2_End,SH3_start,SH3_End,SH4_start,SH4_End : TTime;
  Temp : double;
  Effic1, Effic2, Effic3, Effic4 : double;
  qry:    TMqmQuery;
  tbInfo: ^TTblInfo;
  SqlUpdate : string;
  I : Integer;
begin
  qry := CreateQuery(Main_DB);
  qry.Transaction := CreateTransaction(Main_DB);
  qry.Transaction.StartTransaction;

  tbInfo := @tblInfo[tbl_calShiftEffic];
  qry.SQL.Clear;

  if m_CalShiftList.Count = 0 then
    Exit
  else if m_CalShiftList.Count = 1 then
    m_RowSelected := 1;

  RowDate := PTShiftEffic(m_CalShiftList[m_RowSelected - 1]);
  CalShiftEffic := TCalShiftEffic.CreateCalShiftEfficUpdate(self,RowDate.StartDate,RowDate.EndDate,
  RowDate.StartMinute1/24/60, RowDate.EndMinute1/24/60,RowDate.Effic1, RowDate.StartMinute2/24/60, RowDate.EndMinute2/24/60, RowDate.Effic2,
  RowDate.StartMinute3/24/60, RowDate.EndMinute3/24/60, RowDate.Effic3, RowDate.StartMinute4/24/60, RowDate.EndMinute4/24/60, RowDate.Effic4);

  if CalShiftEffic.ShowModal = mrOk then
  begin
    CalShiftEffic.GetUpdatedCalShift(StarDate,EndDate, SH1_start, SH1_End,Effic1, SH2_start,
    SH2_End, Effic2, SH3_start, SH3_End, Effic3, SH4_start, SH4_End, Effic4);

    if SH1_End = 0 then
       SH1_End := 1;

    if SH2_End = 0 then
       SH2_End := 1;

    if SH3_End = 0 then
       SH3_End := 1;

    if SH4_End = 0 then
       SH4_End := 1;

    Temp :=  SH1_start * 24 * 60;
    RowDate.StartMinute1   := trunc(Temp);

    Temp :=  SH1_End * 24 * 60;
    RowDate.EndMinute1   := trunc(Temp);
    RowDate.Effic1       := Effic1;

    Temp :=  SH2_start * 24 * 60;
    RowDate.StartMinute2   := trunc(Temp);

    Temp :=  SH2_End * 24 * 60;
    RowDate.EndMinute2   := trunc(Temp);
    RowDate.Effic2       := Effic2;

    Temp :=  SH3_start * 24 * 60;
    RowDate.StartMinute3   := trunc(Temp);

    Temp :=  SH3_End * 24 * 60;
    RowDate.EndMinute3   := trunc(Temp);

    RowDate.Effic3       := Effic3;

    Temp :=  SH4_start * 24 * 60;
    RowDate.StartMinute4   := trunc(Temp);

    Temp :=  SH4_End * 24 * 60;
    RowDate.EndMinute4   := trunc(Temp);

    RowDate.Effic4       := Effic4;
    RefreshCalShiftGrid;

    SqlUpdate := 'update ' + tbInfo.GetTableName + ' set ';
    SqlUpdate := SqlUpdate + CreateFld(tbInfo.pfx, fli_SH1_start) + ' = ';
    SqlUpdate := SqlUpdate + ':' + CreateFld(tbInfo.pfx, fli_SH1_start) + ',';
    SqlUpdate := SqlUpdate + CreateFld(tbInfo.pfx, fli_SH1_End) + ' = ';
    SqlUpdate := SqlUpdate + ':' + CreateFld(tbInfo.pfx, fli_SH1_End)  + ',';
    SqlUpdate := SqlUpdate + CreateFld(tbInfo.pfx, fli_SH1_EFFIC) + ' = ';
    SqlUpdate := SqlUpdate + ':' + CreateFld(tbInfo.pfx, fli_SH1_EFFIC)  + ',';
    SqlUpdate := SqlUpdate + CreateFld(tbInfo.pfx, fli_SH2_start) + ' = ';
    SqlUpdate := SqlUpdate + ':' + CreateFld(tbInfo.pfx, fli_SH2_start)  + ',';
    SqlUpdate := SqlUpdate + CreateFld(tbInfo.pfx, fli_SH2_End) + ' = ';
    SqlUpdate := SqlUpdate + ':' + CreateFld(tbInfo.pfx, fli_SH2_End)  + ',';
    SqlUpdate := SqlUpdate + CreateFld(tbInfo.pfx, fli_SH2_EFFIC) + ' = ';
    SqlUpdate := SqlUpdate + ':' + CreateFld(tbInfo.pfx, fli_SH2_EFFIC)  + ',';
    SqlUpdate := SqlUpdate + CreateFld(tbInfo.pfx, fli_SH3_start) + ' = ';
    SqlUpdate := SqlUpdate + ':' + CreateFld(tbInfo.pfx, fli_SH3_start)  + ',';
    SqlUpdate := SqlUpdate + CreateFld(tbInfo.pfx, fli_SH3_End) + ' = ';
    SqlUpdate := SqlUpdate + ':' + CreateFld(tbInfo.pfx, fli_SH3_End)  + ',';
    SqlUpdate := SqlUpdate + CreateFld(tbInfo.pfx, fli_SH3_EFFIC) + ' = ';
    SqlUpdate := SqlUpdate + ':' + CreateFld(tbInfo.pfx, fli_SH3_EFFIC)  + ',';
    SqlUpdate := SqlUpdate + CreateFld(tbInfo.pfx, fli_SH4_start) + ' = ';
    SqlUpdate := SqlUpdate + ':' + CreateFld(tbInfo.pfx, fli_SH4_start)  + ',';
    SqlUpdate := SqlUpdate + CreateFld(tbInfo.pfx, fli_SH4_End) + ' = ';
    SqlUpdate := SqlUpdate + ':' + CreateFld(tbInfo.pfx, fli_SH4_End)  + ',';
    SqlUpdate := SqlUpdate + CreateFld(tbInfo.pfx, fli_SH4_EFFIC) + ' = ';
    SqlUpdate := SqlUpdate + ':' + CreateFld(tbInfo.pfx, fli_SH4_EFFIC);
    SqlUpdate := SqlUpdate + ' where ';
    SqlUpdate := SqlUpdate + CreateFld(tbInfo.pfx, fli_identifier)   + ' = ';
    SqlUpdate := SqlUpdate + ':' + CreateFld(tbInfo.pfx, fli_identifier) + ' and ';
    SqlUpdate := SqlUpdate + CreateFld(tbInfo.pfx, fli_CalCod)   + ' = ';
    SqlUpdate := SqlUpdate + ':' + CreateFld(tbInfo.pfx, fli_CalCod) + ' and ';
    SqlUpdate := SqlUpdate + CreateFld(tbInfo.pfx, fli_rsc)   + ' = ';
    SqlUpdate := SqlUpdate + ':' + CreateFld(tbInfo.pfx, fli_rsc) + ' and ';
    SqlUpdate := SqlUpdate + CreateFld(tbInfo.pfx, fli_CalStartDate)   + ' = ';
    SqlUpdate := SqlUpdate + ':' + CreateFld(tbInfo.pfx, fli_CalStartDate);
    qry.SQL.Text := SqlUpdate;

    if m_EfficiencyOnLevel = EffLvl_Wc then
    begin
      for I := 0 to m_calWcEfficiency_ResName.Count - 1 do
      begin
        qry.ParamByName(CreateFld(tbInfo.pfx, fli_identifier)).AsString := IniAppGlobals.Identifier;
        qry.ParamByName(CreateFld(tbInfo.pfx, fli_CalCod)).AsString := m_calCode;
        qry.ParamByName(CreateFld(tbInfo.pfx, fli_rsc)).AsString    := m_calWcEfficiency_ResName.Strings[I];
        qry.ParamByName(CreateFld(tbInfo.pfx, fli_CalStartDate)).AsDateTime := RowDate.StartDate;
        qry.ParamByName(CreateFld(tbInfo.pfx, fli_SH1_start)).AsInteger  := RowDate.StartMinute1;
        qry.ParamByName(CreateFld(tbInfo.pfx, fli_SH1_End)).AsInteger    := RowDate.EndMinute1;
        qry.ParamByName(CreateFld(tbInfo.pfx, fli_SH1_EFFIC)).AsFloat := Effic1;
        qry.ParamByName(CreateFld(tbInfo.pfx, fli_SH2_start)).AsInteger  := RowDate.StartMinute2;
        qry.ParamByName(CreateFld(tbInfo.pfx, fli_SH2_End)).AsInteger    := RowDate.EndMinute2;
        qry.ParamByName(CreateFld(tbInfo.pfx, fli_SH2_EFFIC)).AsFloat := Effic2;
        qry.ParamByName(CreateFld(tbInfo.pfx, fli_SH3_start)).AsInteger  := RowDate.StartMinute3;
        qry.ParamByName(CreateFld(tbInfo.pfx, fli_SH3_End)).AsInteger    := RowDate.EndMinute3;
        qry.ParamByName(CreateFld(tbInfo.pfx, fli_SH3_EFFIC)).AsFloat := Effic3;
        qry.ParamByName(CreateFld(tbInfo.pfx, fli_SH4_start)).AsInteger  := RowDate.StartMinute4;
        qry.ParamByName(CreateFld(tbInfo.pfx, fli_SH4_End)).AsInteger    := RowDate.EndMinute4;
        qry.ParamByName(CreateFld(tbInfo.pfx, fli_SH4_EFFIC)).AsFloat := Effic4;
        Qry.ExecSQL;
      end;
    end
    else
    begin
      qry.ParamByName(CreateFld(tbInfo.pfx, fli_identifier)).AsString := IniAppGlobals.Identifier;
      qry.ParamByName(CreateFld(tbInfo.pfx, fli_CalCod)).AsString := m_calCode;
      if m_EfficiencyOnLevel = EffLvl_Res then
        qry.ParamByName(CreateFld(tbInfo.pfx,fli_rsc)).AsString           := m_ResCode
      else
      begin
        if IniAppGlobals.DownloadTo = '1'  then
          qry.ParamByName(CreateFld(tbInfo.pfx,fli_rsc)).AsString           := ' '
        else
          qry.ParamByName(CreateFld(tbInfo.pfx,fli_rsc)).AsString           := '';
      end;

      qry.ParamByName(CreateFld(tbInfo.pfx, fli_CalStartDate)).AsDateTime := RowDate.StartDate;
      qry.ParamByName(CreateFld(tbInfo.pfx, fli_SH1_start)).AsInteger  := RowDate.StartMinute1;
      qry.ParamByName(CreateFld(tbInfo.pfx, fli_SH1_End)).AsInteger    := RowDate.EndMinute1;
      qry.ParamByName(CreateFld(tbInfo.pfx, fli_SH1_EFFIC)).AsFloat := Effic1;
      qry.ParamByName(CreateFld(tbInfo.pfx, fli_SH2_start)).AsInteger  := RowDate.StartMinute2;
      qry.ParamByName(CreateFld(tbInfo.pfx, fli_SH2_End)).AsInteger    := RowDate.EndMinute2;
      qry.ParamByName(CreateFld(tbInfo.pfx, fli_SH2_EFFIC)).AsFloat := Effic2;
      qry.ParamByName(CreateFld(tbInfo.pfx, fli_SH3_start)).AsInteger  := RowDate.StartMinute3;
      qry.ParamByName(CreateFld(tbInfo.pfx, fli_SH3_End)).AsInteger    := RowDate.EndMinute3;
      qry.ParamByName(CreateFld(tbInfo.pfx, fli_SH3_EFFIC)).AsFloat := Effic3;
      qry.ParamByName(CreateFld(tbInfo.pfx, fli_SH4_start)).AsInteger  := RowDate.StartMinute4;
      qry.ParamByName(CreateFld(tbInfo.pfx, fli_SH4_End)).AsInteger    := RowDate.EndMinute4;
      qry.ParamByName(CreateFld(tbInfo.pfx, fli_SH4_EFFIC)).AsFloat := Effic4;
      Qry.ExecSQL;
    end;
    Qry.Transaction.Commit;
    qry.Free;
  end;
end;

//----------------------------------------------------------------------------//

procedure TEditCapacity.RefreshCalShiftGrid;
var
  I : integer;
  RowData : PTShiftEffic;
begin
  with SGRowDetails do
  begin

    RowCount := m_CalShiftList.Count + 1;
    if RowCount > 1 then FixedRows := 1;

    Cells[0, 0] := _('Start Date');
    Cells[1, 0] := _('End Date');
    Cells[2, 0] := _('Start');
    Cells[3, 0] := _('End');
    Cells[4, 0] := _('Efficiency');

    Cells[5, 0] := _('Start');
    Cells[6, 0] := _('End');
    Cells[7, 0] := _('Efficiency');

    Cells[8, 0] := _('Start');
    Cells[9, 0] := _('End');
    Cells[10, 0] := _('Efficiency');

    Cells[11, 0] := _('Start');
    Cells[12, 0] := _('End');
    Cells[13, 0] := _('Efficiency');

    for i:= 0 to m_CalShiftList.Count - 1 do
    begin
      RowData := m_CalShiftList.Items[i];
      Cells[0, i+1] := DateTimeToStr(RowData.StartDate);
      Cells[1, i+1] := DateTimeToStr(RowData.EndDate);
      Cells[2, i+1] := TimeToStr(RowData.StartMinute1 / 24 / 60);
      Cells[3, i+1] := TimeToStr(RowData.EndMinute1 / 24 / 60);
      Cells[4, i+1] := FloatToStr(RowData.Effic1);
      Cells[5, i+1] := TimeToStr(RowData.StartMinute2 / 24 / 60);
      Cells[6, i+1] := TimeToStr(RowData.EndMinute2 / 24 / 60);
      Cells[7, i+1] := FloatToStr(RowData.Effic2);
      Cells[8, i+1] := TimeToStr(RowData.StartMinute3 / 24 / 60);
      Cells[9, i+1] := TimeToStr(RowData.EndMinute3 / 24 / 60);
      Cells[10, i+1] := FloatToStr(RowData.Effic3);
      Cells[11, i+1] := TimeToStr(RowData.StartMinute4 / 24 / 60);
      Cells[12, i+1] := TimeToStr(RowData.EndMinute4 / 24 / 60);
      Cells[13, i+1] := FloatToStr(RowData.Effic4);
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure TEditCapacity.SGRowDetailsSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  m_RowSelected := Arow;
end;

//----------------------------------------------------------------------------//

procedure TEditCapacity.ReadCalShiftData;
var
  qry:    TMqmQuery;
  tbInfo: ^TTblInfo;
  RodDate : PTShiftEffic;
begin
  qry := CreateQuery(Main_DB);
  tbInfo := @tblInfo[tbl_calShiftEffic];

  qry.SQL.Clear;
  qry.SQL.Add('select * from ' + tbInfo.GetTableName);
  qry.SQL.Add(' where ' + CreateFld(tbInfo.pfx, fli_CalCod) + '=''' + m_calCode + '''');
  qry.SQL.Add(' and ' + CreateFld(tbInfo.pfx, fli_rsc) + '=''' + m_ResCode + '''');
  qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_identifier)));
  qry.SQL.Add(' order by ' + CreateFld(tbInfo.pfx , fli_CalStartDate));
  qry.Open;

  while not qry.Eof do
  begin
    new(RodDate);
    RodDate.StartDate := qry.FieldByName(CreateFld(tbInfo.pfx, fli_CalStartDate)).AsDateTime;
    RodDate.EndDate := qry.FieldByName(CreateFld(tbInfo.pfx, fli_CalEndDate)).AsDateTime;
    RodDate.StartMinute1  := qry.FieldByName(CreateFld(tbInfo.pfx, fli_SH1_start)).AsInteger;
    RodDate.EndMinute1    := qry.FieldByName(CreateFld(tbInfo.pfx, fli_SH1_end)).AsInteger;
    RodDate.Effic1  := qry.FieldByName(CreateFld(tbInfo.pfx, fli_SH1_EFFIC)).AsFloat;
    RodDate.StartMinute2  := qry.FieldByName(CreateFld(tbInfo.pfx, fli_SH2_start)).AsInteger;
    RodDate.EndMinute2    := qry.FieldByName(CreateFld(tbInfo.pfx, fli_SH2_end)).AsInteger;
    RodDate.Effic2  := qry.FieldByName(CreateFld(tbInfo.pfx, fli_SH2_EFFIC)).AsFloat;
    RodDate.StartMinute3  := qry.FieldByName(CreateFld(tbInfo.pfx, fli_SH3_start)).AsInteger;
    RodDate.EndMinute3    := qry.FieldByName(CreateFld(tbInfo.pfx, fli_SH3_end)).AsInteger;
    RodDate.Effic3  := qry.FieldByName(CreateFld(tbInfo.pfx, fli_SH3_EFFIC)).AsFloat;
    RodDate.StartMinute4  := qry.FieldByName(CreateFld(tbInfo.pfx, fli_SH4_start)).AsInteger;
    RodDate.EndMinute4    := qry.FieldByName(CreateFld(tbInfo.pfx, fli_SH4_end)).AsInteger;
    RodDate.Effic4  := qry.FieldByName(CreateFld(tbInfo.pfx, fli_SH4_EFFIC)).AsFloat;
    m_CalShiftList.Add(RodDate);
    qry.Next;
  end;

  qry.Free;
end;

end.
