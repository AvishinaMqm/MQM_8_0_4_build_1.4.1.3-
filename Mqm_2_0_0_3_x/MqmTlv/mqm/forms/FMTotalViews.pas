unit FMTotalViews;

interface

uses
  cxButtons, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, umglobal, DMSrvpc, UMtblDesc, UMObjCont, UMcommon, UReShape, gnugettext, UMWkCtr,
  Vcl.ExtCtrls, Vcl.StdCtrls, Vcl.CheckLst, UGPropComp, UMCompat, Vcl.Grids, UMSchedList, UMMaths, Math,
  Vcl.Menus, UMSchedContFunc;

type

  TTotalsView = Record
    set_name    : String;
    Workstation : String;
    Wkc_list    : TList;
    Group_list  : TList;
    Formula_list : TList;
  end;
  PTTotalsView = ^TTotalsView;

  TTotalsViewGroup = Record
    PropID : TPropID;
    Sequence : Integer;
  end;
  PTTotalsViewGroup = ^TTotalsViewGroup;

  TTotalsViewFormula = Record
    Argument : Integer;
    PropID : TPropID;
    Attribute : Integer;
    Formula : String;
    Description : String;
    Decimals : String;
  end;
  PTTotalsViewFormula = ^TTotalsViewFormula;

  TFTotalViews = class(TForm)
    pnMain: TPanel;
    pnLow: TPanel;
    Button1: TcxButton;
    Button2: TcxButton;
    pnWKC: TPanel;
    CLBWorkCenters: TCheckListBox;
    pnGrp: TPanel;
    pnFormula: TPanel;
    sgFormula: TStringGrid;
    cbAtt: TComboBox;
    cbProp: TComboBox;
    PopupMenu1: TPopupMenu;
    Movedown1: TMenuItem;
    constructor CreateTotalView(AOwner: TComponent; TotalsView : PTTotalsView; setT : string);
    constructor CreateTotalView_Delete(AOwner: TComponent);
    constructor CreateTotalView_NewSet(AOwner: TComponent);
    constructor CreateTotalView_Final(AOwner: TComponent; mSched: TMSchedList;TotalsView : PTTotalsView; setT : string; IdGroup: Variant);
    procedure CreateNewSet(setName: string);
    procedure Save(SetType,setName: string);
    procedure FormCreate(Sender: TObject);
    procedure SetWKCPanel;
    Procedure SetGrpPanel;
    Procedure SetFormulaPanel;
    Procedure SetViewPanel;
    Procedure SetTotalsView(NumOfArgument : integer);
    function  DeleteSet(SetName: String): boolean;
    procedure Button1Click(Sender: TObject);
    Procedure SaveWkcToSet(SetName: String);
    procedure Button2Click(Sender: TObject);
    procedure FormShow(Sender: TObject);
    Procedure SavePropToSet(var msg : String);
    procedure SaveFormulaToSet(var msg : String);
    procedure sgFormulaSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure cbAttChange(Sender: TObject);
    procedure cbAttExit(Sender: TObject);
    procedure sgFormulaKeyPress(Sender: TObject; var Key: Char);
    procedure cbPropExit(Sender: TObject);
    procedure cbPropChange(Sender: TObject);
    procedure sgFormulaKeyDown(Sender: TObject; var Key: Word;
      Shift: TShiftState);
    procedure sgFormulaDrawCell(Sender: TObject; ACol, ARow: Integer;
      Rect: TRect; State: TGridDrawState);
    procedure Movedown1Click(Sender: TObject);
    procedure adjustGridWidth(grid:TStringGrid);
    procedure sgFormulaFixedCellClick(Sender: TObject; ACol, ARow: Integer);
    Procedure SortGridByColumn(ACol : Integer; Asc : Boolean);
  private
    m_TTotalsView : PTTotalsView;
    m_PropComp : TPropComponent;
    m_setType : string;
    m_SetName : string;
    m_main_Sched : TMSchedList;
    Err : String;
  public
    function  GetError : string;
  end;

  procedure ClearTotalViewList;
  procedure BuildTotalViewStructure_FromDB;
  function  GetTotalViews_List : TList;
  function  GetCodeViewName(I : integer) : string;

implementation

  uses  UMSchedCont;

{$R *.dfm}

var
  M_TotalViews_List : TList;


function  TFTotalViews.GetError : string;
begin
  Result := Err;
end;

//----------------------------------------------------------------------------//

procedure TFTotalViews.SaveFormulaToSet(var msg : String);
var i : Integer;
  PropCode : string;
  PropID : TPropID;
  tvFor : PTTotalsViewFormula;
begin
  msg := '';

  m_TTotalsView.Formula_list.Clear;

  for i := 1 to sgFormula.RowCount -1 do
  begin

    if (sgFormula.Cells[1, i] = '') and (sgFormula.Cells[2, i] = '0-NA') and (sgFormula.Cells[3, i] = '') then
      continue;

    if (sgFormula.Cells[1, i] <> '')  then  //Prop <> ''
    begin
      if (sgFormula.Cells[2, i] = '1-Job quantity') or (sgFormula.Cells[3, i] <> '') then
      begin
        msg := _('Cannot have Atribute or Formula for argument ' + sgFormula.Cells[0, i]) ;
        exit;
      end;

      if sgFormula.Cells[5, i] <> '' then
      begin
        msg := _('Decimals must be blank for argument ' + sgFormula.Cells[0, i]) ;
        exit;
      end;
    end;

    if (sgFormula.Cells[2, i] = '1-Job quantity')  then  //Atribute = '1-Job quantity'
    begin
      if (sgFormula.Cells[1, i] <> '') or (sgFormula.Cells[3, i] <> '') then
      begin
        msg := _('Cannot have Property or Formula for argument ' + sgFormula.Cells[0, i]) ;
        exit;
      end;

      if sgFormula.Cells[5, i] <> '' then
      begin
        msg := _('Decimals must be blank for argument ' + sgFormula.Cells[0, i]) ;
        exit;
      end;
    end;

    if (sgFormula.Cells[3, i] <> '')  then  //Formula <> ''
    begin
      if (sgFormula.Cells[2, i] = '1-Job quantity') or (sgFormula.Cells[1, i] <> '') then
      begin
        msg := _('Cannot have Atribute or Property for argument ' + sgFormula.Cells[0, i]) ;
        exit;
      end;

      if sgFormula.Cells[5, i] = '' then
      begin
        msg := _('Decimals cannot be blank for argument ' + sgFormula.Cells[0, i]) ;
        exit;
      end;
    end;

    New(tvFor);
    tvFor.Argument    := StrToInt(sgFormula.Cells[0, i]);

    if sgFormula.Cells[1, i] <> '' then
    begin
      cbProp.ItemIndex := cbProp.Items.IndexOf(sgFormula.Cells[1, i]);
      tvFor.PropID :=  cbProp.Items.Objects[cbProp.ItemIndex];
    end else
      tvFor.PropID := nil;

    tvFor.Attribute   := StrToInt(Copy(sgFormula.Cells[2, i], 1,1));
    tvFor.Formula     := sgFormula.Cells[3, i];
    tvFor.Description := sgFormula.Cells[4, i];

    if sgFormula.Cells[5, i] = '' then
      tvFor.Decimals    := '0'
    else
      tvFor.Decimals    := sgFormula.Cells[5, i];
    m_TTotalsView.Formula_list.add(tvFor);

  end;

end;

procedure TFTotalViews.SaveWkcToSet(SetName : String);
var
  I, y : Integer;
  x: Integer;
  workcenter: String;
begin

  m_TTotalsView.Wkc_list.Clear;

  for y := 0 to CLBWorkCenters.Count - 1 do
  begin
    if CLBWorkCenters.Checked[y] then
    begin

      for x := 0 to p_pl.p_WrkCtrsCount-1 do
      begin
        workcenter := TMqmWrkCtr(p_pl.p_WrkCtr[x]).p_WrkCtrCode;
        if workcenter = CLBWorkCenters.Items[y] then
        begin
          m_TTotalsView.Wkc_list.Add(TMqmWrkCtr(p_pl.p_WrkCtr[x]));
          break;
        end;

      end;
    end;

  end;

end;

//----------------------------------------------------------------------------//

procedure TFTotalViews.SavePropToSet(var msg : String);
var i,y,x : Integer;
  PropCode : string;
  PropID : TPropID;
  tvGrp : PTTotalsViewGroup;
  tempS : TStringList;
begin
  msg := '';

  tempS := TStringList.create;

   for I := 1 to m_PropComp.P_RowCount - 1 do
   begin
    PropCode := m_PropComp.P_GetPropVal[I];
    if PropCode = '' then break;
    PropID := GetIdFromCode(PropCode);

    if m_PropComp.P_GetSeqVal[i] = '' then
      msg := _('Sequence cannot be blank for property ' + PropCode)
    else
      tempS.Add(m_PropComp.P_GetSeqVal[i]);
   end;

   tempS.Sorted := True;

   for y := 0 to tempS.Count -1 do
   begin
     for x := y + 1 to tempS.Count -1 do
      if tempS[x] = tempS[y] then
      begin
        msg := _('Sequences cannot be same!');
        break;
      end;

   end;


   tempS.Free;

   if msg = '' then
   begin
      i := 1;
      m_TTotalsView.Group_list.clear;
      for I := 1 to m_PropComp.P_RowCount - 1 do
      begin
        PropCode := m_PropComp.P_GetPropVal[I];
        if PropCode = '' then break;
        PropID := GetIdFromCode(PropCode);
        new(tvGrp);
        tvGrp.PropID := PropId;
        tvGrp.Sequence := StrToInt(m_PropComp.P_GetSeqVal[i]);

        //TTotalsView(M_TotalViews_List[i]).Group_list.add(tvGrp);
        m_TTotalsView.Group_list.add(tvGrp);
      end;

   end;
end;

procedure TFTotalViews.adjustGridWidth(grid:TStringGrid);

  function GetTextWidthEx(AText: string; AFont: TFont): integer;
    var
    lbl: TLabel;
  begin
    Result := 0;
    lbl := Tlabel.Create(nil);
    try
      lbl.Font := AFont;
      lbl.AutoSize := True;
      lbl.Caption := AText;
      Result := lbl.Width + 5;
    finally
      lbl.Free;
    end;
  end;

var w, i, tmp,m : integer;
begin

  tmp := 0;
  m := 0;

  with grid do
  begin
    w := 0;
    for i := 0 to colcount - 1 do
    begin
      //colwidths[i] := GetTextWidthEx(Cells[i, 0], Font);
      tmp := GetTextWidthEx(Cells[i, 0], Font);

      if tmp > m then
        m := tmp;
    end;
  end;

  with grid do
  begin
    for i := 0 to colcount - 1 do
    begin
      colwidths[i] := m;
      w := w + m;
    end;
  end;

  self.width := w + 25;
end;

procedure TFTotalViews.Button1Click(Sender: TObject);
var
  i: Integer;
  checked: boolean;
  m : String;
begin

  if m_setType = 'wkc' then
  begin
    checked := false;

    for i := 0 to CLBWorkCenters.Count - 1 do
    begin
      if  CLBWorkCenters.Checked[i] then
      begin
        checked := true;
        break;
      end;
    end;

    if not checked then
    begin
      ShowMessage(_('Set is not applied to any work center'));
      Exit;
    end;

    SaveWkcToSet(m_SetName);

  end else if m_SetType = 'group' then
    SavePropToSet(m)
  else if m_SetType = 'formula' then
    SaveFormulaToSet(m);

  if m <> ''  then
      Messagedlg(m, mtError , [mbOK], 0)
  else
  begin
    Save(m_setType, m_SetName);
    Close;
  end;

end;

//----------------------------------------------------------------------------//

procedure TFTotalViews.Button2Click(Sender: TObject);
begin
  Close;
end;

procedure TFTotalViews.cbAttChange(Sender: TObject);
begin
  sgFormula.Cells[sgFormula.Col, sgFormula.Row] := cbAtt.Items[cbAtt.ItemIndex];
  cbAtt.Text := '';
  cbAtt.Visible := False;
  sgFormula.SetFocus;
end;

procedure TFTotalViews.cbAttExit(Sender: TObject);
begin
  if cbAtt.Items.Count > 0 then
    cbAtt.ItemIndex := 0;

  cbAtt.Visible  := False;
  sgFormula.SetFocus;
end;

procedure TFTotalViews.cbPropChange(Sender: TObject);
begin
  //Prop
  if (sgFormula.Cells[3, sgFormula.Row] = '') then //formula = ''
    sgFormula.Cells[sgFormula.Col, sgFormula.Row] := cbProp.Items[cbProp.ItemIndex];
 // else
 //   sgFormula.Cells[sgFormula.Col, sgFormula.Row] := '';

  cbProp.Visible  := False;
  sgFormula.SetFocus;
end;

procedure TFTotalViews.cbPropExit(Sender: TObject);
begin
  if cbProp.Items.Count > 0 then
    cbProp.ItemIndex := 0;
  cbProp.Visible  := False;
  sgFormula.SetFocus;
end;

//----------------------------------------------------------------------------//

constructor TFTotalViews.CreateTotalView(AOwner: TComponent; TotalsView : PTTotalsView; setT : string);
begin
  inherited Create(AOwner);
  m_TTotalsView := TotalsView;
  m_setType := setT;
  m_SetName := TotalsView.set_name;

  if m_setType = 'wkc' then
  begin
    Caption := _('Configuration of Work centers');
    pnWKC.Visible := True;
    pnGrp.Visible := False;
    pnFormula.Visible := False;
    pnLow.Visible := True;
    Width := 250;
  end
  else if m_setType = 'group' then
  begin
    Caption := _('Configuration of Properties grouping by');
    Width := 580;
    pnGrp.Visible := True;
    pnWKC.Visible := False;
    pnFormula.Visible := False;
    pnLow.Visible := True;
  end else if m_setType = 'formula' then
  begin
    Caption := _('Configuration of Formula content');
    pnWKC.Visible := False;
    pnGrp.Visible := False;
    pnFormula.Visible := True;
    pnLow.Visible := True;
    Width := 700;
    cbAtt.Visible := True;
    cbProp.Visible := True;
    sgFormula.Options := sgFormula.Options + [goEditing];
    sgFormula.PopupMenu := PopupMenu1;
  end;

  BorderStyle := bsSingle;
end;

//----------------------------------------------------------------------------//

constructor TFTotalViews.CreateTotalView_Delete(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

constructor TFTotalViews.CreateTotalView_Final(AOwner: TComponent;
  mSched: TMSchedList; TotalsView: PTTotalsView; setT : string; IdGroup: Variant);
begin
  inherited Create(AOwner);
  m_TTotalsView := TotalsView;
  m_setType := setT;
  m_SetName := TotalsView.set_name;
  m_main_Sched := mSched;

  Caption := _('Formula result') +' : ' + m_SetName + '('+ IntToStr(IdGroup)+')';
  pnWKC.Visible := False;
  pnGrp.Visible := False;
  pnFormula.Visible := True;
  pnLow.Visible := False;
  //Width := 800;
  sgFormula.Options := sgFormula.Options - [goEditing];
  cbAtt.Visible := False;
  cbProp.Visible := False;
  BorderStyle := bsSizeable;
  sgFormula.PopupMenu := nil;
end;

//----------------------------------------------------------------------------//

constructor TFTotalViews.CreateTotalView_NewSet(AOwner: TComponent);
begin
  inherited Create(AOwner);
end;

//----------------------------------------------------------------------------//

procedure TFTotalViews.CreateNewSet(setName: string);
begin
  new(m_TTotalsView);
  m_TTotalsView.Wkc_list := Tlist.Create;
  m_TTotalsView.Group_list := TList.Create;
  m_TTotalsView.Formula_list := TList.Create;
  m_TTotalsView.set_name := setName;
  m_TTotalsView.Workstation := IniAppGlobals.WkstCode;
  M_TotalViews_List.Add(m_TTotalsView);
end;

//----------------------------------------------------------------------------//

function TFTotalViews.DeleteSet(SetName: String): boolean;
var qry:       TMqmQuery;
  tbInfo:    ^TTblInfo;
  i, y : Integer;
  tv : PTTotalsView;
begin
  tbInfo := @tblInfo[tbl_TotalsView];
  qry := CreateQuery(Main_DB);
  Qry.Transaction := CreateTransaction(Main_DB);
  Qry.Transaction.StartTransaction;

  qry.SQL.Text := 'Delete from ' + tbInfo.GetTableName
    + ' where ' + CreateFld(tbInfo.pfx, fli_OwnerWorkStation) + ' = ''' + IniAppGlobals.WkstCode + ''''
    + ' and ' + CreateFld(tbInfo.pfx, fli_TotalCode) + ' = ''' + setName + ''''
    + AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier));

  qry.ExecSql;

  qry.Close;
  tbInfo := @tblInfo[tbl_TotalsViewWorkCenters];
  qry.SQL.Text := 'Delete from ' + tbInfo.GetTableName
    + ' where ' + CreateFld(tbInfo.pfx, fli_TotalCode) + ' = ''' + setName + ''''
    + AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier));

  qry.ExecSql;

  qry.Close;
  tbInfo := @tblInfo[tbl_TotalsViewGroupByColumns];
  qry.SQL.Text := 'Delete from ' + tbInfo.GetTableName
    + ' where ' + CreateFld(tbInfo.pfx, fli_TotalCode) + ' = ''' + setName + ''''
    + AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier));

  qry.ExecSql;

  qry.Close;
  tbInfo := @tblInfo[tbl_TotalsViewContent];
  qry.SQL.Text := 'Delete from ' + tbInfo.GetTableName
    + ' where ' + CreateFld(tbInfo.pfx, fli_TotalCode) + ' = ''' + setName + ''''
    + AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier));

  qry.ExecSql;

  qry.Transaction.Commit;
  qry.Close;
  qry.Free;
end;

//----------------------------------------------------------------------------//

function SortBySeq(Item1, Item2: Pointer) : integer;
var
  res1, res2: PTTotalsViewGroup;
begin
  res1 := PTTotalsViewGroup(Item1);
  res2 := PTTotalsViewGroup(Item2);

  if Res1.Sequence > Res2.Sequence then
    Result := 1
  else if Res1.Sequence < Res2.Sequence then
    Result := -1
  else
    Result := 0;

end;

Procedure TFTotalViews.SetTotalsView(NumOfArgument : integer);

  Function AddTotals(SL : Array Of TStringList; GrpCount : Integer) : Integer;
    var i, y, x, rowNumber,  a : Integer;
    s1, s2 : String;
    Sum : Double;
  begin

    SL[GrpCount - 1].add('Totals');
    Result := SL[GrpCount - 1].count;

    for i := GrpCount to Length(SL) - 1 do
    begin
      Sum := 0;

      for y := 0 to SL[i].Count - 1 do
      begin
        if SL[i].Strings[y] <> '' then
          sum := sum + StrToFloat(SL[i].Strings[y]);
      end;

      if SL[i].Count > 0 then
        SL[i].add(FloatToStr(Sum));
    end;
  end;

  Procedure CheckDuplicates(SL : Array Of TStringList; GrpCount : Integer);
    var i, y, x, w, rowNumber,  a : Integer;
    s1, s2 : String;
  begin
    i := 0;

    if sl[0].Count < 2 then exit;
    rowNumber := sl[0].Count;

    while i < sl[0].Count -1 do
    begin

      s1 := '';
      s2 := '';

      for y := 0 to GrpCount - 1 do
        s1 := s1 + ' ' +sl[y].Strings[i];

      if i + 1 <= sl[0].Count -1 then
        y := i +1
      else
        exit;

      while  y <= sl[0].Count - 1 do
      begin

        s2 := '';

        for a := 0 to GrpCount - 1 do
          s2 := s2 + ' ' +sl[a].Strings[y];

          if (s1 = s2) and (s1 <> '') then  //Merge same group
          begin
            for x := GrpCount to length(SL) - 1 do
            begin

              if sl[x].Count > 1 then
              begin

                if (sl[x].Strings[y] <> '') then //summarize same group
                  sl[x].Strings[i] := FloatToStr(StrToFloat(sl[x].Strings[i]) + StrToFloat(sl[x].Strings[y]));

                if sl[x].Count > 0 then
                  sl[x].Delete(y);

              end;
            end;

            for w := 0 to GrpCount - 1 do
              if sl[w].Count > 0 then
                  sl[w].Delete(y);

            if y < sl[0].Count - 1 then
              y := i + 1;


          end else
          begin
            inc(y);
          end;

      end;

      Inc(i);
    end;
  end;

  Function GetAttributeValue(SL : Array Of TStringList;Attribute : String; GrpCount : Integer; RowNumber: Integer) : Double;
  var i, y,  x : Integer;
  c : String;
  begin
     result := 0;

     for i := 1 to length(Attribute) do
     begin
       c := Attribute[i];
       break;
     end;

     x := StrToInt(Copy(Attribute, 2 , Length(Attribute)));

     if C = 'T' then
     begin
        try
        if Trim(SL[GrpCount - 1 + x].Strings[SL[GrpCount - 1 + x].count - 1]) <> '' then
          Result := StrToFloat(SL[GrpCount - 1 + x].Strings[SL[GrpCount - 1 + x].count - 1])
        except
          //MessageDlg(_('Please check formula for argument: ' + Attribute), mtWarning, [mbOk], 0);
          Err := _('Please check formula for argument: ' + Attribute)
        end;
     end else
     begin

        try
        if (trim(SL[GrpCount - 1 + x].Strings[RowNumber]) <> '') then
          Result := StrToFloat(SL[GrpCount - 1 + x].Strings[RowNumber]);
        except
         // MessageDlg(_('Please check formula for argument: ' + Attribute) + char(13) + _('Value = 0'), mtWarning, [mbOk], 0);
          Err := _('Please check formula for argument: ' + Attribute) + char(13) + _('Value = 0');
        end;

     end;


  end;

  Function MakeFormula(SL : Array Of TStringList; GrpCount : Integer; Formula : String; RowNumber: Integer) : String;
     var i, y, x : Integer;
    Att, T : String;
    c : Char;
    NotAtt : Boolean;
  begin
    x := 1;
    NotAtt := True;
    result := '';

    while x <= Length(Formula) do
    begin
      c := Formula[x];

      if (CharInSet(C, ['0'..'9', FormatSettings.DecimalSeparator, '(', ')', '+', '-', '*', '/'])) then
      begin
        Result := Result + c;
        inc(x);
      end else
      if CharInSet(C, ['A', 'T']) then
      begin
        Att := C;

        for y := x + 1 to length(Formula) do
          if CharInSet(Formula[y], ['0'..'9'])  then
          begin
            NotAtt := False;
            Att := Att + Formula[y];

            if x <= Length(Formula) - 1 then
              inc(x);
          end else
          begin
            Result := Result + FloatToStr(GetAttributeValue(SL, Att, GrpCount, RowNumber));
            if Err <> '' then
            begin
              exit;
            end;

            inc(x);
            break;
          end;

        if x = length(Formula) then
        begin
          Result := Result + FloatToStr(GetAttributeValue(SL, Att, GrpCount, RowNumber));

          if Err <> '' then
          begin
            exit;
          end;

          break
        end;

      end;

    end;

  end;

var i, ForNum, y, b, rowNumber,FormulaCount, v, GrpCount, GroupCount, a, NumOfArguments : Integer;
  sl : TSTringList;
  tv : PTTotalsView;
  PropGrpArray : Array Of TStringList;
  value, FormulaSum: variant;
  dataType: CBinColValType;
  Id: TSchedId;
  PropType : CScPropType;
  Formula : PTTotalsViewFormula;
  Src : String;
begin
  SetLength(PropGrpArray, m_TTotalsView.Group_list.Count);
  rowNumber := 0;
  GroupCount :=  m_TTotalsView.Group_list.Count;
  //Group by properties
  for I := 0 to m_TTotalsView.Group_list.Count - 1 do
  begin
    PropGrpArray[i] := TStringList.Create;
    PropGrpArray[i].Delimiter := ' ';
    inc(rowNumber);

    for y := 0 to m_main_Sched.GetLinkCount - 1 do
    begin
      id := TSchedId(m_main_Sched.GetLink(y));
      p_sc.GetPropVal(id, PTTotalsViewGroup(m_TTotalsView.Group_list[i]).PropID, value);
      PropGrpArray[i].add(Value);
    end;
  end;

  for I := 0 to m_TTotalsView.Formula_list.Count -1 do
  begin

    Formula := PTTotalsViewFormula(m_TTotalsView.Formula_list[i]);
    SetLength(PropGrpArray, Length(PropGrpArray) + 1);
    PropGrpArray[rowNumber] := TStringList.Create;
    PropGrpArray[rowNumber].Delimiter := ' ';
     ///Properties and attribute only
    if //(Formula.Description <> '') and
    (Formula.Formula = '')
    then
    begin

      for y := 0 to m_main_Sched.GetLinkCount - 1 do
      begin
        Value := 0;

        id := TSchedId(m_main_Sched.GetLink(y));

        if Formula.PropID <> nil then //Properties
          p_sc.GetPropVal(id, Formula.PropID, value)
        else if Formula.Attribute = 1 then  //Attribute
          p_sc.GetFldValue(Id, CSC_IniQty , value, dataType);

        PropGrpArray[rowNumber].add(Value);
      end;

    end;// else if (Formula.Description = '') and (Formula.Formula = '') then //Non title
    //  PropGrpArray[rowNumber].add('0');

    Inc(rowNumber);

  end;

  CheckDuplicates(PropGrpArray, GroupCount);
  var q := AddTotals(PropGrpArray, GroupCount);

  ///Formula
  FormulaCount := 0;
  v := 0;
  for I := 0 to m_TTotalsView.Formula_list.Count -1 do
  begin

    Formula := PTTotalsViewFormula(m_TTotalsView.Formula_list[i]);

    if //(Formula.Description <> '') and
    (Formula.Formula <> '')
    then
    begin
       FormulaSum := 0;
       Inc(FormulaCount);
       value := 0;

       if PropGrpArray[GroupCount + i].Count > 0 then continue;

      for a := 0 to q - 2 do // - 2 to avoid total
      begin
        Src := MakeFormula(PropGrpArray, GroupCount, Formula.Formula, a);
        if Err <> '' then
        begin
          exit;
        end;
        value := DoMath(Src);
        PropGrpArray[GroupCount + i].add(Value);
        FormulaSum := FormulaSum + Value;
      end;

      PropGrpArray[GroupCount + i].add(FormulaSum);
    end;{ else if (Formula.Description = '') and (Formula.Formula <> '') then //Non title
    begin
      PropGrpArray[GroupCount + i].add('0');
      FormulaSum := 0;
      Inc(FormulaCount);
    end;    }


    inc(v);
  end;

  //paint values to grid
  ForNum := -1;
  b := -1;

  for i := 0 to Length(PropGrpArray) - 1 do
  begin
     inc(b);

     if m_TTotalsView.Formula_list.count > 0 then
     begin
        if i > GroupCount - 1 then
        begin
          if PTTotalsViewFormula(m_TTotalsView.Formula_list[i - GroupCount]).Description = '' then
          begin
            inc(ForNum);
            dec(b);
           // if b > 0 then
           //   Dec(b);
            Continue;
          end else
            inc(ForNum);

        end;
     end;

    for y := 0 to PropGrpArray[i].Count -1 do
    begin
      if (i > GroupCount - 1) and (FormulaCount > 0) and (ForNum > -1) then
      begin
        if PTTotalsViewFormula(m_TTotalsView.Formula_list[ForNum]).Formula <> '' then
        begin
          if (PropGrpArray[i].Strings[y] = 'INF') or (PropGrpArray[i].Strings[y] = 'NAN') then
            sgFormula.Cells[b, y + 1] := '0'
          else
            sgFormula.Cells[b, y + 1] := FloatToStr(RoundTo(StrToFloat(PropGrpArray[i].Strings[y]), StrToInt('-'+PTTotalsViewFormula(m_TTotalsView.Formula_list[ForNum]).Decimals) ))
        end else
          sgFormula.Cells[b, y + 1] := FormatFloat('#,##0.00', StrToFloat(PropGrpArray[i].Strings[y]));
      end else
        sgFormula.Cells[b, y + 1] := PropGrpArray[i].Strings[y];
    end;

  end;

  sgFormula.RowCount := q + 1;
  adjustGridWidth(sgFormula);

  {if sgFormula.ColCount > 0 then
    Width := sgFormula.Colcount * 83;   }
  // := sgFormula.Width + 5;

  if sgFormula.RowCount + 1 <= 5 then
    Height := 200
  else
    Height := (sgFormula.RowCount + 1) * 35;

  //destroy matrix
  for i := Length(PropGrpArray) - 1 downto 0 do
    PropGrpArray[i].Free;
end;

procedure TFTotalViews.SetViewPanel;
var i, y, rowNumber, GrpCount, ColCount, NumOfArguments : Integer;
  sl : TSTringList;
  JobsInBinCount, g : Integer;
  ChildId, id : TSchedID;
  ObjList : TMSchedList;
  planInfo: TSQplanInfo;
  WC  : TMqmWrkCtr;
begin
  Err := '';
  JobsInBinCount := m_main_Sched.GetLinkCount;

  for i := 0 to JobsInBinCount - 1 do
  begin
    id := m_main_Sched.GetLink(I);
    if id = CSchedIdNull then
    begin
      exit;
    end;

    p_sc.GetPlanInfo(id, planInfo);

    if planInfo.isGroup then
    begin
      for G := 0 to p_sc.GetGrpNumSons(Id) - 1 do
      begin
        ChildId := p_sc.GetGrpSon(Id, G);
        WC := TMqmWrkCtr(p_sc.GetWrkCtrPtr(ChildId));

        if Assigned(WC) then
          if m_TTotalsView.Wkc_list.IndexOf(WC) = -1 then
          begin
            MessageDlg(_('Some of selected jobs have unselected Work center in formula!'), mtError, [mbok], 0);
            close;
            exit;
          end;
      end;
    end else
    begin
       WC := TMqmWrkCtr(p_sc.GetWrkCtrPtr(Id));

      if Assigned(WC) then
        if m_TTotalsView.Wkc_list.IndexOf(WC) = -1 then
        begin
          MessageDlg(_('Some of selected jobs have unselected Work center in formula!'), mtError, [mbok], 0);
          close;
          exit;
        end;
    end;
  end;

  m_TTotalsView.Group_list.Sort(SortBySeq);

  sl := TStringList.Create;
  ColCount := 0;
  NumOfArguments := 0;
  GrpCount := m_TTotalsView.Group_list.Count;
  sgFormula.ColCount := 100;

  for i := 0 to GrpCount - 1 do
  begin
    sgFormula.Cells[i, 0] := GetPropDescr(PTTotalsViewGroup(m_TTotalsView.Group_list[i]).PropID);
    inc(ColCount);
  end;

  for I := 0 to m_TTotalsView.Formula_list.Count -1 do
  if PTTotalsViewFormula(m_TTotalsView.Formula_list[i]).Description <> '' then
  begin
    Inc(NumOfArguments);
    inc(ColCount);
    sgFormula.Cells[ColCount-1, 0] := PTTotalsViewFormula(m_TTotalsView.Formula_list[i]).Description;
  end;

  sgFormula.ColCount := ColCount;
  sgFormula.ColWidths[0] := 100;

  sl.Free;

  SetTotalsView(NumOfArguments);

end;

procedure TFTotalViews.SetFormulaPanel;
var i, rowNumber : Integer;
  sl : TList;
begin
  sgFormula.Cells[0,0] := 'Argument';
  sgFormula.Cells[1,0] := 'Property';
  sgFormula.Cells[2,0] := 'Attribute';
  sgFormula.Cells[3,0] := 'Formula';
  sgFormula.Cells[4,0] := 'Title';
  sgFormula.Cells[5,0] := 'Decimals';

  sgFormula.ColWidths[1] := 150;
  sgFormula.ColWidths[2] := 100;
  sgFormula.ColWidths[3] := 120;
  sgFormula.ColWidths[4] := 120;

  i := 0;
  with cbProp do
  begin
    sgFormula.DefaultRowHeight := Height;
    Visible := False;

    SL := m_PropComp.GetNumericPropList;

    for i := 0 to SL.Count -1 do
      Items.AddObject(GetPropDescr(sl[i]),sl[i]);   //description + propid

    sl.free;

    Text := '';
  end;

  with cbAtt do
  begin
    sgFormula.DefaultRowHeight := Height;
    Visible := False;
    Items.Add('0-NA');
    Items.Add('1-Job quantity');
    Text := '';
  end;

  i := 0;

  if m_TTotalsView.Formula_list.count > 21 then
    sgFormula.rowcount := m_TTotalsView.Formula_list.count;

  for i := 0 to m_TTotalsView.Formula_list.count -1 do
  begin
    sgFormula.Cells[0,i+1] := IntToStr(PTTotalsViewFormula(m_TTotalsView.Formula_list[i]).Argument);

    if CheckPropExistByID(PTTotalsViewFormula(m_TTotalsView.Formula_list[i]).PropID) then
      sgFormula.Cells[1,i+1] := GetPropDescr(PTTotalsViewFormula(m_TTotalsView.Formula_list[i]).PropID);

    if PTTotalsViewFormula(m_TTotalsView.Formula_list[i]).Attribute = 0 then
      sgFormula.Cells[2,i+1] := '0-NA'
    else
      sgFormula.Cells[2,i+1] := '1-Job quantity';

    sgFormula.Cells[3,i+1] := PTTotalsViewFormula(m_TTotalsView.Formula_list[i]).Formula;
    sgFormula.Cells[4,i+1] := PTTotalsViewFormula(m_TTotalsView.Formula_list[i]).Description;

    if PTTotalsViewFormula(m_TTotalsView.Formula_list[i]).Formula = '' then
      sgFormula.Cells[5,i+1] := ''
    else
      sgFormula.Cells[5,i+1] := PTTotalsViewFormula(m_TTotalsView.Formula_list[i]).Decimals;
  end;

  rowNumber := 20;

  if m_TTotalsView.Formula_list.count > 0 then
  begin
    if m_TTotalsView.Formula_list.count > 20 then
      rowNumber := m_TTotalsView.Formula_list.count;

    for i := m_TTotalsView.Formula_list.count + 1 to rowNumber do
    begin
      sgFormula.Cells[0,i] := IntToStr(i);  //argument
      sgFormula.Cells[2,i] := '0-NA';  //attribute
    end;
  end else
  begin
    for i:= 1 to rowNumber do
    begin
      sgFormula.Cells[0,i] := IntToStr(i); //argument
      sgFormula.Cells[2,i] := '0-NA';  //attribute
    end;
  end;

end;

procedure TFTotalViews.SetGrpPanel;
var i : Integer;
  PropCode : string;
  PropID : TPropID;
  tvGrp : PTTotalsViewGroup;
begin
  m_PropComp := TPropComponent.CreatePropComp(pnGrp,GroupBy,nil,-1, nil, nil);

  if m_TTotalsView.Group_list.count > 0 then
    for I := 0 to m_TTotalsView.Group_list.count - 1 do
    begin
      PropCode := GetPropCodeFromID(PTTotalsViewGroup(m_TTotalsView.Group_list[i]).PropID);
      m_PropComp.AddPropLineForGrp(PropCode, IntToStr(PTTotalsViewGroup(m_TTotalsView.Group_list[i]).sequence));

    end;
end;

procedure TFTotalViews.SetWKCPanel;
var
  i, y : Integer;
  workcenter: String;
  ExistOneWc : boolean;
  WKC : TStringList;
  WrkCtrCode : string;
begin
  CLBWorkCenters.Items.Clear;
  ExistOneWc := false;
  WKC := TStringList.Create;

  if m_TTotalsView.Wkc_list.Count > 0 then
    for i := 0 to m_TTotalsView.Wkc_list.Count-1 do
    begin
      if TMqmWrkCtr(m_TTotalsView.Wkc_list.Items[i]) <> nil then
      begin
        WrkCtrCode := TMqmWrkCtr(m_TTotalsView.Wkc_list.Items[i]).p_WrkCtrCode;
        WKC.Add(WrkCtrCode);
      end;
    end;

  for i := 0 to p_pl.p_WrkCtrsCount-1 do
  begin
    workcenter := TMqmWrkCtr(p_pl.p_WrkCtr[i]).p_WrkCtrCode;
    CLBWorkCenters.Items.Add(workcenter);

    if wkc.IndexOf(workcenter) > -1 then
      CLBWorkCenters.Checked[i] := True;
  end;

  wkc.Clear;
  wkc.Free;
end;

procedure TFTotalViews.sgFormulaDrawCell(Sender: TObject; ACol, ARow: Integer;
  Rect: TRect; State: TGridDrawState);
begin
  if m_setType = 'view' then
  begin
    if ARow = 0 then
    begin
      TSTringGrid(sender).Canvas.Brush.Color := clMedGray;
      TSTringGrid(sender).Canvas.FillRect(rect);
      TSTringGrid(sender).Canvas.TextOut(Rect.Left + 2, Rect.Top + 4, TSTringGrid(sender).cells[ACol, ARow]);
    end else
      TSTringGrid(sender).Canvas.Brush.Color := clWhite;

    if ARow + 1 = TSTringGrid(sender).RowCount then
    begin
      TSTringGrid(sender).Canvas.Brush.Color := clSilver;
      TSTringGrid(sender).Canvas.FillRect(rect);
      TSTringGrid(sender).Canvas.TextOut(Rect.Left + 5, Rect.Top + 4, TSTringGrid(sender).cells[ACol, ARow]);
    end else
      TSTringGrid(sender).Canvas.Brush.Color := clWhite;
  end;
end;


Procedure TFTotalViews.SortGridByColumn(ACol : Integer; Asc : Boolean);
const
  TheSeparator = '@';
var
  CountItem, I, J, K, ThePosition: integer;
  MyList: TStringList;
  MyString, TempString: string;
begin
  CountItem     := sgFormula.RowCount-1;
  MyList        := TStringList.Create;
  MyList.Sorted := False;

  try
    begin
      for I := 1 to CountItem - 1 do
        MyList.Add(sgFormula.Rows[I].Strings[ACol] + TheSeparator +
          sgFormula.Rows[I].Text);

      Mylist.Sort;

      for K := 1 to Mylist.Count do
      begin

        MyString := MyList.Strings[(K - 1)];

        ThePosition := Pos(TheSeparator, MyString);
        TempString  := '';

        TempString := Copy(MyString, (ThePosition + 1), Length(MyString));
        MyList.Strings[(K - 1)] := '';
        MyList.Strings[(K - 1)] := TempString;
      end;


    end;

    if Asc then
    begin
      for J := 1 to CountItem - 1 do
          sgFormula.Rows[J].Text := MyList.Strings[(J - 1)];
    end else
    begin
      for J := CountItem - 1 downto 1  do
       sgFormula.Rows[CountItem - J].Text := MyList.Strings[(J - 1)];
    end;

  finally
    MyList.Free;
  end;
end;

procedure TFTotalViews.sgFormulaFixedCellClick(Sender: TObject; ACol,
  ARow: Integer);
begin
  if m_setType <> 'view' then exit;

  if ARow = 0 then
    SortGridByColumn(ACol, True);

end;

procedure TFTotalViews.sgFormulaKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (key = 40) and  (sgFormula.Row = sgFormula.RowCount - 1) then //adding new line
  begin
    sgFormula.RowCount := sgFormula.RowCount + 1;
    sgFormula.Cells[0, sgFormula.RowCount -1] := IntToStr(sgFormula.RowCount-1); //argument
    sgFormula.Cells[2, sgFormula.RowCount -1] := '0-NA';
  end;
end;

procedure TFTotalViews.sgFormulaKeyPress(Sender: TObject; var Key: Char);
begin

  if (key = chr(vk_Back))
 // or (key = chr(VK_DELETE))
  then
    exit;

  //Decimals
  if sgFormula.Col = 5 then
  begin

    if sgFormula.Cells[5, sgFormula.Row] <> ''  then
      abort;

    if not ((CharInSet(Key, ['0'..'9']))) then
      abort;

    if Key = '.' then abort

  end;

  //Formula
  if sgFormula.Col = 3 then
  begin
    if not ((CharInSet(Key, [FormatSettings.DecimalSeparator, '0'..'9', 'A', 'a', 't', 'T', '+', '-', '*', '/', ')', '(']))) then
      abort;

   // if Key = '.' then abort

  end;

end;


procedure TFTotalViews.sgFormulaSelectCell(Sender: TObject; ACol, ARow: Integer;
  var CanSelect: Boolean);
var
  R: TRect;
begin

  if m_setType = 'view' then
  begin
    if ARow = sgFormula.RowCount - 1  then
      SortGridByColumn(ACol, False);
  end else
  begin

    //Prop
    if (ACol = 1) and (ARow <> 0) then
    begin
      R := sgFormula.CellRect(ACol, ARow);
      R.Left := R.Left + sgFormula.Left;
      R.Right := R.Right + sgFormula.Left;
      R.Top := R.Top + sgFormula.Top;
      R.Bottom := R.Bottom + sgFormula.Top;
      with cbProp do
      begin
        Left := R.Left + 2 ;
        Top := R.Top+ 2 ;
        Width := (R.Right) - R.Left;
        Height := (R.Bottom ) - R.Top;
        Visible := True;
        SetFocus;
      end;
    end;

    //Attribute
    if (ACol = 2) and (ARow <> 0) then
    begin
      R := sgFormula.CellRect(ACol, ARow);
      R.Left := R.Left + sgFormula.Left;
      R.Right := R.Right + sgFormula.Left;
      R.Top := R.Top + sgFormula.Top;
      R.Bottom := R.Bottom + sgFormula.Top;
      with cbAtt do
      begin
        Left := R.Left + 2 ;
        Top := R.Top+ 2 ;
        Width := (R.Right) - R.Left;
        Height := (R.Bottom ) - R.Top;
        Visible := True;
        SetFocus;
      end;
    end;
    CanSelect := True;
  end;

end;

//----------------------------------------------------------------------------//

procedure TFTotalViews.FormCreate(Sender: TObject);
begin
  TranslateComponent(self);
  if m_setType = 'wkc' then
    SetWKCPanel
  else if m_SetType = 'group' then
    SetGrpPanel
  else if m_setType = 'formula' then
    SetFormulaPanel
  else if m_setType = 'view' then
    SetViewPanel;
end;

//----------------------------------------------------------------------------//

procedure TFTotalViews.FormShow(Sender: TObject);
begin
  ReShape(Self);
end;

procedure TFTotalViews.Movedown1Click(Sender: TObject);
var i, y : Integer;
begin
   for i := sgFormula.RowCount -2 downto sgFormula.Row  do
   begin
      for y := 0 to sgFormula.ColCount -1 do
        if y = 0  then
          continue
        else
          sgFormula.Cells[y , i+1] := sgFormula.Cells[y , i];
   end;

   for y := 0 to sgFormula.ColCount -1 do
   begin
    if (y = 0)  then
      continue
    else
    begin
      if (y = 2) then
        sgFormula.Cells[y , sgFormula.Row] := '0-NA'
      else
        sgFormula.Cells[y , sgFormula.Row] := '';
    end;
   end;

end;

//----------------------------------------------------------------------------//

procedure TFTotalViews.Save(SetType, setName: string);
var qry:       TMqmQuery;
  tbInfo:    ^TTblInfo;
  i, y : Integer;
  tv : PTTotalsView;
begin

  qry := CreateQuery(Main_DB);
  Qry.Transaction := CreateTransaction(Main_DB);
  Qry.Transaction.StartTransaction;

  if SetType = '' then  //////////////Totalviews /////////////////
  begin
    tbInfo := @tblInfo[tbl_TotalsView];

  {  qry.SQL.Clear;
    qry.SQL.Add('delete from ' +  tbInfo.GetTableName);
    qry.SQL.Add('where ' + CreateFld(tbInfo.pfx, fli_OwnerWorkStation) + ' = ''' + IniAppGlobals.WkstCode + '''');
    //qry.SQL.Add(' and ' + CreateFld(tbInfo.pfx, fli_TotalCode) + ' = ''' + setName + ''''); ????
    qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
    qry.ExecSQL;
  //  Qry.Transaction.Commit;
    qry.Close;    }

    qry.SQL.Clear;
    qry.SQL.Add('insert into ' + tbInfo.GetTableName    + '(');
    qry.SQL.Add(CreateFld(tbInfo.pfx, fli_IDENTIFIER)      + ',');
    qry.SQL.Add(CreateFld(tbInfo.pfx, fli_TotalCode)     + ',');
    qry.SQL.Add(CreateFld(tbInfo.pfx, fli_OwnerWorkStation)+ ')');
    qry.SQL.Add(' values (');
    qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_IDENTIFIER)     + ',');
    qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_TotalCode)    + ',');
    qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_OwnerWorkStation) );
    qry.SQL.Add(')');

    qry.ParamByName(CreateFld(tbInfo.pfx, fli_IDENTIFIER)).AsInteger      := StrToInt(IniAppGlobals.Identifier);
    qry.ParamByName(CreateFld(tbInfo.pfx, fli_TotalCode)).AsString        := setName;
    qry.ParamByName(CreateFld(tbInfo.pfx, fli_OwnerWorkStation)).AsString := IniAppGlobals.WkstCode;
    qry.ExecSQL;

  end else
  begin

    i := 0;
    if SetType = 'wkc' then
    begin
      tbInfo := @tblInfo[tbl_TotalsViewWorkCenters];
      qry.SQL.Clear;
      qry.SQL.Add('delete from ' +  tbInfo.GetTableName);
      qry.SQL.Add('where ' + CreateFld(tbInfo.pfx, fli_TotalCode) + ' = ''' + setName + '''');
      qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
      qry.ExecSQL;
      qry.Close;

      qry.SQL.Clear;
      qry.SQL.Add('insert into ' + tbInfo.GetTableName    + '(');
      qry.SQL.Add(CreateFld(tbInfo.pfx, fli_IDENTIFIER)      + ',');
      qry.SQL.Add(CreateFld(tbInfo.pfx, fli_TotalCode)     + ',');
      qry.SQL.Add(CreateFld(tbInfo.pfx, fli_wkCtrCode)+ ')');
      qry.SQL.Add(' values (');
      qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_IDENTIFIER)     + ',');
      qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_TotalCode)    + ',');
      qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_wkCtrCode) );
      qry.SQL.Add(')');

      for i := 0 to m_TTotalsView.Wkc_list.Count -1 do
      begin
        qry.ParamByName(CreateFld(tbInfo.pfx, fli_IDENTIFIER)).AsInteger      := StrToInt(IniAppGlobals.Identifier);
        qry.ParamByName(CreateFld(tbInfo.pfx, fli_TotalCode)).AsString        := setName;
        qry.ParamByName(CreateFld(tbInfo.pfx, fli_wkCtrCode)).AsString        := TMqmWrkCtr(m_TTotalsView.Wkc_list[i]).p_WrkCtrCode;
        qry.ExecSQL;
      end;

    end else if SetType = 'group' then
    begin

      tbInfo := @tblInfo[tbl_TotalsViewGroupByColumns];
      qry.Close;
      qry.SQL.Clear;
      qry.SQL.Add('delete from ' +  tbInfo.GetTableName);
      qry.SQL.Add('where ' + CreateFld(tbInfo.pfx, fli_TotalCode) + ' = ''' + setName + '''');
      qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
      qry.ExecSQL;
      qry.Close;

      qry.SQL.Clear;
      qry.SQL.Add('insert into ' + tbInfo.GetTableName    + '(');
      qry.SQL.Add(CreateFld(tbInfo.pfx, fli_IDENTIFIER)      + ',');
      qry.SQL.Add(CreateFld(tbInfo.pfx, fli_TotalCode)     + ',');
      qry.SQL.Add(CreateFld(tbInfo.pfx, fli_PropertyCode)     + ',');
      qry.SQL.Add(CreateFld(tbInfo.pfx, fli_Sequence)+ ')');
      qry.SQL.Add(' values (');
      qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_IDENTIFIER)     + ',');
      qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_TotalCode)    + ',');
      qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_PropertyCode)    + ',');
      qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_Sequence) );
      qry.SQL.Add(')');

      i := 0;
      for i := 0 to m_TTotalsView.Group_list.Count -1 do
      begin
        qry.ParamByName(CreateFld(tbInfo.pfx, fli_IDENTIFIER)).AsInteger   := StrToInt(IniAppGlobals.Identifier);
        qry.ParamByName(CreateFld(tbInfo.pfx, fli_TotalCode)).AsString     := setName;
        qry.ParamByName(CreateFld(tbInfo.pfx, fli_PropertyCode)).AsString  := GetPropCodeFromID(PTTotalsViewGroup(m_TTotalsView.Group_list[i]).PropID);
        qry.ParamByName(CreateFld(tbInfo.pfx, fli_Sequence)).asInteger := PTTotalsViewGroup(m_TTotalsView.Group_list[i]).Sequence;
        qry.ExecSQL;
      end;

    end else if SetType = 'formula' then
    begin

      tbInfo := @tblInfo[tbl_TotalsViewContent];
      qry.Close;
      qry.SQL.Clear;
      qry.SQL.Add('delete from ' +  tbInfo.GetTableName);
      qry.SQL.Add('where ' + CreateFld(tbInfo.pfx, fli_TotalCode) + ' = ''' + setName + '''');
      qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_Identifier)));
      qry.ExecSQL;

      qry.Close;
      qry.SQL.Clear;
      qry.SQL.Add('insert into ' + tbInfo.GetTableName      + '(');
      qry.SQL.Add(CreateFld(tbInfo.pfx, fli_IDENTIFIER)     + ',');
      qry.SQL.Add(CreateFld(tbInfo.pfx, fli_TotalCode)      + ',');
      qry.SQL.Add(CreateFld(tbInfo.pfx, fli_ArgumentNumber) + ',');
      qry.SQL.Add(CreateFld(tbInfo.pfx, fli_LDescr)         + ',');
      qry.SQL.Add(CreateFld(tbInfo.pfx, fli_PropertyCode)   + ',');
      qry.SQL.Add(CreateFld(tbInfo.pfx, fli_Attribute)      + ',');
      qry.SQL.Add(CreateFld(tbInfo.pfx, fli_Formula)        + ',');
      qry.SQL.Add(CreateFld(tbInfo.pfx, fli_NumberofDecimals)+ ')');
      qry.SQL.Add(' values (');
      qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_IDENTIFIER)   + ',');
      qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_TotalCode)    + ',');
      qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_ArgumentNumber)+ ',');
      qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_LDescr)        + ',');
      qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_PropertyCode)  + ',');
      qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_Attribute)     + ',');
      qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_Formula)       + ',');
      qry.SQL.Add(':' + CreateFld(tbInfo.pfx, fli_NumberofDecimals) );
      qry.SQL.Add(')');

      i := 0;
      for i := 0 to m_TTotalsView.Formula_list.Count -1 do
      begin
        qry.ParamByName(CreateFld(tbInfo.pfx, fli_IDENTIFIER)).AsInteger    := StrToInt(IniAppGlobals.Identifier);
        qry.ParamByName(CreateFld(tbInfo.pfx, fli_TotalCode)).AsString      := setName;
        qry.ParamByName(CreateFld(tbInfo.pfx, fli_ArgumentNumber)).asInteger:= PTTotalsViewFormula(m_TTotalsView.Formula_list[i]).Argument;
        qry.ParamByName(CreateFld(tbInfo.pfx, fli_LDescr)).AsString         := PTTotalsViewFormula(m_TTotalsView.Formula_list[i]).Description;

        if PTTotalsViewFormula(m_TTotalsView.Formula_list[i]).PropID = nil then
          qry.ParamByName(CreateFld(tbInfo.pfx, fli_PropertyCode)).AsString := ''
        else
          qry.ParamByName(CreateFld(tbInfo.pfx, fli_PropertyCode)).AsString   := GetPropCodeFromID(PTTotalsViewFormula(m_TTotalsView.Formula_list[i]).PropID);

        qry.ParamByName(CreateFld(tbInfo.pfx, fli_Attribute)).asInteger     := PTTotalsViewFormula(m_TTotalsView.Formula_list[i]).Attribute;
        qry.ParamByName(CreateFld(tbInfo.pfx, fli_Formula)).AsString        := PTTotalsViewFormula(m_TTotalsView.Formula_list[i]).Formula;
        qry.ParamByName(CreateFld(tbInfo.pfx, fli_NumberofDecimals)).AsString := PTTotalsViewFormula(m_TTotalsView.Formula_list[i]).Decimals;
        qry.ExecSQL;
      end;

    end;
  end;

  Qry.Transaction.Commit;
  qry.Close;
  qry.Free;


end;

//----------------------------------------------------------------------------//

procedure ClearTotalViewList;
var
  I : Integer;
  TV : PTTotalsView;
begin
  for i := 0 to M_TotalViews_List.Count - 1 do
  begin
    tv := PTTotalsView(M_TotalViews_List[I]);
    tv.Wkc_list.Free;
    tv.Group_list.Free;
    tv.Formula_list.Free;
  end;
  M_TotalViews_List.Clear;
end;

//----------------------------------------------------------------------------//

procedure BuildTotalViewStructure_FromDB;
var
  TV : PTTotalsView;
  qry, qryWkc, QryGrp, qryFormula:       TMqmQuery;
  tbInfo, tbWkc, tbGrp, tbFormula:    ^TTblInfo;
  i, y : Integer;
  wkc : string;
  tvGrp : PTTotalsViewGroup;
  tvFor : PTTotalsViewFormula;
  PropCode : string;
  PropID : TPropID;
begin
  // select from TOTALSVIEW left join to all other 3 tables and start to loop all data to structure
  // In case we do not find all expected tables definition (we will know only during the loop) ,
  // in that case we ignore this code (dispose the TV) , and go to the next code

  tbInfo := @tblInfo[tbl_TotalsView];
  tbWkc  := @tblInfo[tbl_TotalsViewWorkCenters];
  tbGrp  := @tblInfo[tbl_TotalsViewGroupByColumns];
  tbFormula  := @tblInfo[tbl_TotalsViewContent];
  qry    := CreateQuery(Main_DB);
  qryWkc := CreateQuery(Main_DB);
  qryGrp := CreateQuery(Main_DB);
  qryFormula := CreateQuery(Main_DB);

  qry.SQL.text := 'Select tv.'+ CreateFld(tbInfo.pfx, fli_TotalCode) +', tv.'+CreateFld(tbInfo.pfx, fli_OwnerWorkStation)
    +' from ' + tbInfo.GetTableName + ' tv '
    //+ ' left join ' + tbGrp.GetTableName +' tvgrp on tv.' CreateFld(tbInfo.pfx, fli_TotalCode) + ' = tvgrp.' +CreateFld(tbGrp.pfx, fli_TotalCode)
    + ' where tv.' + CreateFld(tbInfo.pfx, fli_IDENTIFIER) + ' = ' + IniAppGlobals.Identifier
    + ' and tv.'+ CreateFld(tbInfo.pfx,fli_OwnerWorkStation) + ' = ' + QuotedStr(IniAppGlobals.WkstCode);
  qry.Open;

  while not qry.eof do
  begin
    new(TV);
    TV.set_name := qry.FieldByName(CreateFld(tbInfo.pfx, fli_TotalCode)).AsString;
    TV.Workstation := qry.FieldByName(CreateFld(tbInfo.pfx, fli_OwnerWorkStation)).AsString;

    /////////////wrkc
    Qrywkc.Close;
    qryWkc.SQL.Text := 'select ' +CreateFld(tbWkc.pfx, fli_wkCtrCode)
      + ' from ' + tbWkc.GetTableName
      + ' where ' + CreateFld(tbWkc.pfx, fli_TotalCode) + ' = ' + QuotedStr(TV.set_name)
      + ' and '  + CreateFld(tbWkc.pfx, fli_IDENTIFIER) + ' = ' + IniAppGlobals.Identifier;
    qryWkc.Open;
    TV.Wkc_list := TList.Create;
    TV.Group_list := TList.Create;
    TV.Formula_list := TList.Create;

    while not QryWkc.eof do
    begin
      wkc := qryWkc.FieldByName(CreateFld(tbWkc.pfx, fli_wkCtrCode)).asString;
      tv.Wkc_list.add(p_pl.FindWrkCtrByCode(wkc));
      QryWkc.Next;
    end;

    ////////////////////group
    qryGrp.Close;
    qryGrp.SQL.Text := 'select ' +CreateFld(tbGrp.pfx, fli_PropertyCode) +' ,' +CreateFld(tbGrp.pfx, fli_Sequence)
      + ' from ' + tbGrp.GetTableName
      + ' where ' + CreateFld(tbGrp.pfx, fli_TotalCode) + ' = ' + QuotedStr(TV.set_name)
      + ' and '  + CreateFld(tbGrp.pfx, fli_IDENTIFIER) + ' = ' + IniAppGlobals.Identifier;
    qryGrp.Open;


    while not qryGrp.eof do
    begin
      PropID := GetIdFromCode(qryGrp.FieldByName(CreateFld(tbGrp.pfx, fli_PropertyCode)).asString);

      New(tvGrp);
      tvGrp.PropID := PropID;
      tvGrp.Sequence := qryGrp.FieldByName(CreateFld(tbGrp.pfx, fli_Sequence)).asInteger;
      tv.Group_list.add(tvGrp);
      qryGrp.Next;
    end;

    ///////////////////formula
    qryFormula.Close;
    qryFormula.SQL.Text := 'select *' //+CreateFld(tbFormula.pfx, fli_PropertyCode) +' ,' +CreateFld(tbFormula.pfx, fli_Sequence)
      + ' from ' + tbFormula.GetTableName
      + ' where ' + CreateFld(tbFormula.pfx, fli_TotalCode) + ' = ' + QuotedStr(TV.set_name)
      + ' and '  + CreateFld(tbFormula.pfx, fli_IDENTIFIER) + ' = ' + IniAppGlobals.Identifier;
    qryFormula.Open;


    while not qryFormula.eof do
    begin
      PropID := GetIdFromCode(qryFormula.FieldByName(CreateFld(tbFormula.pfx, fli_PropertyCode)).asString);

      New(tvFor);
      tvFor.Argument    := qryFormula.FieldByName(CreateFld(tbFormula.pfx, fli_ArgumentNumber)).asInteger;
      tvFor.PropID      := PropID;
      tvFor.Attribute   := qryFormula.FieldByName(CreateFld(tbFormula.pfx, fli_Attribute)).asInteger;
      tvFor.Formula     := qryFormula.FieldByName(CreateFld(tbFormula.pfx, fli_Formula)).asString;
      tvFor.Description := qryFormula.FieldByName(CreateFld(tbFormula.pfx, fli_LDescr)).asString;
      tvFor.Decimals    := qryFormula.FieldByName(CreateFld(tbFormula.pfx, fli_NumberOfDecimals)).asString;
      tv.Formula_list.add(tvFor);
      qryFormula.Next;
    end;

    M_TotalViews_List.Add(TV);
    qry.Next;
  end;

  qry.Close;
  Qry.Free;
  qryWkc.Close;
  QryWkc.Free;
  qryGrp.Close;
  QryGrp.Free;
  qryFormula.Close;
  qryFormula.Free;
end;

//----------------------------------------------------------------------------//

function GetTotalViews_List : TList;
begin
  result := M_TotalViews_List
end;

function GetCodeViewName(I : integer) : string;
begin
  result := PTTotalsView(M_TotalViews_List[I]).set_name
end;

//----------------------------------------------------------------------------//

initialization
  M_TotalViews_List := TList.Create;

finalization
  ClearTotalViewList;
  M_TotalViews_List.Free;


end.
