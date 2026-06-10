unit FMGroupedByFieldsConfig;

interface

uses
  cxButtons, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Buttons, Vcl.CheckLst,
  Vcl.ExtCtrls, UMBinFunc, UGPropComp, UMSchedContFunc, UReShape;

type

  TFGroupedByFieldsConfig = class(TForm)
    Bevel1 : TBevel;
    GroupBox1: TGroupBox;
    CBFieldList: TCheckListBox;
    Label1: TLabel;
    LblSetName: TLabel;
    Panel1: TPanel;
    BitOK: TcxButton;
    BitAbort: TcxButton;
    function GetGroupBySetByCode(code : string) : PTGroupedByFieldSet;
    procedure IniCBFieldList;
    procedure RemoveCodeFromList(Code : string);
    procedure BitOKClick(Sender: TObject);
    procedure BitAbortClick(Sender: TObject);
  private
    m_SetName : string;
    m_PropComp : TPropComponent;
    { Private declarations }
  public
    constructor CreateGroupByField(AOwner: TComponent; setName : string);
    procedure SaveToDB(GroupedByFieldSet : PTGroupedByFieldSet);
    { Public declarations }
  end;

  procedure LoadGroupByFieldFromDB;
  function  GetAllGroupedByFieldList : TStringList;
  procedure DeleteGroupedByFieldCode(Code : string);
  function  GetGroupBySetByCode(Code : string) : PTGroupedByFieldSet;
  function  CheckGroupedByCodeFiledsForSearch(Code : string; BinColId : CBinColId) : boolean;

implementation

uses
  UMBinDefault, UMglobal, UMCompat, DMsrvPc, UMTblDesc, gnugettext, UMCommon;

var
  m_ListOfGroupByField : TList;

{$R *.dfm}

{ TFGroupedByFieldsConfig }

//----------------------------------------------------------------------------//

procedure TFGroupedByFieldsConfig.RemoveCodeFromList(Code : string);
var
  I : Integer;
begin
  for I := m_ListOfGroupByField.Count - 1 downto 0 do
  begin
    if PTGroupedByFieldSet(m_ListOfGroupByField[I]).Code = code then
    begin
      m_ListOfGroupByField.Delete(I);
      break
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure TFGroupedByFieldsConfig.BitOKClick(Sender: TObject);
var
  GroupedByFieldSet : PTGroupedByFieldSet;
  I, J : Integer;
begin
  ModalResult := mrOk;

  GroupedByFieldSet := GetGroupBySetByCode(m_SetName);
  if Assigned(GroupedByFieldSet) then
  begin
    GroupedByFieldSet.GroupedByOption := [];
    for I := Low(GroupedByFieldSet.PropCode) to High(GroupedByFieldSet.PropCode) do
      GroupedByFieldSet.PropCode[I] := '';
  end
  else
  begin
    new(GroupedByFieldSet);
    GroupedByFieldSet.Code := m_SetName;
    m_ListOfGroupByField.Add(GroupedByFieldSet);
  end;

  for I := 0 to CBFieldList.Count - 1 do
  begin
    if CBFieldList.Checked[I] then
    begin
      case I of
        0 : include(GroupedByFieldSet.GroupedByOption, FiltProdReq);
        1 : include(GroupedByFieldSet.GroupedByOption, FiltProdFamily);
      end;
    end;
  end;
  if m_PropComp.IsPropEnter then
  begin
    for J := 1 to m_PropComp.P_RowCount - 1 do
    begin
      if m_PropComp.P_GetPropVal[J] <> '' then
         GroupedByFieldSet.PropCode[J - 1] := (m_PropComp.P_GetPropVal[J]);
    end;
  end;
  SaveToDB(GroupedByFieldSet);


end;

//----------------------------------------------------------------------------//

procedure TFGroupedByFieldsConfig.BitAbortClick(Sender: TObject);
begin
  ModalResult := mrAbort;
  close;
end;

constructor TFGroupedByFieldsConfig.CreateGroupByField(AOwner: TComponent;
  setName : string);
begin
  inherited Create(AOwner);
  Caption := _('Grouped by fields configuration');
  m_SetName := setName;
  m_PropComp := TPropComponent.CreatePropComp(Panel1,SelectedProp,nil,-1, nil, nil);
  IniCBFieldList;

  ReShape(Self);

end;


//----------------------------------------------------------------------------//

procedure TFGroupedByFieldsConfig.IniCBFieldList;
var
  I, J, Pos  : integer;
  RetrieveGroupedByFieldSet : PTGroupedByFieldSet;
  PropCode : string;
begin
  LblSetName.Caption := _('Set name:') + ' ' + m_SetName;
  RetrieveGroupedByFieldSet := GetGroupBySetByCode(m_SetName);

  Pos := CBFieldList.Items.Add(_('Production request'));
  if assigned(RetrieveGroupedByFieldSet) then
  begin
    if FiltProdReq in RetrieveGroupedByFieldSet.GroupedByOption then
       CBFieldList.Checked[pos] := true;
  end;

  Pos := CBFieldList.Items.Add(_('Production family'));
  if assigned(RetrieveGroupedByFieldSet) then
  begin
    if FiltProdFamily in RetrieveGroupedByFieldSet.GroupedByOption then
       CBFieldList.Checked[pos] := true;
  end;

  if Assigned(RetrieveGroupedByFieldSet) then
  begin
    for I := 0 to High(RetrieveGroupedByFieldSet.PropCode) - 1 do
    begin
      if (RetrieveGroupedByFieldSet.PropCode[I] <> '') then
    //  and CheckPropExist(RetrieveGroupedByFieldSet.PropCode[I]) then
      begin
        if I = 0 then
          m_PropComp.SetPropVal(RetrieveGroupedByFieldSet.PropCode[I],I + 1,true)
        else
          m_PropComp.SetPropVal(RetrieveGroupedByFieldSet.PropCode[I],I + 1,false);
      end;
    end;
  end;
end;

//----------------------------------------------------------------------------//

function TFGroupedByFieldsConfig.GetGroupBySetByCode(code: string): PTGroupedByFieldSet;
var
  I : Integer;
begin
  Result := nil;
  for I := 0 to m_ListOfGroupByField.Count - 1 do
  begin
    if code = PTGroupedByFieldSet(m_ListOfGroupByField[I]).Code then
    begin
      result := (m_ListOfGroupByField[I]);
      break
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure TFGroupedByFieldsConfig.SaveToDB(GroupedByFieldSet : PTGroupedByFieldSet);
var
 qry:        TMqmQuery;
 tbInfo:     ^TTblInfo;
begin
  tbInfo := @tblInfo[tbl_GroupedByFields];
  qry := CreateQuery(Cfg_DB);
  Qry.Transaction := CreateTransaction(Cfg_DB);
  Qry.Transaction.StartTransaction;

  with qry.sql do
  begin
    Clear;
    Add('Delete from ' + tbInfo.GetTableName);
    Add(' Where ');
    Add(CreateFld(tbInfo.pfx, fli_wkstCode) + '=''' + IniAppGlobals.WkstCode + '''');
    Add( 'And' );
    Add(CreateFld(tbInfo.pfx, fli_GroupedByCode) + '=''' + m_SetName + '''');
    Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_identifier)));
    qry.ExecSQL;

    Clear;
    Add('insert into ' + tbInfo.GetTableName + '(');
    Add(CreateFld(tbInfo.pfx,fli_identifier) + ',');
    Add(CreateFld(tbInfo.pfx,fli_wkstCode) + ',');
    Add(CreateFld(tbInfo.pfx,fli_GroupedByCode)  + ',');
    Add(CreateFld(tbInfo.pfx,fli_GroupedByProdReq) + ',');
    Add(CreateFld(tbInfo.pfx,fli_GroupedByProdFamily) + ',');
    Add(CreateFld(tbInfo.pfx,fli_GroupedByPropCode1)  + ',');
    Add(CreateFld(tbInfo.pfx,fli_GroupedByPropCode2)  + ',');
    Add(CreateFld(tbInfo.pfx,fli_GroupedByPropCode3)  + ',');
    Add(CreateFld(tbInfo.pfx,fli_GroupedByPropCode4)  + ',');
    Add(CreateFld(tbInfo.pfx,fli_GroupedByPropCode5)  + ',');
    Add(CreateFld(tbInfo.pfx,fli_GroupedByPropCode6)  + ',');
    Add(CreateFld(tbInfo.pfx,fli_GroupedByPropCode7)  + ',');
    Add(CreateFld(tbInfo.pfx,fli_GroupedByPropCode8)  + ',');
    Add(CreateFld(tbInfo.pfx,fli_GroupedByPropCode9)  + ',');
    Add(CreateFld(tbInfo.pfx,fli_GroupedByPropCode10) + ')');

    Add(' values (');
    Add(':' + CreateFld(tbInfo.pfx,fli_identifier) + ',');
    Add(':' + CreateFld(tbInfo.pfx,fli_wkstCode) + ',');
    Add(':' + CreateFld(tbInfo.pfx,fli_GroupedByCode)  + ',');
    Add(':' + CreateFld(tbInfo.pfx,fli_GroupedByProdReq)     + ',');
    Add(':' + CreateFld(tbInfo.pfx,fli_GroupedByProdFamily)  + ',');
    Add(':' + CreateFld(tbInfo.pfx,fli_GroupedByPropCode1)  + ',');
    Add(':' + CreateFld(tbInfo.pfx,fli_GroupedByPropCode2)  + ',');
    Add(':' + CreateFld(tbInfo.pfx,fli_GroupedByPropCode3)  + ',');
    Add(':' + CreateFld(tbInfo.pfx,fli_GroupedByPropCode4)  + ',');
    Add(':' + CreateFld(tbInfo.pfx,fli_GroupedByPropCode5)  + ',');
    Add(':' + CreateFld(tbInfo.pfx,fli_GroupedByPropCode6)  + ',');
    Add(':' + CreateFld(tbInfo.pfx,fli_GroupedByPropCode7)  + ',');
    Add(':' + CreateFld(tbInfo.pfx,fli_GroupedByPropCode8)  + ',');
    Add(':' + CreateFld(tbInfo.pfx,fli_GroupedByPropCode9)  + ',');
    Add(':' + CreateFld(tbInfo.pfx,fli_GroupedByPropCode10));
    Add(')');

    qry.ParamByName(CreateFld(tbInfo.pfx,fli_identifier)).AsString             := IniAppGlobals.Identifier;
    qry.ParamByName(CreateFld(tbInfo.pfx,fli_wkstCode)).AsString               := IniAppGlobals.WkstCode;
    qry.ParamByName(CreateFld(tbInfo.pfx,fli_GroupedByCode)).AsString          := m_SetName;
    if FiltProdReq in GroupedByFieldSet.GroupedByOption then
      qry.ParamByName(CreateFld(tbInfo.pfx,fli_GroupedByProdReq)).AsString       := '1'
    else
      qry.ParamByName(CreateFld(tbInfo.pfx,fli_GroupedByProdReq)).AsString       := '0';

    if FiltProdFamily in GroupedByFieldSet.GroupedByOption then
      qry.ParamByName(CreateFld(tbInfo.pfx,fli_GroupedByProdFamily)).AsString    := '1'
    else
      qry.ParamByName(CreateFld(tbInfo.pfx,fli_GroupedByProdFamily)).AsString    := '0';

    if GroupedByFieldSet.PropCode[0] <> '' then
      qry.ParamByName(CreateFld(tbInfo.pfx,fli_GroupedByPropCode1)).AsString     := GroupedByFieldSet.PropCode[0]
    else
      qry.ParamByName(CreateFld(tbInfo.pfx,fli_GroupedByPropCode1)).AsString     := '';

    if GroupedByFieldSet.PropCode[1] <> '' then
      qry.ParamByName(CreateFld(tbInfo.pfx,fli_GroupedByPropCode2)).AsString     := GroupedByFieldSet.PropCode[1]
    else
      qry.ParamByName(CreateFld(tbInfo.pfx,fli_GroupedByPropCode2)).AsString     := '';

    if GroupedByFieldSet.PropCode[2] <> '' then
      qry.ParamByName(CreateFld(tbInfo.pfx,fli_GroupedByPropCode3)).AsString     := GroupedByFieldSet.PropCode[2]
    else
      qry.ParamByName(CreateFld(tbInfo.pfx,fli_GroupedByPropCode3)).AsString     := '';

    if GroupedByFieldSet.PropCode[3] <> '' then
      qry.ParamByName(CreateFld(tbInfo.pfx,fli_GroupedByPropCode4)).AsString     := GroupedByFieldSet.PropCode[3]
    else
      qry.ParamByName(CreateFld(tbInfo.pfx,fli_GroupedByPropCode4)).AsString     := '';

    if GroupedByFieldSet.PropCode[4] <> '' then
      qry.ParamByName(CreateFld(tbInfo.pfx,fli_GroupedByPropCode5)).AsString     := GroupedByFieldSet.PropCode[4]
    else
      qry.ParamByName(CreateFld(tbInfo.pfx,fli_GroupedByPropCode5)).AsString     := '';

    if GroupedByFieldSet.PropCode[5] <> '' then
      qry.ParamByName(CreateFld(tbInfo.pfx,fli_GroupedByPropCode6)).AsString     := GroupedByFieldSet.PropCode[5]
    else
      qry.ParamByName(CreateFld(tbInfo.pfx,fli_GroupedByPropCode6)).AsString     := '';

    if GroupedByFieldSet.PropCode[6] <> '' then
      qry.ParamByName(CreateFld(tbInfo.pfx,fli_GroupedByPropCode7)).AsString     := GroupedByFieldSet.PropCode[6]
    else
      qry.ParamByName(CreateFld(tbInfo.pfx,fli_GroupedByPropCode7)).AsString     := '';

    if GroupedByFieldSet.PropCode[7] <> '' then
      qry.ParamByName(CreateFld(tbInfo.pfx,fli_GroupedByPropCode8)).AsString     := GroupedByFieldSet.PropCode[7]
    else
      qry.ParamByName(CreateFld(tbInfo.pfx,fli_GroupedByPropCode8)).AsString     := '';

    if GroupedByFieldSet.PropCode[8] <> '' then
      qry.ParamByName(CreateFld(tbInfo.pfx,fli_GroupedByPropCode9)).AsString     := GroupedByFieldSet.PropCode[8]
    else
      qry.ParamByName(CreateFld(tbInfo.pfx,fli_GroupedByPropCode9)).AsString     := '';

    if GroupedByFieldSet.PropCode[9] <> '' then
      qry.ParamByName(CreateFld(tbInfo.pfx,fli_GroupedByPropCode10)).AsString     := GroupedByFieldSet.PropCode[9]
    else
      qry.ParamByName(CreateFld(tbInfo.pfx,fli_GroupedByPropCode10)).AsString     := '';

    qry.ExecSQL;

  end;

  Qry.Transaction.Commit;
  qry.Free;

end;

//----------------------------------------------------------------------------//

procedure ClearGroupedByList;
var
  I : Integer;
begin
  for I := m_ListOfGroupByField.Count -1 downto 0 do
    dispose(PTGroupedByFieldSet(m_ListOfGroupByField[I]));
  m_ListOfGroupByField.Free;
end;

//----------------------------------------------------------------------------//

procedure LoadGroupByFieldFromDB;
var
 qry:        TMqmQuery;
 tbInfo:     ^TTblInfo;
 GroupedByFieldSet : PTGroupedByFieldSet;
begin
  qry := CreateQuery(Cfg_DB);
  tbInfo := @tblInfo[tbl_GroupedByFields];
  with qry do
  begin
    SQL.Clear;
    SQL.Add('select * from ' + tbInfo.GetTableName);
    SQL.Add(' where ');
    SQL.Add(CreateFld(tbInfo.pfx, fli_wkstCode) + ' = ');
    SQL.Add('''' + IniAppGlobals.WkstCode + '''');
    SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_identifier)));
    SQL.Add(' Order by ' + CreateFld(tbInfo.pfx, fli_GroupedByCode));
    Open;
    while not EOF do
    begin
      Application.ProcessMessages;
      new(GroupedByFieldSet);
      GroupedByFieldSet.Code := fieldByName(CreateFld(tbInfo.pfx,fli_GroupedByCode)).AsString;
      if fieldByName(CreateFld(tbInfo.pfx,fli_GroupedByProdReq)).AsString = '1' then
        include(GroupedByFieldSet.GroupedByOption, FiltProdReq)
      else
        Exclude(GroupedByFieldSet.GroupedByOption, FiltProdReq);
      if fieldByName(CreateFld(tbInfo.pfx,fli_GroupedByProdFamily)).AsString = '1' then
        include(GroupedByFieldSet.GroupedByOption, FiltProdFamily);
      if fieldByName(CreateFld(tbInfo.pfx,fli_GroupedByPropCode1)).AsString <> '' then
        GroupedByFieldSet.PropCode[0] := fieldByName(CreateFld(tbInfo.pfx,fli_GroupedByPropCode1)).AsString;
      if fieldByName(CreateFld(tbInfo.pfx,fli_GroupedByPropCode2)).AsString <> '' then
        GroupedByFieldSet.PropCode[1] := fieldByName(CreateFld(tbInfo.pfx,fli_GroupedByPropCode2)).AsString;
      if fieldByName(CreateFld(tbInfo.pfx,fli_GroupedByPropCode3)).AsString <> '' then
        GroupedByFieldSet.PropCode[2] := fieldByName(CreateFld(tbInfo.pfx,fli_GroupedByPropCode3)).AsString;
      if fieldByName(CreateFld(tbInfo.pfx,fli_GroupedByPropCode4)).AsString <> '' then
        GroupedByFieldSet.PropCode[3] := fieldByName(CreateFld(tbInfo.pfx,fli_GroupedByPropCode4)).AsString;
      if fieldByName(CreateFld(tbInfo.pfx,fli_GroupedByPropCode5)).AsString <> '' then
        GroupedByFieldSet.PropCode[4] := fieldByName(CreateFld(tbInfo.pfx,fli_GroupedByPropCode5)).AsString;
      if fieldByName(CreateFld(tbInfo.pfx,fli_GroupedByPropCode6)).AsString <> '' then
        GroupedByFieldSet.PropCode[5] := fieldByName(CreateFld(tbInfo.pfx,fli_GroupedByPropCode6)).AsString;
      if fieldByName(CreateFld(tbInfo.pfx,fli_GroupedByPropCode7)).AsString <> '' then
        GroupedByFieldSet.PropCode[6] := fieldByName(CreateFld(tbInfo.pfx,fli_GroupedByPropCode7)).AsString;
      if fieldByName(CreateFld(tbInfo.pfx,fli_GroupedByPropCode8)).AsString <> '' then
        GroupedByFieldSet.PropCode[7] := fieldByName(CreateFld(tbInfo.pfx,fli_GroupedByPropCode8)).AsString;
      if fieldByName(CreateFld(tbInfo.pfx,fli_GroupedByPropCode9)).AsString <> '' then
        GroupedByFieldSet.PropCode[8] := fieldByName(CreateFld(tbInfo.pfx,fli_GroupedByPropCode9)).AsString;
      if fieldByName(CreateFld(tbInfo.pfx,fli_GroupedByPropCode10)).AsString <> '' then
        GroupedByFieldSet.PropCode[9] := fieldByName(CreateFld(tbInfo.pfx,fli_GroupedByPropCode10)).AsString;
      m_ListOfGroupByField.Add(GroupedByFieldSet);
      next;
    end;
  end;
  qry.free
end;

//----------------------------------------------------------------------------//

function GetAllGroupedByFieldList : TStringList;
var
  I : integer;
begin
  Result := nil;
  if m_ListOfGroupByField.Count > 0 then
  begin
    Result := TStringList.Create;
    for I := 0 to m_ListOfGroupByField.Count -1 do
      Result.Add(PTGroupedByFieldSet(m_ListOfGroupByField[I]).Code);
  end;
end;

//----------------------------------------------------------------------------//

procedure DeleteGroupedByFieldCode(Code : string);
var
  I : Integer;
  qry:  TMqmQuery;
  tbInfo: ^TTblInfo;
begin
  for I := m_ListOfGroupByField.Count - 1 downto 0 do
  begin
    if PTGroupedByFieldSet(m_ListOfGroupByField[I]).Code = code then
    begin
      m_ListOfGroupByField.Delete(I);
      break
    end;
  end;

  tbInfo := @tblInfo[tbl_GroupedByFields];
  qry := CreateQuery(Cfg_DB);
  Qry.Transaction := CreateTransaction(Cfg_DB);
  Qry.Transaction.StartTransaction;

  with qry.sql do
  begin
    Clear;
    Add('Delete from ' + tbInfo.GetTableName);
    Add(' Where ');
    Add(CreateFld(tbInfo.pfx, fli_wkstCode) + '=''' + IniAppGlobals.WkstCode + '''');
    Add( 'And' );
    Add(CreateFld(tbInfo.pfx, fli_GroupedByCode) + '=''' + Code + '''');
    qry.prepare;
    qry.ExecSQL;
  end;
  Qry.Transaction.Commit;

  qry.Free;
end;

//----------------------------------------------------------------------------//

function GetGroupBySetByCode(Code : string) : PTGroupedByFieldSet;
var
  I : Integer;
begin
  Result := nil;
  for I := 0 to m_ListOfGroupByField.Count - 1 do
  begin
    if code = PTGroupedByFieldSet(m_ListOfGroupByField[I]).Code then
    begin
      result := (m_ListOfGroupByField[I]);
      break
    end;
  end;
end;

//----------------------------------------------------------------------------//

function CheckGroupedByCodeFiledsForSearch(Code : string; BinColId : CBinColId) : boolean;
var
  GroupedByFieldSet : PTGroupedByFieldSet;
  I, num : Integer;
  pId : TPropId;
  PropCode : string;
begin
  Num := -1;
  Result := false;
  GroupedByFieldSet := GetGroupBySetByCode(code);
  case BinColId of
    CSC_ProdReq : begin
                    if FiltProdReq in GroupedByFieldSet.GroupedByOption then
                    begin
                       Result := true;
                       exit
                    end;
                  end;

    CSC_ProdFamily : begin
                       if FiltProdFamily in GroupedByFieldSet.GroupedByOption then
                       begin
                         Result := true;
                         exit
                       end;
                     end;

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
  else
    Result := false;
  end;

  if (num <> -1) then
  begin
    pId := DBAppGlobals.ShowBinPropArry[num];
    if not assigned(pId) then
    begin
      Exit;
    end;

    PropCode := GetPropCodeFromID (pId);
    for I := Low(GroupedByFieldSet.PropCode) to High(GroupedByFieldSet.PropCode) do
    begin
      if GroupedByFieldSet.PropCode[I] = PropCode then
      begin
        Result := true;
        break
      end;
    end;
  end;

end;

//----------------------------------------------------------------------------//

initialization

   m_ListOfGroupByField := TList.Create;

finalization

 ClearGroupedByList;

end.
