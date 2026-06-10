unit UMRulesComp;

interface

uses
  controls,
  classes,
  grids,
  Sysutils,
  extctrls,
  gnugettext;

type

  TMRulesComp = class(TPanel)
    constructor CreateRulesComp(AOwner: TWinControl);
    destructor  Destroy; override;
    procedure   UpdateROData(list: TList);
    procedure   UpdateOOData(list: TList; Before: boolean);
  private
    m_sg:       TStringGrid;
  end;

implementation

uses
  UMCompat,
  Graphics,
  UMCompatRules,
//  UMSchedObjMover,
  UMObjCont,
  UMRes;

//----------------------------------------------------------------------------//

constructor TMRulesComp.CreateRulesComp(AOwner: TWinControl);
begin
  inherited Create(AOwner);

  Parent  := AOwner;
  Visible := true;
  Align   := alClient;

  m_sg                  := TStringGrid.Create(self);
  m_sg.Parent           := self;
  m_sg.Align            := alClient;
  m_sg.Options          := m_sg.Options + [goRowSelect] - [goRangeSelect] + [goColSizing];
  m_sg.FixedCols        := 0;
  m_sg.Color            := clInfoBk;
  m_sg.FixedColor       := clGrayText;
  m_sg.DefaultRowHeight := 20;
  m_sg.DefaultColWidth  := 80;
  m_sg.Visible          := true;

end;

//----------------------------------------------------------------------------//

destructor TMRulesComp.Destroy;
begin
  inherited Destroy;
end;

//----------------------------------------------------------------------------//

procedure TMRulesComp.UpdateROData(list: TList);
var
  i:        integer;
  compRepo: PTPropCompRepo;
  checkSeq: integer;
  toBase: string;
  op : TRuleOpType;
  value: variant;
  comp: TCompatVal;
begin
  m_sg.RowCount := list.Count+1;

  m_sg.ColCount   := 7;
  m_sg.ColWidths[0] := 205;
  m_sg.ColWidths[1] := 120;
  m_sg.ColWidths[2] := 110;
  m_sg.ColWidths[3] := 50;
  m_sg.ColWidths[4] := 110;
  m_sg.ColWidths[5] := 90;
  m_sg.Cells[0,0] := _('Property');
  m_sg.Cells[1,0] := _('Tested value');
  m_sg.Cells[2,0] := _('Rule');
  m_sg.Cells[3,0] := _('Case');
  m_sg.Cells[4,0] := _('Operand');
  m_sg.Cells[5,0] := _('Rule value');
  m_sg.Cells[6,0] := _('Base value');

  for i := 0 to list.Count-1 do
  begin
    compRepo := PTPropCompRepo(list[i]);
    m_sg.Cells[0,i+1] := GetPropCodeFromID(compRepo.pId) + ' ' + GetPropDescr(compRepo.pId);

    if Assigned(compRepo.rule)
    and (compRepo.pos >= 0) then
    begin
      compRepo.rule.GetItem(compRepo.pos, checkSeq, toBase, value, op, comp);

      m_sg.Cells[1,i+1] := compRepo.jobPropVal;

      if assigned(compRepo.propRes) then
      begin
        case op of
               RO_VRplus: m_sg.Cells[2,i+1] := _('Between ') + FormatToShow(compRepo.pId, compRepo.propRes.m_val) +
                                               _(' and ') + FormatToShow(compRepo.pId, (compRepo.propRes.m_val+value));
              RO_VRminus: m_sg.Cells[2,i+1] := _('Between ') + FormatToShow(compRepo.pId, (compRepo.propRes.m_val-value)) +
                                               _(' and ') + FormatToShow(compRepo.pId, compRepo.propRes.m_val);
           RO_VRpercPlus: m_sg.Cells[2,i+1] := _('Between ') + FormatToShow(compRepo.pId, compRepo.propRes.m_val) +
                                               _(' and ') + FormatToShow(compRepo.pId, (compRepo.propRes.m_val*(1+value/100)));
          RO_VRpercMinus: m_sg.Cells[2,i+1] := _('Between ') + FormatToShow(compRepo.pId, (compRepo.propRes.m_val*(1-value/100))) +
                                               _(' and ') + FormatToShow(compRepo.pId, compRepo.propRes.m_val);
        else
          if toBase = '1' then
            m_sg.Cells[2,i+1] := RTtypeToChar(op) + ' ' + FormatToShow(compRepo.pId, compRepo.propRes.m_val)
          else
            m_sg.Cells[2,i+1] := RTtypeToChar(op) + ' ' + FormatToShow(compRepo.pId, value);
        end;
      end else
        m_sg.Cells[2,i+1] := _('Error');

      m_sg.Cells[3,i+1] := IntToStr(comp);
      m_sg.Cells[4,i+1] := RTtypeToChar(op);

      case op of
        RO_VRplus,
        RO_VRminus,
        RO_VRpercPlus,
        RO_VRpercMinus: m_sg.Cells[5,i+1] := FormatToShow(compRepo.pId, value);
      else
        if toBase = '1' then
          m_sg.Cells[5,i+1] := _('From base')
        else
          m_sg.Cells[5,i+1] := FormatToShow(compRepo.pId, value);
      end;

      if assigned(compRepo.propRes) then
        m_sg.Cells[6,i+1] := FormatToShow(compRepo.pId, compRepo.propRes.m_val)
      else
        m_sg.Cells[6,i+1] := _('Error');

    end else
    begin
      m_sg.Cells[1,i+1] := compRepo.jobPropVal;
      m_sg.Cells[2,i+1] := '--';
      if assigned(compRepo.propRes) then
        m_sg.Cells[3,i+1] := FormatToShow(compRepo.pId, compRepo.propRes.m_dfltResOcc)
      else
        m_sg.Cells[3,i+1] := _('Error');
      m_sg.Cells[4,i+1] := '--';
      m_sg.Cells[5,i+1] := '--';
      if assigned(compRepo.propRes) then
        m_sg.Cells[6,i+1] := FormatToShow(compRepo.pId, compRepo.propRes.m_val)
      else
        m_sg.Cells[6,i+1] := _('Error');
    end;
  end
end;

//----------------------------------------------------------------------------//

procedure TMRulesComp.UpdateOOData(list: TList; Before: boolean);
var
  i:        integer;
  compRepo: PTPropCompRepo;
  checkSeq: integer;
  toBase: string;
  op: TRuleOpType;
  value: variant;
  comp: TCompatVal;
  SetupRec : PTSetupRec;
  Setup, OrigSetup, DurTime: double;
  TmgDescr,TmgMSC, NewSetupTime: string;
  iValue, iCode: Integer;
begin
  m_sg.RowCount := list.Count+1;

  m_sg.ColCount      := 17;//16;//12;//13;//14;
  m_sg.ColWidths[0] := 205;
  m_sg.ColWidths[1] := 120;
  m_sg.ColWidths[2] := 110;
  m_sg.ColWidths[3] := 50;
  m_sg.ColWidths[4] := 110;
  m_sg.ColWidths[5] := 130;

  m_sg.ColWidths[6] := 110;
  m_sg.ColWidths[7] := 160;
  m_sg.ColWidths[8] := 120;
  m_sg.ColWidths[9] := 110;
  m_sg.ColWidths[10] := 110;
  m_sg.ColWidths[11] := 110;
  m_sg.ColWidths[12] := 110;
  m_sg.ColWidths[13] := 170;
  m_sg.ColWidths[14] := 195;
  m_sg.ColWidths[15] := 120;
  m_sg.ColWidths[16] := 170;

  m_sg.Cells[0,0]  := _('Property');
  m_sg.Cells[1,0]  := _('Tested value');
  m_sg.Cells[2,0]  := _('Value on bar');
  m_sg.Cells[3,0]  := _('Rule');
  //m_sg.Cells[4,0]  := _('Depend on value');
  m_sg.Cells[4,0]  := _('Case');
  m_sg.Cells[5,0]  := _('Setup change');
  //m_sg.Cells[6,0]  := _('New setup time');
  m_sg.Cells[6,0]  := _('Same group');
  m_sg.Cells[7,0]  := _('Setup overlap time');
 // m_sg.Cells[8,0]  := _('Minimum gap minutes');

  m_sg.Cells[8,0]  := _('Teoreticl work center');
  m_sg.Cells[9,0]  := _('Duration');
  m_sg.Cells[10,0] := _('LeadTime');

  m_sg.Cells[11,0]  := _('From Pos');
  m_sg.Cells[12,0]  := _('Length');
  m_sg.Cells[13,0]  := _('Number Of decimals');
  m_sg.Cells[14,0]  := _('When Ok Next Sequence');
  m_sg.Cells[15,0]  := _('Sequence');
  m_sg.Cells[16,0]  := _('Learning curve code');

 // m_sg.Cells[8,0] := _('Operand');
 // m_sg.Cells[9,0] := _('Rule value');
 // m_sg.Cells[10,0] := _('Setup rule');
 // m_sg.Cells[11,0] := _('Overlapping rule');

  p_pl.GetMainTimings(OrigSetup, DurTime, TmgDescr, TmgMSC);

  for i := 0 to list.Count-1 do
  begin
    compRepo := PTPropCompRepo(list[i]);
    m_sg.Cells[0,i+1] := GetPropCodeFromID(compRepo.pId) + ' ' + GetPropDescr(compRepo.pId);

    if Assigned(compRepo.rule)
    and (compRepo.pos >= 0)
    and (compRepo.inJob = 0) then
    begin
      SetupRec := compRepo.rule.GetItem(compRepo.pos, checkSeq, toBase, value, op, comp);

      val(compRepo.jobPropValPartial, iValue, iCode);
      if (iCode = 0) or (iCode = 2) then // number
      begin
        compRepo.jobPrecPropVal := compRepo.jobPrecPropValPartial;//compRepo.jobPropValPartial;
        compRepo.jobPropVal     := compRepo.jobPropValPartial;//compRepo.jobPrecPropValPartial;
      end
      else if (compRepo.jobPropValPartial <> '') and (compRepo.jobPrecPropValPartial <> '') then
      begin
        compRepo.jobPrecPropVal := compRepo.jobPrecPropValPartial;//compRepo.jobPropValPartial;
        compRepo.jobPropVal     := compRepo.jobPropValPartial;//compRepo.jobPrecPropValPartial;
      end;

      if Before then
      begin
        m_sg.Cells[1,i+1] := compRepo.jobPrecPropVal;
        m_sg.Cells[2,i+1] := compRepo.jobPropVal
      end else
      begin
        m_sg.Cells[1,i+1] := compRepo.jobPropVal;
        m_sg.Cells[2,i+1] := compRepo.jobPrecPropVal
      end;

      if assigned(SetupRec) then
      begin
        case op of
               RO_VRplus: m_sg.Cells[3,i+1] := _('Between ') + ' ' + FormatToShow(compRepo.pId, compRepo.jobPrecPropVal) + ' ' +
                                               _(' and ') +  ' ' + FormatToShow(compRepo.pId, (compRepo.jobPrecPropVal+SetupRec.Value));
              RO_VRminus: m_sg.Cells[3,i+1] := _('Between ') + ' ' + FormatToShow(compRepo.pId, (compRepo.jobPrecPropVal-SetupRec.Value)) + ' ' +
                                               _(' and ') +  ' ' + FormatToShow(compRepo.pId, compRepo.jobPrecPropVal);
           RO_VRpercPlus: m_sg.Cells[3,i+1] := _('Between ') + ' ' + FormatToShow(compRepo.pId, compRepo.jobPrecPropVal) + ' ' +
                                               _(' and ') + ' ' + FormatToShow(compRepo.pId, (compRepo.jobPrecPropVal*(1+SetupRec.Value/100)));
          RO_VRpercMinus: m_sg.Cells[3,i+1] := _('Between ') + ' ' + FormatToShow(compRepo.pId, (compRepo.jobPrecPropVal*(1-SetupRec.Value/100))) + ' ' +
                                               _(' and ') + ' ' + FormatToShow(compRepo.pId, compRepo.jobPrecPropVal);
        else
          if (toBase = '1') or (toBase = '2')
          or (toBase = '6') or (toBase = '7') then
            m_sg.Cells[3,i+1] := RTtypeToChar(op) + ' ' + FormatToShow(compRepo.pId, SetupRec.Value)
          else
            m_sg.Cells[3,i+1] := RTtypeToChar(op) + ' ' + FormatToShow(compRepo.pId, compRepo.jobPrecPropVal);
        end;
      end else
        m_sg.Cells[3,i+1] := _('Error');
      //Depend on value has been deleted
      //if toBase = '1' then
      //  m_sg.Cells[4,i+1] := FormatToShow(compRepo.pId, compRepo.jobPrecPropVal)
     // else
     //   m_sg.Cells[4,i+1] := '--';

      if (toBase = '5')
      or (toBase = '6')
      or (toBase = '7') then
        m_sg.Cells[4,i+1] := '+ ' + IntToStr(comp)
      else
        m_sg.Cells[4,i+1] := IntToStr(comp);

      setup := CalcSetupFormula(SetupRec.supAdjType,
                            OrigSetup, SetupRec.supTime, SetupRec.supMult, SetupRec.AddToSetup);

      if SetupRec.supAdjType = CSA_AddTot then //Eran//
      begin
        //m_sg.Cells[5,i+1] := _('Add globally');
        //m_sg.Cells[6,i+1] := _('Global add ') + ' ' +  FloatToStr(SetupRec.supTime)
        NewSetupTime := _('Global add ') + ' ' +  FloatToStr(SetupRec.supTime)

      end else
      begin

        if setup = OrigSetup then
        begin
          //m_sg.Cells[5,i+1] := _('No change');
          //m_sg.Cells[6,i+1] := FloatToStr(OrigSetup);
          NewSetupTime := FloatToStr(OrigSetup);

        end else
        begin
          m_sg.Cells[5,i+1] := FloatToStr(setup - OrigSetup);
          if (setup - OrigSetup) > 0 then
            m_sg.Cells[5,i+1] := '+' + NewSetupTime;//m_sg.Cells[6,i+1];
          //m_sg.Cells[6,i+1] := FloatToStr(Setup);
          NewSetupTime := FloatToStr(Setup);
        end;

      end;

      case SetupRec.supAdjType of
        CSA_copy:  m_sg.Cells[5,i+1] := _('No');
        CSA_add:   m_sg.Cells[5,i+1] := _('Add') + ' ' + FloatToStr(SetupRec.supTime);
        CSA_const: m_sg.Cells[5,i+1] := _('Fix') + ' ' + FloatToStr(SetupRec.supTime);
        CSA_mult:  m_sg.Cells[5,i+1] := _('Mult.') + ' ' + FloatToStr(SetupRec.supMult);
        CSA_AddTot: m_sg.Cells[5,i+1] := _('Global add') + ' ' + FloatToStr(SetupRec.supTime); //Eran//
      end;

      if SetupRec.onSameGroup then
        m_sg.Cells[6,i+1] := _('Yes')
      else
        m_sg.Cells[6,i+1] := _('No');

      m_sg.Cells[7,i+1] := FloatToStr(SetupRec.supOverlap);

    //  m_sg.Cells[8,i+1] := FloatToStr(SetupRec.MinGapMinutes);

      m_sg.Cells[8,i+1] := SetupRec.teoreticl_wc;
      m_sg.Cells[9,i+1] := FloatToStr(SetupRec.duration);
      m_sg.Cells[10,i+1] := FloatToStr(SetupRec.LeadTime);

      m_sg.Cells[11,i+1] := FloatToStr(SetupRec.FromPos);
      m_sg.Cells[12,i+1] := FloatToStr(SetupRec.Length);
      m_sg.Cells[13,i+1] := FloatToStr(SetupRec.NumOfdec);
      m_sg.Cells[14,i+1] := FloatToStr(SetupRec.WhenOkNextSeq);
      m_sg.Cells[15,i+1] := IntToStr(SetupRec.Sequence);
      m_sg.Cells[16,i+1] := SetupRec.CurveCode;


    //  m_sg.Cells[8,i+1] := RTtypeToChar(op);
    {
      case op of
        RO_VRplus,
        RO_VRminus,
        RO_VRpercPlus,
        RO_VRpercMinus: m_sg.Cells[9,i+1] := FormatToShow(compRepo.pId, SetupRec.Value);
      else
        if toBase = '1' then
          m_sg.Cells[9,i+1] :=  FormatToShow(compRepo.pId, SetupRec.Value)
        else
          m_sg.Cells[9,i+1] :=  FormatToShow(compRepo.pId, compRepo.jobPrecPropVal);
      end;

      case SetupRec.supAdjType of
        CSA_copy:  m_sg.Cells[10,i+1] := _('No');
        CSA_add:   m_sg.Cells[10,i+1] := _('Add') + ' ' + FloatToStr(SetupRec.supTime);
        CSA_const: m_sg.Cells[10,i+1] := _('Fix') + ' ' + FloatToStr(SetupRec.supTime);
        CSA_mult:  m_sg.Cells[10,i+1] := _('Mult.') + ' ' + FloatToStr(SetupRec.supMult);
        CSA_AddTot: m_sg.Cells[10,i+1] := _('Global add') + ' ' + FloatToStr(SetupRec.supTime); //Eran//
      end;
     }
{  Eran/avi    if SetupRec.supMultOverlap = 0 then
        m_sg.Cells[13,i+1] := _('No')
      else
      begin
        if SetupRec.supMultOverlap = 1 then
          TmpStr := _('Add')
        else
          if SetupRec.supMultOverlap = 2 then
            TmpStr := _('Fix')
          else
            if SetupRec.supMultOverlap = 3 then
              TmpStr := _('Mult.')
              else
                if SetupRec.supMultOverlap = 4 then
                  TmpStr := _('Global add');

        m_sg.Cells[13,i+1] := TmpStr + ' ' + FloatToStr(SetupRec.supOverlap);
      end;  }
   {
      if SetupRec.supAdjType = CSA_copy then
        m_sg.Cells[11,i+1] := _('No')
      else
      begin
        if SetupRec.supAdjType = CSA_add then
          TmpStr := _('Add')
        else
          if SetupRec.supAdjType = CSA_const then
            TmpStr := _('Fix')
          else
            if SetupRec.supAdjType = CSA_mult then
              TmpStr := _('Mult.')
              else
                if SetupRec.supAdjType = CSA_AddTot then
                  TmpStr := _('Global add');

        if SetupRec.supOverlap = 0 then
          TmpStr := '';

        m_sg.Cells[11,i+1] := TmpStr + ' ' + FloatToStr(SetupRec.supOverlap);
      end;
     }
    end else
    begin

      val(compRepo.jobPropValPartial, iValue, iCode);
      if (iCode = 0) or (iCode = 2) then  // number
      begin
        compRepo.jobPrecPropVal := compRepo.jobPrecPropValPartial;//compRepo.jobPropValPartial;
        compRepo.jobPropVal     := compRepo.jobPropValPartial;//compRepo.jobPrecPropValPartial;
      end
      else if (compRepo.jobPropValPartial <> '') and (compRepo.jobPrecPropValPartial <> '') then
      begin
        compRepo.jobPrecPropVal := compRepo.jobPrecPropValPartial;//compRepo.jobPropValPartial;
        compRepo.jobPropVal     := compRepo.jobPropValPartial;//compRepo.jobPrecPropValPartial;
      end;

      if Before then
      begin
        m_sg.Cells[1,i+1] := compRepo.jobPrecPropVal;
        m_sg.Cells[2,i+1] := compRepo.jobPropVal
      end else
      begin
        m_sg.Cells[1,i+1] := compRepo.jobPropVal;
        m_sg.Cells[2,i+1] := compRepo.jobPrecPropVal
      end;
      m_sg.Cells[3,i+1] := '--';
     // m_sg.Cells[4,i+1] := '--';   Depend on value deleted
      if assigned(compRepo.propRes) then
        m_sg.Cells[4,i+1] := FormatToShow(compRepo.pId, compRepo.propRes.m_dfltOccOcc)
      else
        m_sg.Cells[4,i+1] := _('Error');
      m_sg.Cells[5,i+1] := _('No change');
      m_sg.Cells[6,i+1] := FloatToStr(OrigSetup);
      m_sg.Cells[6,i+1] := '--';
      m_sg.Cells[7,i+1] := '--';
      m_sg.Cells[14,i+1] := FloatToStr(compRepo.WhenOkNextSeq);
      m_sg.Cells[15,i+1] := IntToStr(0);
      m_sg.Cells[16,i+1] :=  '--';

     // m_sg.Cells[8,i+1] := '--';
     /// m_sg.Cells[9,i+1] := '--';
    //  m_sg.Cells[10,i+1] := '--';
    //  m_sg.Cells[11,i+1] := '--';
    end;
  end
end;

//----------------------------------------------------------------------------//

end.
