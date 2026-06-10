unit UMReportExport;

{ This unit executes all exports. All HTML and Excel files are created here. }

interface
uses
  classes, Dialogs, SysUtils, UMSchedContFunc, UMBinGrid, gnugettext, mxNativeExcel, UGshiftCal, Vcl.OleCtnrs,
   UMActArea, UGbaseCal,
  CheckLst, Graphics, UMBinDefault, windows;

type
  TRecordStatus = (REC_OK, REC_BREAK, REC_BREAK_RES, REC_BREAK_GROUP, REC_BREAK_RES_GROUP);


  TSettings = record
    NativeExcel      : TmxNativeExcel;
    SaveFileLocation : string;
    ChkLstBoxRsc     : TCheckListBox;
    ReportType       : string;
    DateFrom         : TDateTime;
    DateTo           : TDateTime;
    MaxRows          : Integer;
    MaxCols          : Integer;
    ShowBinCaption   : boolean;
    ShowBinCaptionBinReport : boolean;
    ShowCriteria     : boolean;
    NewPagePerRes    : boolean;
    IncDowntime      : boolean;
    ShowUnschedJobs  : boolean;
    IsExportReport   : boolean;
    IsBinReport      : boolean;
    SchedJobs        : Integer;
    UnschedJobs      : Integer;
    SchedQuantity    : double;
    UnschedQuantity  : double;
    Comment          : string;
    FontBinCaption   : TFont;
    FontCriteria     : TFont;
    FontComment      : TFont;
    FontColTitles    : TFont;
    FontDataLine     : TFont;
    HtmlColorBack    : TColor;
    HtmlColorTabTitle: TColor;
    HtmlColorTabEven : TColor;
    HtmlColorTabOdd  : TColor;
    ExcelTitle       : string;
    ExcelTitleBinReport : string;
    GroupingFields   : Integer;
    PrintComments  : boolean;
    ColumnComments   : integer;
    JumpingFields    : Integer;
    ShowGroups       : boolean;
    ShowResources    : boolean;
    // Only for Bucket Reports
    BucketContent    : Integer;
    BucketNumber     : Integer;
    RoundLevel       : Integer;
    BucketSize       : Double;
    SumBucketsQty    : Double;
    Report_Date_From : Double;
    SheetName        : String;
    ShowExcel        : boolean;
    BinFieldsArray : array [0..High(BinColDefault)] of TBinColCurrent;
    BinFieldArrayReport : array [1..10] of TBinColCurrent;
    ShiftArray : array of PTShiftData;
    BucketByShift : boolean;
    FixColumnsReport : boolean;
    concatenation : boolean;
    Separator     : String;
    HeadingConcatenation : boolean;
    HeadingSeparator     : String;
    ShowColumnsCaptions    : boolean;
    ShowColumnsCaptionsBinReport  : boolean;
    ShowTotal       : boolean;

    GroupList : TStringList;
    StartingDate : integer;
    IsPeriodMachineReport : boolean;
    MachineReportPeriodTitle        : string;
    MachineReportPeriod       : string;
    MachineReportPeriodFrom         : string;
    MachineReportNumPeriod  : string;
    MachineReportShowFromToHeader : boolean;
    MachineReportFileNameAutoOperation : string;
    MachineReportEditTodayMinusDays : string;
    GroupType : Integer;
    //ShowTotal     : boolean;
  end;
  PTSettings = ^TSettings;

type
  TResourceDet = record
    ID:           Integer;
    ResCode:      string;
    SubResCode:   string;
    ResDesc:      string;
    SchedStart:   string;
    SchedEnd:     string;
    ProgStart:    string;
    Downtime:     boolean;
    DownTimeFrom: string;
    DownTimeTo:   string;
    Comment:      string;
    ScheduleType : string;
    FreeResStart  : TDateTime;
    FreeResEnd  : TDateTime;
    FreeTimeHours: double;
    FromPlanInfo_StartDate : TDateTime;
    FromPlanInfo_EndDate   : TDateTime;
    FromPlanInfo_OrigExe   : double;
    FromPlanInfo_Exe       : double;
    IsProgress             : boolean;
    Cal      : TPGCALObj;
    actarea  : TMqmActArea;
    Exe      : double;
    SetUp    : double;
  end;
  PTResourceDet = ^TResourceDet;

  type TotalGrp = Record
    BucketNum : integer;
    Res : String;
  end;
  RTotalGrp = ^TotalGrp;

  type
  TIDGRP = Record
    IDGrpList : String;
    ID  : TschedID;
    idGroup : integer;
  end;
  RTIdGrp = ^TIDGRP;

  function CheckifExcelInstalled: boolean;
  function ExcelFreeResScheduleExport(ReportSettings: TSettings): boolean;
  function DynamicScheduleExport(ReportSettings: TSettings; IsFromReport : boolean): boolean;
  function PeriodMachineReport(ReportSettings: TSettings; IsFromReport : boolean): boolean;
  function BinExtractionReport(ReportSettings: TSettings): boolean;
  function ShowBinExtractionByDate(ReportSettings: TSettings; StartDate : TDateTime; EndDate : TDateTime; DateFilter : Integer): boolean;
  procedure PrintFixedResourceReport(ReportSettings: TSettings);
  function WriteFreeResExcelFile(ResList: TList; ReportSettings: TSettings): boolean;
  function WriteExcelFilePeriodMachine(JobList: TList; showResource: boolean;  ReportSettings: TSettings; var XLApp: OLEVariant; ResCode : string; ExcelInstalled: Boolean): boolean;
  function WriteExcelFile(JobList: TList; showResource: boolean;
           ReportSettings: TSettings): boolean;
  Procedure WriteValuesForExcel(Value : variant; Row, Column : Integer; Sheet: OLEVariant; ExcelInstalled : Boolean);
  function WriteHtmlFile(JobList: TList; showResource: boolean;
           ReportSettings: TSettings; IsFromReport : boolean): boolean;
  function FontStyleToHtml(fontStyles: TFontStyles): string;
  function ColorHexaToHtml(color: TColor): string;
  function IsClosed(Job: TSchedID): boolean;
  function IsEmptyDateTime(Arg: string): Boolean;
  function IsProperty(ColId: CBinColId): Boolean;
  procedure FixAlphaStructure(ColId: CBinColId; var Value : string);
  function GetPropertyDesc(Acol: Integer; BinGrid: TBinDrawGrid): string;
  procedure SetReportFonts(var ReportSettings: TSettings);
  function FontStylesToString(fontStyles: TFontStyles): string;
  function StringToFontStyles(fontStylesStr: string): TFontStyles;
  function SortCapRes(Resource1, Resource2: pointer): Integer;
  function SetBackslash: string;
  // rest of functions only for bucket report with real Excel
  function IsNumeric(Arg: string; numType: char): Boolean;
  function BucketReport(ReportSettings: TSettings): string;
  function WriteCompareBucketExcel(var set1 : TList;ReportSettings: TSettings): string;
  function WriteBucketExcelFile(JobList, CapResList: TList; NumberOfResources: Integer; ReportSettings: TSettings): string;
  function WriteGroupBucketExcelFile(JobList, CapResList: TList; NumberOfResources: Integer; ReportSettings: TSettings): string;
//  function WriteBucketNonExcelFile(JobList: TList; ShowResource: boolean; ReportSettings: TSettings): boolean;
  procedure CalculateBucketRange(BucketNo: Integer; var Bucket_date_from: Double;
            var Bucket_date_to: Double; Report_date_from, BucketSize: Double);
  function CalculateJobQuantityInBucket(Id: TSchedId; FromDateTime, ToDateTime : TDateTime; RoundLevel: Integer; TimeOfFamilyBeforeId : double) : Double;

  Function CreateXML(xml, FileName: String): String;
  Function GenerateXML(NumOfSh : integer): String;
  Function AddValueToXML(BinData: Variant; SheetName : String): String;

  function CreateExcel(BinData: Variant; FileName : String): string;
  function CreateExcelSheet(BinData: Variant; ColumnType: Array of Integer;
           FileName, SheetName: String; ShowExcel: boolean; TextColumn : Integer): string;
  function RefToCell(RowID, ColID: Integer): string;
  procedure ColorExcelSheet(Sheet: OLEVariant; ColCount, RowCount: Integer);
  procedure FormatExcelSheet(Sheet: OLEVariant; ColumnType: Array of Integer; RowNum: Integer);
  procedure CalculateDateTo(BucketNumber: Integer; var Date_to: Double;
            BucketSize, Time_from: Double; var Date_from: Double);
  procedure CalculateDateToShift(BucketNumber: Integer; var Date_to: Double;
            BucketSize, Time_from: Double; var Date_from: Double; var Report : TSettings ; CalCode : string);
  function GrpBucketReport(ReportSettings: TSettings): string;
const
  HTML_REPORT_NAME = 'BinSchedReport_default_#';
  HTML_REPORT_FULL = 'BinSchedReport_default_#1.html';
  SUBRESSEPARATOR = ', Sub ';

var
  noOfHtmlPages: Integer;
  BinData : Variant;
  CapResList : TList;
//  XLApp: OLEVariant;
implementation

uses
  Variants,
  UMMessageFilter,
  ComObj,
  UMpgCal,
  FMBin,
  UMBinTbs,
  UMBinPanel,
  UMGlobal,
  UMSchedCont,
  UMObjCont,
  FMBinTotals,
  UMRes,
  FMMainPlan,
  UMCapRes,
  UMCompatSrv,
  UMCompat,
  UMCommon,
  UMPlanObj,
  UMWkctr,
  DateUtils,
  StrUtils,
  DMsrvPc,
  UMTblDesc,
  FmAutoRunSet,
  UMCalcTimings,
  UMSchedObjMover,
  Math, UMPlanTbs, FMCompareSavedBuckets,
  FMBinReport;

//----------------------------------------------------------------------------//
{ A Job List is created that is finally passed to the file creation area. All
  scheduled (and if chosen also unscheduled) jobs from the actual Bin are
  collected and their IDs stored in the Job List.
  @param ReportSettings   Report settings given by calling classes }
//----------------------------------------------------------------------------//

function BinExtractionReport(ReportSettings: TSettings): boolean;
var
  Value             : Variant;
  ActBinGrid        : TBinDrawGrid;
  id           : TSchedID;
  dataType          : CBinColValType;
  showResource      : boolean;
  JobList           : TList;
  i,
  includedResources : Integer;
  TotSetup,
  TotExe            : Double;
  ResDet            : PTResourceDet;
  LastRes           : string;
  res               : TMqmRes;
  visRes : TMqmVisibleRes;
begin
  Result := false;
  ActBinGrid := FBin.GetActiveView.GetBinGrid;
  JobList := TList.Create;
  includedResources := 0;
  LastRes := '';

  // Create Job List and count resources
  for i := 0 to TBinPanel(ActBinGrid.Parent).m_ObjList.GetLinkCount do
  begin
    id := TSchedId(TBinPanel(ActBinGrid.Parent).m_ObjList.GetLink(i));
    if (id <> CSchedIdNull) and ((p_sc.GetSchedType(id) <> '0') or
      ((p_sc.GetSchedType(id) = '0') and ReportSettings.ShowUnschedJobs)) then
    begin
      new(ResDet);
      p_sc.GetFldValue(id, CSC_Rsc, Value, dataType);
      ResDet.ResCode := VarToStr(Value);
      ResDet.SubResCode := '';
      res := TMqmRes(p_pl.FindResByCode(ResDet.ResCode));
      if Assigned(res) and res.p_isMultiRes and Assigned(p_sc.getExtLinkPtr(id))
        and Assigned(TMqmPlanObj(p_sc.getExtLinkPtr(id)).p_Father) then
      begin
        visRes := TMqmVisibleRes(TMqmActArea(p_sc.getExtLinkPtr(id)).p_Father);
        if Assigned(visRes) then ResDet.SubResCode := IntToStr(visRes.p_SubCode);
      end;
      if LastRes <> ResDet.ResCode then
      begin
        LastRes := ResDet.ResCode;
        Inc(includedResources);
      end;
      p_sc.GetFldValue(id, CSC_RscDesc, Value, dataType);
      ResDet.ResDesc := VarToStr(Value);
      ResDet.ID := id;
      p_sc.GetFldValue(id, CSC_SchedStart, Value, dataType);
      ResDet.SchedStart := VarToStr(Value);
      p_sc.GetFldValue(id, CSC_ProgStart, Value, dataType);
      ResDet.ProgStart := VarToStr(Value);
      ResDet.Downtime := false;
      JobList.Add(ResDet);

      // we print in the report the bin , so , if in the bin there isnt any
      // show group line , we print only one line.
      // avi comment bellow 06/20/2019 for JJ

     { if p_sc.IsGroup(id) then
      begin
        grp := id;
        for G := 1 to p_sc.GetGrpNumSons(grp) - 1 do
        begin
          Id := p_sc.GetGrpSon(grp, G);
          new(ResDet);
          p_sc.GetFldValue(id, CSC_Rsc, Value, dataType);
          ResDet.ResCode := VarToStr(Value);

          ResDet.SubResCode := '';
          res := TMqmRes(p_pl.FindResByCode(ResDet.ResCode));
          if Assigned(res) and res.p_isMultiRes and Assigned(p_sc.getExtLinkPtr(id))
            and Assigned(TMqmPlanObj(p_sc.getExtLinkPtr(id)).p_Father) then
          begin
            visResSub := TMqmVisibleRes(TMqmActArea(p_sc.getExtLinkPtr(id)).p_Father);
            if Assigned(visResSub) then ResDet.SubResCode := IntToStr(visResSub.p_SubCode);
          end;
          p_sc.GetFldValue(id, CSC_RscDesc, Value, dataType);
          ResDet.ResDesc := VarToStr(Value);
          ResDet.Downtime := false;
          ResDet.ID := id;
          p_sc.GetFldValue(id, CSC_SchedStart, Value, dataType);
          ResDet.SchedStart := VarToStr(Value);
          p_sc.GetFldValue(id, CSC_ProgStart, Value, dataType);
          ResDet.ProgStart := VarToStr(Value);
          JobList.Add(ResDet);
        end;
      end;    }

    end;
  end;

  // Call Write-File-Functions and calculate Bin Totals for HTML Bin Extraction
  if JobList.Count <= 0 then
    MessageDlg(_('No jobs found'), mtInformation, [mbOK], 0)
  else
  begin
    Result := true;
    showResource := includedResources = 1;

    //ReportSettings.ReportType := 'Excel';

    if ReportSettings.ReportType = 'Excel' then
      Result := WriteExcelFile(JobList, showResource, ReportSettings)
    //else if ReportSettings.ReportType = 'Non_Excel' then
     // Result := CreateExcel(JobList, ReportSettings.SaveFileLocation)
    else if ReportSettings.ReportType = 'Html' then
      begin
        CalcTotals(ReportSettings.UnschedJobs, ReportSettings.SchedJobs,
          ReportSettings.UnschedQuantity, ReportSettings.SchedQuantity, TotSetup, TotExe);
        Result := WriteHtmlFile(JobList, showResource, ReportSettings, true);
      end;
  end;
  JobList.Clear;
end;

//----------------------------------------------------------------------------//

function ShowBinExtractionByDate(ReportSettings: TSettings; StartDate : TDateTime; EndDate : TDateTime; DateFilter : Integer): boolean;
var
  Value             : Variant;
  ActBinGrid        : TBinDrawGrid;
  id                : TSchedID;
  dataType          : CBinColValType;
  showResource      : boolean;
  JobList           : TList;
  i,
  includedResources : Integer;
  TotSetup,
  TotExe            : Double;
  ResDet            : PTResourceDet;
  LastRes           : string;
  res               : TMqmRes;
  visRes            : TMqmVisibleRes;
  planInfo          : TSQplanInfo;
begin
  Result := false;
  ActBinGrid := FBin.GetActiveView.GetBinGrid;
  JobList := TList.Create;
  includedResources := 0;
  LastRes := '';

  // Create Job List and count resources
  for i := 0 to TBinPanel(ActBinGrid.Parent).m_ObjList.GetLinkCount do
  begin
    id := TSchedId(TBinPanel(ActBinGrid.Parent).m_ObjList.GetLink(i));
    if (id <> CSchedIdNull) and ((p_sc.GetSchedType(id) <> '0') or
      ((p_sc.GetSchedType(id) = '0') and ReportSettings.ShowUnschedJobs)) then
    begin
      p_sc.GetPlanInfo(id, planInfo);

      if (DateFilter = 0) then
      begin
        if (not planInfo.isOnPlan) then
           continue
        else
        begin
          if (planInfo.startDate < StartDate) or (planInfo.endDate > endDate) then
             continue;
        end;
      end
      else if (DateFilter = 1) then
      begin
        if (not planInfo.isOnPlan) then
           continue
        else
        begin
          if (planInfo.LastScheduleChanged < StartDate) or (planInfo.LastScheduleChanged > endDate) then
             continue;
        end;
      end;

      new(ResDet);
      p_sc.GetFldValue(id, CSC_Rsc, Value, dataType);
      ResDet.ResCode := VarToStr(Value);
      ResDet.SubResCode := '';
      res := TMqmRes(p_pl.FindResByCode(ResDet.ResCode));
      if Assigned(res) and res.p_isMultiRes and Assigned(p_sc.getExtLinkPtr(id))
        and Assigned(TMqmPlanObj(p_sc.getExtLinkPtr(id)).p_Father) then
      begin
        visRes := TMqmVisibleRes(TMqmActArea(p_sc.getExtLinkPtr(id)).p_Father);
        if Assigned(visRes) then ResDet.SubResCode := IntToStr(visRes.p_SubCode);
      end;
      if LastRes <> ResDet.ResCode then
      begin
        LastRes := ResDet.ResCode;
        Inc(includedResources);
      end;
      p_sc.GetFldValue(id, CSC_RscDesc, Value, dataType);
      ResDet.ResDesc := VarToStr(Value);
      ResDet.ID := id;
      p_sc.GetFldValue(id, CSC_SchedStart, Value, dataType);
      ResDet.SchedStart := VarToStr(Value);
      p_sc.GetFldValue(id, CSC_ProgStart, Value, dataType);
      ResDet.ProgStart := VarToStr(Value);
      ResDet.Downtime := false;
      JobList.Add(ResDet);
    end;
  end;

  // Call Write-File-Functions and calculate Bin Totals for HTML Bin Extraction
  if JobList.Count <= 0 then
    MessageDlg(_('No jobs found'), mtInformation, [mbOK], 0)
  else
  begin
    Result := true;
    showResource := includedResources = 1;
    if ReportSettings.ReportType = 'Excel' then
      Result := WriteExcelFile(JobList, showResource, ReportSettings)
    else
      if ReportSettings.ReportType = 'Html' then
      begin
        CalcTotals(ReportSettings.UnschedJobs, ReportSettings.SchedJobs,
          ReportSettings.UnschedQuantity, ReportSettings.SchedQuantity, TotSetup, TotExe);
        Result := WriteHtmlFile(JobList, showResource, ReportSettings, false);
      end;
  end;
  JobList.Clear;
end;

//----------------------------------------------------------------------------//

function SortByStartDate(ResDet1 , ResDet2 : pointer): Integer;
begin
  if StrToDateTime(PTResourceDet(ResDet1).SchedStart) < StrToDateTime(PTResourceDet(ResDet2).SchedStart) then
    Result := -1
  else if StrToDateTime(PTResourceDet(ResDet1).SchedStart) > StrToDateTime(PTResourceDet(ResDet2).SchedStart) then
     Result := 1
  else Result := 0;
end;

//----------------------------------------------------------------------------//

function ExcelFreeResScheduleExport(ReportSettings: TSettings): boolean;
var
  res              : TMqmRes;
  visRes           : TMqmVisibleRes;
  act_area         : TMqmActArea;
  TmpDowntime      : TMqmCapRes;
  schedObj         : TSchedID;
  planInfo         : TSQplanInfo;
  i, j, k, l, m, S,
  noOfSubRes       : Integer;
  ResDet, ResDetTmp, ResDetTmp2           : PTResourceDet;
  CapResList,
  ResList, MainResList : TList;
  ChkLstBoxRsc     : TCheckListBox;
  ReportType,
  Res_Code         : string;
  DateFrom,
  DateTo           : Double;

  OrigDateFrom,
  OrigDateTo       : Double;

  NewStart, NewEnd : TDateTime;
  Cal : TPGCALObj;
  ResChecked : boolean;
begin
  Result           := false;
  ResChecked       := false;
  ResList          := TList.Create;
  MainResList      := TList.Create;
  CapResList       := TList.Create;
  OrigDateFrom     := ReportSettings.DateFrom;
  OrigDateTo       := ReportSettings.DateTo;
  ChkLstBoxRsc     := ReportSettings.ChkLstBoxRsc;
  ReportType       := ReportSettings.ReportType;

  // For each selected resource do... (and count resources)
  for i := 0 to (ChkLstBoxRsc.Items.Count - 1) do
    if ChkLstBoxRsc.Checked[i] then
    begin
      Res_Code := ChkLstBoxRsc.Items.Strings[i];
      res := TMqmRes(p_pl.FindResByCode(Res_Code));
      ResChecked := true;
      cal := nil;
      if res.p_isMultiRes then noOfSubRes := res.p_VisResCount
      else noOfSubRes := 1;
      for m := 1 to noOfSubRes do
      begin
        if not res.p_isMultiRes then visRes := res.p_VisRes[0]
        else visRes := res.GetSubRes(m);
        // Find jobs and downtimes for the actual resource...
        if Assigned(visRes) then
          for j := 0 to visRes.p_ActAreasCount - 1 do
          begin
            act_Area := TMqmActArea(visRes.p_ActArea[j]);
            if (TMqmRes(act_Area.p_Res)).p_ResCode = Res_Code then
            begin

              CapResList.Clear;
              ResList.Clear;

              // Collect downtimes and capres for resource...
              for l := 0 to act_area.p_CapResCount - 1 do
              begin
                if (TMqmRes(act_Area.p_Res)).p_ResCode = Res_Code then
                  if (TMqmCapRes((act_Area.p_CapRes[l])).m_Type = cr_DownTime) or
                    (TMqmCapRes((act_Area.p_CapRes[l])).m_Type = Cr_CrossingDtm) or
                    (TMqmCapRes((act_Area.p_CapRes[l])).m_Type = Cr_Normal) then      //CR
                    CapResList.Add(act_Area.p_CapRes[l]);
              end;
              CapResList.Sort(sortCapRes);

              // Collect jobs for resource
              act_area.SortSchedObjs;

              DateFrom := OrigDateFrom;
              DateTo   := OrigDateTo;

              for k := 0 to act_area.SchedObjsCount - 1 do
              begin
                schedObj := TSchedID(act_area.GetSchedObj(k));
                p_sc.GetPlanInfo(schedObj, planInfo);
                if (planInfo.startDate < DateFrom) and (planInfo.endDate > DateFrom) then
                   DateFrom := planInfo.endDate;

                if (planInfo.startDate < DateTo) and (planInfo.endDate > DateTo) then
                   DateTo := planInfo.startDate;

                if (planInfo.isOnPlan) and (not ((planInfo.endDate < DateFrom) or
                  (planInfo.startDate > DateTo))) then
                begin
                  if not assigned(cal) then
                    Cal := TMqmActArea(p_sc.getExtLinkPtr(schedObj)).GetCalendar;
                  New(ResDet);
                  ResDet.ResCode := (TMqmRes(act_Area.p_Res)).p_ResCode;
                  ResDet.ResDesc := (TMqmRes(act_Area.p_Res)).p_ResSDesc;
                  ResDet.SchedStart := DateTimeToStr(planInfo.startDate);
                  ResDet.SchedEnd   := DateTimeToStr(planInfo.endDate);
                  ResDet.ID := schedObj;
                  ResList.Add(ResDet);
                end;
              end;

              for l := CapResList.Count - 1 downto 0 do
              begin
                TmpDowntime := TMqmCapRes(CapResList.Items[l]);
                if (TmpDowntime.p_start > DateFrom) and (TmpDowntime.p_start < DateTo) then
                begin
                  New(ResDet);
                  ResDet.ResCode := (TMqmRes(act_Area.p_Res)).p_ResCode;
                  ResDet.ResDesc := (TMqmRes(act_Area.p_Res)).p_ResSDesc;
                  ResDet.SchedStart := DateTimeToStr(TmpDowntime.p_start);
                  ResDet.SchedEnd := DateTimeToStr(TmpDowntime.p_end);
                  ResDet.ID := CSchedIDnull;
                  ResList.Add(ResDet);
                end;
              end;

              ResList.Sort(SortByStartDate);

              if act_area.FindCapResInSpots(DateFrom,NewStart, nil, NewEnd) then
                 DateFrom := NewStart;

              if act_area.FindCapResInSpots(DateTo,NewEnd, nil, NewEnd) then
                 DateTo := NewEnd;

              for S := 0 to ResList.Count - 1 do
              begin

                if S = 0 then
                begin
                  if DateFrom < StrToDateTime(PTResourceDet(ResList[S]).SchedStart) then
                  begin
                    New(ResDetTmp2);
                    ResDetTmp2.FreeResStart := DateFrom;
                    ResDetTmp2.FreeResEnd   := StrToDateTime(PTResourceDet(ResList[S]).SchedStart);
                    ResDetTmp2.FreeTimeHours := cal.DiffWH(DateFrom , ResDetTmp2.FreeResEnd, nil);
                    ResDetTmp2.ResCode := (TMqmRes(act_Area.p_Res)).p_ResCode;
                    MainResList.Add(ResDetTmp2);
                  end;
                end;
                ResDet := PTResourceDet(ResList[S]);

                if S + 1 < ResList.Count then
                begin
                  ResDetTmp := PTResourceDet(ResList[S + 1]);
                  New(ResDetTmp2);
                  ResDetTmp2.FreeResStart  := StrToDateTime(ResDet.SchedEnd);
                  ResDetTmp2.FreeResEnd    := StrToDateTime(ResDetTmp.SchedStart);
                  ResDetTmp2.ResCode       := ResDet.ResCode;
                  ResDetTmp2.FreeTimeHours := cal.DiffWH(ResDetTmp2.FreeResStart , ResDetTmp2.FreeResEnd, nil);
                  if ResDetTmp2.FreeTimeHours <> 0 then
                    MainResList.Add(ResDetTmp2);
                end
                else if S = ResList.Count - 1 then
                begin
                  if DateTo > StrToDateTime(ResDet.SchedEnd) then
                  begin
                    new(ResDetTmp2);
                    ResDetTmp2.ResCode       := (TMqmRes(act_Area.p_Res)).p_ResCode;
                    ResDetTmp2.FreeResStart  :=  StrToDateTime(PTResourceDet(ResList[S]).SchedEnd);
                    ResDetTmp2.FreeResEnd    :=  DateTo;
                    ResDetTmp2.FreeTimeHours :=  cal.DiffWH(ResDetTmp2.FreeResStart , ResDetTmp2.FreeResEnd, nil);
                    MainResList.Add(ResDetTmp2);
                  end;
                end;
              end;

              if ResList.Count = 0 then
              begin
                new(ResDetTmp2);
                ResDetTmp2.ResCode       := (TMqmRes(act_Area.p_Res)).p_ResCode;
                ResDetTmp2.FreeResStart  :=  OrigDateFrom;
                ResDetTmp2.FreeResEnd    :=  OrigDateTo;
                if not assigned(cal) then
                   Cal := visRes.GetCalendar;
                ResDetTmp2.FreeTimeHours :=  cal.DiffWH(ResDetTmp2.FreeResStart , ResDetTmp2.FreeResEnd, nil);
                MainResList.Add(ResDetTmp2);
              end;

            end;
          end;
      end;
    end;
  // Call Write-File-Functions

    if not ResChecked then
    begin
      Result := false;
      ShowMessage(_('At least one resource must be selected ...'));
      Exit
    end;

    if reportType = 'Free_Resource_Excel' then
      Result := WriteFreeResExcelFile(MainResList, ReportSettings);

    if not Result then ShowMessage(_('Free Resource Schedule Report aborted'));

end;

//----------------------------------------------------------------------------//
{ A Job List is created that is finally passed to the file creation area. All
  passed resources are analysed for existing jobs and downtimes. Everything
  that is found is collected and stored in the Job List.
  @param ReportSettings   Report settings given by calling units }
//----------------------------------------------------------------------------//

function DynamicScheduleExport(ReportSettings: TSettings; IsFromReport : boolean): boolean;
var
  res              : TMqmRes;
  visRes,
  visResSub        : TMqmVisibleRes;
  act_area         : TMqmActArea;
  TmpDowntime      : TMqmCapRes;
  schedObj, grp    : TSchedId;
  planInfo         : TSQplanInfo;
  i, j, k, l, m, G,
  noOfSubRes,
  checkedResources : Integer;
  startingDate     : TDateTime;
  dataType         : CBinColValType;
  Value            : variant;
  ResDet           : PTResourceDet;
  CapResList,
  JobList          : TList;
  showResource     : boolean;
  ChkLstBoxRsc     : TCheckListBox;
  ReportType,
  Res_Code         : string;
  DateFrom,
  DateTo           : Double;
begin
  Result           := false;
  JobList          := TList.Create;
  CapResList       := TList.Create;
  checkedResources := 0;
  DateFrom         := ReportSettings.DateFrom;
  DateTo           := ReportSettings.DateTo;
  ChkLstBoxRsc     := ReportSettings.ChkLstBoxRsc;
  ReportType       := ReportSettings.ReportType;

  // For each selected resource do... (and count resources)
  for i := 0 to (ChkLstBoxRsc.Items.Count - 1) do
    if ChkLstBoxRsc.Checked[i] then
    begin
      Inc(checkedResources);
      Res_Code := ChkLstBoxRsc.Items.Strings[i];
      res := TMqmRes(p_pl.FindResByCode(Res_Code));
      if res.p_isMultiRes then noOfSubRes := res.p_VisResCount
      else noOfSubRes := 1;
      for m := 1 to noOfSubRes do
      begin
        if not res.p_isMultiRes then visRes := res.p_VisRes[0]
        else visRes := res.GetSubRes(m);
        // Find jobs and downtimes for the actual resource...
        if Assigned(visRes) then
          for j := 0 to visRes.p_ActAreasCount - 1 do
          begin
            act_Area := TMqmActArea(visRes.p_ActArea[j]);
            if (TMqmRes(act_Area.p_Res)).p_ResCode = Res_Code then
            begin
              CapResList.Clear;

              // Collect downtimes for resource...
              for l := 0 to act_area.p_CapResCount - 1 do
              begin
                if (TMqmRes(act_Area.p_Res)).p_ResCode = Res_Code then
                  if (TMqmCapRes((act_Area.p_CapRes[l])).m_Type = cr_DownTime) or
                    (TMqmCapRes((act_Area.p_CapRes[l])).m_Type = Cr_CrossingDtm) then
                    CapResList.Add(act_Area.p_CapRes[l]);
              end;
              CapResList.Sort(sortCapRes);

              // Collect jobs for resource
              act_area.SortSchedObjs;
              schedObj := -1;
              for k := 0 to act_area.SchedObjsCount - 1 do
              begin
                schedObj := TSchedID(act_area.GetSchedObj(k));
                p_sc.GetPlanInfo(schedObj, planInfo);
                startingDate := planInfo.startDate;
                if (planInfo.isOnPlan) and (not ((planInfo.endDate < DateFrom) or
                  (planInfo.startDate > DateTo))) then
                begin

                  // Add downtimes within date range
                  for l := CapResList.Count - 1 downto 0 do
                  begin
                    TmpDowntime := TMqmCapRes(CapResList.Items[l]);
                    if (TmpDowntime.p_start < startingDate) and (TmpDowntime.p_start > DateFrom)
                        and (TmpDowntime.p_start < DateTo) then
                    begin
                      new(ResDet);
                      ResDet.Downtime     := true;
                      ResDet.ResCode      := (TMqmRes(act_Area.p_Res)).p_ResCode;
                      ResDet.ResDesc      := (TMqmRes(act_Area.p_Res)).p_ResSDesc;
                      ResDet.SubResCode   := '';
                      if Assigned(res) and res.p_isMultiRes and Assigned(p_sc.getExtLinkPtr(schedObj))
                        and Assigned(TMqmPlanObj(p_sc.getExtLinkPtr(schedObj)).p_Father) then
                      begin
                        visResSub := TMqmVisibleRes(TMqmActArea(p_sc.getExtLinkPtr(schedObj)).p_Father);
                        if Assigned(visResSub) then ResDet.SubResCode := IntToStr(visResSub.p_SubCode);
                      end;
                      ResDet.DownTimeFrom := DateTimeToStr(TmpDowntime.p_start);
                      ResDet.DownTimeTo   := DateTimeToStr(TmpDowntime.p_end);
                      ResDet.Comment      := TmpDowntime.m_Comment;
                      CapResList.Delete(l);
                      JobList.Add(ResDet);
                    end;
                  end;

                  // Add job
                  new(ResDet);
                  ResDet.ResCode := Res_Code;
                  ResDet.SubResCode := '';
                  if Assigned(res) and res.p_isMultiRes and Assigned(p_sc.getExtLinkPtr(schedObj))
                    and Assigned(TMqmPlanObj(p_sc.getExtLinkPtr(schedObj)).p_Father) then
                  begin
                    visResSub := TMqmVisibleRes(TMqmActArea(p_sc.getExtLinkPtr(schedObj)).p_Father);
                    if Assigned(visResSub) then ResDet.SubResCode := IntToStr(visResSub.p_SubCode);
                  end;
                  ResDet.ResDesc := res.p_ResSDesc;
                  ResDet.Downtime := false;
                  ResDet.ID := schedObj;
                  p_sc.GetFldValue(schedObj, CSC_SchedStart, Value, dataType);
                  ResDet.SchedStart := VarToStr(Value);
                  p_sc.GetFldValue(schedObj, CSC_ProgStart, Value, dataType);
                  ResDet.ProgStart := VarToStr(Value);
                  JobList.Add(ResDet);

                  if planInfo.isGroup //and ((DBAppSettings.ShowContinueGroupLinesInBin = '2') or
                     //(DBAppSettings.ShowContinueGroupLinesInBin = '1'))
                     and (p_sc.GetJobType(schedObj) = CST_Continuous) then
                  begin
                  //  ListOfSequence := TStringList.Create;
                    grp := schedObj;
                    for G := 1 to p_sc.GetGrpNumSons(grp) - 1 do
                    begin
                      schedObj := p_sc.GetGrpSon(grp, G);
                    {  p_sc.GetFldValue(schedObj, CSC_Sequence, Value, dataType);
                      if (DBAppSettings.ShowContinueGroupLinesInBin = '2') and (Value <> '') then
                      begin
                        if (ListOfSequence.IndexOf(Value) = -1) then
                          ListOfSequence.Add(value)
                        else
                          Continue;
                      end; }

                      new(ResDet);
                      ResDet.ResCode := Res_Code;
                      ResDet.SubResCode := '';
                      if Assigned(res) and res.p_isMultiRes and Assigned(p_sc.getExtLinkPtr(schedObj))
                        and Assigned(TMqmPlanObj(p_sc.getExtLinkPtr(schedObj)).p_Father) then
                      begin
                        visResSub := TMqmVisibleRes(TMqmActArea(p_sc.getExtLinkPtr(schedObj)).p_Father);
                        if Assigned(visResSub) then ResDet.SubResCode := IntToStr(visResSub.p_SubCode);
                      end;
                      ResDet.ResDesc := res.p_ResSDesc;
                      ResDet.Downtime := false;
                      ResDet.ID := schedObj;
                      p_sc.GetFldValue(schedObj, CSC_SchedStart, Value, dataType);
                      ResDet.SchedStart := VarToStr(Value);
                      p_sc.GetFldValue(schedObj, CSC_ProgStart, Value, dataType);
                      ResDet.ProgStart := VarToStr(Value);
                      JobList.Add(ResDet);

                    end;
                  end

                  else if planInfo.isGroup //and DBAppSettings.ShowBatchGroupLinesInBin
                          and (p_sc.GetJobType(schedObj) = CST_batch) then
                  begin
                    grp := schedObj;
                    for G := 1 to p_sc.GetGrpNumSons(grp) - 1 do
                    begin
                      schedObj := p_sc.GetGrpSon(grp, G);
                      new(ResDet);
                      ResDet.ResCode := Res_Code;
                      ResDet.SubResCode := '';
                      if Assigned(res) and res.p_isMultiRes and Assigned(p_sc.getExtLinkPtr(schedObj))
                        and Assigned(TMqmPlanObj(p_sc.getExtLinkPtr(schedObj)).p_Father) then
                      begin
                        visResSub := TMqmVisibleRes(TMqmActArea(p_sc.getExtLinkPtr(schedObj)).p_Father);
                        if Assigned(visResSub) then ResDet.SubResCode := IntToStr(visResSub.p_SubCode);
                      end;
                      ResDet.ResDesc := res.p_ResSDesc;
                      ResDet.Downtime := false;
                      ResDet.ID := schedObj;
                      p_sc.GetFldValue(schedObj, CSC_SchedStart, Value, dataType);
                      ResDet.SchedStart := VarToStr(Value);
                      p_sc.GetFldValue(schedObj, CSC_ProgStart, Value, dataType);
                      ResDet.ProgStart := VarToStr(Value);
                      JobList.Add(ResDet);
                    end;
                  end;
                end;
              end;

              // Add downtime without date range check
              for l := CapResList.Count - 1 downto 0 do
              begin
                TmpDowntime := TMqmCapRes(CapResList.Items[l]);
                if (TmpDowntime.p_start > DateFrom) and (TmpDowntime.p_start < DateTo) then
                begin
                  new(ResDet);
                  ResDet.Downtime     := true;
                  ResDet.ResCode      := (TMqmRes(act_Area.p_Res)).p_ResCode;
                  ResDet.SubResCode   := '';
                  if (schedObj <> -1) and Assigned(res) and res.p_isMultiRes
                    and Assigned(p_sc.getExtLinkPtr(schedObj))
                    and Assigned(TMqmPlanObj(p_sc.getExtLinkPtr(schedObj)).p_Father) then
                  begin
                    visResSub := TMqmVisibleRes(TMqmActArea(p_sc.getExtLinkPtr(schedObj)).p_Father);
                    if Assigned(visResSub) then ResDet.SubResCode := IntToStr(visResSub.p_SubCode);
                  end;
                  ResDet.ResDesc      := (TMqmRes(act_Area.p_Res)).p_ResSDesc;
                  ResDet.DownTimeFrom := DateTimeToStr(TmpDowntime.p_start);
                  ResDet.DownTimeTo   := DateTimeToStr(TmpDowntime.p_end);
                  ResDet.Comment      := TmpDowntime.m_Comment;
                  CapResList.Delete(l);
                  JobList.Add(ResDet);
                end;
              end;
            end;
          end;
      end;
    end;

  // Call Write-File-Functions
  if JobList.Count <= 0 then
    MessageDlg(_('No jobs present on selected resources'), mtInformation, [mbOK], 0)
  else
  begin
    showResource := checkedResources = 1;
    if (reportType = 'Excel') or (reportType = 'Non_Excel') then
      Result := WriteExcelFile(JobList, showResource, ReportSettings)
    else if reportType = 'Html' then
      Result := WriteHtmlFile(JobList, showResource, ReportSettings, IsFromReport);

    if not Result then ShowMessage(_('HTML Schedule Report aborted'));
  end;
  JobList.Clear;
//  if Assigned(ListOfSequence) then
//     ListOfSequence.Free;
end;

//----------------------------------------------------------------------------//

function PeriodMachineReport(ReportSettings: TSettings; IsFromReport : boolean): boolean;
var
  ColAttributes      : TBinColCurrent;
  res              : TMqmRes;
  visRes,
  visResSub        : TMqmVisibleRes;
  act_area         : TMqmActArea;
  TmpDowntime      : TMqmCapRes;
  schedObj, grp    : TSchedId;
  planInfo         : TSQplanInfo;
  i, j, k, l, m, G,
  noOfSubRes,
  checkedResources, position : Integer;
  dataType         : CBinColValType;
  Value            : variant;
  ResDet           : PTResourceDet;
  CapResList,
  JobList, SameResList  : TList;
  showResource     : boolean;
  XLApp            : OLEVariant;
  ChkLstBoxRsc     : TCheckListBox;
  ReportType,
  Res_Code, SchedType         : string;
  MessageFilter : IOleMessageFilter;
   DateFrom, FinallDate : TdateTime;
  myYear, myMonth, myDay : word;
  MachineReportNumPeriod : Integer;
  DaysMinusDoday : integer;
  ActBinGrid         : TBinDrawGrid;
  ActTab             : TBinTabSheet;
begin

  if (ReportSettings.MachineReportNumPeriod <> '') then
        MachineReportNumPeriod := StrToInt(ReportSettings.MachineReportNumPeriod);

  if (ReportSettings.MachineReportEditTodayMinusDays <> '') then
        DaysMinusDoday := StrToInt(ReportSettings.MachineReportEditTodayMinusDays);

  DateFrom := date;
  FinallDate := DateFrom;

  if ReportSettings.MachineReportPeriodFrom = '2' then
  begin
    if ReportSettings.MachineReportPeriod = '3' then
    begin
      DecodeDate(DateFrom, myYear, myMonth, myDay);
      DateFrom :=  EndOfAMonth(myYear, myMonth);
    end
    else if ReportSettings.MachineReportPeriod = '2' then
      DateFrom :=  FirstDayOfWeekOf(FinallDate, true);
    FinallDate := DateFrom
  end
  else
  begin
    DateFrom := DateFrom - DaysMinusDoday;
  end;

  if ReportSettings.MachineReportPeriod = '3' then
  begin
    for I := 1 to MachineReportNumPeriod do
      FinallDate := IncMonth(FinallDate);
    DecodeDate(FinallDate, myYear, myMonth, myDay);
    FinallDate :=  EndOfAMonth(myYear, myMonth);
  end
  else if ReportSettings.MachineReportPeriod = '2' then
  begin
    for I := 1 to MachineReportNumPeriod do
      FinallDate := IncWeek(FinallDate);
    FinallDate := FirstDayOfWeekOf(FinallDate, true);
    FinallDate := FinallDate - (1/24/3600);
  end

  else if ReportSettings.MachineReportPeriod = '1' then
  begin
    for I := 1 to MachineReportNumPeriod do
      FinallDate := IncDay(FinallDate);
  end;

  ReportSettings.DateFrom := DateFrom;
  ReportSettings.DateTo := FinallDate;

  Result           := false;
  JobList          := TList.Create;
  SameResList      := TList.Create;
  CapResList       := TList.Create;
  checkedResources := 0;
  ChkLstBoxRsc     := ReportSettings.ChkLstBoxRsc;
  ReportType       := ReportSettings.ReportType;

  // For each selected resource do... (and count resources)
  for i := 0 to (ChkLstBoxRsc.Items.Count - 1) do
    if ChkLstBoxRsc.Checked[i] then
    begin
      Inc(checkedResources);
      Res_Code := ChkLstBoxRsc.Items.Strings[i];
      res := TMqmRes(p_pl.FindResByCode(Res_Code));
      if res.p_isMultiRes then noOfSubRes := res.p_VisResCount
      else noOfSubRes := 1;
      for m := 1 to noOfSubRes do
      begin
        if not res.p_isMultiRes then visRes := res.p_VisRes[0]
        else visRes := res.GetSubRes(m);
        // Find jobs and downtimes for the actual resource...
        if Assigned(visRes) then
          for j := 0 to visRes.p_ActAreasCount - 1 do
          begin
            act_Area := TMqmActArea(visRes.p_ActArea[j]);
            if (TMqmRes(act_Area.p_Res)).p_ResCode = Res_Code then
            begin
              {CapResList.Clear;

              // Collect downtimes for resource...
              for l := 0 to act_area.p_CapResCount - 1 do
              begin
                if (TMqmRes(act_Area.p_Res)).p_ResCode = Res_Code then
                  if (TMqmCapRes((act_Area.p_CapRes[l])).m_Type = cr_DownTime) or
                    (TMqmCapRes((act_Area.p_CapRes[l])).m_Type = Cr_CrossingDtm) then
                    CapResList.Add(act_Area.p_CapRes[l]);
              end;
              CapResList.Sort(sortCapRes);

              // Collect jobs for resource
              act_area.SortSchedObjs;
              schedObj := -1;       }
              for k := 0 to act_area.SchedObjsCount - 1 do
              begin
                schedObj := TSchedID(act_area.GetSchedObj(k));
                p_sc.GetPlanInfo(schedObj, planInfo);

                p_sc.GetFldValue(schedObj, CSC_ProgStart, Value, dataType);
                planInfo.StartDate := Value;
                p_sc.GetFldValue(schedObj, CSC_ProgEnd, Value, dataType);
                planInfo.EndDate   := Value;

                if planInfo.startDate > FinallDate then continue;
                if planInfo.EndDate < DateFrom then continue;

                if not ((planInfo.EndDate <= DateFrom) or (planInfo.startDate >= FinallDate)) then

                begin

                  // Add downtimes within date range
                 { for l := CapResList.Count - 1 downto 0 do
                  begin
                    TmpDowntimawe := TMqmCapRes(CapResList.Items[l]);
                    if (TmpDowntime.p_start < startingDate) and (TmpDowntime.p_start > DateFrom)
                        and (TmpDowntime.p_start < FinallDate) then
                    begin
                      new(ResDet);
                      ResDet.Downtime     := true;
                      ResDet.ResCode      := (TMqmRes(act_Area.p_Res)).p_ResCode;
                      ResDet.ResDesc      := (TMqmRes(act_Area.p_Res)).p_ResSDesc;
                      ResDet.SubResCode   := '';
                      if Assigned(res) and res.p_isMultiRes and Assigned(p_sc.getExtLinkPtr(schedObj))
                        and Assigned(TMqmPlanObj(p_sc.getExtLinkPtr(schedObj)).p_Father) then
                      begin
                        visResSub := TMqmVisibleRes(TMqmActArea(p_sc.getExtLinkPtr(schedObj)).p_Father);
                        if Assigned(visResSub) then ResDet.SubResCode := IntToStr(visResSub.p_SubCode);
                      end;
                      ResDet.DownTimeFrom := DateTimeToStr(TmpDowntime.p_start);
                      ResDet.DownTimeTo   := DateTimeToStr(TmpDowntime.p_end);
                      ResDet.Comment      := TmpDowntime.m_Comment;
                      CapResList.Delete(l);
                      JobList.Add(ResDet);
                    end;
                  end;    }

                  // Add job
                  new(ResDet);
                  ResDet.ResCode := Res_Code;
                  ResDet.SubResCode := '';
                  if Assigned(res) and res.p_isMultiRes and Assigned(p_sc.getExtLinkPtr(schedObj))
                    and Assigned(TMqmPlanObj(p_sc.getExtLinkPtr(schedObj)).p_Father) then
                  begin
                    visResSub := TMqmVisibleRes(TMqmActArea(p_sc.getExtLinkPtr(schedObj)).p_Father);
                    if Assigned(visResSub) then ResDet.SubResCode := IntToStr(visResSub.p_SubCode);
                  end;
                  ResDet.ResDesc := res.p_ResSDesc;
                  ResDet.Downtime := false;
                  ResDet.ID := schedObj;
                  ResDet.IsProgress := (p_sc.IsProgressed(ResDet.ID) <> prg_none);

                  p_sc.GetFldValue(schedObj, CSC_ProgStart, Value, dataType);
                  ResDet.FromPlanInfo_StartDate := Value;
                  p_sc.GetFldValue(schedObj, CSC_ProgEnd, Value, dataType);
                  ResDet.FromPlanInfo_EndDate   := Value;

                  if ResDet.IsProgress then
                  begin
                    p_sc.GetFldValue(schedObj, CSC_ActualTime, Value, dataType);
                    ResDet.FromPlanInfo_Exe       := Value;
                  end
                  else
                    ResDet.FromPlanInfo_Exe     := planInfo.exeMin;

                  ResDet.FromPlanInfo_OrigExe          := ResDet.FromPlanInfo_Exe;
                  ResDet.Cal := act_area.GetCalendar;
                  ResDet.actarea := act_area;
                  ResDet.Exe     := planInfo.exeMin;
                  ResDet.SetUp   := planInfo.supMinReal;

                  SchedType := p_sc.GetSchedType(schedObj);

                  if SchedType = '0' then
                    ResDet.ScheduleType := _('No')
                  else if SchedType = '1' then
                    ResDet.ScheduleType := _('Initial')
                  else if SchedType = '2' then
                    ResDet.ScheduleType := _('Final')
                  else if SchedType = '3' then
                    ResDet.ScheduleType := _('Level 1')
                  else if SchedType = '4' then
                    ResDet.ScheduleType := _('Level 2')
                  else if SchedType = '5' then
                    ResDet.ScheduleType := _('Level 3')
                  else if SchedType = '6' then
                    ResDet.ScheduleType := _('Level 4')
                  else if SchedType = '7' then
                    ResDet.ScheduleType := _('Level 5');

                  JobList.Add(ResDet);

                  if planInfo.isGroup //and ((DBAppSettings.ShowContinueGroupLinesInBin = '2') or
                     //(DBAppSettings.ShowContinueGroupLinesInBin = '1'))
                     and (p_sc.GetJobType(schedObj) = CST_Continuous) then
                  begin
                  //  ListOfSequence := TStringList.Create;
                    grp := schedObj;
                    for G := 1 to p_sc.GetGrpNumSons(grp) - 1 do
                    begin
                      schedObj := p_sc.GetGrpSon(grp, G);
                    {  p_sc.GetFldValue(schedObj, CSC_Sequence, Value, dataType);
                      if (DBAppSettings.ShowContinueGroupLinesInBin = '2') and (Value <> '') then
                      begin
                        if (ListOfSequence.IndexOf(Value) = -1) then
                          ListOfSequence.Add(value)
                        else
                          Continue;
                      end; }

                      p_sc.GetPlanInfo(schedObj, planInfo);
                      new(ResDet);
                      ResDet.ResCode := Res_Code;
                      ResDet.SubResCode := '';
                      if Assigned(res) and res.p_isMultiRes and Assigned(p_sc.getExtLinkPtr(schedObj))
                        and Assigned(TMqmPlanObj(p_sc.getExtLinkPtr(schedObj)).p_Father) then
                      begin
                        visResSub := TMqmVisibleRes(TMqmActArea(p_sc.getExtLinkPtr(schedObj)).p_Father);
                        if Assigned(visResSub) then ResDet.SubResCode := IntToStr(visResSub.p_SubCode);
                      end;
                      ResDet.ResDesc := res.p_ResSDesc;
                      ResDet.Downtime := false;
                      ResDet.ID := schedObj;
                      ResDet.IsProgress := (p_sc.IsProgressed(ResDet.ID) <> prg_none);

                      p_sc.GetFldValue(schedObj, CSC_ProgStart, Value, dataType);
                      ResDet.FromPlanInfo_StartDate := Value;
                      p_sc.GetFldValue(schedObj, CSC_ProgEnd, Value, dataType);
                      ResDet.FromPlanInfo_EndDate   := Value;

                      if ResDet.IsProgress then
                      begin
                        p_sc.GetFldValue(schedObj, CSC_ActualTime, Value, dataType);
                        ResDet.FromPlanInfo_Exe       := Value;
                      end
                      else
                        ResDet.FromPlanInfo_Exe     := planInfo.exeMin;

                      ResDet.FromPlanInfo_OrigExe          := ResDet.FromPlanInfo_Exe;
                      ResDet.Cal := act_area.GetCalendar;
                      ResDet.actarea := act_area;
                      ResDet.Exe     := planInfo.exeMin;
                      ResDet.SetUp   := planInfo.supMinReal;

                      SchedType := p_sc.GetSchedType(schedObj);
                      if SchedType = '0' then
                        ResDet.ScheduleType := _('No')
                      else if SchedType = '1' then
                        ResDet.ScheduleType := _('Initial')
                      else if SchedType = '2' then
                        ResDet.ScheduleType := _('Final')
                      else if SchedType = '3' then
                        ResDet.ScheduleType := _('Level 1')
                      else if SchedType = '4' then
                        ResDet.ScheduleType := _('Level 2')
                      else if SchedType = '5' then
                        ResDet.ScheduleType := _('Level 3')
                      else if SchedType = '6' then
                        ResDet.ScheduleType := _('Level 4')
                      else if SchedType = '7' then
                        ResDet.ScheduleType := _('Level 5');

                    end;
                  end

                  else if planInfo.isGroup //and DBAppSettings.ShowBatchGroupLinesInBin
                          and (p_sc.GetJobType(schedObj) = CST_batch) then
                  begin
                    grp := schedObj;
                    for G := 1 to p_sc.GetGrpNumSons(grp) - 1 do
                    begin
                      schedObj := p_sc.GetGrpSon(grp, G);
                      p_sc.GetPlanInfo(schedObj, planInfo);
                      new(ResDet);
                      ResDet.ResCode := Res_Code;
                      ResDet.SubResCode := '';
                      if Assigned(res) and res.p_isMultiRes and Assigned(p_sc.getExtLinkPtr(schedObj))
                        and Assigned(TMqmPlanObj(p_sc.getExtLinkPtr(schedObj)).p_Father) then
                      begin
                        visResSub := TMqmVisibleRes(TMqmActArea(p_sc.getExtLinkPtr(schedObj)).p_Father);
                        if Assigned(visResSub) then ResDet.SubResCode := IntToStr(visResSub.p_SubCode);
                      end;
                      ResDet.ResDesc := res.p_ResSDesc;
                      ResDet.Downtime := false;
                      ResDet.ID := schedObj;
                      ResDet.IsProgress := (p_sc.IsProgressed(ResDet.ID) <> prg_none);

                      p_sc.GetFldValue(schedObj, CSC_ProgStart, Value, dataType);
                      ResDet.FromPlanInfo_StartDate := Value;
                      p_sc.GetFldValue(schedObj, CSC_ProgEnd, Value, dataType);
                      ResDet.FromPlanInfo_EndDate   := Value;

                      if ResDet.IsProgress then
                      begin
                        p_sc.GetFldValue(schedObj, CSC_ActualTime, Value, dataType);
                        ResDet.FromPlanInfo_Exe       := Value;
                      end
                      else
                        ResDet.FromPlanInfo_Exe     := planInfo.exeMin;

                      ResDet.FromPlanInfo_OrigExe          := ResDet.FromPlanInfo_Exe;
                      ResDet.Cal := act_area.GetCalendar;
                      ResDet.actarea := act_area;
                      ResDet.Exe     := planInfo.exeMin;
                      ResDet.SetUp   := planInfo.supMinReal;

                      SchedType := p_sc.GetSchedType(schedObj);
                      if SchedType = '0' then
                        ResDet.ScheduleType := _('No')
                      else if SchedType = '1' then
                        ResDet.ScheduleType := _('Initial')
                      else if SchedType = '2' then
                        ResDet.ScheduleType := _('Final')
                      else if SchedType = '3' then
                        ResDet.ScheduleType := _('Level 1')
                      else if SchedType = '4' then
                        ResDet.ScheduleType := _('Level 2')
                      else if SchedType = '5' then
                        ResDet.ScheduleType := _('Level 3')
                      else if SchedType = '6' then
                        ResDet.ScheduleType := _('Level 4')
                      else if SchedType = '7' then
                        ResDet.ScheduleType := _('Level 5');

                      JobList.Add(ResDet);
                    end;
                  end;
                end;
              end;

              // Add downtime without date range check
              for l := CapResList.Count - 1 downto 0 do
              begin
                TmpDowntime := TMqmCapRes(CapResList.Items[l]);
                if (TmpDowntime.p_start > DateFrom) and (TmpDowntime.p_start < FinallDate) then
                begin
                  new(ResDet);
                  ResDet.Downtime     := true;
                  ResDet.ResCode      := (TMqmRes(act_Area.p_Res)).p_ResCode;
                  ResDet.SubResCode   := '';
                  if (schedObj <> -1) and Assigned(res) and res.p_isMultiRes
                    and Assigned(p_sc.getExtLinkPtr(schedObj))
                    and Assigned(TMqmPlanObj(p_sc.getExtLinkPtr(schedObj)).p_Father) then
                  begin
                    visResSub := TMqmVisibleRes(TMqmActArea(p_sc.getExtLinkPtr(schedObj)).p_Father);
                    if Assigned(visResSub) then ResDet.SubResCode := IntToStr(visResSub.p_SubCode);
                  end;
                  ResDet.ResDesc      := (TMqmRes(act_Area.p_Res)).p_ResSDesc;
                  ResDet.DownTimeFrom := DateTimeToStr(TmpDowntime.p_start);
                  ResDet.DownTimeTo   := DateTimeToStr(TmpDowntime.p_end);
                  ResDet.Comment      := TmpDowntime.m_Comment;
                  CapResList.Delete(l);
                  JobList.Add(ResDet);
                end;
              end;
            end;
          end;
      end;
    end;

  // Call Write-File-Functions
  if JobList.Count <= 0 then
  begin
    Result := false;
    if not IsAutoRunMode then
      MessageDlg(_('No jobs present on selected resources'), mtInformation, [mbOK], 0)
  end
  else
  begin
    showResource := checkedResources = 1;

    var ExcelInstalled := CheckIfExcelInstalled;

    if ExcelInstalled then
    begin
      XLApp := CreateOleObject('Excel.Application');
      XLApp.Application.Workbooks.Add;

      Res_Code := '';

      for I := 0 to JobList.Count - 1 do
      begin
        if (I > 0) and (Res_Code <> PTResourceDet(JobList[I]).ResCode) then
        begin
          XLApp.Worksheets.Add;
          XLApp.Workbooks[1].Worksheets[1].Name := Res_Code;
          Result := WriteExcelFilePeriodMachine(SameResList, showResource, ReportSettings, XLApp, Res_Code, ExcelInstalled);
          SameResList.Clear;
        end;
        Res_Code := PTResourceDet(JobList[I]).ResCode;
        SameResList.add(JobList[I])
      end;

      if SameResList.Count > 0 then
      begin
        XLApp.Worksheets.Add;
        XLApp.Workbooks[1].Worksheets[1].Name := Res_Code;
        Result := WriteExcelFilePeriodMachine(SameResList, showResource, ReportSettings, XLApp, Res_Code, ExcelInstalled);
        SameResList.Clear;
      end;

      ReportSettings.NativeExcel.CloseFile;

      XLApp.Workbooks[1].SaveAs(ReportSettings.SaveFileLocation); //1 =to save in xls format

      MessageFilter.RevokeFilter();
      XLApp.DisplayAlerts := False;
      XLApp.Quit;
      XLAPP := Unassigned;
    //  Sheet := Unassigned;
    end else
    begin
      Res_Code := '';
      var NumOfSheets := 0;
      var XML := '';
      var XMLData := '';
      var VisColInBin := 0;

      ActTab := FBin.GetActiveView;
      if not Assigned(ActTab) then exit;
      ActBinGrid := ActTab.GetBinGrid;

      for j := 0 to High(BinColDefault) - 1 do
      begin
        position := ActBinGrid.FindPos(j);
        ColAttributes := ActBinGrid.BinColumnSet[position];
        if ColAttributes.Visible and (ColAttributes.Field <> CSC_MsgFromHost) then VisColInBin := VisColInBin + 1;
      end;

      for I := 0 to JobList.Count - 1 do
      begin
        if (I > 0) and (Res_Code <> PTResourceDet(JobList[I]).ResCode) then
        begin
          BinData := VarArrayCreate([1,(JobList.Count * 7), 1, 100 ], varVariant);
          Result := WriteExcelFilePeriodMachine(SameResList, showResource, ReportSettings, XLApp, Res_Code, ExcelInstalled);
          Inc(NumOfSheets);
          XMLData := XMLData + AddValueToXML(BinData, Res_Code);
          SameResList.Clear;
          VarClear(BinData);
        end;
        Res_Code := PTResourceDet(JobList[I]).ResCode;
        SameResList.add(JobList[I])
      end;

      if SameResList.Count > 0 then
      begin
        BinData := VarArrayCreate([1,(JobList.Count * 7), 1, 100 ], varVariant);
        Result := WriteExcelFilePeriodMachine(SameResList, showResource, ReportSettings, XLApp, Res_Code, ExcelInstalled);
        Inc(NumOfSheets);
        XMLData := XMLData + AddValueToXML(BinData, Res_Code);
        SameResList.Clear;
        VarClear(BinData);
      end;

      XML := GenerateXML(NumOfSheets);
      XML := XML + XMLData;

      CreateXML(XML,ReportSettings.SaveFileLocation);
    end;


    if not Result then ShowMessage(_('Report aborted'));
  end;

  for I := 0 to JobList.Count - 1 do
    dispose(PTResourceDet(JobList[I]));
  SameResList.Clear;
  JobList.Clear;

  SameResList.free;
  JobList.free;

end;

//----------------------------------------------------------------------------//

function WriteExcelFilePeriodMachine(JobList: TList; showResource: boolean; ReportSettings: TSettings; var XLApp: OLEVariant; ResCode : string; ExcelInstalled: Boolean): boolean;
const
  xlWBATWorksheet = $FFFFEFB9;
var
  i, j, k, pos, F, B, D,
  ColumnProdReq,
  ColumnStart,
  ColumnEnd,
  ColumnComment,
  ColumnQtyToSched,
  ColumnExeTimeSched,
  ColumnSupTimeSched,
  ColumnFinalQty,
  ColumnStepExeTime,
  ColumnActualExecTime,
  ColumnProgQty,
  ColumnRes,
  ColumnResDescr,
  colNum,
  StepGroupIndex,
  stepTypeIndex,
  sumSchedExecTime,
  sumActualExecTime,
  sumStepExeMin,
  sumSetupTime       : integer;
  ActBinGrid         : TBinDrawGrid;
  ActTab             : TBinTabSheet;
  ColAttributes      : TBinColCurrent;
  Field,
  FieldValue         : string;
  ResChange : boolean;
  ResDet             : PTResourceDet;
  id                 : TSchedId;
  Value,qty : Variant;
  dataType : CBinColValType;
  formatSettings : TFormatSettings;
  DateFormat, TimeFormat, DateTimeFormat, ExcelYearChar, ExcelMonthChar,
  ExcelDayChar, ExcelHourChar, ExcelMinuteChar, CopyDateTimeFormat : String;
  sumFinQty,
  sumQtyToSched,
  sumProgQty,
  tmpTime            : double;
  SplitCriteria      : Array [0..4] of string;
  HeadingConcatenationColumn : TStringList;
  Sheet: OLEVariant;
  planInfo         : TSQplanInfo;
  tbInfo: ^TTblInfo;
  CounterFixedColumn, RowTemp : Integer;
  SpaceLineNeeded : boolean;
  ShowBatchGroupLinesInBin : boolean;
  ShowContinueGroupLinesInBin : CScShowContinueGroupLinesInBin;
  TmpYear, TmpMonth, TmpDay : word;
  TmpDate : TDate;
  SavedproductionDate, TempDate : TDate;
  NumberOfDays : Integer;
  TotalWorkH, WorkH : double;
  PlanInfo_StartDateWithSetup : TDateTime;
begin
  Result             := false;
  ResChange          := false;
  tbInfo             := nil;
  ColumnStart        := 0;
  ColumnProdReq      := 0;
  ColumnEnd          := 0;
  ColumnComment      := 0;
  ColumnQtyToSched   := 0;
  ColumnExeTimeSched := 0;
  ColumnSupTimeSched := 0;
  ColumnFinalQty     := 0;
  ColumnStepExeTime  := 0;
  ColumnActualExecTime := 0;
  ColumnProgQty      := 0;
  ColumnRes          := 0;
  ColumnResDescr     := 0;
  sumStepExeMin      := 0;
  sumFinQty          := 0;
  sumSchedExecTime   := 0;
  sumActualExecTime  := 0;
  sumSetupTime       := 0;
  sumQtyToSched      := 0;
  sumProgQty         := 0;
  colNum             := 0;
  CounterFixedColumn := 0;
  SavedproductionDate := date - 100;
  SpaceLineNeeded := false;
  HeadingConcatenationColumn := TStringList.Create;

  ActTab := FBin.GetActiveView;
  if not Assigned(ActTab) then exit;
  ActBinGrid := ActTab.GetBinGrid;
  FBin.ShowGroupLinesInBin(ShowBatchGroupLinesInBin, ShowContinueGroupLinesInBin);

//  XLApp.Application.Workbooks.Add;
//  XLApp.Worksheets.Add;
  if ExcelInstalled then
  begin
    XLApp.Worksheets[1].Select;
 // XLApp.Workbooks[1].Worksheets[WorksheetsAddedNumber].Name := ResCode;
    Sheet := XLApp.Workbooks[1].WorkSheets[1];

    GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT, formatSettings);

    ExcelYearChar := XLApp.International[19];
    ExcelMonthChar := XLApp.International[20];
    ExcelDayChar := XLApp.International[21];
    ExcelHourChar := XLApp.International[22];
    ExcelMinuteChar := XLApp.International[23];

    DateFormat := formatSettings.ShortDateFormat;
    DateFormat := StringReplace(DateFormat, 'y', LowerCase(ExcelYearChar), [rfReplaceAll]);
    DateFormat := StringReplace(DateFormat, 'Y', UpperCase(ExcelYearChar), [rfReplaceAll]);
    DateFormat := StringReplace(DateFormat, 'm', LowerCase(ExcelMonthChar), [rfReplaceAll]);
    DateFormat := StringReplace(DateFormat, 'M', UpperCase(ExcelMonthChar), [rfReplaceAll]);
    DateFormat := StringReplace(DateFormat, 'd', LowerCase(ExcelDayChar), [rfReplaceAll]);
    DateFormat := StringReplace(DateFormat, 'D', UpperCase(ExcelDayChar), [rfReplaceAll]);

    TimeFormat := 'hh:mm';
    TimeFormat := StringReplace(TimeFormat, 'h', LowerCase(ExcelHourChar), [rfReplaceAll]);
    TimeFormat := StringReplace(TimeFormat, 'm', LowerCase(ExcelMinuteChar), [rfReplaceAll]);

    DateTimeFormat := DateFormat + ' ' + TimeFormat;
  end;

  with ReportSettings.NativeExcel do
  begin
    stepTypeIndex  := -1;
    StepGroupIndex := -1;
    //NewFile;
    FileName := ReportSettings.SaveFileLocation;
    AddFont(FMQMPlan.ExcelFontBold.Font);
    AddFont(FMQMPlan.ExcelFontHeader1.Font);
    AddFont(FMQMPlan.ExcelFontHeader2.Font);

    ActiveFont := 1;
    RowTemp := 0;
    Column := 9;

    if (ReportSettings.IsBinReport) and (ReportSettings.MachineReportPeriodTitle <> '') then
    begin
      RowTemp := RowTemp + 1;
      Row := RowTemp;
      if ReportSettings.MachineReportShowFromToHeader then
        WriteValuesForExcel(ReportSettings.MachineReportPeriodTitle + '                      ' +
              'From ' + ' : ' + DateToStr(ReportSettings.DateFrom) + '    ' +  ' To ' + ' : ' + DateToStr(ReportSettings.DateTo),Row, Column, Sheet, ExcelInstalled)
          //Sheet.Cells[Row, Column].Value := ReportSettings.MachineReportPeriodTitle + '                      ' +
          //    'From ' + ' : ' + DateToStr(ReportSettings.DateFrom) + '    ' +  ' To ' + ' : ' + DateToStr(ReportSettings.DateTo)
      else
        WriteValuesForExcel(ReportSettings.MachineReportPeriodTitle,Row, Column, Sheet, ExcelInstalled);
          //Sheet.Cells[Row, Column].Value := ReportSettings.MachineReportPeriodTitle;
      Column := Column + 1;
      if ExcelInstalled then
        Sheet.Rows[Row].Interior.Color := ClSilver;//ClYellow;

      SpaceLineNeeded := true;
    end;


    Column := 1;
    shading := true;
    ActiveFont := 0;
    Alignment:= eaCenter;
    // For Bin Extractions, add columns Row Number and Status

    if ReportSettings.IsBinReport and ReportSettings.ShowColumnsCaptionsBinReport then
    begin
      RowTemp := RowTemp + 1;
      Row := RowTemp;
      WriteValuesForExcel(_('Day'),Row, Column, Sheet, ExcelInstalled);
      //Sheet.Cells[Row, Column].Value := _('Day');
      Column := Column + 1;
      if DBAppSettings.FixColStatVis then
      begin
        WriteValuesForExcel(_('Production date'),Row, Column, Sheet, ExcelInstalled);
      //Sheet.Cells[Row, Column].Value := _('Production date');
        Column := Column + 1;

        WriteValuesForExcel(_('Schedule type'),Row, Column, Sheet, ExcelInstalled);
      //Sheet.Cells[Row, Column].Value := _('Schedule type');
        Column := Column + 1;

      end;

      if ExcelInstalled then
        Sheet.Rows[Row].Interior.Color := clAqua;

    end;

    if not ReportSettings.IsBinReport then
    begin
      if SpaceLineNeeded then
       begin
         RowTemp := RowTemp + 1;
         Row := RowTemp;
         SpaceLineNeeded := false;
      end;
      if ReportSettings.ShowColumnsCaptions then
      begin
        RowTemp := RowTemp + 1;
        Row := RowTemp;
      end;
      if ReportSettings.FixColumnsReport then
      begin
        for B := 1 to 10 do
        begin
          if ReportSettings.BinFieldArrayReport[B].Field <> CSC_NotSorted then
          for F := low(ReportSettings.BinFieldsArray) to High(ReportSettings.BinFieldsArray) - 1 do
          begin
            if ReportSettings.BinFieldsArray[F].Field = ReportSettings.BinFieldArrayReport[B].Field then
            begin
              HeadingConcatenationColumn.Add(ReportSettings.BinFieldsArray[F].Title);
              if ReportSettings.ShowColumnsCaptions then
                WriteValuesForExcel(ReportSettings.BinFieldsArray[F].Title,Row, Column, Sheet, ExcelInstalled);
                //Sheet.Cells[Row, Column].Value := ReportSettings.BinFieldsArray[F].Title;
              Column := Column + 1;
              Inc(CounterFixedColumn);
              break;
            end;
          end;
        end;
      end;
    end;

   // if ReportSettings.ShowCaptionsAndTotal then
   // begin
    for i := 0 to High(BinColDefault) do
    begin
      pos := ActBinGrid.FindPos(i);
      ColAttributes := ActBinGrid.BinColumnSet[pos];
      if (ColAttributes.Field <> CSC_MsgFromHost) and ColAttributes.Visible then
      begin
        if ColAttributes.Title = '' then Field := _(getPropertyDesc(pos, ActBinGrid))
        else Field := _(ColAttributes.Title);
        HeadingConcatenationColumn.Add(Field);
        if ReportSettings.ShowColumnsCaptions then
          WriteValuesForExcel(Field,Row, Column, Sheet, ExcelInstalled);
          //Sheet.Cells[Row, Column].Value := Field;
        Column := Column + 1;

        colNum := colNum + 1;
        if ColAttributes.Field = CSC_ProgStart then ColumnStart := colNum
        else if ColAttributes.Field = CSC_ProdReq then ColumnProdReq := colNum
        else if ColAttributes.Field = CSC_ProgEnd then ColumnEnd := colNum
        else if ColAttributes.Field = CSC_Comment then ColumnComment := colNum
        else if ColAttributes.Field = CSC_QtyToSched then ColumnQtyToSched := colNum
        else if ColAttributes.Field = CSC_ExeTimeSched then ColumnExeTimeSched := colNum
        else if ColAttributes.Field = CSC_SupTimeSched then ColumnSupTimeSched := colNum
        else if ColAttributes.Field = CSC_ProgQty then ColumnProgQty := colNum
        else if ColAttributes.Field = CSC_FinQty then ColumnFinalQty := colNum
        else if ColAttributes.Field = CSC_ExeTime then ColumnStepExeTime := colNum
        else if ColAttributes.Field = CSC_ActualTime then ColumnActualExecTime := colNum
        else if ColAttributes.Field = CSC_Rsc then ColumnRes := colNum
        else if ColAttributes.Field = CSC_RscDesc then ColumnResDescr := colNum
        else if ColAttributes.Field = CSC_StepType then stepTypeIndex := i
        else if ColAttributes.Field = CSC_ReprocNo then stepTypeIndex := i;
      end;
    end;
    //end;

    WriteValuesForExcel(_('Mqm production speed for a day'),Row, Column, Sheet, ExcelInstalled);
    //Sheet.Cells[Row, Column].Value := _('Mqm production speed for a day');
    Column := Column + 1;
    WriteValuesForExcel(_('Prod. Sch. QTY for that day of production date'),Row, Column, Sheet, ExcelInstalled);
    //Sheet.Cells[Row, Column].Value := _('Prod. Sch. QTY for that day of production date');
  //  Column := Column + 1;
  //  Sheet.Cells[Row, Column].Value := _('Qty. progress for this current day');

    //////

    shading := false;
    ActiveFont := 5;
    SplitCriteria[4] := 'xxxxxxxxxxxxxxxxxxxx';
    for k := 0 to 3 do SplitCriteria[k] := '';

    // Create one table row per job
    for i := 0 to JobList.Count - 1 do
    begin
      Column := 1;
      ResChange := false;

      ResDet := JobList.Items[i];
      id := TSchedId(ResDet.ID);

      if not ResDet.IsProgress then
      begin
        ResDet.cal.OfsByWH((ResDet.SetUp)/60, true, ResDet.FromPlanInfo_StartDate, PlanInfo_StartDateWithSetup, ResDet.ActArea.m_CrossDownTmList);
        if PlanInfo_StartDateWithSetup > ReportSettings.DateTo then continue;
      end;


      RowTemp := RowTemp + 1;
      Row := RowTemp;

//      status := REC_OK;
      if (id <> CSchedIdNull) or (ResDet.Downtime) then
      begin
        // insert Day and Production date
        if ReportSettings.IsBinReport then
        begin
          Alignment:= eaLeft;

          p_sc.GetFldValue(id, CSC_ProgStart, Value, dataType);

          if ((I = 0) or ResChange) and (ResDet.FromPlanInfo_StartDate < ReportSettings.DateFrom) and
            (ResDet.FromPlanInfo_EndDate > ReportSettings.DateFrom) then// and (ResDet.FromPlanInfo_EndDate < ReportSettings.DateTo) then
          begin
            Value := ReportSettings.DateFrom;
            SavedproductionDate := (date - 100);

            if not ResDet.IsProgress then
            begin
              if PlanInfo_StartDateWithSetup > SavedproductionDate then
              begin


              end
              else
              begin

                ResDet.FromPlanInfo_StartDate := Value;
                PlanInfo_StartDateWithSetup   := ResDet.FromPlanInfo_StartDate;

              end;
            end;

          end;

          DecodeDate(Value, TmpYear, TmpMonth, TmpDay);
          TmpDate := EncodeDate(TmpYear, TmpMonth, TmpDay);

          if (SavedproductionDate = (date - 100)) then
          begin
            WriteValuesForExcel(DayOfWeekName(Value),Row, Column, Sheet, ExcelInstalled);
            //Sheet.Cells[Row, Column].Value := DayOfWeekName(Value);
            SavedproductionDate := TmpDate;
          end
          else
          begin
            if (SavedproductionDate <> TmpDate) then
            begin
              WriteValuesForExcel(DayOfWeekName(Value),Row, Column, Sheet, ExcelInstalled);
            //Sheet.Cells[Row, Column].Value := DayOfWeekName(Value);
              SavedproductionDate := TmpDate;
            end;
          end;

          Column := Column + 1;
          Alignment:= eaLeft;

          CopyDateTimeFormat := DateTimeFormat;

          if CopyDateTimeFormat = 'dd/MM/yyyy hh:mm' then
            CopyDateTimeFormat := 'dd/MM/yyyy';

          if ExcelInstalled then
            Sheet.Cells[Row, Column].NumberFormat := CopyDateTimeFormat;

          WriteValuesForExcel(Value,Row, Column, Sheet, ExcelInstalled);
            //Sheet.Cells[Row, Column].Value := value;

          Column := Column + 1;

          WriteValuesForExcel(ResDet.ScheduleType,Row, Column, Sheet, ExcelInstalled);
          //Sheet.Cells[Row, Column].Value := ResDet.ScheduleType;

          Column := Column + 1;


        end;


        // Fill fields of data row and add values to totals statistics
        for j := 0 to High(BinColDefault) do
        begin
          pos := ActBinGrid.FindPos(j);
          ColAttributes := ActBinGrid.BinColumnSet[pos];
          if ColAttributes.Field <> CSC_MsgFromHost then
          begin
            if ColAttributes.Visible and ResDet.Downtime then
            begin
              if ColAttributes.Field = CSC_ProdReq then
              begin
                WriteValuesForExcel(_('Downtime'),Row, ColumnProdReq + CounterFixedColumn, Sheet, ExcelInstalled);
                //Sheet.Cells[Row, ColumnProdReq + CounterFixedColumn].Value := _('Downtime');
                Column := Column + 1;
              end;

              if ColAttributes.Field = CSC_ProgStart then
              begin
                WriteValuesForExcel(StrToDateTime(ResDet.DownTimeFrom),Row, ColumnStart + CounterFixedColumn, Sheet, ExcelInstalled);
                //Sheet.Cells[Row, ColumnStart + CounterFixedColumn].Value := StrToDateTime(ResDet.DownTimeFrom); //FormatDateTime('dddd', StrToDateTime(ResDet.DownTimeFrom)) + ' ' + ResDet.DownTimeFrom;
                Column := Column + 1;
              end
              else if ColAttributes.Field = CSC_ProgEnd then
              begin
                WriteValuesForExcel(StrToDateTime(ResDet.DownTimeto),Row, ColumnEnd + CounterFixedColumn, Sheet, ExcelInstalled);
                //Sheet.Cells[Row, ColumnEnd + CounterFixedColumn].Value := StrToDateTime(ResDet.DownTimeto);  //FormatDateTime('dddd', StrToDateTime(ResDet.DownTimeTo)) + ' ' + ResDet.DownTimeTo;
                Column := Column + 1;
              end
              else if ColAttributes.Field = CSC_Comment then
              begin
                WriteValuesForExcel(ResDet.Comment,Row, ColumnComment + CounterFixedColumn, Sheet, ExcelInstalled);
                //Sheet.Cells[Row, ColumnComment + CounterFixedColumn].Value := ResDet.Comment;
                Column := Column + 1;
              end
              else if ColAttributes.Field = CSC_Rsc then
                begin
                  if ResDet.SubResCode = '' then
                  begin
                    WriteValuesForExcel(ResDet.ResCode,Row, ColumnRes + CounterFixedColumn, Sheet, ExcelInstalled);
                    //Sheet.Cells[Row, ColumnRes + CounterFixedColumn].Value := ResDet.ResCode;
                    Column := Column + 1;
                  end
                  else
                  begin
                    WriteValuesForExcel(ResDet.ResCode + SUBRESSEPARATOR + ResDet.SubResCode,Row, ColumnRes + CounterFixedColumn, Sheet, ExcelInstalled);
                    //Sheet.Cells[Row, ColumnRes + CounterFixedColumn].Value := ResDet.ResCode + SUBRESSEPARATOR + ResDet.SubResCode;
                    Column := Column + 1;
                  end;
                end
              else if (ColAttributes.Field = CSC_RscDesc) and (ResDet.ResDesc <> '') then
              begin
                WriteValuesForExcel(ResDet.ResDesc,Row, ColumnResDescr + CounterFixedColumn, Sheet, ExcelInstalled);
                //Sheet.Cells[Row, ColumnResDescr + CounterFixedColumn].Value := ResDet.ResDesc;
                Column := Column + 1;
              end;
              if ReportSettings.IncDowntime then
              begin
                tmpTime := 1440 * (StrToDateTime(ResDet.DownTimeTo) - StrToDateTime(ResDet.DownTimeFrom));
                if ColAttributes.Field = CSC_ExeTimeSched then
                begin
                  WriteValuesForExcel(FormatDuration(tmpTime, true),Row, ColumnExeTimeSched + CounterFixedColumn, Sheet, ExcelInstalled);
                  //Sheet.Cells[Row, ColumnExeTimeSched + CounterFixedColumn].Value := FormatDuration(tmpTime, true);
                  Column := Column + 1;

                  sumSchedExecTime := sumSchedExecTime + Round(tmpTime);
                end
                else if ColAttributes.Field = CSC_ExeTime then
                begin
                  WriteValuesForExcel(FormatDuration(tmpTime, true),Row, ColumnStepExeTime + CounterFixedColumn, Sheet, ExcelInstalled);
                  //Sheet.Cells[Row, ColumnStepExeTime + CounterFixedColumn].Value := FormatDuration(tmpTime, true);
                  Column := Column + 1;
                  sumStepExeMin := sumStepExeMin + Round(tmpTime);
                end;
              end;
            end
            else if ColAttributes.Visible then
            begin
              if (ShowContinueGroupLinesInBin <> CsSCG_No) or ShowBatchGroupLinesInBin then
              begin
                p_sc.GetPlanInfo(Id, planInfo);
                if planInfo.isGroup then
                begin
                  Id := p_sc.GetGrpSon(Id, 0);
                end;
              end;

              if not p_sc.GetFldValue(Id, ColAttributes.Field, Value, dataType) then
              begin
                if (ColAttributes.Field = CSC_SchedStart) or (ColAttributes.Field = CSC_SchedEnd) then
                   Value := '---';
              end;

              if (ColAttributes.Field = CSC_GroupNo) and (Value = '-1') then Value := '';

              FieldValue := VarToStr(Value);

              if (Trim(FieldValue) = '') and not isproperty(ColAttributes.Field) then FieldValue := '---';

              FixAlphaStructure(ColAttributes.Field, FieldValue);

              if ColAttributes.Field in [CSC_ExeTime, CSC_PlanSetup, CSC_ExeTimeSched, CSC_ActualTime,
                                         CSC_SupTimeSched] then
              begin
                if not ReportSettings.IsBinReport then
                begin
                  if ColAttributes.Field = CSC_ExeTimeSched then sumSchedExecTime := sumSchedExecTime + Value
                  else if ColAttributes.Field = CSC_SupTimeSched then sumSetupTime := sumSetupTime + Value
                  else if ColAttributes.Field = CSC_ExeTime then sumStepExeMin := sumStepExeMin + Value
                  else if ColAttributes.Field = CSC_ActualTime then sumActualExecTime := sumActualExecTime + Value
                end;
                if DBAppSettings.ReportTimeFormat = '1' then
                  FieldValue := Value
                else
                  FieldValue := p_sc.GetFldDescr(id, ColAttributes.Field, true);

                WriteValuesForExcel(FieldValue,Row, Column, Sheet, ExcelInstalled);
                //Sheet.Cells[Row, Column].Value := FieldValue;
                Column := Column + 1;
              end
              else
              begin
                if not ReportSettings.IsBinReport then
                begin
                  if ColAttributes.Field = CSC_QtyToSched then sumQtyToSched := sumQtyToSched + Round(Value)
                  else if ColAttributes.Field = CSC_ProgQty then sumProgQty := sumProgQty + Round(Value)
                  else if ColAttributes.Field = CSC_FinQty then sumFinQty := sumFinQty + Round(Value);
                end;
                if (dataType <> CBT_integer) and (dataType <> CBT_float) and
                   (stepGroupIndex = j) and (FieldValue = IntToStr(-1)) then FieldValue := '---';
                if stepTypeIndex = j then
                begin
                  case StrToInt(FieldValue) of
                    1: FieldValue := _('Batch');
                    2: FieldValue := _('Continuous');
                  end;
                  dataType := CBT_string;
                end;
                if ColAttributes.Field = CSC_Rsc then
                begin
                  if ExcelInstalled then
                    Sheet.Columns[Column].NumberFormat := '#.##0,00';//AnsiChar('@');  // set format as text

                  WriteValuesForExcel(ResDet.ResCode,Row, Column, Sheet, ExcelInstalled);
                  //Sheet.Cells[Row, Column].Value := ResDet.ResCode;
                  Column := Column + 1;
                end
                else if (dataType = CBT_float) or (dataType = CBT_integer) then
                begin
                  if IsProperty(ColAttributes.Field) then
                  begin
                    if VarType(value) = varEmpty then
                      WriteValuesForExcel('',Row, Column, Sheet, ExcelInstalled)
                    //Sheet.Cells[Row, Column].Value := ''
                    else
                      WriteValuesForExcel(Value,Row, Column, Sheet, ExcelInstalled);
                      //Sheet.Cells[Row, Column].Value := Value; // working for BIG 05/10/2017
                    Column := Column + 1;
                  end
                  else
                  begin
                    WriteValuesForExcel(Value,Row, Column, Sheet, ExcelInstalled);
                    //Sheet.Cells[Row, Column].Value :=  Value; // RoundDblToDbl(Value, 0)
                    Column := Column + 1;
                  end;
                end
                else if (dataType = CBT_date) and (IsEmptyDateTime(FieldValue)) then
                begin
                  WriteValuesForExcel('---',Row, Column, Sheet, ExcelInstalled);
                  //Sheet.Cells[Row, Column].Value := '---';
                  Column := Column + 1;
                end
                else
                begin
                  if (dataType = CBT_date) then
                  begin
                    if ExcelInstalled then
                    begin
                      Sheet.Cells[Row, Column].HorizontalAlignment := -4131; // alligned left.
                      Sheet.Cells[Row, Column].NumberFormat := DateTimeFormat;//'@'; // working for BIG 05/10/2017  //AnsiChar('@');
                    end;
                    WriteValuesForExcel(Value, Row, Column, Sheet, ExcelInstalled);
                    //Sheet.Cells[Row, Column].Value := Value;//FieldValue;
                    Column := Column + 1;
                  end
                  else
                  begin
                    if ExcelInstalled then
                      Sheet.Cells[Row, Column].NumberFormat := '@'; // working for BIG 05/10/2017
                    WriteValuesForExcel(FieldValue,Row, Column, Sheet, ExcelInstalled);
                  //Sheet.Cells[Row, Column].Value := FieldValue;
                    Column := Column + 1;
                  end;
                end;
              end;
            end;
          end;
        end;

    p_sc.GetFldValue(Id, CSC_QtyToSched, qty, dataType);

    if ResDet.FromPlanInfo_OrigExe = 0 then
      Value := qty
    else
      Value := qty/ResDet.FromPlanInfo_OrigExe * 1440;
    value := roundto(Value, -3);

    WriteValuesForExcel(Value,Row, Column, Sheet, ExcelInstalled);
    //Sheet.Cells[Row, Column].Value := value;
    Column := Column + 1;

    if not ResDet.IsProgress then
    begin

      if ResDet.FromPlanInfo_Exe > 0  then
      begin
        // do it when setup is higher

        TotalWorkH := ResDet.FromPlanInfo_Exe;

        if ((I = 0) or ResChange) and (PlanInfo_StartDateWithSetup < ReportSettings.DateFrom) and
           (ResDet.FromPlanInfo_EndDate > ReportSettings.DateFrom) and (ResDet.FromPlanInfo_EndDate < ReportSettings.DateTo) and (ResDet.FromPlanInfo_EndDate < (SavedproductionDate + 1)) then
        begin
        //  ResDet.cal.OfsByWH((ResDet.SetUp)/60, true, ResDet.FromPlanInfo_StartDate, PlanInfo_StartDateWithSetup, ResDet.ActArea.m_CrossDownTmList);
          if PlanInfo_StartDateWithSetup < ReportSettings.DateFrom then
            PlanInfo_StartDateWithSetup := ReportSettings.DateFrom;
          WorkH := ResDet.cal.DiffWH(PlanInfo_StartDateWithSetup, ResDet.FromPlanInfo_EndDate , ResDet.ActArea.m_CrossDownTmList)*60;
          Value := WorkH * (qty/TotalWorkH);
          value := roundto(Value, -3);
          WriteValuesForExcel(Value,Row, Column, Sheet, ExcelInstalled);
          //Sheet.Cells[Row, Column].Value := Value;
        end
        else if (PlanInfo_StartDateWithSetup >= SavedproductionDate) and (ResDet.FromPlanInfo_EndDate <= (SavedproductionDate + 1)) then
        begin
          p_sc.GetFldValue(Id, CSC_QtyToSched, Value, dataType);
          value := roundto(Value, -3);
          WriteValuesForExcel(Value,Row, Column, Sheet, ExcelInstalled);
          //Sheet.Cells[Row, Column].Value := Value;
        end
        else
        begin

          if (PlanInfo_StartDateWithSetup >= SavedproductionDate) and (PlanInfo_StartDateWithSetup < SavedproductionDate + 1) then
          begin

            if (ResDet.FromPlanInfo_EndDate > SavedproductionDate) and (ResDet.FromPlanInfo_EndDate < (SavedproductionDate + 1)) then
               WorkH := ResDet.cal.DiffWH(PlanInfo_StartDateWithSetup , ResDet.FromPlanInfo_EndDate, ResDet.ActArea.m_CrossDownTmList)*60
            else if (PlanInfo_StartDateWithSetup > SavedproductionDate) and (PlanInfo_StartDateWithSetup < (SavedproductionDate + 1)) then
            begin
              if (ReportSettings.DateTo = (SavedproductionDate + 1)) then
                WorkH := ResDet.cal.DiffWH(PlanInfo_StartDateWithSetup , ReportSettings.DateTo, ResDet.ActArea.m_CrossDownTmList)*60
              else
                WorkH := ResDet.cal.DiffWH(PlanInfo_StartDateWithSetup , SavedproductionDate + 1, ResDet.ActArea.m_CrossDownTmList)*60
            end
            else
              WorkH := ResDet.cal.DiffWH(PlanInfo_StartDateWithSetup , SavedproductionDate + 1, ResDet.ActArea.m_CrossDownTmList)*60;

            value := WorkH * (qty/TotalWorkH);
            value := roundto(Value, -3);
            WriteValuesForExcel(Value,Row, Column, Sheet, ExcelInstalled);
            //Sheet.Cells[Row, Column].Value := Value;

        {    if ((I > 0) and not ResChange) and (ResDet.FromPlanInfo_EndDate < (ReportSettings.DateTo)) then
            begin
              RowTemp := RowTemp + 1;
              Row := RowTemp;
            end;  }
          end

          else if (PlanInfo_StartDateWithSetup <= SavedproductionDate) and (ResDet.FromPlanInfo_EndDate > SavedproductionDate + 1) then
          begin
            PlanInfo_StartDateWithSetup := SavedproductionDate;

            if (ResDet.FromPlanInfo_EndDate > SavedproductionDate) and (ResDet.FromPlanInfo_EndDate < (SavedproductionDate + 1)) then
               WorkH := ResDet.cal.DiffWH(PlanInfo_StartDateWithSetup , ResDet.FromPlanInfo_EndDate, ResDet.ActArea.m_CrossDownTmList)*60
            else
              WorkH := ResDet.cal.DiffWH(PlanInfo_StartDateWithSetup , SavedproductionDate + 1, ResDet.ActArea.m_CrossDownTmList)*60;

            value := WorkH * (qty/TotalWorkH);
            value := roundto(Value, -3);
            WriteValuesForExcel(Value,Row, Column, Sheet, ExcelInstalled);
            //Sheet.Cells[Row, Column].Value := Value;

         {   if (ResDet.FromPlanInfo_EndDate < ReportSettings.DateTo) then
            begin
              RowTemp := RowTemp + 1;
              Row := RowTemp;
            end;  }
          end;

          RowTemp := RowTemp + 1;
          Row := RowTemp;


          NumberOfDays := 0;

          if (ResDet.FromPlanInfo_EndDate < ReportSettings.DateTo) then
            NumberOfDays := trunc(ResDet.FromPlanInfo_EndDate) - Trunc(SavedproductionDate);


          for D := 1 to NumberOfDays do
          begin

            // print the same job data

            DecodeDate(SavedproductionDate + D, TmpYear, TmpMonth, TmpDay);

            TmpDate := EncodeDate(TmpYear, TmpMonth, TmpDay);

            if ExcelInstalled then
              Sheet.Cells[Row, 2].NumberFormat := CopyDateTimeFormat;

            WriteValuesForExcel(TmpDate,Row, 2, Sheet, ExcelInstalled);
            //Sheet.Cells[Row, 2].Value := TmpDate;

            value := qty/ResDet.FromPlanInfo_Exe * 1440;
            value := roundto(Value, -3);
            WriteValuesForExcel(Value,Row, Column - 1, Sheet, ExcelInstalled);
            //Sheet.Cells[Row, Column - 1].Value := Value;

            TempDate := SavedproductionDate + D;
            WriteValuesForExcel(DayOfWeekName(TempDate),Row, 1, Sheet, ExcelInstalled);
            //Sheet.Cells[Row, 1] := DayOfWeekName(TempDate);

            WriteValuesForExcel(ResDet.ScheduleType,Row, 3, Sheet, ExcelInstalled);
            //Sheet.Cells[Row, 3].Value := ResDet.ScheduleType;

            if (ResDet.FromPlanInfo_EndDate > (SavedproductionDate + D)) and (ResDet.FromPlanInfo_EndDate < (SavedproductionDate + D + 1)) then
               WorkH := ResDet.cal.DiffWH(TempDate, ResDet.FromPlanInfo_EndDate , ResDet.ActArea.m_CrossDownTmList)*60
            else
              WorkH := ResDet.cal.DiffWH(TempDate, TempDate + 1 , ResDet.ActArea.m_CrossDownTmList)*60;

            value := WorkH * (qty/TotalWorkH);
            value := roundto(Value, -3);
            WriteValuesForExcel(Value,Row, Column, Sheet, ExcelInstalled);
            //Sheet.Cells[Row, Column].Value := Value;

            //////////  print same job data
            Column := 4;

            for j := 0 to High(BinColDefault) do
            begin
              pos := ActBinGrid.FindPos(j);
              ColAttributes := ActBinGrid.BinColumnSet[pos];
              if ColAttributes.Field <> CSC_MsgFromHost then
              begin
                if ColAttributes.Visible and ResDet.Downtime then
                begin
                  if ColAttributes.Field = CSC_ProdReq then
                  begin
                    WriteValuesForExcel(_('Downtime'),Row, ColumnProdReq + CounterFixedColumn, Sheet, ExcelInstalled);
                    //Sheet.Cells[Row, ColumnProdReq + CounterFixedColumn].Value := _('Downtime');
                    Column := Column + 1;
                  end;

                  if ColAttributes.Field = CSC_ProgStart then
                  begin
                    WriteValuesForExcel(StrToDateTime(ResDet.DownTimeFrom),Row, ColumnStart + CounterFixedColumn, Sheet, ExcelInstalled);
                    //Sheet.Cells[Row, ColumnStart + CounterFixedColumn].Value := StrToDateTime(ResDet.DownTimeFrom); //FormatDateTime('dddd', StrToDateTime(ResDet.DownTimeFrom)) + ' ' + ResDet.DownTimeFrom;
                    Column := Column + 1;
                  end
                  else if ColAttributes.Field = CSC_ProgEnd then
                  begin
                    WriteValuesForExcel(StrToDateTime(ResDet.DownTimeto),Row, ColumnEnd + CounterFixedColumn, Sheet, ExcelInstalled);
                    //Sheet.Cells[Row, ColumnEnd + CounterFixedColumn].Value := StrToDateTime(ResDet.DownTimeto);  //FormatDateTime('dddd', StrToDateTime(ResDet.DownTimeTo)) + ' ' + ResDet.DownTimeTo;
                    Column := Column + 1;
                  end
                  else if ColAttributes.Field = CSC_Comment then
                  begin
                    WriteValuesForExcel(ResDet.Comment,Row, ColumnComment + CounterFixedColumn, Sheet, ExcelInstalled);
                    //Sheet.Cells[Row, ColumnComment + CounterFixedColumn].Value := ResDet.Comment;
                    Column := Column + 1;
                  end
                  else if ColAttributes.Field = CSC_Rsc then
                    begin
                      if ResDet.SubResCode = '' then
                      begin
                        WriteValuesForExcel(ResDet.ResCode,Row, ColumnRes + CounterFixedColumn, Sheet, ExcelInstalled);
                        //Sheet.Cells[Row, ColumnRes + CounterFixedColumn].Value := ResDet.ResCode;
                        Column := Column + 1;
                      end
                      else
                      begin
                        WriteValuesForExcel(ResDet.ResCode + SUBRESSEPARATOR + ResDet.SubResCode,Row, ColumnRes + CounterFixedColumn, Sheet, ExcelInstalled);
                        //Sheet.Cells[Row, ColumnRes + CounterFixedColumn].Value := ResDet.ResCode + SUBRESSEPARATOR + ResDet.SubResCode;
                        Column := Column + 1;
                      end;
                    end
                  else if (ColAttributes.Field = CSC_RscDesc) and (ResDet.ResDesc <> '') then
                  begin
                    WriteValuesForExcel(ResDet.ResDesc,Row, ColumnResDescr + CounterFixedColumn, Sheet, ExcelInstalled);
                    //Sheet.Cells[Row, ColumnResDescr + CounterFixedColumn].Value := ResDet.ResDesc;
                    Column := Column + 1;
                  end;
                  if ReportSettings.IncDowntime then
                  begin
                    tmpTime := 1440 * (StrToDateTime(ResDet.DownTimeTo) - StrToDateTime(ResDet.DownTimeFrom));
                    if ColAttributes.Field = CSC_ExeTimeSched then
                    begin
                      WriteValuesForExcel(FormatDuration(tmpTime, true),Row, ColumnExeTimeSched + CounterFixedColumn, Sheet, ExcelInstalled);
                    //Sheet.Cells[Row, ColumnExeTimeSched + CounterFixedColumn].Value := FormatDuration(tmpTime, true);
                      Column := Column + 1;

                      sumSchedExecTime := sumSchedExecTime + Round(tmpTime);
                    end
                    else if ColAttributes.Field = CSC_ExeTime then
                    begin
                      WriteValuesForExcel(FormatDuration(tmpTime, true),Row, ColumnStepExeTime + CounterFixedColumn, Sheet, ExcelInstalled);
                    //Sheet.Cells[Row, ColumnStepExeTime + CounterFixedColumn].Value := FormatDuration(tmpTime, true);
                      Column := Column + 1;
                      sumStepExeMin := sumStepExeMin + Round(tmpTime);
                    end;
                  end;
                end
                else if ColAttributes.Visible then
                begin
                  if (ShowContinueGroupLinesInBin <> CsSCG_No) or ShowBatchGroupLinesInBin then
                  begin
                    p_sc.GetPlanInfo(Id, planInfo);
                    if planInfo.isGroup then
                    begin
                      Id := p_sc.GetGrpSon(Id, 0);
                    end;
                  end;

                  if not p_sc.GetFldValue(Id, ColAttributes.Field, Value, dataType) then
                  begin
                    if (ColAttributes.Field = CSC_SchedStart) or (ColAttributes.Field = CSC_SchedEnd) then
                       Value := '---';
                  end;

                  if (ColAttributes.Field = CSC_GroupNo) and (Value = '-1') then Value := '';

                  FieldValue := VarToStr(Value);

                  if (Trim(FieldValue) = '') and not isproperty(ColAttributes.Field) then FieldValue := '---';

                  FixAlphaStructure(ColAttributes.Field, FieldValue);

                  if ColAttributes.Field in [CSC_ExeTime, CSC_PlanSetup, CSC_ExeTimeSched, CSC_ActualTime,
                                             CSC_SupTimeSched] then
                  begin
                    if not ReportSettings.IsBinReport then
                    begin
                      if ColAttributes.Field = CSC_ExeTimeSched then sumSchedExecTime := sumSchedExecTime + Value
                      else if ColAttributes.Field = CSC_SupTimeSched then sumSetupTime := sumSetupTime + Value
                      else if ColAttributes.Field = CSC_ExeTime then sumStepExeMin := sumStepExeMin + Value
                      else if ColAttributes.Field = CSC_ActualTime then sumActualExecTime := sumActualExecTime + Value
                    end;
                    if DBAppSettings.ReportTimeFormat = '1' then
                      FieldValue := Value
                    else
                      FieldValue := p_sc.GetFldDescr(id, ColAttributes.Field, true);
                    WriteValuesForExcel(FieldValue,Row, Column, Sheet, ExcelInstalled);
                    //Sheet.Cells[Row, Column].Value := FieldValue;
                    Column := Column + 1;
                  end
                  else
                  begin
                    if not ReportSettings.IsBinReport then
                    begin
                      if ColAttributes.Field = CSC_QtyToSched then sumQtyToSched := sumQtyToSched + Round(Value)
                      else if ColAttributes.Field = CSC_ProgQty then sumProgQty := sumProgQty + Round(Value)
                      else if ColAttributes.Field = CSC_FinQty then sumFinQty := sumFinQty + Round(Value);
                    end;
                    if (dataType <> CBT_integer) and (dataType <> CBT_float) and
                       (stepGroupIndex = j) and (FieldValue = IntToStr(-1)) then FieldValue := '---';
                    if stepTypeIndex = j then
                    begin
                      case StrToInt(FieldValue) of
                        1: FieldValue := _('Batch');
                        2: FieldValue := _('Continuous');
                      end;
                      dataType := CBT_string;
                    end;
                    if ColAttributes.Field = CSC_Rsc then
                    begin
                      if ExcelInstalled then
                        Sheet.Columns[Column].NumberFormat := '#.##0,00';//AnsiChar('@');  // set format as text
                      WriteValuesForExcel(ResDet.ResCode,Row, Column, Sheet, ExcelInstalled);
                    //Sheet.Cells[Row, Column].Value := ResDet.ResCode;
                      Column := Column + 1;
                    end
                    else if (dataType = CBT_float) or (dataType = CBT_integer) then
                    begin
                      if IsProperty(ColAttributes.Field) then
                      begin
                        if VarType(value) = varEmpty then
                          WriteValuesForExcel('',Row, Column, Sheet, ExcelInstalled)
                          //Sheet.Cells[Row, Column].Value := ''
                        else
                          WriteValuesForExcel(Value,Row, Column, Sheet, ExcelInstalled);
                          //Sheet.Cells[Row, Column].Value := Value; // working for BIG 05/10/2017
                        Column := Column + 1;
                      end
                      else
                      begin
                        WriteValuesForExcel(Value,Row, Column, Sheet, ExcelInstalled);
                        //Sheet.Cells[Row, Column].Value :=  Value; // RoundDblToDbl(Value, 0)
                        Column := Column + 1;
                      end;
                    end
                    else if (dataType = CBT_date) and (IsEmptyDateTime(FieldValue)) then
                    begin
                      WriteValuesForExcel('---',Row, Column, Sheet, ExcelInstalled);
                      //Sheet.Cells[Row, Column].Value := '---';
                      Column := Column + 1;
                    end
                    else
                    begin
                      if (dataType = CBT_date) then
                      begin
                        if ExcelInstalled then
                        begin
                          Sheet.Cells[Row, Column].HorizontalAlignment := -4131; // alligned left.
                          Sheet.Cells[Row, Column].NumberFormat := DateTimeFormat;//'@'; // working for BIG 05/10/2017  //AnsiChar('@');
                        end;
                        WriteValuesForExcel(Value,Row, Column, Sheet, ExcelInstalled);
                        //Sheet.Cells[Row, Column].Value := Value;//FieldValue;
                        Column := Column + 1;
                      end
                      else
                      begin
                        if ExcelInstalled then
                          Sheet.Cells[Row, Column].NumberFormat := '@'; // working for BIG 05/10/2017
                        WriteValuesForExcel(FieldValue,Row, Column, Sheet, ExcelInstalled);
                        //Sheet.Cells[Row, Column].Value := FieldValue;
                        Column := Column + 1;
                      end;
                    end;
                  end;
                end;
              end;
            end;

            //////////

            if D < NumberOfDays then
            begin
              RowTemp := RowTemp + 1;
              Row := RowTemp;
            end;

            Column := Column + 1;

          end;

         // Column := Column + 1;

          SavedproductionDate := TmpDate;

        end;

      end


    end
    else
    begin

      // case of progress

      if ResDet.FromPlanInfo_Exe > 0  then
      begin

        TotalWorkH := ResDet.FromPlanInfo_Exe;

        if ((I = 0) or ResChange) and (ResDet.FromPlanInfo_StartDate < ReportSettings.DateFrom) and
           (ResDet.FromPlanInfo_EndDate > ReportSettings.DateFrom) and (ResDet.FromPlanInfo_EndDate < ReportSettings.DateTo) and (ResDet.FromPlanInfo_EndDate < (SavedproductionDate + 1)) then
        begin
        //  ResDet.cal.OfsByWH((ResDet.SetUp)/60, true, ResDet.FromPlanInfo_StartDate, PlanInfo_StartDateWithSetup, ResDet.ActArea.m_CrossDownTmList);
          if ResDet.FromPlanInfo_StartDate < ReportSettings.DateFrom then
            ResDet.FromPlanInfo_StartDate := ReportSettings.DateFrom;
          WorkH := ResDet.cal.DiffWH(ResDet.FromPlanInfo_StartDate, ResDet.FromPlanInfo_EndDate , ResDet.ActArea.m_CrossDownTmList)*60;
          value := WorkH * (qty/TotalWorkH);
          value := roundto(Value, -3);
          WriteValuesForExcel(Value,Row, Column, Sheet, ExcelInstalled);
          //Sheet.Cells[Row, Column].Value := Value;
        end
        else if (ResDet.FromPlanInfo_StartDate >= SavedproductionDate) and (ResDet.FromPlanInfo_EndDate <= (SavedproductionDate + 1)) then
        begin
          p_sc.GetFldValue(Id, CSC_QtyToSched, Value, dataType);
          value := roundto(Value, -3);
          WriteValuesForExcel(Value,Row, Column, Sheet, ExcelInstalled);
          //Sheet.Cells[Row, Column].Value := Value;
        end

        else
        begin

          if (ResDet.FromPlanInfo_StartDate >= SavedproductionDate) and (ResDet.FromPlanInfo_StartDate < SavedproductionDate + 1) then
          begin

            if (ResDet.FromPlanInfo_EndDate > SavedproductionDate) and (ResDet.FromPlanInfo_EndDate < (SavedproductionDate + 1)) then
               WorkH := ResDet.cal.DiffWH(ResDet.FromPlanInfo_StartDate , ResDet.FromPlanInfo_EndDate, ResDet.ActArea.m_CrossDownTmList)*60
            else if (ResDet.FromPlanInfo_StartDate > SavedproductionDate) and (ResDet.FromPlanInfo_StartDate < (SavedproductionDate + 1)) then
            begin
              if (ReportSettings.DateTo = (SavedproductionDate + 1)) then
                WorkH := ResDet.cal.DiffWH(ResDet.FromPlanInfo_StartDate , ReportSettings.DateTo, ResDet.ActArea.m_CrossDownTmList)*60
              else
                WorkH := ResDet.cal.DiffWH(ResDet.FromPlanInfo_StartDate , SavedproductionDate + 1, ResDet.ActArea.m_CrossDownTmList)*60
            end
            else
              WorkH := ResDet.cal.DiffWH(ResDet.FromPlanInfo_StartDate , SavedproductionDate + 1, ResDet.ActArea.m_CrossDownTmList)*60;

            value := WorkH * (qty/TotalWorkH);
            value := roundto(Value, -3);
            WriteValuesForExcel(Value,Row, Column, Sheet, ExcelInstalled);
          //Sheet.Cells[Row, Column].Value := Value;//WorkH * (qty/TotalWorkH);

        {    if ((I > 0) and not ResChange) and (ResDet.FromPlanInfo_EndDate < (ReportSettings.DateTo)) then
            begin
              RowTemp := RowTemp + 1;
              Row := RowTemp;
            end;  }
          end

          else if (ResDet.FromPlanInfo_StartDate <= SavedproductionDate) and (ResDet.FromPlanInfo_EndDate > SavedproductionDate + 1) then
          begin
            ResDet.FromPlanInfo_StartDate := SavedproductionDate;

            if (ResDet.FromPlanInfo_EndDate > SavedproductionDate) and (ResDet.FromPlanInfo_EndDate < (SavedproductionDate + 1)) then
               WorkH := ResDet.cal.DiffWH(ResDet.FromPlanInfo_StartDate , ResDet.FromPlanInfo_EndDate, ResDet.ActArea.m_CrossDownTmList)*60
            else
              WorkH := ResDet.cal.DiffWH(ResDet.FromPlanInfo_StartDate , SavedproductionDate + 1, ResDet.ActArea.m_CrossDownTmList)*60;

            value := WorkH * (qty/TotalWorkH);
            value := roundto(Value, -3);
            WriteValuesForExcel(Value,Row, Column, Sheet, ExcelInstalled);
          //Sheet.Cells[Row, Column].Value := Value;

         {   if (ResDet.FromPlanInfo_EndDate < ReportSettings.DateTo) then
            begin
              RowTemp := RowTemp + 1;
              Row := RowTemp;
            end;  }
          end;

          RowTemp := RowTemp + 1;
          Row := RowTemp;


          NumberOfDays := 0;

          if (ResDet.FromPlanInfo_EndDate < ReportSettings.DateTo) then
            NumberOfDays := trunc(ResDet.FromPlanInfo_EndDate) - Trunc(SavedproductionDate);


          for D := 1 to NumberOfDays do
          begin

            // print the same job data

            DecodeDate(SavedproductionDate + D, TmpYear, TmpMonth, TmpDay);

            TmpDate := EncodeDate(TmpYear, TmpMonth, TmpDay);

            if ExcelInstalled then
              Sheet.Cells[Row, 2].NumberFormat := CopyDateTimeFormat;

            WriteValuesForExcel(TmpDate,Row, 2, Sheet, ExcelInstalled);
          //Sheet.Cells[Row, 2].Value := TmpDate;

            value := qty/ResDet.FromPlanInfo_Exe * 1440;
            value := roundto(Value, -3);
            WriteValuesForExcel(Value,Row, Column - 1, Sheet, ExcelInstalled);
          //Sheet.Cells[Row, Column - 1].Value := Value;

            TempDate := SavedproductionDate + D;
            WriteValuesForExcel(DayOfWeekName(TempDate),Row, 1, Sheet, ExcelInstalled);
          //Sheet.Cells[Row, 1] := DayOfWeekName(TempDate);

            if (ResDet.FromPlanInfo_EndDate > (SavedproductionDate + D)) and (ResDet.FromPlanInfo_EndDate < (SavedproductionDate + D + 1)) then
               WorkH := ResDet.cal.DiffWH(TempDate, ResDet.FromPlanInfo_EndDate , ResDet.ActArea.m_CrossDownTmList)*60
            else
              WorkH := ResDet.cal.DiffWH(TempDate, TempDate + 1 , ResDet.ActArea.m_CrossDownTmList)*60;

            value := WorkH * (qty/TotalWorkH);
            value := roundto(Value, -3);
            WriteValuesForExcel(Value,Row, Column, Sheet, ExcelInstalled);
          //Sheet.Cells[Row, Column].Value := Value;

            //////////  print same job data
            Column := 4;

            for j := 0 to High(BinColDefault) do
            begin
              pos := ActBinGrid.FindPos(j);
              ColAttributes := ActBinGrid.BinColumnSet[pos];
              if ColAttributes.Field <> CSC_MsgFromHost then
              begin
                if ColAttributes.Visible and ResDet.Downtime then
                begin
                  if ColAttributes.Field = CSC_ProdReq then
                  begin
                    WriteValuesForExcel(_('Downtime'),Row, ColumnProdReq + CounterFixedColumn, Sheet, ExcelInstalled);
                    //Sheet.Cells[Row, ColumnProdReq + CounterFixedColumn].Value := _('Downtime');
                    Column := Column + 1;
                  end;

                  if ColAttributes.Field = CSC_ProgStart then
                  begin
                    WriteValuesForExcel(StrToDateTime(ResDet.DownTimeFrom),Row, ColumnStart + CounterFixedColumn, Sheet, ExcelInstalled);
                    //Sheet.Cells[Row, ColumnStart + CounterFixedColumn].Value := StrToDateTime(ResDet.DownTimeFrom); //FormatDateTime('dddd', StrToDateTime(ResDet.DownTimeFrom)) + ' ' + ResDet.DownTimeFrom;
                    Column := Column + 1;
                  end
                  else if ColAttributes.Field = CSC_ProgEnd then
                  begin
                    WriteValuesForExcel(StrToDateTime(ResDet.DownTimeto),Row, ColumnEnd + CounterFixedColumn, Sheet, ExcelInstalled);
                    //Sheet.Cells[Row, ColumnEnd + CounterFixedColumn].Value := StrToDateTime(ResDet.DownTimeto);  //FormatDateTime('dddd', StrToDateTime(ResDet.DownTimeTo)) + ' ' + ResDet.DownTimeTo;
                    Column := Column + 1;
                  end
                  else if ColAttributes.Field = CSC_Comment then
                  begin
                    WriteValuesForExcel(ResDet.Comment,Row, ColumnComment + CounterFixedColumn, Sheet, ExcelInstalled);
                    //Sheet.Cells[Row, ColumnComment + CounterFixedColumn].Value := ResDet.Comment;
                    Column := Column + 1;
                  end
                  else if ColAttributes.Field = CSC_Rsc then
                    begin
                      if ResDet.SubResCode = '' then
                      begin
                        WriteValuesForExcel(ResDet.ResCode,Row, ColumnRes + CounterFixedColumn, Sheet, ExcelInstalled);
                        //Sheet.Cells[Row, ColumnRes + CounterFixedColumn].Value := ResDet.ResCode;
                        Column := Column + 1;
                      end
                      else
                      begin
                        WriteValuesForExcel(ResDet.ResCode + SUBRESSEPARATOR + ResDet.SubResCode,Row, ColumnRes + CounterFixedColumn, Sheet, ExcelInstalled);
                        //Sheet.Cells[Row, ColumnRes + CounterFixedColumn].Value := ResDet.ResCode + SUBRESSEPARATOR + ResDet.SubResCode;
                        Column := Column + 1;
                      end;
                    end
                  else if (ColAttributes.Field = CSC_RscDesc) and (ResDet.ResDesc <> '') then
                  begin
                    WriteValuesForExcel(ResDet.ResDesc,Row, ColumnResDescr + CounterFixedColumn, Sheet, ExcelInstalled);
                    //Sheet.Cells[Row, ColumnResDescr + CounterFixedColumn].Value := ResDet.ResDesc;
                    Column := Column + 1;
                  end;
                  if ReportSettings.IncDowntime then
                  begin
                    tmpTime := 1440 * (StrToDateTime(ResDet.DownTimeTo) - StrToDateTime(ResDet.DownTimeFrom));
                    if ColAttributes.Field = CSC_ExeTimeSched then
                    begin
                      WriteValuesForExcel(FormatDuration(tmpTime, true),Row, ColumnExeTimeSched + CounterFixedColumn, Sheet, ExcelInstalled);
                    //Sheet.Cells[Row, ColumnExeTimeSched + CounterFixedColumn].Value := FormatDuration(tmpTime, true);
                      Column := Column + 1;

                      sumSchedExecTime := sumSchedExecTime + Round(tmpTime);
                    end
                    else if ColAttributes.Field = CSC_ExeTime then
                    begin
                      WriteValuesForExcel(FormatDuration(tmpTime, true),Row, ColumnStepExeTime + CounterFixedColumn, Sheet, ExcelInstalled);
                    //Sheet.Cells[Row, ColumnStepExeTime + CounterFixedColumn].Value := FormatDuration(tmpTime, true);
                      Column := Column + 1;
                      sumStepExeMin := sumStepExeMin + Round(tmpTime);
                    end;
                  end;
                end
                else if ColAttributes.Visible then
                begin
                  if (ShowContinueGroupLinesInBin <> CsSCG_No) or ShowBatchGroupLinesInBin then
                  begin
                    p_sc.GetPlanInfo(Id, planInfo);
                    if planInfo.isGroup then
                    begin
                      Id := p_sc.GetGrpSon(Id, 0);
                    end;
                  end;

                  if not p_sc.GetFldValue(Id, ColAttributes.Field, Value, dataType) then
                  begin
                    if (ColAttributes.Field = CSC_SchedStart) or (ColAttributes.Field = CSC_SchedEnd) then
                       Value := '---';
                  end;

                  if (ColAttributes.Field = CSC_GroupNo) and (Value = '-1') then Value := '';

                  FieldValue := VarToStr(Value);

                  if (Trim(FieldValue) = '') and not isproperty(ColAttributes.Field) then FieldValue := '---';

                  FixAlphaStructure(ColAttributes.Field, FieldValue);

                  if ColAttributes.Field in [CSC_ExeTime, CSC_PlanSetup, CSC_ExeTimeSched, CSC_ActualTime,
                                             CSC_SupTimeSched] then
                  begin
                    if not ReportSettings.IsBinReport then
                    begin
                      if ColAttributes.Field = CSC_ExeTimeSched then sumSchedExecTime := sumSchedExecTime + Value
                      else if ColAttributes.Field = CSC_SupTimeSched then sumSetupTime := sumSetupTime + Value
                      else if ColAttributes.Field = CSC_ExeTime then sumStepExeMin := sumStepExeMin + Value
                      else if ColAttributes.Field = CSC_ActualTime then sumActualExecTime := sumActualExecTime + Value
                    end;
                    if DBAppSettings.ReportTimeFormat = '1' then
                      FieldValue := Value
                    else
                      FieldValue := p_sc.GetFldDescr(id, ColAttributes.Field, true);
                    WriteValuesForExcel(FieldValue,Row, Column, Sheet, ExcelInstalled);
                    //Sheet.Cells[Row, Column].Value := FieldValue;
                    Column := Column + 1;
                  end
                  else
                  begin
                    if not ReportSettings.IsBinReport then
                    begin
                      if ColAttributes.Field = CSC_QtyToSched then sumQtyToSched := sumQtyToSched + Round(Value)
                      else if ColAttributes.Field = CSC_ProgQty then sumProgQty := sumProgQty + Round(Value)
                      else if ColAttributes.Field = CSC_FinQty then sumFinQty := sumFinQty + Round(Value);
                    end;
                    if (dataType <> CBT_integer) and (dataType <> CBT_float) and
                       (stepGroupIndex = j) and (FieldValue = IntToStr(-1)) then FieldValue := '---';
                    if stepTypeIndex = j then
                    begin
                      case StrToInt(FieldValue) of
                        1: FieldValue := _('Batch');
                        2: FieldValue := _('Continuous');
                      end;
                      dataType := CBT_string;
                    end;
                    if ColAttributes.Field = CSC_Rsc then
                    begin
                      if ExcelInstalled then
                        Sheet.Columns[Column].NumberFormat := '#.##0,00';//AnsiChar('@');  // set format as text
                      WriteValuesForExcel(ResDet.ResCode,Row, Column, Sheet, ExcelInstalled);
                    //Sheet.Cells[Row, Column].Value := ResDet.ResCode;
                      Column := Column + 1;
                    end
                    else if (dataType = CBT_float) or (dataType = CBT_integer) then
                    begin
                      if IsProperty(ColAttributes.Field) then
                      begin
                        if VarType(value) = varEmpty then
                          WriteValuesForExcel('',Row, Column, Sheet, ExcelInstalled)
                          //Sheet.Cells[Row, Column].Value := ''
                        else
                          WriteValuesForExcel(Value,Row, Column, Sheet, ExcelInstalled);
                          //Sheet.Cells[Row, Column].Value := Value; // working for BIG 05/10/2017
                        Column := Column + 1;
                      end
                      else
                      begin
                        WriteValuesForExcel(Value,Row, Column, Sheet, ExcelInstalled);
                        //Sheet.Cells[Row, Column].Value :=  Value; // RoundDblToDbl(Value, 0)
                        Column := Column + 1;
                      end;
                    end
                    else if (dataType = CBT_date) and (IsEmptyDateTime(FieldValue)) then
                    begin
                      WriteValuesForExcel('---',Row, Column, Sheet, ExcelInstalled);
                      //Sheet.Cells[Row, Column].Value := '---';
                      Column := Column + 1;
                    end
                    else
                    begin
                      if (dataType = CBT_date) then
                      begin
                        if ExcelInstalled then
                        begin
                          Sheet.Cells[Row, Column].HorizontalAlignment := -4131; // alligned left.
                          Sheet.Cells[Row, Column].NumberFormat := DateTimeFormat;//'@'; // working for BIG 05/10/2017  //AnsiChar('@');
                        End;
                        WriteValuesForExcel(Value,Row, Column, Sheet, ExcelInstalled);
                        //Sheet.Cells[Row, Column].Value := Value;//FieldValue;
                        Column := Column + 1;
                      end
                      else
                      begin
                        if ExcelInstalled then
                          Sheet.Cells[Row, Column].NumberFormat := '@'; // working for BIG 05/10/2017
                        WriteValuesForExcel(FieldValue,Row, Column, Sheet, ExcelInstalled);
                        //Sheet.Cells[Row, Column].Value := FieldValue;
                        Column := Column + 1;
                      end;
                    end;
                  end;
                end;
              end;
            end;

            //////////

            if D < NumberOfDays then
            begin
              RowTemp := RowTemp + 1;
              Row := RowTemp;
            end;

            Column := Column + 1;

          end;

         // Column := Column + 1;

          SavedproductionDate := TmpDate;

        end;

      end
      else
      begin
        p_sc.GetFldValue(Id, CSC_QtyToSched, qty, dataType);
        value := roundto(qty, -3);
        WriteValuesForExcel(Value,Row, Column, Sheet, ExcelInstalled);
        //Sheet.Cells[Row, Column].Value := value;
      end;

    end;

   end;
  end;

//   CloseFile;

  end;

  Result := true;
  Sheet := Unassigned;
end;

//----------------------------------------------------------------------------//
{ This procedure writes the Excel file with the data stored in JobList
  @param JobList         Job List for Dynamic Schedule or Bin Extraction Report
  @param showResource    Indicates whether Job List spans over only one resource
  @param ReportSettings  Report settings given by calling units }
//----------------------------------------------------------------------------//

Procedure WriteValuesForExcel(Value : variant; Row, Column : Integer; Sheet: OLEVariant;  ExcelInstalled : Boolean);
begin
  // Always write to BinData array; bulk-assign to Excel sheet after the loop
  BinData[Row, Column] := Value;
end;

function CheckIfExcelInstalled: boolean;
var
  XLApp: OLEVariant;
begin
  Result := False;
  try
    XLApp := CreateOleObject('Excel.Application');
    if not VarIsEmpty(XLApp) then
    begin
      Result := True;
      XLApp.Quit;
      XLAPP := Unassigned;
    end;
  except
    Result := False;
  end;
end;


function WriteExcelFile(JobList: TList; showResource: boolean; ReportSettings: TSettings): boolean;
const
  xlWBATWorksheet = $FFFFEFB9;
var
  i, j, k, pos, F, B,
  ColumnProdReq,
  ColumnStart,
  ColumnEnd,
  ColumnComment,
  ColumnQtyToSched,
  ColumnExeTimeSched,
  ColumnSupTimeSched,
  ColumnFinalQty,
  ColumnStepExeTime,
  ColumnActualExecTime,
  ColumnProgQty,
  ColumnRes,
  ColumnResDescr,
  colNum,
  StepGroupIndex,
  stepTypeIndex,
  sumSchedExecTime,
  sumActualExecTime,
  sumStepExeMin,
  sumSetupTime,position,VisColInBin       : integer;
  hasEqualCriteria   : boolean;
  ActBinGrid         : TBinDrawGrid;
  ActTab             : TBinTabSheet;
  ColAttributes      : TBinColCurrent;
  SchedType,
  tmpString,
  Field,
  FieldValue, FieldValueFixedColumn         : string;
  ResDet             : PTResourceDet;
  id                 : TSchedId;
  Value, ValueFixedColumn : Variant;
  dataType, dataTypeFixedColumn : CBinColValType;
  formatSettings : TFormatSettings;
  DateFormat, TimeFormat, DateTimeFormat, ExcelYearChar, ExcelMonthChar,
  ExcelDayChar, ExcelHourChar, ExcelMinuteChar : String;
  sumFinQty,
  sumQtyToSched,
  sumProgQty,
  tmpTime            : double;
  SplitCriteria      : Array [0..4] of string;
  status             : TRecordStatus;
  HeadingConcatenationColumn : TStringList;
  XLApp: OLEVariant;
  Sheet: OLEVariant;
  planInfo         : TSQplanInfo;
  qry: TMqmQuery;
  tbInfo: ^TTblInfo;
  ProdNo, ProdStep, Content : string;
  CounterFixedColumn, RowTemp : Integer;
  SpaceLineNeeded : boolean;
  ShowBatchGroupLinesInBin, ExcelInstalled : boolean;
  ShowContinueGroupLinesInBin : CScShowContinueGroupLinesInBin;
  MessageFilter : IOleMessageFilter;
  ColFormatSet  : array[1..300] of Boolean;  // tracks which columns already had format applied
  FinalRow      : Integer;                   // actual last row written — used for bulk Excel assign
  PosCache      : array[0..High(BinColDefault)] of Integer;  // pre-computed FindPos(j) — constant across all rows
  VisColOrigJ   : array[0..High(BinColDefault)] of Integer;  // original j values of visible non-MsgFromHost columns
  VisColCount   : Integer;                                    // number of entries in VisColOrigJ
  jj            : Integer;                                    // loop index into VisColOrigJ
begin
  Result             := false;
  tbInfo             := nil;
  qry                := nil;
  ColumnStart        := 0;
  ColumnProdReq      := 0;
  ColumnEnd          := 0;
  ColumnComment      := 0;
  ColumnQtyToSched   := 0;
  ColumnExeTimeSched := 0;
  ColumnSupTimeSched := 0;
  ColumnFinalQty     := 0;
  ColumnStepExeTime  := 0;
  ColumnActualExecTime := 0;
  ColumnProgQty      := 0;
  ColumnRes          := 0;
  ColumnResDescr     := 0;
  sumStepExeMin      := 0;
  sumFinQty          := 0;
  sumSchedExecTime   := 0;
  sumActualExecTime  := 0;
  sumSetupTime       := 0;
  sumQtyToSched      := 0;
  sumProgQty         := 0;
  colNum             := 0;
  CounterFixedColumn := 0;
  SpaceLineNeeded := false;
  VisColInBin := 0;
  FillChar(ColFormatSet, SizeOf(ColFormatSet), 0);
  HeadingConcatenationColumn := TStringList.Create;

  if ReportSettings.PrintComments then
  begin
    qry := CreateQuery(Main_DB);
    tbInfo := @tblInfo[tbl_prod_info];
  end;

  ActTab := FBin.GetActiveView;
  if not Assigned(ActTab) then exit;
  ActBinGrid := ActTab.GetBinGrid;
  FBin.ShowGroupLinesInBin(ShowBatchGroupLinesInBin, ShowContinueGroupLinesInBin);

//  if IniAppGlobals.ExcelVersion2013IsInstalled <> '1' then
  MessageFilter.RegisterFilter();

  ExcelInstalled := CheckIfExcelInstalled;

  if ReportSettings.FixColumnsReport then
  begin
    for B := 1 to 10 do
    begin
      if ReportSettings.BinFieldArrayReport[B].Field <> CSC_NotSorted then
      for F := low(ReportSettings.BinFieldsArray) to High(ReportSettings.BinFieldsArray) - 1 do
      begin
        if ReportSettings.BinFieldsArray[F].Field = ReportSettings.BinFieldArrayReport[B].Field then
        begin
          Inc(CounterFixedColumn);
          break;
        end;
      end;
    end;
  end;

  if ExcelInstalled then
  begin
    XLApp := CreateOleObject('Excel.Application');

//  if IniAppGlobals.ExcelVersion2013IsInstalled = '1' then
//  begin
//    XLApp.Visible := true;
//    XLApp.Workbooks.Add(xlWBATWorksheet)
//  end
//  else
    XLApp.Application.Workbooks.Add;
    XLApp.Worksheets.Add;
    XLApp.Worksheets[1].Select;
    XLApp.Workbooks[1].Worksheets[1].Name := 'dummy';
    Sheet := XLApp.Workbooks[1].WorkSheets[1];
    XLApp.ScreenUpdating := False;  // Disable screen refresh during write — critical for performance
    XLApp.Visible := False;         // Keep Excel hidden during write

    GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT, formatSettings);

    ExcelYearChar := XLApp.International[19];
    ExcelMonthChar := XLApp.International[20];
    ExcelDayChar := XLApp.International[21];
    ExcelHourChar := XLApp.International[22];
    ExcelMinuteChar := XLApp.International[23];
  end;

  // Always create BinData for both Excel and non-Excel paths.
  // For Excel: values accumulate here during the loop, then bulk-assigned to the sheet in one OLE call.
  // For non-Excel: passed to CreateExcel as before.
  for j := 0 to High(BinColDefault) - 1 do
  begin
    position := ActBinGrid.FindPos(j);
    ColAttributes := ActBinGrid.BinColumnSet[position];
    if ColAttributes.Visible and (ColAttributes.Field <> CSC_MsgFromHost) then VisColInBin := VisColInBin + 1;
  end;
  BinData := VarArrayCreate([1, (JobList.Count * 7), 1, VisColInBin + 2 + CounterFixedColumn], varVariant);

  DateFormat := formatSettings.ShortDateFormat;
  DateFormat := StringReplace(DateFormat, 'y', LowerCase(ExcelYearChar), [rfReplaceAll]);
  DateFormat := StringReplace(DateFormat, 'Y', UpperCase(ExcelYearChar), [rfReplaceAll]);
  DateFormat := StringReplace(DateFormat, 'm', LowerCase(ExcelMonthChar), [rfReplaceAll]);
  DateFormat := StringReplace(DateFormat, 'M', UpperCase(ExcelMonthChar), [rfReplaceAll]);
  DateFormat := StringReplace(DateFormat, 'd', LowerCase(ExcelDayChar), [rfReplaceAll]);
  DateFormat := StringReplace(DateFormat, 'D', UpperCase(ExcelDayChar), [rfReplaceAll]);

  TimeFormat := 'hh:mm';
  TimeFormat := StringReplace(TimeFormat, 'h', LowerCase(ExcelHourChar), [rfReplaceAll]);
  TimeFormat := StringReplace(TimeFormat, 'm', LowerCase(ExcelMinuteChar), [rfReplaceAll]);

  DateTimeFormat := DateFormat + ' ' + TimeFormat;

  with ReportSettings.NativeExcel do
  begin
    stepTypeIndex  := -1;
    StepGroupIndex := -1;
    //NewFile;
    FileName := ReportSettings.SaveFileLocation;
    AddFont(FMQMPlan.ExcelFontBold.Font);
    AddFont(FMQMPlan.ExcelFontHeader1.Font);
    AddFont(FMQMPlan.ExcelFontHeader2.Font);

    // Create header data
  {  if ReportSettings.IsBinReport then
    begin
      XLApp.ActiveSheet.PageSetup.CenterHeader := _('MQM') + ' - ' + _('Bin Extraction');
    end
    else
    begin
      XLApp.ActiveSheet.PageSetup.CenterHeader := _('MQM') + ' - ' + _('Dynamic Schedule Report');
    end;

    XLApp.ActiveSheet.PageSetup.CenterFooter := '&N &P'; //'?&P?';   }

    ActiveFont := 1;
    RowTemp := 0;
    Column := 6;

    if (not ReportSettings.IsBinReport) and (ReportSettings.ExcelTitle <> '') then
    begin
      RowTemp := RowTemp + 1;
      Row := RowTemp;
      WriteValuesForExcel(ReportSettings.ExcelTitle,Row, Column, Sheet, ExcelInstalled);
      //Sheet.Cells[Row, Column].Value := ReportSettings.ExcelTitle;
      Column := Column + 1;
      SpaceLineNeeded := true;
    end
    else if (ReportSettings.IsBinReport) and (ReportSettings.ExcelTitleBinReport <> '') then
    begin
      RowTemp := RowTemp + 1;
      Row := RowTemp;
      WriteValuesForExcel(ReportSettings.ExcelTitleBinReport,Row, Column, Sheet, ExcelInstalled);
      //Sheet.Cells[Row, Column].Value := ReportSettings.ExcelTitleBinReport;
      Column := Column + 1;
      SpaceLineNeeded := true;
    end;


    if not ReportSettings.IsBinReport and ReportSettings.ShowBinCaption then
    begin
      RowTemp := RowTemp + 1;
      Row := RowTemp;
      WriteValuesForExcel(ActTab.Caption,Row, Column, Sheet, ExcelInstalled);
      //Sheet.Cells[Row, Column].Value := ActTab.Caption;
      Column := Column + 1;
      SpaceLineNeeded := true;
    end
    else if ReportSettings.IsBinReport and ReportSettings.ShowBinCaptionBinReport then
    begin
      RowTemp := RowTemp + 1;
      Row := RowTemp;
      WriteValuesForExcel(ActTab.Caption,Row, Column, Sheet, ExcelInstalled);
      //Sheet.Cells[Row, Column].Value := ActTab.Caption;
      Column := Column + 1;
      SpaceLineNeeded := true;
    end;


    ActiveFont := 2;
    if (not ReportSettings.IsBinReport) and ReportSettings.ShowCriteria then
    begin
      RowTemp := RowTemp + 1;
      Row := RowTemp;
      Column := Column - 1;

      WriteValuesForExcel(_('From') + ':  ' + DateToStr(ReportSettings.DateFrom)
                                        + '  ' + TimeToStr(ReportSettings.DateFrom) + '      ' + _('To') + ': ' +
                                       DateToStr(ReportSettings.DateTo) + '  ' + TimeToStr(ReportSettings.DateTo)
      ,Row, Column, Sheet, ExcelInstalled);
      //Sheet.Cells[Row, Column].Value := _('From') + ':  ' + DateToStr(ReportSettings.DateFrom)
      //                                  + '  ' + TimeToStr(ReportSettings.DateFrom) + '      ' + _('To') + ': ' +
       //                                 DateToStr(ReportSettings.DateTo) + '  ' + TimeToStr(ReportSettings.DateTo);

      Column := Column + 1;
      SpaceLineNeeded := true;
    end;

    // Create table titles
 {   Row := Row + 1;

    if (ReportSettings.ExcelTitle = '') and (not ReportSettings.ShowBinCaption) and (not ReportSettings.ShowColumnsCaptions)
       and (not ReportSettings.IsBinReport) and (not ReportSettings.ShowCriteria) then
    begin
      FirstRow := true;
      Row := 1;
    end;     }

    Column := 1;
    shading := true;
    ActiveFont := 0;
    Alignment:= eaCenter;
    // For Bin Extractions, add columns Row Number and Status

    if ReportSettings.IsBinReport and ReportSettings.ShowColumnsCaptionsBinReport then
    begin
      RowTemp := RowTemp + 1;
      Row := RowTemp;
      WriteValuesForExcel(_('Row No') + '.',Row, Column, Sheet, ExcelInstalled);
      //Sheet.Cells[Row, Column].Value := _('Row No') + '.';
      Column := Column + 1;
      if DBAppSettings.FixColStatVis then
      begin
        WriteValuesForExcel(_('Status'),Row, Column, Sheet, ExcelInstalled);
      //Sheet.Cells[Row, Column].Value := _('Status');
        Column := Column + 1;
      end;
    end;

    if not ReportSettings.IsBinReport then
    begin
      if SpaceLineNeeded then
       begin
         RowTemp := RowTemp + 1;
         Row := RowTemp;
         SpaceLineNeeded := false;
      end;
      if ReportSettings.ShowColumnsCaptions then
      begin
        RowTemp := RowTemp + 1;
        Row := RowTemp;
      end;
      if ReportSettings.FixColumnsReport then
      begin
        for B := 1 to 10 do
        begin
          if ReportSettings.BinFieldArrayReport[B].Field <> CSC_NotSorted then
          for F := low(ReportSettings.BinFieldsArray) to High(ReportSettings.BinFieldsArray) - 1 do
          begin
            if ReportSettings.BinFieldsArray[F].Field = ReportSettings.BinFieldArrayReport[B].Field then
            begin
              HeadingConcatenationColumn.Add(ReportSettings.BinFieldsArray[F].Title);
              if ReportSettings.ShowColumnsCaptions then
                WriteValuesForExcel(ReportSettings.BinFieldsArray[F].Title,Row, Column, Sheet, ExcelInstalled);
                  //Sheet.Cells[Row, Column].Value := ReportSettings.BinFieldsArray[F].Title;
              Column := Column + 1;
             // Inc(CounterFixedColumn);
              break;
            end;
          end;
        end;
      end;
    end;

   // if ReportSettings.ShowCaptionsAndTotal then
   // begin

   if ReportSettings.ShowColumnsCaptions then
    Row := Row - 1;

      for i := 0 to High(BinColDefault) do
      begin

        pos := ActBinGrid.FindPos(i);
        ColAttributes := ActBinGrid.BinColumnSet[pos];
        if (ColAttributes.Field <> CSC_MsgFromHost) and ColAttributes.Visible then
        begin
          if ColAttributes.Title = '' then
            Field := _(getPropertyDesc(pos, ActBinGrid))
          else
            Field := _(ColAttributes.Title);

          HeadingConcatenationColumn.Add(Field);
          if ReportSettings.ShowColumnsCaptions then
          begin
            WriteValuesForExcel(Field,Row, Column, Sheet, ExcelInstalled);
          end;
            //Sheet.Cells[Row, Column].Value := Field;


          //colNum := colNum + 1;
          if ColAttributes.Field = CSC_ProgStart then ColumnStart := Column
          else if ColAttributes.Field = CSC_ProdReq then ColumnProdReq := Column
          else if ColAttributes.Field = CSC_ProgEnd then ColumnEnd := Column
          else if ColAttributes.Field = CSC_Comment then ColumnComment := Column
          else if ColAttributes.Field = CSC_QtyToSched then ColumnQtyToSched := Column
          else if ColAttributes.Field = CSC_ExeTimeSched then ColumnExeTimeSched := Column
          else if ColAttributes.Field = CSC_SupTimeSched then ColumnSupTimeSched := Column
          else if ColAttributes.Field = CSC_ProgQty then ColumnProgQty := Column
          else if ColAttributes.Field = CSC_FinQty then ColumnFinalQty := Column
          else if ColAttributes.Field = CSC_ExeTime then ColumnStepExeTime := Column
          else if ColAttributes.Field = CSC_ActualTime then ColumnActualExecTime := Column
          else if ColAttributes.Field = CSC_Rsc then ColumnRes := Column
          else if ColAttributes.Field = CSC_RscDesc then ColumnResDescr := Column
          else if ColAttributes.Field = CSC_StepType then stepTypeIndex := i
          else if ColAttributes.Field = CSC_ReprocNo then stepTypeIndex := i;

          Column := Column + 1;
        end;
      end;
    //end;

    shading := false;
    ActiveFont := 5;
    SplitCriteria[4] := 'xxxxxxxxxxxxxxxxxxxx';
    for k := 0 to 3 do SplitCriteria[k] := '';

    // Pre-compute FindPos for all columns — BinColumnSet order is constant for the entire export.
    for j := 0 to High(BinColDefault) do
      PosCache[j] := ActBinGrid.FindPos(j);

    // Build visible column list — invisible columns do nothing in the j-loop (neither branch
    // executes). Pre-filtering reduces inner loop from 152 → ~15 iterations per row,
    // saving ~137 × 103K = 14M no-op iterations. Original j values stored so that
    // stepGroupIndex/stepTypeIndex comparisons inside the loop body remain correct.
    VisColCount := 0;
    for j := 0 to High(BinColDefault) do
    begin
      pos := PosCache[j];
      if (ActBinGrid.BinColumnSet[pos].Field <> CSC_MsgFromHost) and
          ActBinGrid.BinColumnSet[pos].Visible then
      begin
        VisColOrigJ[VisColCount] := j;
        Inc(VisColCount);
      end;
    end;

    // Create one table row per job
    for i := 0 to JobList.Count - 1 do
    begin
      Column := 1;

      if SpaceLineNeeded then
      begin
        RowTemp := RowTemp + 1;
        Row := RowTemp;
        SpaceLineNeeded := false;
      end;
    //  RowTemp := RowTemp + 1;
      if i = 0 then
        Row := RowTemp
      else
        Row := Row + 1;

      ResDet := JobList.Items[i];
      id := TSchedId(ResDet.ID);
      status := REC_OK;
      if (id <> CSchedIdNull) or (ResDet.Downtime) then
      begin
        // Check whether sort criteria or a new resource indicate a new group
        if ReportSettings.NewPagePerRes or ReportSettings.ShowResources or
          ReportSettings.ShowGroups or (ReportSettings.GroupingFields > 0) then
        begin
          if ResDet.ResCode <> SplitCriteria[4] then
          begin
            if ReportSettings.NewPagePerRes then status := REC_BREAK;
            if ReportSettings.ShowResources then status := REC_BREAK_RES;
          end;
          if ReportSettings.IsBinReport and (ReportSettings.GroupingFields > 0) then
          begin
            hasEqualCriteria := true;
            if not ResDet.Downtime then
            begin
              for k := 0 to ReportSettings.GroupingFields - 1 do
              begin
                tmpString := p_sc.GetFldDescr(id, ActBinGrid.BinColumnSet[ActBinGrid.FindOrderPos(k)].Field, true);
                hasEqualCriteria := hasEqualCriteria and (SplitCriteria[k] = tmpString);
                if not hasEqualCriteria then SplitCriteria[k] := tmpString;
                if (I = 0) and (SplitCriteria[k] = '') and (tmpString = '') then
                   hasEqualCriteria := false;
              end;
            end
            else
            begin
              hasEqualCriteria := hasEqualCriteria and (SplitCriteria[0] = _('Downtime'));
              SplitCriteria[0] := _('Downtime');
              for k := 1 to ReportSettings.GroupingFields - 1 do SplitCriteria[k] := '';
            end;
            if not hasEqualCriteria then begin
              if (status = REC_OK) and (not ReportSettings.ShowGroups) then status := REC_BREAK;
              if ReportSettings.ShowGroups then
              begin
                case status of
                  REC_OK, REC_BREAK : status := REC_BREAK_GROUP;
                  REC_BREAK_RES     : status := REC_BREAK_RES_GROUP;
                end;
              end;
            end;
          end;
          if SplitCriteria[4] <> ResDet.ResCode then SplitCriteria[4] := ResDet.ResCode;
        end;

        // Insert a break into the Excel data depending on record status: at least one
        // criteria defined, line break per resource or show resource description set
        if status <> REC_OK then
        begin
          tmpString := '';
         // if i > 0 then Row := Row + 1;
          if status in [REC_BREAK_RES, REC_BREAK_RES_GROUP] then
          begin
            if ResDet.ResCode <> ''  then
            begin
              tmpString := tmpString + ResDet.ResCode;
              if ResDet.ResDesc <> '' then tmpString := tmpString + '(' + ResDet.ResDesc + ')';
            end
          end;
          if status in [REC_BREAK_GROUP, REC_BREAK_RES_GROUP] then
          begin
            if ResDet.Downtime then tmpString := tmpString + _('Downtime')
            else
            begin
              for k := 0 to ReportSettings.GroupingFields - 1 do
              begin
                tmpString := tmpString + getPropertyDesc(ActBinGrid.FindOrderPos(k),
                             ActBinGrid) + ': ' + SplitCriteria[k];
                if k < ReportSettings.GroupingFields - 1 then tmpString := tmpString + ', ';
              end;
            end;
          end;
          Alignment:= eaLeft;
          //WriteLabel(Row, 1, tmpString);
          //added by Erbil K���KAHMET
          WriteValuesForExcel(tmpString,Row, 1, Sheet, ExcelInstalled);
            //Sheet.Cells[Row, 1].Value := tmpString;
          Column := Column + 1;

          Alignment:= eaCenter;
          if status <> REC_BREAK then Row := Row + 1;
          Column := 1;
        end;

        // For Bin Extractions, insert columns Row Number and Status
        if ReportSettings.IsBinReport then
        begin
          //WriteLabel(Row, Column, IntToStr(i + 1));
          //added by Erbil K���KAHMET
          WriteValuesForExcel(IntToStr(i + 1),Row, Column, Sheet, ExcelInstalled);
            //Sheet.Cells[Row, Column].Value := IntToStr(i + 1);
          Column := Column + 1;

          if DBAppSettings.FixColStatVis then
          begin
            if not isClosed(id) then
            begin
              case p_sc.IsProgressed(id) of
                prg_Starting:
                begin
                  //WriteLabel(Row, Column, _('Started'));
                  //added by Erbil K���KAHMET
                  WriteValuesForExcel(_('Started'),Row, Column, Sheet, ExcelInstalled);
                    //Sheet.Cells[Row, Column].Value := _('Started');
                  Column := Column + 1;
                end;
                prg_General:
                begin
                  //WriteLabel(Row, Column, _('Progressed'));
                  //added by Erbil K���KAHMET
                  WriteValuesForExcel(_('Progressed'),Row, Column, Sheet, ExcelInstalled);
                    //Sheet.Cells[Row, Column].Value := _('Progressed');
                  Column := Column + 1;
                end;
                prg_Final,
                prg_FinalSplit:
                begin
                  //WriteLabel(Row, Column, _('Ended'));
                  //added by Erbil K���KAHMET
                  WriteValuesForExcel(_('Ended'),Row, Column, Sheet, ExcelInstalled);
                    //Sheet.Cells[Row, Column].Value := _('Ended');
                  Column := Column + 1;
                end
                else
                begin
                  SchedType := p_sc.GetSchedType(id);
                  if (SchedType = '1') then
                  begin
                    //WriteLabel(Row, Column, _('Temporarily'));
                    //added by Erbil K���KAHMET
                    WriteValuesForExcel(_('Temporarily'),Row, Column, Sheet, ExcelInstalled);
                    //Sheet.Cells[Row, Column].Value := _('Temporarily');
                    Column := Column + 1;
                  end
                  else if (SchedType = '2') then
                  begin
                    //WriteLabel(Row, Column, _('Fixed'));
                    //added by Erbil K���KAHMET
                    WriteValuesForExcel(_('Fixed'),Row, Column, Sheet, ExcelInstalled);
                    //Sheet.Cells[Row, Column].Value := _('Fixed');
                    Column := Column + 1;
                  end
                  else if (SchedType = '3') then
                  begin
                    //WriteLabel(Row, Column, _('Level') + ' ' + '1');
                    //added by Erbil K���KAHMET
                    WriteValuesForExcel(_('Level') + ' ' + '1',Row, Column, Sheet, ExcelInstalled);
                    //Sheet.Cells[Row, Column].Value := _('Level') + ' ' + '1';
                    Column := Column + 1;
                  end
                  else if (SchedType = '4') then
                  begin
                    //WriteLabel(Row, Column, _('Level') + ' ' + '2');
                    //added by Erbil K���KAHMET
                    WriteValuesForExcel(_('Level') + ' ' + '2',Row, Column, Sheet, ExcelInstalled);
                    //Sheet.Cells[Row, Column].Value := _('Level') + ' ' + '2';
                    Column := Column + 1;
                  end
                  else if (SchedType = '5') then
                  begin
                    //WriteLabel(Row, Column, _('Level') + ' ' + '3');
                    //added by Erbil K���KAHMET
                    WriteValuesForExcel(_('Level') + ' ' + '3',Row, Column, Sheet, ExcelInstalled);
                    //Sheet.Cells[Row, Column].Value := _('Level') + ' ' + '3';
                    Column := Column + 1;
                  end
                  else if (SchedType = '6') then
                  begin
                    //WriteLabel(Row, Column, _('Level') + ' ' + '4');
                    //added by Erbil K���KAHMET
                    WriteValuesForExcel(_('Level') + ' ' + '4',Row, Column, Sheet, ExcelInstalled);
                    //Sheet.Cells[Row, Column].Value := _('Level') + ' ' + '4';
                    Column := Column + 1;
                  end
                  else if (SchedType = '7') then
                  begin
                    //WriteLabel(Row, Column, _('Level') + ' ' + '5');
                    //added by Erbil K���KAHMET
                    WriteValuesForExcel(_('Level') + ' ' + '5',Row, Column, Sheet, ExcelInstalled);
                    //Sheet.Cells[Row, Column].Value := _('Level') + ' ' + '5';
                    Column := Column + 1;
                  end
                  else
                  begin
                    //WriteLabel(Row, Column, '---');
                    //added by Erbil K���KAHMET
                    WriteValuesForExcel('---',Row, Column, Sheet, ExcelInstalled);
                    //Sheet.Cells[Row, Column].Value := '---';
                    Column := Column + 1;
                  end;
                end;
              end;
            end
            else
            begin
              //WriteLabel(Row, Column, _('Closed'));
              //added by Erbil K���KAHMET
              WriteValuesForExcel(_('Closed'),Row, Column, Sheet, ExcelInstalled);
                    //Sheet.Cells[Row, Column].Value := _('Closed');
              Column := Column + 1;
            end;
          end;
        end;

        //////////////////

        if not ReportSettings.IsBinReport and ReportSettings.FixColumnsReport then
        begin
          for B := 1 to 10 do
          begin

            if ResDet.Downtime then
            begin
               if ReportSettings.BinFieldArrayReport[B].Field = CSC_ProdReq then
               begin
                  WriteValuesForExcel(_('Downtime'),Row, Column, Sheet, ExcelInstalled);
                    //Sheet.Cells[Row, Column].Value := _('Downtime');
                  Column := Column + 1;
                  continue;
               end;
               if ReportSettings.BinFieldArrayReport[B].Field = CSC_ProgStart then
               begin
                  WriteValuesForExcel(StrToDateTime(ResDet.DownTimeFrom),Row, Column, Sheet, ExcelInstalled);
                    //Sheet.Cells[Row, Column].Value := StrToDateTime(ResDet.DownTimeFrom);
                  Column := Column + 1;
                  continue;
               end;
               if ReportSettings.BinFieldArrayReport[B].Field = CSC_ProgEnd then
               begin
                  WriteValuesForExcel(StrToDateTime(ResDet.DownTimeTo),Row, Column, Sheet, ExcelInstalled);
                    //Sheet.Cells[Row, Column].Value := StrToDateTime(ResDet.DownTimeTo);
                  Column := Column + 1;
                  continue;
               end;
               if ReportSettings.BinFieldArrayReport[B].Field = CSC_Comment then
               begin
                  WriteValuesForExcel(ResDet.Comment,Row, Column, Sheet, ExcelInstalled);
                    //Sheet.Cells[Row, Column].Value := ResDet.Comment;
                  Column := Column + 1;
                  continue;
               end;
               if ReportSettings.BinFieldArrayReport[B].Field = CSC_Rsc then
               begin
                  WriteValuesForExcel(ResDet.ResCode,Row, Column, Sheet, ExcelInstalled);
                    //Sheet.Cells[Row, Column].Value := ResDet.ResCode;
                  Column := Column + 1;
                  continue;
               end;
               if ReportSettings.BinFieldArrayReport[B].Field = CSC_RscDesc then
               begin
                  WriteValuesForExcel(ResDet.ResDesc,Row, Column, Sheet, ExcelInstalled);
                    //Sheet.Cells[Row, Column].Value := ResDet.ResDesc;
                  Column := Column + 1;
                  continue;
               end;
               Column := Column + 1;
               continue;
            end;

            if ReportSettings.BinFieldArrayReport[B].Field = CSC_NotSorted then continue;

            if ReportSettings.BinFieldArrayReport[B].Field <> CSC_MsgFromHost then
            begin
              if (ShowContinueGroupLinesInBin <> CsSCG_No) or ShowBatchGroupLinesInBin then
              begin
                p_sc.GetPlanInfo(Id, planInfo);
                if planInfo.isGroup then
                begin
                  Id := p_sc.GetGrpSon(Id, 0);
                end;
              end;
              p_sc.GetFldValue(Id, ReportSettings.BinFieldArrayReport[B].Field, ValueFixedColumn, dataTypeFixedColumn);

              if (ReportSettings.BinFieldArrayReport[B].Field = CSC_GroupNo) and (ValueFixedColumn = '-1') then Value := '';

              FieldValueFixedColumn := VarToStr(ValueFixedColumn);

              if (Trim(FieldValueFixedColumn) = '') then FieldValueFixedColumn := '---';

              FixAlphaStructure(ReportSettings.BinFieldArrayReport[B].Field, FieldValueFixedColumn);

              if (dataTypeFixedColumn <> CBT_integer) and (dataTypeFixedColumn <> CBT_float) and
                  (FieldValueFixedColumn = IntToStr(-1)) then FieldValueFixedColumn := '---';

              if ReportSettings.BinFieldArrayReport[B].Field = CSC_StepType then
              begin
                case StrToInt(FieldValue) of
                  1: FieldValue := _('Batch');
                  2: FieldValue := _('Continuous');
                end;
                dataType := CBT_string;
              end;
              if ReportSettings.BinFieldArrayReport[B].Field = CSC_Rsc then
              begin
                if (ResDet.SubResCode = '') then
                begin
                  WriteValuesForExcel(ResDet.ResCode,Row, Column, Sheet, ExcelInstalled);
                    //Sheet.Cells[Row, Column].Value := ResDet.ResCode;
                  Column := Column + 1;
                end;
              end
              else if (dataTypeFixedColumn = CBT_float) or (dataTypeFixedColumn = CBT_integer) then
              begin
                if IsProperty(ReportSettings.BinFieldArrayReport[B].Field) then
                begin
                  WriteValuesForExcel(RoundDblToDbl(ValueFixedColumn, 3),Row, Column, Sheet, ExcelInstalled);
                    //Sheet.Cells[Row, Column].Value := RoundDblToDbl(ValueFixedColumn, 3);
                  Column := Column + 1;
                end
                else
                begin
                  WriteValuesForExcel(RoundDblToDbl(ValueFixedColumn, 0),Row, Column, Sheet, ExcelInstalled);
                    //Sheet.Cells[Row, Column].Value := RoundDblToDbl(ValueFixedColumn, 0);
                  Column := Column + 1;
                end;
              end
              else if (dataTypeFixedColumn = CBT_date) and (IsEmptyDateTime(FieldValueFixedColumn)) then
              begin
                WriteValuesForExcel('---',Row, Column, Sheet, ExcelInstalled);
                    //Sheet.Cells[Row, Column].Value := '---';
                Column := Column + 1;
              end
              else
              begin
                if (dataTypeFixedColumn = CBT_date) then
                begin
                  WriteValuesForExcel(StrToDateTime(FieldValueFixedColumn),Row, Column, Sheet, ExcelInstalled);
                    //Sheet.Cells[Row, Column].Value := StrToDateTime(FieldValueFixedColumn);
                  Column := Column + 1;
                end
                else
                begin
                  WriteValuesForExcel(FieldValueFixedColumn,Row, Column, Sheet, ExcelInstalled);
                    //Sheet.Cells[Row, Column].Value := FieldValueFixedColumn;
                  Column := Column + 1;
                end;
              end;
            end;
          end;

        end;

        /////////////////

        // Resolve group son once per row (not once per column)
        if not ResDet.Downtime and
           ((ShowContinueGroupLinesInBin <> CsSCG_No) or ShowBatchGroupLinesInBin) then
        begin
          p_sc.GetPlanInfo(Id, planInfo);
          if planInfo.isGroup then
            Id := p_sc.GetGrpSon(Id, 0);
        end;

        // Fill fields of data row and add values to totals statistics
        // Iterate only visible non-MsgFromHost columns (pre-filtered in VisColOrigJ).
        // j is restored to its original 0..High(BinColDefault) value so all comparisons
        // inside the loop body (stepGroupIndex=j, stepTypeIndex=j) remain correct.
        for jj := 0 to VisColCount - 1 do
        begin
          j := VisColOrigJ[jj];
          pos := PosCache[j];
          ColAttributes := ActBinGrid.BinColumnSet[pos];
          if ColAttributes.Field <> CSC_MsgFromHost then
          begin
            if ColAttributes.Visible and ResDet.Downtime then
            begin
              //WriteLabel(Row, 1, _('Downtime'));
              //added by Erbil K���KAHMET
             // Sheet.Cells[Row, 1].Value := _('Downtime');
              if ColAttributes.Field = CSC_ProdReq then
              begin
                WriteValuesForExcel(_('Downtime'),Row, ColumnProdReq + CounterFixedColumn, Sheet, ExcelInstalled);
                    //Sheet.Cells[Row, ColumnProdReq + CounterFixedColumn].Value := _('Downtime');
                Column := Column + 1;
              end;

              if ColAttributes.Field = CSC_ProgStart then
              begin
                //WriteLabel(Row, ColumnStart, FormatDateTime('dddd', StrToDateTime(ResDet.DownTimeFrom)) + ' ' + ResDet.DownTimeFrom);
                //added by Erbil K���KAHMET
                WriteValuesForExcel(StrToDateTime(ResDet.DownTimeFrom),Row, ColumnStart + CounterFixedColumn, Sheet, ExcelInstalled);
                    //Sheet.Cells[Row, ColumnStart + CounterFixedColumn].Value := StrToDateTime(ResDet.DownTimeFrom); //FormatDateTime('dddd', StrToDateTime(ResDet.DownTimeFrom)) + ' ' + ResDet.DownTimeFrom;
                Column := Column + 1;
              end
              else if ColAttributes.Field = CSC_ProgEnd then
              begin
                //WriteLabel(Row, ColumnEnd, FormatDateTime('dddd', StrToDateTime(ResDet.DownTimeTo)) + ' ' + ResDet.DownTimeTo);
                //added by Erbil K���KAHMET
                WriteValuesForExcel(StrToDateTime(ResDet.DownTimeTo),Row, ColumnEnd + CounterFixedColumn, Sheet, ExcelInstalled);
                    //Sheet.Cells[Row, ColumnEnd + CounterFixedColumn].Value := StrToDateTime(ResDet.DownTimeto);  //FormatDateTime('dddd', StrToDateTime(ResDet.DownTimeTo)) + ' ' + ResDet.DownTimeTo;
                Column := Column + 1;
              end
              else if ColAttributes.Field = CSC_Comment then
              begin
                //WriteLabel(Row, ColumnComment, ResDet.Comment);
                //added by Erbil K���KAHMET
                WriteValuesForExcel(ResDet.Comment,Row, ColumnComment + CounterFixedColumn, Sheet, ExcelInstalled);
                    //Sheet.Cells[Row, ColumnComment + CounterFixedColumn].Value := ResDet.Comment;
                Column := Column + 1;
              end
              else if ColAttributes.Field = CSC_Rsc then
                begin
                  if ResDet.SubResCode = '' then
                  begin
                    //WriteLabel(Row, ColumnRes, ResDet.ResCode);
                    //added by Erbil K���KAHMET
                    WriteValuesForExcel(ResDet.ResCode,Row, ColumnRes + CounterFixedColumn, Sheet, ExcelInstalled);
                    //Sheet.Cells[Row, ColumnRes + CounterFixedColumn].Value := ResDet.ResCode;
                    Column := Column + 1;
                  end
                  else
                  begin
                    //WriteLabel(Row, ColumnRes, ResDet.ResCode + SUBRESSEPARATOR + ResDet.SubResCode);
                    //added by Erbil K���KAHMET
                    WriteValuesForExcel(ResDet.ResCode + SUBRESSEPARATOR + ResDet.SubResCode,Row, ColumnRes + CounterFixedColumn, Sheet, ExcelInstalled);
                    //Sheet.Cells[Row, ColumnRes + CounterFixedColumn].Value := ResDet.ResCode + SUBRESSEPARATOR + ResDet.SubResCode;
                    Column := Column + 1;
                  end;
                end
              else if (ColAttributes.Field = CSC_RscDesc) and (ResDet.ResDesc <> '') then
              begin
                //WriteLabel(Row, ColumnResDescr, ResDet.ResDesc);
                //added by Erbil K���KAHMET
                WriteValuesForExcel(ResDet.ResDesc,Row, ColumnResDescr + CounterFixedColumn, Sheet, ExcelInstalled);
                    //Sheet.Cells[Row, ColumnResDescr + CounterFixedColumn].Value := ResDet.ResDesc;
                Column := Column + 1;
              end;
              if ReportSettings.IncDowntime then
              begin
                tmpTime := 1440 * (StrToDateTime(ResDet.DownTimeTo) - StrToDateTime(ResDet.DownTimeFrom));
                if ColAttributes.Field = CSC_ExeTimeSched then
                begin
                  //WriteLabel(Row, ColumnExeTimeSched, FormatDuration(tmpTime, true));
                  //added by Erbil K���KAHMET
                  WriteValuesForExcel(FormatDuration(tmpTime, true),Row, ColumnExeTimeSched + CounterFixedColumn, Sheet, ExcelInstalled);
                    //Sheet.Cells[Row, ColumnExeTimeSched + CounterFixedColumn].Value := FormatDuration(tmpTime, true);
                  Column := Column + 1;

                  sumSchedExecTime := sumSchedExecTime + Round(tmpTime);
                end
                else if ColAttributes.Field = CSC_ExeTime then
                begin
                  //WriteLabel(Row, ColumnStepExeTime, FormatDuration(tmpTime, true));
                  //added by Erbil K���KAHMET
                  WriteValuesForExcel(FormatDuration(tmpTime, true),Row, ColumnStepExeTime + CounterFixedColumn, Sheet, ExcelInstalled);
                    //Sheet.Cells[Row, ColumnStepExeTime + CounterFixedColumn].Value := FormatDuration(tmpTime, true);
                  Column := Column + 1;

                  sumStepExeMin := sumStepExeMin + Round(tmpTime);
                end;
              end;
            end
            else if ColAttributes.Visible then
            begin
              // GetPlanInfo/GetGrpSon hoisted to before the j loop (once per row)

              // Optimization: CSC_Rsc — GetFldRealValue result never used; write ResCode directly
              if ColAttributes.Field = CSC_Rsc then
              begin
                if ExcelInstalled and not ColFormatSet[Column] then
                begin
                  Sheet.Columns[Column].NumberFormat := '#.##0,00';
                  ColFormatSet[Column] := True;
                end;
                WriteValuesForExcel(ResDet.ResCode, Row, Column, Sheet, ExcelInstalled);
                Column := Column + 1;
              end
              // Optimization: time fields in IsBinReport + formatted mode — GetFldRealValue result
              // always overwritten by GetFldDescr; totals accumulation skipped for IsBinReport anyway
              else if ReportSettings.IsBinReport and (DBAppSettings.ReportTimeFormat <> '1') and
                      (ColAttributes.Field in [CSC_ExeTime, CSC_PlanSetup, CSC_ExeTimeSched,
                                               CSC_ActualTime, CSC_SupTimeSched]) then
              begin
                FieldValue := p_sc.GetFldDescr(id, ColAttributes.Field, true);
                WriteValuesForExcel(FieldValue, Row, Column, Sheet, ExcelInstalled);
                Column := Column + 1;
              end
              else
              begin
             // if not p_sc.GetFldValue(Id, ColAttributes.Field, Value, dataType) then
              if not p_sc.GetFldRealValue(Id, ColAttributes.Field, Value, dataType, true) then
              begin
                if (ColAttributes.Field = CSC_SchedStart) or (ColAttributes.Field = CSC_SchedEnd) then
                   Value := '---';
              end;

              if (ColAttributes.Field = CSC_GroupNo) and (Value = '-1') then Value := '';

              FieldValue := VarToStr(Value);
            //  if Trim(FieldValue) = '' then FieldValue := '---';
              if (Trim(FieldValue) = '') and not isproperty(ColAttributes.Field) then FieldValue := '---';

              FixAlphaStructure(ColAttributes.Field, FieldValue);

              if ColAttributes.Field in [CSC_ExeTime, CSC_PlanSetup, CSC_ExeTimeSched, CSC_ActualTime,
                                         CSC_SupTimeSched] then
              begin
                if not ReportSettings.IsBinReport then
                begin
                  if ColAttributes.Field = CSC_ExeTimeSched then sumSchedExecTime := sumSchedExecTime + Value
                  else if ColAttributes.Field = CSC_SupTimeSched then sumSetupTime := sumSetupTime + Value
                  else if ColAttributes.Field = CSC_ExeTime then sumStepExeMin := sumStepExeMin + Value
                  else if ColAttributes.Field = CSC_ActualTime then sumActualExecTime := sumActualExecTime + Value
                end;
                if DBAppSettings.ReportTimeFormat = '1' then
                  FieldValue := Value
                else
                  FieldValue := p_sc.GetFldDescr(id, ColAttributes.Field, true);
                //WriteLabel(Row, Column, FieldValue);
                //added by Erbil K���KAHMET
                WriteValuesForExcel(FieldValue,Row, Column, Sheet, ExcelInstalled);
                    //Sheet.Cells[Row, Column].Value := FieldValue;
                Column := Column + 1;
              end
              else
              begin
                if not ReportSettings.IsBinReport then
                begin
                  if ColAttributes.Field = CSC_QtyToSched then sumQtyToSched := sumQtyToSched + Round(Value)
                  else if ColAttributes.Field = CSC_ProgQty then sumProgQty := sumProgQty + Round(Value)
                  else if ColAttributes.Field = CSC_FinQty then sumFinQty := sumFinQty + Round(Value);
                end;
                if (dataType <> CBT_integer) and (dataType <> CBT_float) and
                   (stepGroupIndex = j) and (FieldValue = IntToStr(-1)) then FieldValue := '---';
                if stepTypeIndex = j then
                begin
                  case StrToInt(FieldValue) of
                    1: FieldValue := _('Batch');
                    2: FieldValue := _('Continuous');
                  end;
                  dataType := CBT_string;
                end;
                if ColAttributes.Field = CSC_Rsc then
                begin

                 // if (ResDet.SubResCode = '') then
                 // begin
                 if ExcelInstalled and not ColFormatSet[Column] then
                 begin
                   Sheet.Columns[Column].NumberFormat := '#.##0,00';
                   ColFormatSet[Column] := True;
                 end;

                  WriteValuesForExcel(ResDet.ResCode,Row, Column, Sheet, ExcelInstalled);
                    //Sheet.Cells[Row, Column].Value := ResDet.ResCode;
                  Column := Column + 1;
                 // end;

                end
                else if (dataType = CBT_float) or (dataType = CBT_integer) then
                begin
                  if IsProperty(ColAttributes.Field) then
                  begin
                    //WriteNumber(Row, Column, RoundDblToDbl(Value, 3));
                    //added by Erbil K���KAHMET
                    if VarType(value) = varEmpty then
                      WriteValuesForExcel('',Row, Column, Sheet, ExcelInstalled)
                    //Sheet.Cells[Row, Column].Value := ''
                    else
                      WriteValuesForExcel(Value,Row, Column, Sheet, ExcelInstalled);
                    //Sheet.Cells[Row, Column].Value := Value; // working for BIG 05/10/2017
                    Column := Column + 1;
                  end
                  else
                  begin
                    //WriteNumber(Row, Column, RoundDblToDbl(Value, 0));

                  //  Sheet.Cells[Row, Column].HorizontalAlignment := -4131;

                  //  Sheet.Columns[Column].NumberFormatLocal := '#';

                    // this is done for Big to show the date time as text , should be also fine for
                    // Us regional settings format (since we pront the date time as Text).
                    // working for BIG 05/10/2017
                    WriteValuesForExcel(Value,Row, Column, Sheet, ExcelInstalled);
                    //Sheet.Cells[Row, Column].Value :=  Value; // RoundDblToDbl(Value, 0)
                 //   Sheet.Cells[Row, Column].Value := Value;//RoundDblToDbl(Value, 0);

                    Column := Column + 1;
                  end;
                end
                else if (dataType = CBT_date) and (IsEmptyDateTime(FieldValue)) then
                begin
                  WriteValuesForExcel('---',Row, Column, Sheet, ExcelInstalled);
                    //Sheet.Cells[Row, Column].Value := '---';
                  Column := Column + 1;
                end
                else
                begin
                  if (dataType = CBT_date) then
                  begin
                    if ExcelInstalled and not ColFormatSet[Column] then
                    begin
                      Sheet.Columns[Column].HorizontalAlignment := -4131; // aligned left
                      ColFormatSet[Column] := True;
                    end;

            {        GetLocaleFormatSettings(LOCALE_SYSTEM_DEFAULT, formatSettings);

                    ExcelYearChar := XLApp.International[19];
                    ExcelMonthChar := XLApp.International[20];
                    ExcelDayChar := XLApp.International[21];
                    ExcelHourChar := XLApp.International[22];
                    ExcelMinuteChar := XLApp.International[23];

                    DateFormat := formatSettings.ShortDateFormat;
                    DateFormat := StringReplace(DateFormat, 'y', LowerCase(ExcelYearChar), [rfReplaceAll]);
                    DateFormat := StringReplace(DateFormat, 'Y', UpperCase(ExcelYearChar), [rfReplaceAll]);
                    DateFormat := StringReplace(DateFormat, 'm', LowerCase(ExcelMonthChar), [rfReplaceAll]);
                    DateFormat := StringReplace(DateFormat, 'M', UpperCase(ExcelMonthChar), [rfReplaceAll]);
                    DateFormat := StringReplace(DateFormat, 'd', LowerCase(ExcelDayChar), [rfReplaceAll]);
                    DateFormat := StringReplace(DateFormat, 'D', UpperCase(ExcelDayChar), [rfReplaceAll]);

                    TimeFormat := 'hh:mm';
                    TimeFormat := StringReplace(TimeFormat, 'h', LowerCase(ExcelHourChar), [rfReplaceAll]);
                    TimeFormat := StringReplace(TimeFormat, 'm', LowerCase(ExcelMinuteChar), [rfReplaceAll]);

                    DateTimeFormat := DateFormat + ' ' + TimeFormat;        }


                    // this is done for Big to show the date time as text , should be also fine for
                    // Us regional settings format (since we pront the date time as Text).
                    // working for BIG 05/10/2017

                    if ExcelInstalled and not ColFormatSet[Column] then
                    begin
                      Sheet.Columns[Column].NumberFormat := DateTimeFormat;
                      ColFormatSet[Column] := True;
                    end;

                    WriteValuesForExcel(Value,Row, Column, Sheet, ExcelInstalled);
                    //Sheet.Cells[Row, Column].Value := Value;//FieldValue;
                    Column := Column + 1;
                  end
                  else
                  begin
                    if ExcelInstalled and not ColFormatSet[Column] then
                    begin
                      Sheet.Columns[Column].NumberFormat := '@';
                      ColFormatSet[Column] := True;
                    end;

                    WriteValuesForExcel(FieldValue,Row, Column, Sheet, ExcelInstalled);
                    //Sheet.Cells[Row, Column].Value := FieldValue;
                    Column := Column + 1;
                  end;
                end;
              end;
              end; // close else (GetFldRealValue path)
            end;
          end;
        end;

        if ReportSettings.Concatenation and not ResDet.Downtime
        and (not ReportSettings.IsBinReport) then
        begin
          Content := '';
          for B := 1 to Column - 1 do
          begin
             if ReportSettings.HeadingConcatenation then
                Content := Content + HeadingConcatenationColumn[B - 1] + ReportSettings.HeadingSeparator;

             // Always read from BinData (values are bulk-assigned to Sheet after the loop)
              Content := Content + VarToStr(Bindata[Row, B]) + ReportSettings.Separator
          end;
          WriteValuesForExcel(Content,Row, Column, Sheet, ExcelInstalled);
                    //Sheet.Cells[Row, Column].Value := Content;
          Column := Column + 1;
        end;
      end;

      if not ReportSettings.PrintComments then
         continue;
      Column := ReportSettings.ColumnComments;

      with qry do
      begin

      //Transaction.Active := true;
        ProdNo := p_sc.GetFldDescr(Id, CSC_ProdReq, true);
        ProdStep := p_sc.GetFldDescr(Id, CSC_ProdStep, true);

        SQL.Clear;
        SQL.Add('select * from ' + tbInfo.GetTableName + ' where ' + CreateFld(tbInfo.pfx,fli_preqNo) + ' = ' + QuotedStr(ProdNo) +
        ' and ((' + CreateFld(tbInfo.pfx,fli_pstepId) + ' = ' +  QuotedStr(ProdStep) + ') or (' + CreateFld(tbInfo.pfx,fli_pstepId) + ' = ' + QuotedStr('0') + ' )) and ' +
          CreateFld(tbInfo.pfx,fli_infoType) + ' in (' + QuotedStr('4') + ',' + QuotedStr('5') + ')' );
        SQL.Add(AND_IDF_Condition(CreateFld(TbInfo.pfx, fli_Identifier)));
        open;
        while not EOF do
        begin
          Row := Row + 1;
          WriteValuesForExcel(FieldByName(CreateFld(tbInfo.pfx, fli_InfoArea)).Asstring,Row, Column, Sheet, ExcelInstalled);
          //Sheet.Cells[Row, Column].Value := FieldByName(CreateFld(tbInfo.pfx, fli_InfoArea)).Asstring;
          Next;
        end;
        close;
      end;
    end;

    // For Dynamic Schedule Reports, add totals statistics
    if not ReportSettings.IsBinReport and ReportSettings.ShowTotal then
    begin
      Row := Row + 2;
      for i := 1 to colNum do
      begin
        if i = 1 then
        begin
          //WriteLabel(Row, i, _('Total'));
          //added by Erbil K���KAHMET
          WriteValuesForExcel(_('Total'),Row, i, Sheet, ExcelInstalled);
          //Sheet.Cells[Row, i].Value := _('Total');
          Column := Column + 1;
        end
        else if i = ColumnExeTimeSched then
        begin
          //WriteLabel(Row, i, FormatDuration(sumSchedExecTime, true));
          //added by Erbil K���KAHMET
          if DBAppSettings.ReportTimeFormat = '0' then
            WriteValuesForExcel(FormatDuration(sumSchedExecTime, true),Row, i, Sheet, ExcelInstalled)
          //Sheet.Cells[Row, i].Value := FormatDuration(sumSchedExecTime, true)
          else if DBAppSettings.ReportTimeFormat = '1' then
            WriteValuesForExcel(IntToStr(sumSchedExecTime),Row, i, Sheet, ExcelInstalled);
          //Sheet.Cells[Row, i].Value := IntToStr(sumSchedExecTime);
          Column := Column + 1;
        end
        else if i = ColumnSupTimeSched then
        begin
          //WriteLabel(Row, i, FormatDuration(sumSetupTime, true));
          //added by Erbil K���KAHMET
          if DBAppSettings.ReportTimeFormat = '0' then
            WriteValuesForExcel(FormatDuration(sumSetupTime, true),Row, i, Sheet, ExcelInstalled)
          //Sheet.Cells[Row, i].Value := FormatDuration(sumSetupTime, true)
          else if DBAppSettings.ReportTimeFormat = '1' then
            WriteValuesForExcel(IntToStr(sumSetupTime),Row, i, Sheet, ExcelInstalled);
          //Sheet.Cells[Row, i].Value := IntToStr(sumSetupTime);
          Column := Column + 1;
        end
        else if i = ColumnStepExeTime  then
        begin
          //WriteLabel(Row, i, FormatDuration(sumStepExeMin, true));
          //added by Erbil K���KAHMET
         if DBAppSettings.ReportTimeFormat = '0' then
            WriteValuesForExcel(FormatDuration(sumStepExeMin, true),Row, i, Sheet, ExcelInstalled)
          //Sheet.Cells[Row, i].Value := FormatDuration(sumStepExeMin, true)
          else if DBAppSettings.ReportTimeFormat = '1' then
            WriteValuesForExcel(IntToStr(sumStepExeMin),Row, i, Sheet, ExcelInstalled);
          //Sheet.Cells[Row, i].Value := IntToStr(sumStepExeMin);
          Column := Column + 1;
        end
        else if i = ColumnActualExecTime  then
        begin
          //WriteLabel(Row, i, FormatDuration(sumActualExecTime, true));
          //added by Erbil K���KAHMET
          if DBAppSettings.ReportTimeFormat = '0' then
            WriteValuesForExcel(FormatDuration(sumActualExecTime, true),Row, i, Sheet, ExcelInstalled)
          //Sheet.Cells[Row, i].Value := FormatDuration(sumActualExecTime, true)
          else if DBAppSettings.ReportTimeFormat = '1' then
           WriteValuesForExcel(IntToStr(sumActualExecTime),Row, i, Sheet, ExcelInstalled);
          //Sheet.Cells[Row, i].Value := IntToStr(sumActualExecTime);
          Column := Column + 1;
        end
        else if i = ColumnProgQty      then
        begin
          //WriteNumber(Row, i, Round(sumProgQty));
          //added by Erbil K���KAHMET
          WriteValuesForExcel(Round(sumProgQty),Row, i, Sheet, ExcelInstalled);
          //Sheet.Cells[Row, i].Value := Round(sumProgQty);
          Column := Column + 1;
        end
        else if i = ColumnFinalQty     then
        begin
          //WriteNumber(Row, i, Round(sumFinQty));
          //added by Erbil K���KAHMET
          WriteValuesForExcel(Round(sumFinQty),Row, i, Sheet, ExcelInstalled);
          //Sheet.Cells[Row, i].Value := Round(sumFinQty);
          Column := Column + 1;
        end
        else if i = ColumnQtyToSched   then
        begin
          //WriteNumber(Row, i, Round(sumQtyToSched));
          //added by Erbil K���KAHMET

          WriteValuesForExcel(Round(sumQtyToSched),Row, i, Sheet, ExcelInstalled);
          //Sheet.Cells[Row, i].Value := Round(sumQtyToSched);
          Column := Column + 1;
        end;
      end;
    end;
    //showmessage(Filename);
    //
    //SaveToFile;
    FinalRow := Row;  // capture actual last written row before leaving the with block
    CloseFile;

    //exit;
  end;

  //XLApp.Workbooks[1].SaveAs('amanyaw0'); //to save in xlsx format

  if ExcelInstalled then
  begin
    // Bulk-assign only the rows actually written (FinalRow) instead of the full pre-allocated array
    if FinalRow < 1 then FinalRow := 1;
    Sheet.Range[Sheet.Cells[1, 1], Sheet.Cells[FinalRow, VarArrayHighBound(BinData, 2)]].Value := BinData;
    VarClear(BinData);
    XLApp.Workbooks[1].SaveAs(ReportSettings.SaveFileLocation); //1=to save in xls format
    MessageFilter.RevokeFilter();
    XLApp.DisplayAlerts := False;
    XLApp.Quit;
    XLAPP := Unassigned;
    Sheet := Unassigned;
  end else
  begin
    CreateExcel(BinData, ReportSettings.SaveFileLocation);
    VarClear(BinData);
  end;


  if ReportSettings.PrintComments then
  begin
    qry.Free;
  end;

  Result := true;
  HeadingConcatenationColumn.Free;
end;

//----------------------------------------------------------------------------//
{ This procedure writes the HTML file(s) with the data stored in JobList
  @param JobList         Job List for Dynamic Schedule or Bin Extraction Report
  @param showResource    Indicates whether Job List spans over only one resource
  @param ReportSettings  Report settings given by calling units }
//----------------------------------------------------------------------------//

function WriteHtmlFile(JobList: TList; showResource: boolean;
                       ReportSettings: TSettings; IsFromReport : boolean): boolean;
var
  i, j, k, pos,
  ColumnStart,
  ColumnEnd,
  ColumnComment,
  ColumnQtyToSched,
  ColumnExeTimeSched,
  ColumnSupTimeSched,
  ColumnActualTime,
  ColumnProgQty,
  ColumnFinalQty,
  ColumnRes,
  ColumnResDescr,
  ColumnStepExeTime,
  colNum,
  pageActRows,
  position,
  StepGroupIndex,
  stepTypeIndex,
  sumStepExeMin,
  sumActualTime,
  sumSchedExecTime,
  sumSetupTime,
  headerPos,
  fromPage,
  toPage           : Integer;
  sumFinQty,
  sumProgQty,
  sumQtyToSched,
  tmpTime          : Double;
  ActBinGrid       : TBinDrawGrid;
  ActTab           : TBinTabSheet;
  ColAttributes    : TBinColCurrent;
  Field,
  FieldValue,
  tempString       : string;
  ResDet           : PTResourceDet;
  id               : TSchedId;
  Value            : Variant;
  dataType         : CBinColValType;
  sl,
  Header           : TStringList;
  doItOneTime,
  OddRow,
  hasEqualCriteria,
  noGroupJump      : boolean;
  DatesInfo        : TSQDatesInfo;
  SplitCriteria    : Array [0..4] of string;
  status           : TRecordStatus;
begin
  Result             := false;
  sumSchedExecTime   := 0;
  sumSetupTime       := 0;
  sumActualTime      := 0;
  sumQtyToSched      := 0;
  sumProgQty         := 0;
  sumStepExeMin      := 0;
  sumFinQty          := 0;
  ColumnStart        := 0;
  ColumnEnd          := 0;
  ColumnComment      := 0;
  ColumnQtyToSched   := 0;
  ColumnExeTimeSched := 0;
  ColumnSupTimeSched := 0;
  ColumnRes          := 0;
  ColumnResDescr     := 0;
  ColumnProgQty      := 0;
  ColumnFinalQty     := 0;
  ColumnStepExeTime  := 0;
  colNum             := 0;
  ColumnActualTime   := 0;
  stepTypeIndex      := -1;
  StepGroupIndex     := -1;
  OddRow             := true;
  noOfHtmlPages      := 0;
  HeaderPos := 15;
  ActTab := FBin.GetActiveView;
  if not Assigned(ActTab) then exit;

  // Create header
  ActBinGrid := ActTab.GetBinGrid;
  sl     := TStringList.Create;
  Header := TStringList.Create;
  Header.Add('<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">');
  Header.Add('<HTML>');
  Header.Add('<HEAD>');
  Header.Add('<STYLE type="text/css"> body {background-color: '+ColorHexaToHtml(ReportSettings.HtmlColorBack)+'}');
  Header.Add('  TH {background: '+ColorHexaToHtml(ReportSettings.HtmlColorTabTitle)+
    ' ; font-family: '''+ReportSettings.FontColTitles.Name+
    ''', Arial, Helvetica, sans-serif; font-size: '+IntToStr(ReportSettings.FontColTitles.Size)+
    'px; '+FontStyleToHtml(ReportSettings.FontColTitles.Style)+'color: '+
    ColorHexaToHtml(ReportSettings.FontColTitles.Color)+'; text-align: center}');
  Header.Add('  TR.Header { background: #E4E4E4; font-family: Arial, Helvetica, sans-serif; font-size: 12px}');
  Header.Add('  TR.Odd { background: '+ColorHexaToHtml(ReportSettings.HtmlColorTabOdd)+
    '; font-family: Arial, Helvetica, sans-serif; font-size: 12px}');
  Header.Add('  TR.Even { background: '+ColorHexaToHtml(ReportSettings.HtmlColorTabEven)+
    '; font-family: Arial, Helvetica, sans-serif; font-size: 12px}');
  Header.Add('  TR.Space { background: Gray; font-family: Arial, Helvetica, sans-serif; font-size: 8px}');
  Header.Add('  TD {font-family: '''+ReportSettings.FontDataLine.Name+
    ''', Arial, Helvetica, sans-serif; font-size: '+IntToStr(ReportSettings.FontDataLine.Size)+
    'px; '+FontStyleToHtml(ReportSettings.FontDataLine.Style)+'color: ' +
    ColorHexaToHtml(ReportSettings.FontDataLine.Color)+'; text-align: center}');
  Header.Add('  P.Title {font-family: Arial, Helvetica, sans-serif; font-size: 28px; text-align: center}');
  Header.Add('</STYLE>');
  Header.Add('</HEAD>');
  Header.Add('<BODY>');

  if ReportSettings.ShowBinCaption then
  begin
    Header.Add('<center><h2><p class="Title"><span style="font-family: ''' +
      ReportSettings.FontBinCaption.Name +
      ''', Arial, Helvetica, sans-serif; font-size: ' +
      IntToStr(ReportSettings.FontBinCaption.Size)+'px; ' +
      FontStyleToHtml(ReportSettings.FontBinCaption.Style) + 'color: ' +
      ColorHexaToHtml(ReportSettings.FontBinCaption.Color) + '">' +
      ActTab.Caption + '</span></p></h2></center> ');
    Inc(HeaderPos);
  end;

  if ReportSettings.ShowResources and ReportSettings.NewPagePerRes then
  begin
    Header.Add('Resource');
  end;

  if (not ReportSettings.IsBinReport) and ReportSettings.ShowCriteria then
  begin
    Header.Add('<center><h3><p class="Title"><span style="font-family: ''' +
      ReportSettings.FontCriteria.Name +
      ''', Arial, Helvetica, sans-serif; font-size: ' +
      IntToStr(ReportSettings.FontCriteria.Size)+'px; ' +
      FontStyleToHtml(ReportSettings.FontCriteria.Style) + 'color: ' +
      ColorHexaToHtml(ReportSettings.FontCriteria.Color) + '">' +
      _('From') + ':  ' + DateToStr(ReportSettings.DateFrom) + '  ' +
      TimeToStr(ReportSettings.DateFrom) + '      ' + _('To') +
      ': ' + DateToStr(ReportSettings.DateTo) + '  ' +
      TimeToStr(ReportSettings.DateTo) + '</span></p></h3></center>');
  end;

  if ReportSettings.Comment <> '' then
  begin
    Header.Add('<center><h3><p class="Title"><span style="font-family: ''' +
      ReportSettings.FontComment.Name +
      ''', Arial, Helvetica, sans-serif; font-size: ' +
      IntToStr(ReportSettings.FontComment.Size)+'px; ' +
      FontStyleToHtml(ReportSettings.FontComment.Style) + 'color: ' +
      ColorHexaToHtml(ReportSettings.FontComment.Color) + '">' +
      ReportSettings.Comment + '</span></p></h3></center>');
  end;

  Header.Add('<table align="center" border="1"  >');
  Header.Add('  <tr>');

  // Only for Bin Extraction, create table fields Row Number and Status
  if ReportSettings.IsBinReport then
  begin
    Header.Add('    <th>' + _('Row No') + '.</th>');
    if DBAppSettings.FixColStatVis then
      Header.Add('    <th>' + _('Status') + '</th>');
  end;

  // Create table columns
  for i := 0 to High(BinColDefault) - 1 do
  begin
    pos := ActBinGrid.FindPos(i);
    ColAttributes := ActBinGrid.BinColumnSet[pos];
    if ColAttributes.Field <> CSC_MsgFromHost then
    begin
      if ColAttributes.Visible then
      begin
        if ColAttributes.Title = '' then Field := _(getPropertyDesc(pos, ActBinGrid))
        else Field := _(ColAttributes.Title);

      //  Field := AnsiReplaceText(Field,' ','&nbsp;'); // avi 13/4/2010

        Header.Add('    <th>' + Field + '</th>');
        colNum := colNum + 1;
        if ColAttributes.Field = CSC_ProgStart then ColumnStart := colNum
        else if ColAttributes.Field = CSC_ProgEnd then ColumnEnd := colNum
        else if ColAttributes.Field = CSC_Comment then ColumnComment := colNum
        else if ColAttributes.Field = CSC_QtyToSched then ColumnQtyToSched := colNum
        else if ColAttributes.Field = CSC_ExeTimeSched then ColumnExeTimeSched := colNum
        else if ColAttributes.Field = CSC_SupTimeSched then ColumnSupTimeSched := colNum
        else if ColAttributes.Field = CSC_Rsc then ColumnRes := colNum
        else if ColAttributes.Field = CSC_RscDesc then ColumnResDescr := colNum
        else if ColAttributes.Field = CSC_ProgQty then ColumnProgQty := colNum
        else if ColAttributes.Field = CSC_FinQty then ColumnFinalQty := colNum
        else if ColAttributes.Field = CSC_ExeTime then ColumnStepExeTime := colNum
        else if ColAttributes.Field = CSC_ActualTime then ColumnActualTime := colNum
        else if ColAttributes.Field = CSC_StepType then stepTypeIndex := i
        else if ColAttributes.Field = CSC_ReprocNo then stepTypeIndex := i;
      end;
    end;
  end;
  Header.Add('  </tr>');

  // Calculate how many pages are created (pageAmount), including MaxRows and
  // the flag for page break when new resource is reached
  toPage := 0;
  pageActRows := 0;
  noGroupJump := true;
  SplitCriteria[4] := 'xxxxxxxxxxxxxxxxxxxx';
  for k := 0 to 3 do SplitCriteria[k] := '';
  for i := 0 to JobList.Count - 1 do
  begin
    ResDet := JobList.Items[i];
    id := TSchedId(ResDet.ID);
    status := REC_OK;
    if (i > 0) and (((ReportSettings.MaxRows > 0) and (pageActRows >= ReportSettings.MaxRows))
      or ((ReportSettings.NewPagePerRes) and (ResDet.ResCode <> SplitCriteria[4])))
      or (not noGroupJump) then
    begin
      Inc(toPage);
      pageActRows := 0;
      noGroupJump := true;
    end;
    if (id <> CSchedIdNull) or (ResDet.Downtime) then
    begin
      if (ResDet.ResCode <> SplitCriteria[4]) and (not ReportSettings.NewPagePerRes)
        and ReportSettings.ShowResources then
        status := REC_BREAK;
      if ReportSettings.IsBinReport and (status = REC_OK) and (ReportSettings.GroupingFields > 0) then
      begin
        hasEqualCriteria := true;
        for k := 0 to ReportSettings.GroupingFields - 1 do
        begin
          tempString := p_sc.GetFldDescr(id, ActBinGrid.BinColumnSet[ActBinGrid.FindOrderPos(k)].Field, true);
          hasEqualCriteria := hasEqualCriteria and (SplitCriteria[k] = tempString);
          if k <= ReportSettings.JumpingFields - 1 then
            noGroupJump := noGroupJump and (SplitCriteria[k] = tempString);
          if not hasEqualCriteria then SplitCriteria[k] := tempString;
        end;
        if (not hasEqualCriteria) and (status = REC_OK) then status := REC_BREAK;
      end;
    end;
    if status = REC_OK then pageActRows := pageActRows + 1
    else pageActRows := pageActRows + 2;
    if ResDet.ResCode <> SplitCriteria[4] then SplitCriteria[4] := ResDet.ResCode;
  end;
  if pageActRows > 0 then Inc(toPage);
  if toPage < 2 then Dec(HeaderPos);
  fromPage := 0;
  pageActRows := 0;
  SplitCriteria[4] := 'xxxxxxxxxxxxxxxxxxxx';
  for k := 0 to 3 do SplitCriteria[k] := '';

  // For each job do...
  for i := 0 to JobList.Count - 1 do
  begin
    OddRow      := not OddRow;
    ResDet      := JobList.Items[i];
    id          := TSchedId(ResDet.ID);
    doItOneTime := false;
    noGroupJump := true;
    status      := REC_OK;

    // Calculate status for current job
    if (id <> CSchedIdNull) or ResDet.Downtime or ReportSettings.NewPagePerRes or
      ReportSettings.ShowResources or ReportSettings.ShowGroups or (ReportSettings.GroupingFields > 0) then
    begin
      if ResDet.ResCode <> SplitCriteria[4] then
      begin
        if ReportSettings.NewPagePerRes then status := REC_BREAK
        else if ReportSettings.ShowResources then status := REC_BREAK_RES;
      end;
      if ReportSettings.IsBinReport and (ReportSettings.GroupingFields > 0) then
      begin
        hasEqualCriteria := true;
        if not ResDet.Downtime then
        begin
          for k := 0 to ReportSettings.GroupingFields - 1 do
          begin
            tempString := p_sc.GetFldDescr(id, ActBinGrid.BinColumnSet[ActBinGrid.FindOrderPos(k)].Field, true);
            hasEqualCriteria := hasEqualCriteria and (SplitCriteria[k] = tempString);
            if k <= ReportSettings.JumpingFields - 1 then
              noGroupJump := noGroupJump and (SplitCriteria[k] = tempString);
            if not hasEqualCriteria then SplitCriteria[k] := tempString;
          end;
        end
        else
        begin
          hasEqualCriteria := hasEqualCriteria and (SplitCriteria[0] = _('Downtime'));
          SplitCriteria[0] := _('Downtime');
          for k := 1 to ReportSettings.GroupingFields - 1 do SplitCriteria[k] := '';
        end;
        if not hasEqualCriteria then begin
          if (status = REC_OK) and (not ReportSettings.ShowGroups) then status := REC_BREAK;
          if ReportSettings.ShowGroups then
          begin
            case status of
              REC_OK, REC_BREAK : status := REC_BREAK_GROUP;
              REC_BREAK_RES     : status := REC_BREAK_RES_GROUP;
            end;
          end;
        end;
      end;
    end;

    // If necessary, create a new page
    if (i=0) or ((ReportSettings.MaxRows > 0) and (pageActRows >= ReportSettings.MaxRows)) or
      ((ReportSettings.NewPagePerRes) and (ResDet.ResCode <> SplitCriteria[4]))
      or (not noGroupJump) then
    begin
      if status in [REC_OK, REC_BREAK] then pageActRows := 1
      else pageActRows := 2;
      OddRow := false;
      Inc(fromPage);
      noOfHtmlPages := noOfHtmlPages + 1;
      if toPage > 1 then
      begin
        if fromPage > 1 then Header.Delete(14);
        Header.Insert(14, '<h4><span style="color: ' +
          ColorHexaToHtml(ReportSettings.FontBinCaption.Color) + '">' +
          _('Page') + ' ' + IntToStr(fromPage) + ' ' + _('of') + ' ' +
          IntToStr(toPage) + '</span></h4>' );
      end;
      if ReportSettings.ShowResources and ReportSettings.NewPagePerRes then
      begin
        Header.Delete(HeaderPos);
        tempString := '<center><h3><p class="Title"><span style="font-family: ''' +
          ReportSettings.FontCriteria.Name + ''', Arial, Helvetica, sans-serif; font-size: ' +
          IntToStr(ReportSettings.FontCriteria.Size)+'px; ' +
          FontStyleToHtml(ReportSettings.FontCriteria.Style) + 'color: ' +
          ColorHexaToHtml(ReportSettings.FontCriteria.Color) + '">';
        if ResDet.ResCode <> '' then
        begin
          if ResDet.ResDesc <> '' then
            tempString := tempString + ResDet.ResDesc + '(' + ResDet.ResCode + ')'
          else
            if ResDet.ResCode <> '' then tempString := tempString + ResDet.ResCode
        end;
        Header.Insert(HeaderPos, tempString + '</span></p></h3></center>');
      end;
      if noOfHtmlPages > 1 then
      begin
        sl.Add('</table>');
        sl.Add('</BODY>');
        sl.Add('</HTML>');
        sl.SaveToFile(ReportSettings.SaveFileLocation);
      end;
      sl.Clear;
      sl.AddStrings(Header);
      if not ReportSettings.IsExportReport then
        ReportSettings.SaveFileLocation := GetCurrentDir + SetBackslash + HTML_REPORT_NAME +  IntToStr(noOfHtmlPages) + '.html';
      if status = REC_BREAK then status := REC_OK;
    end
    else
    begin
      if status = REC_OK then pageActRows := pageActRows + 1
      else pageActRows := pageActRows + 2;
    end;
    if SplitCriteria[4] <> ResDet.ResCode then SplitCriteria[4] := ResDet.ResCode;

    // Fill data row
    if (id <> CSchedIdNull) or (ResDet.Downtime) then
    begin
      // Insert a break into the table data depending on record status: at least one
      // criteria defined or show resource description set
      if status <> REC_OK then
      begin
        tempString := '';
        if (status in [REC_BREAK_RES, REC_BREAK_RES_GROUP]) then
        begin
          if ResDet.ResCode <> ''  then
          begin
            tempString := tempString + ResDet.ResCode;
            if ResDet.ResDesc <> '' then tempString := tempString + '(' + ResDet.ResDesc + ')';
          end
        end;
        if status in [REC_BREAK_GROUP, REC_BREAK_RES_GROUP] then
        begin
          if ResDet.Downtime then tempString := tempString + _('Downtime')
          else
          begin
            for k := 0 to ReportSettings.GroupingFields - 1 do
            begin
              tempString := tempString + getPropertyDesc(ActBinGrid.FindOrderPos(k),
                            ActBinGrid) + ': ' + SplitCriteria[k];
              if k < ReportSettings.GroupingFields - 1 then tempString := tempString + ', ';
            end;
          end;
        end;
        if tempString = '' then tempString := '&#160;';
        sl.Add('  <tr>');
        sl.Add('    <td style="text-align:left" colspan=100 style="font-family: ''' +
          ReportSettings.FontCriteria.Name + ''', Arial, Helvetica, sans-serif; font-size: ' +
          IntToStr(ReportSettings.FontCriteria.Size)+'px; ' +
          FontStyleToHtml(ReportSettings.FontCriteria.Style) + 'color: ' +
          ColorHexaToHtml(ReportSettings.FontCriteria.Color) + '">' + tempString + '</td>');
        sl.Add('  </tr>');
      end;

      if not ResDet.Downtime then p_sc.GetDatesInfo(id, DatesInfo);
      if OddRow then sl.Add('  <tr class = Odd>')
      else sl.Add('  <tr class = Even>');

      // Fill Row Number and Status for Bin Extraction
      if ReportSettings.IsBinReport then
      begin
        sl.Add('    <td align="center">' + IntToStr(i + 1) + '</td>');

        if DBAppSettings.FixColStatVis then
        begin
          tempString := '    <td align="center">';
          if not isClosed(id) then
          begin
            case p_sc.IsProgressed(id) of
              prg_Starting:   tempString := tempString + _('Started');
              prg_General:    tempString := tempString + _('Progressed');
              prg_Final,
              prg_FinalSplit: tempString := tempString + _('Ended');
              else
              begin
                if (p_sc.GetSchedType(id) = '0') then tempString := tempString + '---'
                else if (p_sc.GetSchedType(id) = '1') then tempString := tempString + _('Temporarily')
                else if (p_sc.GetSchedType(id) = '2') then tempString := tempString + _('Fixed')
                else if (p_sc.GetSchedType(id) = '3') then tempString := tempString + _('Level 1')
                else if (p_sc.GetSchedType(id) = '4') then tempString := tempString + _('Level 2')
                else if (p_sc.GetSchedType(id) = '5') then tempString := tempString + _('Level 3')
                else if (p_sc.GetSchedType(id) = '6') then tempString := tempString + _('Level 4')
                else if (p_sc.GetSchedType(id) = '7') then tempString := tempString + _('Level 5')
              end;
            end;
          end
          else tempString := tempString + _('Closed');
          sl.Add(tempString + '</td>');
        end;
      end;

      // Fill the other columns and calculate totals statistics
      for j:= 0 to High(BinColDefault) - 1 do
      begin
        pos := ActBinGrid.FindPos(j);
        ColAttributes := ActBinGrid.BinColumnSet[pos];
        if ColAttributes.Field <> CSC_MsgFromHost then
        begin
          if ColAttributes.Visible and ResDet.Downtime then
          begin
            if not doItOneTime then
            begin
              sl.Add('    <td><b> ' + _('Downtime') + ' <b></td>');
              for k := 2 to colNum do
              begin
                sl.Add('    <td>---</td>');
                doItOneTime := true;
              end;
            end;
            position := sl.Count - colNum - 1;
            if ColAttributes.Field = CSC_ProgStart then
            begin
              sl.Delete(position + ColumnStart);
              if IsEmptyDateTime(ResDet.DownTimeFrom) then
                tempString := '    <td>---</td>'
              else tempString := '    <td>' + FormatDateTime('dddd',
                StrToDateTime(ResDet.DownTimeFrom)) + ' ' + ResDet.DownTimeFrom + '</td>';
              sl.Insert(position + ColumnStart, tempString);
            end
            else if ColAttributes.Field = CSC_ProgEnd then
            begin
              sl.Delete(position + ColumnEnd);
              if IsEmptyDateTime(ResDet.DownTimeTo) then
                tempString := '    <td>---</td>'
              else tempString := '    <td>' + FormatDateTime('dddd',
                StrToDateTime(ResDet.DownTimeTo)) + ' ' + ResDet.DownTimeTo + '</td>';
              sl.Insert(position + ColumnEnd, tempString);
            end
            else if (ColAttributes.Field = CSC_Comment) and (ResDet.Comment <> '') then
            begin
              sl.Delete(position + ColumnComment);
              tempString := '    <td> ' + ResDet.Comment + '</td>';
              sl.Insert( position + ColumnComment, tempString);
            end
            else if ColAttributes.Field = CSC_Rsc then
            begin
              sl.Delete(position + ColumnRes);
              tempString := '    <td> ' + ResDet.ResCode;
              if ResDet.SubResCode <> '' then
              tempString := tempString + SUBRESSEPARATOR + ResDet.SubResCode;
              tempString := tempString + '</td>';
              sl.Insert(position + ColumnRes, tempString);
            end
            else if (ColAttributes.Field = CSC_RscDesc) and (ResDet.ResDesc <> '') then
            begin
              sl.Delete(position + ColumnResDescr);
              tempString := '    <td> ' + ResDet.ResDesc + '</td>';
              sl.Insert( position + ColumnResDescr, tempString);
            end;
            if ReportSettings.IncDowntime then
            begin
              tmpTime := 1440 * (StrToDateTime(ResDet.DownTimeTo) - StrToDateTime(ResDet.DownTimeFrom));
              if ColAttributes.Field = CSC_ExeTimeSched then
              begin
                sl.Delete(position + ColumnExeTimeSched);
                tempString := '    <td> ' + FormatDuration(tmpTime, true) + '</td>';
                sl.Insert(position + ColumnExeTimeSched, tempString);
                sumSchedExecTime := sumSchedExecTime + Round(tmpTime);
              end
              else if ColAttributes.Field = CSC_ExeTime then
              begin
                sl.Delete(position + ColumnStepExeTime);
                tempString := '    <td> ' + FormatDuration(tmpTime, true) + '</td>';
                sl.Insert( position + ColumnStepExeTime, tempString);
                sumStepExeMin := sumStepExeMin + Round(tmpTime);
              end;
            end;
          end
          else if ColAttributes.Visible then
          begin
            p_sc.GetFldValue(Id, ColAttributes.Field, Value, dataType);
            if (ColAttributes.Field = CSC_GroupNo) and (Value = '-1') then Value := '';
            FieldValue := VarToStr(Value);

            if (not IsFromReport) and (dataType = CBT_string) then
                FieldValue := AnsiReplaceText(FieldValue,' ','&nbsp;'); // avi 13/4/2010

            if Trim(FieldValue) = '' then FieldValue := '---';
           // if (Trim(FieldValue) = '') and not isproperty(ColAttributes.Field) then FieldValue := '---';
            if ColAttributes.Field in [CSC_ExeTime, CSC_PlanSetup, CSC_ExeTimeSched, CSC_ActualTime,
                                       CSC_SupTimeSched] then
            begin
              if not ReportSettings.IsBinReport then
              begin
                if ColAttributes.Field = CSC_ExeTimeSched then sumSchedExecTime := sumSchedExecTime + Value
                else if ColAttributes.Field = CSC_SupTimeSched then sumSetupTime := sumSetupTime + Value
                else if ColAttributes.Field = CSC_ActualTime then sumActualTime := sumActualTime + Value
                else if ColAttributes.Field = CSC_ExeTime then sumStepExeMin := sumStepExeMin + Value;
              end;
              if DBAppSettings.ReportTimeFormat = '1' then
                FieldValue := Value
              else
                FieldValue := p_sc.GetFldDescr(id, ColAttributes.Field, true);
              FieldValue := AnsiReplaceText(FieldValue,' ','&nbsp;'); // avi 13/4/2010
              sl.Add('    <td>' + FieldValue + '</td>');
            end
            else
            begin
              if not ReportSettings.IsBinReport then
              begin
                if ColAttributes.Field = CSC_QtyToSched then sumQtyToSched := sumQtyToSched + Round(Value)
                else if ColAttributes.Field = CSC_ProgQty then sumProgQty := sumProgQty + Round(Value)
                else if ColAttributes.Field = CSC_FinQty then sumFinQty := sumFinQty + Round(Value);
              end;
              if (dataType <> CBT_integer) and (dataType <> CBT_float)
                and (stepGroupIndex = j ) and (FieldValue = IntToStr(-1)) then FieldValue := '---';
              if (ColAttributes.Field = CSC_Rsc) and (ResDet.SubResCode <> '') then
                FieldValue := FieldValue + SUBRESSEPARATOR + ResDet.SubResCode
              else if (dataType = CBT_integer) or (dataType = CBT_float) then
              begin
                if IsProperty(ColAttributes.Field) then
                  FieldValue := FormatQtyWithoutZeros(Value, 3)
                else
                  FieldValue := FormatQtyWithoutZeros(Value, 0)
              end
              else if (dataType = CBT_date) and (IsEmptyDateTime(FieldValue)) then FieldValue := '---'
              else if (ColAttributes.Field = CSC_ProgStart) or (ColAttributes.Field = CSC_ProgEnd) then
                FieldValue := FormatDateTime('dddd', Value) + ' ' + FieldValue;
              if stepTypeIndex = j then
              begin
                case StrToInt(FieldValue) of
                  1: FieldValue := _('Batch');
                  2: FieldValue := _('Continuous');
                end;
                dataType := CBT_string;
              end;

              if (not IsFromReport) and  (dataType = CBT_date) then
                FieldValue := AnsiReplaceText(FieldValue,' ','&nbsp;'); // avi 13/4/2010

              sl.Add('    <td>' + FieldValue + '</td>');
            end;
          end;
        end;
      end;
      sl.Add('  </tr>');
    end;
  end;

  // Add totals statistics for Dynamic Schedule Report
  if not ReportSettings.IsBinReport then
  begin
    if OddRow then sl.Add('  <tr class = Even>')
    else sl.Add('  <tr class = Odd>');
    for i:= 1 to colNum do
    begin
      if      i = 1                  then sl.Add('    <td><b>' + _('Total') + '</b></td>')
      else if i = ColumnQtyToSched   then sl.Add('    <td><b>' + FormatQtyWithoutZeros(sumQtyToSched, 0)       + '</b></td>')
      else if i = ColumnExeTimeSched then
      begin
        if DBAppSettings.ReportTimeFormat = '0' then
          sl.Add('    <td><b>' + FormatDuration(sumSchedExecTime, true) + '</b></td>')
        else if DBAppSettings.ReportTimeFormat = '1' then
          sl.Add('    <td><b>' + IntToStr(sumSchedExecTime) + '</b></td>')
      end
      else if i = ColumnActualTime then
      begin
        if DBAppSettings.ReportTimeFormat = '0' then
          sl.Add('    <td><b>' + FormatDuration(sumActualTime, true) + '</b></td>')
        else if DBAppSettings.ReportTimeFormat = '1' then
          sl.Add('    <td><b>' + IntToStr(sumActualTime) + '</b></td>')
      end
      else if i = ColumnSupTimeSched then
      begin
        if DBAppSettings.ReportTimeFormat = '0' then
          sl.Add('    <td><b>' + FormatDuration(sumSetupTime, true)     + '</b></td>')
        else if DBAppSettings.ReportTimeFormat = '1' then
          sl.Add('    <td><b>' + IntToStr(sumSetupTime)     + '</b></td>')
      end
      else if i = ColumnProgQty      then sl.Add('    <td><b>' + FormatQtyWithoutZeros(sumProgQty, 0)          + '</b></td>')
      else if i = ColumnFinalQty     then sl.Add('    <td><b>' + FormatQtyWithoutZeros(sumFinQty, 0)           + '</b></td>')
      else if i = ColumnStepExeTime  then
      begin
        if DBAppSettings.ReportTimeFormat = '0' then
          sl.Add('    <td><b>' + FormatDuration(sumStepExeMin, true)       + '</b></td>')
        else if DBAppSettings.ReportTimeFormat = '1' then
          sl.Add('    <td><b>' + IntToStr(sumStepExeMin)       + '</b></td>')
      end
      else                                sl.Add('    <td><b>---</b></td>');
    end;
    sl.Add('  </tr>');
  end;
  sl.Add('</table>');
  sl.Add('</BODY>');
  sl.Add('</HTML>');
  sl.SaveToFile(ReportSettings.SaveFileLocation);
  sl.Free;
  Result := true;
end;

//----------------------------------------------------------------------------//
{ Converts font attributes as TFontStyles into a HTML readable string
  @Param fontStyles    Font attributes }
//----------------------------------------------------------------------------//

function FontStyleToHtml(fontStyles: TFontStyles): string;
begin
  Result := '';
  if fsBold in fontStyles then Result := Result + 'font-weight: 900; '
  else Result := Result + 'font-weight: 500; ';
  if fsItalic in fontStyles then Result := Result + 'font-style: italic; ';
  // if Underline AND StrikeOut is activated, StrikeOut is ignored for HTML.
  if (fsUnderline in fontStyles) or (fsStrikeOut in fontStyles) then
  begin
    Result := Result + 'text-decoration: ';
    if fsUnderline in fontStyles then Result := Result + 'underline; '
    else Result := Result + 'line-through; ';
  end;
end;

//----------------------------------------------------------------------------//
{ Converts a color as TColor into a HTML readable hexadecimal string
  @Param color    Color value }
//----------------------------------------------------------------------------//

function ColorHexaToHtml(color: TColor): string;
begin
  Result := IntToHex(color, 6);
  Result := '#' + Result[5] + Result[6] + Result[3] + Result[4] + Result[1] + Result[2];
end;

//----------------------------------------------------------------------------//
{ Checks if the step is closed
  @param Job      ID of the Job }
//----------------------------------------------------------------------------//

function IsClosed(Job: TSchedID): boolean;
var
  StepInfo       : TSQStepInfo;
  ProdNo, StepNo : string;
  j              : Integer;
begin
  StepNo := p_sc.GetFldDescr(Job, CSC_ProdStep, true);
  ProdNo := p_sc.GetFldDescr(Job, CSC_ProdReq, true);
  for j := 0 to p_sc.StepCount(ProdNo) - 1 do
  begin
    StepInfo := p_sc.GetStepByIndex(ProdNo, j);
    if StepInfo.StepNo = StrToInt(StepNo) then break;
  end;
  Result := StepInfo.StepClosed;
end;

//----------------------------------------------------------------------------/
{ Checks if the String is invalid or empty(=0) DateTime value
  @param Arg     String to check }
//----------------------------------------------------------------------------//

function IsEmptyDateTime(Arg: string): Boolean;
var
  dt: TDateTime;
begin
  dt := 0;
  Result := true;
  try
    dt := StrToDateTime(Arg);
  except
    on EConvertError do;
  end;
  if dt <> 0 then Result := false;
end;

//----------------------------------------------------------------------------/
{ Checks if the Column ID is one of the 60 properties
  @param ColId     Column Id to check }
//----------------------------------------------------------------------------//

function IsProperty(ColId: CBinColId): Boolean;
begin
  Result := (ColId = CSC_property1) or (ColId = CSC_property2) or (ColId = CSC_property3) or
    (ColId = CSC_property4) or (ColId = CSC_property5) or (ColId = CSC_property6) or
    (ColId = CSC_property7) or (ColId = CSC_property8) or (ColId = CSC_property9) or
    (ColId = CSC_property10) or (ColId = CSC_property11) or (ColId = CSC_property12) or
    (ColId = CSC_property13) or (ColId = CSC_property14) or (ColId = CSC_property15) or
    (ColId = CSC_property16) or (ColId = CSC_property17) or (ColId = CSC_property18) or
    (ColId = CSC_property19) or (ColId = CSC_property20) or (ColId = CSC_property21) or
    (ColId = CSC_property22) or (ColId = CSC_property23) or (ColId = CSC_property24) or
    (ColId = CSC_property25) or (ColId = CSC_property26) or (ColId = CSC_property27) or
    (ColId = CSC_property28) or (ColId = CSC_property29) or (ColId = CSC_property30) or
    (ColId = CSC_property31) or (ColId = CSC_property32) or (ColId = CSC_property33) or
    (ColId = CSC_property34) or (ColId = CSC_property35) or (ColId = CSC_property36) or
    (ColId = CSC_property37) or (ColId = CSC_property38) or (ColId = CSC_property39) or
    (ColId = CSC_property40) or (ColId = CSC_property41) or (ColId = CSC_property42) or
    (ColId = CSC_property43) or (ColId = CSC_property44) or (ColId = CSC_property45) or
    (ColId = CSC_property46) or (ColId = CSC_property47) or (ColId = CSC_property48) or
    (ColId = CSC_property49) or (ColId = CSC_property50) or (ColId = CSC_property51) or
    (ColId = CSC_property52) or (ColId = CSC_property53) or (ColId = CSC_property54) or
    (ColId = CSC_property55) or (ColId = CSC_property56) or (ColId = CSC_property57) or
    (ColId = CSC_property58) or (ColId = CSC_property59) or (ColId = CSC_property60);

end;

//----------------------------------------------------------------------------//
{ Get the description of a property in a grid
  @param Acol      Cell number in the Bin Grid
  @param BinGrid   The BinGrid itself }
//----------------------------------------------------------------------------//

procedure FixAlphaStructure(ColId: CBinColId; var Value : string);
var
  Num : integer;
  pId : TPropId;
begin
  Num := -1;
  case ColId of
    CSC_property1:   num := 0;
    CSC_property2:   num := 1;
    CSC_property3:   num := 2;
    CSC_property4:   num := 3;
    CSC_property5:   num := 4;
    CSC_property6:   num := 5;
    CSC_property7:   num := 6;
    CSC_property8:   num := 7;
    CSC_property9:   num := 8;
    CSC_property10:  num := 9;
    CSC_property11:  num := 10;
    CSC_property12:  num := 11;
    CSC_property13:  num := 12;
    CSC_property14:  num := 13;
    CSC_property15:  num := 14;
    CSC_property16:  num := 15;
    CSC_property17:  num := 16;
    CSC_property18:  num := 17;
    CSC_property19:  num := 18;
    CSC_property20:  num := 19;
    CSC_property21:  num := 20;
    CSC_property22:  num := 21;
    CSC_property23:  num := 22;
    CSC_property24:  num := 23;
    CSC_property25:  num := 24;
    CSC_property26:  num := 25;
    CSC_property27:  num := 26;
    CSC_property28:  num := 27;
    CSC_property29:  num := 28;
    CSC_property30:  num := 29;
    CSC_property31:  num := 30;
    CSC_property32:  num := 31;
    CSC_property33:  num := 32;
    CSC_property34:  num := 33;
    CSC_property35:  num := 34;
    CSC_property36:  num := 35;
    CSC_property37:  num := 36;
    CSC_property38:  num := 37;
    CSC_property39:  num := 38;
    CSC_property40:  num := 39;
    CSC_property41:  num := 40;
    CSC_property42:  num := 41;
    CSC_property43:  num := 42;
    CSC_property44:  num := 43;
    CSC_property45:  num := 44;
    CSC_property46:  num := 45;
    CSC_property47:  num := 46;
    CSC_property48:  num := 47;
    CSC_property49:  num := 48;
    CSC_property50:  num := 49;
    CSC_property51:  num := 50;
    CSC_property52:  num := 51;
    CSC_property53:  num := 52;
    CSC_property54:  num := 53;
    CSC_property55:  num := 54;
    CSC_property56:  num := 55;
    CSC_property57:  num := 56;
    CSC_property58:  num := 57;
    CSC_property59:  num := 58;
    CSC_property60:  num := 59
  end;

  if (num = -1) and (ColId <> CSC_ProdReq) then
     Exit;

  if num <> -1 then
  begin
    pId := DBAppGlobals.ShowBinPropArry[num];

    if not IsPropAlpha(pId) then
       Exit;
  end;

  try
    StrToIntDef(Value, 0); //StrToInt(Value);
  except

    try
      StrToFloat(Value);
    except
      Exit;
    end;

  end;

  if copy(Value,1,1) = '0' then
       Value := '''' + value;

end;

//----------------------------------------------------------------------------//

function GetPropertyDesc(Acol: Integer; BinGrid: TBinDrawGrid): string;
var
  num: Integer;
  pId: TPropId;
begin
  Result := '';
  num := -1;
  case BinGrid.BinColumnSet[Acol].Field of
    CSC_property1:   num := 0;
    CSC_property2:   num := 1;
    CSC_property3:   num := 2;
    CSC_property4:   num := 3;
    CSC_property5:   num := 4;
    CSC_property6:   num := 5;
    CSC_property7:   num := 6;
    CSC_property8:   num := 7;
    CSC_property9:   num := 8;
    CSC_property10:  num := 9;
    CSC_property11:  num := 10;
    CSC_property12:  num := 11;
    CSC_property13:  num := 12;
    CSC_property14:  num := 13;
    CSC_property15:  num := 14;
    CSC_property16:  num := 15;
    CSC_property17:  num := 16;
    CSC_property18:  num := 17;
    CSC_property19:  num := 18;
    CSC_property20:  num := 19;
    CSC_property21:  num := 20;
    CSC_property22:  num := 21;
    CSC_property23:  num := 22;
    CSC_property24:  num := 23;
    CSC_property25:  num := 24;
    CSC_property26:  num := 25;
    CSC_property27:  num := 26;
    CSC_property28:  num := 27;
    CSC_property29:  num := 28;
    CSC_property30:  num := 29;
    CSC_property31:  num := 30;
    CSC_property32:  num := 31;
    CSC_property33:  num := 32;
    CSC_property34:  num := 33;
    CSC_property35:  num := 34;
    CSC_property36:  num := 35;
    CSC_property37:  num := 36;
    CSC_property38:  num := 37;
    CSC_property39:  num := 38;
    CSC_property40:  num := 39;
    CSC_property41:  num := 40;
    CSC_property42:  num := 41;
    CSC_property43:  num := 42;
    CSC_property44:  num := 43;
    CSC_property45:  num := 44;
    CSC_property46:  num := 45;
    CSC_property47:  num := 46;
    CSC_property48:  num := 47;
    CSC_property49:  num := 48;
    CSC_property50:  num := 49;
    CSC_property51:  num := 50;
    CSC_property52:  num := 51;
    CSC_property53:  num := 52;
    CSC_property54:  num := 53;
    CSC_property55:  num := 54;
    CSC_property56:  num := 55;
    CSC_property57:  num := 56;
    CSC_property58:  num := 57;
    CSC_property59:  num := 58;
    CSC_property60:  num := 59

  end;
  if (num <> -1) then
  begin
    pId := DBAppGlobals.ShowBinPropArry[num];
    if pId <> nil then Result := GetPropDescr(pId);
  end else Result := BinGrid.BinColumnSet[Acol].Title
end;

//----------------------------------------------------------------------------//
{ Initializes report fonts by the values in the MQM global values (from MQM-INI)
  @Param ReportSettings    Report settings that include the fonts }
//----------------------------------------------------------------------------//

procedure SetReportFonts(var ReportSettings: TSettings);
begin
  ReportSettings.FontBinCaption := TFont.Create;
  ReportSettings.FontBinCaption.Name := iniAppGlobals.FontBinCaption;
  ReportSettings.FontBinCaption.Style := StringToFontStyles(iniAppGlobals.FontBinCapStyle);
  try
    ReportSettings.FontBinCaption.Color := StrToInt(iniAppGlobals.FontBinCapColor);
  except ReportSettings.FontBinCaption.Color := clBlack;
  end;
  try
    ReportSettings.FontBinCaption.Charset := StrToInt(iniAppGlobals.FontBinCapChar);
  except ReportSettings.FontBinCaption.Charset := 0;
  end;
  try
    ReportSettings.FontBinCaption.Size := StrToInt(iniAppGlobals.FontBinCapSize);
  except ReportSettings.FontBinCaption.Size := 28;
  end;
  ReportSettings.FontCriteria := TFont.Create;
  ReportSettings.FontCriteria.Name := iniAppGlobals.FontCriteria;
  ReportSettings.FontCriteria.Style := StringToFontStyles(iniAppGlobals.FontCriteriaStyle);
  try
    ReportSettings.FontCriteria.Color := StrToInt(iniAppGlobals.FontCriteriaColor);
  except ReportSettings.FontCriteria.Color := clBlack;
  end;
  try
    ReportSettings.FontCriteria.Charset := StrToInt(iniAppGlobals.FontCriteriaChar);
  except ReportSettings.FontCriteria.Charset := 0;
  end;
  try
    ReportSettings.FontCriteria.Size := StrToInt(iniAppGlobals.FontCriteriaSize);
  except ReportSettings.FontCriteria.Size := 24;
  end;
  ReportSettings.FontComment := TFont.Create;
  ReportSettings.FontComment.Name := iniAppGlobals.FontComment;
  ReportSettings.FontComment.Style := StringToFontStyles(iniAppGlobals.FontCommentStyle);
  try
    ReportSettings.FontComment.Color := StrToInt(iniAppGlobals.FontCommentColor);
  except ReportSettings.FontComment.Color := clBlack;
  end;
  try
    ReportSettings.FontComment.Charset := StrToInt(iniAppGlobals.FontCommentChar);
  except ReportSettings.FontComment.Charset := 0;
  end;
  try
    ReportSettings.FontComment.Size := StrToInt(iniAppGlobals.FontCommentSize);
  except ReportSettings.FontComment.Size := 20;
  end;
  ReportSettings.FontColTitles := TFont.Create;
  ReportSettings.FontColTitles.Name := iniAppGlobals.FontColTitles;
  ReportSettings.FontColTitles.Style := StringToFontStyles(iniAppGlobals.FontColTitleStyle);
  try
    ReportSettings.FontColTitles.Color := StrToInt(iniAppGlobals.FontColTitleColor);
  except ReportSettings.FontColTitles.Color := clBlack;
  end;
  try
    ReportSettings.FontColTitles.Charset := StrToInt(iniAppGlobals.FontColTitleChar);
  except ReportSettings.FontColTitles.Charset := 0;
  end;
  try
    ReportSettings.FontColTitles.Size := StrToInt(iniAppGlobals.FontColTitleSize);
  except ReportSettings.FontColTitles.Size := 12;
  end;
  ReportSettings.FontDataLine := TFont.Create;
  ReportSettings.FontDataLine.Name := iniAppGlobals.FontDataLine;
  ReportSettings.FontDataLine.Style := StringToFontStyles(iniAppGlobals.FontDataLineStyle);
  try
    ReportSettings.FontDataLine.Color := StrToInt(iniAppGlobals.FontDataLineColor);
  except ReportSettings.FontDataLine.Color := clBlack;
  end;
  try
    ReportSettings.FontDataLine.Charset := StrToInt(iniAppGlobals.FontDataLineChar);
  except ReportSettings.FontDataLine.Charset := 0;
  end;
  try
    ReportSettings.FontDataLine.Size := StrToInt(iniAppGlobals.FontDataLineSize);
  except ReportSettings.FontDataLine.Size := 12;
  end;
  try
    ReportSettings.HtmlColorBack := StrToInt(iniAppGlobals.HtmlColorBack);
  except ReportSettings.HtmlColorBack := clWhite;
  end;
  try
    ReportSettings.HtmlColorTabTitle := StrToInt(iniAppGlobals.HtmlColorTabTitle);
  except ReportSettings.HtmlColorTabTitle := clMedGray;
  end;
  try
    ReportSettings.HtmlColorTabEven := StrToInt(iniAppGlobals.HtmlColorTabEven);
  except ReportSettings.HtmlColorTabEven := clWhite;
  end;
  try
    ReportSettings.HtmlColorTabOdd := StrToInt(iniAppGlobals.HtmlColorTabOdd);
  except ReportSettings.HtmlColorTabOdd := clLtGray;
  end;
end;

//----------------------------------------------------------------------------//
{ Converts font attributes as TFontStyles into a string for the MQM globals
  @Param fontStyles    Font attributes }
//----------------------------------------------------------------------------//

function FontStylesToString(fontStyles: TFontStyles): string;
begin
  if fontStyles = [fsBold, fsItalic, fsUnderline, fsStrikeOut] then Result := '1111'
  else if fontStyles = [fsBold, fsItalic, fsUnderline] then Result := '1110'
  else if fontStyles = [fsBold, fsItalic, fsStrikeOut] then Result := '1101'
  else if fontStyles = [fsBold, fsItalic] then Result := '1100'
  else if fontStyles = [fsBold, fsUnderline, fsStrikeOut] then Result := '1011'
  else if fontStyles = [fsBold, fsUnderline] then Result := '1010'
  else if fontStyles = [fsBold, fsStrikeOut] then Result := '1001'
  else if fontStyles = [fsBold] then Result := '1000'
  else if fontStyles = [fsItalic, fsUnderline, fsStrikeOut] then Result := '0111'
  else if fontStyles = [fsItalic, fsUnderline] then Result := '0110'
  else if fontStyles = [fsItalic, fsStrikeOut] then Result := '0101'
  else if fontStyles = [fsItalic] then Result := '0100'
  else if fontStyles = [fsUnderline, fsStrikeOut] then Result := '0011'
  else if fontStyles = [fsUnderline] then Result := '0010'
  else if fontStyles = [fsStrikeOut] then Result := '0001'
  else Result := '0000'; // Cases empty or invalid set of TFontStyles
end;

//----------------------------------------------------------------------------//
{ Converts a string from the MQM globals into font attributes as TFontStyles
  @Param fontStylesStr    Font attributes as string }
//----------------------------------------------------------------------------//

function StringToFontStyles(fontStylesStr: string): TFontStyles;
begin
  if fontStylesStr = '1111'      then Result := [fsBold, fsItalic, fsUnderline, fsStrikeOut]
  else if fontStylesStr = '1110' then Result := [fsBold, fsItalic, fsUnderline]
  else if fontStylesStr = '1101' then Result := [fsBold, fsItalic, fsStrikeOut]
  else if fontStylesStr = '1100' then Result := [fsBold, fsItalic]
  else if fontStylesStr = '1011' then Result := [fsBold, fsUnderline, fsStrikeOut]
  else if fontStylesStr = '1010' then Result := [fsBold, fsUnderline]
  else if fontStylesStr = '1001' then Result := [fsBold, fsStrikeOut]
  else if fontStylesStr = '1000' then Result := [fsBold]
  else if fontStylesStr = '0111' then Result := [fsItalic, fsUnderline, fsStrikeOut]
  else if fontStylesStr = '0110' then Result := [fsItalic, fsUnderline]
  else if fontStylesStr = '0101' then Result := [fsItalic, fsStrikeOut]
  else if fontStylesStr = '0100' then Result := [fsItalic]
  else if fontStylesStr = '0011' then Result := [fsUnderline, fsStrikeOut]
  else if fontStylesStr = '0010' then Result := [fsUnderline]
  else if fontStylesStr = '0001' then Result := [fsStrikeOut]
  else Result := []; // Cases '0000' or invalid string
end;

//----------------------------------------------------------------------------//
{ Creates and prints a Fixed Schedule Report
  @Param ReportSettings    The report settings }
//----------------------------------------------------------------------------//

procedure PrintFixedResourceReport(ReportSettings: TSettings);
var
  res              : TMqmRes;
  visRes           : TMqmVisibleRes;
  act_area         : TMqmActArea;
  schedObj         : TSchedId;
  planInfo         : TSQplanInfo;
  new_resource,
  jobs_on_resource : boolean;
  PropRscCode,
  Res_Code,
  SchedType,
  UM               : string;
  i, j, k, l       : Integer;
  sl               : TStringList;
  startingDate     : TDateTime;
  dataType         : CBinColValType;
  Comment,
  execution_time,
  GroupNo,
  ProdFamily,
  ProdReqNum,
  ProdStep,
  ProdSubStep,
  Progressed_Quantity,
  PropVal,
  Reproc_Num,
  Scheduled_Quantity,
  setup_Time,
  Value,
  WorkCenterProc   : variant;
  prop             : TProperties;
  PropID           : TPropID;
begin
  // Create header
  sl := TStringList.Create;
  sl.Add('<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">');
  sl.Add('<HTML>');
  sl.Add('<HEAD>');
  sl.Add('<TITLE>' + _('MQM plan resources report') + ' </TITLE>');
  sl.Add('<STYLE type="text/css">');
  sl.Add('  TH { background: #C0C0C0 ; color: #000000; font-family: Arial, Helvetica, sans-serif; font-size: 14px; font-weight: bold; text-align: center}');
  sl.Add('  TR.header { background: #E4E4E4; color: #000000; font-family: Arial, Helvetica, sans-serif; font-size: 12px}');
  sl.Add('  TD.center{ text-align: center }');
  sl.Add('  TD {font-size: 90%; font-family: Arial, Helvetica, sans-serif; font-size: 12px}');
  sl.Add('  P.Title {font-family: Arial, Helvetica, sans-serif; font-size: 28px; font-weight: bold; text-align: center}');
  sl.Add('</STYLE>');
  sl.Add('</HEAD>');
  sl.Add('<BODY>');
  sl.Add('<p class="Title"> ' + _('Resource report for the following dates') + ':  <br>  ');
  sl.Add(' ' + _('From') + ' ' + DateToStr(ReportSettings.DateFrom - 1) + ' ' + _('to') + ' ' +  DateToStr(ReportSettings.DateTo));
  sl.Add('</p><br>');
  sl.Add('<table align="center" border="1"  >');
  sl.Add('  <tr>');
  sl.Add('    <td>');

  // Create report for each selected resource
  for i := 0 to (ReportSettings.ChkLstBoxRsc.Items.Count - 1) do
  begin
    new_resource := true;
    jobs_on_resource := false;
    if ReportSettings.ChkLstBoxRsc.Checked[i] then
    begin
      Res_Code := ReportSettings.ChkLstBoxRsc.Items.Strings[i];
      res := TMqmRes(p_pl.FindResByCode(Res_Code));
      sl.Add('    <table align="center" border="1"  >');
      sl.Add('      <tr>');
      sl.Add('        <th class="Title" colspan="5">');
      sl.Add(           Res_Code + '  ---  ' + res.p_ResSDesc + '  <br>  ' );
      sl.Add(             TMqmWrkCtr(res.p_Father).p_WrkCtrLDesc + '</th>');
      sl.Add('      </tr>');
      sl.Add('      <tr >');
      if not res.p_isMultiRes then visRes := res.p_VisRes[0]
      else
      begin
        visRes := res.GetSubRes(0);
        if not Assigned(visRes) then exit;
      end;

      for j := 0 to visRes.p_ActAreasCount - 1 do
      begin
        act_Area := TMqmActArea(visRes.p_ActArea[j]);
        if (TMqmRes(act_Area.p_Res)).p_ResCode = Res_Code then
          for k := 0 to act_area.SchedObjsCount - 1 do
          begin
            jobs_on_resource := true;
            act_area.SortSchedObjs;
            schedObj := TSchedID(act_area.GetSchedObj(k));
            p_sc.GetPlanInfo(schedObj, planInfo);
            SchedType := p_sc.GetSchedType(schedObj);
            if (planInfo.isOnPlan) then
            begin
              if new_resource = false then sl.Add('<tr></tr>')
              else new_resource := false;
              startingDate := planInfo.startDate ;
              if not ((startingDate < ReportSettings.DateFrom - 1) or
                      (startingDate > ReportSettings.DateTo)) then
              begin
                p_sc.GetFldValue(schedObj, CSC_GroupNo, Value, dataType);
                GroupNo := Value;
                if GroupNo = '-1' then
                begin
                  p_sc.GetFldValue(schedObj, CSC_ProdReq, Value, dataType);
                  ProdReqNum := Value;
                  p_sc.GetFldValue(schedObj, CSC_ProdStep, Value, dataType);
                  ProdStep := IntToStr(Value);
                  p_sc.GetFldValue(schedObj, CSC_ProdSubStep, Value, dataType);
                  ProdSubStep := IntToStr(Value);
                  p_sc.GetFldValue(schedObj, CSC_ReprocNo, Value, dataType);
                  Reproc_num := IntToStr(Value);
                  sl.Add('        <tD>&nbsp; <b> ' + _('Request') + ': </b>');
                  sl.Add(         ProdReqNum +'&nbsp;</td>');
                  sl.Add('        <tD>&nbsp; <b> ' +  _('Step') + ': </b>');
                  sl.Add(         ProdStep +'&nbsp;</td> ');
                  sl.Add('        <tD>&nbsp; <b> '+ _('Substep') + ': </b>');
                  sl.Add(         ProdSubStep +'&nbsp;</td> ');
                  sl.Add('        <tD>&nbsp; <b> ' + _('Re-process') + ': </b>');
                  sl.Add(         Reproc_Num +'&nbsp;');
                  sl.Add('        </td>');
                  sl.Add('      </tr>');
                end
                else
                begin
                  sl.Add('        <tD>&nbsp; <b> ' + _('Group') +': </b>');
                  try
                  sl.Add(         IntToStr(GroupNo) +'&nbsp;');
                  except
                    sl.Add(       'Host' +'&nbsp;');
                  end;
                  sl.Add('        </tD>');
                  sl.Add('      </tr>');
                end;
                p_sc.GetFldValue(schedObj, CSC_ProdFamily, Value, dataType);
                ProdFamily := Value;
                sl.Add('        <tr>');
                sl.Add('          <td>&nbsp; <b> ' + _('Product family') + ': </b>');
                sl.Add(           ProdFamily +'&nbsp;</td> ');
                sl.Add('          <tD> &nbsp; <b> ' + _('Starting') + ': </b> '+DateTimeToStr(startingDate) + '&nbsp;</td>');
                WorkCenterProc := p_sc.GetFldDescr(schedObj, CSC_WkctProc, true);
                sl.Add('          <tD> &nbsp; <b> ' + WorkCenterProc + '</b></td>');
                p_sc.GetPlanInfo(schedObj, planInfo);
                setup_time := FormatDuration(planInfo.supMinReal, true);
                sl.Add('          <tD> &nbsp; <b> ' + _('Setup') + ': </b>'+setup_time+' &nbsp; </td>');
                sl.Add('        </tr>');
                sl.Add('        <tr>');
                sl.Add('          <td></td >');
                execution_time := FormatDuration(planInfo.exeMin, true);
                sl.Add('          <tD> &nbsp; <b> ' + _('Execution') + ': </b>'+execution_time+' &nbsp; </td>');
                p_sc.GetFldValue(schedObj, CSC_ProdUM, Value, dataType);
                UM := Value;
                p_sc.GetFldValue(schedObj, CSC_ProgQty, Value, dataType);
                Progressed_Quantity := FloatToStr(Value);
                sl.Add('          <tD> &nbsp; <b> ' + _('Progressed') +': </b>'+Progressed_Quantity+' '+UM+'&nbsp;</td>');
                Scheduled_Quantity := p_sc.GetFldDescr(schedObj, CSC_QtyToSched, true);
                sl.Add('          <tD> &nbsp; <b> ' + _('Scheduled') +': </b>'+Scheduled_Quantity+' '+UM+'&nbsp;</td>');
                sl.Add('        </tr>');
                sl.Add('        <tr>');
                sl.Add('          <td></td >');
                p_sc.GetFldDescr(schedObj, CSC_Comment, true);
                Comment := p_sc.GetFldDescr(schedObj, CSC_Comment, true);
                sl.Add('          <tD colspan="4"> &nbsp; <b> ' + _('Comment') +': </b>' + Comment+'</td>');
                sl.Add('        </tr>');
                sl.Add('        <tr>');
                sl.Add('          <td></td >');
                prop := p_sc.GetProperties(schedObj, nil);
                if Assigned(prop) and (Prop.p_PropCount > 0) then
                begin
                  for l := 0 to Prop.p_PropCount - 1 do
                  begin
                    PropVal := Prop.GetProperty(l, propId, PropRscCode);
                    sl.Add('          <tD>');
                    sl.Add( GetPropDescr( propId));
                    sl.Add('             = ');
                    sl.Add(PropVal );
                    sl.Add('          </tD>');
                    if ((l+1) mod 4) = 0 then
                    begin
                      sl.Add('        </tr>');
                      sl.Add('        <tr>');
                      sl.Add('          <tD></tD>');
                    end;
                  end;
                  sl.Add('</tr>');
                  sl.Add('<tr><td align="center" colspan=5 >-----------------' + _('End') + '--------------------</td></tr>');
                end;
              end;
            end;
          end;
      end;
      if jobs_on_resource then
      begin
        sl.Add('</table>');
        sl.Add('</td>');
        sl.Add('</tr>');
        sl.Add('<tr>');
        sl.Add('  <td>');
      end;
    end;
  end;
  sl.Add('</td></tr>');
  sl.Add('</table>');
  sl.Add('</BODY>');
  sl.Add('</HTML>');
  sl.SaveToFile(ReportSettings.SaveFileLocation);
  sl.Free
end;

//----------------------------------------------------------------------------//

function WriteFreeResExcelFile(ResList: TList; ReportSettings: TSettings): boolean;
const
  xlWBATWorksheet = $FFFFEFB9;
var
  i : Integer;
  ResDet             : PTResourceDet;
  XLApp: OLEVariant;
  Sheet: OLEVariant;
  OldResCode : string;
  SumFreeRes : double;
begin
  OldResCode := '';
  SumFreeRes := 0;

  var ExcelInstalled := CheckIfExcelInstalled;

  if ExcelInstalled then
  begin
    XLApp := CreateOleObject('Excel.Application');
    XLApp.Visible := false;
  //  XLApp.Workbooks.Add(xlWBATWorksheet);
    XLApp.Application.Workbooks.Add;
    XLApp.Worksheets.Add;
    XLApp.Worksheets[1].Select;
    XLApp.Workbooks[1].Worksheets[1].Name := 'Free Report';
    Sheet := XLApp.Workbooks[1].WorkSheets[1];
  end else
  begin
   { for j := 0 to High(BinColDefault) - 1 do
    begin
      position := ActBinGrid.FindPos(j);
      ColAttributes := ActBinGrid.BinColumnSet[position];
      if ColAttributes.Visible and (ColAttributes.Field <> CSC_MsgFromHost) then VisColInBin := VisColInBin + 1;
    end;       }

    BinData := VarArrayCreate([1,(ResList.Count * 7), 1, 256 + 2 ], varVariant);
  end;


  with ReportSettings.NativeExcel do
  begin

    FileName := ReportSettings.SaveFileLocation;
    AddFont(FMQMPlan.ExcelFontBold.Font);
    AddFont(FMQMPlan.ExcelFontHeader1.Font);
    AddFont(FMQMPlan.ExcelFontHeader2.Font);

    Row := 0;
    Column := 4;

    ActiveFont := 3;
    WriteValuesForExcel(_('From') + ':  ' + DateToStr(ReportSettings.DateFrom)
                                        + '  ' + TimeToStr(ReportSettings.DateFrom) + '      ' + _('To') + ': ' +
                                        DateToStr(ReportSettings.DateTo) + '  ' + TimeToStr(ReportSettings.DateTo),Row, Column, Sheet, ExcelInstalled);

    {Sheet.Cells[Row, Column].Value := _('From') + ':  ' + DateToStr(ReportSettings.DateFrom)
                                        + '  ' + TimeToStr(ReportSettings.DateFrom) + '      ' + _('To') + ': ' +
                                        DateToStr(ReportSettings.DateTo) + '  ' + TimeToStr(ReportSettings.DateTo);   }
    Row := Row + 2;
    Column := 1;
    shading := true;
    ActiveFont := 0;
    Alignment:= eaCenter;

    WriteValuesForExcel('Resource Code',Row, Column, Sheet, ExcelInstalled);
    //Sheet.Cells[Row, Column].Value := 'Resource Code';

    Column := Column + 1;

    WriteValuesForExcel(_('From Date'),Row, Column, Sheet, ExcelInstalled);
    //Sheet.Cells[Row, Column].Value := _('From Date');
    Column := Column + 1;

    WriteValuesForExcel(_('To Date'),Row, Column, Sheet, ExcelInstalled);
    //Sheet.Cells[Row, Column].Value := _('To Date');
    Column := Column + 1;

    WriteValuesForExcel(_('Number of hours'),Row, Column, Sheet, ExcelInstalled);
    //Sheet.Cells[Row, Column].Value := _('Number of hours');
    Column := Column + 1;

    if ResList.Count > 0 then
      OldResCode := PTResourceDet(ResList.Items[0]).ResCode;

    for I := 0 to ResList.Count - 1 do
    begin
      ResDet := ResList.Items[i];

      if OldResCode <> ResDet.ResCode then
      begin
        Row := Row + 1;
        WriteValuesForExcel(FormatDuration(60 * SumFreeRes, true),Row, 4, Sheet, ExcelInstalled);
        //Sheet.Cells[Row, 4].Value := FormatDuration(60 * SumFreeRes, true);
        OldResCode := ResDet.ResCode;
        SumFreeRes := 0;
      end;

      Row := Row +1;
      Column := 1;
      WriteValuesForExcel(ResDet.ResCode,Row, Column, Sheet, ExcelInstalled);
      //Sheet.Cells[Row, Column].Value := ResDet.ResCode;

      if (Column = 1) and (ExcelInstalled) then
         Sheet.Columns[1].NumberFormat := AnsiChar('@');

      Column := Column + 1;
      WriteValuesForExcel(ResDet.FreeResStart,Row, Column, Sheet, ExcelInstalled);
      //Sheet.Cells[Row, Column].Value := ResDet.FreeResStart;
      Column := Column + 1;
      WriteValuesForExcel(ResDet.FreeResEnd,Row, Column, Sheet, ExcelInstalled);
      //Sheet.Cells[Row, Column].Value := ResDet.FreeResEnd;
      Column := Column + 1;
      WriteValuesForExcel(FormatDuration(60 * ResDet.FreeTimeHours, true),Row, Column, Sheet, ExcelInstalled);
      //Sheet.Cells[Row, Column].Value := FormatDuration(60 * ResDet.FreeTimeHours, true);

      SumFreeRes := SumFreeRes + ResDet.FreeTimeHours;


    end;

    if SumFreeRes <> 0 then
    begin
      Row := Row + 1;
      WriteValuesForExcel(FormatDuration(60 * SumFreeRes, true),Row, 4, Sheet, ExcelInstalled);
      //Sheet.Cells[Row, 4].Value := FormatDuration(60 * SumFreeRes, true);
    end;

    CloseFile;
  end;

  if ExcelInstalled then
  begin
    XLApp.Workbooks[1].SaveAs(ReportSettings.SaveFileLocation);

    XLApp.DisplayAlerts := False;
    XLApp.Quit;
    XLAPP := Unassigned;
    Sheet := Unassigned;
  end else
  begin
    CreateExcel(BinData, ReportSettings.SaveFileLocation);
    VarClear(BinData);
  end;
//  if ReportSettings.PrintComments then
//  begin
//    qry.Free;
//    trs.Free
//  end;
  Result := true;
 // HeadingConcatenationColumn.Free;
end;

//----------------------------------------------------------------------------//
{ Sorts the downtime job list by start time
  @param Item1     pointer to a downtime object
  @param Item2     pointer to a downtime object }
//----------------------------------------------------------------------------//

function SortCapRes(Resource1, Resource2: pointer): Integer;
begin
  if TMqmCapRes(Resource1).p_start < TMqmCapRes(Resource2).p_start then Result := 1
  else if TMqmCapRes(Resource1).p_start > TMqmCapRes(Resource2).p_start then Result := -1
  else Result := 0;
end;

//----------------------------------------------------------------------------//
{ Returns a backslash if current directory is not a main folder like C:\ }
//----------------------------------------------------------------------------//

function SetBackslash: string;
begin
  if (Length(GetCurrentDir) > 0) and (GetCurrentDir[Length(GetCurrentDir)] = '\') then Result := ''
  else Result := '\';
end;

//----------------------------------------------------------------------------//
{ Checks whether string parameter is a numeric value }
//----------------------------------------------------------------------------//

function IsNumeric(Arg: string; numType: char): Boolean;
begin
  Result := true;
  try
    if numType = 'i' then StrToInt(Arg)
    else StrToFloat(Arg);
  except
    Result := false;
  end;
end;

//----------------------------------------------------------------------------//
{ Create Bucket Report as real Excel file }
//----------------------------------------------------------------------------//

function GrpBucketReport(ReportSettings: TSettings): string;
var
  Value             : Variant;
  schedObj, grp     : TSchedId;
  res               : TMqmRes;
  visResSub, visRes : TMqmVisibleRes;
  planInfo          : TSQplanInfo;
  dataType          : CBinColValType;
  ResDet            : PTResourceDet;
  JobList           : TList;
  ReportType, SaveFileLocation, Res_Code : String;
  DateFrom, DateTo: Double;
  i,j,k, g, checkedResources : Integer;
  act_area         : TMqmActArea;
  CapRes      : TMqmCapRes;
  pt : TMqmPlanTabSheet;
  ftm:  TFMQMPlan;
begin
  Result           := _('Group Bucket Report aborted!');
  JobList          := TList.Create;
  CapResList       := TList.Create;
  checkedResources := 0;
  DateFrom         := ReportSettings.DateFrom;
  DateTo           := ReportSettings.DateTo;
  ReportType       := ReportSettings.ReportType;
  SaveFileLocation := ReportSettings.SaveFileLocation;
  ftm := FMMainPlan.FMQMPlan;
  pt := TMqmPlanTabSheet(ftm.m_pgcPlan.GetActiveView);

  for i := 0 to pt.p_ganttPanel.p_VisResList.Count -1 do
  begin

    //Res_Code := ChkLstBoxRsc.Items.Strings[i];
    //visRes := TMqmVisibleRes(ChkLstBoxRsc.Items.Objects[i]);
    VisRes := TMqmVisibleRes(pt.p_ganttPanel.p_VisResList[i]);
    res := TMqmRes(visRes.p_Father);
    if not Assigned(res) then continue;

        // Find jobs and downtimes for the actual resource...
    if Assigned(visRes) then
      for j := 0 to visRes.p_ActAreasCount - 1 do
      begin
        act_Area := TMqmActArea(visRes.p_ActArea[j]);

        for k := 0 to act_area.SchedObjsCount - 1 do
        begin

          schedObj := TSchedID(act_area.GetSchedObj(k));
          p_sc.GetPlanInfo(schedObj, planInfo);

          p_sc.GetFldValue(schedObj, CSC_ProgStart, Value, dataType);
          planInfo.StartDate := Value;
          p_sc.GetFldValue(schedObj, CSC_ProgEnd, Value, dataType);
          planInfo.EndDate   := Value;

          if not ((planInfo.EndDate <= DateFrom) or (planInfo.startDate >= DateTo)) then
          begin

            // Add job
            new(ResDet);
            ResDet.ResCode := Res_Code;
            ResDet.SubResCode := '';
            if Assigned(res) and res.p_isMultiRes and Assigned(p_sc.getExtLinkPtr(schedObj))
              and Assigned(TMqmPlanObj(p_sc.getExtLinkPtr(schedObj)).p_Father) then
            begin
              visResSub := TMqmVisibleRes(TMqmActArea(p_sc.getExtLinkPtr(schedObj)).p_Father);
              if Assigned(visResSub) then ResDet.SubResCode := IntToStr(visResSub.p_SubCode);
            end;

            ResDet.ResDesc := res.p_ResSDesc;
            ResDet.Downtime := false;
            ResDet.ID := schedObj;

            p_sc.GetFldValue(schedObj, CSC_ProgStart, Value, dataType);
            ResDet.FromPlanInfo_StartDate := Value;
            p_sc.GetFldValue(schedObj, CSC_SchedStart, Value, dataType);
            ResDet.SchedStart   := Value;

            JobList.Add(ResDet);

            if planInfo.isGroup and (p_sc.GetJobType(schedObj) = CST_Continuous) then
            begin
              grp := schedObj;
              for G := 1 to p_sc.GetGrpNumSons(grp) - 1 do
              begin
                schedObj := p_sc.GetGrpSon(grp, G);
                p_sc.GetPlanInfo(schedObj, planInfo);
                new(ResDet);
                ResDet.ResCode := Res_Code;
                ResDet.SubResCode := '';
                if Assigned(res) and res.p_isMultiRes and Assigned(p_sc.getExtLinkPtr(schedObj))
                  and Assigned(TMqmPlanObj(p_sc.getExtLinkPtr(schedObj)).p_Father) then
                begin
                  visResSub := TMqmVisibleRes(TMqmActArea(p_sc.getExtLinkPtr(schedObj)).p_Father);
                  if Assigned(visResSub) then ResDet.SubResCode := IntToStr(visResSub.p_SubCode);
                end;
                ResDet.ResDesc := res.p_ResSDesc;
                ResDet.Downtime := false;
                ResDet.ID := schedObj;
                //ResDet.IsProgress := (p_sc.IsProgressed(ResDet.ID) <> prg_none);

                p_sc.GetFldValue(schedObj, CSC_ProgStart, Value, dataType);
                ResDet.FromPlanInfo_StartDate := Value;
                p_sc.GetFldValue(schedObj, CSC_SchedStart, Value, dataType);
                ResDet.SchedStart   := Value;

              end;
            end
            else if planInfo.isGroup //and DBAppSettings.ShowBatchGroupLinesInBin
                    and (p_sc.GetJobType(schedObj) = CST_batch) then
            begin
              grp := schedObj;
              for G := 1 to p_sc.GetGrpNumSons(grp) - 1 do
              begin
                schedObj := p_sc.GetGrpSon(grp, G);
                p_sc.GetPlanInfo(schedObj, planInfo);
                new(ResDet);
                ResDet.ResCode := Res_Code;
                ResDet.SubResCode := '';
                if Assigned(res) and res.p_isMultiRes and Assigned(p_sc.getExtLinkPtr(schedObj))
                  and Assigned(TMqmPlanObj(p_sc.getExtLinkPtr(schedObj)).p_Father) then
                begin
                  visResSub := TMqmVisibleRes(TMqmActArea(p_sc.getExtLinkPtr(schedObj)).p_Father);
                  if Assigned(visResSub) then ResDet.SubResCode := IntToStr(visResSub.p_SubCode);
                end;
                ResDet.ResDesc := res.p_ResSDesc;
                ResDet.Downtime := false;
                ResDet.ID := schedObj;

                p_sc.GetFldValue(schedObj, CSC_ProgStart, Value, dataType);
                ResDet.FromPlanInfo_StartDate := Value;
                p_sc.GetFldValue(schedObj, CSC_SchedStart, Value, dataType);
                ResDet.SchedStart   := Value;

                JobList.Add(ResDet);
              end;
            end;
          end; //end of date condition

        end; //end act area

         //cap res
        for k := 0 to act_area.p_CapResCount - 1 do
        begin
            CapRes := TMqmCapRes(act_Area.p_CapRes[k]);
            if not ((CapRes.p_end <= DateFrom) or (CapRes.p_start >= DateTo)) then
              CapResList.Add(CapRes);

        end;
      end;
  end;

  if JobList.Count <= 0 then
  begin
    Result := _('No jobs present on selected resources!');
    exit;
  end;

  ReportSettings.ShowResources := checkedResources <= 1;
 // if reportType = 'Excel_Group_Bucket' then
 Result := WriteGroupBucketExcelFile(JobList, CapResList, checkedResources, ReportSettings)
 // else if reportType = 'Excel_Group_Bucket_for_non_excel' then
 //   Result := _('MS-Excel not installed!');

end;

function WriteCompareBucketExcel(var set1 : TList; ReportSettings: TSettings): string;
var
  pos,colNum,position,i, j,  K, x, a, DoubleColumnsIndex,
  VisColInBin ,RowNum, //AfterIndex, BeforeIndex,
  DoubleColumns     : Integer;
  ActBinGrid        : TBinDrawGrid;
  ActTab            : TBinTabSheet;
  ColAttributes     : TBinColCurrent;
  Field,BinData, SumData     : Variant;
  ColumnType        : array [0..100] of Integer; //0 = text 1 = decimal
  RecSavedPlan : PRecSavedPlanCopy;
  qry : TMqmQuery;
  tbl, tblProp : ^TTblInfo;
  PropList : TSTringList;
  val : Double;
begin
  colNum             := 1;

  qry := CreateQuery(Main_DB);
  tbl := @tblInfo[tbl_prop_prod];
  tblProp := @tblInfo[tbl_prop];
  PropList := TSTringList.Create;

  ActTab := FBin.GetActiveView;
  if not Assigned(ActTab) then exit;
  ActBinGrid := ActTab.GetBinGrid;

  if not assigned(ActBinGrid) then
  begin
    Result := _('You cannot select Warp bin for bucket report!');
    exit;
  end;

  if ReportSettings.ShowResources then
    VisColInBin := 10
  else
    VisColInBin := 9;

  for j := 0 to High(BinColDefault) - 1 do
  begin
    position := ActBinGrid.FindPos(j);
    ColAttributes := ActBinGrid.BinColumnSet[position];

    if (ColAttributes.Visible) and (ColAttributes.PropCode <> '')  then  //properties
      VisColInBin := VisColInBin + 1;
  end;

  BinData := VarArrayCreate([1,(set1.Count * 7) + 1,1, VisColInBin + (Trunc(ReportSettings.DateTo) - Trunc(ReportSettings.DateFrom))], varVariant);

  BinData[1, ColNum] := _('                  Compare Buckets report') + '  ' + _('from') + ' : ' + DateTimeToStr(ReportSettings.Report_Date_From)
        +  ' to : ' + DateTimeToStr(ReportSettings.DateTo);

  ColNum := 1;

  DoubleColumns := Trunc(ReportSettings.DateTo) - Trunc(ReportSettings.DateFrom) + 1;
  SumData := VarArrayCreate([1, 1, 1, DoubleColumns], varVariant);

  BinData[2, ColNum] := _('Production req.');
  Inc(ColNum);
  BinData[2, ColNum] := _('Step');
  Inc(ColNum);
  BinData[2, ColNum] := _('Sub step');
  Inc(ColNum);
  BinData[2, ColNum] := _('Scheduled start');
  Inc(ColNum);
  BinData[2, ColNum] := _('Scheduled end');
  Inc(ColNum);
  BinData[2, ColNum] := _('Schedule execution time');
  Inc(ColNum);

  if ReportSettings.ShowResources then
  begin
    BinData[2, ColNum] := _('Resource');
    Inc(ColNum);
  end;

  for i := 0 to High(BinColDefault) - 1 do  //loop properties
  begin
    pos := ActBinGrid.FindPos(i);
    ColAttributes := ActBinGrid.BinColumnSet[pos];
    Field := '';
    if (ColAttributes.Visible) and (ColAttributes.PropCode <> '')  then  //properties
    begin
      Field := getPropertyDesc(pos, ActBinGrid);
      if Field <> '' then
        PropList.Add(Field);
    end;
  end;

  PropList.Sort;
  for i := 0 to PropList.Count-1 do
  begin
    BinData[2, ColNum] := _(PropList[i]);
    Inc(ColNum);
  end;

  BinData[2, ColNum] := _('Set');
  inc(ColNum);

  i := 0;
  while trunc(ReportSettings.DateFrom) + i <= Trunc(ReportSettings.DateTo)   do
  begin
    BinData[2, ColNum] := DateToStr(trunc(ReportSettings.DateFrom) + i);
    inc(ColNum);
    inc(i);
  end;

  ColNum := 0;
  RowNum := 3;

  RecSavedPlan := nil;
  //LOOP SET
  i := 0;
  while i <= set1.Count - 1 do
  begin
    a := 1;

    if RecSavedPlan = nil then
      RecSavedPlan := PRecSavedPlanCopy(set1[i]);

    if (RecSavedPlan.PREQ_NO = PRecSavedPlanCopy(set1[i]).PREQ_NO)
        and (RecSavedPlan.STEP_ID = PRecSavedPlanCopy(set1[i]).STEP_ID)
        and (RecSavedPlan.SET_NAME = PRecSavedPlanCopy(set1[i]).SET_NAME)
        and (RowNum > 3)
      then
      begin
         Dec(RowNum);
      end
    else if ((RecSavedPlan.PREQ_NO <> PRecSavedPlanCopy(set1[i]).PREQ_NO)
          or (RecSavedPlan.STEP_ID <> PRecSavedPlanCopy(set1[i]).STEP_ID)
          or (RecSavedPlan.SET_NAME <> PRecSavedPlanCopy(set1[i]).SET_NAME))
        then
        begin
          RecSavedPlan := PRecSavedPlanCopy(set1[i]);
        end;


    BinData[RowNum, a] := PRecSavedPlanCopy(set1[i]).PREQ_NO;
    inc(a);
    BinData[RowNum, a] := PRecSavedPlanCopy(set1[i]).STEP_ID;
    inc(a);
    BinData[RowNum, a] := PRecSavedPlanCopy(set1[i]).SubStep;
    inc(a);
    BinData[RowNum, a] := PRecSavedPlanCopy(set1[i]).SchedStart;
    inc(a);
    BinData[RowNum, a] := PRecSavedPlanCopy(set1[i]).SchedEnd;
    inc(a);
    BinData[RowNum, a] := PRecSavedPlanCopy(set1[i]).ExeMin;
    inc(a);
    if ReportSettings.ShowResources then
    begin
      BinData[RowNum, a] := PRecSavedPlanCopy(set1[i]).RSC;
      inc(a);
    end;

    //LOOP FOR PROPERTIES
    var z := 0;
    if PropList.Count > 0 then
    begin
      qry.sql.Text := 'select PY_S_DESC, PP_VALUE, PY_TYPE, PY_NUM_OF_DEC from ' + tbl.GetTableName + ' pp'
        + ' inner join '+tblProp.GetTableName+' p on pp.pp_property = p.py_property and PP_IDENTIFIER = PY_IDENTIFIER '
        + ' where PP_PREQ_NO = '+ QuotedStr(PRecSavedPlanCopy(set1[i]).PREQ_NO)
       // + ' and PP_PSTEP_ID = ' + IntToStr(PRecSavedPlanCopy(set1[i]).SubStep)
       // + ' and PP_RSC_CODE = '+ QuotedStr(PRecSavedPlanCopy(set1[i]).RSC)
        + ' and PP_IDENTIFIER = ' + IniAppGlobals.Identifier
        + ' order by PY_S_DESC';
      qry.Open;

      while z <= PropList.Count - 1 do
      begin
        qry.First;
        while not qry.Eof do
        begin
          if PropList[z] = qry.FieldByName('PY_S_DESC').AsString then
          begin

            if qry.FieldByName('PY_TYPE').AsString = '3' then
            begin
              try
                Val := qry.FieldByName('PP_VALUE').asFloat/(power(10, qry.FieldByName('PY_NUM_OF_DEC').asInteger));
              except
              end;

              BinData[RowNum, a + z] := Val;
            end else
              BinData[RowNum, a + z] := qry.FieldByName('PP_VALUE').AsString;
            //inc(a);
          end;


          qry.Next;
        end;
        inc(z);
      end;

    end; //end loop properties

    a := a + PropList.Count;

    qry.Close;

    BinData[RowNum, a] := PRecSavedPlanCopy(set1[i]).SET_NAME;

    inc(a);
    k := 0;

    DoubleColumnsIndex := a;

    while Trunc(ReportSettings.DateFrom) + k <= Trunc(ReportSettings.DateTo) do
    begin

      if i = set1.Count then break;

      if RecSavedPlan.SET_NAME <> PRecSavedPlanCopy(set1[i]).SET_NAME  then break;

      if (PRecSavedPlanCopy(set1[i]).SchedStart.GetDate <= ReportSettings.DateFrom.GetDate + k)
        and (PRecSavedPlanCopy(set1[i]).SchedEnd.GetDate >= ReportSettings.DateFrom.GetDate + k) then
      begin
        BinData[RowNum, a] := PRecSavedPlanCopy(set1[i]).BucQty;
        if DoubleColumns >= k + 1 then
          SumData[1, k + 1] :=  SumData[1, k + 1] + PRecSavedPlanCopy(set1[i]).BucQty;

        inc(i);
      end;

      inc(k);
      inc(a);
    end;

    Inc(RowNum);
  end;

  BinData[RowNum, DoubleColumnsIndex - 1] := 'Totals:';

  for i := 1 to VarArrayHighBound(SumData, 2) do  //total rows
  begin
    if VarToStr(SumData[1, i]) <> '' then
      BinData[RowNum, DoubleColumnsIndex + i - 1] := SumData[1, i]
    else
      BinData[RowNum, DoubleColumnsIndex + i - 1] := 0;
  end;

  //put 0 on every empty cell for quantities
  for x := DoubleColumnsIndex to VarArrayHighBound(BinData, 2) - 1 do   //columns
  begin
     for i := 3 to RowNum do    //rows
     begin
      if vartostr(BinData[i, x]) = ''  then
        BinData[i, x] := 0;
     end;
  end;


  PropList.Free;

  if ReportSettings.ReportType = 'Excel_Compare_Buckets_for_non_excel' then
    Result := CreateExcel(BinData, ReportSettings.SaveFileLocation)
  else
    Result := CreateExcelSheet(BinData, ColumnType, ReportSettings.SaveFileLocation,ReportSettings.SheetName, ReportSettings.ShowExcel,-1);
end;

function BucketReport(ReportSettings: TSettings): string;
var
  Value             : Variant;
  schedObj, grp    : TSchedId;
  res               : TMqmRes;
  visResSub, visRes        : TMqmVisibleRes;
  planInfo          : TSQplanInfo;
  dataType          : CBinColValType;
  ResDet            : PTResourceDet;
  JobList           : TList;
  ReportType, SaveFileLocation, Res_Code : String;
  ChkLstBoxRsc    : TCheckListBox;
  DateFrom, DateTo: Double;
  i,j,k, g, checkedResources : Integer;
  act_area         : TMqmActArea;
  CapRes      : TMqmCapRes;
begin
  Result           := _('Bucket Report aborted!');
  JobList          := TList.Create;
  CapResList       := TList.Create;
  checkedResources := 0;
  DateFrom         := ReportSettings.DateFrom;
  DateTo           := ReportSettings.DateTo;
  ChkLstBoxRsc     := ReportSettings.ChkLstBoxRsc;
  ReportType       := ReportSettings.ReportType;
  SaveFileLocation := ReportSettings.SaveFileLocation;

  // For each selected resource do... (and count resources)
  for i := 0 to (ChkLstBoxRsc.Items.Count - 1) do
    if ChkLstBoxRsc.Checked[i] then
    begin
      Inc(checkedResources);
      Res_Code := ChkLstBoxRsc.Items.Strings[i];
      visRes := TMqmVisibleRes(ChkLstBoxRsc.Items.Objects[i]);
      res := TMqmRes(visRes.p_Father);
      if not Assigned(res) then continue;

        // Find jobs and downtimes for the actual resource...
    if Assigned(visRes) then
      for j := 0 to visRes.p_ActAreasCount - 1 do
      begin
        act_Area := TMqmActArea(visRes.p_ActArea[j]);

        for k := 0 to act_area.SchedObjsCount - 1 do
        begin
            schedObj := TSchedID(act_area.GetSchedObj(k));
            p_sc.GetPlanInfo(schedObj, planInfo);

            p_sc.GetFldValue(schedObj, CSC_ProgStart, Value, dataType);
            planInfo.StartDate := Value;
            p_sc.GetFldValue(schedObj, CSC_ProgEnd, Value, dataType);
            planInfo.EndDate   := Value;

            if not ((planInfo.EndDate <= DateFrom) or (planInfo.startDate >= DateTo)) then
            begin

              // Add job
              new(ResDet);
              ResDet.ResCode := Res_Code;
              ResDet.SubResCode := '';
              if Assigned(res) and res.p_isMultiRes and Assigned(p_sc.getExtLinkPtr(schedObj))
                and Assigned(TMqmPlanObj(p_sc.getExtLinkPtr(schedObj)).p_Father) then
              begin
                visResSub := TMqmVisibleRes(TMqmActArea(p_sc.getExtLinkPtr(schedObj)).p_Father);
                if Assigned(visResSub) then ResDet.SubResCode := IntToStr(visResSub.p_SubCode);
              end;
              ResDet.ResDesc := res.p_ResSDesc;
              ResDet.Downtime := false;
              ResDet.ID := schedObj;

              p_sc.GetFldValue(schedObj, CSC_ProgStart, Value, dataType);
              ResDet.FromPlanInfo_StartDate := Value;
              p_sc.GetFldValue(schedObj, CSC_SchedStart, Value, dataType);
              ResDet.SchedStart   := Value;

              JobList.Add(ResDet);

              if planInfo.isGroup and (p_sc.GetJobType(schedObj) = CST_Continuous) then
              begin
                grp := schedObj;
                for G := 1 to p_sc.GetGrpNumSons(grp) - 1 do
                begin
                  schedObj := p_sc.GetGrpSon(grp, G);
                  p_sc.GetPlanInfo(schedObj, planInfo);
                  new(ResDet);
                  ResDet.ResCode := Res_Code;
                  ResDet.SubResCode := '';
                  if Assigned(res) and res.p_isMultiRes and Assigned(p_sc.getExtLinkPtr(schedObj))
                    and Assigned(TMqmPlanObj(p_sc.getExtLinkPtr(schedObj)).p_Father) then
                  begin
                    visResSub := TMqmVisibleRes(TMqmActArea(p_sc.getExtLinkPtr(schedObj)).p_Father);
                    if Assigned(visResSub) then ResDet.SubResCode := IntToStr(visResSub.p_SubCode);
                  end;
                  ResDet.ResDesc := res.p_ResSDesc;
                  ResDet.Downtime := false;
                  ResDet.ID := schedObj;
                  //ResDet.IsProgress := (p_sc.IsProgressed(ResDet.ID) <> prg_none);

                  p_sc.GetFldValue(schedObj, CSC_ProgStart, Value, dataType);
                  ResDet.FromPlanInfo_StartDate := Value;
                  p_sc.GetFldValue(schedObj, CSC_SchedStart, Value, dataType);
                  ResDet.SchedStart   := Value;

                end;
              end

              else if planInfo.isGroup //and DBAppSettings.ShowBatchGroupLinesInBin
                      and (p_sc.GetJobType(schedObj) = CST_batch) then
              begin
                grp := schedObj;
                for G := 1 to p_sc.GetGrpNumSons(grp) - 1 do
                begin
                  schedObj := p_sc.GetGrpSon(grp, G);
                  p_sc.GetPlanInfo(schedObj, planInfo);
                  new(ResDet);
                  ResDet.ResCode := Res_Code;
                  ResDet.SubResCode := '';
                  if Assigned(res) and res.p_isMultiRes and Assigned(p_sc.getExtLinkPtr(schedObj))
                    and Assigned(TMqmPlanObj(p_sc.getExtLinkPtr(schedObj)).p_Father) then
                  begin
                    visResSub := TMqmVisibleRes(TMqmActArea(p_sc.getExtLinkPtr(schedObj)).p_Father);
                    if Assigned(visResSub) then ResDet.SubResCode := IntToStr(visResSub.p_SubCode);
                  end;
                  ResDet.ResDesc := res.p_ResSDesc;
                  ResDet.Downtime := false;
                  ResDet.ID := schedObj;

                  p_sc.GetFldValue(schedObj, CSC_ProgStart, Value, dataType);
                  ResDet.FromPlanInfo_StartDate := Value;
                  p_sc.GetFldValue(schedObj, CSC_SchedStart, Value, dataType);
                  ResDet.SchedStart   := Value;

                  JobList.Add(ResDet);
                end;
              end;
            end;
        end;


        //cap res
        for k := 0 to act_area.p_CapResCount - 1 do
        begin
            CapRes := TMqmCapRes(act_Area.p_CapRes[k]);
            if not ((CapRes.p_end <= DateFrom) or (CapRes.p_start >= DateTo)) then
              CapResList.Add(CapRes);

        end;
      end;
    end;

  if JobList.Count <= 0 then
  begin
    Result := _('No jobs present on selected resources!');
    exit;
  end;

  ReportSettings.ShowResources := checkedResources <= 1;
 // if reportType = 'Excel_Bucket' then
 Result := WriteBucketExcelFile(JobList, CapResList, checkedResources, ReportSettings)
 // else if reportType = 'Excel_Bucket_for_non_excel' then
  //  Result := _('MS-Excel not installed!');

end;

//----------------------------------------------------------------------------//

function BucketReportOld(ReportSettings: TSettings): string;
var
  Value             : Variant;
  ActBinGrid        : TBinDrawGrid;
  id                : TSchedID;
  res               : TMqmRes;
  visResSub         : TMqmVisibleRes;
  planInfo          : TSQplanInfo;
  dataType          : CBinColValType;
  ResDet            : PTResourceDet;
  JobList,CapResList           : TList;
  ReportType, SaveFileLocation: String;
  ChkLstBoxRsc    : TCheckListBox;
  DateFrom, DateTo: Double;
  i,IndexOf ,checkedResources : Integer;
  linkInfo: TSQlinkInfo;
begin
  Result           := _('Bucket Report aborted!');
  JobList          := TList.Create;
  CapResList       := TList.Create;
  checkedResources := 0;
  DateFrom         := ReportSettings.DateFrom;
  DateTo           := ReportSettings.DateTo;
  ChkLstBoxRsc     := ReportSettings.ChkLstBoxRsc;
  ReportType       := ReportSettings.ReportType;
  SaveFileLocation := ReportSettings.SaveFileLocation;
  ActBinGrid := FBin.GetActiveView.GetBinGrid;

  for i := 0 to TBinPanel(ActBinGrid.Parent).m_ObjList.GetLinkCount - 1 do
  begin
    id := TSchedId(TBinPanel(ActBinGrid.Parent).m_ObjList.GetLink(i));
    if (id <> CSchedIdNull) and ((p_sc.GetSchedType(id) <> '0') or
      ((p_sc.GetSchedType(id) = '0') and ReportSettings.ShowUnschedJobs)) then
    begin
      p_sc.GetFldValue(id, CSC_Rsc, Value, dataType);
      if trim(Value) = '' then continue;

      if not Assigned(p_sc.getExtLinkPtr(id)) then continue;
      if not Assigned(TMqmPlanObj(p_sc.getExtLinkPtr(id)).p_Father) then continue;

      res := TMqmRes(p_pl.FindResByCode(Value));
      if not Assigned(res) then exit;

      p_sc.GetLinkInfo(id, linkInfo);

      if res.p_isMultiRes then
        IndexOf := ChkLstBoxRsc.Items.IndexOf(res.p_ResCode + SUBRESSEPARATOR + IntToStr(linkInfo.subLinRscId))
      else
        IndexOf := ChkLstBoxRsc.Items.IndexOf(res.p_ResCode);

      p_sc.GetPlanInfo(Id, planInfo);
      if not planInfo.isOnPlan then continue;

      if IndexOf = -1 then continue;
      if not ChkLstBoxRsc.Checked[IndexOf] then continue;
      if (planInfo.endDate < DateFrom) or (planInfo.startDate > DateTo) then continue;

      New(ResDet);
      ResDet.ResCode := res.p_ResCode;
      ResDet.ResDesc := res.p_ResSDesc;
      ResDet.SubResCode := '';
      if Assigned(res) and res.p_isMultiRes and Assigned(p_sc.getExtLinkPtr(Id))
        and Assigned(TMqmPlanObj(p_sc.getExtLinkPtr(Id)).p_Father) then
      begin
        visResSub := TMqmVisibleRes(TMqmActArea(p_sc.getExtLinkPtr(Id)).p_Father);
        if Assigned(visResSub) then ResDet.SubResCode := IntToStr(visResSub.p_SubCode);
      end;
      ResDet.Downtime := False;
      ResDet.ID := Id;

      p_sc.GetFldValue(Id, CSC_SchedStart, Value, dataType);
      ResDet.SchedStart := VarToStr(Value);
      p_sc.GetFldValue(Id, CSC_ProgStart, Value, dataType);
      ResDet.ProgStart := VarToStr(Value);
      JobList.Add(ResDet);
    end;
  end;

  if JobList.Count <= 0 then
  begin
    Result := _('No jobs present on selected resources!');
    exit;
  end;
  ReportSettings.ShowResources := checkedResources <= 1;
  if reportType = 'Excel_Bucket' then
    Result := WriteBucketExcelFile(JobList, CapResList, checkedResources, ReportSettings)
  else if reportType = 'Excel_Bucket_for_non_excel' then
    Result := _('MS-Excel not installed!');

end;

//----------------------------------------------------------------------------//

Function GetNumberOfMachinesForGroup(id : TSchedID; ReportSettings : TSettings) : Integer;
var pos, j : Integer;
  ActBinGrid        : TBinDrawGrid;
  dataType          : CBinColValType;
  ActTab : TBinTabSheet;
  value : Variant;
  ColAttributes     : TBinColCurrent;
  FieldValue : String;
begin
  Result := 0;
  ActTab := FBin.GetActiveView;
  if not Assigned(ActTab) then exit;
  ActBinGrid := ActTab.GetBinGrid;

  for j := 0 to ReportSettings.GroupList.Count - 1 do
  begin
    pos := ActBinGrid.FindPosViaName(ReportSettings.GroupList[j]);
    ColAttributes := ActBinGrid.BinColumnSet[pos];

    //if ColAttributes.Visible then
    //begin
      p_sc.GetFldValue(Id, ColAttributes.Field, Value, dataType);
      FieldValue := VarToStr(Value);

     { if Result = '' then
        Result := FieldValue
      else
        Result := Result +','+ FieldValue;  }
    //end;
  end;

end;

Function GetGroupListofID(id : TSchedID; ReportSettings : TSettings) : String;
var pos, j : Integer;
  ActBinGrid        : TBinDrawGrid;
  dataType          : CBinColValType;
  ActTab : TBinTabSheet;
  value : Variant;
  ColAttributes     : TBinColCurrent;
  FieldValue : String;
begin
  Result := '';
  ActTab := FBin.GetActiveView;
  if not Assigned(ActTab) then exit;
  ActBinGrid := ActTab.GetBinGrid;

  for j := 0 to ReportSettings.GroupList.Count - 1 do
  begin
    pos := ActBinGrid.FindPosViaName(ReportSettings.GroupList[j]);
    ColAttributes := ActBinGrid.BinColumnSet[pos];

    //if ColAttributes.Visible then
    //begin
      p_sc.GetFldValue(Id, ColAttributes.Field, Value, dataType);
      FieldValue := VarToStr(Value);

      if Result = '' then
        Result := FieldValue
      else
        Result := Result +','+ FieldValue;
    //end;
  end;

end;

Procedure SetupIDofGroups(IDGrpList : TList);
var i : Integer;
begin
  for I := 0 to IDGrpList.Count -1  do
  begin
    if i = 0 then
      RTIDGRP(IDGrpList[i]).idGroup := 0
    else
    begin
      if RTIDGRP(IDGrpList[i - 1]).IDGrpList = RTIDGRP(IDGrpList[i]).IDGrpList then
        RTIDGRP(IDGrpList[i]).idGroup := RTIDGRP(IDGrpList[i - 1]).idGroup
      else
        RTIDGRP(IDGrpList[i]).idGroup := RTIDGRP(IDGrpList[i - 1]).idGroup + 1;

    end;
  end;

end;

function SortGroupAndRes(Item1: Pointer; Item2: Pointer): Integer;
var
line1 : RTIDGRP;
line2 : RTIDGRP;
begin
  line1 :=  RTIDGRP(Item1);
  line2 :=  RTIDGRP(Item2);

  if (line1.IDGrpList < line2.IDGrpList) then
    result := -1
  else if (line1.IDGrpList > line2.IDGrpList) then
    result := 1
  else
    result := 0;

end;

function WriteGroupBucketExcelFile(JobList, CapResList: TList; NumberOfResources: Integer; ReportSettings: TSettings): string;
var
  idgrp, Nextidgrp : RTIDGRP;
  pos,stepTypeIndex,StepGroupIndex,colNum,
  sumSchedExecTimeAll, sumSchedExecTimeKey1, sumSchedExecTimeKey2, sumSchedExecTimeKey3, sumSchedExecTimeKey4,  sumSchedExecTimePos,
  sumSetupTimeAll, sumSetupTimeKey1, sumSetupTimeKey2,sumSetupTimeKey3, sumSetupTimeKey4, sumSetupTimePos,
  sumQtyToSchedAll, sumQtyToSchedKey1, sumQtyToSchedKey2, sumQtyToSchedKey3, sumQtyToSchedKey4, sumQtyToSchedPos,
  sumProgQty,Row,Column, savedColumNum,
  i, j, b, K,VisColInBin       : Integer;
  sumSchedExecTimeVis, sumSetupTimeVis, sumQtyToSchedVis : boolean;
  bucket_date_from,notUsed           : double;
  ActBinGrid        : TBinDrawGrid;
  ActTab            : TBinTabSheet;
  ColAttributes     : TBinColCurrent;
  FieldValue        : String;
  ResDet            : PTResourceDet;
  id, NextID        : TSchedId;
  dataType          : CBinColValType;
  Value,PreviousRsc,BinData  : Variant;
  TextColumn        : Integer;
  ColumnType        : array [0..100] of Integer; //0 = text 1 = decimal
  SumArray, SumArrayKey1, SumArrayKey2, SumArrayKey3, SumArrayKey4 : array of double;
  SplitCriteria     : Array [0..3] of string;
  status            : TRecordStatus;
  FromDateTime, ToDateTime : double;
  TotalQuantityForJob : double;
  QuantityForJob, SumQuantityForJob : double;
  BucketType : string;
  Cal      : TPGCALObj;
  ActArea  : TMqmActArea;
  TimeOfFamilyBeforeId : double;
  DatesInfo : TSQStartEndInfo;
begin
  Result := _('Could not create MS-Excel sheet!');
  TextColumn := -1;
  sumSchedExecTimeAll  := 0;
  sumSchedExecTimeKey1 := 0;
  sumSchedExecTimeKey2 := 0;
  sumSchedExecTimeKey3 := 0;
  sumSchedExecTimeKey4 := 0;
  sumSetupTimeAll      := 0;
  sumSetupTimeKey1     := 0;
  sumSetupTimeKey2     := 0;
  sumSetupTimeKey3     := 0;
  sumSetupTimeKey4     := 0;
  sumQtyToSchedAll     := 0;
  sumQtyToSchedKey1    := 0;
  sumQtyToSchedKey2    := 0;
  sumQtyToSchedKey3    := 0;
  sumQtyToSchedKey4    := 0;
  sumQtyToSchedPos     := 0;
  sumSetupTimePos      := 0;
  sumSchedExecTimePos  := 0;
  sumProgQty         := 0;
  stepTypeIndex      := -1;
  StepGroupIndex     := -1;
  colNum             := 1;
  Row                := 2;
  PreviousRsc        := '';
  VisColInBin        := 0;
  savedColumNum      := 0;
  sumSchedExecTimeVis := false;
  sumSetupTimeVis     := false;
  sumQtyToSchedVis    := false;
  SumQuantityForJob  := 0;

//  SplitCriteria[0] := 'xxxxxxxxxxxxxxxxxxxx';
  for k := 0 to 3 do
    SplitCriteria[k] := 'xxxxxxxxxxxxxxxxxxxx';

  try
    SetLength(SumArray, ReportSettings.BucketNumber);
    for b := Low(SumArray) to High(SumArray) do
      SumArray[b] := 0;

    SetLength(SumArrayKey1, ReportSettings.BucketNumber);
    for b := Low(SumArrayKey1) to High(SumArrayKey1) do
      SumArrayKey1[b] := 0;

    SetLength(SumArrayKey2, ReportSettings.BucketNumber);
    for b := Low(SumArrayKey2) to High(SumArrayKey2) do
      SumArrayKey2[b] := 0;

    SetLength(SumArrayKey3, ReportSettings.BucketNumber);
    for b := Low(SumArrayKey3) to High(SumArrayKey3) do
      SumArrayKey3[b] := 0;

    SetLength(SumArrayKey4, ReportSettings.BucketNumber);
    for b := Low(SumArrayKey4) to High(SumArrayKey4) do
      SumArrayKey4[b] := 0;

    ActTab := FBin.GetActiveView;
    if not Assigned(ActTab) then exit;
    ActBinGrid := ActTab.GetBinGrid;

    if not assigned(ActBinGrid) then
    begin
      Result := _('You cannot select Warp bin for bucket report!');
      exit;
    end;

    VisColInBin := ReportSettings.GroupList.Count;

    if ReportSettings.BucketContent <> 2 then
      BinData := VarArrayCreate([1,(JobList.Count * 7), 1, VisColInBin  + (2 + ReportSettings.BucketNumber ) ]
        , varVariant)
    else
      BinData := VarArrayCreate([1,(JobList.Count * 7), 1, VisColInBin  + (2 + ReportSettings.BucketNumber )*2 ]
        , varVariant);

    // Write title bucket
    BucketType := '';
    if ReportSettings.BucketSize = 30 then
      BucketType := _('Monthly')
    else if ReportSettings.BucketSize = 7 then
      BucketType := _('Weekly')
    else if ReportSettings.BucketSize = 1 then
      BucketType := _('Daily');

    var Content := '';
    if ReportSettings.BucketContent = 0 then
      Content := _('Content: Quantity')
    else if ReportSettings.BucketContent = 1 then
      Content := _('Content: Number of Machines')
    else if ReportSettings.BucketContent = 2 then
      Content := _('Content: Quantity and Number of Machines');

    BinData[1, ColNum] := _('                  Group Bucket report') + '  ' + _('from') + ' : ' + DateTimeToStr(ReportSettings.Report_Date_From) +
                          ' / ' + BucketType  + ' / ' + IntToStr(ReportSettings.BucketNumber) + ' ' + _('buckets')
                          + ' / ' + Content;


    //Loop over the column headers
    for i := 0 to ReportSettings.GroupList.Count - 1 do
    begin
      BinData[2, ColNum] := _(ReportSettings.GroupList[i]);
      Inc(colNum);
    end;

    Dec(ColNum);
    //Add Column header for the Buckets
    for i := 1 to ReportSettings.BucketNumber do
    begin
      CalculateBucketRange(i, bucket_date_from, notUsed, ReportSettings.Report_Date_From, ReportSettings.BucketSize);

      //BinData[2, ColNum] := '';

      if ReportSettings.BucketContent <> 2 then
      begin

        Inc(ColNum);
        if ReportSettings.BucketSize = 1 then
          BinData[2, ColNum] := ' ' + DateTimeToStr(bucket_date_from)
        else if ReportSettings.BucketSize = 7 then
          BinData[2, ColNum] := ' ' + DateTimeToStr(bucket_date_from)
        else if ReportSettings.BucketSize = 30 then
          BinData[2, ColNum] := ' ' + DateTimeToStr(bucket_date_from);
      end else
      begin
        if i = 1 then
          Inc(ColNum)
        else
          Inc(ColNum, 2);

        if ReportSettings.BucketSize = 1 then
        begin
          BinData[2, ColNum] := ' ' + DateTimeToStr(bucket_date_from);
          BinData[2, ColNum + 1] := ' ';
        end else if ReportSettings.BucketSize = 7 then
        begin
          BinData[2, ColNum] := ' ' + DateTimeToStr(bucket_date_from);
          BinData[2, ColNum + 1] := ' ';
        end else if ReportSettings.BucketSize = 30 then
        begin
          BinData[2, ColNum] := ' ' + DateTimeToStr(bucket_date_from);
          BinData[2, ColNum + 1] := ' ';
        end;
      end;
    end;

    var CurrentGroup := '';
    var IDGrpList := TList.Create;
    Var NewGroup := False;

    for i := 0 to JobList.Count - 1 do  //create grouplist
    begin
      ResDet := JobList.Items[i];
      id := TSchedId(ResDet.ID);

      if (id <> CSchedIdNull) then
        if ResDet.Downtime then
          continue;

      CurrentGroup := GetGroupListofID(id, ReportSettings);

      new(idgrp);
      idgrp.IDGrpList :=  CurrentGroup;
      idgrp.ID := id;

      IDGrpList.Add(idGrp);

    end;  //end group list
    CurrentGroup := '';
    IDGrpList.Sort(SortGroupAndRes);

    SetupIDofGroups(IDGrpList);

    var GrandTotal := 0;
    NextID := -1;
    var NextGL := '';
    Inc(Row);
    var NumberOfRes := TStringList.Create;
    var GroupRes := TStringList.Create;
    var TotalRes := TStringList.Create;
    GroupRes.Duplicates := dupIgnore;
    TotalRes.Duplicates := dupIgnore;
    var x := 0;

    for i := 0 to IDGrpList.Count - 1 do  //WAS JOBLIST
    begin
      status := REC_OK;
      Column := 0;

      idgrp := IDGrpList.Items[i];
      id := TSchedId(idgrp.ID);

      if IDGrpList.count > i + 1 then
      begin
        Nextidgrp := IDGrpList.Items[i + 1];
        NextID := TSchedId(Nextidgrp.ID);
      end;

      var GL := GetGroupListofID(id, ReportSettings);

      if NextID <> CSchedIdNull then
      begin
        NextGL := GetGroupListofID(NextID, ReportSettings);

        if GL <> NextGL  then
          NewGroup := True;

      end;

      NextGL := '';

      //loop over all columns of row in bin
      for j := 0 to ReportSettings.GroupList.Count - 1 do
      begin

        pos := ActBinGrid.FindPosViaName(ReportSettings.GroupList[j]);
        ColAttributes := ActBinGrid.BinColumnSet[pos];

        if ColAttributes.Field = CSC_MsgFromHost then continue;

        inc(Column);


        p_sc.GetFldValue(Id, ColAttributes.Field, Value, dataType);
        FieldValue := VarToStr(Value);

        if Trim(FieldValue) = '' then FieldValue := '----';

        if ((ColAttributes.Field = CSC_ExeTime) or
          (ColAttributes.Field = CSC_PlanSetup) or
          (ColAttributes.Field = CSC_ExeTimeSched) or
          (ColAttributes.Field = CSC_SupTimeSched)) then
          begin
            if ColAttributes.Field = CSC_ExeTimeSched then
            begin
              sumSchedExecTimeVis := true;
              sumSchedExecTimeAll :=  sumSchedExecTimeAll +  Value;
              sumSchedExecTimeKey1 := sumSchedExecTimeKey1 + Value;
              sumSchedExecTimeKey2 := sumSchedExecTimeKey2 + Value;
              sumSchedExecTimeKey3 := sumSchedExecTimeKey3 + Value;
              sumSchedExecTimeKey4 := sumSchedExecTimeKey4 + Value;
              sumSchedExecTimePos := Column;
            end else
            if ColAttributes.Field = CSC_SupTimeSched then
            begin
              sumSetupTimeVis := true;
              sumSetupTimeAll := sumSetupTimeAll + Value;
              sumSetupTimeKey1 := sumSetupTimeKey1 + Value;
              sumSetupTimeKey2 := sumSetupTimeKey2 + Value;
              sumSetupTimeKey3 := sumSetupTimeKey3 + Value;
              sumSetupTimeKey4 := sumSetupTimeKey4 + Value;
              sumSetupTimePos := Column;
            end;

            FieldValue := p_sc.GetFldDescr(id, ColAttributes.Field, true);
            BinData[Row, Column] := FieldValue;
            continue;
          end;
          if ColAttributes.Field = CSC_Rsc then
          begin
           // TextColumn := Column;
           // FieldValue := ResDet.ResCode; // avi 18.03.21 instead of the 2 lines below
           // if ResDet.SubResCode = '' then FieldValue := ResDet.ResCode
           // else FieldValue := ResDet.ResCode + SUBRESSEPARATOR + ResDet.SubResCode
          end else
          if ColAttributes.Field = CSC_QtyToSched then
          begin
            sumQtyToSchedVis := true;
            sumQtyToSchedAll := sumQtyToSchedAll + Value;
            sumQtyToSchedKey1 := sumQtyToSchedKey1 + Value;
            sumQtyToSchedKey2 := sumQtyToSchedKey2 + Value;
            sumQtyToSchedKey3 := sumQtyToSchedKey3 + Value;
            sumQtyToSchedKey4 := sumQtyToSchedKey4 + Value;
            sumQtyToSchedPos := Column;
          end else
          if ColAttributes.Field = CSC_ProgQty then
            sumProgQty := sumProgQty + Value;

          if (dataType <> CBT_integer) and (dataType <> CBT_float) then
          begin
            if ((stepGroupIndex = j) and (FieldValue = IntToStr(-1))) then
              FieldValue := '----';
          end;

          if stepTypeIndex = j then
          begin
            case StrToInt(FieldValue) of
              1: FieldValue := _('Batch');
              2: FieldValue := _('Continuous');
            end;
            dataType := CBT_string;
          end;

          if (dataType = CBT_float) or (dataType = CBT_integer) then
          begin
            if not IsNumeric(FieldValue, 'f') then
            begin
              BinData[Row, Column] := FieldValue;
              continue;
            end;
            if (dataType = CBT_float) then
            begin
              ColumnType[Column]  := 1;
              BinData[Row, Column] := FloatToStr(RoundDblToDbl(Value, 3));//FloatValue;
              continue;
            end
            else if (dataType = CBT_integer) then
            begin
              BinData[Row, Column] := IntToStr(value);
              continue;
            end;
          end
          else
          if (dataType = CBT_date) then
          begin
            try
              BinData[Row, Column] := StrToDateTime(FieldValue);
            except
              BinData[Row, Column] := FieldValue;
            end;
          end
          else
            BinData[Row, Column] := FieldValue;
        //end;
      end;

    // Add all buckets quantity
      TotalQuantityForJob := 0;
      Column := VisColInBin;
      savedColumNum := Column;

      var QtyCol := 0;

      for b := 1 to ReportSettings.BucketNumber do
      begin

        if (id = CSchedIdNull) then break;

        CalculateBucketRange(b,FromDateTime,ToDateTime,ReportSettings.Report_Date_From,ReportSettings.BucketSize);

        ActArea := p_sc.GetExtLinkPtr(id);
        if not Assigned(ActArea) then
          TimeOfFamilyBeforeId := 0
        else
        begin
          Cal := ActArea.GetCalendar;
          p_sc.GetStartInfo(id, DatesInfo);
          TimeOfFamilyBeforeId := ActArea.GetDurationOfAllJobsBeforeThisSpot(DatesInfo.StartDate, id);
        end;

        QuantityForJob := CalculateJobQuantityInBucket(id, FromDateTime, ToDateTime, ReportSettings.RoundLevel, TimeOfFamilyBeforeId);

        if ReportSettings.BucketContent = 0 then  //show only qty
        begin
          BinData[Row, (Column + b)] := BinData[Row, (Column + b)] + RoundTo(QuantityForJob, ReportSettings.RoundLevel);

          if QuantityForJob > 0 then
            SumArray[b-1] := SumArray[b-1] + RoundTo(QuantityForJob, ReportSettings.RoundLevel);

         { SumArrayKey1[b-1] := SumArrayKey1[b-1] + BinData[Row, (Column + 1 + b)];
          SumArrayKey2[b-1] := SumArrayKey2[b-1] + BinData[Row, (Column + 1 + b)];
          SumArrayKey3[b-1] := SumArrayKey3[b-1] + BinData[Row, (Column + 1 + b)];
          SumArrayKey4[b-1] := SumArrayKey4[b-1] + BinData[Row, (Column + 1 + b)];  }

        end
        else if ReportSettings.BucketContent = 1 then  //show only num of res
        begin

          if QuantityForJob > 0 then
          begin
            p_sc.GetFldValue(Id, CSC_Rsc, Value, dataType);

            if GroupRes.IndexOf(IntToStr(b) +'-'+ Value) = -1 then
            begin
              GroupRes.Add(IntToStr(b) +'-'+ Value);
              BinData[Row, (Column  + b)] :=  BinData[Row, (Column + b)] + 1;
            end;

            if TotalRes.IndexOf(IntToStr(b) +'-'+ Value) = -1 then
            begin
              TotalRes.Add(IntToStr(b) +'-'+ Value);
              SumArray[b-1] := SumArray[b-1] + 1;
            end;

          end
          else if BinData[Row, (Column  + b)] = 0 then  //just to show 0
            BinData[Row, (Column + b)] := 0;

        end else if ReportSettings.BucketContent = 2 then //show both
        begin
           p_sc.GetFldValue(Id, CSC_Rsc, Value, dataType);

          if b = 1  then
            QtyCol := 0
          else
            Inc(QtyCol);

          BinData[Row, (Column + b + QtyCol)] := BinData[Row, (Column + b + QtyCol)] + RoundTo(QuantityForJob, ReportSettings.RoundLevel);

          if QuantityForJob > 0 then
          begin
            SumArray[b-1] := SumArray[b-1] + RoundTo(QuantityForJob, ReportSettings.RoundLevel);

            if GroupRes.IndexOf(IntToStr(b) +'-'+ Value) = -1 then
            begin
              GroupRes.Add(IntToStr(b) +'-'+ Value);
              BinData[Row, (Column + b + QtyCol + 1)] :=  BinData[Row, (Column + b + QtyCol + 1)] + 1;
            end;

            //total for num of res

            if TotalRes.IndexOf(IntToStr(b) +'-'+ Value) = -1 then
            begin
              TotalRes.Add(IntToStr(b) +'-'+ Value);
              SumArrayKey1[b-1] := SumArrayKey1[b-1] + 1;

            end;

          end else if BinData[Row, (Column + b + QtyCol + 1)] = 0 then  //just to show 0
            BinData[Row, (Column + b + QtyCol + 1)] := 0;

        end;

      end;

      if NewGroup then
      begin
        Inc(Row);
        NewGroup := False;
        GroupRes.Clear;
      end;


    end; //end joblist

    ////TOTAL
    BinData[Row + 1, 1] := _('Total');
    var QtyCol := 0;

    for b := 1 to ReportSettings.BucketNumber do
    begin
      if ReportSettings.BucketContent = 2 then
      begin
        if b = 1  then
          QtyCol := 0
        else
          Inc(QtyCol);

        BinData[Row + 1, (savedColumNum + b + QtyCol)] := SumArray[b-1]; //total qty
        BinData[Row + 1, (savedColumNum + b + QtyCol) + 1] := SumArrayKey1[b-1];  //total num of res

      end else
      begin
        BinData[Row + 1, (savedColumNum + b)] := SumArray[b-1]; //total
      end;
    end;

    //new preview form
    {FBinRep := TFBinRep.CreateReport(nil, BinData);
    FBinRep.ShowModal;
    FBinRep.Free;
    Result := _('');}

    if ReportSettings.ReportType = 'Excel_Group_Bucket_for_non_excel' then
      Result := CreateExcel(BinData, ReportSettings.SaveFileLocation)
    else
      Result := CreateExcelSheet(BinData, ColumnType, ReportSettings.SaveFileLocation,
        ReportSettings.SheetName, ReportSettings.ShowExcel,TextColumn);

    NumberOfRes.Free;
    TotalRes.Clear;
    GroupRes.Clear;

    for x := IDGrpList.Count -1 to 0  do
        Dispose(RTIdGrp(IDGrpList.Items[x]));

    IDGrpList.Free;
    GroupRes.Free;
    TotalRes.Free;
  except
    on e:Exception do MessageDlg('UMReportExport - WriteGroupBucketExcelFile'+#13'Message: '+e.Message,mtError, [mbOK],0);
  end;

end;

function WriteBucketExcelFile(JobList, CapResList: TList; NumberOfResources: Integer; ReportSettings: TSettings): string;
var
  pos,
  stepTypeIndex,
  StepGroupIndex,
  colNum,
  position,
  sumSchedExecTimeAll, sumSchedExecTimeKey1, sumSchedExecTimeKey2, sumSchedExecTimeKey3, sumSchedExecTimeKey4,  sumSchedExecTimePos,
  sumSetupTimeAll, sumSetupTimeKey1, sumSetupTimeKey2,sumSetupTimeKey3, sumSetupTimeKey4, sumSetupTimePos,
  sumQtyToSchedAll, sumQtyToSchedKey1, sumQtyToSchedKey2, sumQtyToSchedKey3, sumQtyToSchedKey4, sumQtyToSchedPos,
  sumProgQty,
  Row,
  Column, savedColumNum,
  i, j, b, K,
  VisColInBin       : Integer;
  sumSchedExecTimeVis, sumSetupTimeVis, sumQtyToSchedVis : boolean;
  bucket_date_from,
  notUsed           : double;
  ActBinGrid        : TBinDrawGrid;
  ActTab            : TBinTabSheet;
  ColAttributes     : TBinColCurrent;
  Field,
  FieldValue        : String;
  ResDet            : PTResourceDet;
  id                : TSchedId;
  dataType          : CBinColValType;
  CapRes : TMQMCapRes;
  Value,
  PreviousRsc,
  BinData ,val          : Variant;
  pId:    TPropId;
  TextColumn,num        : Integer;
  ColumnType        : array [0..100] of Integer; //0 = text 1 = decimal
  SumArray, SumArrayKey1, SumArrayKey2, SumArrayKey3, SumArrayKey4 : array of double;
  SplitCriteria, SplitCriteriaCopy  : Array [0..3] of string;
  status             : TRecordStatus;
  tmpString          : string;
  hasEqualCriteria, hasEqualCriteriaLastLine : boolean;
  EqualCriteriaAll   : Array [0..3] of boolean;
  FromDateTime, ToDateTime : double;
  TotalQuantityForJob : double;
  QuantityForJob : double;
  SchedQty : Double;
  BucketType : string;
  Cal      : TPGCALObj;
  ActArea  : TMqmActArea;
  TimeOfFamilyBeforeId : double;
  DatesInfo : TSQStartEndInfo;
  //FBinRep: TFBinRep;
begin
  Result := _('Could not create MS-Excel sheet!');
  TextColumn := -1;
  sumSchedExecTimeAll  := 0;
  sumSchedExecTimeKey1 := 0;
  sumSchedExecTimeKey2 := 0;
  sumSchedExecTimeKey3 := 0;
  sumSchedExecTimeKey4 := 0;
  sumSetupTimeAll      := 0;
  sumSetupTimeKey1     := 0;
  sumSetupTimeKey2     := 0;
  sumSetupTimeKey3     := 0;
  sumSetupTimeKey4     := 0;
  sumQtyToSchedAll     := 0;
  sumQtyToSchedKey1    := 0;
  sumQtyToSchedKey2    := 0;
  sumQtyToSchedKey3    := 0;
  sumQtyToSchedKey4    := 0;
  sumQtyToSchedPos     := 0;
  sumSetupTimePos      := 0;
  sumSchedExecTimePos  := 0;
  sumProgQty         := 0;
  stepTypeIndex      := -1;
  StepGroupIndex     := -1;
  colNum             := 1;
  Row                := 2;
  PreviousRsc        := '';
  VisColInBin        := 0;
  savedColumNum      := 0;
  sumSchedExecTimeVis := false;
  sumSetupTimeVis     := false;
  sumQtyToSchedVis    := false;

//  SplitCriteria[0] := 'xxxxxxxxxxxxxxxxxxxx';
  for k := 0 to 3 do
    SplitCriteria[k] := 'xxxxxxxxxxxxxxxxxxxx';

  try

    SetLength(SumArray, ReportSettings.BucketNumber);
    for b := Low(SumArray) to High(SumArray) do
      SumArray[b] := 0;

    SetLength(SumArrayKey1, ReportSettings.BucketNumber);
    for b := Low(SumArrayKey1) to High(SumArrayKey1) do
      SumArrayKey1[b] := 0;

    SetLength(SumArrayKey2, ReportSettings.BucketNumber);
    for b := Low(SumArrayKey2) to High(SumArrayKey2) do
      SumArrayKey2[b] := 0;

    SetLength(SumArrayKey3, ReportSettings.BucketNumber);
    for b := Low(SumArrayKey3) to High(SumArrayKey3) do
      SumArrayKey3[b] := 0;

    SetLength(SumArrayKey4, ReportSettings.BucketNumber);
    for b := Low(SumArrayKey4) to High(SumArrayKey4) do
      SumArrayKey4[b] := 0;

    ActTab := FBin.GetActiveView;
    if not Assigned(ActTab) then exit;
    ActBinGrid := ActTab.GetBinGrid;

    if not assigned(ActBinGrid) then
    begin
      Result := _('You cannot select Warp bin for bucket report!');
      exit;
    end;

    for j := 0 to High(BinColDefault) - 1 do
    begin
      position := ActBinGrid.FindPos(j);
      ColAttributes := ActBinGrid.BinColumnSet[position];
      if ColAttributes.Visible and (ColAttributes.Field <> CSC_MsgFromHost) then VisColInBin := VisColInBin + 1;
    end;
    BinData := VarArrayCreate([1,(JobList.Count * 7),
      1, VisColInBin + (2 + ReportSettings.BucketNumber ) ], varVariant);

    // Write title bucket

    BucketType := '';
    if ReportSettings.BucketSize = 30 then
      BucketType := _('Monthly')
    else if ReportSettings.BucketSize = 7 then
      BucketType := _('Weekly')
    else if ReportSettings.BucketSize = 1 then
      BucketType := _('Daily')
    else if ReportSettings.BucketSize = -1 then
      BucketType := _('Hourly')
    else if ReportSettings.BucketSize = -2 then
      BucketType := _('Shift');

    BinData[1, ColNum] := _('                  Bucket report') + '  ' + _('from') + ' : ' + DateTimeToStr(ReportSettings.Report_Date_From) +
                          ' / ' + BucketType  + ' / ' + IntToStr(ReportSettings.BucketNumber) + ' ' + _('buckets');

    //Loop over the column headers
    for i := 0 to High(BinColDefault) - 1 do
    begin
      pos := ActBinGrid.FindPos(i);
      ColAttributes := ActBinGrid.BinColumnSet[pos];
      if ColAttributes.Field = CSC_MsgFromHost then continue;
      if ColAttributes.Visible then
      begin
        if ColAttributes.Field = CSC_StepType then stepTypeIndex := i;
        if ColAttributes.Field = CSC_ReprocNo then stepTypeIndex := i;
        if ColAttributes.Title = '' then Field := getPropertyDesc(pos, ActBinGrid)
        else Field := ColAttributes.Title;
        BinData[2, ColNum] := _(Field);
        colNum := colNum + 1;
      end;
    end;

    //Add Column header for the Buckets
    for i := 0 to ReportSettings.BucketNumber do
    begin
      if i = 0 then
      begin
        //BinData[1, ColNum] := _('Remainder');
        BinData[2, ColNum] := _('Planned minus buckets');
        continue;
      end;

      ColNum := ColNum + 1;

      if not ReportSettings.BucketByShift then
      begin
        CalculateBucketRange(i, bucket_date_from, notUsed, ReportSettings.Report_Date_From, ReportSettings.BucketSize);
        BinData[2, ColNum] := '';
        if ReportSettings.BucketSize = 1 then
          BinData[2, ColNum] := ' ' + DateTimeToStr(bucket_date_from);
        if ReportSettings.BucketSize = 7 then
          BinData[2, ColNum] := ' ' + DateTimeToStr(bucket_date_from);
        if ReportSettings.BucketSize = 30 then
          BinData[2, ColNum] := ' ' + DateTimeToStr(bucket_date_from);
        if ReportSettings.BucketSize = -1 then //1/24
          BinData[2, ColNum] := ' ' + DateTimeToStr(bucket_date_from);
      end
      else
      begin
        if High(ReportSettings.ShiftArray) > 0 then
          BinData[2, ColNum] := ' ' + DateTimeToStr(ReportSettings.ShiftArray[I -1].Date) + ' Shift ' + IntToStr(ReportSettings.ShiftArray[I -1].ShiftNumber);
      end;

    end;

    for i := 0 to JobList.Count - 1 do
    begin
      status := REC_OK;
      Column := 0;
      Row := Row + 1;
      ResDet := JobList.Items[i];
      id := TSchedId(ResDet.ID);
      if (id <> CSchedIdNull) then
      begin
        if ResDet.Downtime then
        begin
          Row := Row - 1;
          continue;
        end;
        // line breaks between resources
        {if (not ResDet.Downtime) then
        begin
          p_sc.GetFldValue(Id, CSC_Rsc, Value, dataType);
          if PreviousRsc <> Value then
          begin
            PreviousRsc := Value;
            BinData[Row, 1] := '';
            Row := Row + 1;
          end;
        end; }

        if ReportSettings.GroupingFields > 0 then
        begin

          hasEqualCriteria := true;
          if not ResDet.Downtime then
          begin
            for k := 0 to ReportSettings.GroupingFields - 1 do
            begin
              tmpString := p_sc.GetFldDescr(id, ActBinGrid.BinColumnSet[ActBinGrid.FindOrderPos(k)].Field, true);

              hasEqualCriteria := hasEqualCriteria and (SplitCriteria[k] = tmpString);
              EqualCriteriaAll[k] := not hasEqualCriteria;
              SplitCriteriaCopy[k] := SplitCriteria[k];
              hasEqualCriteriaLastLine := EqualCriteriaAll[k];

              if not hasEqualCriteria then SplitCriteria[k] := tmpString;
            end;
          end;
          if not hasEqualCriteria and (status = REC_OK) then status := REC_BREAK;


          if ReportSettings.GroupingFields > 0 then
          begin
            if SplitCriteriaCopy[0] <> p_sc.GetFldDescr(id, ActBinGrid.BinColumnSet[ActBinGrid.FindOrderPos(0)].Field, true) then
            begin
              SplitCriteria[0] := p_sc.GetFldDescr(id, ActBinGrid.BinColumnSet[ActBinGrid.FindOrderPos(0)].Field, true);
            end;
          end;

          if ReportSettings.GroupingFields > 1 then
          begin
            if SplitCriteriaCopy[1] <> p_sc.GetFldDescr(id, ActBinGrid.BinColumnSet[ActBinGrid.FindOrderPos(1)].Field, true) then
            begin
              SplitCriteria[1] := p_sc.GetFldDescr(id, ActBinGrid.BinColumnSet[ActBinGrid.FindOrderPos(1)].Field, true);
            end;
          end;

          if ReportSettings.GroupingFields > 2 then
          begin
            if SplitCriteriaCopy[2] <> p_sc.GetFldDescr(id, ActBinGrid.BinColumnSet[ActBinGrid.FindOrderPos(2)].Field, true) then
            begin
              SplitCriteria[2] := p_sc.GetFldDescr(id, ActBinGrid.BinColumnSet[ActBinGrid.FindOrderPos(2)].Field, true);
            end;
          end;

          if ReportSettings.GroupingFields > 3 then
          begin
            if SplitCriteriaCopy[3] <> p_sc.GetFldDescr(id, ActBinGrid.BinColumnSet[ActBinGrid.FindOrderPos(3)].Field, true) then
            begin
              SplitCriteria[3] := p_sc.GetFldDescr(id, ActBinGrid.BinColumnSet[ActBinGrid.FindOrderPos(3)].Field, true);
            end;
          end;

        end;

        if (I > 0) and EqualCriteriaAll[0] then
        begin

          if ReportSettings.GroupingFields = 4 then
          begin

            BinData[Row, 1] := SplitCriteriaCopy[0];
            BinData[Row, 2] := SplitCriteriaCopy[1];
            BinData[Row, 3] := SplitCriteriaCopy[2];
            BinData[Row, 4] := SplitCriteriaCopy[3];

            if sumQtyToSchedVis then
              BinData[Row, sumQtyToSchedPos] := sumQtyToSchedKey4;
            if sumSchedExecTimeVis then
              BinData[Row, sumSchedExecTimePos] := FormatDuration(sumSchedExecTimeKey4 , true);
            if sumSetupTimeVis then
              BinData[Row, sumSetupTimePos] := FormatDuration(sumSetupTimeKey4 , true);
            sumQtyToSchedKey4 := 0;
            sumSchedExecTimeKey4 := 0;
            sumSetupTimeKey4 := 0;

            for b := 1 to ReportSettings.BucketNumber do
               BinData[Row , (savedColumNum + 1 + b)] := SumArrayKey4[b-1];
            for b := 1 to ReportSettings.BucketNumber do
               SumArrayKey4[b-1] := 0;

            Row := Row + 1;

            BinData[Row, 1] := SplitCriteriaCopy[0];
            BinData[Row, 2] := SplitCriteriaCopy[1];
            BinData[Row, 3] := SplitCriteriaCopy[2];
            if sumQtyToSchedVis then
              BinData[Row, sumQtyToSchedPos] := sumQtyToSchedKey3;
            if sumSchedExecTimeVis then
              BinData[Row, sumSchedExecTimePos] := FormatDuration(sumSchedExecTimeKey3 , true);
            if sumSetupTimeVis then
              BinData[Row, sumSetupTimePos] := FormatDuration(sumSetupTimeKey3 , true);
            sumQtyToSchedKey3 := 0;
            sumSchedExecTimeKey3 := 0;
            sumSetupTimeKey3 := 0;

            for b := 1 to ReportSettings.BucketNumber do
               BinData[Row , (savedColumNum + 1 + b)] := SumArrayKey3[b-1];
            for b := 1 to ReportSettings.BucketNumber do
               SumArrayKey3[b-1] := 0;


            Row := Row + 1;

            BinData[Row, 1] := SplitCriteriaCopy[0];
            BinData[Row, 2] := SplitCriteriaCopy[1];

            if sumQtyToSchedVis then
              BinData[Row, sumQtyToSchedPos] := sumQtyToSchedKey2;
            if sumSchedExecTimeVis then
              BinData[Row, sumSchedExecTimePos] := FormatDuration(sumSchedExecTimeKey2 , true);
            if sumSetupTimeVis then
              BinData[Row, sumSetupTimePos] := FormatDuration(sumSetupTimeKey2 , true);
            sumQtyToSchedKey2 := 0;
            sumSchedExecTimeKey2 := 0;
            sumSetupTimeKey2 := 0;

            for b := 1 to ReportSettings.BucketNumber do
               BinData[Row , (savedColumNum + 1 + b)] := SumArrayKey2[b-1];
            for b := 1 to ReportSettings.BucketNumber do
               SumArrayKey2[b-1] := 0;

            Row := Row + 1;

            BinData[Row, 1] := SplitCriteriaCopy[0];

            if sumQtyToSchedVis then
              BinData[Row, sumQtyToSchedPos] := sumQtyToSchedKey1;
            if sumSchedExecTimeVis then
              BinData[Row, sumSchedExecTimePos] := FormatDuration(sumSchedExecTimeKey1 , true);
            if sumSetupTimeVis then
              BinData[Row, sumSetupTimePos] := FormatDuration(sumSetupTimeKey1 , true);
            sumQtyToSchedKey1 := 0;
            sumSchedExecTimeKey1 := 0;
            sumSetupTimeKey1 := 0;

            for b := 1 to ReportSettings.BucketNumber do
               BinData[Row , (savedColumNum + 1 + b)] := SumArrayKey1[b-1];
            for b := 1 to ReportSettings.BucketNumber do
               SumArrayKey1[b-1] := 0;

            Row := Row + 1;

          end

          else if ReportSettings.GroupingFields = 3 then
          begin

            BinData[Row, 1] := SplitCriteriaCopy[0];
            BinData[Row, 2] := SplitCriteriaCopy[1];
            BinData[Row, 3] := SplitCriteriaCopy[2];
            if sumQtyToSchedVis then
              BinData[Row, sumQtyToSchedPos] := sumQtyToSchedKey3;
            if sumSchedExecTimeVis then
              BinData[Row, sumSchedExecTimePos] := FormatDuration(sumSchedExecTimeKey3 , true);
            if sumSetupTimeVis then
              BinData[Row, sumSetupTimePos] := FormatDuration(sumSetupTimeKey3 , true);
            sumQtyToSchedKey3 := 0;
            sumSchedExecTimeKey3 := 0;
            sumSetupTimeKey3 := 0;

            for b := 1 to ReportSettings.BucketNumber do
               BinData[Row , (savedColumNum + 1 + b)] := SumArrayKey3[b-1];
            for b := 1 to ReportSettings.BucketNumber do
               SumArrayKey3[b-1] := 0;

            Row := Row + 1;

            BinData[Row, 1] := SplitCriteriaCopy[0];
            BinData[Row, 2] := SplitCriteriaCopy[1];

            if sumQtyToSchedVis then
              BinData[Row, sumQtyToSchedPos] := sumQtyToSchedKey2;
            if sumSchedExecTimeVis then
              BinData[Row, sumSchedExecTimePos] := FormatDuration(sumSchedExecTimeKey2 , true);
            if sumSetupTimeVis then
              BinData[Row, sumSetupTimePos] := FormatDuration(sumSetupTimeKey2 , true);
            sumQtyToSchedKey2 := 0;
            sumSchedExecTimeKey2 := 0;
            sumSetupTimeKey2 := 0;
            for b := 1 to ReportSettings.BucketNumber do
               BinData[Row , (savedColumNum + 1 + b)] := SumArrayKey2[b-1];
            for b := 1 to ReportSettings.BucketNumber do
               SumArrayKey2[b-1] := 0;
            Row := Row + 1;

            BinData[Row, 1] := SplitCriteriaCopy[0];

            if sumQtyToSchedVis then
              BinData[Row, sumQtyToSchedPos] := sumQtyToSchedKey1;
            if sumSchedExecTimeVis then
              BinData[Row, sumSchedExecTimePos] := FormatDuration(sumSchedExecTimeKey1 , true);
            if sumSetupTimeVis then
              BinData[Row, sumSetupTimePos] := FormatDuration(sumSetupTimeKey1 , true);
            sumQtyToSchedKey1 := 0;
            sumSchedExecTimeKey1 := 0;
            sumSetupTimeKey1 := 0;

            for b := 1 to ReportSettings.BucketNumber do
               BinData[Row , (savedColumNum + 1 + b)] := SumArrayKey1[b-1];
            for b := 1 to ReportSettings.BucketNumber do
               SumArrayKey1[b-1] := 0;

            Row := Row + 1;
          end;

          if ReportSettings.GroupingFields = 2 then
          begin

            BinData[Row, 1] := SplitCriteriaCopy[0];
            BinData[Row, 2] := SplitCriteriaCopy[1];

            if sumQtyToSchedVis then
              BinData[Row, sumQtyToSchedPos] := sumQtyToSchedKey2;
            if sumSchedExecTimeVis then
              BinData[Row, sumSchedExecTimePos] := FormatDuration(sumSchedExecTimeKey2 , true);
            if sumSetupTimeVis then
              BinData[Row, sumSetupTimePos] := FormatDuration(sumSetupTimeKey2 , true);
            sumQtyToSchedKey2 := 0;
            sumSchedExecTimeKey2 := 0;
            sumSetupTimeKey2 := 0;

            for b := 1 to ReportSettings.BucketNumber do
               BinData[Row , (savedColumNum + 1 + b)] := SumArrayKey2[b-1];
            for b := 1 to ReportSettings.BucketNumber do
               SumArrayKey2[b-1] := 0;
            Row := Row + 1;

            BinData[Row, 1] := SplitCriteriaCopy[0];

            if sumQtyToSchedVis then
              BinData[Row, sumQtyToSchedPos] := sumQtyToSchedKey1;
            if sumSchedExecTimeVis then
              BinData[Row, sumSchedExecTimePos] := FormatDuration(sumSchedExecTimeKey1 , true);
            if sumSetupTimeVis then
              BinData[Row, sumSetupTimePos] := FormatDuration(sumSetupTimeKey1 , true);
            sumQtyToSchedKey1 := 0;
            sumSchedExecTimeKey1 := 0;
            sumSetupTimeKey1 := 0;
            for b := 1 to ReportSettings.BucketNumber do
               BinData[Row , (savedColumNum + 1 + b)] := SumArrayKey1[b-1];
            for b := 1 to ReportSettings.BucketNumber do
               SumArrayKey1[b-1] := 0;

            Row := Row + 1;

          end

          else if ReportSettings.GroupingFields = 1 then
          begin
            BinData[Row, 1] := SplitCriteriaCopy[0];

            if sumQtyToSchedVis then
              BinData[Row, sumQtyToSchedPos] := sumQtyToSchedKey1;
            if sumSchedExecTimeVis then
              BinData[Row, sumSchedExecTimePos] := FormatDuration(sumSchedExecTimeKey1 , true);
            if sumSetupTimeVis then
              BinData[Row, sumSetupTimePos] := FormatDuration(sumSetupTimeKey1 , true);
            sumQtyToSchedKey1 := 0;
            sumSchedExecTimeKey1 := 0;
            sumSetupTimeKey1 := 0;
            for b := 1 to ReportSettings.BucketNumber do
               BinData[Row , (savedColumNum + 1 + b)] := SumArrayKey1[b-1];
            for b := 1 to ReportSettings.BucketNumber do
               SumArrayKey1[b-1] := 0;

            Row := Row + 1;
          end;

        end

        else if (I > 0) and EqualCriteriaAll[1] then
        begin

          if ReportSettings.GroupingFields = 4 then
          begin

            BinData[Row, 1] := SplitCriteriaCopy[0];
            BinData[Row, 2] := SplitCriteriaCopy[1];
            BinData[Row, 3] := SplitCriteriaCopy[2];
            BinData[Row, 4] := SplitCriteriaCopy[3];

            if sumQtyToSchedVis then
              BinData[Row, sumQtyToSchedPos] := sumQtyToSchedKey4;
            if sumSchedExecTimeVis then
              BinData[Row, sumSchedExecTimePos] := FormatDuration(sumSchedExecTimeKey4 , true);
            if sumSetupTimeVis then
              BinData[Row, sumSetupTimePos] := FormatDuration(sumSetupTimeKey4 , true);
            sumQtyToSchedKey4 := 0;
            sumSchedExecTimeKey4 := 0;
            sumSetupTimeKey4 := 0;
            for b := 1 to ReportSettings.BucketNumber do
               BinData[Row , (savedColumNum + 1 + b)] := SumArrayKey4[b-1];
            for b := 1 to ReportSettings.BucketNumber do
               SumArrayKey4[b-1] := 0;

            Row := Row + 1;

            BinData[Row, 1] := SplitCriteriaCopy[0];
            BinData[Row, 2] := SplitCriteriaCopy[1];
            BinData[Row, 3] := SplitCriteriaCopy[2];
            if sumQtyToSchedVis then
              BinData[Row, sumQtyToSchedPos] := sumQtyToSchedKey3;
            if sumSchedExecTimeVis then
              BinData[Row, sumSchedExecTimePos] := FormatDuration(sumSchedExecTimeKey3 , true);
            if sumSetupTimeVis then
              BinData[Row, sumSetupTimePos] := FormatDuration(sumSetupTimeKey3 , true);
            sumQtyToSchedKey3 := 0;
            sumSchedExecTimeKey3 := 0;
            sumSetupTimeKey3 := 0;
            for b := 1 to ReportSettings.BucketNumber do
               BinData[Row , (savedColumNum + 1 + b)] := SumArrayKey3[b-1];
            for b := 1 to ReportSettings.BucketNumber do
               SumArrayKey3[b-1] := 0;
            Row := Row + 1;

            BinData[Row, 1] := SplitCriteriaCopy[0];
            BinData[Row, 2] := SplitCriteriaCopy[1];

            if sumQtyToSchedVis then
              BinData[Row, sumQtyToSchedPos] := sumQtyToSchedKey2;
            if sumSchedExecTimeVis then
              BinData[Row, sumSchedExecTimePos] := FormatDuration(sumSchedExecTimeKey2 , true);
            if sumSetupTimeVis then
              BinData[Row, sumSetupTimePos] := FormatDuration(sumSetupTimeKey2 , true);
            sumQtyToSchedKey2 := 0;
            sumSchedExecTimeKey2 := 0;
            sumSetupTimeKey2 := 0;
            for b := 1 to ReportSettings.BucketNumber do
               BinData[Row , (savedColumNum + 1 + b)] := SumArrayKey2[b-1];
            for b := 1 to ReportSettings.BucketNumber do
               SumArrayKey2[b-1] := 0;
            Row := Row + 1;
          end

          else if ReportSettings.GroupingFields = 3 then
          begin

            BinData[Row, 1] := SplitCriteriaCopy[0];
            BinData[Row, 2] := SplitCriteriaCopy[1];
            BinData[Row, 3] := SplitCriteriaCopy[2];
            if sumQtyToSchedVis then
              BinData[Row, sumQtyToSchedPos] := sumQtyToSchedKey3;
            if sumSchedExecTimeVis then
              BinData[Row, sumSchedExecTimePos] := FormatDuration(sumSchedExecTimeKey3 , true);
            if sumSetupTimeVis then
              BinData[Row, sumSetupTimePos] := FormatDuration(sumSetupTimeKey3 , true);
            sumQtyToSchedKey3 := 0;
            sumSchedExecTimeKey3 := 0;
            sumSetupTimeKey3 := 0;
            for b := 1 to ReportSettings.BucketNumber do
               BinData[Row , (savedColumNum + 1 + b)] := SumArrayKey3[b-1];
            for b := 1 to ReportSettings.BucketNumber do
               SumArrayKey3[b-1] := 0;

            Row := Row + 1;

            BinData[Row, 1] := SplitCriteriaCopy[0];
            BinData[Row, 2] := SplitCriteriaCopy[1];

            if sumQtyToSchedVis then
              BinData[Row, sumQtyToSchedPos] := sumQtyToSchedKey2;
            if sumSchedExecTimeVis then
              BinData[Row, sumSchedExecTimePos] := FormatDuration(sumSchedExecTimeKey2 , true);
            if sumSetupTimeVis then
              BinData[Row, sumSetupTimePos] := FormatDuration(sumSetupTimeKey2 , true);
            sumQtyToSchedKey2 := 0;
            sumSchedExecTimeKey2 := 0;
            sumSetupTimeKey2 := 0;
            for b := 1 to ReportSettings.BucketNumber do
               BinData[Row , (savedColumNum + 1 + b)] := SumArrayKey2[b-1];
            for b := 1 to ReportSettings.BucketNumber do
               SumArrayKey2[b-1] := 0;

            Row := Row + 1;
          end;

          if ReportSettings.GroupingFields = 2 then
          begin

            BinData[Row, 1] := SplitCriteriaCopy[0];
            BinData[Row, 2] := SplitCriteriaCopy[1];

            if sumQtyToSchedVis then
              BinData[Row, sumQtyToSchedPos] := sumQtyToSchedKey2;
            if sumSchedExecTimeVis then
              BinData[Row, sumSchedExecTimePos] := FormatDuration(sumSchedExecTimeKey2 , true);
            if sumSetupTimeVis then
              BinData[Row, sumSetupTimePos] := FormatDuration(sumSetupTimeKey2 , true);
            sumQtyToSchedKey2 := 0;
            sumSchedExecTimeKey2 := 0;
            sumSetupTimeKey2 := 0;
            for b := 1 to ReportSettings.BucketNumber do
               BinData[Row , (savedColumNum + 1 + b)] := SumArrayKey2[b-1];
            for b := 1 to ReportSettings.BucketNumber do
               SumArrayKey2[b-1] := 0;

            Row := Row + 1;

          end

          else if ReportSettings.GroupingFields = 1 then
          begin

          end;


        end

        else if (I > 0) and EqualCriteriaAll[2] then
        begin

          if ReportSettings.GroupingFields = 4 then
          begin

            BinData[Row, 1] := SplitCriteriaCopy[0];
            BinData[Row, 2] := SplitCriteriaCopy[1];
            BinData[Row, 3] := SplitCriteriaCopy[2];
            BinData[Row, 4] := SplitCriteriaCopy[3];

            if sumQtyToSchedVis then
              BinData[Row, sumQtyToSchedPos] := sumQtyToSchedKey4;
            if sumSchedExecTimeVis then
              BinData[Row, sumSchedExecTimePos] := FormatDuration(sumSchedExecTimeKey4 , true);
            if sumSetupTimeVis then
              BinData[Row, sumSetupTimePos] := FormatDuration(sumSetupTimeKey4 , true);
            sumQtyToSchedKey4 := 0;
            sumSchedExecTimeKey4 := 0;
            sumSetupTimeKey4 := 0;
            for b := 1 to ReportSettings.BucketNumber do
               BinData[Row , (savedColumNum + 1 + b)] := SumArrayKey4[b-1];
            for b := 1 to ReportSettings.BucketNumber do
               SumArrayKey4[b-1] := 0;

            Row := Row + 1;

            BinData[Row, 1] := SplitCriteriaCopy[0];
            BinData[Row, 2] := SplitCriteriaCopy[1];
            BinData[Row, 3] := SplitCriteriaCopy[2];
            if sumQtyToSchedVis then
              BinData[Row, sumQtyToSchedPos] := sumQtyToSchedKey3;
            if sumSchedExecTimeVis then
              BinData[Row, sumSchedExecTimePos] := FormatDuration(sumSchedExecTimeKey3 , true);
            if sumSetupTimeVis then
              BinData[Row, sumSetupTimePos] := FormatDuration(sumSetupTimeKey3 , true);
            sumQtyToSchedKey3 := 0;
            sumSchedExecTimeKey3 := 0;
            sumSetupTimeKey3 := 0;
            for b := 1 to ReportSettings.BucketNumber do
               BinData[Row , (savedColumNum + 1 + b)] := SumArrayKey3[b-1];
            for b := 1 to ReportSettings.BucketNumber do
               SumArrayKey3[b-1] := 0;

            Row := Row + 1;

          end

          else if ReportSettings.GroupingFields = 3 then
          begin

            BinData[Row, 1] := SplitCriteriaCopy[0];
            BinData[Row, 2] := SplitCriteriaCopy[1];
            BinData[Row, 3] := SplitCriteriaCopy[2];
            if sumQtyToSchedVis then
              BinData[Row, sumQtyToSchedPos] := sumQtyToSchedKey3;
            if sumSchedExecTimeVis then
              BinData[Row, sumSchedExecTimePos] := FormatDuration(sumSchedExecTimeKey3 , true);
            if sumSetupTimeVis then
              BinData[Row, sumSetupTimePos] := FormatDuration(sumSetupTimeKey3 , true);
            sumQtyToSchedKey3 := 0;
            sumSchedExecTimeKey3 := 0;
            sumSetupTimeKey3 := 0;
            for b := 1 to ReportSettings.BucketNumber do
               BinData[Row , (savedColumNum + 1 + b)] := SumArrayKey3[b-1];
            for b := 1 to ReportSettings.BucketNumber do
               SumArrayKey3[b-1] := 0;

            Row := Row + 1;

          end;

          if ReportSettings.GroupingFields = 2 then
          begin

          end

          else if ReportSettings.GroupingFields = 1 then
          begin

          end;


        end

        else if (I > 0) and EqualCriteriaAll[3] then
        begin
          if ReportSettings.GroupingFields = 4 then
          begin

            BinData[Row, 1] := SplitCriteriaCopy[0];
            BinData[Row, 2] := SplitCriteriaCopy[1];
            BinData[Row, 3] := SplitCriteriaCopy[2];
            BinData[Row, 4] := SplitCriteriaCopy[3];

            if sumQtyToSchedVis then
              BinData[Row, sumQtyToSchedPos] := sumQtyToSchedKey4;
            if sumSchedExecTimeVis then
              BinData[Row, sumSchedExecTimePos] := FormatDuration(sumSchedExecTimeKey4 , true);
            if sumSetupTimeVis then
              BinData[Row, sumSetupTimePos] := FormatDuration(sumSetupTimeKey4 , true);
            sumQtyToSchedKey4 := 0;
            sumSchedExecTimeKey4 := 0;
            sumSetupTimeKey4 := 0;
            for b := 1 to ReportSettings.BucketNumber do
               BinData[Row , (savedColumNum + 1 + b)] := SumArrayKey4[b-1];
            for b := 1 to ReportSettings.BucketNumber do
               SumArrayKey4[b-1] := 0;

            Row := Row + 1;

          end

          else if ReportSettings.GroupingFields = 3 then
          begin

          end;

          if ReportSettings.GroupingFields = 2 then
          begin

          end

          else if ReportSettings.GroupingFields = 1 then
          begin

          end;

        end;

        //loop over all columns of row in bin
        for j := 0 to High(BinColDefault) - 1 do
        begin
          pos := ActBinGrid.FindPos(j);
          ColAttributes := ActBinGrid.BinColumnSet[pos];
          if ColAttributes.Field = CSC_MsgFromHost then continue;
          if ColAttributes.Visible then
          begin
            Column := Column + 1;
            p_sc.GetFldValue(Id, ColAttributes.Field, Value, dataType);
            FieldValue := VarToStr(Value);
            if Trim(FieldValue) = '' then FieldValue := '----';
            if ((ColAttributes.Field = CSC_ExeTime) or
              (ColAttributes.Field = CSC_PlanSetup) or
              (ColAttributes.Field = CSC_ExeTimeSched) or
              (ColAttributes.Field = CSC_SupTimeSched)) then
            begin
              if ColAttributes.Field = CSC_ExeTimeSched then
              begin
                sumSchedExecTimeVis := true;
                sumSchedExecTimeAll :=  sumSchedExecTimeAll +  Value;
                sumSchedExecTimeKey1 := sumSchedExecTimeKey1 + Value;
                sumSchedExecTimeKey2 := sumSchedExecTimeKey2 + Value;
                sumSchedExecTimeKey3 := sumSchedExecTimeKey3 + Value;
                sumSchedExecTimeKey4 := sumSchedExecTimeKey4 + Value;
                sumSchedExecTimePos := Column;
              end;
              if ColAttributes.Field = CSC_SupTimeSched then
              begin
                sumSetupTimeVis := true;
                sumSetupTimeAll := sumSetupTimeAll + Value;
                sumSetupTimeKey1 := sumSetupTimeKey1 + Value;
                sumSetupTimeKey2 := sumSetupTimeKey2 + Value;
                sumSetupTimeKey3 := sumSetupTimeKey3 + Value;
                sumSetupTimeKey4 := sumSetupTimeKey4 + Value;
                sumSetupTimePos := Column;
              end;
              FieldValue := p_sc.GetFldDescr(id, ColAttributes.Field, true);
              BinData[Row, Column] := FieldValue;
              continue;
            end;
            if ColAttributes.Field = CSC_Rsc then
            begin
              TextColumn := Column;
              FieldValue := ResDet.ResCode; // avi 18.03.21 instead of the 2 lines below
             // if ResDet.SubResCode = '' then FieldValue := ResDet.ResCode
             // else FieldValue := ResDet.ResCode + SUBRESSEPARATOR + ResDet.SubResCode
            end;
            if ColAttributes.Field = CSC_QtyToSched then
            begin
              sumQtyToSchedVis := true;
              sumQtyToSchedAll := sumQtyToSchedAll + Value;
              sumQtyToSchedKey1 := sumQtyToSchedKey1 + Value;
              sumQtyToSchedKey2 := sumQtyToSchedKey2 + Value;
              sumQtyToSchedKey3 := sumQtyToSchedKey3 + Value;
              sumQtyToSchedKey4 := sumQtyToSchedKey4 + Value;
              sumQtyToSchedPos := Column;
            end;

            if ColAttributes.Field = CSC_ProgQty then
              sumProgQty := sumProgQty + Value;
            if (dataType <> CBT_integer) and (dataType <> CBT_float) then
            begin
              if ((stepGroupIndex = j) and (FieldValue = IntToStr(-1))) then
                FieldValue := '----';
            end;
            if stepTypeIndex = j then
            begin
              case StrToInt(FieldValue) of
                1: FieldValue := _('Batch');
                2: FieldValue := _('Continuous');
              end;
              dataType := CBT_string;
            end;
            if (dataType = CBT_float) or (dataType = CBT_integer) then
            begin
              if not IsNumeric(FieldValue, 'f') then
              begin
                BinData[Row, Column] := FieldValue;
                continue;
              end;
              if (dataType = CBT_float) then
              begin
                ColumnType[Column]  := 1;
                BinData[Row, Column] := FloatToStr(RoundDblToDbl(Value, 3));//FloatValue;
                continue;
              end
              else if (dataType = CBT_integer) then
              begin
                BinData[Row, Column] := IntToStr(value);
                continue;
              end;
            end
            else if (dataType = CBT_date) then
            begin
              try
                BinData[Row, Column] := StrToDateTime(FieldValue);
              except
                BinData[Row, Column] := FieldValue;
              end;
            end
            else
              BinData[Row, Column] := FieldValue;
          end;
        end;
      end;

      // Example of 8 hours daily shift
      {Quantity - 6074
      Execusion - 4176

      Do in one minute 6074/4176 = 1.454501915708812 units

      8 - 20%, 8 40%, 8 - 60%, 8 - 80%   // curve percent

      1.   96 * 1.454501915708812 = 139.632183908046
      2.   192 * 1.454501915708812 = 279.264367816092
      3.   288 * 1.454501915708812 = 418.8965517241379
      4.   384 * 1.454501915708812 = 558.5287356321839

      Quantity up to now 1396.322735632184 - Remain to dop 4677.677264367816

      Do one unit in : 4176/6074 = 0.6875205795192624 minutes

      5.   4677.6 * 0.685264194289465 = 3215.994389199868

      Total minutes = 3216 + 480 + 480 + 480 + 480 = 5136 = 85 hours and 36 minutes. }


      // Add all buckets quantity and left quantity

      TotalQuantityForJob := 0;
      Column := VisColInBin;
      for b := 1 to ReportSettings.BucketNumber do
      begin
        savedColumNum := Column;
        if (id = CSchedIdNull) then break;

        if ReportSettings.BucketByShift then
        begin
          if (High(ReportSettings.ShiftArray) > 0) and (ReportSettings.BucketNumber > High(ReportSettings.ShiftArray)) then
          begin
            FromDateTime := ReportSettings.ShiftArray[b - 1].Date + ReportSettings.ShiftArray[b - 1].start/24/60;
            ToDateTime   := FromDateTime + ReportSettings.ShiftArray[b - 1].dur/24/60;
          end;
        end
        else
        begin
          CalculateBucketRange(b,FromDateTime,ToDateTime,ReportSettings.Report_Date_From,ReportSettings.BucketSize);
        end;

        ActArea := p_sc.GetExtLinkPtr(id);
        if not Assigned(ActArea) then
          TimeOfFamilyBeforeId := 0
        else
        begin
          Cal := ActArea.GetCalendar;
          p_sc.GetStartInfo(id, DatesInfo);
          TimeOfFamilyBeforeId := ActArea.GetDurationOfAllJobsBeforeThisSpot(DatesInfo.StartDate, id);
        end;

        QuantityForJob := CalculateJobQuantityInBucket(id, FromDateTime, ToDateTime, ReportSettings.RoundLevel, TimeOfFamilyBeforeId);
        TotalQuantityForJob := TotalQuantityForJob + QuantityForJob;
        BinData[Row, (Column + 1 + b)] := QuantityForJob;
        SumArray[b-1] := SumArray[b-1] + BinData[Row, (Column + 1 + b)];
        SumArrayKey1[b-1] := SumArrayKey1[b-1] + BinData[Row, (Column + 1 + b)];
        SumArrayKey2[b-1] := SumArrayKey2[b-1] + BinData[Row, (Column + 1 + b)];
        SumArrayKey3[b-1] := SumArrayKey3[b-1] + BinData[Row, (Column + 1 + b)];
        SumArrayKey4[b-1] := SumArrayKey4[b-1] + BinData[Row, (Column + 1 + b)];

      end;
      p_sc.GetFldValue(Id, CSC_QtyToSched, Value, dataType);
      SchedQty := Value;
      QuantityForJob := 0;
      if SchedQty > TotalQuantityForJob then QuantityForJob := SchedQty - TotalQuantityForJob;
      BinData[Row, (VisColInBin + 1)] := RoundTo(QuantityForJob, ReportSettings.RoundLevel);
    end;

    {if ReportSettings.GroupingFields > 0 then
    begin
      for G := 1 to ReportSettings.GroupingFields - 1 do
      begin
        Row := Row + 1;
        for k := 0 to ReportSettings.GroupingFields - G do
        begin
          BinData[Row, k + 1] := SplitCriteriaCopy[k];
        end;
      end;
      Row := Row + 1;
      BinData[Row, 1] := SplitCriteriaCopy[0];
    end;}

    // ONLY for the last JOB
///////////////////////////////////

    if ReportSettings.GroupingFields > 0 then
    begin
      Column := 0;
      Row := Row + 1;

      hasEqualCriteria := true;
      if not ResDet.Downtime then
      begin
        for k := 0 to ReportSettings.GroupingFields - 1 do
        begin
          //tmpString := p_sc.GetFldDescr(id, ActBinGrid.BinColumnSet[ActBinGrid.FindOrderPos(k)].Field, true);

          //hasEqualCriteria := hasEqualCriteria and (SplitCriteria[k] = tmpString);
          hasEqualCriteria := false;//hasEqualCriteria and (SplitCriteria[k] = tmpString);
          EqualCriteriaAll[k] := not hasEqualCriteria;


          SplitCriteriaCopy[k] := SplitCriteria[k];
          hasEqualCriteriaLastLine := EqualCriteriaAll[k];

          if not hasEqualCriteria then SplitCriteria[k] := tmpString;
        end;
      end;
      if not hasEqualCriteria and (status = REC_OK) then status := REC_BREAK;

      if ReportSettings.GroupingFields > 0 then
      begin
       // if SplitCriteriaCopy[0] <> p_sc.GetFldDescr(id, ActBinGrid.BinColumnSet[ActBinGrid.FindOrderPos(0)].Field, true) then
       // begin
          SplitCriteria[0] := p_sc.GetFldDescr(id, ActBinGrid.BinColumnSet[ActBinGrid.FindOrderPos(0)].Field, true);
       // end;
      end;

      if ReportSettings.GroupingFields > 1 then
      begin
       // if SplitCriteriaCopy[1] <> p_sc.GetFldDescr(id, ActBinGrid.BinColumnSet[ActBinGrid.FindOrderPos(1)].Field, true) then
       // begin
          SplitCriteria[1] := p_sc.GetFldDescr(id, ActBinGrid.BinColumnSet[ActBinGrid.FindOrderPos(1)].Field, true);
       // end;
      end;

      if ReportSettings.GroupingFields > 2 then
      begin
       // if SplitCriteriaCopy[2] <> p_sc.GetFldDescr(id, ActBinGrid.BinColumnSet[ActBinGrid.FindOrderPos(2)].Field, true) then
       // begin
          SplitCriteria[2] := p_sc.GetFldDescr(id, ActBinGrid.BinColumnSet[ActBinGrid.FindOrderPos(2)].Field, true);
       // end;
      end;

      if ReportSettings.GroupingFields > 3 then
      begin
       // if SplitCriteriaCopy[3] <> p_sc.GetFldDescr(id, ActBinGrid.BinColumnSet[ActBinGrid.FindOrderPos(3)].Field, true) then
       // begin
          SplitCriteria[3] := p_sc.GetFldDescr(id, ActBinGrid.BinColumnSet[ActBinGrid.FindOrderPos(3)].Field, true);
       // end;
      end;

    end;

    if (I > 0) and EqualCriteriaAll[0] then
    begin

      if ReportSettings.GroupingFields = 4 then
      begin

        BinData[Row, 1] := SplitCriteriaCopy[0];
        BinData[Row, 2] := SplitCriteriaCopy[1];
        BinData[Row, 3] := SplitCriteriaCopy[2];
        BinData[Row, 4] := SplitCriteriaCopy[3];

        if sumQtyToSchedVis then
          BinData[Row, sumQtyToSchedPos] := sumQtyToSchedKey4;
        if sumSchedExecTimeVis then
          BinData[Row, sumSchedExecTimePos] := FormatDuration(sumSchedExecTimeKey4 , true);
        if sumSetupTimeVis then
          BinData[Row, sumSetupTimePos] := FormatDuration(sumSetupTimeKey4 , true);
        sumQtyToSchedKey4 := 0;
        sumSchedExecTimeKey4 := 0;
        sumSetupTimeKey4 := 0;

        for b := 1 to ReportSettings.BucketNumber do
           BinData[Row , (savedColumNum + 1 + b)] := SumArrayKey4[b-1];
        for b := 1 to ReportSettings.BucketNumber do
           SumArrayKey4[b-1] := 0;

        Row := Row + 1;

        BinData[Row, 1] := SplitCriteriaCopy[0];
        BinData[Row, 2] := SplitCriteriaCopy[1];
        BinData[Row, 3] := SplitCriteriaCopy[2];
        if sumQtyToSchedVis then
          BinData[Row, sumQtyToSchedPos] := sumQtyToSchedKey3;
        if sumSchedExecTimeVis then
          BinData[Row, sumSchedExecTimePos] := FormatDuration(sumSchedExecTimeKey3 , true);
        if sumSetupTimeVis then
          BinData[Row, sumSetupTimePos] := FormatDuration(sumSetupTimeKey3 , true);
        sumQtyToSchedKey3 := 0;
        sumSchedExecTimeKey3 := 0;
        sumSetupTimeKey3 := 0;

        for b := 1 to ReportSettings.BucketNumber do
           BinData[Row , (savedColumNum + 1 + b)] := SumArrayKey3[b-1];
        for b := 1 to ReportSettings.BucketNumber do
           SumArrayKey3[b-1] := 0;


        Row := Row + 1;

        BinData[Row, 1] := SplitCriteriaCopy[0];
        BinData[Row, 2] := SplitCriteriaCopy[1];

        if sumQtyToSchedVis then
          BinData[Row, sumQtyToSchedPos] := sumQtyToSchedKey2;
        if sumSchedExecTimeVis then
          BinData[Row, sumSchedExecTimePos] := FormatDuration(sumSchedExecTimeKey2 , true);
        if sumSetupTimeVis then
          BinData[Row, sumSetupTimePos] := FormatDuration(sumSetupTimeKey2 , true);
        sumQtyToSchedKey2 := 0;
        sumSchedExecTimeKey2 := 0;
        sumSetupTimeKey2 := 0;

        for b := 1 to ReportSettings.BucketNumber do
           BinData[Row , (savedColumNum + 1 + b)] := SumArrayKey2[b-1];
        for b := 1 to ReportSettings.BucketNumber do
           SumArrayKey2[b-1] := 0;

        Row := Row + 1;

        BinData[Row, 1] := SplitCriteriaCopy[0];

        if sumQtyToSchedVis then
          BinData[Row, sumQtyToSchedPos] := sumQtyToSchedKey1;
        if sumSchedExecTimeVis then
          BinData[Row, sumSchedExecTimePos] := FormatDuration(sumSchedExecTimeKey1 , true);
        if sumSetupTimeVis then
          BinData[Row, sumSetupTimePos] := FormatDuration(sumSetupTimeKey1 , true);
        sumQtyToSchedKey1 := 0;
        sumSchedExecTimeKey1 := 0;
        sumSetupTimeKey1 := 0;

        for b := 1 to ReportSettings.BucketNumber do
           BinData[Row , (savedColumNum + 1 + b)] := SumArrayKey1[b-1];
        for b := 1 to ReportSettings.BucketNumber do
           SumArrayKey1[b-1] := 0;

      //  Row := Row + 1;

      end

      else if ReportSettings.GroupingFields = 3 then
      begin

        BinData[Row, 1] := SplitCriteriaCopy[0];
        BinData[Row, 2] := SplitCriteriaCopy[1];
        BinData[Row, 3] := SplitCriteriaCopy[2];
        if sumQtyToSchedVis then
          BinData[Row, sumQtyToSchedPos] := sumQtyToSchedKey3;
        if sumSchedExecTimeVis then
          BinData[Row, sumSchedExecTimePos] := FormatDuration(sumSchedExecTimeKey3 , true);
        if sumSetupTimeVis then
          BinData[Row, sumSetupTimePos] := FormatDuration(sumSetupTimeKey3 , true);
        sumQtyToSchedKey3 := 0;
        sumSchedExecTimeKey3 := 0;
        sumSetupTimeKey3 := 0;

        for b := 1 to ReportSettings.BucketNumber do
           BinData[Row , (savedColumNum + 1 + b)] := SumArrayKey3[b-1];
        for b := 1 to ReportSettings.BucketNumber do
           SumArrayKey3[b-1] := 0;

        Row := Row + 1;

        BinData[Row, 1] := SplitCriteriaCopy[0];
        BinData[Row, 2] := SplitCriteriaCopy[1];

        if sumQtyToSchedVis then
          BinData[Row, sumQtyToSchedPos] := sumQtyToSchedKey2;
        if sumSchedExecTimeVis then
          BinData[Row, sumSchedExecTimePos] := FormatDuration(sumSchedExecTimeKey2 , true);
        if sumSetupTimeVis then
          BinData[Row, sumSetupTimePos] := FormatDuration(sumSetupTimeKey2 , true);
        sumQtyToSchedKey2 := 0;
        sumSchedExecTimeKey2 := 0;
        sumSetupTimeKey2 := 0;
        for b := 1 to ReportSettings.BucketNumber do
           BinData[Row , (savedColumNum + 1 + b)] := SumArrayKey2[b-1];
        for b := 1 to ReportSettings.BucketNumber do
           SumArrayKey2[b-1] := 0;
        Row := Row + 1;

        BinData[Row, 1] := SplitCriteriaCopy[0];

        if sumQtyToSchedVis then
          BinData[Row, sumQtyToSchedPos] := sumQtyToSchedKey1;
        if sumSchedExecTimeVis then
          BinData[Row, sumSchedExecTimePos] := FormatDuration(sumSchedExecTimeKey1 , true);
        if sumSetupTimeVis then
          BinData[Row, sumSetupTimePos] := FormatDuration(sumSetupTimeKey1 , true);
        sumQtyToSchedKey1 := 0;
        sumSchedExecTimeKey1 := 0;
        sumSetupTimeKey1 := 0;

        for b := 1 to ReportSettings.BucketNumber do
           BinData[Row , (savedColumNum + 1 + b)] := SumArrayKey1[b-1];
        for b := 1 to ReportSettings.BucketNumber do
           SumArrayKey1[b-1] := 0;

      //  Row := Row + 1;
      end;

      if ReportSettings.GroupingFields = 2 then
      begin

        BinData[Row, 1] := SplitCriteriaCopy[0];
        BinData[Row, 2] := SplitCriteriaCopy[1];

        if sumQtyToSchedVis then
          BinData[Row, sumQtyToSchedPos] := sumQtyToSchedKey2;
        if sumSchedExecTimeVis then
          BinData[Row, sumSchedExecTimePos] := FormatDuration(sumSchedExecTimeKey2 , true);
        if sumSetupTimeVis then
          BinData[Row, sumSetupTimePos] := FormatDuration(sumSetupTimeKey2 , true);
        sumQtyToSchedKey2 := 0;
        sumSchedExecTimeKey2 := 0;
        sumSetupTimeKey2 := 0;

        for b := 1 to ReportSettings.BucketNumber do
           BinData[Row , (savedColumNum + 1 + b)] := SumArrayKey2[b-1];
        for b := 1 to ReportSettings.BucketNumber do
           SumArrayKey2[b-1] := 0;
        Row := Row + 1;

        BinData[Row, 1] := SplitCriteriaCopy[0];

        if sumQtyToSchedVis then
          BinData[Row, sumQtyToSchedPos] := sumQtyToSchedKey1;
        if sumSchedExecTimeVis then
          BinData[Row, sumSchedExecTimePos] := FormatDuration(sumSchedExecTimeKey1 , true);
        if sumSetupTimeVis then
          BinData[Row, sumSetupTimePos] := FormatDuration(sumSetupTimeKey1 , true);
        sumQtyToSchedKey1 := 0;
        sumSchedExecTimeKey1 := 0;
        sumSetupTimeKey1 := 0;
        for b := 1 to ReportSettings.BucketNumber do
           BinData[Row , (savedColumNum + 1 + b)] := SumArrayKey1[b-1];
        for b := 1 to ReportSettings.BucketNumber do
           SumArrayKey1[b-1] := 0;

      //  Row := Row + 1;

      end

      else if ReportSettings.GroupingFields = 1 then
      begin
        BinData[Row, 1] := SplitCriteriaCopy[0];

        if sumQtyToSchedVis then
          BinData[Row, sumQtyToSchedPos] := sumQtyToSchedKey1;
        if sumSchedExecTimeVis then
          BinData[Row, sumSchedExecTimePos] := FormatDuration(sumSchedExecTimeKey1 , true);
        if sumSetupTimeVis then
          BinData[Row, sumSetupTimePos] := FormatDuration(sumSetupTimeKey1 , true);
        sumQtyToSchedKey1 := 0;
        sumSchedExecTimeKey1 := 0;
        sumSetupTimeKey1 := 0;
        for b := 1 to ReportSettings.BucketNumber do
           BinData[Row , (savedColumNum + 1 + b)] := SumArrayKey1[b-1];
        for b := 1 to ReportSettings.BucketNumber do
           SumArrayKey1[b-1] := 0;

      //  Row := Row + 1;
      end;

    end

    else if (I > 0) and EqualCriteriaAll[1] then
    begin

      if ReportSettings.GroupingFields = 4 then
      begin

        BinData[Row, 1] := SplitCriteriaCopy[0];
        BinData[Row, 2] := SplitCriteriaCopy[1];
        BinData[Row, 3] := SplitCriteriaCopy[2];
        BinData[Row, 4] := SplitCriteriaCopy[3];

        if sumQtyToSchedVis then
          BinData[Row, sumQtyToSchedPos] := sumQtyToSchedKey4;
        if sumSchedExecTimeVis then
          BinData[Row, sumSchedExecTimePos] := FormatDuration(sumSchedExecTimeKey4 , true);
        if sumSetupTimeVis then
          BinData[Row, sumSetupTimePos] := FormatDuration(sumSetupTimeKey4 , true);
        sumQtyToSchedKey4 := 0;
        sumSchedExecTimeKey4 := 0;
        sumSetupTimeKey4 := 0;
        for b := 1 to ReportSettings.BucketNumber do
           BinData[Row , (savedColumNum + 1 + b)] := SumArrayKey4[b-1];
        for b := 1 to ReportSettings.BucketNumber do
           SumArrayKey4[b-1] := 0;

        Row := Row + 1;

        BinData[Row, 1] := SplitCriteriaCopy[0];
        BinData[Row, 2] := SplitCriteriaCopy[1];
        BinData[Row, 3] := SplitCriteriaCopy[2];
        if sumQtyToSchedVis then
          BinData[Row, sumQtyToSchedPos] := sumQtyToSchedKey3;
        if sumSchedExecTimeVis then
          BinData[Row, sumSchedExecTimePos] := FormatDuration(sumSchedExecTimeKey3 , true);
        if sumSetupTimeVis then
          BinData[Row, sumSetupTimePos] := FormatDuration(sumSetupTimeKey3 , true);
        sumQtyToSchedKey3 := 0;
        sumSchedExecTimeKey3 := 0;
        sumSetupTimeKey3 := 0;
        for b := 1 to ReportSettings.BucketNumber do
           BinData[Row , (savedColumNum + 1 + b)] := SumArrayKey3[b-1];
        for b := 1 to ReportSettings.BucketNumber do
           SumArrayKey3[b-1] := 0;
        Row := Row + 1;

        BinData[Row, 1] := SplitCriteriaCopy[0];
        BinData[Row, 2] := SplitCriteriaCopy[1];

        if sumQtyToSchedVis then
          BinData[Row, sumQtyToSchedPos] := sumQtyToSchedKey2;
        if sumSchedExecTimeVis then
          BinData[Row, sumSchedExecTimePos] := FormatDuration(sumSchedExecTimeKey2 , true);
        if sumSetupTimeVis then
          BinData[Row, sumSetupTimePos] := FormatDuration(sumSetupTimeKey2 , true);
        sumQtyToSchedKey2 := 0;
        sumSchedExecTimeKey2 := 0;
        sumSetupTimeKey2 := 0;
        for b := 1 to ReportSettings.BucketNumber do
           BinData[Row , (savedColumNum + 1 + b)] := SumArrayKey2[b-1];
        for b := 1 to ReportSettings.BucketNumber do
           SumArrayKey2[b-1] := 0;
      //  Row := Row + 1;
      end

      else if ReportSettings.GroupingFields = 3 then
      begin

        BinData[Row, 1] := SplitCriteriaCopy[0];
        BinData[Row, 2] := SplitCriteriaCopy[1];
        BinData[Row, 3] := SplitCriteriaCopy[2];
        if sumQtyToSchedVis then
          BinData[Row, sumQtyToSchedPos] := sumQtyToSchedKey3;
        if sumSchedExecTimeVis then
          BinData[Row, sumSchedExecTimePos] := FormatDuration(sumSchedExecTimeKey3 , true);
        if sumSetupTimeVis then
          BinData[Row, sumSetupTimePos] := FormatDuration(sumSetupTimeKey3 , true);
        sumQtyToSchedKey3 := 0;
        sumSchedExecTimeKey3 := 0;
        sumSetupTimeKey3 := 0;
        for b := 1 to ReportSettings.BucketNumber do
           BinData[Row , (savedColumNum + 1 + b)] := SumArrayKey3[b-1];
        for b := 1 to ReportSettings.BucketNumber do
           SumArrayKey3[b-1] := 0;

        Row := Row + 1;

        BinData[Row, 1] := SplitCriteriaCopy[0];
        BinData[Row, 2] := SplitCriteriaCopy[1];

        if sumQtyToSchedVis then
          BinData[Row, sumQtyToSchedPos] := sumQtyToSchedKey2;
        if sumSchedExecTimeVis then
          BinData[Row, sumSchedExecTimePos] := FormatDuration(sumSchedExecTimeKey2 , true);
        if sumSetupTimeVis then
          BinData[Row, sumSetupTimePos] := FormatDuration(sumSetupTimeKey2 , true);
        sumQtyToSchedKey2 := 0;
        sumSchedExecTimeKey2 := 0;
        sumSetupTimeKey2 := 0;
        for b := 1 to ReportSettings.BucketNumber do
           BinData[Row , (savedColumNum + 1 + b)] := SumArrayKey2[b-1];
        for b := 1 to ReportSettings.BucketNumber do
           SumArrayKey2[b-1] := 0;

      //  Row := Row + 1;
      end;

      if ReportSettings.GroupingFields = 2 then
      begin

        BinData[Row, 1] := SplitCriteriaCopy[0];
        BinData[Row, 2] := SplitCriteriaCopy[1];

        if sumQtyToSchedVis then
          BinData[Row, sumQtyToSchedPos] := sumQtyToSchedKey2;
        if sumSchedExecTimeVis then
          BinData[Row, sumSchedExecTimePos] := FormatDuration(sumSchedExecTimeKey2 , true);
        if sumSetupTimeVis then
          BinData[Row, sumSetupTimePos] := FormatDuration(sumSetupTimeKey2 , true);
        sumQtyToSchedKey2 := 0;
        sumSchedExecTimeKey2 := 0;
        sumSetupTimeKey2 := 0;
        for b := 1 to ReportSettings.BucketNumber do
           BinData[Row , (savedColumNum + 1 + b)] := SumArrayKey2[b-1];
        for b := 1 to ReportSettings.BucketNumber do
           SumArrayKey2[b-1] := 0;

      //  Row := Row + 1;

      end

      else if ReportSettings.GroupingFields = 1 then
      begin

      end;

    end

    else if (I > 0) and EqualCriteriaAll[2] then
    begin

      if ReportSettings.GroupingFields = 4 then
      begin

        BinData[Row, 1] := SplitCriteriaCopy[0];
        BinData[Row, 2] := SplitCriteriaCopy[1];
        BinData[Row, 3] := SplitCriteriaCopy[2];
        BinData[Row, 4] := SplitCriteriaCopy[3];

        if sumQtyToSchedVis then
          BinData[Row, sumQtyToSchedPos] := sumQtyToSchedKey4;
        if sumSchedExecTimeVis then
          BinData[Row, sumSchedExecTimePos] := FormatDuration(sumSchedExecTimeKey4 , true);
        if sumSetupTimeVis then
          BinData[Row, sumSetupTimePos] := FormatDuration(sumSetupTimeKey4 , true);
        sumQtyToSchedKey4 := 0;
        sumSchedExecTimeKey4 := 0;
        sumSetupTimeKey4 := 0;
        for b := 1 to ReportSettings.BucketNumber do
           BinData[Row , (savedColumNum + 1 + b)] := SumArrayKey4[b-1];
        for b := 1 to ReportSettings.BucketNumber do
           SumArrayKey4[b-1] := 0;

        Row := Row + 1;

        BinData[Row, 1] := SplitCriteriaCopy[0];
        BinData[Row, 2] := SplitCriteriaCopy[1];
        BinData[Row, 3] := SplitCriteriaCopy[2];
        if sumQtyToSchedVis then
          BinData[Row, sumQtyToSchedPos] := sumQtyToSchedKey3;
        if sumSchedExecTimeVis then
          BinData[Row, sumSchedExecTimePos] := FormatDuration(sumSchedExecTimeKey3 , true);
        if sumSetupTimeVis then
          BinData[Row, sumSetupTimePos] := FormatDuration(sumSetupTimeKey3 , true);
        sumQtyToSchedKey3 := 0;
        sumSchedExecTimeKey3 := 0;
        sumSetupTimeKey3 := 0;
        for b := 1 to ReportSettings.BucketNumber do
           BinData[Row , (savedColumNum + 1 + b)] := SumArrayKey3[b-1];
        for b := 1 to ReportSettings.BucketNumber do
           SumArrayKey3[b-1] := 0;

      //  Row := Row + 1;

      end

      else if ReportSettings.GroupingFields = 3 then
      begin

        BinData[Row, 1] := SplitCriteriaCopy[0];
        BinData[Row, 2] := SplitCriteriaCopy[1];
        BinData[Row, 3] := SplitCriteriaCopy[2];
        if sumQtyToSchedVis then
          BinData[Row, sumQtyToSchedPos] := sumQtyToSchedKey3;
        if sumSchedExecTimeVis then
          BinData[Row, sumSchedExecTimePos] := FormatDuration(sumSchedExecTimeKey3 , true);
        if sumSetupTimeVis then
          BinData[Row, sumSetupTimePos] := FormatDuration(sumSetupTimeKey3 , true);
        sumQtyToSchedKey3 := 0;
        sumSchedExecTimeKey3 := 0;
        sumSetupTimeKey3 := 0;
        for b := 1 to ReportSettings.BucketNumber do
           BinData[Row , (savedColumNum + 1 + b)] := SumArrayKey3[b-1];
        for b := 1 to ReportSettings.BucketNumber do
           SumArrayKey3[b-1] := 0;

      //  Row := Row + 1;

      end;

      if ReportSettings.GroupingFields = 2 then
      begin

      end

      else if ReportSettings.GroupingFields = 1 then
      begin

      end;
    end

    else if (I > 0) and EqualCriteriaAll[3] then
    begin
      if ReportSettings.GroupingFields = 4 then
      begin

        BinData[Row, 1] := SplitCriteriaCopy[0];
        BinData[Row, 2] := SplitCriteriaCopy[1];
        BinData[Row, 3] := SplitCriteriaCopy[2];
        BinData[Row, 4] := SplitCriteriaCopy[3];

        if sumQtyToSchedVis then
          BinData[Row, sumQtyToSchedPos] := sumQtyToSchedKey4;
        if sumSchedExecTimeVis then
          BinData[Row, sumSchedExecTimePos] := FormatDuration(sumSchedExecTimeKey4 , true);
        if sumSetupTimeVis then
          BinData[Row, sumSetupTimePos] := FormatDuration(sumSetupTimeKey4 , true);
        sumQtyToSchedKey4 := 0;
        sumSchedExecTimeKey4 := 0;
        sumSetupTimeKey4 := 0;
        for b := 1 to ReportSettings.BucketNumber do
           BinData[Row , (savedColumNum + 1 + b)] := SumArrayKey4[b-1];
        for b := 1 to ReportSettings.BucketNumber do
           SumArrayKey4[b-1] := 0;

      //  Row := Row + 1;

      end

      else if ReportSettings.GroupingFields = 3 then
      begin

      end;

      if ReportSettings.GroupingFields = 2 then
      begin

      end

      else if ReportSettings.GroupingFields = 1 then
      begin

      end;
    end;
/////////////////////////////////////  CAPACITY RES

     for k := 0 to CapResList.Count - 1 do
     begin

       //loop over all columns of row in bin
       Column := 0;
       CapRes := TMqmCapRes(CapResList[k]);
       Row := Row + 1;
          for j := 0 to High(BinColDefault) - 1 do
          begin
            pos := ActBinGrid.FindPos(j);
            ColAttributes := ActBinGrid.BinColumnSet[pos];
            if ColAttributes.Field = CSC_MsgFromHost then continue;

            if ColAttributes.Visible then
            begin
              Column := Column + 1;

              if (ColAttributes.Field = CSC_ProgStart) then
                BinData[Row, Column] := CapRes.p_Start
              else if (ColAttributes.Field = CSC_ProgEnd) then
                BinData[Row, Column] := CapRes.p_End
              else if (ColAttributes.Field = CSC_Rsc) then
                BinData[Row, Column] := TMqmRes(CapRes.p_Res).p_ResCode
              else if (ColAttributes.Field = CSC_Calendar) then
                BinData[Row, Column] := TMqmActArea(CapRes.p_Father).GetCalendar.GetKey;

              ///PROPERTIES
              num := -1;

              case ColAttributes.Field of
                  CSC_property1:   num := 0;
                  CSC_property2:   num := 1;
                  CSC_property3:   num := 2;
                  CSC_property4:   num := 3;
                  CSC_property5:   num := 4;
                  CSC_property6:   num := 5;
                  CSC_property7:   num := 6;
                  CSC_property8:   num := 7;
                  CSC_property9:   num := 8;
                  CSC_property10:  num := 9;
                  CSC_property11:  num := 10;
                  CSC_property12:  num := 11;
                  CSC_property13:  num := 12;
                  CSC_property14:  num := 13;
                  CSC_property15:  num := 14;
                  CSC_property16:  num := 15;
                  CSC_property17:  num := 16;
                  CSC_property18:  num := 17;
                  CSC_property19:  num := 18;
                  CSC_property20:  num := 19;
                  CSC_property21:  num := 20;
                  CSC_property22:  num := 21;
                  CSC_property23:  num := 22;
                  CSC_property24:  num := 23;
                  CSC_property25:  num := 24;
                  CSC_property26:  num := 25;
                  CSC_property27:  num := 26;
                  CSC_property28:  num := 27;
                  CSC_property29:  num := 28;
                  CSC_property30:  num := 29;
                  CSC_property31:  num := 30;
                  CSC_property32:  num := 31;
                  CSC_property33:  num := 32;
                  CSC_property34:  num := 33;
                  CSC_property35:  num := 34;
                  CSC_property36:  num := 35;
                  CSC_property37:  num := 36;
                  CSC_property38:  num := 37;
                  CSC_property39:  num := 38;
                  CSC_property40:  num := 39;
                  CSC_property41:  num := 40;
                  CSC_property42:  num := 41;
                  CSC_property43:  num := 42;
                  CSC_property44:  num := 43;
                  CSC_property45:  num := 44;
                  CSC_property46:  num := 45;
                  CSC_property47:  num := 46;
                  CSC_property48:  num := 47;
                  CSC_property49:  num := 48;
                  CSC_property50:  num := 49;
                  CSC_property51:  num := 50;
                  CSC_property52:  num := 51;
                  CSC_property53:  num := 52;
                  CSC_property54:  num := 53;
                  CSC_property55:  num := 54;
                  CSC_property56:  num := 55;
                  CSC_property57:  num := 56;
                  CSC_property58:  num := 57;
                  CSC_property59:  num := 58;
                  CSC_property60:  num := 59

              end;

              if num <> -1 then
              begin
                pId := DBAppGlobals.ShowBinPropArry[num];

                var  RscCode := TMqmRes(CapRes.p_Res).p_ResCode;
                var  PropCode := GetPropCodeFromID(pId);

                if capres.m_propList.GetValforProp(pId, val) then
                  BinData[Row, Column] := val;

                if pId <> nil then
                begin

                  if IsAssignedBooleanProp1(pId) then
                  begin
                    BinData[Row, Column] := '0';
                  end;

                  if IsPropDynamic(pId) then
                  begin
                    num := trunc(100*p_sc.GetPropDinamicVal(id,value));
                    BinData[Row, Column] := num/100;
                  end;
                end;
              end;

            end;

          end;
     end;

///////// TOTAL

    BinData[Row + 1, 1] := _('Total');

    if sumQtyToSchedVis then
      BinData[Row + 1, sumQtyToSchedPos] := sumQtyToSchedAll;
    if sumSchedExecTimeVis then
      BinData[Row + 1, sumSchedExecTimePos] := FormatDuration(sumSchedExecTimeAll , true);
    if sumSetupTimeVis then
      BinData[Row + 1, sumSetupTimePos] := FormatDuration(sumSetupTimeAll , true);

    for b := 1 to ReportSettings.BucketNumber do
      BinData[Row + 1, (savedColumNum + 1 + b)] := SumArray[b-1];


      //new preview form
   {   FBinRep := TFBinRep.CreateReport(nil, BinData);
    FBinRep.ShowModal;
    FBinRep.Free;
    Result := _('');}
    if ReportSettings.ReportType = 'Excel_Bucket_for_non_excel' then
      Result := CreateExcel(BinData, ReportSettings.SaveFileLocation)
    else
      Result := CreateExcelSheet(BinData, ColumnType, ReportSettings.SaveFileLocation,
        ReportSettings.SheetName, ReportSettings.ShowExcel,TextColumn);

  except
    on e:Exception do MessageDlg('UMReportExport - WriteBucketExcelFile'+#13'Message: '+e.Message,mtError, [mbOK],0);
  end;
end;

//----------------------------------------------------------------------------//
// COMPLETELY WORK OVER THIS FUNCTION!!!!!!!!!!!!!!! BUCKETS NOT REGARDED!!!!!!!
{function WriteBucketNonExcelFile(JobList: Tlist; showResource: boolean; ReportSettings: TSettings): boolean;
var
  i, j, pos,
  stepTypeIndex,
  StepGroupIndex,
  ColumnStart,
  ColumnEnd,
  ColumnComment,
  ColumnQtyToSched,
  ColumnExeTimeSched,
  ColumnSupTimeSched,
  ColumnProgQty,
  colNum,
  position,
  sumSchedExecTime,
  sumSetupTime,
  sumQtyToSched,
  sumProgQty         : Integer;
  ActBinGrid         : TBinDrawGrid;
  ActTab             : TBinTabSheet;
  ColAttributes      : TBinColCurrent;
  Field,
  FieldValue         : String;
  ResDet             : PTResourceDet;
  id                 : TSchedId;
  Value              : Variant;
  dataType           : CBinColValType;
  FloatValue         : double;
begin
  Result := false;
  ColumnStart        := 0;
  ColumnEnd          := 0;
  ColumnComment      := 0;
  ColumnQtyToSched   := 0;
  ColumnExeTimeSched := 0;
  ColumnSupTimeSched := 0;
  ColumnProgQty      := 0;
  sumSchedExecTime   := 0;
  sumSetupTime       := 0;
  sumQtyToSched      := 0;
  sumProgQty         := 0;
  colNum             := 0;

  ActTab := FBin.GetActiveView;
  if not Assigned(ActTab) then exit;
  ActBinGrid := ActTab.GetBinGrid;
  With ReportSettings.NativeExcel Do
  Begin
    stepTypeIndex  := -1;
    StepGroupIndex := -1;
    NewFile;
    FileName := ReportSettings.SaveFileLocation;
    AddFont(FMQMPlan.ExcelFontBold.Font);
    AddFont(FMQMPlan.ExcelFontHeader1.Font);
    AddFont(FMQMPlan.ExcelFontHeader2.Font);
    SetHeader('MQM - ' + _('Resource extraction'));
    SetFooter('&N &P');
    ActiveFont := 1;
    WriteLabel(1,6,_('Schedules list') + ' - ' + ActTab.Caption);
    ResDet := JobList.Items[0];
    ActiveFont := 2;

    //only for one resource
    if showResource then
    begin
      if ResDet.ResDesc <> '' then
        WriteLabel(3,6,_('Resource')+ ':  ' + ResDet.ResDesc );
      WriteLabel(4,6,_('From') + ': ' + DateTimeToStr(ReportSettings.DateFrom) + ' '+ _('To') +': '+ DateTimeToStr(ReportSettings.DateTo));
    end
    else
      WriteLabel(3,6,_('From') + ': ' + DateTimeToStr(ReportSettings.DateFrom) + '  ' + _('To') +': '+ DateTimeToStr(ReportSettings.DateTo));
    if showResource then Row := 6
    else Row := 5;
    Column := 1;
    shading := true;
    ActiveFont := 0;
    Alignment:= eaCenter;

    //Loop over the column headers
    for i := 0 to High(BinColDefault) - 1 do
    begin
      pos := ActBinGrid.FindPos(i);
      ColAttributes := ActBinGrid.BinColumnSet[pos];
      if ColAttributes.Field = CSC_MsgFromHost then continue;
      if ColAttributes.Visible then
      begin
        if ColAttributes.Title = '' then field := getPropertyDesc(pos,ActBinGrid)
        else field := ColAttributes.Title;
        WriteLabel(Row, Column, _(field));
        colNum := colNum + 1;
        //for Downtime entries
        if ColAttributes.Field = CSC_ProgStart then ColumnStart := colNum;
        if ColAttributes.Field = CSC_ProgEnd then ColumnEnd := colNum;
        if ColAttributes.Field = CSC_Comment then ColumnComment := colNum;
        //for summing columns
        if ColAttributes.Field = CSC_QtyToSched then ColumnQtyToSched := colNum;
        if ColAttributes.Field = CSC_ExeTimeSched then ColumnExeTimeSched := colNum;
        if ColAttributes.Field = CSC_SupTimeSched then ColumnSupTimeSched := colNum;
        if ColAttributes.Field = CSC_ProgQty then ColumnProgQty := colNum;
        //so that we can replace the number with text
        if ColAttributes.Field = CSC_StepType then stepTypeIndex := i;
        if ColAttributes.Field = CSC_ReprocNo then stepTypeIndex := i;
      end;
    end;
    shading := false;
    ActiveFont := 5;
    //Loop over all the rows of the bin
    for i := 0 to JobList.Count - 1 do
    begin
      Column := 1;
      Row := Row +1;
      ResDet := JobList.Items[i];
      id := TSchedId(ResDet.ID);
      if (id <> CSchedIdNull) or (ResDet.Downtime) then
      begin
        //loop over all columns of row in bin
        for j := 0 to High(BinColDefault) - 1 do
        begin
          pos := ActBinGrid.findpos(j);
          ColAttributes := ActbinGrid.BinColumnSet[pos];
          if  ColAttributes.Field = CSC_MsgFromHost then continue;
          if (ColAttributes.Visible and ResDet.Downtime) then
          begin
            WriteLabel(Row, 1, 'Downtime');
            if ColAttributes.Field = CSC_ProgStart then
              WriteLabel(Row,ColumnStart,ResDet.DownTimeFrom);
            if ColAttributes.Field = CSC_ProgEnd then
              WriteLabel(Row,ColumnEnd,ResDet.DownTimeTo);
            if ColAttributes.Field = CSC_Comment then
              WriteLabel(Row,ColumnComment,ResDet.Comment);
            continue;
          end;
          if ColAttributes.Visible then
          begin
            p_sc.GetFldValue(Id, ColAttributes.Field, Value, dataType);
            FieldValue := VarToStr(Value);
            if trim(FieldValue) = '' then FieldValue := '----';
            if ((ColAttributes.Field = CSC_ExeTime) or
              (ColAttributes.Field = CSC_PlanSetup) or
              (ColAttributes.Field = CSC_ExeTimeSched) or
              (ColAttributes.Field = CSC_SupTimeSched)) then
            begin
              if ColAttributes.Field = CSC_ExeTimeSched then
                sumSchedExecTime := sumSchedExecTime + Value;
              if ColAttributes.Field = CSC_SupTimeSched then
                sumSetupTime := sumSetupTime + Value;
              FieldValue := p_sc.GetFldDescr(id, ColAttributes.Field);
              WriteLabel(Row,Column,FieldValue);
              continue;
            end;
            if ColAttributes.Field = CSC_QtyToSched then sumQtyToSched := sumQtyToSched + Value;
            if ColAttributes.Field = CSC_ProgQty then sumProgQty := sumProgQty + Value;
            if (dataType <> CBT_integer) and (dataType <> CBT_float) then
            begin
              if ((stepGroupIndex = j) and (FieldValue = intToStr(-1))) then
                FieldValue := '----';
            end;
            if stepTypeIndex = j then
            begin
              case strToInt(FieldValue) of
                1: FieldValue := _('Batch');
                2: FieldValue := _('Continuous');
              end;
              dataType := CBT_string;
            end;
            if (dataType = CBT_float) or (dataType = CBT_integer) then
            begin
              if not IsNumeric(FieldValue, 'f') then
              begin
                WriteLabel(Row, Column, FieldValue);
                continue;
              end;
              FloatValue := StrToFloat(FieldValue);
              WriteNumber(Row, Column, FloatValue);
              continue;
            end;
            WriteLabel(Row, Column, FieldValue);
          end;
        end;
      end;
    end;

    //Print the sum rows
    Row := Row + 2;
    for i := 1 to colNum do
    begin
      if      i = 1                  then WriteLabel(Row,i,'Total')
      else if i = ColumnQtyToSched   then WriteNumber(Row,i,sumQtyToSched)
      else if i = ColumnExeTimeSched then WriteLabel(Row,i,FormatDuration(sumSchedExecTime, true))
      else if i = ColumnSupTimeSched then WriteLabel(Row,i,FormatDuration(sumSetupTime, true))
      else if i = ColumnProgQty      then WriteNumber(Row,i,sumProgQty)
    end;
    CloseFile;
    SaveToFile;
  end;
  Result := true;
end;
}

//----------------------------------------------------------------------------/
{ Calculates one bucket's time range for Bucket Report }
//----------------------------------------------------------------------------//

procedure CalculateBucketRange(BucketNo: Integer; var Bucket_date_from: Double;
  var Bucket_date_to: Double; Report_date_from, BucketSize: Double);
var
  BucketSizeFix, Current_bucket_size, Bucket_period, RealBucketSize: Double;
  Year, Month, Day : word;
  Report_date_fromTemp : Double;
  CallculatedDaysForMonthsPeriod : TDateTime;
  I : Integer;
begin
  try
    BucketSizeFix := 0;

    if ((BucketSize * 24) < 2) then
      BucketSizeFix := ((60 - MinuteOfTheHour(Report_date_from))/60)/24;

    if BucketSize = 1 then
      BucketSizeFix := DaySpan(Report_date_from, EndOfTheDay(Report_date_from));
    if BucketSize = 7 then
      BucketSizeFix := DaySpan(Report_date_from, EndOfTheWeek(Report_date_from));
    if BucketSize = 30 then
      BucketSizeFix := DaySpan(Report_date_from, EndOfTheMonth(Report_date_from));
    if BucketSize = -1 then //1/24
    begin
      BucketSizeFix := DaySpan(Report_date_from, Report_date_from + 1/24);
      //BucketSizeFix := DaySpan(Report_date_from, EndOfTheDay(Report_date_from));
      BucketSize := 1/24;
    end
    else if BucketSize = -2 then // handling shift ..
    begin

     // BucketSizeFix := DaySpan(Report_date_from, Report_date_from + 1/24);
      //BucketSizeFix := DaySpan(Report_date_from, EndOfTheDay(Report_date_from));
     // BucketSize := 1/24;
    end;

    if BucketSize = 30 then
    begin
      BucketSizeFix := IncMilliSecond(BucketSizeFix);
      if BucketNo = 1 then Current_bucket_size := BucketSizeFix
      else
      begin
        Report_date_fromTemp := Report_date_from;
        DecodeDate(Report_date_fromTemp,Year,Month,Day);
        CallculatedDaysForMonthsPeriod := EncodeDate(Year,Month,1);

        for I := 1 to BucketNo - 1 do
          CallculatedDaysForMonthsPeriod := Trunc(IncMonth(CallculatedDaysForMonthsPeriod));

        RealBucketSize := CallculatedDaysForMonthsPeriod - Report_date_from;

      end;

      if BucketNo = 1 then
      begin
        Bucket_date_from := Report_date_from;
        Bucket_date_to := EndOfTheMonth(Report_date_from) - 1/24/3600;
      end
      else
      begin
        Bucket_date_from := CallculatedDaysForMonthsPeriod;//Report_date_from + Trunc(Bucket_period) - RealBucketSize;
        Bucket_date_to := Trunc(IncMonth(Bucket_date_from)) - 1/24/3600;
      end;

      // old part
     { BucketSizeFix := IncMilliSecond(BucketSizeFix);
      if BucketNo = 1 then Current_bucket_size := BucketSizeFix
      else Current_bucket_size := BucketSize;

      Bucket_period := BucketSize * (BucketNo - 1) + BucketSizeFix;
      Bucket_date_from := Report_date_from + Bucket_period - Current_bucket_size;
      Bucket_date_to := Report_date_from + Bucket_period;   }

    end
    else
    begin
      BucketSizeFix := IncMilliSecond(BucketSizeFix);
      if BucketNo = 1 then Current_bucket_size := BucketSizeFix
      else Current_bucket_size := BucketSize;
      Bucket_period := BucketSize * (BucketNo - 1) + BucketSizeFix;
      Bucket_date_from := Report_date_from + Bucket_period - Current_bucket_size;
      Bucket_date_to := Report_date_from + Bucket_period;
    end;
  except
    on e:Exception do MessageDlg('UMReportExport - CalculateBucketRange'+#13'Message: '+e.Message,mtError, [mbOK],0);
  end;
end;


//----------------------------------------------------------------------------//

function CalculateJobQuantityInBucket(Id: TSchedId; FromDateTime, ToDateTime : TDateTime; RoundLevel: Integer; TimeOfFamilyBeforeId : double) : Double;
var
  Cal      : TPGCALObj;
  ActArea  : TMqmActArea;
  PlanInfo : TSQplanInfo;
  SchedQty, ExecTime, ExecTimeExcludeLearningCurve, BucketMinutes, GenericProgressTimeWithoutCurve : Double;
  Value, FieldVal    : Variant;
  DataType : CBinColValType;
  StartExecutionDateTime, FromDate, ToDate : TDateTime;
  TimePerUnit : double;
  ExecutionMinutesBeforeBucket, ExecutionMinutesUpToProgressEnd : Double;
  ProgInfo: TSQProgInfo;
  NewStartProgress, NewEndProgress : TDateTime;
  Res : TMQMRes;
  componentsTemp, components : integer;
  Duration: double;
begin
  Result := 0;
  ProgInfo.PrgQty := 0;
  ActArea := p_sc.GetExtLinkPtr(id);
  if not Assigned(ActArea) then exit;
  Cal := ActArea.GetCalendar;
  if Cal = nil then exit;
  NewStartProgress := 0;
  NewEndProgress := 0;
  // Decide when the execution starts and the execution time
  p_sc.GetPlanInfo(Id, PlanInfo);
            ///only if no progress then
  if (p_sc.IsProgressed(Id) <> prg_none) then
  begin

    if PlanInfo.isGroup then
    begin
      p_pl.SetTmgMainID(Id);
      p_pl.UpdateGrpTmg;
      p_pl.SetTmgTargetResForGroup(TMqmRes(ActArea.p_res));
      if planInfo.stepType = CST_batch then
        p_pl.GetSubTimings(0, id, PlanInfo.supMinReal, PlanInfo.exeMin, PlanInfo.TmgDescr, PlanInfo.MSC)
      else if planInfo.stepType = CST_Continuous then
        p_pl.GetMainTimings(PlanInfo.supMinBase, duration, PlanInfo.TmgDescr, PlanInfo.MSC);
    end
    else
    begin
      p_pl.SetTmgMainID(Id);
      p_pl.SetTmgTargetResForGroup(TMqmRes(ActArea.p_res));
  //    p_pl.SetTmgTargetRes(TMqmRes(actArea.p_res));
      p_pl.GetMainTimings(PlanInfo.supMinBase, duration, PlanInfo.TmgDescr, PlanInfo.MSC);
    end;
  end;

  p_sc.GetFldValue(id, CSC_NoResComp, FieldVal, dataType);
  components := FieldVal;
  Res := TMQMRes(actArea.p_Res);
  if Assigned(Res) and Res.p_isMultiRes and (p_sc.GetJobType(Id) = CST_Continuous)  then
    componentsTemp := components
  else
    componentsTemp := 1;

  CalcDurBeforeCurve(id,Duration,components);

  if ((p_sc.IsProgressed(Id) = prg_none) or (p_sc.IsProgressed(Id) = prg_Starting)) then
  begin
    cal.OfsByWH((PlanInfo.supMinReal)/60, true, PlanInfo.startDate, StartExecutionDateTime, ActArea.m_CrossDownTmList);
    ExecTime := PlanInfo.exeMin;
  end
  else
  begin
    if (p_sc.IsProgressed(Id) = prg_General) then
    begin
      p_sc.GetProgInfo(id,ProgInfo);
      StartExecutionDateTime := ProgInfo.PrgSt;
      p_sc.GetFldValue(Id, CSC_QtyToSched, Value, dataType);
      if (ProgInfo.PrgQty <> Value) and (ProgInfo.PrgCurDt >= ToDateTime) then
      begin
        ExecTime := cal.DiffWH(ProgInfo.PrgSt, ProgInfo.PrgCurDt , ActArea.m_CrossDownTmList)*60;
      end
      else
      begin
        if (ProgInfo.PrgCurDt > FromDateTime) and (ProgInfo.PrgCurDt < ToDateTime) then
        begin
          Result := CalculateJobQuantityInBucket(Id, ProgInfo.PrgCurDt, ToDateTime, RoundLevel, TimeOfFamilyBeforeId);
          ExecTime := cal.DiffWH(PlanInfo.startDate , ProgInfo.PrgCurDt , ActArea.m_CrossDownTmList)*60;
          if (ExecTime = 0) and (ProgInfo.PrgSt >= FromDateTime)  then
          begin
            Result := Result + ProgInfo.PrgQty;
            Exit;
          end;
        end
        else
        begin
          ExecTime := cal.DiffWH(ProgInfo.PrgCurDt, PlanInfo.enddate , ActArea.m_CrossDownTmList)*60;
        end;
      end;
    end
    else
    begin
      StartExecutionDateTime := PlanInfo.startDate;
      ExecTime := cal.DiffWH(PlanInfo.startDate, PlanInfo.enddate , ActArea.m_CrossDownTmList)*60;
    end;
  end;

  if ExecTime = 0 then exit;
  if StartExecutionDateTime > ToDateTime then exit;
  if PlanInfo.endDate < FromDateTime then exit;

  if StartExecutionDateTime >= FromDateTime then
  begin
    FromDate := StartExecutionDateTime;
    ExecutionMinutesBeforeBucket := 0;
  end
  else
  begin
    FromDate := FromDateTime;
    ExecutionMinutesBeforeBucket := cal.DiffWH(StartExecutionDateTime, FromDateTime, ActArea.m_CrossDownTmList)*60;
  end;

  ToDate := ToDateTime;
  if PlanInfo.endDate < ToDateTime then ToDate := PlanInfo.endDate;
  if (FromDate = ToDate) or (FromDate > ToDate) then exit;

  // Calculate the bucket size in minutes
  if (p_sc.IsProgressed(Id) = prg_General) and
     (ProgInfo.PrgCurDt > FromDateTime) and (ProgInfo.PrgCurDt < ToDateTime) then
        ToDate := ProgInfo.PrgCurDt;

  BucketMinutes := cal.DiffWH(FromDate, ToDate , ActArea.m_CrossDownTmList)*60;

  if BucketMinutes < 1 then exit;

  // Get the job execution time
  if (ProgInfo.ProgType = '2') and (ProgInfo.PrgQty > 0) then
  begin
    if (ProgInfo.PrgCurDt >= ToDateTime) or ((ProgInfo.PrgCurDt > FromDateTime) and (ProgInfo.PrgCurDt < ToDateTime)) then
    begin
      SchedQty := ProgInfo.PrgQty;
      ExecutionMinutesUpToProgressEnd := 0;
    end
    else
    begin
      p_sc.GetFldValue(Id, CSC_QtyToSched, Value, dataType);
      SchedQty := Value - ProgInfo.PrgQty;
      GenericProgressTimeWithoutCurve := ProgInfo.PrgQty / Value * Duration;
      ExecutionMinutesUpToProgressEnd := GenericProgressTimeWithoutCurve + GetCurveTime(ActArea, ProgInfo.PrgSt, id, GenericProgressTimeWithoutCurve, true, 0);
      if ExecutionMinutesBeforeBucket > 0 then // StartExecutionDateTime >= FromDateTime
        ExecutionMinutesBeforeBucket := ExecutionMinutesUpToProgressEnd + cal.DiffWH(ProgInfo.PrgCurDt, FromDateTime, ActArea.m_CrossDownTmList)*60;
    end;
  end
  else
  begin
    p_sc.GetFldValue(Id, CSC_QtyToSched, Value, dataType);
    SchedQty := Value;
    ExecutionMinutesUpToProgressEnd := 0;
  end;

  ExecTimeExcludeLearningCurve := GetMinutesExcludeLearningCurveAffect(Id, ExecutionMinutesUpToProgressEnd+TimeOfFamilyBeforeId, ExecTime);
  TimePerUnit := ExecTimeExcludeLearningCurve / SchedQty;

  if ExecTimeExcludeLearningCurve <> ExecTime then
    BucketMinutes := GetMinutesExcludeLearningCurveAffect(Id, ExecutionMinutesBeforeBucket+TimeOfFamilyBeforeId, BucketMinutes);

  Result :=  Result + RoundTo((BucketMinutes / TimePerUnit), RoundLevel);

  if Result < 5 then
     Result := 0

end;
//----------------------------------------------------------------------------//
Function GenerateXML(NumOfSh : integer): String;
begin
  Result := '<?xml version="1.0"?>  '
+ '<?mso-application progid="Excel.Sheet"?>'
+ '<Workbook xmlns="urn:schemas-microsoft-com:office:spreadsheet"  '
+ ' xmlns:o="urn:schemas-microsoft-com:office:office" '
+ ' xmlns:x="urn:schemas-microsoft-com:office:excel"'
+ ' xmlns:ss="urn:schemas-microsoft-com:office:spreadsheet"  '
+ ' xmlns:html="http://www.w3.org/TR/REC-html40">   '
+ ' <ExcelWorkbook xmlns="urn:schemas-microsoft-com:office:excel"> '
+ '  <ActiveSheet>'+ IntToStr(NumOfSh)+'</ActiveSheet> '
+ ' </ExcelWorkbook>  '
+ ' <Styles> '
+ '  <Style ss:ID="Default" ss:Name="Normal">  '
+ '  <Alignment ss:Vertical="Bottom"/>  '
+ '  <Borders/>  '
+ '   <Font ss:FontName="Calibri" x:Family="Swiss" ss:Size="11" ss:Color="#000000"/>   '
+ '   <Interior/>  '
+ '   <NumberFormat/>  '
+ '   <Protection/> '
+ '  </Style>  '
+ ' </Styles> ';
end;

Function AddValueToXML(BinData: Variant; SheetName : String): String;
var Row ,Col, j ,i: Integer;
  s,q,tp: String;
  x : Variant;
begin
  Result := '';
  Row := VarArrayHighBound(BinData, 1);
  Col := VarArrayHighBound(BinData, 2);

   s :=  ' <Worksheet ss:Name="'+SheetName+'"> '
    + '  <Table ss:ExpandedColumnCount="'+IntToStr(Col)+'" ss:ExpandedRowCount="'+IntToStr(Row)+'" x:FullColumns="1" '
    + '  x:FullRows="1" ss:DefaultRowHeight="15"> ';

    for J := 0 to Row - 1 do
   begin
     s := s + '   <Row> ';
      for I := 0 to Col - 1 do
      begin

        x := BinData[J + 1, I + 1]; //variant
        q := BinData[J + 1, I + 1]; //string

       // if TryStrToDateTime(q, dt) then
       //   tp := 'DateTime'
       // else
          tp := 'String';

        if not VarIsEmpty(x)  then
          s := s + '    <Cell><Data ss:Type="'+tp+'">'+VarToStr(x)+'</Data></Cell> '
        else
          s := s + '    <Cell><Data ss:Type="String"></Data></Cell> '
      end;

     s := s + '   </Row> ';
   end;

  s := s
    + '  </Table> '
    + ' </Worksheet> ';

  Result := s;

end;

Function CreateXML(xml, FileName: String): String;
begin
  var lstExcel := TStringList.Create;
  xml := xml + '</Workbook>';

  lstExcel.add(xml);
  lstExcel.SaveToFile(Copy(FileName, 0, Length(FileName)-3) + 'xml');
  lstExcel.Free;
end;

function CreateExcel(BinData: Variant; FileName : String): string;
var Row,nRow ,Col, j ,i, l: Integer;
s,q: String;
x : Variant;
begin
  Result := _('Could not create MS-Excel file!');
  var lstExcel := TStringList.Create;
  Row := VarArrayHighBound(BinData, 1);
  Col := VarArrayHighBound(BinData, 2);
  nRow := 0;
  s := '';
  l := 0;
  var CellSep := #34 + #09;

   for J := 0 to Row - 1 do
   begin

      for I := 0 to Col - 1 do
      begin
        x := BinData[J + 1, I + 1]; //variant
        q := BinData[J + 1, I + 1]; //string

        if (s = '') and (not VarIsEmpty(x)) then
          s := VarToStr(x) + CellSep
        else
        begin
          if not VarIsEmpty(x)  then
            s := s + #34 + VarToStr(x) + CellSep
          else
            s := s + #34 + q + CellSep;

        end;
      end;
      s := s + #13; //new Row
   end;

  if s <> '' then
  begin
    lstExcel.add(s);

    try
      lstExcel.SaveToFile(FileName);
      Result := _('Report created!');
    except

    end;
  end;

  lstExcel.Free;

end;

function CreateExcelSheet(BinData: Variant; ColumnType: Array of Integer; FileName,
  SheetName: String; ShowExcel: boolean; TextColumn : Integer): string;
const
  xlWBATChart = $FFFFEFF3;
  xlWBATExcel4IntlMacroSheet = $00000004;
  xlWBATExcel4MacroSheet = $00000003;
  xlWBATWorksheet = $FFFFEFB9;
var
  XLApp, Sheet, Data : OLEVariant;
  I, J, N, M,
  Row, Col,
  SheetCount,
  SheetColCount,
  SheetRowCount,
  BookCount          : Integer;
  SaveFileName       : string;
  MessageFilter : IOleMessageFilter;
begin
  Row := VarArrayHighBound(BinData, 1);
  Col := VarArrayHighBound(BinData, 2);
  SheetCount := (Col div 256) + 1;
  if Col mod 256 = 0 then SheetCount := SheetCount - 1;
  BookCount := (Row div 65536) + 1;
  if Row mod 65536 = 0 then BookCount := BookCount - 1;
  Result := _('Could not create MS-Excel sheet!');
  MessageFilter.RegisterFilter();
  XLApp := CreateOleObject('Excel.Application');
  try
    //XLApp.Visible := ShowExcel;
    for M := 1 to BookCount do
    begin
    //  XLApp.Workbooks.Add(xlWBATWorksheet);
      MessageFilter.RegisterFilter();
      XLApp.Application.Workbooks.Add;
     // XLApp.Worksheets.Add;
      for N := 1 to SheetCount - 1 do
      begin
        XLApp.Worksheets.Add;
      end;
    end;
    if Col <= 256 then SheetColCount := Col
    else SheetColCount := 256;
    if Row <= 65536 then SheetRowCount := Row
    else SheetRowCount := 65536;
    for M := 1 to BookCount do
    begin
      for N := 1 to SheetCount do
      begin
        Data := VarArrayCreate([1, Row, 1, SheetColCount], varVariant);
        for J := 0 to SheetRowCount - 1 do
          for I := 0 to SheetColCount - 1 do
            if ((I + 1 + 256 * (N - 1)) <= Col) and
              ((J + 1 + 65536 * (M - 1)) <= Row) then
                Data[J + 1 , I + 1 ] := BinData[ J + 1 + 65536 * (M - 1), I + 1 + 256 * (N - 1)];
        XLApp.Worksheets[N].Select;
        XLApp.Workbooks[M].Worksheets[N].Name := SheetName + IntToStr(N);
   //    avi comment
   //     XLApp.Workbooks[M].Worksheets[N].Range[RefToCell(1, 1),
   //       RefToCell(SheetRowCount, SheetColCount)].Select;
   //     XLApp.Selection.NumberFormat := '@';
   //     XLApp.Workbooks[M].Worksheets[N].Range['A1'].Select;
        Sheet := XLApp.Workbooks[M].WorkSheets[N];
        if TextColumn <> -1 then
          Sheet.Columns[TextColumn].NumberFormat := AnsiChar('@');
        Sheet.Range[RefToCell(1, 1), RefToCell(SheetRowCount, SheetColCount)].Value := Data;


      end;
    end;
    ColorExcelSheet(Sheet, SheetColcount, SheetRowCount);
//    FormatExcelSheet(Sheet, ColumnType, SheetRowCount);
    try
      for M := 1 to BookCount do
      begin
        // avi savefile name
        //SaveFileName := Copy(FileName, 1,Pos('.', FileName) - 1) + IntToStr(M) +
        //  Copy(FileName, Pos('.', FileName),Length(FileName) - Pos('.', FileName) + 1);
        SaveFileName := FileName;
        XLApp.Workbooks[M].SaveAs(SaveFileName);
      end;
      Result := _('Bucket Report created!');
    except
    end;
  finally
    if (not VarIsEmpty(XLApp)) and (not ShowExcel) then
    begin
      XLApp.DisplayAlerts := False;
      XLApp.Quit;
      XLAPP := Unassigned;
      Sheet := Unassigned;
    end;
  end;
  MessageFilter.RevokeFilter();
end;

//----------------------------------------------------------------------------//

function RefToCell(RowID, ColID: Integer): string;
var
  ACount, APos: Integer;
begin
  ACount := ColID div 26;
  APos := ColID mod 26;
  if APos = 0 then
  begin
    ACount := ACount - 1;
    APos := 26;
  end;
  if ACount = 0 then Result := Chr(Ord('A') + ColID - 1) + IntToStr(RowID);
  if ACount = 1 then Result := 'A' + Chr(Ord('A') + APos - 1) + IntToStr(RowID);
  if ACount > 1 then Result := Chr(Ord('A') + ACount - 1) + Chr(Ord('A') + APos - 1) + IntToStr(RowID);
end;

//----------------------------------------------------------------------------//

procedure ColorExcelSheet(Sheet: OLEVariant; ColCount, RowCount: Integer);
var i,FirstCP : Integer;
var CP : TMqmCapRes;
begin
  Sheet.Range[RefToCell(1, 1),RefToCell(1, ColCount)].Font.Size := 12;
  Sheet.Range[RefToCell(1, 1),RefToCell(1, ColCount)].Font.FontStyle := 'Bold';
  Sheet.Range['A2',RefToCell(1, ColCount)].Font.FontStyle := 'Bold'; // bold the header fields ...
  FirstCP := -1;
  //capres row color
  for i := 2 to RowCount - 2 do
  begin
    if length(Sheet.cells[i,1].value) = 0 then
    begin
     { if FirstCP < 0 then
        FirstCP := 0
      else
        FirstCP := i - FirstCP; }

        inc(FirstCP);

      if not assigned(CapResList) then break;
      if CapResList.Count = 0  then break;
      

      CP := TMQMCapRes(CapResList[FirstCP]);
      if Cp.m_BrushColor <> clWhite then
        Sheet.Rows[i].Interior.Color := Cp.m_BrushColor;

      if CapResList.Count = FirstCP + 1 then
        exit;
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure FormatExcelSheet(Sheet: OLEVariant; ColumnType: Array of Integer; RowNum: Integer);
var i: Integer;
begin
  for i:= 1 to Length(ColumnType) - 1 do begin
    if ColumnType[i]= 1 then
   //   Sheet.Range[RefToCell(1, i),RefToCell(1, i)].EntireColumn.NumberFormat := '0';
  end;
end;

//----------------------------------------------------------------------------//

procedure CalculateDateTo(BucketNumber: Integer; var Date_to: Double; BucketSize, Time_from: Double; var Date_from: Double);
var
  Time_to, First_bucket_date_to, First_bucket_period, NotUsed: Double;
  SavedBucketSize : double;
begin
  try
    SavedBucketSize := BucketSize;
    Date_to := 0;
    Time_to := 0;
    CalculateBucketRange(1, NotUsed, First_bucket_date_to, Date_from + Time_from, BucketSize);
    First_bucket_period := First_bucket_date_to - (Date_from + Time_from);

    if BucketSize = -1 then
      BucketSize := 1/24;

    if BucketSize >= 1 then
      Date_to := (BucketNumber - 1) * BucketSize + First_bucket_period
    else
      Time_to := (BucketNumber - 1) * BucketSize + First_bucket_period;
    Date_to   := Date_from + Int(Date_to) ;
    Time_to   := Time_from + Frac(Time_to);
    Date_from := Date_from + Time_from;
    Date_to   := Date_to + Time_to;

    if SavedBucketSize = -1 then
      Date_to := Date_from + BucketNumber/24

  except
    on e:Exception do MessageDlg('UMReportExport - CalculateDateTo'+#13'Message: '+e.Message,mtError, [mbOK],0);
  end;
end;

//----------------------------------------------------------------------------//

procedure CalculateDateToShift(BucketNumber: Integer; var Date_to: Double;
            BucketSize, Time_from: Double; var Date_from: Double; var Report : TSettings ; CalCode : string);
var
  Cal: TPGCALshift;
  CalElem : PTPGCALElem;
  I, ShiftNr: Integer;
  ShiftData : PTShiftData;
  TempDateFrom : TDateTime;
begin
  try
    Date_to := 0;
    TempDateFrom := Date_from;
    Date_from := Date_from + Time_from;
    Cal := nil;
    if (trim(CalCode) <> '') then
      Cal := TPGCALshift(ObjPGCAL_ByKey(CalCode, TPGCALObjMqm));

    if BucketNumber > 0 then
       SetLength(Report.ShiftArray,  BucketNumber);

    for I := 0 to High(Report.ShiftArray) do
    begin
      new(ShiftData);
      Report.ShiftArray[I] := ShiftData;
    end;

    CalElem := Cal.GetShiftCalDay(TempDateFrom);
    for ShiftNr := 1 to 4 do
    begin
      if (CalElem.shift[ShiftNr].dur = 0) then break;
      if (Time_from <= (CalElem.shift[ShiftNr].start + CalElem.shift[ShiftNr].dur) / 24 / 60) then break;
    end;

    I := 0;
    while I < BucketNumber do
    begin
      CalElem := Cal.GetShiftCalDay(TempDateFrom);
      if (ShiftNr > 4)
      //or (CalElem.shift[ShiftNr].dur = 0)
      then
      begin
        TempDateFrom := TempDateFrom + 1;
        ShiftNr := 1;
        continue;
      end;

      if (CalElem.shift[ShiftNr].dur = 0) and (ShiftNr > 1) then
      begin
        ShiftNr := ShiftNr + 1;
        continue;
      end;

      if i = 0 then
      begin
        Date_from := TempDateFrom + (CalElem.shift[ShiftNr].start / 24 / 60);
      end;
      Date_to   := TempDateFrom + (CalElem.shift[ShiftNr].start + CalElem.shift[ShiftNr].dur) / 24 / 60;

      Report.ShiftArray[I].Date := TempDateFrom;
      Report.ShiftArray[I].start := CalElem.shift[ShiftNr].start;
      Report.ShiftArray[I].dur := CalElem.shift[ShiftNr].dur;
      Report.ShiftArray[I].ShiftNumber := ShiftNr;

      ShiftNr := ShiftNr + 1;
      inc(i);
    end;

  except
    on e:Exception do MessageDlg('UMReportExport - CalculateDateToShift'+#13'Message: '+e.Message,mtError, [mbOK],0);
  end;
end;

end.



