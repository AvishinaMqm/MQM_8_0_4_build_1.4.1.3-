unit UMCalcTimings;

interface

uses
  classes,
  UMSchedCont,
  UMSchedContFunc;

type

  TMCalcTimings = class
    constructor CreateCalc;
    destructor  Destroy; override;

    procedure Clear;
    procedure SetMainId(id: TSchedId);

    function  CanGoOnRes(resObj: TObject): boolean;

    procedure SetTargetRes(resObj: TObject);
    procedure SetByDescr(Descr: string);
    procedure UpdateGrpTmg;
    procedure GetMainTimingsOrig(var supMin, exeMin: double; var TmgDescr: string; var TmgMSC: string);
    procedure GetMainTimings(var supMin, exeMin: double; var TmgDescr: string; var TmgMSC: string);
    procedure GetResCatWrkCntrProcessCalcTiming(var WkCentr : string; var Process : string; var Res : string; var CatRes : string);
    procedure GetDescList(DescList: TStringList);

    function  GetNumSubs: integer;
    procedure GetSubTimings(pos: integer; var id: TSchedId; var supMin, exeMin: double; var TmgDescr: string; var TmgMSC: string);
    procedure GetResCatWrkCntrProcessSubTimings(pos: integer; var id: TSchedId; var WkCentr : string; var Process : string; var Res : string; var CatRes : string);

  private
    m_tgtRes: TObject;
    m_id:     TSchedId;
    m_type:   CScSchedType;
    m_list:   TList;
    m_supMin: double;
    m_exeMin: double;
    m_origexeMin: double;
    m_origSetupMin: double;
    m_TmgDescr: string;
    m_MSC:      string;
    m_wkcCode : string;
    m_wkcProc : string;
    m_resCode : string;
    m_resCat  : string;
    m_MachineSetupList:  Tlist;

  end;

{$ifdef ARO}
  function SortSTBySeq(Item1, Item2: Pointer): integer;
{$endif}

procedure Destroy_SchedContTime(FreeList : boolean);
function GetAddtionalTimeExeForCurve(Id : TSchedId; RemainExecutionTime : double; CurveTimeToIgnore : double) : double;
function GetMinutesExcludeLearningCurveAffect(Id : TSchedId; MinuteToStartFrom, NumberOfMinutes : double) : double;

implementation

uses
  SysUtils,
  gnugettext,
  UMRes,
  UMTblDesc,
  DMSrvPC,
  UMWkCtr,
  UMObjCont,
  FMlearningCurve,
  UMSchedOnPlan,
  UMCOmmon,
  UMResCat;

type

  TMachineSetup = record
    wkcCode:       string;
    wkcProc:       string;
    resCat:        string;
    resCode:       string;
    Sequence:      string;
    Description:   string;
    MachSetupCode: string;
  end;
  PTMachineSetup = ^TMachineSetup;

  TRecTmg = record
    wkcCode:       string;
    wkcProc:       string;
    resCat:        string;
    resCode:       string;
    MachSetupCode: string;
    IgnorExeTimeWhenGrp : boolean;
    supTime:       double;
    exeTime:       double;
    exeTimeOrig:   double;
    supTimeOrig:       double;
{$ifdef ARO}
    sequence:      string;
{$endif}
    description:   string;

  end;
  PTRecTmg = ^TRecTmg;

  TMObjTimings = class
    constructor CreateObj(id: TSchedId; machine_list: Tlist);
    destructor  Destroy; override;

    function  CanGoOnRes(resObj: TObject): boolean;
    procedure SetObjTargetRes(resObj: TObject);
    procedure GetSubTimings(var id: TSchedId; var supMin, exeMin: double; var TmgDescr: string;  var TmgMSC: string);
    procedure GetResCatWrkCntrProcessSubTimings(var id: TSchedId; var WkCentr : string; var Process : string; var Res : string; var CatRes : string);

  private
    m_id:         TSchedId;
    m_ObjSupMin:  double;
    m_ObjExeMin:  double;
    m_ObjExeMinOrig:  double;
    m_ObjSupMinOrig:  double;
    m_ObjTmgDesc: string;
    m_ObjMSC:     string; //machine setup code
    m_timingInfo: TSQtimingInfo;
    m_moveChg:    TSQmoveChgInfo;
    m_wkc:        TMqmWrkCtr;

    m_ObjwkcCode : string;
    m_ObjwkcProc : string;
    m_ObjresCode : string;
    m_ObjresCat  : string;

    m_recList:           TList; // all step times per prod req and step
    m_ValidRecList:      TList; // valid ST for the job
    m_ValidMSC:          Tlist; // valid MSC for the job
    MSC_List:            Tlist; // all MSC avaliable

    function  FindTheOne(wkcCode, wkcProc, resCode, resCat: string): PTRecTmg;
    procedure FindAll(wkcCode, wkcProc, resCode, resCat: string; TmgList: TList);
    procedure getValidMachineSUList(WrkCtr,WrkProc: string); //MSC_List: Tlist);
  end;

//----------------------------------------------------------------------------//
//  is called from UMPlan constructor TMqmPlan.CreatePlan
//  takes from DB all MSC ( Machine Setup Codes ). into m_MachineSetupList
//
//----------------------------------------------------------------------------//

var
  m_SchedContTime : TList;
constructor TMCalcTimings.CreateCalc;
var
  tbInfo: ^TTblInfo;
  qry:    TMqmQuery;
  pMsc:   PTMachineSetup;
begin
  inherited Create;
  m_tgtRes := nil;
  m_id     := CSchedIdNull;
  m_list   := TList.Create;

  m_MachineSetupList := TList.Create;
  qry := CreateQuery(Main_DB);

  tbInfo := @tblInfo[tbl_Machine_Setup_code];
  SetFldPfx(tbInfo.pfx);

  with qry.SQL do
  begin
    Add('select');
    Add(CreateFld(tbInfo.pfx, fli_wkCtrCode)       + ',');
    Add(CreateFld(tbInfo.pfx, fli_wkcProc)         + ',');
    Add(CreateFld(tbInfo.pfx, fli_ResCatcode)      + ',');
    Add(CreateFld(tbInfo.pfx, fli_Rsc)             + ',');
//    Add(CreatePfxFld(fli_sequenceChar)    + ',');
    Add(CreateFld(tbInfo.pfx, fli_Desc)       + ',');
    Add(CreateFld(tbInfo.pfx, fli_MachSetupCode)   );
    Add('from ' + tbInfo.GetTableName);
    Add(WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
  end;

  qry.Open;

  while not qry.EOF do
  begin
    New(pMsc);

    pMsc.wkcCode        := trim(qry.FieldByName(CreateFld(tbInfo.pfx, fli_wkCtrCode)).AsString);
    pMsc.wkcProc        := trim(qry.FieldByName(CreateFld(tbInfo.pfx, fli_wkcProc)).AsString);
    pMsc.resCat         := trim(qry.FieldByName(CreateFld(tbInfo.pfx, fli_ResCatcode)).AsString);
    pMsc.resCode        := trim(qry.FieldByName(CreateFld(tbInfo.pfx, fli_Rsc)).AsString);
    pMsc.MachSetupCode  := trim(qry.FieldByName(CreateFld(tbInfo.pfx, fli_MachSetupCode)).AsString);
//    pMsc.Sequence       := trim(qry.FieldByName(CreatePfxFld(fli_sequenceChar)).AsString);
    pMsc.Description    := trim(qry.FieldByName(CreateFld(tbInfo.pfx, fli_Desc)).AsString);

    m_MachineSetupList.Add(pMsc);

    qry.Next
  end;
//  trs.Commit;

  qry.Close;
  qry.Free;

end;

//----------------------------------------------------------------------------//

destructor TMCalcTimings.Destroy;
begin
  Clear;
  m_MachineSetupList.Free;
  m_list.Free;
  inherited Destroy
end;

//----------------------------------------------------------------------------//

procedure TMCalcTimings.Clear;
var
  i: integer;
begin
  m_tgtRes := nil;
  m_id     := CSchedIdNull;
  for I := m_MachineSetupList.Count -1 downto 0 do
    Dispose(PTMachineSetup(m_MachineSetupList[I]));
  m_MachineSetupList.Clear;
//  for i := 0 to m_list.Count-1 do
//    TMObjTimings(m_list[i]).Free;
  m_list.Clear
end;

//----------------------------------------------------------------------------//

procedure TMCalcTimings.SetMainId(id: TSchedId);
var
  isGrp: boolean;
  i:     integer;
  Temp : TMObjTimings;
  planInfo: TSQplanInfo;
  SonId, Id_CalcTiming : TSchedId;
begin
  Clear;
  m_id   := id;
  if not Assigned(m_SchedContTime) then
     m_SchedContTime := TList.Create;
  m_type := p_sc.GetJobType(id);

  p_sc.GetObjInfo(id, isGrp);

  p_sc.GetPlanInfo(id, planInfo);
  if not isGrp then
  begin
    if not p_sc.GetCalculatedTimeId(id, Id_CalcTiming) then
    begin
      Temp := TMObjTimings.CreateObj(m_id, m_MachineSetupList);
      Id_CalcTiming := m_SchedContTime.add(Temp);
      p_sc.SetCalculatedTime(id, true, Id_CalcTiming);
      m_list.Add(Temp)
    end
    else
    begin
      if Id_CalcTiming <> CSchedIDnull then
      begin
        Temp := TMObjTimings(m_SchedContTime[Id_CalcTiming]);
        m_list.Add(Temp);
      end
      else
      begin
        Temp := TMObjTimings.CreateObj(m_id, m_MachineSetupList);
        Id_CalcTiming := m_SchedContTime.add(Temp);
        p_sc.SetCalculatedTime(id, true, Id_CalcTiming);
        m_list.Add(Temp)
      end;
    end;
  end
  else
  begin
    for i := 0 to p_sc.GetGrpNumSons(m_id)-1 do
    begin
      SonId := p_sc.GetGrpSon(m_id, i);
      if not p_sc.GetCalculatedTimeId(SonId, Id_CalcTiming) then
      begin
        Temp := TMObjTimings.CreateObj(SonId, m_MachineSetupList);
        Id_CalcTiming := m_SchedContTime.add(Temp);
        p_sc.SetCalculatedTime(SonId, true, Id_CalcTiming);
        m_list.Add(Temp)
      end
      else
      begin
        Temp := TMObjTimings(m_SchedContTime[Id_CalcTiming]);
        m_list.Add(Temp);
      end;
    end;
  end;
{  if not isGrp then
  begin
    Temp := TMObjTimings.CreateObj(m_id, m_MachineSetupList);
    m_list.Add(Temp)

  end
  else
    for i := 0 to p_sc.GetGrpNumSons(m_id)-1 do
      m_list.Add(TMObjTimings.CreateObj(p_sc.GetGrpSon(m_id, i), m_MachineSetupList)) }
end;

//----------------------------------------------------------------------------//

procedure  TMCalcTimings.UpdateGrpTmg;
var
  isGrp: boolean;
  i:     integer;
  resObj: TObject;
  SonId , Id_CalcTiming : TSchedId;
  Temp : TMObjTimings;
begin
  p_sc.GetObjInfo(m_id, isGrp);
  if isGrp then
  begin
    m_list.Clear;

//    for i := 0 to p_sc.GetGrpNumSons(m_id)-1 do
//      m_list.Add(TMObjTimings.CreateObj(p_sc.GetGrpSon(m_id, i),m_MachineSetupList));

    for i := 0 to p_sc.GetGrpNumSons(m_id)-1 do
    begin
      SonId := p_sc.GetGrpSon(m_id, i);
      if not p_sc.GetCalculatedTimeId(SonId, Id_CalcTiming) then
      begin
        Temp := TMObjTimings.CreateObj(SonId, m_MachineSetupList);
        Id_CalcTiming := m_SchedContTime.add(Temp);
        p_sc.SetCalculatedTime(SonId, true, Id_CalcTiming);
        m_list.Add(Temp)
      end
      else
      begin
        Temp := TMObjTimings(m_SchedContTime[Id_CalcTiming]);
        m_list.Add(Temp);
      end;
    end;

    if Assigned(m_tgtRes) then
    begin
      resObj := m_tgtRes;
      m_tgtRes := nil;
      SetTargetRes(resObj)
      end
  end;
end;

//----------------------------------------------------------------------------//

function TMCalcTimings.CanGoOnRes(resObj: TObject): boolean;
var
  i: integer;
begin
  Result := false;
  for i := 0 to m_list.Count-1 do
    if not TMObjTimings(m_list[i]).CanGoOnRes(resObj) then exit;
  Result := true
end;

//----------------------------------------------------------------------------//

procedure TMCalcTimings.SetTargetRes(resObj: TObject);
var
  i, j: integer;
  GroupSequenceAlreadyTaken : boolean;
  ExeMinSequence : double;
begin
  if m_tgtRes <> resObj then
  begin
    for i := 0 to m_list.Count-1 do
      TMObjTimings(m_list[i]).SetObjTargetRes(resObj);

    if ((m_type = CST_batch))
    or (TMObjTimings(m_list[0]).m_timingInfo.Continues_Parallel) then
    begin
      m_exeMin := TMObjTimings(m_list[0]).m_ObjExeMin;
      m_origexeMin := m_exeMin;
      m_supMin := 0;

      //Take the worst setup time
      for i := 0 to m_list.Count-1 do
        if m_supMin < TMObjTimings(m_list[i]).m_ObjSupMin then
          m_supMin := TMObjTimings(m_list[i]).m_ObjSupMin;

      m_origSetupMin := m_supMin;

      m_wkcCode := TMObjTimings(m_list[0]).m_ObjwkcCode;   // avi sep 16 2009
      m_wkcProc := TMObjTimings(m_list[0]).m_ObjwkcProc;   // avi sep 16 2009
      m_resCode := TMObjTimings(m_list[0]).m_ObjresCode;   // avi sep 16 2009
      m_resCat := TMObjTimings(m_list[0]).m_ObjresCat;     // avi sep 16 2009

    end
    else
    begin
      //Take the setup time of the first job
      m_supMin := TMObjTimings(m_list[0]).m_ObjSupMin;
      m_origSetupMin := TMObjTimings(m_list[0]).m_ObjSupMinOrig;

      m_exeMin := 0;
      m_origexeMin := 0;

      m_wkcCode := TMObjTimings(m_list[0]).m_ObjwkcCode;
      m_wkcProc := TMObjTimings(m_list[0]).m_ObjwkcProc;
      m_resCode := TMObjTimings(m_list[0]).m_ObjresCode;
      m_resCat := TMObjTimings(m_list[0]).m_ObjresCat;

      //Sum the jobs duration
      for i := 0 to m_list.Count-1 do
      begin
        if TMObjTimings(m_list[i]).m_timingInfo.IgnorExeTimeWhenGrp then continue;
        if (TMObjTimings(m_list[i]).m_timingInfo.Grp_Sequence = '') then
        begin
          m_exeMin := m_exeMin + TMObjTimings(m_list[i]).m_ObjExeMin;
          m_origexeMin := m_origexeMin + TMObjTimings(m_list[i]).m_ObjExeMinOrig;
          continue;
        end;
        GroupSequenceAlreadyTaken := false;
        ExeMinSequence := TMObjTimings(m_list[i]).m_ObjExeMin;
        for j := 0 to m_list.Count-1 do
        begin
          if j = i then continue;
          if TMObjTimings(m_list[j]).m_timingInfo.IgnorExeTimeWhenGrp then continue;
          if (TMObjTimings(m_list[j]).m_timingInfo.Grp_Sequence <>
              TMObjTimings(m_list[i]).m_timingInfo.Grp_Sequence) then continue;
          if j < i then
          begin
            GroupSequenceAlreadyTaken := true;
            break;
          end;
          if ExeMinSequence < TMObjTimings(m_list[j]).m_ObjExeMin then
            ExeMinSequence := TMObjTimings(m_list[j]).m_ObjExeMin;
        end;
        if not GroupSequenceAlreadyTaken then
        begin
          m_exeMin := m_exeMin + ExeMinSequence;
          m_origexeMin := m_exeMin
        end;
      end;
    end;

    m_TmgDescr := TMObjTimings(m_list[0]).m_ObjTmgDesc;
    m_MSC  :=  TMObjTimings(m_list[0]).m_ObjMSC;

    m_tgtRes := resObj
  end
end;

//----------------------------------------------------------------------------//

procedure TMCalcTimings.SetByDescr(Descr: string);
var
  oTmg: TMObjTimings;
  i, j: integer;
  pTmg: PTRecTmg;
begin
  Assert(Assigned(m_tgtRes));
  m_ExeMin := 0;
  m_origexeMin := 0;

  for i := 0 to m_list.Count -1 do
  begin
    oTmg := TMObjTimings(m_list[i]);
    for j := 0 to oTmg.m_ValidRecList.Count -1 do
    begin
      pTmg := PTRecTmg(oTmg.m_ValidRecList[j]);

      if (pTmg.description = Descr)  then
      begin
        m_SupMin  := pTmg.supTime;
        m_origSetupMin := m_SupMin;

        if not oTmg.m_timingInfo.IgnorExeTimeWhenGrp then
        begin
          m_ExeMin  := m_ExeMin + pTmg.exeTime;
          m_origexeMin := m_origexeMin + pTmg.exeTimeOrig;
        end;

        m_TmgDescr := pTmg.description;  //pTmg.MachSetupCode;
        m_MSC := pTmg.MachSetupCode;

        m_wkcCode := pTmg.wkcCode;
        m_wkcProc := pTmg.wkcProc;
        m_resCode := pTmg.resCode;
        m_resCat  := pTmg.resCat;
        break;
      end;
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure TMCalcTimings.GetMainTimingsOrig(var supMin, exeMin: double; var TmgDescr: string; var TmgMSC: string);
begin
  Assert(Assigned(m_tgtRes));
  supMin := m_origSetupMin;
  exeMin := m_origexeMin;
  TmgDescr := m_TmgDescr;
  TmgMSC := m_MSC;
end;

//----------------------------------------------------------------------------//

procedure TMCalcTimings.GetMainTimings(var supMin, exeMin: double; var TmgDescr: string; var TmgMSC: string);
var
  CalcExeMin : double;
begin
  Assert(Assigned(m_tgtRes));
  supMin := m_supMin;
  exeMin := m_exeMin;
  TmgDescr := m_TmgDescr;
  TmgMSC := m_MSC;
  if p_sc.GetWorkCenterOccupationValue(m_Id ,CalcExeMin) then
     exeMin := CalcExeMin;
end;

//----------------------------------------------------------------------------//

procedure TMCalcTimings.GetResCatWrkCntrProcessCalcTiming(var WkCentr : string; var Process : string; var Res : string; var CatRes : string);
begin
  Assert(Assigned(m_tgtRes));
  WkCentr := m_wkcCode;
  Process := m_wkcProc;
  Res     := m_resCode;
  CatRes  := m_resCat
end;

//----------------------------------------------------------------------------//
//  This function populates the combo box list
//  CBoxTimeSele of FMOccMov ( TFMOccMove.FormShow )
//
//----------------------------------------------------------------------------//
procedure TMCalcTimings.GetDescList(DescList: TStringList);
var
  oTmg: TMObjTimings;
  i, j: integer;
  pTmg: PTRecTmg;
  ST_List: Tlist;
begin
  St_List := Tlist.Create;
  Assert(Assigned(m_tgtRes));
  DescList.Clear;

  for i := 0 to m_list.Count -1 do
  begin
    oTmg := TMObjTimings(m_list[i]);
    for j := 0 to oTmg.m_ValidRecList.Count -1 do
    begin
      pTmg := PTRecTmg(oTmg.m_ValidRecList[j]);
      St_List.Add(pTmg);
      //DescList.Add(pTmg.description);
    end;
  end;
{$ifdef ARO}
  St_List.Sort(SortSTBySeq); // sort by sequence
{$endif}

  for i := 0 to St_List.Count -1 do
  begin
    pTmg := PTRecTmg(St_List[i]);
    DescList.Add(pTmg.description);
  end;
  St_List.Free;
end;

//----------------------------------------------------------------------------//

function TMCalcTimings.GetNumSubs: integer;
begin
  Result := m_list.Count
end;

//----------------------------------------------------------------------------//

procedure TMCalcTimings.GetSubTimings(pos: integer; var id: TSchedId; var supMin, exeMin: double; var TmgDescr: string; var TmgMSC: string);
var
  oTmg: TMObjTimings;
begin
  Assert(Assigned(m_tgtRes));
  Assert((pos >= 0) and (pos < m_list.Count));
  oTmg := TMObjTimings(m_list[pos]);
  oTmg.GetSubTimings(id, supMin, exeMin, TmgDescr, TmgMSC)
end;

//----------------------------------------------------------------------------//

procedure TMCalcTimings.GetResCatWrkCntrProcessSubTimings(pos: integer; var id: TSchedId; var WkCentr : string; var Process : string; var Res : string; var CatRes : string);
var
  oTmg: TMObjTimings;
begin
  Assert(Assigned(m_tgtRes));
  Assert((pos >= 0) and (pos < m_list.Count));
  oTmg := TMObjTimings(m_list[pos]);
  oTmg.GetResCatWrkCntrProcessSubTimings(id, WkCentr, Process, Res, CatRes)
end;

//----------------------------------------------------------------------------//
{
  This procedure loops over all MSC(Machine Setup Codes) and finds
  those that are valid for our job and keeps them in m_ValidMSC
}
//----------------------------------------------------------------------------//

procedure TMObjTimings.getValidMachineSUList(WrkCtr,WrkProc: string);
var
 i: Integer;
 pMsc:   PTMachineSetup;
begin
   m_ValidMSC.Clear;

   for i:= 0 to MSC_List.Count-1 do
   begin
      pMsc := MSC_List.Items[i];
      if pMsc.wkcCode =  WrkCtr then
        if pMsc.wkcProc = WrkProc then
          m_ValidMSC.Add(pMsc);
   end;
 {
   if m_ValidMSC.Count > 0 then
  begin
    m_ValidMSC.Sort(SortMSBySeq);
   end;
   }
end;

//----------------------------------------------------------------------------//
{
// This creates the Timings object.
// This Object has all the ST for this id's Prod req & step job.
// We make an SQL from Prod_Step_times and get all ST
// and stores them in m_recList. The list may have
// non valid ST so to get only the valid ones we check them all
// and keep them in m_ValidRecList ( this is done in FindAll) .
// we keep all valid Machine setup codes in m_ValidMSC (in getValidMachineSUList)
//
// @param id           the id of the job for which we are creating the times obj
// @param machine_List the list of all Machine setup codes ( MQMMS) we keep
//                      this list in MSC_List
//
}
//----------------------------------------------------------------------------//

constructor TMObjTimings.CreateObj(id: TSchedId; machine_List: Tlist);
var
  pTmg:   PTRecTmg;
  wkcProc: string;
  TimeList : TList;
  I : Integer;
  NewTime, NewSetup, NewJobSetup : double;
//  TimeOverriden : boolean;
  IsSpeedChanged, IsSetUpChanged, IsJobSetUpChanged : boolean;
begin
  inherited Create;
//  TimeOverriden := false;
  m_recList := TList.Create;
  m_ValidRecList := TList.Create;
  m_ValidMSC:=      TList.Create;

  m_id      := id;

  TimeList := p_sc.GetProdReqDetTimeList(m_id);

  p_sc.GetNewTimeIfSpeedChanged(id, NewTime, NewSetup, NewJobSetup, IsSpeedChanged, IsSetUpChanged, IsJobSetUpChanged);
    //TimeOverriden := true;

  for I := 0 to TimeList.count - 1 do
  begin
    New(pTmg);

    pTmg.wkcCode        := PTRecTiming(TimeList[I]).wkcCode;
    pTmg.wkcProc        := PTRecTiming(TimeList[I]).wkcProc;
    pTmg.resCat         := PTRecTiming(TimeList[I]).resCat;
    pTmg.resCode        := PTRecTiming(TimeList[I]).resCode;
    pTmg.supTime        := PTRecTiming(TimeList[I]).supTime;

    //if TimeOverriden then
    //begin
    if IsSpeedChanged then
      pTmg.exeTime := NewTime
    else
      pTmg.exeTime := PTRecTiming(TimeList[I]).exeTime;

    if IsSetUpChanged then
      pTmg.supTime := NewSetup
    else
      pTmg.supTime := PTRecTiming(TimeList[I]).supTime;

    if IsJobSetUpChanged then
      pTmg.supTime := NewJobSetup;
    //end;

    pTmg.exeTimeOrig      := PTRecTiming(TimeList[I]).exeTime;
    pTmg.supTimeOrig      := PTRecTiming(TimeList[I]).supTime;

    pTmg.description    := _('Default');

    m_recList.Add(pTmg);

  end;

end;

//----------------------------------------------------------------------------//

destructor TMObjTimings.Destroy;
var
  i:    integer;
  pTmg: PTRecTmg;
begin
  for i := m_recList.Count - 1 downto 0 do
  begin
    pTmg := PTRecTmg(m_recList[i]);
    Dispose(pTmg)
  end;

  m_recList.Free;
  m_ValidMSC.Free;
  m_ValidRecList.Free;
  MSC_List := nil;
  inherited Destroy

end;

//----------------------------------------------------------------------------//
//Itzik - I think this FindTheOne is just to check if there is
// at least one valid step time.
// If I'm wrong please tell me
//----------------------------------------------------------------------------//

function TMObjTimings.FindTheOne(wkcCode, wkcProc, resCode, resCat: string): PTRecTmg;
var
  i: integer;
begin
  for i := 0 to m_recList.Count-1 do
  begin
    Result := PTRecTmg(m_recList[i]);

  //  if (Result.wkcCode = wkcCode) and
  //     (Result.wkcProc = wkcProc) and
  //     (Result.resCat  = '')      and
    if (Result.resCode = resCode) then exit
  end;

  for i := 0 to m_recList.Count-1 do
  begin
    Result := PTRecTmg(m_recList[i]);

    if (Result.wkcCode = wkcCode) and
       (Result.wkcProc = wkcProc) and
       (Result.resCat  = resCat)  and
       (Result.resCode = '')      then exit
  end;

  for i := 0 to m_recList.Count-1 do
  begin
    Result := PTRecTmg(m_recList[i]);

    if (Result.wkcCode = wkcCode) and
       (Result.wkcProc = wkcProc) and
       (Result.resCat  = '') and
       (Result.resCode = '') then exit
  end;

  for i := 0 to m_recList.Count-1 do
  begin
    Result := PTRecTmg(m_recList[i]);

    if (Result.wkcCode = '') and
       (Result.wkcProc = '') and
       (Result.resCat  = '') and
       (Result.resCode = '') then exit
  end;

  Result := nil;
end;

//----------------------------------------------------------------------------//
// This function fills the m_ValidRecList list with all the valid and possible
// values of ST
//
//----------------------------------------------------------------------------//
procedure TMObjTimings.FindAll(wkcCode, wkcProc, resCode, resCat: string; TmgList: TList);
var
  i,j: integer;
  RecTmg: PTRecTmg;
  MachineSU:   PTMachineSetup;
begin
  TmgList.Clear;
 { getValidMachineSUList(wkcCode,wkcProc);

  for j := 0 to m_ValidMSC.Count-1 do
    begin
    for i := 0 to m_recList.Count-1 do
    begin
      RecTmg := PTRecTmg(m_recList[i]);
      MachineSU :=  PTMachineSetup(m_ValidMSC[j]);
      if (RecTmg.MachSetupCode = MachineSU.MachSetupCode) and
         (RecTmg.wkcCode = MachineSU.wkcCode) and
         (RecTmg.wkcProc = MachineSU.wkcProc) and
         (RecTmg.resCat  = MachineSU.resCat) and
         (RecTmg.resCode = MachineSU.resCode) then
          begin
            RecTmg.description := MachineSU.Description;
          end;
    end;//i
  end;//j   }

  for i := 0 to m_recList.Count-1 do
  begin
    RecTmg := PTRecTmg(m_recList[i]);
   // if (RecTmg.wkcCode = wkcCode) and
   //    (RecTmg.wkcProc = wkcProc) and
   //    (RecTmg.resCat  = '')  and
    if (RecTmg.resCode = resCode) then
    begin
      if TmgList.IndexOf(RecTmg) = -1 then
        TmgList.Add(RecTmg);
    end;
  end;

  for i := 0 to m_recList.Count-1 do
  begin
    RecTmg := PTRecTmg(m_recList[i]);

    if (RecTmg.wkcCode = wkcCode) and
       (RecTmg.wkcProc = wkcProc) and
       (RecTmg.resCat  = resCat) and
       (RecTmg.resCode = '') then
    begin
      if TmgList.IndexOf(RecTmg) = -1 then
        TmgList.Add(RecTmg);
    end;
  end;

  for i := 0 to m_recList.Count-1 do
  begin
    RecTmg := PTRecTmg(m_recList[i]);

    if (RecTmg.wkcCode = wkcCode) and
       (RecTmg.wkcProc = wkcProc) and
       (RecTmg.resCat  = '') and
       (RecTmg.resCode = '') then
    begin
      if TmgList.IndexOf(RecTmg) = -1 then
        TmgList.Add(RecTmg);
    end;
  end;

  for i := 0 to m_recList.Count-1 do
  begin
    RecTmg := PTRecTmg(m_recList[i]);

    if (RecTmg.wkcCode = '') and
       (RecTmg.wkcProc = '') and
       (RecTmg.resCat  = '') and
       (RecTmg.resCode = '') then
    begin
      if TmgList.IndexOf(RecTmg) = -1 then
        TmgList.Add(RecTmg);
    end;
  end;


end;

//----------------------------------------------------------------------------//

function TMObjTimings.CanGoOnRes(resObj: TObject): boolean;
var
  pTmg:    PTRecTmg;
  wkcCode,
  wkcProc,
  resCode,
  resCat:  string;
  pInfo:   TSQtimingInfo;
  res:     TMqmRes;
  WrkCtr: TMqmWrkCtr;
begin
  Result := false;
  p_sc.GetTimingInfo(m_id, pInfo);

  res := TMqmRes(resObj);
  wkcCode := TMqmWrkCtr(res.p_father).p_WrkCtrCode;
  if (wkcCode = pInfo.wkctCode) then
    wkcProc := pInfo.wcProc
  else
  begin
    WrkCtr := TMqmWrkCtr(p_sc.GetWrkCtrPtr(m_id));
    if not WrkCtr.GetAltProcForAltWrkCtr(pInfo.wcProc, wkcCode, wkcProc) then
      exit;
//    wkcCode := WrkCtr.p_WrkCtrCode
  end;
  resCode := res.p_ResCode;
  resCat  := res.m_ResCat.p_ResCatCode;
  pTmg := FindTheOne(wkcCode, wkcProc, resCode, resCat);
  Result := Assigned(pTmg)
end;

//----------------------------------------------------------------------------//

procedure TMObjTimings.SetObjTargetRes(resObj: TObject);
var
  pTmg:    PTRecTmg;
  wkcCode,
  wkcProc,
  resCode,
  resCat:  string;
  pInfo:   TSQtimingInfo;
  res:     TMqmRes;
  WrkCtr: TMqmWrkCtr;
begin
  p_sc.GetTimingInfo(m_id, pInfo);

  res := TMqmRes(resObj);
  wkcCode := TMqmWrkCtr(res.p_father).p_WrkCtrCode;
  if (wkcCode = pInfo.wkctCode) then
    wkcProc := pInfo.wcProc
  else
  begin
    WrkCtr := TMqmWrkCtr(p_sc.GetWrkCtrPtr(m_id));
    if WrkCtr = nil then
      wkcProc := pInfo.wcProc
    else
      if not WrkCtr.GetAltProcForAltWrkCtr(pInfo.wcProc, wkcCode, wkcProc) then
        exit;
//    wkcCode := WrkCtr.p_WrkCtrCode
  end;
  resCode := res.p_ResCode;
  resCat  := res.m_ResCat.p_ResCatCode;
  //Itzik - I think this FindTheOne is just to check if there is
  // at least one valid step time if there is then
  // find all of them that are valid
  pTmg := FindTheOne(wkcCode, wkcProc, resCode, resCat);
 // Assert(Assigned(pTmg));
//  if not assigned(pTmg) then

  FindAll(wkcCode, wkcProc, resCode, resCat,  m_ValidRecList);

  if not assigned(pTmg) then
  begin
    exit;
  end;

  m_ObjSupMin  := pTmg.supTime;
  m_ObjExeMin  := pTmg.exeTime;
  m_ObjExeMinOrig := pTmg.exeTimeOrig;
  m_ObjSupMinOrig := pTmg.supTimeOrig;

 // m_ObjTmgDesc := pTmg.TimeDescr
  m_ObjTmgDesc := pTmg.description;   //pTmg.MachSetupCode;
  m_ObjMSC := pTmg.MachSetupCode;

  m_ObjwkcCode := pTmg.wkcCode;
  m_ObjwkcProc := pTmg.wkcProc;
  m_ObjresCode := pTmg.resCode;
  m_ObjresCat  := pTmg.resCat

end;

//----------------------------------------------------------------------------//

procedure TMObjTimings.GetSubTimings(var id: TSchedId; var supMin, exeMin: double; var TmgDescr: string; var TmgMSC: string);
begin
  id     := m_id;
  supMin := m_ObjSupMin;
  exeMin := m_ObjExeMin;
  TmgDescr := m_ObjTmgDesc;
  TmgMSC := m_ObjMSC;
end;

//----------------------------------------------------------------------------//

procedure TMObjTimings.GetResCatWrkCntrProcessSubTimings(var id: TSchedId; var WkCentr : string; var Process : string; var Res : string; var CatRes : string);
begin
  id      := m_id;
  WkCentr := m_ObjwkcCode;
  Process := m_ObjwkcProc;
  Res     := m_ObjresCode;
  CatRes  := m_ObjresCat;
end;

//----------------------------------------------------------------------------//

{$ifdef ARO}
//----------------------------------------------------------------------------//
// Sorts the list of Step times (ST) by the sequence.
// It is used just once to sort the combobox on the move
// form

function SortSTBySeq(Item1, Item2: Pointer): integer;
var
  pTmg1, pTmg2:    PTRecTmg;

begin
  pTmg1 := PTRecTmg(Item1);
  pTmg2 := PTRecTmg(Item2);

  if      pTmg1.Sequence = pTmg2.Sequence then Result :=  0
  else if pTmg1.Sequence < pTmg2.Sequence then Result := -1
  else                                           Result :=  1
end;
{$endif}

//----------------------------------------------------------------------------//

function GetAddtionalTimeExeForCurve(Id : TSchedId; RemainExecutionTime : double; CurveTimeToIgnore : double) : double;
var
  // RemainExecutionTime = Remain executiuon time without learning curve affect
  // CurveTimeToIgnore = Total time passed with learning curve affect

  Curr_Exec : double;
  CurvePercent : integer;
  CurveMinutes : double;
  CurveMinutesIgnoringCurve : Double;
  RemainingProgressToConsider : Double;

  I : integer;
  FirstCurveHrs, SecondCurveHrs, ThirdCurveHrs, ForthCurveHrs, FifthCurveHrs,
  SixthCurveHrs, SeventhCurveHrs, EighthCurveHrs : double;
  FirstCurvePrc,SecondCurvePrc,ThirdCurvePrc,ForthCurvePrc,FifthCurvePrc,
  SixthCurvePrc,SevenThCurvePrc,EighthCurvePrc : integer;

  begin
  Result := 0;
  CurveMinutes := 0;
  CurvePercent := 0;
  RemainingProgressToConsider := CurveTimeToIgnore;
//  Curr_Exec := ExecutionTime - ProgressedTime;
  Curr_Exec := RemainExecutionTime;

  if Curr_Exec <=0 then exit;

  if not GetDataForCurveCode(p_sc.GetLearningCurveCode(id), FirstCurveHrs,FirstCurvePrc,
       SecondCurveHrs,SecondCurvePrc,ThirdCurveHrs,ThirdCurvePrc,
       ForthCurveHrs,ForthCurvePrc,FifthCurveHrs,FifthCurvePrc,
       SixthCurveHrs,SixthCurvePrc,SeventhCurveHrs,SeventhCurvePrc,
       EighthCurveHrs,EighthCurvePrc) then exit;

  for I := 1 to 8 do
  begin

    if I = 1 then
    begin
      CurveMinutes :=  FirstCurveHrs * 60;
      CurvePercent :=  FirstCurvePrc;
    end;
    if I = 2 then
    begin
      CurveMinutes :=  SecondCurveHrs * 60;
      CurvePercent :=  SecondCurvePrc;
    end;
    if I = 3 then
    begin
      CurveMinutes :=  ThirdCurveHrs * 60;
      CurvePercent :=  ThirdCurvePrc;
    end;
    if I = 4 then
    begin
      CurveMinutes :=  ForthCurveHrs * 60;
      CurvePercent :=  ForthCurvePrc;
    end;
    if I = 5 then
    begin
      CurveMinutes :=  FifthCurveHrs * 60;
      CurvePercent :=  FifthCurvePrc;
    end;
    if I = 6 then
    begin
      CurveMinutes :=  SixthCurveHrs * 60;
      CurvePercent :=  SixthCurvePrc;
    end;
    if I = 7 then
    begin
      CurveMinutes :=  SeventhCurveHrs * 60;
      CurvePercent :=  SeventhCurvePrc;
    end;
    if I = 8 then
    begin
      CurveMinutes :=  EighthCurveHrs * 60;
      CurvePercent :=  EighthCurvePrc;
    end;

    if (CurveMinutes <=0) or (CurvePercent <=0) then  continue;

    if CurveMinutes <= RemainingProgressToConsider  then
    begin
      RemainingProgressToConsider := RemainingProgressToConsider - CurveMinutes;
      Continue;
    end;

    CurveMinutes := CurveMinutes - RemainingProgressToConsider;
    RemainingProgressToConsider := 0;

    CurveMinutesIgnoringCurve := CurveMinutes * (CurvePercent/100);

    if CurveMinutesIgnoringCurve < Curr_Exec then
    begin
      Result := Result + CurveMinutes - CurveMinutesIgnoringCurve;
      Curr_Exec := Curr_Exec - CurveMinutesIgnoringCurve;
      Continue;
    end;

    Result := Result + ((Curr_Exec / (CurvePercent/100)) - Curr_Exec);
    break;

  end;

end;

//----------------------------------------------------------------------------//

function GetMinutesExcludeLearningCurveAffect(Id : TSchedId; MinuteToStartFrom, NumberOfMinutes : double) : double;
var
  FirstCurveHrs, SecondCurveHrs, ThirdCurveHrs, ForthCurveHrs, FifthCurveHrs,
  SixthCurveHrs, SeventhCurveHrs, EighthCurveHrs : double;
  FirstCurvePrc,SecondCurvePrc,ThirdCurvePrc,ForthCurvePrc,FifthCurvePrc,
  SixthCurvePrc,SevenThCurvePrc,EighthCurvePrc : integer;
  CurveMinutes : double;
  CurvePercent : integer;
  MinutesToSkip, MinutesRemain : double;
  I : Integer;
begin
  CurveMinutes := 0;
  CurvePercent := 0;
  MinutesToSkip := MinuteToStartFrom;
  MinutesRemain := NumberOfMinutes;

  Result := NumberOfMinutes;
  if not GetDataForCurveCode(p_sc.GetLearningCurveCode(id), FirstCurveHrs,FirstCurvePrc,
       SecondCurveHrs,SecondCurvePrc,ThirdCurveHrs,ThirdCurvePrc,
       ForthCurveHrs,ForthCurvePrc,FifthCurveHrs,FifthCurvePrc,
       SixthCurveHrs,SixthCurvePrc,SeventhCurveHrs,SeventhCurvePrc,
       EighthCurveHrs,EighthCurvePrc) then exit;

  Result := 0;
  for I := 1 to 8 do
  begin
    if I = 1 then
    begin
      CurveMinutes :=  FirstCurveHrs * 60;
      CurvePercent :=  FirstCurvePrc;
    end;
    if I = 2 then
    begin
      CurveMinutes :=  SecondCurveHrs * 60;
      CurvePercent :=  SecondCurvePrc;
    end;
    if I = 3 then
    begin
      CurveMinutes :=  ThirdCurveHrs * 60;
      CurvePercent :=  ThirdCurvePrc;
    end;
    if I = 4 then
    begin
      CurveMinutes :=  ForthCurveHrs * 60;
      CurvePercent :=  ForthCurvePrc;
    end;
    if I = 5 then
    begin
      CurveMinutes :=  FifthCurveHrs * 60;
      CurvePercent :=  FifthCurvePrc;
    end;
    if I = 6 then
    begin
      CurveMinutes :=  SixthCurveHrs * 60;
      CurvePercent :=  SixthCurvePrc;
    end;
    if I = 7 then
    begin
      CurveMinutes :=  SeventhCurveHrs * 60;
      CurvePercent :=  SeventhCurvePrc;
    end;
    if I = 8 then
    begin
      CurveMinutes :=  EighthCurveHrs * 60;
      CurvePercent :=  EighthCurvePrc;
    end;

    if (CurveMinutes <=0) or (CurvePercent <=0) then  continue;

    if CurveMinutes <= MinutesToSkip then
    begin
      MinutesToSkip := MinutesToSkip - CurveMinutes;
      continue;
    end;

    CurveMinutes := CurveMinutes - MinutesToSkip;
    MinutesToSkip := 0;

    if CurveMinutes < MinutesRemain then
    begin
      Result := Result + CurveMinutes * CurvePercent/100;
      MinutesRemain := MinutesRemain - CurveMinutes;
      continue;
    end;

    Result := Result + MinutesRemain * CurvePercent/100;
    MinutesRemain := 0;
    break;
  end;

  Result := Result + MinutesRemain;

end;

//----------------------------------------------------------------------------//

procedure Ini_SchedContTime;
begin
  m_SchedContTime := TList.Create;
end;

//----------------------------------------------------------------------------//

procedure Destroy_SchedContTime(FreeList : boolean);
var
  I : Integer;
begin
  for i := m_SchedContTime.Count-1 downto 0 do
    TMObjTimings(m_SchedContTime[i]).Free;
  m_SchedContTime.Clear;
  if FreeList then
    m_SchedContTime.Free;
end;

//----------------------------------------------------------------------------//

initialization

  Ini_SchedContTime;

// -------------------------------------------------------------------------- //

finalization

  Destroy_SchedContTime(true);

// -------------------------------------------------------------------------- //

end.

