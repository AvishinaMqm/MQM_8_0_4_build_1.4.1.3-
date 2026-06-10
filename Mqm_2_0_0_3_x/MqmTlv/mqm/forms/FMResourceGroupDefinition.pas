unit FMResourceGroupDefinition;

interface

uses
  UReShape, cxButtons, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons;

type

  TResGroupDefinition = class(TForm)
    ListBox1: TListBox;
    GroupBoxGrpSett: TGroupBox;
    BitDeleteSet: TBitBtn;
    BitOpenSet: TBitBtn;
    LBListOfGroupSets: TListBox;
    GroupBox1: TGroupBox;
    LblNewSetName: TLabel;
    EditNewGroupSetName: TEdit;
    BtnSaveNewSet: TcxButton;
    BitAbort: TBitBtn;
    BitOK: TBitBtn;
    procedure FormCreate(Sender: TObject);
    procedure BtnSaveNewSetClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure LBListOfGroupSetsDblClick(Sender: TObject);
    procedure BitOKClick(Sender: TObject);
    procedure BitDeleteSetClick(Sender: TObject);

  private
    m_ListOfResGroupSet : TList;
    m_ListCodeToDelete  : TStringList;
    { Private declarations }
  public
    constructor CreateResGroupDefinition(AOwner: TComponent);
    destructor  Destroy; override;
    procedure   IniListGroup;
    { Public declarations }
  end;


implementation

{$R *.dfm}

uses UReShape, DMsrvPc,UMTblDesc,UMglobal,UMAutoSchedCfg,UMObjCont,gnugettext,UMRes;

{ TResGroupDefinition }

//----------------------------------------------------------------------------//

procedure TResGroupDefinition.BitDeleteSetClick(Sender: TObject);
//var
//  GroupResSet   : TGroupResSet;
begin
{  foundSelected := false;
  for I := LBListOfGroupSets.Items.Count - 1 downto 0 do
  begin
    if LBListOfGroupSets.Selected[I] then
    begin
      foundSelected := true;
      GroupCode := LBListOfGroupSets.Items[LBListOfGroupSets.ItemIndex];
      LBListOfGroupSets.Items.Delete(I);
      Break;
    end;
  end;
  if foundSelected then
  begin
    m_ListCodeToDelete.Add(GroupCode);
    for I := m_ListOfResGroupSet.Count - 1 downto 0 do
    begin
      GroupResSet := TGroupResSet(m_ListOfResGroupSet[I]);
      if GroupCode = GroupResSet.m_GroupSetCode then
      begin
        m_ListOfResGroupSet.Delete(I);
        break
      end;
    end;
  end
  else
    showmessage(_('Please select a set first !')); }
end;

//----------------------------------------------------------------------------//

procedure TResGroupDefinition.BitOKClick(Sender: TObject);
var
  qry: TMqmQuery;
  trs: TMqmTransaction;
  tbInfo : ^TTblInfo;
  OldSet: String;
//  GroupResSet : TGroupResSet;
//  Res : TMqmRes;
  I : Integer;
  SqlInsert : string;
begin
  trs := CreateTransaction(Cfg_DB, false);
  qry := CreateQuery(trs, Cfg_DB);
  tbInfo := @tblInfo[tbl_GroupResDefinition];
  OldSet := '';

  for I := 0 to m_ListCodeToDelete.Count - 1 do
  begin
    with qry do
    begin
      SQL.Clear;
      SQL.Add(' delete from ' + tbInfo.PCname + ' where ');
      SQL.Add(CreateFld(tbInfo.pfx, fli_workstation) + '= ''' + IniAppGlobals.WkstCode + '''');
      SQL.Add(' and ' + CreateFld(tbInfo.pfx, fli_SetName) + '= ''' + m_ListCodeToDelete.Strings[I] + '''');
      ExecSQL;
      Transaction.Commit;
    end;
  end;

  for I := 0 to m_ListOfResGroupSet.Count - 1 do
  begin
//    if not TGroupResSet(m_ListOfResGroupSet[I]).m_Changed then continue;
//    GroupResSet := TGroupResSet(m_ListOfResGroupSet[I]);
    with qry do
    begin
      SQL.Clear;
      SQL.Add(' delete from ' + tbInfo.PCname + ' where ');
      SQL.Add(CreateFld(tbInfo.pfx, fli_workstation) + '= ''' + IniAppGlobals.WkstCode + '''');
//      SQL.Add(' and ' + CreateFld(tbInfo.pfx, fli_SetName) + '= ''' + GroupResSet.m_GroupSetCode + '''');
      ExecSQL;
      SQL.Clear;
      SqlInsert := '';
      SqlInsert := SqlInsert + 'insert into ' + tbInfo.PCname + '(';
      SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_workstation) + ',';
      SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_SetName) + ',';
      SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_Rsc) + ',';
      SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_NumberOfScheduleCounter);
      SqlInsert := SqlInsert + ') values (';
      SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_workstation) + ',';
      SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_SetName) + ',';
      SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_Rsc) + ',';
      SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_NumberOfScheduleCounter);
      SqlInsert := SqlInsert + ')';
      sql.Text  := SqlInsert;
      Prepare;

{      for J := 0 to GroupResSet.m_ResList.Count - 1 do
      begin
        ParamByName(CreateFld(tbInfo.pfx,fli_workstation)).AsString   := IniAppGlobals.WkstCode;
        ParamByName(CreateFld(tbInfo.pfx,fli_SetName)).AsString       := GroupResSet.m_GroupSetCode;
        Res := TMqmRes(GroupResSet.m_ResList.Objects[J]);
        if not assigned(Res) then continue;
        ParamByName(CreateFld(tbInfo.pfx,fli_Rsc)).AsString         := Res.p_ResCode;
        ParamByName(CreateFld(tbInfo.pfx,fli_NumberOfScheduleCounter)).AsInteger  := GroupResSet.m_NumOfSchedCounter;
        ExecSQL;
      end;
      Transaction.Commit;
    end;                   }

  end;
  ModalResult := mrOk;

end;

end;

//----------------------------------------------------------------------------//

procedure TResGroupDefinition.BtnSaveNewSetClick(Sender: TObject);
//var
//  GroupResSet : TGroupResSet;
begin
end;

//----------------------------------------------------------------------------//

constructor TResGroupDefinition.CreateResGroupDefinition(AOwner: TComponent);
begin
  inherited Create(AOwner);
  m_ListOfResGroupSet := TList.Create;
  m_ListCodeToDelete  := TStringList.Create;
//  LoadResourceGroupFromDB(m_ListOfResGroupSet);
  IniListGroup;
end;

//----------------------------------------------------------------------------//

destructor TResGroupDefinition.Destroy;
//var
//  I : Integer;
begin
  if Assigned(m_ListOfResGroupSet) then
  begin
//    for I := m_ListOfResGroupSet.Count - 1 downto 0 do
//       TGroupResSet(m_ListOfResGroupSet[I]).free;
  end;
  inherited destroy;
end;

//----------------------------------------------------------------------------//

procedure TResGroupDefinition.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

//----------------------------------------------------------------------------//

procedure TResGroupDefinition.IniListGroup;
var
  I : Integer;
begin
  for I := 0 to m_ListOfResGroupSet.Count - 1 do
  begin
//    if LBListOfGroupSets.Items.IndexOf(TGroupResSet(m_ListOfResGroupSet[I]).m_GroupSetCode) = -1 then
//       LBListOfGroupSets.Items.Add(TGroupResSet(m_ListOfResGroupSet[I]).m_GroupSetCode);
  end;
end;

//----------------------------------------------------------------------------//

procedure TResGroupDefinition.LBListOfGroupSetsDblClick(Sender: TObject);
begin
 // BitOpenSetClick(self)
end;

//----------------------------------------------------------------------------//

procedure TResGroupDefinition.FormCreate(Sender: TObject);
begin
  ReShape(Self);
end;

end.
