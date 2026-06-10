//******************************************************************************
// This unit exports the data of the rows in the Bin to an Excel file.
// The Excel file is made by the mxNativeExcel unit
// has just one procedure BinToExcelExport which makes the above
//******************************************************************************
unit UMBinToExcel;

interface
  uses
    UMSchedContFunc, SysUtils, mxNativeExcel, UMBinGrid, gnugettext;
    
  procedure BinToExcelExport(NativeExcel: TmxNativeExcel; SaveFileLocation: String);
  function IsInteger(Arg : string) : Boolean;
  function getPropertyDesc(Acol: Integer; binGrid: TBinDrawGrid): String;
  
implementation

uses
  variants,
  FMBin,
  UMBinDefault,
  UMBinTbs,
  UMBinPanel,
  UMGlobal,
  UMSchedCont,
  UMObjCont,
  FMBinTotals,
  UMBinReport,
  FMMainPlan,
  UMCompat, Dialogs;
{
//******************************************************************************
  This procedure generates an Excel file out of the Bin data.
  And is very similiar to UMBinReport which generates an Html file.
  It loops over all the bin rows and writes them in the Excel file.
  @param NativeExcel the Excel object - is sent from FMMainPlan
  @param SaveFileLocation The name of the file to save in
}
procedure BinToExcelExport(NativeExcel: TmxNativeExcel; SaveFileLocation: String);
var
  i, j{, row, column}: Integer;
  stepTypeIndex, StepGroupIndex, pos: Integer;
  NumberOfRowsInBin{, IntegerValue}: Integer;
  FloatValue: double;
  Field,
  FieldValue,
  SchedType:      String;
  Value: Variant;
  ActTab: TBinTabSheet;
  ActBinGrid : TBinDrawGrid;
  id: TschedID;
  ColAttributes: TBinColCurrent;
  dataType:  CBinColValType;
begin
  stepTypeIndex := -1;
  StepGroupIndex := -1;
  ActTab := FBin.GetActiveView;
  ActbinGrid := ActTab.GetBinGrid;
  NumberOfRowsInBin := TBinPanel(ActbinGrid.Parent).m_ObjList.GetLinkCount;
 // CalcTotals(notSchedCounter,SchedCounter,
 //            notSchedQuantity,SchedQuantity);

   With NativeExcel Do
     Begin
       NewFile;

       FileName := SaveFileLocation;
       //added a font for use in excel takes the attributes from that
       //font from FMMainPlan will be font 0
       AddFont(FMQMPlan.ExcelFontBold.Font);
       {
       SetLeftMargin( 0.30 ); // ** This value has to be in inches **
       SetBottomMargin( 2.30 ); // ** This value has to be in inches **
       SetTopMargin( 0.30 ); // ** This value has to be in inches **
       SetRightMargin( 0.30 ); // ** This value has to be in inches **
       //SetColumnWidth( Column, 7 );
       }
       SetHeader( 'MQM - Bin extraction' );//The header that will appear in print
       SetFooter( '&N &P' ); //The Footer of the printed excel file

       Row := 1;
       Column := 1;

       
       shading := true;
       ActiveFont := 0;  //what font to use
       Alignment:= eaCenter;  //Alignment of the Cells

       WriteLabel(Row,Column, _('Row no.') );

       if DBAppSettings.FixColStatVis then
         WriteLabel(Row,Column, _('Status'));

       //Loop over the column headers
       for i:= 0 to High(BinColDefault)-1 do
       begin
         pos := ActbinGrid.findpos(i);//position of the header in the bin
         ColAttributes := ActbinGrid.BinColumnSet[pos];
          if  ColAttributes.Field = CSC_MsgFromHost then continue;
       if  ColAttributes.Visible then
       begin
         //field := ColAttributes.Title;
         field := getPropertyDesc(pos,ActbinGrid);
         WriteLabel(Row,Column,_(field));

         //so that we can replace the number with text
        // if field = _('Step Type') then stepTypeIndex := i;
        //   if field = _('Step Group') then stepGroupIndex := i;
         if ColAttributes.Field = CSC_StepType then stepTypeIndex := i;
         if ColAttributes.Field = CSC_ReprocNo then stepTypeIndex := i;
      end;
    end;//for


    shading := false;
    ActiveFont := 1;  //normal font
  
    //Loop over all the rows of the bin
    for i := 0 to NumberOfRowsInBin do
    begin
      Column := 1;
      Row := Row +1;
      id := TSchedId(TBinPanel(ActbinGrid.Parent).m_ObjList.GetLink(i));
      if id <> CSchedIdNull then
      begin
        WriteLabel(Row,Column,IntToStr(i + 1));  //row Number

       //Print Status column
        if DBAppSettings.FixColStatVis then
        begin
          if isClosed(id) = false then
          begin
            case p_sc.IsProgressed(id) of
              prg_Starting:   WriteLabel(Row,Column,_('Started'));
              prg_General:    WriteLabel(Row,Column,_('Progressed'));
              prg_Final,
              prg_FinalSplit: WriteLabel(Row,Column,_('Ended'));
              else
              begin
              SchedType := p_sc.GetSchedType(id);
                if (SchedType = '1') then
                  WriteLabel(Row,Column,_('Temporarily'))
                else if (SchedType = '2') then
                  WriteLabel(Row,Column,_('Fixed'))
                else if (SchedType = '4') then
                  WriteLabel(Row,Column,_('Level') + ' ' + '1')
                else if (SchedType = '5') then
                  WriteLabel(Row,Column,_('Level') + ' ' + '2')
                else if (SchedType = '6') then
                  WriteLabel(Row,Column,_('Level') + ' ' + '3')
                else if (SchedType = '7') then
                  WriteLabel(Row,Column,_('Level') + ' ' + '4')
                else if (SchedType = '8') then
                  WriteLabel(Row,Column,_('Level') + ' ' + '5')
                else
                  WriteLabel(Row,Column,'----');
              end;
            end;//case
          end;//if open

        if isClosed(id) = true then WriteLabel(Row,Column,_('Closed'));

       end;//Show status

        //loop over all columns of row in bin
        for j:= 0 to High(BinColDefault)-1 do
        begin
          try
          pos := ActbinGrid.findpos(j);
          ColAttributes := ActbinGrid.BinColumnSet[pos];
          if  ColAttributes.Field = CSC_MsgFromHost then continue;
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
                 WriteLabel(Row,Column,FieldValue);
                 continue;
              end;
              
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
                if FieldValue = '----' then
                begin
                   WriteLabel(Row,Column,FieldValue);
                   continue;
                end;
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

         except
          MessageDlg('An error occured, aborting', mtError, [mbOK], 0);
          abort;
         end;

         end;//j Column Loop
     end;//if
  end;//i Rows Loop

  CloseFile;
  SaveToFile;
  End;
End;


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

function getPropertyDesc(Acol: Integer; binGrid: TBinDrawGrid): String;
var
  num: Integer;
  pId: TPropId;
begin
  Result := '';
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
    if pId <> nil then
      Result := GetPropDescr(pId);
  end else
    Result := binGrid.BinColumnSet[Acol].Title
end;

end.
