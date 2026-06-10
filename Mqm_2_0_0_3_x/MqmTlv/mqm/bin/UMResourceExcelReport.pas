//******************************************************************************
// This unit exports the data of the Jobs on the Gantt to an Excel file.
// Is been called from FMMainPlan
// function isClosed checks if the job is closed or not
// procedure WriteExcelFile which makes the report
//******************************************************************************

unit UMResourceExcelReport;

interface
uses
  classes, Dialogs, SysUtils, UMSchedContFunc,
  mxNativeExcel, CheckLst, variants, UMBinGrid,
  UMCapRes, gnugettext, FMResourceReport;


type
  TResourceDet = record
  ID:         Integer;
  ResCode:       String;
  ResDesc:       String;
  SchedStart:   String;
  ProgStart:    String;
  Downtime:     boolean;
  DownTimeFrom: String;
  DownTimeTo:   String;
  Comment:      String;
end;
  PTResourceDet = ^TResourceDet;

  function BinScheduleExport(ReportSettings: TSettings): boolean;
  function WriteExcelFile( JobList: Tlist;
                           showResource: boolean;
                           ReportSettings: TSettings): boolean;

  function WriteHtmlFile(  JobList: Tlist;
                           showResource: boolean;
                           ReportSettings: TSettings): boolean;

 {
  function BinScheduleExport( NativeExcel:      TmxNativeExcel;
                              SaveFileLocation: String;
                              ChkLstBoxRsc:     TCheckListBox;
                              ReportType:       String;
                              DateFrom,DateTo:  Double;
                              MaxRows,MaxCols:  Integer): boolean;

  function  WriteExcelFile(JobList:          Tlist;
                           DateFrom,DateTo:  Double;
                           showResource:     boolean;
                           NativeExcel:      TmxNativeExcel;
                           SaveFileLocation: string): boolean;

  function  WriteHtmlFile( JobList:          Tlist;
                           DateFrom,DateTo:  Double;
                           showResource:     boolean;
                           SaveFileLocation: string;
                           MaxRows,MaxCols:  Integer): boolean;
  }
  function getPropertyDesc(Acol: Integer; binGrid: TBinDrawGrid): String;
  function isClosed(job: TSchedID): boolean;
  function IsInteger(Arg : string) : Boolean;

var
  noOfHtmlPages: Integer;

implementation

uses
 UMWkctr,
  UMRes,
  UMPlan,
  UMObjCont,
  UMActArea,
  UMschedCont,
  UMCommon,
  UMCompatSrv,
  UMCompat,
  FMMainPlan,
  UMGlobal,
  UMBinDefault,
  FMBin,
  UMBinTbs,
  UMBinPanel,
  FMViewHTML;

//----------------------------------------------------------------------------//
{
  Sorts the downtime jobs list by start time
  @param Item1     pointer to a downtime object
  @param Item2     pointer to a downtime object
  }
//----------------------------------------------------------------------------//

function sortCapRes( Item1 , Item2 : pointer): Integer;
  var
    Downtime1, Downtime2 : TMqmCapRes;
  begin
    Result:= 0;
    Downtime1 := TMqmCapRes(item1);
    Downtime2 := TMqmCapRes(item2);

    if Downtime1.p_start < Downtime2.p_start  then Result := 1;
    if Downtime1.p_start > Downtime2.p_start  then Result := -1;
    if Downtime1.p_start = Downtime2.p_start  then Result := 0;
  end;

//----------------------------------------------------------------------------//
{
//******************************************************************************
  This procedure generates an excel file of the Jobs that are on the Gantt.
  It loops over all the resources and writes the Jobs in the Excel file.
  with the details that are in the Bin.
  @param NativeExcel      The Excel Object
  @param SaveFileLocation The name of the file to save in
  @param ChkLstBoxRsc     The List box object that has all the resources chosen
                          by the user to generate the report for.
  @param DateFrom         The Date the user chose to start the report from
  @param DateTo           The Date the user chose to end the report in.
  @param ReportType       What kind of report to produce Excel/Html
}
//----------------------------------------------------------------------------//
{
function BinScheduleExport( NativeExcel:      TmxNativeExcel;
                            SaveFileLocation: String;
                            ChkLstBoxRsc:     TCheckListBox;
                            ReportType  :     String;
                            DateFrom,DateTo:  Double;
                            MaxRows,MaxCols:              Integer): boolean;
}
function BinScheduleExport(ReportSettings: TSettings): boolean;
var
  res:     TMqmRes;
  visRes:  TMqmVisibleRes;
  act_area: TMqmActArea;
  TmpDowntime: TMqmCapRes;
  schedObj: TSchedId;
  planInfo:   TSQplanInfo;
  Res_Code: String;
  i,j,k,
  checkedResources : Integer;
  startingDate: TdateTime;
  dataType: CBinColValType;
  Value:     variant;
  ResDet: PTResourceDet;
  JobList: Tlist;
  CapResList : Tlist;
  showresource: boolean;

  SaveFileLocation: String;
  ChkLstBoxRsc:     TCheckListBox;
  ReportType  :     String;
  DateFrom,DateTo:  Double;


  // This checks if there is a Downtime on the res and adds it in place
  procedure AddDowntime(dontCheckForDate: boolean);
  var
    i: Integer;
  begin
  for i:= CapResList.Count -1 downto 0 do
  begin
    TmpDowntime := TMqmCapRes(CapResList.Items[i]);   //TMqmCapRes(act_area.p_CapRes[l]);
    //startingDate is the date of the last job we have added to the report , so now
    //we are looking to add all downtime that start before that last job, this is to
    //keep the jobs and downtime in the right order
    //any other downtime will be added later
    if ( ((TmpDowntime.p_start <  startingDate) or (dontCheckForDate))
           and ((TmpDowntime.p_start > DateFrom) and (TmpDowntime.p_start < DateTo)) ) then
    begin
      new(ResDet);
      ResDet.Downtime := true;
      ResDet.ResCode      := (TMqmRes(act_Area.p_Res)).p_ResCode;
      ResDet.DownTimeFrom := DateTimeToStr(TmpDowntime.p_start);
      ResDet.DownTimeTo   := DateTimeToStr(TmpDowntime.p_end);
      ResDet.Comment      := TmpDowntime.m_Comment;

      CapResList.Delete(i);
      JobList.Add(ResDet);
     end; // if
    end;//loop
  end;//procedure

  //Duplicate the CapRes list so that we can delete each cap res
  //once we add it to the printing list - to avoid the case where
  // a last capres with no job before it shall be omitted
  procedure duplicateCapResList;
  var
    i: Integer;
  begin
    CapResList.Clear;
    for I := 0 to  act_area.p_CapResCount -1 do
    begin
      if (TMqmRes(act_Area.p_Res)).p_ResCode <> Res_Code then continue;
      if (TMqmCapRes((act_Area.p_CapRes[i])).m_Type = cr_DownTime) or
         (TMqmCapRes((act_Area.p_CapRes[i])).m_Type = Cr_CrossingDtm) then
        CapResList.add(act_Area.p_CapRes[i]);
    end;
    CapResList.Sort(sortCapRes);
  end;//procedure
begin
  Result := false;
  JobList := Tlist.create;
  CapResList := Tlist.create;
  checkedResources := 0;
  showresource := false;

  DateFrom         := ReportSettings.DateFrom;
  DateTo           := ReportSettings.DateTo;
  ChkLstBoxRsc     := ReportSettings.ChkLstBoxRsc;
  ReportType       := ReportSettings.ReportType;
  SaveFileLocation := ReportSettings.SaveFileLocation;

  //Loop over all resources in list of the checkbox
  for i := 0 to (ChkLstBoxRsc.Items.Count - 1) do begin
  if ChkLstBoxRsc.Checked[i] = false then continue
    else
      checkedResources := checkedResources + 1;
      Res_Code := ChkLstBoxRsc.Items.Strings[i];
      res := TMqmRes(p_pl.FindResByCode(Res_Code));

      if not res.p_isMultiRes then
        visRes := res.p_VisRes[0]
      else   // still need to take care of multi resource
        begin
          visRes := res.GetSubRes(0);
          if not Assigned(visRes) then exit;
        end;

    for j := 0 to visres.p_ActAreasCount -1  do begin
      act_Area := TMqmActArea(visres.p_ActArea[j]);
      if (TMqmRes(act_Area.p_Res)).p_ResCode <> Res_Code then
        continue
      else
        //Loop over all the jobs that are on the resource
        duplicateCapResList;
        for k := 0 to act_area.SchedObjsCount -1 do begin
          act_area.SortSchedObjs;
          schedObj := TSchedID(act_area.GetSchedObj(k));
          p_sc.GetPlanInfo(schedObj, planInfo);
          if (planInfo.isOnPlan) = false then continue;
          startingDate := planInfo.startDate ;
//            if (startingdate < DateFrom-1) or
//               (startingdate > DateTo ) then
            if (planInfo.endDate < DateFrom) or
               (planInfo.startDate > DateTo ) then
              continue
            else
          //check for Downtime and add it

          AddDowntime(false);

          new(ResDet);
          ResDet.ResCode := Res_Code;
          ResDet.ResDesc := res.p_ResSDesc;
          ResDet.Downtime := false;
     //     ResDet.WkcDesc := TMqmWrkCtr(res.p_Father).p_WrkCtrLDesc;
          ResDet.ID := schedObj;
          p_sc.GetFldValue(schedObj,CSC_SchedStart,Value, dataType);
          ResDet.SchedStart := vartoStr(Value);
          p_sc.GetFldValue(schedObj,CSC_ProgStart,Value, dataType);
          ResDet.ProgStart := vartoStr(Value);

          JobList.Add(ResDet);
        end; // k loop - Jobs loop
      AddDowntime(true);
     end; // j loop - Resources loop
   end; // i loop - check box loop

   if JobList.Count <=0 then
   begin
     MessageDlg(_('No jobs present on selected resources'), mtInformation, [mbOK], 0);
     result := false;
     exit;
   end;
     
   if checkedResources <= 1 then
     showResource := true;

   if reportType = 'Excel' then
     result := WriteExcelFile(JobList, showResource, ReportSettings);
     //result := WriteExcelFile(JobList,DateFrom,DateTo, showResource, NativeExcel,SaveFileLocation);
   if reportType = 'Html' then
     result := WriteHtmlFile(JobList, showResource, ReportSettings);
     //result := WriteHtmlFile(JobList,DateFrom,DateTo, showResource, SaveFileLocation, MaxRows, MaxCols);

end;

//----------------------------------------------------------------------------//

{
//******************************************************************************
  This procedure writes the Excel file with the data stored in JobList list
  @param JobList          The List with all the Resources and Sched Jobs
  @param NativeExcel      The Excel Object
  @param SaveFileLocation The name of the file to save in
  @param DateFrom         The Date the user chose to start the report from
  @param DateTo           The Date the user chose to end the report in.
  @param showResource     If to show the string 'resource' in the report
}
//----------------------------------------------------------------------------/
{
function WriteExcelFile( JobList: Tlist;
                         DateFrom,DateTo: Double;
                         showResource: boolean;
                         NativeExcel: TmxNativeExcel;
                         SaveFileLocation: string): boolean;
                         }
function WriteExcelFile(  JobList: Tlist;
                         showResource: boolean;
                         ReportSettings: TSettings): boolean;

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
// DIRK BEGIN - move sumX Integers to Doubles
  sumSetupTime :       Integer;
  ActBinGrid :         TBinDrawGrid;
  ActTab:              TBinTabSheet;
  ColAttributes:       TBinColCurrent;
  Field,
  FieldValue :         String;
  ResDet :             PTResourceDet;
  id : TSchedId;
  Value: Variant;
  dataType:            CBinColValType;
  sumQtyToSched,
  sumProgQty,
  FloatValue:          double;
// DIRK END
begin
  result := false;
  ColumnStart        := 0;
//  ColumnEnd          := 0;
//  ColumnComment      := 0;
//  ColumnStart        := 0;
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
  if not Assigned(ActTab) then  exit;
  ActbinGrid := ActTab.GetBinGrid;
  With ReportSettings.NativeExcel Do
  Begin
    stepTypeIndex  := -1;
    StepGroupIndex := -1;
    NewFile;
    FileName := ReportSettings.SaveFileLocation;
    //added a font for use in excel takes the attributes from that
    //font from FMMainPlan will be font 0
    AddFont(FMQMPlan.ExcelFontBold.Font);
    //font from FMMainPlan will be font 1
    AddFont(FMQMPlan.ExcelFontHeader1.Font);
    //font from FMMainPlan will be font 2
    AddFont(FMQMPlan.ExcelFontHeader2.Font);
       {
       SetLeftMargin( 0.30 ); // ** This value has to be in inches **
       SetBottomMargin( 2.30 ); // ** This value has to be in inches **
       SetTopMargin( 0.30 ); // ** This value has to be in inches **
       SetRightMargin( 0.30 ); // ** This value has to be in inches **
       //SetColumnWidth( Column, 7 );                          
       }
    SetHeader( 'MQM - Resource extraction' );//The header that will appear in print
    SetFooter( '&N &P' ); //The Footer of the printed excel file


    ActiveFont := 1;  //what font to use
   // shading := true;
    WriteLabel(1,6,_('Schedules list -') + ActTab.Caption);
    ResDet := JobList.Items[0];
 //   if not assigned(ResDet) then

    ActiveFont := 2;  //what font to use
 
    //only for one resources
    if showResource then
    begin
      if  ResDet.ResDesc <> '' then
        WriteLabel(3,6,_('Resource:')+ '  ' + ResDet.ResDesc );
      WriteLabel(4,6,_('From:') + '  ' + DateTimeToStr(ReportSettings.DateFrom) + ' '+ _('To:') +' '+ DateTimeToStr(ReportSettings.DateTo) );
    end
    else
      WriteLabel(3,6,_('From:') + '  ' + DateTimeToStr(ReportSettings.DateFrom) + '  ' + _('To:') +' '+ DateTimeToStr(ReportSettings.DateTo) );
      
    if showResource then
      Row := 6
    else
      Row := 5;

    Column := 1;



    shading := true;
    ActiveFont := 0;  //what font to use
    Alignment:= eaCenter;  //Alignment of the Cells

    //Loop over the column headers
    for i:= 0 to High(BinColDefault)-1 do
    begin
      pos := ActbinGrid.findpos(i);//position of the header in the bin
      ColAttributes := ActbinGrid.BinColumnSet[pos];
      if  ColAttributes.Field = CSC_MsgFromHost then continue;
      if  ColAttributes.Visible then
      begin
      //  field := getPropertyDesc(pos,ActbinGrid);
        if ColAttributes.Title = '' then
          field := getPropertyDesc(pos,ActbinGrid)
        else
          field := ColAttributes.Title;

        WriteLabel(Row,Column,_(field));
        colNum :=  colNum +1;
       //for Downtime entries
        if  ColAttributes.Field = CSC_ProgStart then
           ColumnStart := colNum; //i;
        if  ColAttributes.Field = CSC_ProgEnd then
           ColumnEnd := colNum; //i;
        if  ColAttributes.Field = CSC_Comment then
           ColumnComment := colNum; //i;

        //for summing columns
        if  ColAttributes.Field = CSC_QtyToSched then
           ColumnQtyToSched := colNum;
        if  ColAttributes.Field = CSC_ExeTimeSched then
           ColumnExeTimeSched := colNum;
        if  ColAttributes.Field = CSC_SupTimeSched then
           ColumnSupTimeSched := colNum;
        if  ColAttributes.Field = CSC_ProgQty then
           ColumnProgQty := colNum;

         //so that we can replace the number with text
        if ColAttributes.Field = CSC_StepType then stepTypeIndex := i;
        if ColAttributes.Field = CSC_ReprocNo then stepTypeIndex := i;

      end;
    end;//for


    shading := false;
    ActiveFont := 5;  //normal font
  
    //Loop over all the rows of the bin
    for i := 0 to JobList.Count-1 do
    begin
      Column := 1;
      Row := Row +1;
      ResDet := JobList.Items[i];
      id := TSchedId(ResDet.ID);

      if (id <> CSchedIdNull) or (ResDet.Downtime) then
      begin
        //loop over all columns of row in bin
        for j:= 0 to High(BinColDefault)-1 do
        begin
          pos := ActbinGrid.findpos(j);
          ColAttributes := ActbinGrid.BinColumnSet[pos];
          if  ColAttributes.Field = CSC_MsgFromHost then continue;

          if (ColAttributes.Visible and ResDet.Downtime) then
               begin
               WriteLabel(Row,1,'Downtime');
               if  ColAttributes.Field = CSC_ProgStart then
                 WriteLabel(Row,ColumnStart,ResDet.DownTimeFrom);
               if  ColAttributes.Field = CSC_ProgEnd then
                 WriteLabel(Row,ColumnEnd,ResDet.DownTimeTo);
               if  ColAttributes.Field = CSC_Comment then
                 WriteLabel(Row,ColumnComment,ResDet.Comment);
               continue;
               end;

               
          if  ColAttributes.Visible then
            begin
              p_sc.GetFldValue(Id, ColAttributes.Field ,Value, dataType);

              FieldValue := VarToStr( Value);
              if trim(FieldValue) = '' then FieldValue := '----';

              if  ( (ColAttributes.Field = CSC_ExeTime) or
                    (ColAttributes.Field = CSC_PlanSetup) or
                    (ColAttributes.Field = CSC_ExeTimeSched) or
                    (ColAttributes.Field = CSC_SupTimeSched) ) then
              begin
                if ColAttributes.Field = CSC_ExeTimeSched then
                  sumSchedExecTime := sumSchedExecTime + Value;
                if ColAttributes.Field = CSC_SupTimeSched then
                  sumSetupTime := sumSetupTime + Value;

                 FieldValue := p_sc.GetFldDescr(id, ColAttributes.Field);
                 WriteLabel(Row,Column,FieldValue);
                 continue;
              end;

              if ColAttributes.Field = CSC_QtyToSched then
                  sumQtyToSched := sumQtyToSched + Value;
              if ColAttributes.Field = CSC_ProgQty then
                  sumProgQty := sumProgQty + Value;

              if (dataType <> CBT_integer) and (dataType <> CBT_float) then
              begin
               if ((stepGroupIndex = j ) and  (FieldValue = intToStr(-1))) then
                    FieldValue := '----';
              end;

              if stepTypeIndex = j  then
              begin
              case strToInt(FieldValue) of
                1: FieldValue := _('Batch');
                2: FieldValue := _('Continuous');
              end;
              dataType := CBT_string;
              end;//if

              if (dataType = CBT_float) or (dataType = CBT_integer) then
              begin
                if IsInteger(FieldValue) = false then
                begin
                   WriteLabel(Row,Column,FieldValue);
                   continue;
                end;
                FloatValue := StrToFloat(FieldValue);
                WriteNumber(Row,Column,FloatValue);
                continue;
              end;

              WriteLabel(Row,Column,FieldValue);

            end;//if Visible
         end;//j Column Loop
     end;//if
  end;//i Rows Loop


  //Print the sum rows
  Row := Row + 2;
  for i:= 1 to colNum do
    begin
    if      i = 1                  then  WriteLabel(Row,i,'Total')
// DIRK BEGIN - format quantity values
    else if i = ColumnQtyToSched   then  WriteLabel(Row,i,FormatQtyWithoutZeros(sumQtyToSched, 3))
    else if i = ColumnExeTimeSched then  WriteLabel(Row,i,FormatDuration(sumSchedExecTime, true))
    else if i = ColumnSupTimeSched then  WriteLabel(Row,i,FormatDuration(sumSetupTime, true))
    else if i = ColumnProgQty      then  WriteLabel(Row,i,FormatQtyWithoutZeros(sumProgQty, 3))
// DIRK EMD
 //   else                                 WriteNumber(Row,Column, sl.Add('-- </td>');
  end;//for

  CloseFile;
  SaveToFile;
  End;
  result := true;
End;

//----------------------------------------------------------------------------/

{
//******************************************************************************
  This procedure writes the HTML file with the data stored in JobList list
  @param JobList          The List with all the Resources and Sched Jobs
  @param SaveFileLocation The name of the file to save in
  @param DateFrom         The Date the user chose to start the report from
  @param DateTo           The Date the user chose to end the report in.
  @param MaxRows          If splitted page - the number of rows per page
  @param MaxCols          If splitted page - the number of columns per page -
                          Not implemented yet
  @param showResource     If to show the string 'resource' in the report
}
//----------------------------------------------------------------------------/
{
function WriteHtmlFile( JobList: Tlist;
                         DateFrom,DateTo: Double;
                         showResource: boolean;
                         SaveFileLocation: string;
                         MaxRows,MaxCols: Integer): boolean;
}
function WriteHtmlFile(  JobList: Tlist;
                         showResource: boolean;
                         ReportSettings: TSettings): boolean;
var
  i, j, pos, k,
  stepTypeIndex,
  StepGroupIndex,
  ColumnStart,
  ColumnEnd,
  ColumnComment,
  ColumnQtyToSched,
  ColumnExeTimeSched,
  ColumnSupTimeSched,
  ColumnProgQty,
  ColumnFinalQty,
  ColumnStepExeTime,
  colNum,
  position,
// DIRK BEGIN - move sumX Integers to Doubles
  sumStepExeMin,
  sumSchedExecTime,
  sumSetupTime,
  fromPage,
  toPage :         Integer;
  sumFinQty,
  sumQtyToSched,
  sumProgQty:      Double;
// DIRK END
  ActBinGrid :     TBinDrawGrid;
  ActTab:          TBinTabSheet;
  ColAttributes:   TBinColCurrent;
  Field,
  FieldValue,
  tempString,
  headerString:      String;
  ResDet :         PTResourceDet;
  id :             TSchedId;
  Value:           Variant;
  dataType:        CBinColValType;
  sl, Header:      TStringList;
  doItOneTime,
  OddRow:          boolean;
  LastEndDate:     TDateTime;
  DatesInfo:       TSQDatesInfo;
begin
  result             := false;
  sumSchedExecTime   := 0;
  sumSetupTime       := 0;
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
  ColumnProgQty      := 0;
  ColumnFinalQty     := 0;
  ColumnStepExeTime  := 0;
  colNum             := 0;
  stepTypeIndex      := -1;
  StepGroupIndex     := -1;
  OddRow             := true;
  noOfHtmlPages      := 0;

  ActTab := FBin.GetActiveView;
  if not Assigned(ActTab) then  exit;
  ActbinGrid := ActTab.GetBinGrid;

  sl     := TStringList.Create;
  Header := TStringList.Create;
  header.Add('<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">');
  Header.Add('<HTML>');
  Header.Add('<HEAD>');
//  Header.Add('<TITLE>' + _('MQM plan schedules report') + ' </TITLE>');
  Header.Add('<STYLE type="text/css">');
  Header.Add('  TH { background: #C0C0C0 ; color: #000000; font-family: Arial, Helvetica, sans-serif; font-size: 14px; font-weight: bold; text-align: center}');
  Header.Add('  TR.header { background: #E4E4E4; color: #000000; font-family: Arial, Helvetica, sans-serif; font-size: 12px}');
  Header.Add('  TR.Odd { background: #E2DEE0; font-family: Arial, Helvetica, sans-serif; font-size: 12px}');
  Header.Add('  TR.Even { background: #FFFFFF; font-family: Arial, Helvetica, sans-serif; font-size: 12px}');
  Header.Add('  TR.Space { background: Gray; font-family: Arial, Helvetica, sans-serif; font-size: 8px}');
//  sl.Add('  TD.center{ text-align: center }');
  Header.Add('  TD {font-size: 90%; font-family: Arial, Helvetica, sans-serif; font-size: 12px; text-align: center}');
  Header.Add('  P.Title {font-family: Arial, Helvetica, sans-serif; font-size: 28px; font-weight: bold; text-align: center}');
  Header.Add('</STYLE>');
  Header.Add('</HEAD>');
  Header.Add('<BODY>');

   //only for one resources
  if ReportSettings.ShowBinCaption then
  begin
    header.Add('<center>');
    header.Add('<p class="Title"> <H2>' + ActTab.Caption + '</h2></p></center> ');
  end;
  ResDet := JobList.Items[0];

  if ReportSettings.ShowCriteria then
  begin
    if showResource then
    begin
      header.Add('<center><h3><p class="Title">');
      if  ResDet.ResDesc <> '' then
      begin
        header.Add(_('Resource:')+ '  ' + ResDet.ResDesc + '<br>');
      end;
      header.Add(_('From:') + '  ' + DateTimeToStr(ReportSettings.DateFrom) +  _('To:') +' '+ DateTimeToStr(ReportSettings.DateTo));
      header.Add('</p></h3></center>');
    end
  else
    begin
      header.Add('<center><h3><p class="Title">');
      header.Add(_('From:') + '  ' + DateTimeToStr(ReportSettings.DateFrom) + _('To:') +' '+ DateTimeToStr(ReportSettings.DateTo));
      header.Add('</p></h3></center>');
    end;//else
  end;//if to show

 if ReportSettings.Comment <> '' then
   begin
     header.Add('<center><p class="Title"><h3>');
     header.Add( ReportSettings.Comment );
     header.Add('</p></h3></center>');
   end;

 // header.Add('</center>');
  header.Add('<table align="center" border="1"  >');
  header.Add('  <tr>');
  //Loop over the column headers
  for i:= 0 to High(BinColDefault)-1 do
    begin
      pos := ActbinGrid.findpos(i);//position of the header in the bin
      ColAttributes := ActbinGrid.BinColumnSet[pos];
      if  ColAttributes.Field = CSC_MsgFromHost then continue;
      if  ColAttributes.Visible then
      begin
        header.Add('    <th>');
        if ColAttributes.Title = '' then
          field := getPropertyDesc(pos,ActbinGrid)
        else
          field := ColAttributes.Title;
        header.Add(_(field));
        header.Add('    </th>');
        colNum :=  colNum +1;

       //for Downtime entries
        if  ColAttributes.Field = CSC_ProgStart then
           ColumnStart :=  colNum; //i;
        if  ColAttributes.Field = CSC_ProgEnd then
           ColumnEnd := colNum; //i;
        if  ColAttributes.Field = CSC_Comment then
           ColumnComment := colNum; //i;
       //for summing columns
        if  ColAttributes.Field = CSC_QtyToSched then
           ColumnQtyToSched := colNum; //i;
        if  ColAttributes.Field = CSC_ExeTimeSched then
           ColumnExeTimeSched := colNum; //i;
        if  ColAttributes.Field = CSC_SupTimeSched then
           ColumnSupTimeSched := colNum; //i;
        if  ColAttributes.Field = CSC_ProgQty then
           ColumnProgQty := colNum; //i;
        if  ColAttributes.Field = CSC_FinQty then
           ColumnFinalQty := colNum; //i;
        if  ColAttributes.Field = CSC_ExeTime then
           ColumnStepExeTime := colNum; //i;

         //so that we can replace the number with text
        if ColAttributes.Field = CSC_StepType then stepTypeIndex := i;
        if ColAttributes.Field = CSC_ReprocNo then stepTypeIndex := i;

      end;
    end;//for
    header.Add('    </tr>');

    LastEndDate := 0;
    //Loop over all the rows of the bin
    for i := 0 to JobList.Count-1 do
    begin
      Oddrow := not OddRow;
      ResDet := JobList.Items[i];
      id := TSchedId(ResDet.ID);
      doItOneTime    := false;

      if (ReportSettings.MaxRows > 0) and ((i = 0) or (i mod ReportSettings.MaxRows = 0)) then
      begin
        noOfHtmlPages :=  noOfHtmlPages + 1;
        if ((i div ReportSettings.MaxRows) >= 1) then
          Header.Delete(14);
        FromPage := (i div ReportSettings.MaxRows) + 1;
        ToPage   := ((JobList.Count-1) div ReportSettings.MaxRows)+ 1;
        Header.Insert(14,'<h4>' + _('Page') + ' ' + inttostr(FromPage) + ' ' + _('of') + ' ' + inttostr(ToPage) + '</h3>' );
        // this is to save the previous page before we create a new one - in case of multiple pages.
        if noOfHtmlPages > 1 then //if i > 1 then
        begin
          sl.Add('</tr>');
          sl.Add('</table>');
          sl.Add('</BODY>');
          sl.Add('</HTML>');
          sl.SaveToFile(ReportSettings.SaveFileLocation);
        end;
        sl.Clear;
        sl.AddStrings(header);

        ReportSettings.SaveFileLocation := GetCurrentdir + '\' + 'BinSchedReport_default_#' +  intToStr(noOfHtmlPages) + '.html';
      end
      else
        if i = 0 then sl.AddStrings(header);

      if (id <> CSchedIdNull) or (ResDet.Downtime) then
      begin
        if not (ResDet.Downtime) then
        begin
          p_sc.GetDatesInfo(id, DatesInfo);
          if (i > 0)
          and (LastEndDate < DatesInfo.StartDate) then
          begin
            sl.Add('  <tr class = Space>');
            sl.Add('    <td colspan=100%><br></td>');
            sl.Add('  </tr>');
          end;
          LastEndDate := DatesInfo.EndDate;
        end else
        begin
          if (i > 0)
          and (LastEndDate < StrToDateTime(ResDet.DownTimeFrom)) then
          begin
            sl.Add('  <tr class = Space>');
            sl.Add('    <td colspan=100%><br></td>');
            sl.Add('  </tr>');
          end;
          LastEndDate := StrToDateTime(ResDet.DownTimeTo);
        end;

        if OddRow then
          sl.Add('  <tr class = Odd>')
        else
          sl.Add('  <tr class = Even>');
        //loop over all columns of row in bin
        for j:= 0 to High(BinColDefault)-1 do
        begin

          pos := ActbinGrid.findpos(j);
          ColAttributes := ActbinGrid.BinColumnSet[pos];
          if  ColAttributes.Field = CSC_MsgFromHost then continue;

          if (ColAttributes.Visible and ResDet.Downtime) then
               begin
               if not doItOneTime then
               begin
                 sl.Add('  <td><b> Downtime <b></td>');
                 for k := 2 to colNum do
                 begin
                   sl.Add('  <td>--</td>');
                   doItOneTime := true;
                 end; //for
               end; //if
               position := sl.Count - colNum - 1 ;

               if  ColAttributes.Field = CSC_ProgStart then
               begin
                 sl.Delete(position + ColumnStart);
                 tempString := '<td> ' + ResDet.DownTimeFrom + '</td>';
                 sl.Insert(position + ColumnStart, tempString);
               end;
               if  ColAttributes.Field = CSC_ProgEnd then
               begin
                 sl.Delete(position + ColumnEnd);
                 tempString := '<td> ' + ResDet.DownTimeTo + '</td>';
                 sl.Insert( position + ColumnEnd, tempString );
               end;
               if  ColAttributes.Field = CSC_Comment then
               begin
                 sl.Delete(position + ColumnComment);
                 tempString := '<td> ' + ResDet.Comment + '</td>';
                 sl.Insert( position + ColumnComment, tempString);
               end;
               continue;
               end;


          if  ColAttributes.Visible then
            begin
              p_sc.GetFldValue(Id, ColAttributes.Field ,Value, dataType);

              FieldValue := VarToStr( Value);
              if trim(FieldValue) = '' then FieldValue := '----';

              if  ( (ColAttributes.Field = CSC_ExeTime) or
                    (ColAttributes.Field = CSC_PlanSetup) or
                    (ColAttributes.Field = CSC_ExeTimeSched) or
                    (ColAttributes.Field = CSC_SupTimeSched) ) then
              begin
                if ColAttributes.Field = CSC_ExeTimeSched then
                  sumSchedExecTime := sumSchedExecTime + Value;
                if ColAttributes.Field = CSC_SupTimeSched then
                  sumSetupTime := sumSetupTime + Value;
                if  ColAttributes.Field = CSC_ExeTime then
                   sumStepExeMin := sumStepExeMin + Value;

                 FieldValue := p_sc.GetFldDescr(id, ColAttributes.Field);
                 sl.Add('<td>');
                 sl.Add( FieldValue);
                 sl.Add( '</td>');
                 continue;
              end;

              if ColAttributes.Field = CSC_QtyToSched then
                  sumQtyToSched := sumQtyToSched + Value;
              if ColAttributes.Field = CSC_ProgQty then
                  sumProgQty := sumProgQty + Value;

              if  ColAttributes.Field = CSC_FinQty then
                 sumFinQty := sumFinQty + Value;

              if (dataType <> CBT_integer) and (dataType <> CBT_float) then
              begin
               if ((stepGroupIndex = j ) and  (FieldValue = intToStr(-1))) then
                    FieldValue := '----';
              end;

// DIRK BEGIN - transform numerics with or without decimals
              if (dataType = CBT_integer) or (dataType = CBT_float) then
                FieldValue := FormatQtyWithoutZeros(Value, 3);
// DIRK END

              if (ColAttributes.Field = CSC_ProgStart)
              or (ColAttributes.Field = CSC_ProgEnd) then
                FieldValue := FormatDateTime('dddd', Value) + ' ' + FieldValue;

              if stepTypeIndex = j  then
              begin
              case strToInt(FieldValue) of
                1: FieldValue := _('Batch');
                2: FieldValue := _('Continuous');
              end;
              dataType := CBT_string;
              end;//if

              sl.Add('<td>');
              sl.Add( FieldValue);
              sl.Add( '</td>');

            end;//if Visible
         end;//j Column Loop
     end;//if
  end;//i Rows Loop

  sl.Add('</td></tr>');
  //Print the sum rows
  sl.Add('<tr>');
  for i:= 1 to colNum do
    begin
    sl.Add('  <td> <b>');
    if      i = 1                  then  sl.Add('Total </b></td>')
// DIRK BEGIN - format sum quantities
    else if i = ColumnQtyToSched   then  sl.Add(FormatQtyWithoutZeros(sumQtyToSched, 3)       + '</b></td>')
    else if i = ColumnExeTimeSched then  sl.Add(FormatDuration(sumSchedExecTime, true) + '</b></td>')
    else if i = ColumnSupTimeSched then  sl.Add(FormatDuration(sumSetupTime, true)     + '</b></td>')
    else if i = ColumnProgQty      then  sl.Add(FormatQtyWithoutZeros(sumProgQty, 3)          + '</b></td>')
    else if i = ColumnFinalQty     then  sl.Add(FormatQtyWithoutZeros(sumFinQty, 3)           + '</b></td>')
// DIRK END
    else if i = ColumnStepExeTime  then  sl.Add(FormatDuration(sumstepExeMin, true)       + '</b></td>')
    else                                 sl.Add('-- </td>');
  end;//for
  sl.Add('</tr>');

  sl.Add('</table>');
  sl.Add('</BODY>');
  sl.Add('</HTML>');

  sl.SaveToFile(ReportSettings.SaveFileLocation);
  sl.Free;

  result := true;
End;

//----------------------------------------------------------------------------/
//----------------------------------------------------------------------------//
{
  Retrieves the description of the property in the grid
  @param Acol      cell number in the bin grid
  @param bingrid   The Bingrid object

  Returns the description of the property
  }
//----------------------------------------------------------------------------//

function getPropertyDesc(Acol: Integer; binGrid: TBinDrawGrid): String;
var
  num: Integer;
  pId: TPropId;
begin
  num := -1;
  case binGrid.BinColumnSet[Acol].Field of
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
    Result := GetPropDescr(pId);
  end else
    Result := binGrid.BinColumnSet[Acol].Title
end;

//----------------------------------------------------------------------------/
//----------------------------------------------------------------------------//
{
  Check if the step is closed
  @param Job      id of the Job
  }
//----------------------------------------------------------------------------//

function isClosed(job: TSchedID): boolean;
var
  StepInfo: TSQStepInfo;
  ProdNo, StepNo: String;
  j: Integer;
begin
  StepNo := p_sc.GetFldDescr(Job, CSC_ProdStep);
  ProdNo := p_sc.GetFldDescr(Job, CSC_ProdReq);

  for j := 0 to p_sc.StepCount(ProdNo) -1 do
  begin
    StepInfo := p_sc.GetStepByIndex(ProdNo, j);
    if StepInfo.StepNo = StrToInt(StepNo) then break;
  end;

  result := StepInfo.StepClosed;
end;

//----------------------------------------------------------------------------/
//----------------------------------------------------------------------------//
{
  Checks if the String is an integer
  @param Arg     the String we want to check

  returns true if the string is an Integer , or false it isn't
  }
//----------------------------------------------------------------------------//

function IsInteger(Arg : string) : Boolean;
begin
  result := true;
  try
    StrToFloat(Arg);
  except
    on EConvertError do
    begin
      result := false;
    end;//on..do
  end;//try..except
end;
end.
