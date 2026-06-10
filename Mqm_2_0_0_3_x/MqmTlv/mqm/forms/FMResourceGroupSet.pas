unit FMResourceGroupSet;

interface

uses
  UReShape, cxButtons, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls,UMres;

type
  TReourceGroupSet = class(TForm)
    Panel1: TPanel;
    ListResGroup: TListBox;
    ListBoxAllRes: TListBox;
    BitOK: TBitBtn;
    BitAbort: TBitBtn;
    Label1: TLabel;
    EditNumberOfScheduleCounter: TEdit;
    LblResForGroup: TLabel;
    Label3: TLabel;
    BtnRight: TcxButton;
    BtnLeft: TcxButton;
    procedure EditNumberOfScheduleCounterKeyPress(Sender: TObject; var Key: Char);
    procedure BitOKClick(Sender: TObject);
    procedure BtnLeftClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure BtnRightClick(Sender: TObject);
    procedure ListResGroupDblClick(Sender: TObject);
    procedure ListBoxAllResDblClick(Sender: TObject);
    procedure BitAbortClick(Sender: TObject);
  private
    m_groupCode : string;
    m_ListOfAllGroupResSet : TList;
    procedure IniAllGroupResSet;
    procedure IniCurrentGroupResSet;
    function  FindResInGroup(Res : TMqmRes): string;
    procedure SignGroupAsChanged(groupCode : string; ResToDelete : string);
    procedure CheckResInDeleteList(groupCode : string; ResCode : string);
    function  SaveGroupCodesChanged : boolean;
    { Private declarations }
  public
    constructor CreateResGroupSet(AOwner: TComponent; GroupCode : string; ListOfGroupSet : TList);
  end;

implementation

{$R *.dfm}

uses UReShape, UMObjCont,UMWkCtr,UMAutoSchedCfg,gnugettext;

type
  TResRec = Record
    Res : TMqmRes;
    GroupCode : string;
  end;
  PTResRec = ^TResRec;

//----------------------------------------------------------------------------//

procedure TReourceGroupSet.BitAbortClick(Sender: TObject);
var
  I : Integer;
//  GroupResSet : TGroupResSet;
begin
  for I := 0 to m_ListOfAllGroupResSet.Count - 1 do
  begin
//    GroupResSet := TGroupResSet(m_ListOfAllGroupResSet[I]);
//    if Assigned(GroupResSet.m_ResToDelete) then
//       GroupResSet.m_ResToDelete.Clear;
  end;
end;

//----------------------------------------------------------------------------//

procedure TReourceGroupSet.BitOKClick(Sender: TObject);
begin
  if ListResGroup.Items.Count > 0 then
  begin
    if SaveGroupCodesChanged then
       ModalResult := mrOk;
  end
  else
    ShowMessage(_('At least one resouce must be selected in a group !'));
end;

//----------------------------------------------------------------------------//

procedure TReourceGroupSet.BtnLeftClick(Sender: TObject);
var
  I,J : Integer;
  Rsc : TMqmRes;
  Found : boolean;
  TempGroup : string;
begin
  found := false;
  for I := 0 to ListBoxAllRes.Count - 1 do
  begin
    if ListBoxAllRes.Selected[I] then
    begin
      found := true;
      break;
    end;
  end;

  if not found then
  begin
    Showmessage(_('Please select a resource first !'));
    exit;
  end;

  for I := 0 to ListBoxAllRes.Count - 1 do
  begin
    if ListBoxAllRes.Selected[I] then
    begin
      found := false;
      for J := 0 to ListResGroup.Count - 1 do
      begin
        if ListBoxAllRes.Items.Objects[I] = ListResGroup.Items.Objects[J] then
        begin
          Found := true;
          break;
        end;
      end;
      if not found then
      begin
        Rsc := TMqmRes(ListBoxAllRes.Items.Objects[I]);

        TempGroup := FindResInGroup(Rsc);
        if (m_GroupCode <> TempGroup) then
           SignGroupAsChanged(TempGroup, Rsc.p_ResCode);

        ListBoxAllRes.Items[I] := Rsc.p_ResCode + '    ' + Rsc.p_ResSDesc +  '  (' + m_GroupCode + ')';
        ListResGroup.AddItem(Rsc.p_ResCode + '    ' + Rsc.p_ResSDesc , Rsc)
      end;
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure TReourceGroupSet.BtnRightClick(Sender: TObject);
var
  I : Integer;
  Rsc : TMqmRes;
  GroupCode : string;
begin
  if ListResGroup.ItemIndex = -1 then
  begin
    showmessage(_('Please select a resource first !'));
    exit;
  end;

  Rsc := TMqmRes(ListResGroup.Items.Objects[ListResGroup.ItemIndex]);
  ListResGroup.Items.Delete(ListResGroup.ItemIndex);
  GroupCode := FindResInGroup(Rsc);
  for I := 0 to ListBoxAllRes.Count - 1 do
  begin
    if (Rsc = TMqmRes(ListBoxAllRes.Items.Objects[I])) then
    begin
      if GroupCode = m_groupCode then
        ListBoxAllRes.Items[I] := Rsc.p_ResCode + '    ' + Rsc.p_ResSDesc
      else
      begin
        if GroupCode <> '' then
        begin
          CheckResInDeleteList(GroupCode, Rsc.p_ResCode);
          GroupCode := '  (' + GroupCode + ')';
        end;
        ListBoxAllRes.Items[I] := Rsc.p_ResCode + '    ' + Rsc.p_ResSDesc + GroupCode;
      end;
      exit;
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure TReourceGroupSet.CheckResInDeleteList(groupCode: string; ResCode : string);
//var
//  I,DelIndex : Integer;
//  GroupResSet : TGroupResSet;
begin
{  for I := 0 to m_ListOfAllGroupResSet.Count - 1 do
  begin
    GroupResSet := TGroupResSet(m_ListOfAllGroupResSet[I]);
    if GroupResSet.m_GroupSetCode = groupCode then
    begin
      //if not GroupResSet.m_Changed then continue;
      if Assigned(GroupResSet.m_ResToDelete) then
      begin
        DelIndex := GroupResSet.m_ResToDelete.IndexOf(ResCode);
        if DelIndex <> -1 then
           GroupResSet.m_ResToDelete.Delete(DelIndex);
        break;
      end;
    end }
 // end;
end;

//----------------------------------------------------------------------------//

constructor TReourceGroupSet.CreateResGroupSet(AOwner: TComponent; GroupCode : string; ListOfGroupSet : TList);
begin
  inherited Create(AOwner);
  m_groupCode := GroupCode;
  m_ListOfAllGroupResSet := ListOfGroupSet;
  IniAllGroupResSet;
  IniCurrentGroupResSet;
end;

//----------------------------------------------------------------------------//

procedure TReourceGroupSet.EditNumberOfScheduleCounterKeyPress(Sender: TObject;
  var Key: Char);
begin
  if not ((CharInSet(Key, ['0'..'9'])) or (key = chr(vk_Back)) or (Key = chr(24))) then
      abort;
end;

//----------------------------------------------------------------------------//

function TReourceGroupSet.FindResInGroup(Res : TMqmRes): string;
//var
//  I,J : Integer;
//  GroupResSet : TGroupResSet;
begin
{  Result := '';
  for I := 0 to m_ListOfAllGroupResSet.Count - 1 do
  begin
    GroupResSet := TGroupResSet(m_ListOfAllGroupResSet[I]);
    for J := 0 to GroupResSet.m_ResList.Count - 1 do
    begin
      if GroupResSet.m_ResList.Objects[J] = Res then
      begin
        Result := GroupResSet.m_GroupSetCode;
        Exit;
      end;
    end;
  end;       }
end;

//----------------------------------------------------------------------------//

procedure TReourceGroupSet.FormCreate(Sender: TObject);
begin
  LblResForGroup.Caption := (_('Resources in') + ' - ') + m_groupCode;
  ReShape(Self);
end;

//----------------------------------------------------------------------------//

function SortResourceList(Item1, Item2: Pointer): integer;
var
  Rec1, Rec2 : PTResRec;
  Res1, Res2 : TMqmRes;
  Group1, Group2 : string;
begin
  Rec1 := PTResRec(Item1);
  Rec2 := PTResRec(Item2);

  Res1 := Rec1.Res;
  Res2 := Rec2.Res;
  Group1 := Rec1.GroupCode;
  Group2 := Rec2.GroupCode;

  if (Group1 <> '') and (Group2 <> '') then
  begin
    if (Group1 < Group2) then
      Result := -1
    else if (Group1 > Group2) then
      Result := 1
    else
    begin
      if Res1.p_ResCode < Res2.p_ResCode then
        Result := -1
      else if Res1.p_ResCode > Res2.p_ResCode then
        Result := 1
      else
        Result := 0;
    end;
  end

  else if (Group1 = '') and (Group2 = '') then
  begin
    if Res1.p_ResCode < Res2.p_ResCode then
      Result := -1
    else if Res1.p_ResCode > Res2.p_ResCode then
      Result := 1
    else
      Result := 0;
  end

  else if (Group1 = '') and (Group2 <> '') then
  begin
    result := -1
  end

  else  if (Group1 <> '') and (Group2 = '') then
    result := 1
  else
    Result := 0;
end;

//----------------------------------------------------------------------------//

procedure TReourceGroupSet.IniAllGroupResSet;
var
  I,J  : Integer;
  WC  : TMqmWrkCtr;
  Rsc : TMqmRes;
  GroupCode : string;
  TempList : TList;
  ResourceRec  : PTResRec;
begin
  TempList := TList.Create;
  for i := 0 to p_pl.p_WrkCtrsCount - 1 do
  begin
    WC := TMqmWrkCtr(p_pl.p_WrkCtr[i]);
    if (WC.p_ReadOnly) then
      Continue;

    for J := 0 to WC.p_ResCount - 1 do
    begin
      Rsc := TMqmRes(WC.p_Res[J]);
      new(ResourceRec);
      GroupCode := FindResInGroup(Rsc);
      if GroupCode <> '' then
        ResourceRec.GroupCode := GroupCode
      else
        ResourceRec.GroupCode := '';
      ResourceRec.Res := Rsc;
      TempList.Add(ResourceRec);
    end
  end;

  TempList.Sort(SortResourceList);

  for I := 0 to TempList.Count - 1 do
  begin
    Rsc := PTResRec(TempList[I]).Res;
    GroupCode := FindResInGroup(Rsc);
    if GroupCode <> '' then
         GroupCode := '  (' + GroupCode + ')';
      ListBoxAllRes.AddItem(Trim(Rsc.p_ResCode) + '    ' + Rsc.p_ResSDesc + GroupCode,Rsc);
  end;

  for I := 0 to TempList.Count - 1 do
    Dispose(PTResRec(TempList[I]));
  TempList.Free;

end;

//----------------------------------------------------------------------------//

procedure TReourceGroupSet.IniCurrentGroupResSet;
//var
//  I,J : Integer;
//  GroupResSet : TGroupResSet;
//  Res : TMqmRes;
begin
{  for I := 0 to m_ListOfAllGroupResSet.Count - 1 do
  begin
    if (TGroupResSet(m_ListOfAllGroupResSet[I]).m_GroupSetCode = m_groupCode) then
    begin
      GroupResSet := TGroupResSet(m_ListOfAllGroupResSet[I]);
      for J := 0 to GroupResSet.m_ResList.Count - 1 do
      begin
        Res := TMqmRes(GroupResSet.m_ResList.Objects[J]);
        ListResGroup.AddItem(Res.p_ResCode + '    ' + Res.p_ResSDesc,Res);
      end;
      EditNumberOfScheduleCounter.text := IntToStr(GroupResSet.m_NumOfSchedCounter);
    end;
  end;   }
end;

//----------------------------------------------------------------------------//

procedure TReourceGroupSet.ListBoxAllResDblClick(Sender: TObject);
begin
  BtnLeftClick(self);
end;

//----------------------------------------------------------------------------//

procedure TReourceGroupSet.ListResGroupDblClick(Sender: TObject);
begin
  BtnRightClick(self);
end;

//----------------------------------------------------------------------------//

function TReourceGroupSet.SaveGroupCodesChanged : boolean;
//var
//  I,J,M : Integer;
//  GroupResSet : TGroupResSet;
begin
  Result := true;

{  try
    if (StrToInt(EditNumberOfScheduleCounter.Text) < 0) then
    begin
      Result := false;
      ShowMessage(_('Number of scheduled counter is wrong value'));
      exit;
    end;
  except
  end;

  for I := 0 to m_ListOfAllGroupResSet.Count - 1 do
  begin
    GroupResSet := TGroupResSet(m_ListOfAllGroupResSet[I]);
    if GroupResSet.m_GroupSetCode <> m_groupCode then
    begin
      if not GroupResSet.m_Changed then continue;
      if Assigned(GroupResSet.m_ResToDelete) then
      begin
        for J := 0 to GroupResSet.m_ResToDelete.Count - 1 do
        begin
          for m := 0 to GroupResSet.m_ResList.Count - 1 do
          begin
            if copy(GroupResSet.m_ResList[m],0,6) = GroupResSet.m_ResToDelete[J] then
            begin
              GroupResSet.m_ResList.Delete(m);
              break;
            end;
          end;
        end;
        GroupResSet.m_ResToDelete.Clear;
      end;
    end
    else
    begin
      GroupResSet.m_ResList.Clear;
      for J := 0 to ListResGroup.Items.Count - 1 do
        GroupResSet.m_ResList.AddObject(ListResGroup.Items[J],ListResGroup.Items.Objects[J]);
      GroupResSet.m_NumOfSchedCounter := StrToInt(EditNumberOfScheduleCounter.Text);
      GroupResSet.m_Changed := true;
    end;
  end;     }
end;

//----------------------------------------------------------------------------//

procedure TReourceGroupSet.SignGroupAsChanged(groupCode : string; ResToDelete : string);
//var
//  I : Integer;
//  GroupResSet : TGroupResSet;
begin
{  for I := 0 to m_ListOfAllGroupResSet.Count - 1 do
  begin
    if (TGroupResSet(m_ListOfAllGroupResSet[I]).m_GroupSetCode = groupCode) then
    begin
      GroupResSet := TGroupResSet(m_ListOfAllGroupResSet[I]);
      GroupResSet.m_Changed := true;
      if groupCode <> m_groupCode then
      begin
        if not assigned(GroupResSet.m_ResToDelete) then
          GroupResSet.m_ResToDelete := TStringList.Create;
        GroupResSet.m_ResToDelete.Add(ResToDelete);
      end;
      break
    end;
  end;    }
end;

//----------------------------------------------------------------------------//

end.
