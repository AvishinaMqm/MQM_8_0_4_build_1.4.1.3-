//******************************************************************************
// This unit exports the data of the rows in the Bin to an Html file.
// Is been called from FMMainPlan
// function isClosed checks if the job is closed or not
// procedure PrintBinreport which makes the report
//******************************************************************************

unit UMBinReport;

interface
uses
  classes, Dialogs, SysUtils, UMSchedContFunc, UMBinGrid, gnugettext;

  procedure PrintBinReport(SaveFileLocation: String);
  function isClosed(job: TSchedID): boolean;
  function getPropertyDesc(Acol: Integer; binGrid: TBinDrawGrid): String;

implementation

uses
  Variants,
  FMBin,
  UMBinDefault,
  UMBinTbs,
  UMBinPanel,
  UMGlobal,
  UMSchedCont,
  UMObjCont,
  FMBinTotals,
  UMCompat;

//----------------------------------------------------------------------------//
{
//******************************************************************************
  This procedure generates an Html file out of the Bin data.
  And is very similiar to UMBinToExcel which generates an Excel file.
  It loops over all the bin rows and writes them in the Html file.
  @param SaveFileLocation The name of the file to save in
}
procedure PrintBinReport(SaveFileLocation: string);
var
  i,j, NumberOfRowsInBin, pos: Integer;
  stepTypeIndex, StepGroupIndex: Integer;
  Field,
  FieldValue,
  BackGroundColor,
  SchedType:      String;
  Value: Variant;
  slist: TStringList;
  ActTab: TBinTabSheet;
  ActBinGrid : TBinDrawGrid;
  id: TschedID;
  ColAttributes: TBinColCurrent;
  dataType:  CBinColValType;
  SchedCounter,
  notSchedCounter : Integer;
  SchedQuantity,
  NotSchedQuantity,
  TotSetup, TotExe: Double;
begin
  ActTab := FBin.GetActiveView;
  ActbinGrid := ActTab.GetBinGrid;
  NumberOfRowsInBin := TBinPanel(ActbinGrid.Parent).m_ObjList.GetLinkCount;
  CalcTotals(notSchedCounter,SchedCounter,
             notSchedQuantity,SchedQuantity,TotSetup, TotExe);
  stepTypeIndex := -1;
  stepGroupIndex := -1;
  
  slist := TStringList.Create;
  slist.Clear;
  slist.Add('<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0//EN">');
  slist.Add('<HTML>');
  slist.Add('<HEAD>');
  slist.Add('<TITLE>' + _('MQM - bin extraction') + ' </TITLE>');
  slist.Add('<STYLE type="text/css">');
  slist.Add('  TH { background: #B4B4B4; color: #000000; font-family: Arial, Helvetica, sans-serif; font-size: 12px; font-style: bold}');
  slist.Add('  TR.Odd { background: #E2DEE0; font-family: Arial, Helvetica, sans-serif; font-size: 12px} ');
  slist.Add('  TR.Even { background: #FFFFFF; font-family: Arial, Helvetica, sans-serif; font-size: 12px} ');
  slist.Add('  TD.center{ text-align: center }');
  slist.Add('  TD {font-size: 90%}');
  slist.Add('  P.Title {font-family: Arial, Helvetica, sans-serif; font-size: 28px; font-weight: bold; text-align: center} ');
  slist.Add('  LI.Normal {font-family: Arial, Helvetica, sans-serif; font-size: 14px; font-weight: normal; text-align: left} ');
  slist.Add('</STYLE>');
  slist.Add('</HEAD>');
  slist.Add('<BODY>');

  slist.Add('<p class="Title">'+ ActTab.Caption + ' </p>');
  slist.Add('<ul  title="Total of :" type="">');
  slist.Add('    <li class="Normal"> '+  IntToStr(notSchedCounter) + ' ' );
  slist.Add(     _('Not scheduled jobs, Total quantity') + ' = ' + FloatToStr(notSchedQuantity) + '</li>');
  slist.Add('    <li class="Normal"> '+  IntToStr(SchedCounter) + ' ');
  slist.Add(     _('Scheduled jobs, Total quantity') + ' = '+  FloatToStr(SchedQuantity) + '</li>');
  slist.Add('</ul>');

  slist.Add('<table align="center" border="1">');



  slist.Add('  <tr>');
  slist.Add('    <th>');
  slist.Add('      ' + _('Row no.'));
  slist.Add('    </th>');

  if DBAppSettings.FixColStatVis then
  begin
    slist.Add('    <th>');
    slist.Add('      ' + _('Status'));
    slist.Add('    </th>');
  end;  

  //Loop over the column headers
  for i:= 0 to High(BinColDefault)-1 do
  begin
    pos := ActbinGrid.findpos(i);
    ColAttributes := ActbinGrid.BinColumnSet[pos];
    if  ColAttributes.Visible then
    begin
      //field := ColAttributes.Title;
      field := getPropertyDesc(pos,ActbinGrid);
      slist.Add('    <th>');
      slist.Add('      ' + _(field));
      slist.Add('    </th>');

      //so that we can replace the number with text
  //    if field = 'Step Type' then stepTypeIndex := i;
  //    if field = 'Step Group' then stepGroupIndex := i;
      if ColAttributes.Field = CSC_StepType then stepTypeIndex := i;
      if ColAttributes.Field = CSC_ReprocNo then stepTypeIndex := i;

    end;
  end;//for
  slist.Add('  </tr>');
  slist.Add('<tr><hr></tr>');

  //Loop over all the rows of the bin
  for i := 0 to NumberOfRowsInBin do
  begin
    id := TSchedId(TBinPanel(ActbinGrid.Parent).m_ObjList.GetLink(i));
      if id <> CSchedIdNull then
      begin
        if (i mod 2) > 0 then
          BackGroundColor := 'Odd'
         else
           BackGroundColor := 'Even';

        slist.Add('  <tr class=' + BackGroundColor + '>');
        slist.Add('    <td align="center">');
        slist.Add('         ' + IntToStr(i + 1));
        slist.Add('    </td>');

       //Status column
        if DBAppSettings.FixColStatVis then
        begin
          slist.Add('    <td align="center">');
          if isClosed(id) = false then
          begin
            case p_sc.IsProgressed(id) of
              prg_Starting:   slist.Add('         ' +_('Started'));
              prg_General:    slist.Add('         ' +_('Progressed'));
              prg_Final,
              prg_FinalSplit: slist.Add('         ' +_('Ended'));
              else
              begin
              SchedType := p_sc.GetSchedType(id);
                if (SchedType = '0') then
                  slist.Add('         ' + '----');
                if (SchedType = '1') then
                  slist.Add('         ' +_('Temporarily'));
                if (SchedType = '2') then
                  slist.Add('         ' +_('Fixed'));
              end;
            end;//case
          end;//if open

        if isClosed(id) = true then slist.Add('         ' +_('Closed'));

        slist.Add('    </td>');
        end;//Show status

        //loop over all columns of row in bin
        for j:= 0 to High(BinColDefault)-1 do
        begin
          pos := ActbinGrid.findpos(j);
          ColAttributes := ActbinGrid.BinColumnSet[pos];
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
                 FieldValue := p_sc.GetFldDescr(id, ColAttributes.Field);
                 slist.Add('    <td align="center">');
                 slist.Add('         ' + FieldValue);
                 slist.Add('    </td>');
                 continue;
              end;

              if ((stepGroupIndex = j ) and  (FieldValue = intToStr(-1))) then
                  FieldValue := '----';
              if stepTypeIndex = j then
              begin
              case strToInt(FieldValue) of
                1: FieldValue := _('Batch');
                2: FieldValue := _('Continuous');
              end;
              end;//if

              slist.Add('    <td align="center">');
              slist.Add('         ' + FieldValue);
              slist.Add('    </td>');
            end;//if Visible
         end;//j Column Loop
        slist.Add('  </tr>');
    end;//if
  end;//i Rows Loop
  slist.Add('</table>');
  slist.Add('</BODY>');
  slist.Add('</HTML>');
  slist.SaveToFile(SaveFileLocation);
  slist.Free;
  
end;


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

end.
 