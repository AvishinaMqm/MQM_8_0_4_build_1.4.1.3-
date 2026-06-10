unit UMPlanGraph;

interface

uses
  extctrls,
  controls,
  classes,
  Sysutils,
  Graphics,
  Menus,
  Windows,
  UMProdLine,
  UGshapeMan,
  UGCal,
  UGGanttPanel,
  UMSchedContFunc,
  UMCompatSrv,
  UMRes, gnugettext;

type

  TMqmGanttConst = class(TGanttConst)
    VO_RS: integer;   // vert. offset of resources from top of resource line
    OO_RS: integer;   // orizon. offset of resources from calendar line
  end;

  TMqmShapeType = (st_ActArea, st_Warp_1lvl, st_Warp_2lvl, st_CapRes, st_DownTime, st_CrossDownTime, st_Group, st_schedObj, st_Compat);

  procedure TransRectangle(Canvas:TCanvas; R:TRect; C:TColor);
  procedure TransRectangle2(Canvas:TCanvas; R:TRect; C:TColor);

  function  CalcPos(date: TDateTime; calcObj: TObject): integer;
  function  CalcDate(pos: integer; calcObj: TObject): TDateTime;
  function  CalcWdw(isLeft: boolean; calcObj: TObject): TDateTime;
  procedure DrawRes(parms: PTRowParms; assObj: TObject; Canvas: TCanvas; x1,y1: integer);
  procedure DrawActArea(Canvas: TCanvas; parms: PTRowParms; const rect: TRect; const IntPt, MatPt: integer);
  procedure DrawCapRes(Canvas: TCanvas; parms: PTRowParms; const rect: TRect; const IntPt, MatPt: integer);
  procedure DrawWarp(Canvas: TCanvas; parms: PTRowParms; const rect: TRect; const IntPt, MatPt: integer);
  procedure DrawGroup(Canvas: TCanvas; parms: PTRowParms; const rect: TRect; const IntPt, MatPt: integer);
  procedure DrawSchedObj(Canvas: TCanvas; parms: PTRowParms; const rect: TRect; const IntPt, MatPt: integer; Trans : Boolean);
  procedure DrawCmp(Canvas: TCanvas; parms: PTRowParms; const rect: TRect; const IntPt, MatPt: integer);
  procedure MsUp(parms: PTRowParms; date: TDateTime; mouObj: TObject; Button:TMouseButton; isRes, isBk, SubResBtnClick: boolean);
  procedure MsMove(parms: PTRowParms; x,y: integer; mouObj: TObject);
  procedure SetDrawPos(var PercTop: double; var PercHeight: double; ShapeType: TMqmShapeType);
  function  GetErrorDesc(ErrIndex: CScErrors): string;
  procedure LinkAssPropAndDraw(Link: PTLink; Canvas: TCanvas; assObj: TObject; shMan: TShapeManager);

  function  GetGroupProp(pId: TSchedID; ptr: pointer): TProperties;

const
  ZOOM_CONST = 20;
  Corner_Radius = 3;

var FilledLine : Integer;
var SavedFont  : integer = 0;

implementation

uses
  UMSchedCont,
  UMGlobal,
  UMCompat,
  UMCmp,
  UMCapRes,
  UMWarp,
  UMCompatRules,
  FMOccMov,
  UMObjCont,
  UMCompatClr,
  FMMainPlan,
  UMActArea,
  UMPlanObj,
  UMBinFunc,
  FMGroupDetail,
  FMOORulesCase,
  FMRORulesCase,
  FMBin,
  FMCreateWarp,
  FMCreateCapRes,
  FMCrtDownTime,
  UMWkCtr,
  UGGraph,
  Dialogs,
  DMsrvPc,
  UMArticles,
  UMBalance,
  UMDurObj,
  UMSchedList,
  Vcl.Forms,
  FMShowColorsBar,
  UMPlan, Types, DateUtils,
  UMPlanTbs,
  UMTabcfg, dxGDIPlusClasses,
  cxGraphics, Math, dxCoreGraphics;
  //---------------//


//----------------------------------------------------------------------------//

procedure MsUp(parms: PTRowParms; date: TDateTime; mouObj: TObject;
               button: TMouseButton; isRes, isBk, SubResBtnClick: boolean);
var
  ftm:      TFMQMPlan;
  planInfo: TSQplanInfo;
  isGrp:    boolean;
  mqmObj:   TMqmObj;
  id:       TSchedId;
  idComp,DammyId:   TSchedId;
  capRes:   TMqmCapRes;
  Warp:     TMqmWarp;
  res:      TMqmRes;
  NewStart, OrigStart : TDateTime;
  WarpDur, MatQtyRequired : double;
  ConfTab: TPlanTabCfg;
  i : Integer;
begin
  DMib.m_MainDB.Ping;  // will be catched by CommunicationException in case ping failed
  Assert(Assigned(mouObj));
  ftm := TFMQMPlan(mouObj);

  if not Assigned(parms) then
  begin
    if Button = mbRight then
      ftm.PUpPlan.Popup(Mouse.CursorPos.x, Mouse.CursorPos.y);
    exit;
  end;

  id     := CSchedIdNull;
  mqmObj := nil;

  if Button = mbLeft then
  begin

    if parms.isContObj then
      id := TSchedID(parms.objPtr)
    else
      mqmObj := TMqmObj(parms.objPtr);

    // working with a resource, active planning area or a capacity reservation
    if GetOccMoveForm <> nil then
    begin
      GetOccMoveForm.Reset;

      // fp - temp... or not temp?
      // exit if click over the same object
      if GetOccMoveForm.p_ObjMover.p_ID = id then exit;

      if parms.isContObj then
      begin

        p_sc.GetPlanInfo(id, planInfo);
        if (planInfo.endDate - date) < (date - planInfo.StartDate) then
          // right side
          ChangeOccTo(TMqmActArea(p_sc.GetExtLinkPtr(id)), 0{planInfo.endDate}, false, id, false)
        else
          // left side
          ChangeOccTo(TMqmActArea(p_sc.GetExtLinkPtr(id)), 0{planInfo.StartDate}, true, id, false);
      end else
        if mqmObj is TMqmActArea then
        begin
          TMqmActArea(mqmObj).P_ActArea_UserClick := true;
          ChangeOccTo(TMqmActArea(mqmObj), date, false, CSchedIDnull, true);
          TMqmActArea(mqmObj).P_ActArea_UserClick := false;
        end
        else
          if mqmObj is TMqmWarp then
          begin
            Warp := TMqmWarp(mqmObj);
            if (p_pl.GetCompatModeInPlanId <> CSchedIDnull) then
            begin
              if not p_sc.CheckItemAndProductForWarp(TMqmWarp(Warp).Get_M_id, p_pl.GetCompatModeInPlanId, false, DammyId, MatQtyRequired) then
                ChangeOccTo(TMqmActArea(p_sc.GetExtLinkPtr_Material(TMqmWarp(Warp).Get_M_id)), Warp.p_end, false, CSchedIDnull, true)
              else
                ChangeOccTo(TMqmActArea(p_sc.GetExtLinkPtr_Material(TMqmWarp(Warp).Get_M_id)), Warp.p_start, false, CSchedIDnull, true)
            end;      //TMQMActArea(Warp.p_Father) // alternative to the nil that was given back from the stack
          end                                      // avi 090922
          else if mqmObj is TMqmCapRes then
          begin
            capRes := TMqmCapRes(mqmObj);
            if (capRes.p_end - date) < (date - capRes.p_start) then
              // right side
              ChangeOccTo(TMqmActArea(capRes.p_Father), capRes.p_end, false, CSchedIDnull, false)
            else
              // left side
              ChangeOccTo(TMqmActArea(capRes.p_Father), capRes.p_start, true, CSchedIDnull, false);
          end;
      exit
    end;

    if IsGroupFormOut then
    begin
      if parms.isContObj then
      begin
        p_sc.GetPlanInfo(id, planInfo);
        SetTargetVisRes(TMqmVisibleRes(TMqmActArea(p_sc.GetExtLinkPtr(id)).p_father))
      end
      else if mqmObj is TMqmActArea then
        SetTargetVisRes(TMqmVisibleRes(TMqmActArea(mqmObj).p_father))
      else if mqmObj is TMqmVisibleRes then
        SetTargetVisRes(TMqmVisibleRes(mqmObj));
      exit
    end;

    if GetCrtCapResForm <> nil then
    begin
      if (mqmObj is TMqmActArea) then
        GetCrtCapResForm.setDataFromPlan(TMqmActArea(mqmObj), date)
      else if mqmObj is TMqmCapRes then
      begin
        capRes := TMqmCapRes(mqmObj);
        GetCrtCapResForm.setDataFromPlan(TMqmActArea(capRes.p_father), capRes.p_end);
      end else
      if parms.isContObj then
      begin
        p_sc.GetPlanInfo(id, planInfo);
        GetCrtCapResForm.setDataFromPlan(TMqmActArea(p_sc.GetExtLinkPtr(id)), planInfo.endDate);
      end;
      exit
    end;

    if GetCrtWarpForm <> nil then
    begin
      if (mqmObj is TMqmActArea) then
        GetCrtWarpForm.MoveToNewPosition(TMqmActArea(mqmObj), date, false)
      else if mqmObj is TMqmCapRes then
      begin
        capRes := TMqmCapRes(mqmObj);
        if (capRes.p_end - date) < (date - capRes.p_start) then
              // right side
          GetCrtWarpForm.MoveToNewPosition(TMqmActArea(capRes.p_Father), capRes.p_end, false)
        else
              // left side
          GetCrtWarpForm.MoveToNewPosition(TMqmActArea(capRes.p_Father), capRes.p_start, true);
      end else if mqmObj is TMqmWarp then
      begin
        Warp := TMqmWarp(mqmObj);

        if GetCrtWarpForm.GetWarpId = Warp.Get_M_id then
          Exit
        else
        begin
          if GetCrtWarpForm.GetWarpLvl <> Warp.m_WarpLvl then
            GetCrtWarpForm.MoveToNewPosition(TMqmActArea(Warp.p_Father), Warp.p_start, false)
          else
          begin
            if (Warp.p_end - date) < (date - Warp.p_start) then
              // right side
              GetCrtWarpForm.MoveToNewPosition(TMqmActArea(Warp.p_Father), Warp.p_end, false)
            else
              // left side
              GetCrtWarpForm.MoveToNewPosition(TMqmActArea(Warp.p_Father), Warp.p_start, true);
          end;
        end;

      end else
      if parms.isContObj then
      begin
        p_sc.GetPlanInfo(id, planInfo);
        if (planInfo.endDate - date) < (date - planInfo.StartDate) then
           GetCrtWarpForm.MoveToNewPosition(TMqmActArea(p_sc.GetExtLinkPtr(id)), planInfo.endDate, false)
        else
          GetCrtWarpForm.MoveToNewPosition(TMqmActArea(p_sc.GetExtLinkPtr(id)), planInfo.startDate, true);
      end;
      exit
    end;

    if GetDownTimeForm <> nil then
    begin
      if GetDownTimeForm.GetCapRes.p_CapResNum < 0 then exit;

      if mqmObj is TMqmActArea then
      begin
        if TMqmActArea(mqmObj).FindCapResInSpots(date , NewStart, GetDownTimeForm.GetCapRes, OrigStart) then
          GetDownTimeForm.MoveTo(TMqmActArea(mqmObj), NewStart, -1, false)
        else
          GetDownTimeForm.MoveTo(TMqmActArea(mqmObj), date, -1, false)
      end

      else if mqmObj is TMqmCapRes then
      begin
        capRes := TMqmCapRes(mqmObj);

        if (GetDownTimeForm.p_CapResMover.p_CapResToMove = capRes) then exit;

        if (capRes.p_end - date) < (date - capRes.p_start) then
          // right side
          GetDownTimeForm.MoveTo(TMqmActArea(capRes.p_Father), capRes.p_end, -1, false)
        else
          // left side
          GetDownTimeForm.MoveTo(TMqmActArea(capRes.p_Father), capRes.p_start, -1, true)
      end else
      if parms.isContObj then
      begin
        p_sc.GetPlanInfo(id, planInfo);
        if (planInfo.endDate - date) < (date - planInfo.StartDate) then
          // right side
          GetDownTimeForm.MoveTo(TMqmActArea(p_sc.GetExtLinkPtr(id)), planInfo.endDate, -1, false)
        else
          // left side
          GetDownTimeForm.MoveTo(TMqmActArea(p_sc.GetExtLinkPtr(id)), planInfo.StartDate, -1, true)
      end;

      exit
    end;

    if parms.isContObj then
    begin
      OpenOccMoveForm(FMQMPlan, id, RefreshAfterMove, FMQMPlan, OccMoveEnter, OccMoveExit, false);

      if Assigned(Fbin) and DBAppSettings.ShowInBinOnMove then
        Fbin.FocusBinOnJobID(id, False);
    end
    else
      if mqmObj is TMqmCapRes then
      begin
        capRes := TMqmCapRes(mqmObj);
        case capRes.m_Type of
          cr_Normal, Cr_Dynamic :   OpenCapResForm(FMQMPlan, capRes, RefreshAfterMove, FMQMPlan, TMqmActArea(capRes.p_father),date);
          cr_DownTime, Cr_CrossingDtm : OpenDownTimeForm(FMQMPlan, capRes, RefreshAfterMove, FMQMPlan, TMqmActArea(capRes.p_father), date);
        end
      end
      else if mqmObj is TMqmWarp then
      begin
        Warp := TMqmWarp(mqmObj);
        OpenWarpForm(FMQMPlan, Warp, Warp.Get_M_id, RefreshAfterMove, FMQMPlan, OccMoveEnter, OccMoveExit, TMqmActArea(Warp.p_father));
        if (GetCrtWarpForm <> nil) then
           GetCrtWarpForm.MoveToNewPosition(TMqmActArea(Warp.p_father), Warp.p_start, false)

       // case Warp.m_TypeOfWarp of
       //   cr_Normal, Cr_Dynamic :   OpenCapResForm(FMQMPlan, capRes, RefreshAfterMove, FMQMPlan, TMqmActArea(capRes.p_father),date);
       //   cr_DownTime, Cr_CrossingDtm : OpenDownTimeForm(FMQMPlan, capRes, RefreshAfterMove, FMQMPlan, TMqmActArea(capRes.p_father), date);
      //  end
      end;


    // Check 1st subresource if left click for collapse or expand it
    if SubResBtnClick and (not TMqmVisibleRes(parms.objPtr).p_isSubRes) and
       (TMqmVisibleRes(parms.objPtr).p_SubCode = 1) then // if p_isSubRes is false mean that this visible res is a subresource
    begin
      res := TMqmRes(TMqmVisibleRes(parms.objPtr).p_father);
      ftm.m_popObj := parms.objPtr;

      ConfTab := TPlanTabCfg(FMQMPlan.m_planTbCfg.FindTab(FMQMPlan.m_pgcPlan.GetActiveView.GetCode));

      for i := 0 to ConfTab.IsResExpanded.Count-1 do
      begin

        if res = TMQMRES(TTResExpanded(ConfTab.IsResExpanded[i]).obj) then
        begin
          if TTResExpanded(ConfTab.IsResExpanded[i]).Is_Res_Expanded = 1 then
            FMQMPlan.ExpOrCollSubRes(false)
          else
            FMQMPlan.ExpOrCollSubRes(true);

          break;

        end;
      end;

      {if TMqmVisibleRes(parms.objPtr).p_SubResExpanded then
        FMQMPlan.ExpOrCollSubRes(false)
      else
        FMQMPlan.ExpOrCollSubRes(true) }
    end;

    if FMQMPlan.GetActiveTab.p_shapeMan.m_scroll.Visible then
      FMQMPlan.GetActiveTab.p_shapeMan.m_scroll.SetFocus;
    exit  // button = mbLeft
  end;


  if Button = mbRight then
  begin
    if parms.isContObj then
      id := TSchedID(parms.objPtr)
    else
      mqmObj := TMqmObj(parms.objPtr);

    ftm.m_popDate := date;
//    CapResSelectedDate := date;

    if (GetCrtCapResForm <> nil)
   // or (GetCrtWarpForm <> nil)
    or (GetDownTimeForm <> nil) then exit;

    if isRes then
    begin
      if Assigned(parms.objPtr) then
      begin
        ftm.m_popObj := parms.objPtr;
        if (GetOccMoveForm = nil) and (GetCrtWarpForm = nil) then
          ftm.PopRes.Popup(Mouse.CursorPos.x, Mouse.CursorPos.y)
        else
        begin
          idComp := p_pl.GetCompatModeInPlanId;
          Assert(idComp <> CSchedIdNull);
          res := TMqmRes(TMqmVisibleRes(parms.objPtr).p_father);
          if res.p_occGoodWkc[idComp] and res.p_occHasTimings then
            OpenFrmRtORulesCase(ftm, idComp, res);
        end
      end;
      exit
    end;

    idComp := p_pl.GetCompatModeInPlanId;
//    if GetOccMoveForm <> nil then
    if idComp <> CSchedIdNull then
    begin
      ftm.m_popObj := parms.objPtr;

      Assert(idComp <> CSchedIdNull);

      if parms.isContObj then
        OpenFrmOtORulesCase(ftm, idComp, id);
      exit
    end;

    ftm.m_popObj := parms.objPtr;

    if parms.isContObj then
    begin
      p_sc.GetObjInfo(id, isGrp);
      if isGrp then
        ftm.PupGroup.Popup(Mouse.CursorPos.x, Mouse.CursorPos.y)
      else
        ftm.PupJob.Popup(Mouse.CursorPos.x, Mouse.CursorPos.y);
      exit
    end;

    if mqmObj is TMqmCapRes then
      ftm.PupCapRes.Popup(Mouse.CursorPos.x, Mouse.CursorPos.y)
    else if mqmObj is TMqmWarp then
      ftm.PupWarp.Popup(Mouse.CursorPos.x, Mouse.CursorPos.y)
    else if mqmObj is TMqmActArea then
      ftm.PupActArea.Popup(Mouse.CursorPos.x, Mouse.CursorPos.y)
    else
      ftm.PUpPlan.Popup(Mouse.CursorPos.x, Mouse.CursorPos.y)
  end
end;

//----------------------------------------------------------------------------//

Function GetCompNumFromSubResInSpot(Rsc : TMqmRes; DT : TDateTime) : Double;
var moveChgInfo: TSQmoveChgInfo;
  ActArea : TMqmActArea;
  id: TSchedID;
   VisRes : TMqmVisibleRes;
   w, q : Integer;
   DatesInfo: TSQDatesInfo;
   subqty : Double;
begin

  for q := 0 to rsc.p_VisResList.Count -1 do
  begin

    VisRes := TMqmVisibleRes(rsc.p_VisResList[q]);

    if  not TMqmActArea(VisRes.p_ActArea[0]).p_CheckIfSchedObjsIsAssigned then
      continue;

    ActArea := TMqmActArea(VisRes.p_ActArea[0]);

    for w := 0 to ActArea.p_ObjCount - 1 do
    begin
      id := ActArea.GetSchedObj(w);
      p_sc.GetMoveChgInfo(id, moveChgInfo);
      p_sc.GetDatesInfo(id, DatesInfo);

      if (DatesInfo.StartDate < DT) and (DatesInfo.EndDate > DT) then
      begin

        if VisRes.p_SubCode >= 1 then
          subqty := subqty + moveChgInfo.numOfRscComp;
      end;
    end;
  end;

  result := rsc.p_ResComp - subqty;

end;

//----------------------------------------------------------------------------//

procedure MsMove(parms: PTRowParms; x,y: integer; mouObj: TObject);
var
  ftm:  TFMQMPlan;
  pt : TMqmPlanTabSheet;
  pId : TSchedID;
  moveChgInfo: TSQmoveChgInfo;
  Qty : Double;
  res : TMqmRes;
  VisRes : TMqmVisibleRes;
  TDT : TDateTIme;
  ShowSubResStatusInfo : boolean;
begin
  ShowSubResStatusInfo := false;
  Assert(Assigned(mouObj));
  ftm := TFMQMPlan(mouObj);
  ftm.CleanSBar;

  pt := TMqmPlanTabSheet(ftm.m_pgcPlan.GetActiveView);
  pt.ShowHint := False;

  if Assigned(parms) then
  begin

    if parms.isContObj then
    begin
      ftm.SBarSetSchedObj(parms);

      // If ShowStatusBarAsHint is on, SBarSetSchedObj already set pt.ShowHint and pt.Hint
      // so skip the sub-resource hint below unless not in hint mode
      if not IniAppGlobals.ShowStatusBarAsHint then
      begin
        //Status text on job
        pId := TSchedID(parms.objPtr);
        if pId = CSchedIDnull then exit;
        if not Assigned(TMqmActArea(p_sc.GetExtLinkPtr(pId))) then exit;
        if TMqmActArea(p_sc.GetExtLinkPtr(pId)).p_Father = nil then exit;

        VisRes := TMqmVisibleRes(TMqmActArea(p_sc.GetExtLinkPtr(pId)).p_Father);
        if Assigned(VisRes) and not VisRes.p_isSubRes then // condition should be the oposite
        begin
          ShowSubResStatusInfo := true;
          res := TMqmRes(TMqmPlanObj(VisRes.p_father));
          TDT := pt.p_HeaderMan.m_CalPanel.PixelsToTime(x);
          Qty := GetCompNumFromSubResInSpot(res, tdt);

          //HINT ON JOB
          pt.ShowHint := True;
          try
            if ftm.GetActiveTab.p_shapeMan.m_scroll.Visible then
               ftm.GetActiveTab.p_shapeMan.m_scroll.SetFocus;
            p_sc.GetMoveChgInfo(pId, moveChgInfo);
            pt.hint := 'Components : ' + FloatToStr(moveChgInfo.numOfRscComp);
          except
            pt.hint := '';
          end;
        end;
      end;

    end
    else
    begin
      ftm.SBarSetPlanObj(parms.objPtr);

      //Status text on blank
      if (TMqmPlanObj(parms.objPtr).p_father is TMqmVisibleRes) then
      begin
        VisRes := TMqmVisibleRes(TMqmPlanObj(parms.objPtr).p_father);
        if not VisRes.p_isSubRes then
        begin
          ShowSubResStatusInfo := true;
          res := TMqmRes(TMqmPlanObj(VisRes.p_father));
          TDT := pt.p_HeaderMan.m_CalPanel.PixelsToTime(x);
          Qty := GetCompNumFromSubResInSpot(res, tdt)
        end;
      end;
    end;

  end
  else
    ftm.SBarSetPlanObj(TMqmPlanObj(mouObj));

  ftm.SetMouseDateDesc(x);

  ftm.SetMouseQtyComp(Qty, ShowSubResStatusInfo); //Status text for number of components

end;

//----------------------------------------------------------------------------//

function CalcPos(date: TDateTime; calcObj: TObject): integer;
begin
  Assert(Assigned(calcObj));
  Result := TCalPanel(calcObj).TimeToPixels(date);
end;

//----------------------------------------------------------------------------//

function CalcDate(pos: integer; calcObj: TObject): TDateTime;
begin
  Assert(Assigned(calcObj));
  Result := TCalPanel(calcObj).PixelsToTime(pos);
end;

//----------------------------------------------------------------------------//

function CalcWdw(isLeft: boolean; calcObj: TObject): TDateTime;
begin
  if isLeft then
    Result := TCalPanel(calcObj).LeftTime
  else
    Result := TCalPanel(calcObj).RightTime
end;

//----------------------------------------------------------------------------//

procedure DrawRes(parms: PTRowParms; assObj: TObject; Canvas: TCanvas; x1,y1: integer);
var
  ts:       TSize;
  gp:       TGanttPanel;
  res:      TMqmRes;
  mc:       TMqmGanttConst;
  str:      string;
  txtSpc:   integer;
  txtLft:   integer;
  visRes:   TMqmVisibleRes;
  ResH:     integer;
  ResW:     integer;
  ConfTab: TPlanTabCfg;
  i : Integer;
  ACanvas : TcxCanvas;
  ARect : TRect;
  stripeJobClr: COLORREF;

  procedure DrawSmoothRoundRect(ACanvas: TcxCanvas; const ARect: TRect; AColor, ABkColor: TColor;
    ARadiusX, ARadiusY: Integer; APenWidth: Integer = 1; APenColorAlpha: Byte = 255; ABrushColorAlpha: Byte = 255);
  var
    AGpCanvas: TdxGPCanvas;
  begin
    AGpCanvas := TdxGPCanvas.Create(ACanvas.Handle);
    AGpCanvas.SmoothingMode := smAntiAlias;
    AGpCanvas.EnableAntialiasing(True);
    AGpCanvas.RoundRect(ARect, AColor, ABkColor, ARadiusX, ARadiusY, APenWidth, APenColorAlpha, ABrushColorAlpha);
    AGpCanvas.Free;
  end;

  procedure DrawGradientRoundRect(ACanvas: TcxCanvas; ARect: TRect;
    StartColor, EndColor, ABorderColor: TColor);
  var
    AGpCanvas: TdxGPCanvas;
    AGPBrush:  TdxGPBrush;
    AGPPen:    TdxGPPen;
  begin
    AGpCanvas := TdxGPCanvas.Create(ACanvas.Handle);
    AGpCanvas.SmoothingMode := smAntiAlias;
    AGpCanvas.EnableAntialiasing(True);
    AGPPen   := TdxGPPen.Create(ABorderColor, 1);
    AGPBrush := TdxGPBrush.Create;
    try
      AGPBrush.Style        := gpbsGradient;
      AGPBrush.GradientMode := gpbgmVertical;
      AGPBrush.GradientPoints.Add(0.0, dxColorToAlphaColor(StartColor, 255));
      AGPBrush.GradientPoints.Add(1.0, dxColorToAlphaColor(EndColor,   255));
      AGpCanvas.RoundRect(ARect, AGPPen, AGPBrush, Corner_Radius, Corner_Radius);
    finally
      AGPPen.Free;
      AGPBrush.Free;
      AGpCanvas.Free;
    end;
  end;

    procedure DrawResReadOnly(parms: PTRowParms; assObj: TObject; cxCanvas: TcxCanvas; x1,y1: integer);
    var
      ts:       TSize;
      gp:       TGanttPanel;
      res:      TMqmRes;
      mc:       TMqmGanttConst;
      str:      string;
      txtSpc:   integer;
      txtLft:   integer;
      visRes:   TMqmVisibleRes;
      ResH:     integer;
      ResW:     integer;
      r : TRect;
    begin
      gp := TGanttPanel(assObj);

      Assert(Assigned(parms.objPtr));
      visRes := TMqmVisibleRes(parms.objPtr);
      res    := TMqmRes(visRes.p_Father);

      with cxCanvas do
      begin
        mc := TMqmGanttConst(gp.GetGanttConst);

        visRes.GetColors(Brush, Pen, Font);

        ResH := mc.Rh;
        ResW := mc.RW;

        if visRes.p_SubCode <> -1 then
          x1 := x1 + 3; //10;

        //RoundRect(x1, y1+mc.VO_RS, mc.RW-mc.OO_RS, y1+ResH-mc.VO_RS+1, 10, 10);
        //Rectangle(x1, y1+mc.VO_RS, mc.RW-mc.OO_RS, y1+ResH-mc.VO_RS+1);
        r := TRect.Create(x1, y1+mc.VO_RS, mc.RW-mc.OO_RS, y1+ResH-mc.VO_RS+1);
        stripeJobClr := ColorToRGB(Brush.Color);
        DrawGradientRoundRect(cxCanvas, r,
          RGB(Min(255, Integer(GetRValue(stripeJobClr)) + 48),
              Min(255, Integer(GetGValue(stripeJobClr)) + 48),
              Min(255, Integer(GetBValue(stripeJobClr)) + 48)),
          Brush.Color, Pen.Color);

        {// Draw button for collapse or expand sub resources
        if visRes.p_SubCode = 1 then
        begin
          // button
          Rectangle(x1+ResW-20,y1+ResH-10,x1+ResW-10,y1+ResH);
          // Expand/collapse symbol (Horizontal section)
          Rectangle(x1+ResW-17,y1+ResH-5,x1+ResW-12,y1+ResH-4);
          if not visRes.p_SubResExpanded then // vertical section
            Rectangle(x1+ResW-15,y1+ResH-7,x1+ResW-14,y1+ResH-2);
        end;  }

        // write resource name centered
        if (p_pl.GetCompatModeInPlanId = CSchedIDnull) then
        begin
          if (p_pl.GetCompatModeInPlanCapRes <> nil) then
          begin
            case res.p_occCompatVal of
              -1: begin
                    if res.p_Text1 <> '' then
                      str := res.p_Text1 + ' ' + _('Invalid')
                    else
                      str := res.p_ResCode + ' ' + _('Invalid')
                  end
              else
              begin
                if res.p_Text1 <> '' then
                  str := res.p_Text1 + _(' Case: ') + IntToStr(res.p_occCompatVal)
                else
                  str := res.p_ResCode + _(' Case: ') + IntToStr(res.p_occCompatVal)
              end;
            end
          end else
          begin
            if res.p_Text1 <> '' then
              str := res.p_Text1
            else
            begin
              if (visRes.p_EfficiencyOnLevel <> EffLvl_Non) and (visRes.p_EfficiencyOnLevel <> Eff_And_Cal_Both_Lvl_Res) then
              begin
                if Length(res.p_ResCode) <= 7 then
                  str := res.p_ResCode + ' (' + visRes.p_CalCodReal + ')'
                else
                  str := res.p_ResCode + ' ' + visRes.p_CalCodReal
              end
              else
              begin
                if Length(res.p_ResCode) <= 7 then
                  str := res.p_ResCode + ' (' + visRes.p_CalCod + ')'
                else
                  str := res.p_ResCode + ' ' + visRes.p_CalCod
              end;
            end;
          end;
        end else
        begin
          if not res.p_occGoodWkc[p_pl.GetCompatModeInPlanId] then
          begin
            if res.p_Text1 <> '' then
            begin
              if Length(res.p_Text1) <= 7 then
                str := res.p_Text1 + _(' Dif. WC')        // _(' Diff. WC')
              else
                str := res.p_Text1 + _(' Dif.W')           // _(' Dif.W')
            end
            else
            begin
              if Length(res.p_ResCode) <= 7 then
                str := res.p_ResCode + _(' Dif. WC')    //_(' Diff. WC')
              else
                str := res.p_ResCode + _(' Dif.W');     // _(' Dif.W');
            end;
          end
          else
            if not res.p_occHasTimings then
            begin
              if res.p_Text1 <> '' then
                str := res.p_Text1 + _(' NoTims')
              else
                str := res.p_ResCode + _(' NoTims') // _(' No Times')
            end
            else
              if not res.p_occGoodDepend[p_pl.GetCompatModeInPlanId] then
              begin
              if res.p_Text1 <> '' then
                str := res.p_Text1 + _(' Depend')
              else
                str := res.p_ResCode + _(' Depend.')
              end
              else
              begin
                if res.p_Text1 <> '' then  //_(' Case: ')
                  str := res.p_Text1 + _(' : ') + IntToStr(res.p_occCompatVal)
                else
                  str := res.p_ResCode + _(' : ') + IntToStr(res.p_occCompatVal);
              end;
        end;

        if SavedFont = 0 then
          SavedFont := font.PixelsPerInch;

        if SavedFont = 96 then
          font.Size := 8
        else
        if SavedFont = 120 then
          font.Size := 6
        else
        if SavedFont = 144 then
          font.Size := 5;

        ts     := TextExtent(str);

        txtLft := (ResW - ts.cx) div 2;
        txtSpc := (ResH - ts.cy * 2) div 3;

        Brush.Style := bsClear;
        if txtSpc > 2 then
        begin
          if (visRes.p_SubCode <> -1) and (res.p_VisResCount > 1) then
          begin
            //SMALLER FONT
           { if SavedFont = 0 then
              SavedFont := Canvas.Font.Size;

            if Length(trim(str)) >= 12 then
              Font.Size := SavedFont - 1
            else
              Font.Size := SavedFont;  }

            //BIGGER RECT
            if Length(trim(str)) >= 12 then
            begin
              r := TRect.Create(x1-3, y1+mc.VO_RS, mc.RW-mc.OO_RS + 6, y1+ResH-mc.VO_RS+1);
              DrawGradientRoundRect(cxCanvas, r,
                RGB(Min(255, Integer(GetRValue(stripeJobClr)) + 48),
                    Min(255, Integer(GetGValue(stripeJobClr)) + 48),
                    Min(255, Integer(GetBValue(stripeJobClr)) + 48)),
                TColor(stripeJobClr), Pen.Color);
            end;

            TextOut(txtLft, txtSpc + y1, str);
            str := _('sub ') + IntToStr(visRes.p_SubCode) + ' - ' + TMqmWrkCtr(Res.p_Father).p_WrkCtrCode;
            ts     := TextExtent(str);
            txtLft := (ResW - ts.cx) div 2;
            txtSpc := (ResH - ts.cy * 2) div 3;
            TextOut(txtLft, txtSpc + y1 + ts.cy + txtSpc, str);

            if (visRes.p_SubCode = 1) then
            begin

              // Draw button for collapse or expand sub resources
              Rectangle(x1+ResW-15,y1+ResH-11,x1+ResW-5,y1+ResH-3);
              // Expand/collapse symbol (Horizontal section)
              Rectangle(x1+ResW-12,y1+ResH-7,x1+ResW-7,y1+ResH-6);
             // if not visRes.p_SubResExpanded then // vertical section
             //   Rectangle(x1+ResW-10,y1+ResH-9,x1+ResW-9,y1+ResH-4);
            end;
          end else
          begin
            //SavedFont := Canvas.Font.Size;
            //Canvas.Font.Size := SavedFont - 1;
            TextOut(txtLft, txtSpc + y1, str);
            if res.p_Text2 <> '' then
              str := res.p_Text2
            else
              str := (res.p_ResCat.p_ResCatCode + ' - ' + TMqmWrkCtr(Res.p_Father).p_WrkCtrCode);
            ts     := TextExtent(str);
            txtLft := (ResW - ts.cx) div 2;
            txtSpc := (ResH - ts.cy * 2) div 3;
            TextOut(txtLft, txtSpc + y1 + ts.cy + txtSpc, str);
            //Canvas.Font.Size := SavedFont;
          end
        end else
          TextOut((ResW - ts.cx) div 2,
                  (ResH - ts.cy) div 2 + y1,
                  str)
      end

    end;

//----------------------------------------------------------------------------//



begin
  gp := TGanttPanel(assObj);

  Assert(Assigned(parms.objPtr));
  visRes := TMqmVisibleRes(parms.objPtr);
  res    := TMqmRes(visRes.p_Father);

  ACanvas := TcxCanvas.Create(Canvas);

  if TMqmWrkCtr(res.p_father).p_ReadOnly then
  begin
    DrawResReadOnly(parms,assObj,ACanvas,x1,y1);
    exit;
  end;

  with Acanvas do
  begin
    mc := TMqmGanttConst(gp.GetGanttConst);

    visRes.GetColors(Brush, Pen, Font);

    ResH := mc.Rh;
    ResW := mc.RW;

    if visRes.p_SubCode <> -1 then
      x1 := x1 + 3; //10;

    //RoundRect(x1, y1+mc.VO_RS, mc.RW-mc.OO_RS, y1+ResH-mc.VO_RS+1, 10, 10);
    //Rectangle(x1, y1+mc.VO_RS, mc.RW-mc.OO_RS, y1+ResH-mc.VO_RS+1);

    ARect.Create(x1, y1+mc.VO_RS, mc.RW-mc.OO_RS, y1+ResH-mc.VO_RS+1);
    stripeJobClr := ColorToRGB(Canvas.Brush.Color);
    DrawGradientRoundRect(ACanvas, ARect,
      RGB(Min(255, Integer(GetRValue(stripeJobClr)) + 48),
          Min(255, Integer(GetGValue(stripeJobClr)) + 48),
          Min(255, Integer(GetBValue(stripeJobClr)) + 48)),
      Canvas.Brush.Color, Canvas.Pen.Color);

    {// Draw button for collapse or expand sub resources
    if visRes.p_SubCode = 1 then
    begin
      // button
      Rectangle(x1+ResW-20,y1+ResH-10,x1+ResW-10,y1+ResH);
      // Expand/collapse symbol (Horizontal section)
      Rectangle(x1+ResW-17,y1+ResH-5,x1+ResW-12,y1+ResH-4);
      if not visRes.p_SubResExpanded then // vertical section
        Rectangle(x1+ResW-15,y1+ResH-7,x1+ResW-14,y1+ResH-2);
    end;  }

    // write resource name centered
    if (p_pl.GetCompatModeInPlanId = CSchedIDnull) then
    begin
      if (p_pl.GetCompatModeInPlanCapRes <> nil) then
      begin
        case res.p_occCompatVal of
          -1: begin
                if res.p_Text1 <> '' then
                  str := res.p_Text1 + ' ' + _('Invalid')
                else
                  str := res.p_ResCode + ' ' + _('Invalid')
              end
          else
          begin
            if res.p_Text1 <> '' then
              str := res.p_Text1 + _(' Case: ') + IntToStr(res.p_occCompatVal)
            else
              str := res.p_ResCode + _(' Case: ') + IntToStr(res.p_occCompatVal)
          end;
        end
      end else
      begin
        if res.p_Text1 <> '' then
          str := res.p_Text1
        else
        begin
          if (visRes.p_EfficiencyOnLevel <> EffLvl_Non) and (visRes.p_EfficiencyOnLevel <> Eff_And_Cal_Both_Lvl_Res) then
          begin
            if Length(res.p_ResCode) <= 7 then
              str := res.p_ResCode + ' (' + visRes.p_CalCodReal + ')'
            else
              str := res.p_ResCode + ' ' + visRes.p_CalCodReal
          end
          else
          begin
            if Length(res.p_ResCode) <= 7 then
              str := res.p_ResCode + ' (' + visRes.p_CalCod + ')'
            else
              str := res.p_ResCode + ' ' + visRes.p_CalCod
          end;
        end;
      end;
    end else
    begin
      if not res.p_occGoodWkc[p_pl.GetCompatModeInPlanId] then
      begin
        if res.p_Text1 <> '' then
        begin
          if Length(res.p_Text1) <= 7 then
            str := res.p_Text1 + _(' Dif. WC')        // _(' Diff. WC')
          else
            str := res.p_Text1 + _(' Dif.W')           // _(' Dif.W')
        end
        else
        begin
          if Length(res.p_ResCode) <= 7 then
            str := res.p_ResCode + _(' Dif. WC')    //_(' Diff. WC')
          else
            str := res.p_ResCode + _(' Dif.W');     // _(' Dif.W');
        end;
      end
      else
        if not res.p_occHasTimings then
        begin
          if res.p_Text1 <> '' then
            str := res.p_Text1 + _(' NoTims')
          else
            str := res.p_ResCode + _(' NoTims') // _(' No Times')
        end
        else
          if not res.p_occGoodDepend[p_pl.GetCompatModeInPlanId] then
          begin
          if res.p_Text1 <> '' then
            str := res.p_Text1 + _(' Depend')
          else
            str := res.p_ResCode + _(' Depend.')
          end
          else
          begin
            if res.p_Text1 <> '' then  //_(' Case: ')
              str := res.p_Text1 + _(' : ') + IntToStr(res.p_occCompatVal)
            else
              str := res.p_ResCode + _(' : ') + IntToStr(res.p_occCompatVal);
          end;
    end;

    if SavedFont = 0 then
      SavedFont := font.PixelsPerInch;

    if SavedFont = 96 then
      font.Size := 8
    else
    if SavedFont = 120 then
      font.Size := 6
    else
    if SavedFont = 144 then
      font.Size := 5;

    ts     := TextExtent(str);

    txtLft := (ResW - ts.cx) div 2;
    txtSpc := (ResH - ts.cy * 2) div 3;

    Brush.Style := bsClear;
    if txtSpc > 2 then
    begin
      if (visRes.p_SubCode <> -1) and (res.p_VisResCount > 1) then
      begin
        //SMALLER FONT
       { if SavedFont = 0 then
          SavedFont := Canvas.Font.Size;

        if Length(trim(str)) >= 12 then
          Font.Size := SavedFont - 1
        else
          Font.Size := SavedFont;  }

        //BIGGER RECT
        if Length(trim(str)) >= 12 then
        begin
          ARect.Create(x1-3, y1+mc.VO_RS, mc.RW-mc.OO_RS + 4, y1+ResH-mc.VO_RS+1);
          DrawGradientRoundRect(ACanvas, ARect,
            RGB(Min(255, Integer(GetRValue(stripeJobClr)) + 48),
                Min(255, Integer(GetGValue(stripeJobClr)) + 48),
                Min(255, Integer(GetBValue(stripeJobClr)) + 48)),
            TColor(stripeJobClr), Canvas.Pen.Color);
        end;

        TextOut(txtLft, txtSpc + y1, str);
        str := _('sub ') + IntToStr(visRes.p_SubCode) + ' - ' + TMqmWrkCtr(Res.p_Father).p_WrkCtrCode;
        ts     := TextExtent(str);
        txtLft := (ResW - ts.cx) div 2;
        txtSpc := (ResH - ts.cy * 2) div 3;
        TextOut(txtLft, txtSpc + y1 + ts.cy + txtSpc, str);

        if (visRes.p_SubCode = 1) then
        begin

          // Draw button for collapse or expand sub resources
          Rectangle(x1+ResW-15,y1+ResH-11,x1+ResW-5,y1+ResH-3);
          // Expand/collapse symbol (Horizontal section)
          Rectangle(x1+ResW-12,y1+ResH-7,x1+ResW-7,y1+ResH-6);

          ConfTab := TPlanTabCfg(FMQMPlan.m_planTbCfg.FindTab(FMQMPlan.m_pgcPlan.GetActiveView.GetCode));

          for i := 0 to ConfTab.IsResExpanded.Count-1 do
          begin

            if res = TMQMRES(TTResExpanded(ConfTab.IsResExpanded[i]).obj) then
            begin
              if TTResExpanded(ConfTab.IsResExpanded[i]).Is_Res_Expanded = 0 then
                Rectangle(x1+ResW-10,y1+ResH-9,x1+ResW-9,y1+ResH-4);

              break;

            end;
          end;

          //if not visRes.p_SubResExpanded then // vertical section
         //   Rectangle(x1+ResW-10,y1+ResH-9,x1+ResW-9,y1+ResH-4);
        end;
      end else
      begin
        //SavedFont := Canvas.Font.Size;
        //Canvas.Font.Size := SavedFont - 1;
        TextOut(txtLft, txtSpc + y1, str);
        if res.p_Text2 <> '' then
          str := res.p_Text2
        else
          str := (res.p_ResCat.p_ResCatCode + ' - ' + TMqmWrkCtr(Res.p_Father).p_WrkCtrCode);
        ts     := TextExtent(str);
        txtLft := (ResW - ts.cx) div 2;
        txtSpc := (ResH - ts.cy * 2) div 3;
        TextOut(txtLft, txtSpc + y1 + ts.cy + txtSpc, str);
        //Canvas.Font.Size := SavedFont;
      end
    end else
      TextOut((ResW - ts.cx) div 2,
              (ResH - ts.cy) div 2 + y1,
              str)
  end;

  ACanvas.Free;
end;

//----------------------------------------------------------------------------//

procedure DrawActArea(Canvas: TCanvas; parms: PTRowParms; const rect: TRect; const IntPt, MatPt: integer);
var
  ActArea:     TMqmActArea;
  oldCp:  TCopyMode;
  oldStyle:  TBrushStyle;
  drawRect:  TRect;
begin
  exit;
  ActArea := TMqmActArea(parms.objPtr);
  drawRect := rect;
//sav  drawRect.Bottom := drawRect.Top + Trunc((drawRect.Bottom - drawRect.Top) * 0.07);
  drawRect.Bottom := drawRect.Top + 3;
  with canvas do
  begin
    ActArea.GetNormalColors(true, Brush, pen, Font);
    oldCp := Canvas.CopyMode;
    oldStyle := Canvas.Brush.Style;
    Canvas.CopyMode := cmSrcInvert;
    Canvas.Brush.Style := bsBDiagonal;
    Canvas.CopyRect(drawRect, Canvas, drawRect);
    Canvas.FillRect(drawRect);
    Canvas.Brush.Style := oldStyle;
    Canvas.CopyMode := oldCp
  end;
end;

//----------------------------------------------------------------------------//

procedure DrawObjDesc(cvs: TCanvas; var rect: TRect; desc: string; LineNumber : Integer);
var
  txthOfs,
  txtvOfs,txtvOfs2: integer;
  oldStyle:  TBrushStyle;
  OriginTop,x : Integer;
begin
  oldStyle := cvs.Brush.Style;
  cvs.Brush.Style := bsClear;
 // cvs.Font.Style := [fsBold];

 if trim(desc) = '' then
 begin
  {if FilledLine > 0 then
    FilledLine := FilledLine -1; }

  exit;
 end;

 {if Length(desc) = 1 then
  mainTop := Rect.Top;

 if mainTop > rect.top then
  rect.Top := mainTop; }


 if (LineNumber = 0) and (FilledLine = 1) then exit;

  with rect do
  begin
    if Left < 0 then Left := 0;
//    if shMan.m_prntSh.Width < rect.Right then Right := shMan.m_prntSh.Width;
    txtvOfs := ((Bottom - Top) div 2) - (cvs.TextHeight(desc) div 2)-1;
    txtvOfs2 := ((Bottom - Top) div 2) - (cvs.TextHeight(desc) div 12)-1;

    Inc(FilledLine);

    //Default Top
    OriginTop := Top + cvs.pen.Width + txtvOfs;

    if LineNumber = 0 then
      Top := OriginTop
    else if LineNumber = 1 then
      Top := OriginTop;
     /////////////////
    if (LineNumber = 2) and (FilledLine = 1) then
      Top := OriginTop - 10;

    if (LineNumber = 2) and (FilledLine = 2) then
      Top := OriginTop + 10;
     //////////////////////
     if LineNumber = 3  then
     begin

       if FilledLine = 1 then
        Top := Top + txtvOfs div 2 - 5;

       if FilledLine = 2 then
        Top := Top + txtvOfs;

       if FilledLine = 3 then
        Top := Top + txtvOfs * 2 -5
     end;
     ///////////////
     if LineNumber = 4  then
     begin

       if FilledLine = 1 then
        Top := Top + txtvOfs div 4 - 5;

       if FilledLine = 2 then
        Top := Top + txtvOfs - 10;

       if FilledLine = 3 then
        Top := Top + txtvOfs;

       if FilledLine = 4 then
        Top := Top + txtvOfs + 10;
     end;
     /////////////////////////
    if ((Bottom - Top) > cvs.TextHeight(desc)) and
       ((Right - Left) > cvs.TextWidth(desc)) then
    begin
      if LineNumber > 1 then
        txthOfs := 5
      else
        txthOfs := ((Right - Left) div 2) - (cvs.TextWidth(desc) div 2);

      if (Right - Left) > cvs.TextWidth(desc) then
        cvs.TextOut(Left + txthOfs, Top, desc)
    end
  end;
  cvs.Brush.Style := oldStyle;
end;

//----------------------------------------------------------------------------//

procedure DrawCapRes(Canvas: TCanvas; parms: PTRowParms; const rect: TRect; const IntPt, MatPt: integer);
var
  capRes:   TMqmCapRes;
  mdRect:   TRect;
  n : Integer;
begin
  capRes := TMqmCapRes(parms.objPtr);

  with canvas do
  begin
    if parms.suppVal1 = -1 then
      capRes.GetNormalColors(true, brush, pen, font)
    else
      GetCapResCompatColor(parms.suppVal1, true, brush, pen, font);

    Rectangle(rect);
  end;
  mdRect := rect;
//  DrawObjDesc(Canvas, mdRect, capRes.GetTxtDesc, txtClr, int);
  FilledLine := 0;
  //  x := p_sc.GetMaxLineNum(id, isGrp, True);
    for n := 1 to 4  do
      DrawObjDesc(Canvas, mdRect, '',0);
  FilledLine := 0;

  if (capRes.m_Type = Cr_CrossingDtm) or (capRes.m_Type = cr_DownTime) then
     DrawObjDesc(Canvas, mdRect, capRes.m_Comment ,1);

  DrawArrowOnRect(canvas, mdRect, capRes.IsMoved, 0)
end;

//----------------------------------------------------------------------------//

procedure DrawWarp(Canvas: TCanvas; parms: PTRowParms; const rect: TRect; const IntPt, MatPt: integer);
var
  MqmWarp:   TMqmWarp;
  mdRect:   TRect;
  n : Integer;
  Id, TestedId, Item_Id : TSchedId;
  compFore,
  compBack: TCompatVal;
  Selected : Boolean;
  DammyQty : double;
  ArctArea : TMqmActArea;
  var
  C, P1, P2: TPoint;
  rx, ry, Y: Integer;
  SchedList : TMSchedList;
begin
  MqmWarp := TMqmWarp(parms.objPtr);
  Id := p_pl.GetCompatModeInPlanId;
  Selected := False;
  var CornerRadius := 4;

  with canvas do
  begin

    if parms.suppVal1 = -1 then
    begin
      MqmWarp.GetNormalColors(true, brush, pen, font);
      if (Id <> CSchedIdNull) and (id = MqmWarp.Get_M_id) then
      begin

        Selected := True;
      end
      else if (Id <> CSchedIdNull) and not p_sc.IsProdSchedMaterial(Id) then
      begin
        Selected := False;
        if p_sc.CheckItemAndProductForWarp(MqmWarp.Get_M_id, Id, false, Item_Id, DammyQty) then
          GetOccCompatColor(1, true, brush, pen, font)
        else
          GetOccCompatColor(99, true, brush, pen, font);

         RoundRect(rect, CornerRadius, CornerRadius );
         mdRect := rect;
         exit;
      end
      else
      begin
        ArctArea := TMqmActArea(parms.objActArea_Warp);
        SchedList := TMSchedList.Create(Application);
        if Assigned(ArctArea) then
           ArctArea.FindSchedInSpots(MqmWarp.p_start , MqmWarp.p_End , SchedList);
        if SchedList.GetLinkCount > 0 then

        for Y := 0 to SchedList.GetLinkCount - 1 do
        begin
          if not p_sc.CheckItemAndProductForWarp(MqmWarp.Get_M_id, SchedList.GetLink(Y), false, Item_Id, DammyQty) then
          begin
            GetOccCompatColor(99, true, brush, pen, font);
            RoundRect(rect, CornerRadius, CornerRadius );
            mdRect := rect;
            exit;
          end;
        end;

      end;

    end
    else
    begin
      //GetMqmWarpCompatColor(parms.suppVal1, true, brush, pen, font);

    end;

      var dis := Rect.Width div 10;
      var x1 := Rect.Left;
      var x2 := Trunc(x1 + dis * 1.5);
      var i := 0;
      var Last := False;
      var LastRect := False;

     // if MqmWarp.IsLinkedToRequest then
     //   Brush.Color := clWhite
     // else
      Brush.Color := Cl_STNDRD_WARP_COLOR;//$009547D9;
      RoundRect(Rect.Left, Rect.Top, Rect.Right, Rect.Bottom, CornerRadius, CornerRadius);

      if MqmWarp.IsLinkedToRequest then
      begin
        Brush.Style := bsClear;
        Pen.Color := clYellow;
        RoundRect(Rect.Left+1, Rect.Top+1, Rect.Right-1, Rect.Bottom-1, CornerRadius, CornerRadius);
      end;
     //   Brush.Color := clWhite
     Brush.Style := bsSolid;
     Pen.Color := clBlack;
     // if MqmWarp.IsLinkedToRequest then
     //   Brush.Color := cLRed
     // else
      Brush.Color := clBlack;

      while not Last do
      begin

        if LastRect then Break;

        if (MqmWarp.IsLinkedToRequest) and (rect.Height <= 7) then break;

        if i mod 2 <> 0 then
        begin
          if x1 + trunc(dis / 1.5)  >= Rect.Right then
          begin
            x2 := x1 + (Rect.right - x1);
            LastRect := True;
          end;

          if (Rect.Width < 50)
          and (Rect.Width > 20)
          then
          begin
             if not MqmWarp.IsLinkedToRequest then
             begin
              Rectangle(Rect.Left + (Rect.Width div 2) - 8, Rect.Top, Rect.Left + (Rect.Width div 2) - 6, Rect.Bottom);
              Rectangle(Rect.Left + (Rect.Width div 2) - 1, Rect.Top, Rect.Left + (Rect.Width div 2) + 1, Rect.Bottom);
              Rectangle(Rect.Left + (Rect.Width div 2) + 6, Rect.Top, Rect.Left + (Rect.Width div 2) + 8, Rect.Bottom);
             end
             else
               Canvas.Ellipse(Rect.Left + (Rect.Width div 2) - 5,
                  (Rect.Top + (Rect.Height div 2))  - 5,
                  Rect.Left + (Rect.Width div 2) + 5,
                  (Rect.Top + (Rect.Height div 2))  + 5);

            break
          end;

          if (Rect.Width <= 20) then  break;

      {    if (Rect.Width < 40)
          and (Rect.Width > 15)
          then
          begin
            Rectangle(Rect.Left + (Rect.Width div 2) - 6, Rect.Top, Rect.Left +(Rect.Width div 2) - 4, Rect.Bottom);
            Rectangle(Rect.Left + (Rect.Width div 2) + 4, Rect.Top, Rect.Left + (Rect.Width div 2) + 6, Rect.Bottom);
            break
          end;

          if (Rect.Width <= 15) then  break; }

          if LastRect then Break;


          if MqmWarp.IsLinkedToRequest then
          begin
            if Rect.Width > 85 then
              Canvas.Ellipse(x1,
                (Rect.Top + (Rect.Height div 2))  - 4,
                x1 + 8,
                (Rect.Top + (Rect.Height div 2))  + 4)
            else
                Canvas.Ellipse(x1,
                (Rect.Top + (Rect.Height div 2))  - 2,
                x1 + 4,
                (Rect.Top + (Rect.Height div 2))  + 2);

           end else
              Rectangle(x1, Rect.Top, x2 - (dis div 2), Rect.Bottom);

          if x2 >= Rect.Right  then break;

          x1 := x2 - (dis div 2);
          x2 := x1 + dis - (dis div 2);

        end else
        begin
            x1 := x2;
            x2 := x1 + dis;
            inc(i);
            continue;
        end;


        inc(i);
      end;

   { for i := 2 to dis+5 do
    begin
      pen.color := clBlack;
      pen.Width := 1;

      if i mod 2 = 0 then
        Brush.Color := $009547D9
      else
        Brush.Color := clBlack;

      if x1 + dis  >= Rect.Right then
      begin
        x2 := x1 + (Rect.right - x1);
        Last := True;
      end;
      pen.Color := $009547D9;
      if (i = 2) and not Last then
        RoundRect(x1, Rect.Top, x2, Rect.Bottom+1, CornerRadius, CornerRadius)
      else if (i > 2)  and not(Last) then
        Rectangle(x1-1, Rect.Top, x2, Rect.Bottom+1)
      else if Last then
      begin
        Brush.Color := $009547D9;
        RoundRect(x1, Rect.Top, x2, Rect.Bottom+1, CornerRadius, CornerRadius);
        if x1 + 2 < x2 then
        begin
          pen.Color := $009547D9;
          Rectangle(x1, Rect.Top, x1+1, Rect.Bottom+1);
        end;

      end;


     if x2 >= Rect.Right  then break;

      x1 := x2;

      if i mod 2 = 0 then
        x2 := trunc(x1 + dis * 0.3)
      else
        x2 := x1 + dis;

    end;  }

     { pen.color := clBlack;
      pen.Width := 1;
      rx := 4;
      ry := 4;
      //TOP
      MoveTo(rect.Left, Rect.top);
      LineTo(rect.Right, Rect.top);

      //Right
      MoveTo(rect.Right, Rect.top);
      LineTo(rect.Right, Rect.bottom);

      //Bottom
      MoveTo(rect.Right, Rect.bottom);
      LineTo(rect.left , Rect.bottom);



      //Left
      MoveTo(rect.left, Rect.bottom);
      LineTo(rect.left , Rect.top );

      LineTo(rect.Left, Rect.Top+2);   }

    if Selected then
    begin
      pen.color := CLBlack;//clYellow;
      pen.Width := 2;

      MoveTo(rect.Left, Rect.top);
      LineTo(rect.Right, Rect.Top);
      LineTo(rect.Right, Rect.Bottom);
      LineTo(rect.Left, Rect.Bottom);
      LineTo(rect.Left, Rect.Top);
    end;

  //  RoundRect(Rect.Left + 2, Rect.Top + 2, Rect.Right - 2, Rect.Bottom - 2, 5, 5);
  //  Rectangle(rect);
  end;
  mdRect := rect;
  FilledLine := 0;



 // for n := 1 to 4  do
 //   DrawObjDesc(Canvas, mdRect, '',0);

 // FilledLine := 0;

//  if (capRes.m_Type = Cr_CrossingDtm) or (capRes.m_Type = cr_DownTime) then
//     DrawObjDesc(Canvas, mdRect, capRes.m_Comment ,1);

//  DrawArrowOnRect(canvas, mdRect, capRes.IsMoved, 0)
end;

//----------------------------------------------------------------------------//

procedure DrawSchedObj(Canvas: TCanvas; parms: PTRowParms; const rect: TRect; const IntPt, MatPt: integer; Trans : Boolean);
var
  mdRect:   TRect;
  tinyRect: TRect;
  IsTinyBar: Boolean;
  id:       TSchedID;
  TypeActive : CScFlags;
  planInfo: TSQPlanInfo;
  isGrp:    boolean;
  compId, TestedId, OnlyItem_Id :   TSchedID;
  compFore,
  compBack: TCompatVal;
  PlanType : TPlanType;
  CanvasDates: TCanvas;
  CanvasMater: TCanvas;
  CanvasStatus: TCanvas;
  errSet: SetOfErrors;
  ActArea: TMqmActArea;
  ProdNature : SetArProdNature;
  PurchaseOrderLeadTimeList, DummyList : TList;
  RecNoMatDate: PTRecNoMatDate;
  I : Integer;
  mi : Graphics.TBitMap;
  Opacity : Byte;
  DammyQty : double;
  n,x : Integer;
  ACanvas : TcxCanvas;
  stripeJobClr:   COLORREF;

  function ColorIsLight(Color: TColor): Boolean;
  begin
    Color := ColorToRGB(Color);
    Result := ((Color and $FF) + (Color shr 8 and $FF) +
      (Color shr 16 and $FF)) >= 200;
  end;

  procedure CopyColor(CanvasToCopy: TCanvas);
  var
    TmpColor: TColor;
  begin
    Canvas.Pen   := CanvasToCopy.Pen;
    Canvas.Brush := CanvasToCopy.Brush;
    Canvas.Font  := CanvasToCopy.Font;

    if (Canvas.Brush.Style = bsBDiagonal)
    or (Canvas.Brush.Style = bsFDiagonal)
    or (Canvas.Brush.Style = bsDiagCross) then
    begin
      //set the background color
      TmpColor := Canvas.brush.Color;
      Canvas.brush.Color := Canvas.pen.Color;
      SetBkColor(Canvas.Handle, ColorToRGB(TmpColor));
      SetBkMode(Canvas.Handle, OPAQUE);
    end;
  end;

  procedure DrawSmoothRoundRect(ACanvas: TcxCanvas; const ARect: TRect; AColor, ABkColor: TColor;
  ARadiusX, ARadiusY: Integer; APenWidth: Integer = 1; APenColorAlpha: Byte = 255; ABrushColorAlpha: Byte = 255);
  var
    AGpCanvas: TdxGPCanvas;
  begin
    //ACanvas.Brush.Style := bsClear;
    AGpCanvas := TdxGPCanvas.Create(ACanvas.Handle);
    AGpCanvas.SmoothingMode := smAntiAlias;
    AGpCanvas.EnableAntialiasing(True);
    AGpCanvas.RoundRect(ARect, AColor, ABkColor, ARadiusX, ARadiusY, APenWidth, APenColorAlpha, ABrushColorAlpha);
    AGpCanvas.Free;
  end;

  procedure DrawGradientRoundRect(ACanvas: TcxCanvas; ARect: TRect;
    StartColor, EndColor, ABorderColor: TColor);
  var
    AGpCanvas: TdxGPCanvas;
    AGPBrush:  TdxGPBrush;
    AGPPen:    TdxGPPen;
  begin
    AGpCanvas := TdxGPCanvas.Create(ACanvas.Handle);
    AGpCanvas.SmoothingMode := smAntiAlias;
    AGpCanvas.EnableAntialiasing(True);
    AGPPen   := TdxGPPen.Create(ABorderColor, 1);
    AGPBrush := TdxGPBrush.Create;
    try
      AGPBrush.Style        := gpbsGradient;
      AGPBrush.GradientMode := gpbgmVertical;
      AGPBrush.GradientPoints.Add(0.0, dxColorToAlphaColor(StartColor, 255));
      AGPBrush.GradientPoints.Add(1.0, dxColorToAlphaColor(EndColor,   255));
      AGpCanvas.RoundRect(ARect, AGPPen, AGPBrush, Corner_Radius, Corner_Radius);
    finally
      AGPPen.Free;
      AGPBrush.Free;
      AGpCanvas.Free;
    end;
  end;

begin

  if DBAppGlobals.MAINPLAN_Ignore_Pain_When_refresh then
     exit;

//  compId := CSchedIdNull;
//  compFore := CompValNotValid;
//  compBack := CompValNotValid;

  id := TSchedID(parms.objPtr);

  if not p_sc.TestPlanInfo(id) then
  begin
    exit;
  end;

  DummyList := nil;
  p_sc.GetPlanInfo(id, planInfo);

  if IsDynamicPlanActiv then
    PlanType := PDynamic
  else
    PlanType := PNormal;

//  if (PlanType = PDynamic) and not p_sc.HasFlags(id, [CSF_FilterJobsInDynamicGantt]) then
//     exit;

  mdRect := rect;

  // Enforce minimum bar width so very short jobs (e.g. 1-sec progress gap) render visibly
  IsTinyBar := False;
  if (mdRect.Right - mdRect.Left) < (Corner_Radius * 2 + 2) then
  begin
    mdRect.Right := mdRect.Left + Corner_Radius * 2 + 2;
    IsTinyBar := True;
    tinyRect   := mdRect;   // widened bar geometry (top/bottom still = rect)
  end;

  //Draw setup bar
  if (IntPt > 0)
  and (p_sc.isProgressed(id) = prg_none) then
  begin
    if MatPt > 0 then
    begin
      Canvas.Pen.Color := clYellow;
      Canvas.MoveTo(MatPt, mdRect.Top+1);
      Canvas.LineTo(MatPt, mdRect.Bottom -1);
    end;

    if (IntPt <= rect.Right) then  // avi 14 october 2007
    begin
      mdRect.Left  := IntPt;
      mdRect.Right := rect.Right
    end;
  end;

  //Calculate compatibility values
  TestedId := p_pl.GetCompatModeInPlanId;
  if (TestedId <> CSchedIdNull) and p_sc.IsProdSchedMaterial(TestedId) then
  begin
    compId := TestedId;
    if p_sc.CheckItemAndProductForWarp(TestedId, Id, false, OnlyItem_Id, DammyQty) then
    begin
      compFore := 1;
      compBack := 1
    end
    else
    begin
      compFore := CompValNotValid;
      compBack := CompValNotValid
    end
  end
  else
  begin
    compId := p_pl.GetCompatModeInPlanId;
    if compId <> CSchedIdNull then
      p_sc.GetCompatWithOcc(id, compFore, compBack);
  end;

  CanvasDates  := TCanvas.Create;
  CanvasMater  := TCanvas.Create;
  CanvasStatus := TCanvas.Create;

  ACanvas := TcxCanvas.Create(Canvas);

//Mihailo
  if (PlanType = PDynamic) and not p_sc.HasFlags(id, [CSF_FilterJobsInDynamicGantt]) then
    Trans := True
  else
    Trans := False;
  //canvas.Font.Name := 'Montserrat';
  with Acanvas do
  begin
    Brush.Style := bsSolid;
    if (compId <> CSchedIdNull)
    and (compBack <> CompValNotValid) then
    begin
      p_sc.GetColors(id, true, compBack, PlanType, CanvasDates, CanvasMater, CanvasStatus);
      CopyColor(CanvasStatus);

      mdRect.Right := mdRect.Left + Trunc((mdRect.Right - mdRect.Left)/2);

      if Trans = False then
      begin
        stripeJobClr := ColorToRGB(Canvas.Brush.Color);
        DrawGradientRoundRect(ACanvas, mdRect,
          RGB(Min(255, Integer(GetRValue(stripeJobClr)) + 70),
              Min(255, Integer(GetGValue(stripeJobClr)) + 70),
              Min(255, Integer(GetBValue(stripeJobClr)) + 70)),
          Canvas.Brush.Color,
          Canvas.Pen.Color);
      end
      else
        TransRectangle(Canvas,mdRect,brush.Color);

      FilledLine := 0;
     // x := p_sc.GetMaxLineNum(id, isGrp, True);
     // for n := 1 to 4  do
      if not p_sc.IsProdSchedMaterial(TestedId) then
        DrawObjDesc(Canvas, mdRect, IntToStr(compBack),0);
      FilledLine := 0;

      mdRect.Left  := mdRect.Right;
      mdRect.Right := rect.Right;
      p_sc.GetColors(id, true, compFore, PlanType, CanvasDates, CanvasMater, CanvasStatus);

      CopyColor(CanvasStatus);
      mdRect.top := Rect.top;
      if Trans = False then
      begin
        stripeJobClr := ColorToRGB(Canvas.Brush.Color);
        DrawGradientRoundRect(ACanvas, mdRect,
          RGB(Min(255, Integer(GetRValue(stripeJobClr)) + 70),
              Min(255, Integer(GetGValue(stripeJobClr)) + 70),
              Min(255, Integer(GetBValue(stripeJobClr)) + 70)),
          Canvas.Brush.Color,
          Canvas.Pen.Color);
      end
      else
        TransRectangle(Canvas,mdRect,brush.Color);

    end else
    begin
      try
        p_sc.GetColors(id, true, compFore, PlanType, CanvasDates, CanvasMater, CanvasStatus);
      except
      end;

      {if (DBAppGlobals.ShowColorJobModeActivTab <> ScheduleStatus) and
         (DBAppGlobals.ShowColorJobModeActivTab <> Standard) then

      begin
        if DBAppGlobals.ShowColorJobModeActivTab = PreDefinedPropList then
        begin
          CanvasStatus.brush.Color := FindColorInDisplayedPropListActivTab(id);
        end
        else if DBAppGlobals.ShowColorJobModeActivTab = DinamicPropList then
        begin
          CanvasStatus.brush.Color := FindColorInDynamicListPropValues(id);
        end
      end
      else if DBAppGlobals.ShowColorJobModeActivTab = Standard then
      begin
        if DBAppGlobals.ShowColorJobMode = PreDefinedPropList then
        begin
          CanvasStatus.brush.Color := FindColorInDisplayedPropList(id);
        end
        else if DBAppGlobals.ShowColorJobMode = DinamicPropList then
        begin
          CanvasStatus.brush.Color := FindColorInDynamicListPropValues(id);
        end;
      end;    }


      {if DBAppGlobals.ShowColorJobModeActivTab = PreDefinedPropList then
      begin
        CanvasStatus.brush.Color := FindColorInDisplayedPropListActivTab(id);
      end
      else if DBAppGlobals.ShowColorJobModeActivTab = DinamicPropList then
      begin
        CanvasStatus.brush.Color := FindColorInDynamicListPropValues(id);
      end
      else if DBAppGlobals.ShowColorJobMode = PreDefinedPropList then
      begin
        CanvasStatus.brush.Color := FindColorInDisplayedPropList(id);
      end
      else if DBAppGlobals.ShowColorJobMode = DinamicPropList then
      begin
        CanvasStatus.brush.Color := FindColorInDynamicListPropValues(id);
      end; }

       if DBAppGlobals.ShowColorJobModeActivTab = PreDefinedPropList then
          CanvasStatus.brush.Color := FindColorInDisplayedPropList(id)
        else if DBAppGlobals.ShowColorJobModeActivTab = DinamicPropList then
          CanvasStatus.brush.Color := FindColorInDynamicListPropValues(id)
        else if (DBAppGlobals.ShowColorJobMode = PreDefinedPropList) and (DBAppGlobals.ShowColorJobModeActivTab = PreDefinedPropList) then
          CanvasStatus.brush.Color := FindColorInDisplayedPropList(id)
        else if (DBAppGlobals.ShowColorJobMode = DinamicPropList) and (DBAppGlobals.ShowColorJobModeActivTab = DinamicPropList) then
          CanvasStatus.brush.Color := FindColorInDynamicListPropValues(id)
        else if (DBAppGlobals.ShowColorJobMode = PreDefinedPropList) and (DBAppGlobals.ShowColorJobModeActivTab = Standard) then
          CanvasStatus.brush.Color := FindColorInDisplayedPropList(id)
         else if (DBAppGlobals.ShowColorJobMode = DinamicPropList) and (DBAppGlobals.ShowColorJobModeActivTab = Standard) then
          CanvasStatus.brush.Color := FindColorInDynamicListPropValues(id);

      CopyColor(CanvasStatus);

      if Trans = False then
      begin
        // Gradient fill: lighter shade at top → full job color at bottom
        stripeJobClr := ColorToRGB(Canvas.Brush.Color);
        DrawGradientRoundRect(ACanvas, mdRect,
          RGB(Min(255, Integer(GetRValue(stripeJobClr)) + 70),
              Min(255, Integer(GetGValue(stripeJobClr)) + 70),
              Min(255, Integer(GetBValue(stripeJobClr)) + 70)),
          Canvas.Brush.Color,
          Canvas.Pen.Color);
      end
      else
        TransRectangle(Canvas,mdRect,brush.Color);

      errSet := [];
      //Draw materials error bar
      PurchaseOrderLeadTimeList := TList.Create;
      p_sc.CheckErrors(id, CSEG_Materials, errSet, PurchaseOrderLeadTimeList);

      if errSet <> [CSE_NoError] then
      begin
        CopyColor(CanvasMater);
        for i := 0 to PurchaseOrderLeadTimeList.Count -1 do
        begin
          RecNoMatDate := PurchaseOrderLeadTimeList.Items[i];
          if RecNoMatDate.m_StdPurcOrProdTime > 0 then
          begin
            if (planInfo.startDate >= RecNoMatDate.m_startStdPurcOrd) and
               (planInfo.EndDate <= RecNoMatDate.m_endStdPurcOrd) then
              Canvas.Brush.Color := Clwhite;
          end;
        end;

        mdRect.Bottom := mdRect.Top + round((mdRect.Bottom - mdRect.Top)/4);

        if Trans = False then
          FillRect(mdRect)
        else
          TransRectangle(Canvas,mdRect,brush.Color);

        mdRect.Bottom := rect.Bottom;

        for I := 0 to PurchaseOrderLeadTimeList.Count - 1 do
          dispose(PTRecNoMatDate(PurchaseOrderLeadTimeList[I]));
        PurchaseOrderLeadTimeList.Free;
      end;

      errSet := [];
      //Draw dates error bar
      p_sc.CheckErrors(id, CSEG_Dates, errSet, DummyList);
      if errSet <> [CSE_NoError] then
      begin
        CopyColor(CanvasDates);
        mdRect.Top := mdRect.Bottom - round((mdRect.Bottom - mdRect.Top)/4) -1;

        if Trans = False then
          //FillRect(mdRect)
          DrawSmoothRoundRect(ACanvas,
          mdRect,  //Rectangle
          Canvas.Pen.Color, //pen color
          Canvas.Brush.Color, //brush color
          Corner_Radius, Corner_Radius, //corner radius
          1, //border width
          255,  //transparent of pen
          255) //transparent of brush
        else
          TransRectangle(Canvas,mdRect,brush.Color);

        mdRect.top := rect.top;
      end;

      CopyColor(CanvasStatus);
    end;

    if Trans = false then
    begin
      Brush.Style := bsClear;
      //Rectangle(rect);
      if IsTinyBar then
        // Very thin job: wrap the widened bar in a crisp, solid thin black border so it is visible
        DrawSmoothRoundRect(ACanvas,
          tinyRect, //Rectangle
          clBlack, //pen color
          Canvas.Brush.Color, //brush color
          Corner_Radius, Corner_Radius, //corner radius
          1, //border width
          255,  //transparent of pen (fully opaque)
          0) //transparent of brush
      else
        DrawSmoothRoundRect(ACanvas,
          rect,  //Rectangle
          clBlack, //pen color
          Canvas.Brush.Color, //brush color
          Corner_Radius, Corner_Radius, //corner radius
          1, //border width
          100,  //transparent of pen
          0) //transparent of brush
    end else
      TransRectangle2(Canvas,Rect,canvas.Brush.color);

  end;
  FilledLine := 0;
  //canvas.Font.Name := 'Montserrat';
  //Write description
  if (compId = CSchedIdNull)
  or (compFore = CompValNotValid) then
  begin
//    mdRect.Left := IntPt;
//    DrawProgressed(canvas, mdRect, p_sc.IsProgressed(id));
    mdRect.Left := Rect.Left;
    mdRect.Top := Rect.Top-1;

   if not ColorIsLight(canvasStatus.Brush.color) then
      Canvas.Font.Color := clWhite
    else
      Canvas.Font.Color := clBlack;

    x := p_sc.GetMaxLineNum(id, isGrp, True);
    for n := 1 to 4  do
      DrawObjDesc(Canvas, mdRect, p_sc.GetObjBarText(id, isGrp, true,n),x);
  end else
  begin
    mdRect.top := Rect.top;
    if not p_sc.IsProdSchedMaterial(TestedId) then
      DrawObjDesc(Canvas, mdRect, IntToStr(compFore),0);
  end;

  ACanvas.Free;

   FilledLine := 0;
  //canvas.Font.Name := 'Montserrat';
  if (p_sc.isProgressed(id) = prg_none) then
    mdRect.Left := IntPt;

  //Draw symbol of forced delivery date
 // if planInfo.FrcDelDate and ((mdRect.Right - mdRect.Left) > 18) and ((mdRect.Bottom - mdRect.Top) > 18) then
 // begin
 {   Mi := graphics.TBitmap.Create;
  //  FMQMPlan.ImageList1.GetBitmap(19, MandatoryImage);
  MandatoryImage.Canvas.Brush.Color := CanvasStatus.brush.Color;
  MandatoryImage.Width := mdRect.Width;
  MandatoryImage.Height := mdRect.Height;
    MandatoryImage.Transparent := true;
    canvas.Draw(mdRect.Left,mdRect.top,MandatoryImage,100);
//    canvas.Draw(mdRect.Right-18,mdRect.top+2,MandatoryImage);
    MandatoryImage.free;
 // end;   }

  DrawArrowOnRect(canvas, Rect, p_sc.IsMoved(id), 0);

  { Mi := graphics.TBitmap.Create;
   mi.Height := mdRect.Height;
   Mi.Width := mdRect.Width;
   mi.canvas.Brush.color := clRed;
   mi.Canvas.Pen.Color := clRed;
   mi.Transparent := True;
   mi.TransparentColor := clRed;
   canvas.Draw(mdRect.Left,mdRect.Top,Mi, 255);
   mi.free;}

  //DrawOpacityBrush(canvas,mdRect.Left, mdRect.Top, mdRect.Width, mdRect.Height, CanvasStatus.brush.Color, 50,100);

  CanvasDates.Free;
  CanvasMater.Free;
  CanvasStatus.Free;

end;

//----------------------------------------------------------------------------//

procedure DrawGroup(Canvas: TCanvas; parms: PTRowParms; const rect: TRect; const IntPt, MatPt: integer);
var
  I:          Integer;
  id:         TSchedID;
  TypeActive: CScFlags;
  planInfo:   TSQPlanInfo;
  isGrp:      boolean;
  mdRect:     TRect;
  tinyRect:   TRect;
  IsTinyBar:  Boolean;
  StdPerc, StdTop:    integer;
  FillPerc, FillTop, Middle: integer;
  Bottom1,Bottom2,Bottom3: integer;
  Right1,Right2,Right3: integer;
  Left1,Left2,Left3: integer;
  Left33,Right33,left44,Right44, Left55,Right55,left66,Right66 : integer;
  Res: TMqmRes;
  QtyTosched: variant;
  GrpQty: double;
  ObjPlanInfo: TSQplanInfo;
  MultQty: double;
  dataType: CBinColValType;
  compId, TestedId, Item_Id:   TSchedID;
  PlanType : TPlanType;
  compFore,
  compBack: TCompatVal;
  supRec:   TSetupRec;
  CanvasDates: TCanvas;
  CanvasMater: TCanvas;
  CanvasStatus: TCanvas;
  IsSameGroup : boolean;
  AdditionalMultiplierProp : double;
  errSet: SetOfErrors;
  LearningCurveCode : string;
  PurchaseOrderLeadTimeList, DummyList : TList;
  RecNoMatDate: PTRecNoMatDate;
  DammyQty : double;
  n,x : Integer;
  Trans : Boolean;
  ACanvas : TcxCanvas;
  stripeJobClr: COLORREF;

  procedure CopyColor(CanvasToCopy: TCanvas);
  var
    TmpColor: TColor;
  begin
    Canvas.Pen   := CanvasToCopy.Pen;
    Canvas.Brush := CanvasToCopy.Brush;
    Canvas.Font  := CanvasToCopy.Font;

    if (Canvas.Brush.Style = bsBDiagonal)
    or (Canvas.Brush.Style = bsFDiagonal)
    or (Canvas.Brush.Style = bsDiagCross) then
    begin
      //set the background color
      TmpColor := Canvas.brush.Color;
      Canvas.brush.Color := Canvas.pen.Color;
      SetBkColor(Canvas.Handle, ColorToRGB(TmpColor));
      SetBkMode(Canvas.Handle, OPAQUE);
    end;
  end;

  procedure DrawSmoothRoundRect(ACanvas: TcxCanvas; const ARect: TRect; AColor, ABkColor: TColor;
  ARadiusX, ARadiusY: Integer; APenWidth: Integer = 1; APenColorAlpha: Byte = 255; ABrushColorAlpha: Byte = 255);
  var
    AGpCanvas: TdxGPCanvas;
  begin
    //ACanvas.Brush.Style := bsClear;
    AGpCanvas := TdxGPCanvas.Create(ACanvas.Handle);
    AGpCanvas.SmoothingMode := smAntiAlias;
    AGpCanvas.EnableAntialiasing(True);
    AGpCanvas.RoundRect(ARect, AColor, ABkColor, ARadiusX, ARadiusY, APenWidth, APenColorAlpha, ABrushColorAlpha);
    AGpCanvas.Free;
  end;

  procedure DrawGradientRoundRect(ACanvas: TcxCanvas; ARect: TRect;
    StartColor, EndColor, ABorderColor: TColor);
  var
    AGpCanvas: TdxGPCanvas;
    AGPBrush:  TdxGPBrush;
    AGPPen:    TdxGPPen;
  begin
    AGpCanvas := TdxGPCanvas.Create(ACanvas.Handle);
    AGpCanvas.SmoothingMode := smAntiAlias;
    AGpCanvas.EnableAntialiasing(True);
    AGPPen   := TdxGPPen.Create(ABorderColor, 1);
    AGPBrush := TdxGPBrush.Create;
    try
      AGPBrush.Style        := gpbsGradient;
      AGPBrush.GradientMode := gpbgmVertical;
      AGPBrush.GradientPoints.Add(0.0, dxColorToAlphaColor(StartColor, 255));
      AGPBrush.GradientPoints.Add(1.0, dxColorToAlphaColor(EndColor,   255));
      AGpCanvas.RoundRect(ARect, AGPPen, AGPBrush, Corner_Radius, Corner_Radius);
    finally
      AGPPen.Free;
      AGPBrush.Free;
      AGpCanvas.Free;
    end;
  end;

  procedure DrawPolygon3D(const Pts: array of TPoint; BaseColor: TColor;
    ClipLeft, ClipMid, ClipRight, ClipBottom: Integer);
  const
    NBands = 8;
  var
    BasRGB: COLORREF;
    ClipTop, TotalHeight, BandH, i, BTop, BBot, Light: Integer;
  begin
    BasRGB := ColorToRGB(BaseColor);
    // Draw full polygon with base color first
    Canvas.Brush.Color := BaseColor;
    Canvas.Polygon(Pts);
    // Derive top of fill area from ClipMid and ClipBottom
    ClipTop := 2 * ClipMid - ClipBottom;
    TotalHeight := ClipBottom - ClipTop;
    if TotalHeight <= 0 then Exit;
    BandH := Max(1, TotalHeight div NBands);
    // Overdraw from top to bottom in bands, each slightly less light than previous
    for i := 0 to NBands - 2 do
    begin
      BTop := ClipTop + i * BandH;
      BBot := BTop + BandH;
      Light := 70 - (i * 70 div (NBands - 1));
      IntersectClipRect(Canvas.Handle, ClipLeft, BTop, ClipRight, BBot);
      Canvas.Brush.Color := RGB(
        Min(255, Integer(GetRValue(BasRGB)) + Light),
        Min(255, Integer(GetGValue(BasRGB)) + Light),
        Min(255, Integer(GetBValue(BasRGB)) + Light));
      Canvas.Polygon(Pts);
      SelectClipRgn(Canvas.Handle, 0);
    end;
    Canvas.Brush.Color := BaseColor;
  end;

begin
  compBack := 0;
  if DBAppGlobals.MAINPLAN_Ignore_Pain_When_refresh then
     exit;

//  compId := CSchedIdNull;

  id := TSchedID(parms.objPtr);

  if not p_sc.TestPlanInfo(id) then
  begin
    exit;
  end;

  DummyList := nil;

  if IsDynamicPlanActiv then
    PlanType := PDynamic
  else
    PlanType := PNormal;

  CanvasDates  := TCanvas.Create;
  CanvasMater  := TCanvas.Create;
  CanvasStatus := TCanvas.Create;

  ACanvas := TcxCanvas.Create(Canvas);

  p_sc.GetPlanInfo(id, planInfo);

  if not Assigned(p_sc.GetExtLinkPtr(id)) then exit;

  mdRect := rect;

  // Enforce minimum bar width so very short jobs (e.g. 1-sec progress gap) render visibly
  IsTinyBar := False;
  if (mdRect.Right - mdRect.Left) < (Corner_Radius * 2 + 2) then
  begin
    mdRect.Right := mdRect.Left + Corner_Radius * 2 + 2;
    IsTinyBar := True;
    tinyRect   := mdRect;   // widened bar geometry (top/bottom still = rect)
  end;

  //Draw setup bar
  if (IntPt > 0) and (p_sc.isProgressed(id) = prg_none) then
  begin
    if MatPt > 0 then
    begin
      Canvas.Pen.Color := clYellow;
      Canvas.MoveTo(MatPt, mdRect.Top+1);
      Canvas.LineTo(MatPt, mdRect.Bottom -1);
    end;

//    p_sc.GetColors(id, true, CompValNotDef, PlanType, Canvas.brush, Canvas.pen, Canvas.font);
    p_sc.GetColors(id, true, CompValNotDef, PlanType, CanvasDates, CanvasMater, CanvasStatus);
    CopyColor(CanvasStatus);

    Canvas.Pen.Color := clBlack;

    Canvas.Brush.Color := clBlack;
    Canvas.Brush.Style := bsClear;
    mdRect.Right := IntPt;
    if (planInfo.stepType = CST_batch) then
      Canvas.Rectangle(mdRect);
    mdRect.Left  := mdRect.Right-1;
    mdRect.Right := rect.Right
  end;

  //Calculate compatibility values

 // compId := p_pl.GetCompatModeInPlanId;

  TestedId := p_pl.GetCompatModeInPlanId;
  if (TestedId <> CSchedIdNull) and p_sc.IsProdSchedMaterial(TestedId) then
  begin
    compId := TestedId;
    if p_sc.CheckItemAndProductForWarp(TestedId, Id, false, Item_Id, DammyQty) then
    begin
      compFore := 1;
      compBack := 1
    end
    else
    begin
      compFore := CompValNotValid;
      compBack := CompValNotValid
    end
  end
  else
  begin
    compId := p_pl.GetCompatModeInPlanId;
    if compId <> CSchedIdNull then
      p_sc.GetCompatWithOcc(id, compFore, compBack);
  end;

  if compId <> CSchedIdNull then
  begin
   // p_sc.GetCompatWithOcc(id, compFore, compBack);
    if compFore = CompValNotCached then
    begin
      res := TMqmRes(TMqmActArea(p_sc.GetExtLinkPtr(id)).p_res);
      if (compId = id) or (not res.p_occCanAttach) then
      begin
        compFore := CompValNotValid;
        compBack := CompValNotValid
      end
      else
      begin
        if not res.GetSetupParms(compId, id, supRec, compFore , IsSameGroup, LearningCurveCode) then
          compFore := CompValNotDef;
        if not res.GetSetupParms(id, compId, supRec, compBack, IsSameGroup, LearningCurveCode) then
          compBack := CompValNotDef
      end;
      p_sc.SetCompatWithOcc(id, compFore, compBack)
    end;
//    compFore := CompValNotValid;
//    compBack := CompValNotValid
  end{ else
  begin
    p_sc.CheckErrors(id, parms.errSet)
//    if not p_sc.CheckErrors(id, parms.errVal) then
//      parms.errVal := -1;
  end};

  //Mihailo
  if (PlanType = PDynamic) and not p_sc.HasFlags(id, [CSF_FilterJobsInDynamicGantt]) then
      Trans := True
    else
      Trans := False;

  Canvas.Brush.Style := bsSolid;
  ACanvas.Brush.Style := bsSolid;

  if (planInfo.stepType <> CST_batch) then
  begin
    //Draw continue bar
    with Acanvas do
    begin
      if (compId <> CSchedIdNull)
      and (compBack <> CompValNotValid) then
      begin
        mdRect.Right := mdRect.Left + Trunc((mdRect.Right - mdRect.Left)/2);
//        p_sc.GetColors(id, true, compBack, PlanType, brush, pen, font);

        p_sc.GetColors(id, true, compBack, PlanType, CanvasDates, CanvasMater, CanvasStatus);
        CopyColor(CanvasStatus);

        if Trans = False then
        begin
          stripeJobClr := ColorToRGB(Canvas.Brush.Color);
          DrawGradientRoundRect(ACanvas, mdRect,
            RGB(Min(255, Integer(GetRValue(stripeJobClr)) + 70),
                Min(255, Integer(GetGValue(stripeJobClr)) + 70),
                Min(255, Integer(GetBValue(stripeJobClr)) + 70)),
            Canvas.Brush.Color,
            Canvas.Pen.Color);
        end
        else
          TransRectangle(Canvas,mdRect,brush.Color);

        FilledLine := 0;
        //x := p_sc.GetMaxLineNum(id, isGrp, True);
       // for n := 1 to 4  do
        if not p_sc.IsProdSchedMaterial(TestedId) then
          DrawObjDesc(Canvas, mdRect, IntToStr(compBack),0);
        FilledLine := 0;

        mdRect.Left  := mdRect.Right;
        mdRect.Right := rect.Right
      end;

      if (compId = CSchedIdNull)
      and (compBack = CompValNotValid)
      and planInfo.isGroup then
      begin
//        p_sc.GetColors(id, true, compFore, PlanType, brush, pen, font);
        p_sc.GetColors(id, true, compFore, PlanType, CanvasDates, CanvasMater, CanvasStatus);
        CopyColor(CanvasStatus);
{
        for i := 0 to p_sc.GetGrpNumSons(grp)-1 do
        begin
          GrpJobId   := p_sc.GetGrpSon(grp, i);
          Res.GetSetupParms(job, GrpJobId, supRec, compatVal);
        end;
}
      end else
      begin
//        p_sc.GetColors(id, true, compFore, PlanType, brush, pen, font);
        p_sc.GetColors(id, true, compFore, PlanType, CanvasDates, CanvasMater, CanvasStatus);

        if (DBAppGlobals.ShowColorJobModeActivTab <> ScheduleStatus) and
           (DBAppGlobals.ShowColorJobModeActivTab <> Standard) then

        begin
          if DBAppGlobals.ShowColorJobModeActivTab = PreDefinedPropList then
          begin
            CanvasStatus.brush.Color := FindColorInDisplayedPropListActivTab(id);
          end
          else if DBAppGlobals.ShowColorJobModeActivTab = DinamicPropList then
          begin
            CanvasStatus.brush.Color := FindColorInDynamicListPropValues(id);
          end
        end
        else if DBAppGlobals.ShowColorJobModeActivTab = Standard then
        begin
          if DBAppGlobals.ShowColorJobMode = PreDefinedPropList then
          begin
            CanvasStatus.brush.Color := FindColorInDisplayedPropList(id);
          end
          else if DBAppGlobals.ShowColorJobMode = DinamicPropList then
          begin
            CanvasStatus.brush.Color := FindColorInDynamicListPropValues(id);
          end;
        end;

        CopyColor(CanvasStatus);
         mdRect.top := Rect.top;

        if Trans = False then
        begin
          stripeJobClr := ColorToRGB(Canvas.Brush.Color);
          DrawGradientRoundRect(ACanvas, mdRect,
            RGB(Min(255, Integer(GetRValue(stripeJobClr)) + 70),
                Min(255, Integer(GetGValue(stripeJobClr)) + 70),
                Min(255, Integer(GetBValue(stripeJobClr)) + 70)),
            Canvas.Brush.Color,
            Canvas.Pen.Color);
        end
        else
          TransRectangle(Canvas,mdRect,brush.Color);

        if (compId = CSchedIdNull) or (compId = id) then
          begin
          errSet := [];
          //Draw materials error bar
          PurchaseOrderLeadTimeList := TList.create;
          p_sc.CheckErrors(id, CSEG_Materials, errSet, PurchaseOrderLeadTimeList);
          if errSet <> [CSE_NoError] then
          begin
            CopyColor(CanvasMater);

            for i := 0 to PurchaseOrderLeadTimeList.Count -1 do
            begin
              RecNoMatDate := PurchaseOrderLeadTimeList.Items[i];
              if RecNoMatDate.m_StdPurcOrProdTime > 0 then
              begin
                if (planInfo.startDate >= RecNoMatDate.m_startStdPurcOrd) and
                   (planInfo.EndDate <= RecNoMatDate.m_endStdPurcOrd) then
                  Canvas.Brush.Color := Clwhite;
              end;
            end;

            mdRect.Bottom := mdRect.Top + round((mdRect.Bottom - mdRect.Top)/4);

            if Trans = False then
              FillRect(mdRect)
            else
              TransRectangle(Canvas,mdRect,brush.Color);

            mdRect.Bottom := rect.Bottom;


            for I := 0 to PurchaseOrderLeadTimeList.Count - 1 do
              dispose(PTRecNoMatDate(PurchaseOrderLeadTimeList[I]));
            PurchaseOrderLeadTimeList.Free;
          end;

          errSet := [];
          //Draw dates error bar
          p_sc.CheckErrors(id, CSEG_Dates, errSet, DummyList);
          if errSet <> [CSE_NoError] then
          begin
            CopyColor(CanvasDates);
            mdRect.Top := mdRect.Bottom - round((mdRect.Bottom - mdRect.Top)/4) -1;

            if Trans = False then
              //FillRect(mdRect)
              DrawSmoothRoundRect(ACanvas,
              mdRect,  //Rectangle
              Canvas.Brush.Color, //pen color
              Canvas.Brush.Color, //brush color
              Corner_Radius, Corner_Radius, //corner radius
              1, //border width
              255,  //transparent of pen
              255) //transparent of brush
            else
              TransRectangle(Canvas,mdRect,brush.Color);

            mdRect.top := rect.top;

          end;
        end;

        CopyColor(CanvasStatus);

      end;
      Brush.Style := bsClear;

      if Trans = False then
      begin
        //FillRect(mdRect);
        //Rectangle(rect);
        if IsTinyBar then
          // Very thin job: wrap the widened bar in a crisp, solid thin black border so it is visible
          DrawSmoothRoundRect(ACanvas,
          tinyRect,  //Rectangle
          clBlack, //pen color
          Canvas.Brush.Color, //brush color
          Corner_Radius, Corner_Radius, //corner radius
          1, //border width
          255,  //transparent of pen (fully opaque)
          0) //transparent of brush
        else
          DrawSmoothRoundRect(ACanvas,
          rect,  //Rectangle
          clBlack, //pen color
          Canvas.Brush.Color, //brush color
          Corner_Radius, Corner_Radius, //corner radius
          1, //border width
          100,  //transparent of pen
          0) //transparent of brush
      end
      else
        TransRectangle2(Canvas,Rect,canvas.Brush.color);
    end;

    FilledLine := 0;
    //canvas.Font.Name := 'Montserrat';
    if (compId = CSchedIdNull)
    or (compFore = CompValNotValid) then
    begin
   //   mdRect.Left := IntPt;
   //   DrawProgressed(canvas, mdRect, p_sc.IsProgressed(id));
      mdRect.Left := Rect.Left;
     // DrawObjDesc(Canvas, mdRect, p_sc.GetObjInfo(id, isGrp))


      x := p_sc.GetMaxLineNum(id, isGrp, True);
      for n := 1 to 4  do
        DrawObjDesc(Canvas, mdRect, p_sc.GetObjBarText(id, isGrp, true,n),x);

    end else
    begin
      mdRect.top := Rect.top;
      if not p_sc.IsProdSchedMaterial(TestedId) then
        DrawObjDesc(Canvas, mdRect, IntToStr(compFore),0);
    end;

     FilledLine := 0;

  end else
  begin
    //Draw Batch bar
    Res := TMqmRes(TMqmActArea(p_sc.GetExtLinkPtr(id)).p_res);
    p_sc.GetFldValue(id, CSC_QtyToSched, QtyTosched, dataType);
    GrpQty := QtyTosched;

    ////

    p_sc.GetPlanInfo(id, ObjPlanInfo);

    FillPerc := 100;
    StdPerc := 100;

    AdditionalMultiplierProp := res.P_GetAdditionalOptimumMaxMultiplierProp[Id];
    if not ObjPlanInfo.BatchSizePerStep then
    begin
      if ObjPlanInfo.MaxBatchSize <> -1 then
        p_sc.QtyInUM(id, res.p_BchUM, GrpQty, MultQty); // this line will not influence /// Avi
      if Res.p_Max_bch_size > 0 then
      begin
        FillPerc := trunc(GrpQty*100/Res.p_Max_bch_size*AdditionalMultiplierProp);
        StdPerc := trunc(Res.p_Sndt_bch_Size*AdditionalMultiplierProp*100/Res.p_Max_bch_size*AdditionalMultiplierProp);
      end;
    end
    else
    begin
      p_sc.QtyInUM(id, res.p_BchUM, GrpQty, MultQty);
      if ObjPlanInfo.MaxBatchSize > 0 then
      begin
        FillPerc := trunc(GrpQty*100/ObjPlanInfo.MaxBatchSize);
        StdPerc := trunc(ObjPlanInfo.MaxBatchSize*100/ObjPlanInfo.MaxBatchSize);
      end;
    end;

    with mdRect do
    begin
      FillTop := Bottom-Trunc((Bottom-Top)/100*FillPerc);
      StdTop := Bottom-Trunc((Bottom-Top)/100*StdPerc);
      Bottom1 := Bottom-Trunc((Bottom-Top)/100*50);
      Bottom2 := Bottom-Trunc((Bottom-Top)/100*35);
      Bottom3 := Bottom-Trunc((Bottom-Top)/100*15);
      Left1 := Left-Trunc((Left-Right)/100*10);
      Left2 := Left-Trunc((Left-Right)/100*4.5);
      Left3 := Left-Trunc((Left-Right)/100*1);
      Right1 := Right+Trunc((Left-Right)/100*10);
      Right2 := Right+Trunc((Left-Right)/100*4.5);
      Right3 := Right+Trunc((Left-Right)/100*1);
      Middle := Right+Trunc((Left-Right)/2);

      if (compId = CSchedIdNull) or (compBack = CompValNotValid)
      or (compFore = CompValNotValid) then
      begin
        p_sc.GetColors(id, true, CompValNotValid, PlanType, CanvasDates, CanvasMater, CanvasStatus);

        if DBAppGlobals.ShowColorJobModeActivTab = PreDefinedPropList then
          CanvasStatus.brush.Color := FindColorInDisplayedPropList(id)
        else if DBAppGlobals.ShowColorJobModeActivTab = DinamicPropList then
          CanvasStatus.brush.Color := FindColorInDynamicListPropValues(id)
        else if (DBAppGlobals.ShowColorJobMode = PreDefinedPropList) and (DBAppGlobals.ShowColorJobModeActivTab = PreDefinedPropList) then
          CanvasStatus.brush.Color := FindColorInDisplayedPropList(id)
        else if (DBAppGlobals.ShowColorJobMode = DinamicPropList) and (DBAppGlobals.ShowColorJobModeActivTab = DinamicPropList) then
          CanvasStatus.brush.Color := FindColorInDynamicListPropValues(id)
        else if (DBAppGlobals.ShowColorJobMode = PreDefinedPropList) and (DBAppGlobals.ShowColorJobModeActivTab = Standard) then
          CanvasStatus.brush.Color := FindColorInDisplayedPropList(id)
         else if (DBAppGlobals.ShowColorJobMode = DinamicPropList) and (DBAppGlobals.ShowColorJobModeActivTab = Standard) then
          CanvasStatus.brush.Color := FindColorInDynamicListPropValues(id);

        CopyColor(CanvasMater);
        PurchaseOrderLeadTimeList := TList.create;
        case FillPerc of
              0: begin
                 //   p_sc.GetColors(id, true, CompValNotDef, PlanType, CanvasDates, CanvasMater, CanvasStatus);
                    CopyColor(CanvasStatus);
                    Canvas.Brush.Style := bsDiagCross;
                    Canvas.Polygon([Point(Right, Top), Point(Right, Bottom1),
                                    Point(Right3, Bottom2), Point(Right2, Bottom3), Point(Right1, Bottom),
                                    Point(Left1, Bottom), Point(Left2, Bottom3), Point(Left3, Bottom2),
                                    Point(Left, Bottom1), Point(Left, Top)]);
                  end;

          101..999: begin  // avi 07/10/20118

                    FillTop := Top;
                    CopyColor(CanvasStatus);
                    DrawPolygon3D(
                      [Point(Right, FillTop), Point(Right, Bottom1),
                       Point(Right3, Bottom2), Point(Right2, Bottom3), Point(Right1, Bottom),
                       Point(Left1, Bottom), Point(Left2, Bottom3), Point(Left3, Bottom2),
                       Point(Left, Bottom1), Point(Left, FillTop)],
                      Canvas.Brush.Color,
                      Left, FillTop + (Bottom - FillTop) div 2, Right, Bottom + 1);
                    Canvas.Brush.Style := bsDiagCross;
                    Canvas.Polygon([Point(Right, Top), Point(Right, FillTop),
                                    Point(Left, FillTop), Point(Left, Top)]);

                    errSet := [];

                    p_sc.CheckErrors(id, CSEG_Materials, errSet, PurchaseOrderLeadTimeList);
                    if errSet <> [CSE_NoError] then
                    begin
                      Canvas.Brush.Style := bsSolid;
                      CopyColor(CanvasMater);
                      for i := 0 to PurchaseOrderLeadTimeList.Count -1 do
                      begin
                        RecNoMatDate := PurchaseOrderLeadTimeList.Items[i];
                        if RecNoMatDate.m_StdPurcOrProdTime > 0 then
                        begin
                          if (planInfo.startDate >= RecNoMatDate.m_startStdPurcOrd) and
                             (planInfo.EndDate <= RecNoMatDate.m_endStdPurcOrd) then
                            Canvas.Brush.Color := Clwhite;
                        end;
                      end;
                      Canvas.Polygon([Point(Left, Bottom1), Point(Left3, Bottom2),
                      Point(Right3, Bottom2), Point(Right, Bottom1)]);
                    end;

                    errSet := [];
                    p_sc.CheckErrors(id, CSEG_Dates, errSet, DummyList);
                    if errSet <> [CSE_NoError] then
                    begin
                      Canvas.Brush.Style := bsSolid;
                      CopyColor(CanvasDates);
                      Canvas.Polygon([Point(Left2, Bottom3), Point(Left1, Bottom),
                      Point(Right1, Bottom), Point(Right2, Bottom3)]);
                    end;

                   end;

          50..100: begin

                    CopyColor(CanvasStatus);
                    DrawPolygon3D(
                      [Point(Right, FillTop), Point(Right, Bottom1),
                       Point(Right3, Bottom2), Point(Right2, Bottom3), Point(Right1, Bottom),
                       Point(Left1, Bottom), Point(Left2, Bottom3), Point(Left3, Bottom2),
                       Point(Left, Bottom1), Point(Left, FillTop)],
                      Canvas.Brush.Color,
                      Left, FillTop + (Bottom - FillTop) div 2, Right, Bottom + 1);



                    errSet := [];
                 {   p_sc.CheckErrors(id, CSEG_Materials, errSet);
                    if errSet <> [CSE_NoError] then
                    begin
                      CopyColor(CanvasMater);
                      Canvas.Polygon([Point(Left, FillTop), Point(Left, Bottom1 - 3),
                      Point(Right, Bottom1 - 3),
                      Point(Right, FillTop)]);
                    end;

                    errSet := [];
                    p_sc.CheckErrors(id, CSEG_Dates, errSet);
                    if errSet <> [CSE_NoError] then
                    begin
                      Canvas.Brush.Style := bsSolid;
                      CopyColor(CanvasDates);
                      Canvas.Polygon([Point(Left2, Bottom3 - 4), Point(Left1, Bottom),
                      Point(Right1, Bottom), Point(Right2, Bottom3 - 4)]);

                    end; }

                    var YellowHeight := 0;
                    YellowHeight := height - (height - (100 div Trunc(500 div height)));

                    p_sc.CheckErrors(id, CSEG_Materials, errSet, PurchaseOrderLeadTimeList);
                    if errSet <> [CSE_NoError] then
                    begin
                      Canvas.Brush.Style := bsSolid;
                      CopyColor(CanvasMater);
                      for i := 0 to PurchaseOrderLeadTimeList.Count -1 do
                      begin
                        RecNoMatDate := PurchaseOrderLeadTimeList.Items[i];
                        if RecNoMatDate.m_StdPurcOrProdTime > 0 then
                        begin
                          if (planInfo.startDate >= RecNoMatDate.m_startStdPurcOrd) and
                             (planInfo.EndDate <= RecNoMatDate.m_endStdPurcOrd) then
                            Canvas.Brush.Color := Clwhite;
                        end;
                      end;
                      //YELLOW LINE
                      {Canvas.Polygon([Point(Left, Bottom1), Point(Left3, Bottom2),
                      Point(Right3, Bottom2), Point(Right, Bottom1)]); }

                      //CopyColor(CanvasStatus);
                      CopyColor(CanvasMater);
                      Canvas.Rectangle(Left, top, right,  top + YellowHeight);  //Error position on TOP

                      //CROSS LINE bellow yellow
                      CopyColor(CanvasStatus);
                      Canvas.Brush.Style := bsSolid;
                      Canvas.Pen.Color := Cl_STNDRD_LIGHT_BLUE;
                      Canvas.Brush.Color := clWhite;
                      Canvas.Polygon([Point(Right, Top+YellowHeight), Point(Right, FillTop+YellowHeight),
                                    Point(Left, FillTop +YellowHeight), Point(Left, Top +YellowHeight)]);
                    end else
                    begin
                    //CROSS LINE without yellow
                      CopyColor(CanvasStatus);
                      Canvas.Brush.Style := bsSolid;
                      Canvas.Pen.Color := Cl_STNDRD_LIGHT_BLUE;
                      Canvas.Brush.Color := clWhite;
                      //Canvas.Brush.Style := bsDiagCross;
                      Canvas.Polygon([Point(Right, Top), Point(Right, FillTop),
                                    Point(Left, FillTop), Point(Left, Top)]);
                    end;


                    errSet := [];
                    p_sc.CheckErrors(id, CSEG_Dates, errSet, DummyList);
                    if errSet <> [CSE_NoError] then
                    begin
                      Canvas.Brush.Style := bsSolid;
                      CopyColor(CanvasDates);

                      Canvas.Polygon([Point(Left2, Bottom3), Point(Left1, Bottom),
                      Point(Right1, Bottom), Point(Right2, Bottom3)]);
                    end;


                  end;
          35..49: begin

                    CopyColor(CanvasStatus);
                    DrawPolygon3D(
                      [Point(Right, Bottom1), Point(Right3, Bottom2),
                       Point(Right2, Bottom3), Point(Right1, Bottom),
                       Point(Left1, Bottom), Point(Left2, Bottom3),
                       Point(Left3, Bottom2), Point(Left, Bottom1)],
                      Canvas.Brush.Color,
                      Left, Bottom1 + (Bottom - Bottom1) div 2, Right, Bottom + 1);

                    Canvas.Brush.Style := bsDiagCross;
                    Canvas.Polygon([Point(Right, Top), Point(Right, Bottom1),
                                    Point(Left, Bottom1), Point(Left, Top)]);

                    errSet := [];
                    p_sc.CheckErrors(id, CSEG_Materials, errSet, PurchaseOrderLeadTimeList);
                    if errSet <> [CSE_NoError] then
                    begin
                      Canvas.Brush.Style := bsSolid;
                      CopyColor(CanvasMater);
                      for i := 0 to PurchaseOrderLeadTimeList.Count -1 do
                      begin
                        RecNoMatDate := PurchaseOrderLeadTimeList.Items[i];
                        if RecNoMatDate.m_StdPurcOrProdTime > 0 then
                        begin
                          if (planInfo.startDate >= RecNoMatDate.m_startStdPurcOrd) and
                             (planInfo.EndDate <= RecNoMatDate.m_endStdPurcOrd) then
                            Canvas.Brush.Color := Clwhite;
                        end;
                      end;
                      Canvas.Polygon([Point(Left, Bottom1), Point(Left3, Bottom2),
                      Point(Right3, Bottom2), Point(Right, Bottom1)]);
                    end;

                    errSet := [];
                    p_sc.CheckErrors(id, CSEG_Dates, errSet, DummyList);
                    if errSet <> [CSE_NoError] then
                    begin
                      Canvas.Brush.Style := bsSolid;
                      CopyColor(CanvasDates);
                      Canvas.Polygon([Point(Left2, Bottom3), Point(Left1, Bottom),
                      Point(Right1, Bottom), Point(Right2, Bottom3)]);
                    end;

                  end;
          1..34: begin
                    CopyColor(CanvasStatus);
                    DrawPolygon3D(
                      [Point(Right3, Bottom2), Point(Right2, Bottom3), Point(Right1, Bottom),
                       Point(Left1, Bottom), Point(Left2, Bottom3), Point(Left3, Bottom2)],
                      Canvas.Brush.Color,
                      Left, Bottom2 + (Bottom - Bottom2) div 2, Right, Bottom + 1);
                    Canvas.Brush.Style := bsDiagCross;
                    Canvas.Polygon([Point(Right, Top), Point(Right, Bottom1),
                                    Point(Right3, Bottom2), Point(Left3, Bottom2),
                                    Point(Left, Bottom1), Point(Left, Top)]);

                    Left33 := Trunc(Left1 - left3);
                    Left33 := Trunc(Left33/3) - 2;
                    Left33 := Left3 + Left33;
                    Right33 := Trunc(Bottom - Bottom2);
                    Right33 := Trunc(Right33/3);
                    Right33 := Bottom2 + Right33;

                    left44 := Trunc(Right3 - Right1);
                    left44 := Trunc(left44/3) - 2;
                    left44 := Right3 - left44;
                    Right44 := Trunc(Bottom - Bottom2);
                    Right44 := Trunc(Right44/3);
                    Right44 := Bottom2 + Right44;

                    Left55 := Trunc(Left1 - left3);
                    Left55 := Trunc(Left55/3);
                    Left55 := Left1 - Left55 -1 ;
                    Right55 := Trunc(Bottom - Bottom2);
                    Right55 := Trunc(Right55/3 - 1);
                    Right55 := Bottom - Right55 - 1;

                    left66 := Trunc(Right3 - Right1);
                    left66 := Trunc(left66/3);
                    left66 := Right1 + left66 + 1;
                    Right66 := Trunc(Bottom - Bottom2);
                    Right66 := Trunc(Right66/3) - 1;
                    Right66 := Bottom - Right66 - 1;

                    errSet := [];
                    p_sc.CheckErrors(id, CSEG_Materials, errSet, PurchaseOrderLeadTimeList);
                    if errSet <> [CSE_NoError] then
                    begin
                      Canvas.Brush.Style := bsSolid;
                      CopyColor(CanvasMater);
                      for i := 0 to PurchaseOrderLeadTimeList.Count -1 do
                      begin
                        RecNoMatDate := PurchaseOrderLeadTimeList.Items[i];
                        if RecNoMatDate.m_StdPurcOrProdTime > 0 then
                        begin
                          if (planInfo.startDate >= RecNoMatDate.m_startStdPurcOrd) and
                             (planInfo.EndDate <= RecNoMatDate.m_endStdPurcOrd) then
                            Canvas.Brush.Color := Clwhite;
                        end;
                      end;
                      Canvas.Polygon([Point(Left3, Bottom2), Point(Left33, Right33), Point(Left44, Right44),
                      Point(Right3, Bottom2)]);
                    end;

                    errSet := [];
                    p_sc.CheckErrors(id, CSEG_Dates, errSet, Dummylist);
                    if errSet <> [CSE_NoError] then
                    begin
                      Canvas.Brush.Style := bsSolid;
                      CopyColor(CanvasDates);
                      Canvas.Polygon([Point(Left55, Right55), Point(Left1, Bottom), Point(Right1, Bottom),
                      Point(Left66, Right66)]);
                    end;

                  end;
          { 1..14: begin

                    p_sc.GetColors(id, true, CompValNotDef, PlanType, CanvasDates, CanvasMater, CanvasStatus);
                    CopyColor(CanvasStatus);

                    Canvas.Polygon([Point(Right2, Bottom3), Point(Right1, Bottom),
                                    Point(Left1, Bottom), Point(Left2, Bottom3)]);
                    Canvas.Brush.Style := bsDiagCross;
                    Canvas.Polygon([Point(Right, Top), Point(Right, Bottom1),
                                    Point(Right3, Bottom2), Point(Right2, Bottom3),
                                    Point(Left2, Bottom3), Point(Left3, Bottom2),
                                    Point(Left, Bottom1), Point(Left, Top)]);
                  end;  }
        else
          Canvas.Polygon([Point(Right, Top), Point(Right, Bottom1),
                          Point(Right3, Bottom2), Point(Right2, Bottom3), Point(Right1, Bottom),
                          Point(Left1, Bottom), Point(Left2, Bottom3), Point(Left3, Bottom2),
                          Point(Left, Bottom1), Point(Left, Top)]);
        end;

        for I := 0 to PurchaseOrderLeadTimeList.Count - 1 do
          dispose(PTRecNoMatDate(PurchaseOrderLeadTimeList[I]));
        PurchaseOrderLeadTimeList.Free;

        Canvas.Brush.Style := bsSolid;
        Canvas.Pen.Color := ClBlack;//clWhite;
        case StdPerc of
         50..99: begin
                   Canvas.MoveTo(Left+1, StdTop);
                   Canvas.LineTo(Right-1, StdTop)
                 end;
         35..49: begin
                   Canvas.MoveTo(Left+1, Bottom1);
                   Canvas.LineTo(Right-1, Bottom1)
                 end;
         15..34: begin
                   Canvas.MoveTo(Left3+1, Bottom2);
                   Canvas.LineTo(Right3-1, Bottom2)
                 end;
         1..14: begin
                   Canvas.MoveTo(Left2+1, Bottom3);
                   Canvas.LineTo(Right2-1, Bottom3)
                 end;
              0: begin
                   Canvas.MoveTo(Left1+1, Bottom);
                   Canvas.LineTo(Right1-1, Bottom)
                 end;
        else
          begin
            Canvas.MoveTo(Left+1, Top);
            Canvas.LineTo(Right-1, Top)
          end
        end;

      end else
      begin
        case FillPerc of
              0: begin
                    Canvas.Brush.Style := bsDiagCross;
                    if IsDynamicPlanActiv then
                    begin
                      p_sc.GetColors(id, true, compBack, PlanType, CanvasDates, CanvasMater, CanvasStatus);
                      CopyColor(CanvasStatus);
                    end;
                    Canvas.Polygon([Point(Middle, Top), Point(Middle, Bottom),
                                    Point(Left1, Bottom), Point(Left2, Bottom3), Point(Left3, Bottom2),
                                    Point(Left, Bottom1), Point(Left, Top)]);
                    p_sc.GetColors(id, true, compFore, PlanType, CanvasDates, CanvasMater, CanvasStatus);
                    CopyColor(CanvasStatus);
                    Canvas.Polygon([Point(Right, Top), Point(Right, Bottom1),
                                    Point(Right3, Bottom2), Point(Right2, Bottom3), Point(Right1, Bottom),
                                    Point(Middle, Bottom), Point(Middle, Top)]);
                  end;
          50..99: begin
                    p_sc.GetColors(id, true, compBack, PlanType, CanvasDates, CanvasMater, CanvasStatus);
                    CopyColor(CanvasStatus);
                    DrawPolygon3D(
                      [Point(Middle, FillTop), Point(Middle, Bottom),
                       Point(Left1, Bottom), Point(Left2, Bottom3), Point(Left3, Bottom2),
                       Point(Left, Bottom1), Point(Left, FillTop)],
                      Canvas.Brush.Color,
                      Left, FillTop + (Bottom - FillTop) div 2, Middle, Bottom + 1);
                    Canvas.Brush.Style := bsDiagCross;
                    Canvas.Polygon([Point(Middle, Top), Point(Middle, FillTop),
                                    Point(Left, FillTop), Point(Left, Top)]);
                    p_sc.GetColors(id, true, compFore, PlanType, CanvasDates, CanvasMater, CanvasStatus);
                    CopyColor(CanvasStatus);
                    Canvas.Brush.Style := bsSolid;
                    DrawPolygon3D(
                      [Point(Right, FillTop), Point(Right, Bottom1),
                       Point(Right3, Bottom2), Point(Right2, Bottom3), Point(Right1, Bottom),
                       Point(Middle, Bottom), Point(Middle, FillTop)],
                      Canvas.Brush.Color,
                      Middle, FillTop + (Bottom - FillTop) div 2, Right, Bottom + 1);
                    Canvas.Brush.Style := bsDiagCross;
                    Canvas.Polygon([Point(Right, Top), Point(Right, FillTop),
                                    Point(Middle, FillTop), Point(Middle, Top)]);
                  end;
          35..49: begin
                    p_sc.GetColors(id, true, compBack, PlanType, CanvasDates, CanvasMater, CanvasStatus);
                    CopyColor(CanvasStatus);
                    DrawPolygon3D(
                      [Point(Middle, Bottom1), Point(Middle, Bottom),
                       Point(Left1, Bottom), Point(Left2, Bottom3),
                       Point(Left3, Bottom2), Point(Left, Bottom1)],
                      Canvas.Brush.Color,
                      Left, Bottom1 + (Bottom - Bottom1) div 2, Middle, Bottom + 1);
                    Canvas.Brush.Style := bsDiagCross;
                    Canvas.Polygon([Point(Middle, Top), Point(Middle, Bottom1),
                                    Point(Left, Bottom1), Point(Left, Top)]);
                    p_sc.GetColors(id, true, compFore, PlanType, CanvasDates, CanvasMater, CanvasStatus);
                    CopyColor(CanvasStatus);
                    Canvas.Brush.Style := bsSolid;
                    DrawPolygon3D(
                      [Point(Right, Bottom1), Point(Right3, Bottom2),
                       Point(Right2, Bottom3), Point(Right1, Bottom),
                       Point(Middle, Bottom), Point(Middle, Bottom1)],
                      Canvas.Brush.Color,
                      Middle, Bottom1 + (Bottom - Bottom1) div 2, Right, Bottom + 1);
                    Canvas.Brush.Style := bsDiagCross;
                    Canvas.Polygon([Point(Right, Top), Point(Right, Bottom1),
                                    Point(Middle, Bottom1), Point(Middle, Top)]);
                  end;
          15..34: begin
                    p_sc.GetColors(id, true, compBack, PlanType, CanvasDates, CanvasMater, CanvasStatus);
                    CopyColor(CanvasStatus);
                    DrawPolygon3D(
                      [Point(Middle, Bottom2), Point(Middle, Bottom),
                       Point(Left1, Bottom), Point(Left2, Bottom3), Point(Left3, Bottom2)],
                      Canvas.Brush.Color,
                      Left, Bottom2 + (Bottom - Bottom2) div 2, Middle, Bottom + 1);
                    Canvas.Brush.Style := bsDiagCross;
                    Canvas.Polygon([Point(Middle, Top),
                                    Point(Middle, Bottom2), Point(Left3, Bottom2),
                                    Point(Left, Bottom1), Point(Left, Top)]);
                    p_sc.GetColors(id, true, compFore, PlanType, CanvasDates, CanvasMater, CanvasStatus);
                    CopyColor(CanvasStatus);
                    Canvas.Brush.Style := bsSolid;
                    DrawPolygon3D(
                      [Point(Right3, Bottom2), Point(Right2, Bottom3), Point(Right1, Bottom),
                       Point(Middle, Bottom), Point(Middle, Bottom2)],
                      Canvas.Brush.Color,
                      Middle, Bottom2 + (Bottom - Bottom2) div 2, Right, Bottom + 1);
                    Canvas.Brush.Style := bsDiagCross;
                    Canvas.Polygon([Point(Right, Top), Point(Right, Bottom1),
                                    Point(Right3, Bottom2), Point(Middle, Bottom2),
                                    Point(Middle, Top)]);
                  end;
           1..14: begin
                    p_sc.GetColors(id, true, compBack, PlanType, CanvasDates, CanvasMater, CanvasStatus);
                    CopyColor(CanvasStatus);
                    DrawPolygon3D(
                      [Point(Middle, Bottom3), Point(Middle, Bottom),
                       Point(Left1, Bottom), Point(Left2, Bottom3)],
                      Canvas.Brush.Color,
                      Left, Bottom3 + (Bottom - Bottom3) div 2, Middle, Bottom + 1);
                    Canvas.Brush.Style := bsDiagCross;
                    Canvas.Polygon([Point(Middle, Top), Point(Middle, Bottom3),
                                    Point(Left2, Bottom3), Point(Left3, Bottom2),
                                    Point(Left, Bottom1), Point(Left, Top)]);
                    p_sc.GetColors(id, true, compFore, PlanType, CanvasDates, CanvasMater, CanvasStatus);
                    CopyColor(CanvasStatus);
                    Canvas.Brush.Style := bsSolid;
                    DrawPolygon3D(
                      [Point(Right2, Bottom3), Point(Right1, Bottom),
                       Point(Middle, Bottom), Point(Middle, Bottom3)],
                      Canvas.Brush.Color,
                      Middle, Bottom3 + (Bottom - Bottom3) div 2, Right, Bottom + 1);
                    Canvas.Brush.Style := bsDiagCross;
                    Canvas.Polygon([Point(Right, Top), Point(Right, Bottom1),
                                    Point(Right3, Bottom2), Point(Right2, Bottom3),
                                    Point(Middle, Bottom3), Point(Middle, Top)]);
                  end;
        else
          begin
            p_sc.GetColors(id, true, compBack, PlanType, CanvasDates, CanvasMater, CanvasStatus);
            CopyColor(CanvasStatus);
            DrawPolygon3D(
              [Point(Middle, Top), Point(Middle, Bottom),
               Point(Left1, Bottom), Point(Left2, Bottom3), Point(Left3, Bottom2),
               Point(Left, Bottom1), Point(Left, Top)],
              Canvas.Brush.Color,
              Left, Top + (Bottom - Top) div 2, Middle, Bottom + 1);
            p_sc.GetColors(id, true, compFore, PlanType, CanvasDates, CanvasMater, CanvasStatus);
            CopyColor(CanvasStatus);
            Canvas.Brush.Style := bsSolid;
            DrawPolygon3D(
              [Point(Right, Top), Point(Right, Bottom1),
               Point(Right3, Bottom2), Point(Right2, Bottom3), Point(Right1, Bottom),
               Point(Middle, Bottom), Point(Middle, Top)],
              Canvas.Brush.Color,
              Middle, Top + (Bottom - Top) div 2, Right, Bottom + 1);
          end
        end;

      end;
      Canvas.Brush.Style := bsSolid;
    end;

    FilledLine := 0;
    if (compId = CSchedIdNull) or (compBack = CompValNotValid)
    or (compFore = CompValNotValid) then
    begin
    //  mdRect.Left := IntPt;
    //  mdRect.Bottom := Bottom2;
    //  DrawProgressed(canvas, mdRect, p_sc.IsProgressed(id));
      mdRect.Left := Rect.Left;
      mdRect.Bottom := Rect.Bottom;
      //DrawObjDesc(Canvas, mdRect, p_sc.GetObjInfo(id, isGrp))

      x := p_sc.GetMaxLineNum(id, isGrp, True);
      for n := 1 to 4  do
        DrawObjDesc(Canvas, mdRect, p_sc.GetObjBarText(id, isGrp, true,n),x);

    end else
    begin
      mdRect.Right := Middle;
      p_sc.GetColors(id, true, compBack, PlanType, CanvasDates, CanvasMater, CanvasStatus);
      CopyColor(CanvasStatus);
      DrawObjDesc(Canvas, mdRect, IntToStr(compBack),0);
      mdRect.Left := Middle;
      mdRect.Right := Rect.Right;
      p_sc.GetColors(id, true, compFore, PlanType, CanvasDates, CanvasMater, CanvasStatus);
      DrawObjDesc(Canvas, mdRect, IntToStr(compFore),0);
    end;

    FilledLine := 0;
  end;

  mdRect := Rect;
  mdRect.Left := IntPt;
  DrawArrowOnRect(canvas, Rect, p_sc.IsMoved(id), 0);

  CanvasDates.Free;
  CanvasMater.Free;
  CanvasStatus.Free;
  Acanvas.Free;
end;

//----------------------------------------------------------------------------//

procedure DrawCmp(Canvas: TCanvas; parms: PTRowParms; const rect: TRect; const IntPt, MatPt: integer);
var
  cmp: TMqmCmp;
begin
  cmp := TMqmCmp(parms.objPtr);
  GetCapResCompatColor(cmp.m_diffVal, true, canvas.brush, canvas.pen, canvas.font);
  canvas.Pen.Width := 1;
//  Canvas.Rectangle(rect);  //avi
end;

//----------------------------------------------------------------------------//

procedure SetDrawPos(var PercTop: double; var PercHeight: double; ShapeType: TMqmShapeType);
begin
  case ShapeType of
      st_ActArea: begin
                    PercTop     := 0.05;
                    PercHeight  := 0.95;
                  end;

      st_Warp_1lvl : begin
                       PercTop     := 0.1;
                       PercHeight  := 0.15;
                     end;

      st_Warp_2lvl : begin
                       PercTop     := 0.3;
                       PercHeight  := 0.15;//0.15;
                     end;

       st_CapRes: begin
                    PercTop     := 0.2;
                    PercHeight  := 0.15;
                  end;

     st_DownTime: begin
                    if DBAppSettings.DisableCapRes then
                    begin
                      PercTop     := 0.25;
                      PercHeight  := 0.6;
                    end else
                    begin
                      PercTop     := 0.2;
                      PercHeight  := 0.72;
                    end;
                  end;

    st_CrossDownTime : begin
                    if DBAppSettings.DisableCapRes then
                    begin
                      PercTop     := 0.25;
                      PercHeight  := 0.6;
                    end else
                    begin
                      PercTop     := 0.2;
                      PercHeight  := 0.32;
                    end;
                  end;

        st_Group: begin
                    if DBAppSettings.DisableCapRes then
                    begin
                      PercTop     := 0.25;
                      PercHeight  := 0.6;
                    end else
                    begin
                      PercTop     := 0.55;
                      PercHeight  := 0.38;
                    end;
                  end;

     st_schedObj: begin
                    if DBAppSettings.DisableCapRes then
                    begin
//                      PercTop     := 0.25;
                      PercTop     := 0.3;
                      PercHeight  := 0.6;
                    end else
                    begin
                      PercTop     := 0.55;
//                      PercHeight  := 0.38;
                      PercHeight  := 0.37;
                    end;
                  end;

       st_Compat: begin
                    PercTop     := 0.37;
//                    PercHeight  := 0.15;
                    PercHeight  := 0.10;
                  end;
  end;
end;

//----------------------------------------------------------------------------//

function GetErrorDesc(ErrIndex: CScErrors): string;
var
  Err: integer;
begin
  try
//  Err := integer(ErrIndex);
//  Result := DBAppGlobals.JobStatusColor[Err].Dsc;

  case ErrIndex of
    CSE_Temp        : Result := DBAppGlobals.JobStatusColor[0].Dsc;
    CSE_Level1      : Result := DBAppGlobals.JobStatusColor[1].Dsc;
    CSE_Level2      : Result := DBAppGlobals.JobStatusColor[2].Dsc;
    CSE_Level3      : Result := DBAppGlobals.JobStatusColor[3].Dsc;
    CSE_Level4      : Result := DBAppGlobals.JobStatusColor[4].Dsc;
    CSE_Level5      : Result := DBAppGlobals.JobStatusColor[5].Dsc;
    CSE_Final       : Result := DBAppGlobals.JobStatusColor[6].Dsc;
    CSE_NotFinProg  : Result := DBAppGlobals.JobStatusColor[7].Dsc;
    CSE_FinProg     : Result := DBAppGlobals.JobStatusColor[8].Dsc;
    CSE_Closed      : Result := DBAppGlobals.JobStatusColor[9].Dsc;

    CSE_DelDate     : Result := DBAppGlobals.JobDateWarningColor[0].Dsc;
    CSE_HighEndDate : Result := DBAppGlobals.JobDateWarningColor[1].Dsc;
    CSE_LowStrDate  : Result := DBAppGlobals.JobDateWarningColor[2].Dsc;
    CSE_ApprovalDate  : Result := DBAppGlobals.JobDateWarningColor[3].Dsc;

    CSE_Materials : Result := DBAppGlobals.JobMatWarningColor[1].Dsc;
    CSE_AddRes    : Result := DBAppGlobals.JobMatWarningColor[2].Dsc;
    CSE_LeftOvlp,
    CSE_RightOvlp,
    CSE_BothOvlp  : Result := DBAppGlobals.JobMatWarningColor[0].Dsc;
  else
    Result := _('Undefined')
  end;
  Except
    Result := _('Undefined');
  end;
end;

//----------------------------------------------------------------------------//
 {
function GetCapResDesc(ResIndex: integer): string;
begin
    Result := _('Undefined')
end;
  }
//----------------------------------------------------------------------------//

function GetGroupProp(pId: TSchedID; ptr: pointer): TProperties;
var
  Obj: TMqmObj;
begin
  Result := nil;

  if Assigned(ptr) then
  begin
    Obj := ptr;
    if (Obj is TMqmActArea) then
      Result := TMqmRes(TMqmActArea(Obj).p_Res).GetPropListForGroup(pId)
    else
      if Obj is TMqmRes then
        Result := TMqmRes(Obj).GetPropListForGroup(pId);
  end;
end;

//----------------------------------------------------------------------------//

procedure LinkAssPropAndDraw(Link: PTLink; Canvas: TCanvas; assObj: TObject; shMan: TShapeManager);
var
  oldPenColor: TColor;
  StDs, EndDs: TDurShape;
begin
  oldPenColor := Canvas.Pen.Color;
  Canvas.Pen.Color := clwhite;
  Canvas.Pen.Width := 2;

  case Link.LK_Type of
    LT_ConnJob: Canvas.Pen.Color := clGreen;
    LT_SameStep: Canvas.Pen.Color := clBlue;
    LT_DiffStep: Canvas.Pen.Color := clNavy;
    LT_ConnReq: Canvas.Pen.Color := clPurple;
  end;

  StDs := shMan.GetShapeForObj(Link.LK_StObj);
  EndDs := shMan.GetShapeForObj(Link.LK_EndObj);

//  GetRowYFromObj

  if Assigned(StDs)
  and Assigned(EndDs) then
    DrawLink(Canvas, StDs.m_rect.Left + (StDs.m_rect.Right - StDs.m_rect.Left) div 2,
                     StDs.m_rect.Top + (StDs.m_rect.Bottom - StDs.m_rect.Top) div 2,
                     EndDs.m_rect.Left + (EndDs.m_rect.Right - EndDs.m_rect.Left) div 2,
                     EndDs.m_rect.Top + (EndDs.m_rect.Bottom - EndDs.m_rect.Top) div 2);

  Canvas.Pen.Color := oldPenColor
end;

//----------------------------------------------------------------------------//

procedure TransRectangle(Canvas:TCanvas;R:TRect;C:TColor);
Var
 tmpBMP: Graphics.TBitmap;
 Blend:_BLENDFUNCTION;
 Opacity : byte;
begin
  Opacity := 20;

   tmpBMP:= Graphics.TBitmap.Create;
   try
    tmpBMP.PixelFormat := pf24bit;
    tmpBMP.SetSize(1,1);
    tmpBMP.Width:= r.Width;
    tmpBMP.Height:= r.Height;
    tmpBMP.Canvas.Pixels[0,0]:=C;
    tmpBmp.IgnorePalette := True;
    tmpBmp.AlphaFormat := afPremultiplied;

    Blend.BlendOp:=AC_SRC_OVER;
    Blend.BlendFlags:=0;
    Blend.SourceConstantAlpha:=(50+255*Opacity) Div 100;
    Blend.AlphaFormat:=0;
    AlphaBlend(Canvas.Handle,R.Left,R.Top,R.Right-R.Left,R.Bottom-R.Top,tmpBMP.Canvas.Handle,0,0,1,1,Blend);
   finally
    tmpBMP.Free;
   end;

 tmpBMP.Empty;
end;

procedure TransRectangle2(Canvas:TCanvas;R:TRect;C:TColor);
Var
 tmpBMP: Graphics.TBitmap;
 Blend:_BLENDFUNCTION;
 Opacity : byte;
 TopLine,LeftLine,RightLine,BottomLine : TRect;
begin
  Opacity := 20;
  canvas.Brush.Style := bsClear;

   tmpBMP:= Graphics.TBitmap.Create;
   try
      //Top Line
      TopLine.TopLeft := r.TopLeft;
      TopLine.Height := 1;
      TopLine.Width := r.Width;

      tmpBMP.PixelFormat := pf24bit;
      tmpBMP.SetSize(1,1);
      tmpBMP.Width:= TopLine.Width;
      tmpBMP.Height:= TopLine.Height;
      tmpBMP.Canvas.Pixels[0,0] := clBLack;
      tmpBmp.IgnorePalette := True;
      tmpBmp.AlphaFormat := afPremultiplied;
      tmpBmp.FreeImage;

      Blend.BlendOp := AC_SRC_OVER;
      Blend.BlendFlags := 0;
      Blend.SourceConstantAlpha := (50+255*Opacity) Div 100;
      Blend.AlphaFormat := 0;
      AlphaBlend(Canvas.Handle,TopLine.Left,TopLine.Top,TopLine.Right-TopLine.Left,TopLine.Bottom-TopLine.Top,tmpBMp.Canvas.Handle,0,0,1,1,Blend);

     //Left line
     LeftLine.TopLeft := r.TopLeft;
     LeftLine.Height := r.Height;
     LeftLine.Width := 1;

     tmpBMP.Width:= LeftLine.Width;
     tmpBMP.Height:= LeftLine.Height;
     AlphaBlend(Canvas.Handle,LeftLine.Left,LeftLine.Top,LeftLine.Right-LeftLine.Left,LeftLine.Bottom-LeftLine.Top,tmpBMP.Canvas.Handle,0,0,1,1,Blend);

     //Right Line

     RightLine.Left := LeftLine.Left + TopLine.Width;
     RightLine.Top := LeftLine.Top;
     RightLine.Height := r.Height;
     RightLine.Width := 1;

     tmpBMP.Width:= RightLine.Width;
     tmpBMP.Height:= RightLine.Height;
     AlphaBlend(Canvas.Handle,RightLine.Left,RightLine.Top,RightLine.Right-RightLine.Left,RightLine.Bottom-RightLine.Top,tmpBMP.Canvas.Handle,0,0,1,1,Blend);

     //Bottom line
     BottomLIne.Left := TopLine.Left;
     BottomLIne.Top := TopLine.Top + R.Height;
     BottomLIne.Height := 1;
     BottomLIne.Width := TopLine.Width;

     tmpBMP.Width:= BottomLIne.Width;
     tmpBMP.Height:= BottomLIne.Height;

     AlphaBlend(Canvas.Handle,BottomLIne.Left,BottomLIne.Top,BottomLIne.Right-BottomLIne.Left,BottomLIne.Bottom-BottomLIne.Top,tmpBMP.Canvas.Handle,0,0,1,1,Blend);

   finally
    tmpBMP.Free;
   end;

end;

end.

