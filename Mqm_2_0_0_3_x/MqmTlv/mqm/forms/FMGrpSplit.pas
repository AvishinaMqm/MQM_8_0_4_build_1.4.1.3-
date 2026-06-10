unit FMGrpSplit;

interface

uses
  cxButtons, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, UMSchedContFunc, StdCtrls, ExtCtrls, ComCtrls, UMSchedView, UMSchedList,
  UMObjCont, UMOpStack, Buttons, UReShape, Math;

type

  TSplitGroupData = record
    Id_Grp     : TSchedId;
    SplitPercent : double;
    NewGrpNr   : integer;
  end;
  PTSplitGroupData = ^TSplitGroupData;

  TGrpSplit = class(TForm)
    PgcGrp: TPageControl;
    PanOp: TPanel;
    BtnOk: TcxButton;
    BtnCanc: TcxButton;
    procedure FormCreate(Sender: TObject);
    procedure BtnCancClick(Sender: TObject);
    procedure BtnOkClick(Sender: TObject);
  private
    m_GrpId : TSchedId;
    m_msgError   : string;
//    m_GrpSchedList : TMSchedList;
    m_SplitGroupData : TSplitGroupData;
    m_markStack      : TStackMark;

    procedure CreateNewGroupAndSplit;
  public
    constructor CreateGrpSplit(AOwner : TComponent; SplitGroupData : TSplitGroupData);
    function GetmsgError : string;
  end;

  function SplitGroup(GroupId : TSchedId; SplitJobQty: currency; Use_opStack : boolean): TSchedId;

var
  GrpSplit: TGrpSplit;

implementation

{$R *.dfm}

uses UMPlanFunc;

{ TGrpSplit }

//----------------------------------------------------------------------------//

function SplitGroup(GroupId : TSchedId; SplitJobQty: currency; Use_opStack : boolean) : TSchedId;
var
  QtyPerJob, OrigJobQty, EachJobQty, RemainQty: currency;
  NewJobNr: integer;
  NewId, ChildId, m_Newgrp : TSchedID;
  Err: string;
  List : TList;
  I,J, JobQtyInt : Integer;
  value: variant;
  dataType: CBinColValType;
  GroupQty, JobQty : double;
  TabSheet : TTabSheet;
  m_GrpSchedList : TMSchedList;
  ArraySchedList : array of TMSchedList;
  schedListView  : TMSchedListView;
  SplitPercent   : double;
  DecMult        : integer;
begin
  Result := CSchedIDnull;
  DecMult := Round(IntPower(10, p_sc.GetJobNumOfDecimals(GroupId)));
  List := nil;
//  p_opStack.MarkStackForButtonUndo('Split Job');
  m_GrpSchedList := TMSchedList.Create(application);

  p_sc.GetFldValue(GroupId, CSC_QtyToSched, value, dataType);
  GroupQty := value;

  SplitPercent := SplitJobQty/GroupQty;

  for I := 0 to p_sc.GetGrpNumSons(GroupId) - 1 do
  begin
    ChildId := p_sc.GetGrpSon(GroupId, I);
    p_sc.GetFldValue(ChildId, CSC_QtyToSched, value, dataType);
    JobQty := value;

    JobQtyInt := trunc(JobQty * SplitPercent * DecMult);
    EachJobQty := JobQtyInt / DecMult;

    RemainQty := JobQty - EachJobQty;

    if Use_opStack then
    begin
      p_opStack.SplitJob(ChildId, RemainQty, EachJobQty, 1, NewId, List);

      if I = 0 then
      begin
        for J := 0 to List.Count - 1 do
        begin
          p_opStack.CreateGroup(TSchedId(List[J]), m_Newgrp);
          m_GrpSchedList.AddLink(TschedId(m_Newgrp));
        end
      end
      else
      begin
        for J := 0 to List.count - 1 do
          p_opStack.AddJobToGroup(TSchedId(List[J]), TSchedId(m_GrpSchedList.GetLink(J)));
      end;

    end
    else
    begin

      List := p_sc.SplitJob(ChildId, RemainQty, EachJobQty, 1, NewId);

      if I = 0 then
      begin
        for J := 0 to List.Count - 1 do
        begin
          m_Newgrp := p_sc.CreateGroup(TSchedId(List[J]));
          m_GrpSchedList.AddLink(TschedId(m_Newgrp));
        end
      end
      else
      begin
        for J := 0 to List.count - 1 do
           p_sc.AddJobToGroup(TSchedId(List[J]), m_Newgrp);
      end;

    end;

  end;

  Result := m_Newgrp;

end;

//----------------------------------------------------------------------------//

procedure TGrpSplit.BtnCancClick(Sender: TObject);
begin
  p_opStack.UndoByMark(m_markStack);
  ModalResult := mrCancel;
//  Close;
end;

//----------------------------------------------------------------------------//

procedure TGrpSplit.BtnOkClick(Sender: TObject);
begin
  ModalResult := mrOk;
//  Close;
end;

constructor TGrpSplit.CreateGrpSplit(AOwner : TComponent; SplitGroupData : TSplitGroupData);
begin
  inherited Create(AOwner);
//  m_GrpSchedList := TMSchedList.Create(self);
  m_SplitGroupData := SplitGroupData;
  m_GrpId          := SplitGroupData.Id_Grp;


//  if m_markStack <> -1 then
//    m_markStack := markStack
//  else
//  m_markStack := p_opStack.MarkStack;
  p_opStack.MarkStackForButtonUndo('Split group'); //aviadd

  CreateNewGroupAndSplit;
end;

//----------------------------------------------------------------------------//

procedure TGrpSplit.FormCreate(Sender: TObject);
begin
  ReShape(self);
//  ReShape(BtnOk);
//  ReShape(BtnCanc);
end;

//----------------------------------------------------------------------------//

function TGrpSplit.GetmsgError : string;
begin
  result := m_msgError
end;

//----------------------------------------------------------------------------//

procedure TGrpSplit.CreateNewGroupAndSplit;
var
  SplitQty, QtyPerJob, OrigJobQty, EachJobQty: currency;
  NewJobNr: integer;
  NewId, ChildId, m_Newgrp : TSchedID;
  Err: string;
  List : TList;
  I,J : Integer;
  value: variant;
  dataType: CBinColValType;
  JobQty : double;
  TabSheet : TTabSheet;
  m_GrpSchedList : TMSchedList;
  ArraySchedList : array of TMSchedList;
  schedListView  : TMSchedListView;
begin
  List := nil;
  m_GrpSchedList := TMSchedList.Create(self);

  for I := 0 to p_sc.GetGrpNumSons(m_SplitGroupData.Id_Grp) - 1 do
  begin
    ChildId := p_sc.GetGrpSon(m_SplitGroupData.Id_Grp, I);
    p_sc.GetFldValue(ChildId, CSC_QtyToSched, value, dataType);
    JobQty := value;
    SplitQty := JobQty*m_SplitGroupData.SplitPercent;
    m_msgError := '';
    if not CalcSplitQtyGrp(ChildId,0,SplitQty, m_SplitGroupData.NewGrpNr, QtyPerJob, OrigJobQty, EachJobQty, NewJobNr, Err) then
    begin
      m_msgError := Err;
      break;
    end;
    p_opStack.SplitJob(ChildId, OrigJobQty, EachJobQty, NewJobNr, NewId, List);
    if I = 0 then
    begin
      for J := 0 to List.Count - 1 do
      begin
        p_opStack.CreateGroup(TSchedId(List[J]), m_Newgrp);
        m_GrpSchedList.AddLink(TschedId(m_Newgrp));
      end
    end
    else
    begin
      for J := 0 to List.count - 1 do //m_GrpSchedList.GetLinkCount - 1 do
        p_opStack.AddJobToGroup(TSchedId(List[J]), TSchedId(m_GrpSchedList.GetLink(J)));
    end;
  end;

  SetLength(ArraySchedList, m_GrpSchedList.GetLinkCount);
  for I := 0 to m_GrpSchedList.GetLinkCount - 1 do
  begin
    m_Newgrp := TSchedId(m_GrpSchedList.GetLink(I));
    ArraySchedList[I] := TMSchedList.Create(self);
    for J := 0 to p_sc.GetGrpNumSons(m_Newgrp) - 1 do
    begin
      ChildId := p_sc.GetGrpSon(m_Newgrp, J);
      ArraySchedList[I].AddLink(ChildId);
    end;
     TabSheet := TTabSheet.Create(PgcGrp);
    TabSheet.PageControl := PgcGrp;
    p_sc.GetFldValue(m_Newgrp, CSC_GroupNo, Value, dataType);
    TabSheet.Caption := 'Group' + ' ' + Value;
    schedListView        := TMSchedListView.CreateListView(TabSheet, ArraySchedList[I]);
    schedListView.Parent := TabSheet;
    schedListView.Align  := alClient;
  end;

  p_pl.EnterCompatModeInPlan(m_SplitGroupData.Id_Grp);

end;

//----------------------------------------------------------------------------//

end.
