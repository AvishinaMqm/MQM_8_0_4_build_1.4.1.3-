unit FMCustomizeDatesGap;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, UMCompat,UMSchedContFunc, Vcl.ExtCtrls, UReShape,
  cxGraphics, dxUIAClasses, cxLookAndFeels, cxLookAndFeelPainters, Vcl.Menus,
  cxButtons;

type
  TDatesCustomizeGap = class(TForm)
    CBField1: TComboBox;
    Label1: TLabel;
    Label4: TLabel;
    CBPropType: TComboBox;
    Label2: TLabel;
    CBTimeType: TComboBox;
    Label3: TLabel;
    CBABSVal: TComboBox;
    Label5: TLabel;
    CBField2: TComboBox;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    BtnOk: TcxButton;
    BtnAbo: TcxButton;
    Button1: TcxButton;
    Button2: TcxButton;
    Button3: TcxButton;
    procedure BtnOkClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure BtnAboClick(Sender: TObject);
  private
    m_DateGapColumn : Integer;
  public
    constructor CreateCustomizeDateGap(AOwner : Tcomponent; DateGapColumn : Integer);
  end;

  procedure LoadCustomDateGapColumnInfo;
  function CustomDateGapInfoEnabled(Customized_column_Num : Integer; var DateColumnId  : CBinColId; var PropId : TPropId;
                                   var TimeAdd : double; var BinDateColumn : CBinColId; var IsAbs : boolean; var IsDur : boolean) : boolean;

implementation

uses UMbinGrid, FMbin, DMsrvPc, UMTblDesc, UMglobal, UMCommon, gnugettext;

{$R *.dfm}

type

  TDatesCustomizeGapRec = record
    DateColumNumber : Integer;
    SatartingDateColumn : CBinColId;
//    OperationType : string;
    PropIdDateColumn : TPropID;
    BinDateColumn      : CBinColId;
    TimeType           : String;
    ABSoluteValue      : boolean;
    enable             : boolean;
  end;

var
  DatesCustomize2Rec : TDatesCustomizeGapRec;
  DatesCustomize3Rec : TDatesCustomizeGapRec;
  CurrentDatesCustomizeRec : TDatesCustomizeGapRec;

//----------------------------------------------------------------------------//

procedure TDatesCustomizeGap.BtnOkClick(Sender: TObject);
var
  qry: TMqmQuery;
  tbInfo : ^TTblInfo;
begin

  if (CBField1.ItemIndex = -1) then
  begin
    Showmessage(_('Please select date column'));
    exit
  end;

  if (CBPropType.ItemIndex = -1) and  (CBField2.ItemIndex = -1) then
  begin
    Showmessage(_(' Please select a date Property column OR a Date column ... '));
    exit
  end;

  tbInfo := @tblInfo[btl_CustomizedDateGap];
  qry := CreateQuery(Cfg_DB);
  Qry.Transaction := CreateTransaction(Cfg_DB);
  Qry.Transaction.StartTransaction;

  with qry.sql do
  begin
    Clear;
    Add('Delete from ' + tbInfo.GetTablename);
    Add(' Where ');
    Add(CreateFld(tbInfo.pfx, fli_wkstCode) + '=''' + IniAppGlobals.WkstCode + '''');
    Add( ' and ' + CreateFld(tbInfo.pfx, fli_ColumnNum) + '=' + IntToStr(m_DateGapColumn));
    Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_identifier)));
    qry.ExecSQL;

    Clear;
    Add('insert into ' + tbInfo.GetTablename + '(');
    Add(CreateFld(tbInfo.pfx,fli_identifier) + ',');
    Add(CreateFld(tbInfo.pfx,fli_wkstCode) + ',');
    Add(CreateFld(tbInfo.pfx,fli_ColumnNum) + ',');
    Add(CreateFld(tbInfo.pfx,fli_StartingDateColumn) + ',');
    //Add(CreateFld(tbInfo.pfx,fli_TypOprtion) + ',');
    Add(CreateFld(tbInfo.pfx,fli_PropertyDateColumn) + ',');
    Add(CreateFld(tbInfo.pfx,fli_BinDateColumn) + ',');
    Add(CreateFld(tbInfo.pfx,fli_ABSolute_Value) + ',');
    Add(CreateFld(tbInfo.pfx,fli_TimeType) + ')');

    qry.SQL.Add(' values (');
    qry.SQL.Add(':' + CreateFld(tbInfo.pfx,fli_identifier) + ',');
    qry.SQL.Add(':' + CreateFld(tbInfo.pfx,fli_wkstCode) + ',');
    qry.SQL.Add(':' + CreateFld(tbInfo.pfx,fli_ColumnNum) + ',');
    qry.SQL.Add(':' + CreateFld(tbInfo.pfx,fli_StartingDateColumn) + ',');
    //qry.SQL.Add(':' + CreateFld(tbInfo.pfx,fli_TypOprtion) + ',');
    qry.SQL.Add(':' + CreateFld(tbInfo.pfx,fli_PropertyDateColumn) + ',');
    qry.SQL.Add(':' + CreateFld(tbInfo.pfx,fli_BinDateColumn) + ',');
    qry.SQL.Add(':' + CreateFld(tbInfo.pfx,fli_ABSolute_Value) + ',');
    qry.SQL.Add(':' + CreateFld(tbInfo.pfx,fli_TimeType));
    qry.SQL.Add(')');

    if (CBField1.ItemIndex <> -1) then
    begin
      qry.ParamByName(CreateFld(tbInfo.pfx,fli_identifier)).AsString := IniAppGlobals.Identifier;
      qry.ParamByName(CreateFld(tbInfo.pfx,fli_wkstCode)).AsString := IniAppGlobals.WkstCode;
      qry.ParamByName(CreateFld(tbInfo.pfx,fli_ColumnNum)).AsInteger := m_DateGapColumn;
      qry.ParamByName(CreateFld(tbInfo.pfx,fli_StartingDateColumn)).AsInteger := CBField1.ItemIndex;

      if CBField1.ItemIndex = 0 then
         CurrentDatesCustomizeRec.SatartingDateColumn := CSC_LowStartTimeLimit
      else if CBField1.ItemIndex = 1 then
         CurrentDatesCustomizeRec.SatartingDateColumn := CSC_ProdDlvDate
      else if CBField1.ItemIndex = 2 then
         CurrentDatesCustomizeRec.SatartingDateColumn := CSC_MatArrivalDate
      else if CBField1.ItemIndex = 3 then
         CurrentDatesCustomizeRec.SatartingDateColumn := CSC_LowStartDate
      else if CBField1.ItemIndex = 4 then
         CurrentDatesCustomizeRec.SatartingDateColumn := CSC_HighEndLimit
      else if CBField1.ItemIndex = 5 then
         CurrentDatesCustomizeRec.SatartingDateColumn := CSC_SchedStart
      else if CBField1.ItemIndex = 6 then
         CurrentDatesCustomizeRec.SatartingDateColumn := CSC_SchedEnd
      else if CBField1.ItemIndex = 7 then
         CurrentDatesCustomizeRec.SatartingDateColumn := CSC_ProgStart
      else if CBField1.ItemIndex = 8 then
         CurrentDatesCustomizeRec.SatartingDateColumn := CSC_ProgEnd
      else if CBField1.ItemIndex = 9 then
         CurrentDatesCustomizeRec.SatartingDateColumn := CSC_PrvHighestDate
      else if CBField1.ItemIndex = 10 then
         CurrentDatesCustomizeRec.SatartingDateColumn := CSC_NxtLowestDate
      else if CBField1.ItemIndex = 11 then
         CurrentDatesCustomizeRec.SatartingDateColumn := CSC_ProgStart_Ignored
      else if CBField1.ItemIndex = 12 then
         CurrentDatesCustomizeRec.SatartingDateColumn := CSC_ProgEnd_Ignored
      else
         CurrentDatesCustomizeRec.SatartingDateColumn := CSC_Non;

      if CBField2.ItemIndex > -1 then
        qry.ParamByName(CreateFld(tbInfo.pfx,fli_BinDateColumn)).AsInteger := CBField2.ItemIndex
      else
        qry.ParamByName(CreateFld(tbInfo.pfx,fli_BinDateColumn)).AsInteger := -1;

      if CBField2.ItemIndex = 0 then
         CurrentDatesCustomizeRec.BinDateColumn := CSC_LowStartTimeLimit
      else if CBField2.ItemIndex = 1 then
         CurrentDatesCustomizeRec.BinDateColumn := CSC_ProdDlvDate
      else if CBField2.ItemIndex = 2 then
         CurrentDatesCustomizeRec.BinDateColumn := CSC_MatArrivalDate
      else if CBField2.ItemIndex = 3 then
         CurrentDatesCustomizeRec.BinDateColumn := CSC_LowStartDate
      else if CBField2.ItemIndex = 4 then
         CurrentDatesCustomizeRec.BinDateColumn := CSC_HighEndLimit
      else if CBField2.ItemIndex = 5 then
         CurrentDatesCustomizeRec.BinDateColumn := CSC_SchedStart
      else if CBField2.ItemIndex = 6 then
         CurrentDatesCustomizeRec.BinDateColumn := CSC_SchedEnd
      else if CBField2.ItemIndex = 7 then
         CurrentDatesCustomizeRec.BinDateColumn := CSC_ProgStart
      else if CBField2.ItemIndex = 8 then
         CurrentDatesCustomizeRec.BinDateColumn := CSC_ProgEnd
      else if CBField2.ItemIndex = 9 then
         CurrentDatesCustomizeRec.BinDateColumn := CSC_PrvHighestDate
      else if CBField2.ItemIndex = 10 then
         CurrentDatesCustomizeRec.BinDateColumn := CSC_NxtLowestDate
      else if CBField2.ItemIndex = 11 then
         CurrentDatesCustomizeRec.BinDateColumn := CSC_ProgStart_Ignored
      else if CBField2.ItemIndex = 12 then
         CurrentDatesCustomizeRec.BinDateColumn := CSC_ProgEnd_Ignored
      else
         CurrentDatesCustomizeRec.BinDateColumn := CSC_Non;

      if CBPropType.ItemIndex > -1 then
        qry.ParamByName(CreateFld(tbInfo.pfx,fli_PropertyDateColumn)).AsString := GetPropCodeFromID(CBPropType.Items.Objects[CBPropType.ItemIndex])
      else
        qry.ParamByName(CreateFld(tbInfo.pfx,fli_PropertyDateColumn)).AsString := '';

      if CBPropType.ItemIndex = -1 then
        CurrentDatesCustomizeRec.PropIdDateColumn := nil
      else
        CurrentDatesCustomizeRec.PropIdDateColumn := CBPropType.Items.Objects[CBPropType.ItemIndex];

      if CBTimeType.ItemIndex = 0 then
      begin
        qry.ParamByName(CreateFld(tbInfo.pfx,fli_TimeType)).AsString := '1';
        CurrentDatesCustomizeRec.TimeType := 'Minutes'
      end
      else if CBTimeType.ItemIndex = 1 then
      begin
        qry.ParamByName(CreateFld(tbInfo.pfx,fli_TimeType)).AsString := '2';
        CurrentDatesCustomizeRec.TimeType := 'Hours'
      end
      else if CBTimeType.ItemIndex = 2 then
      begin
        qry.ParamByName(CreateFld(tbInfo.pfx,fli_TimeType)).AsString := '3';
        CurrentDatesCustomizeRec.TimeType := 'Days';
      end
      else if CBTimeType.ItemIndex = 3 then
      begin
        qry.ParamByName(CreateFld(tbInfo.pfx,fli_TimeType)).AsString := '4';
        CurrentDatesCustomizeRec.TimeType := 'Dur';
      end;

      if CBABSVal.ItemIndex = 0 then
      begin
        qry.ParamByName(CreateFld(tbInfo.pfx,fli_ABSolute_Value)).AsString := '1';
        CurrentDatesCustomizeRec.ABSoluteValue := true
      end
      else if CBABSVal.ItemIndex = 1 then
      begin
        qry.ParamByName(CreateFld(tbInfo.pfx,fli_ABSolute_Value)).AsString := '0';
        CurrentDatesCustomizeRec.ABSoluteValue := false;
      end;

      qry.ExecSQL;
    end;
  end;

  CurrentDatesCustomizeRec.enable := true;

  if m_DateGapColumn = 2 then
    DatesCustomize2Rec := CurrentDatesCustomizeRec
  else
    DatesCustomize3Rec := CurrentDatesCustomizeRec;

  if assigned(FBin) then FBin.RefreshGrid;
  Qry.Transaction.Commit;
  qry.Free;
  close;
end;

//----------------------------------------------------------------------------//

procedure TDatesCustomizeGap.Button1Click(Sender: TObject);
begin
  CBField1.ItemIndex := -1;
  CurrentDatesCustomizeRec.SatartingDateColumn := CSC_Non
end;

//----------------------------------------------------------------------------//

procedure TDatesCustomizeGap.Button2Click(Sender: TObject);
begin
  CBField2.ItemIndex := -1;
  CurrentDatesCustomizeRec.BinDateColumn := CSC_Non
end;

procedure TDatesCustomizeGap.Button3Click(Sender: TObject);
begin
  CBPropType.ItemIndex := -1;
  CurrentDatesCustomizeRec.PropIdDateColumn := nil;
end;

//----------------------------------------------------------------------------//

constructor TDatesCustomizeGap.CreateCustomizeDateGap(AOwner: Tcomponent;
  DateGapColumn: Integer);
begin
  inherited create(AOwner);
  m_DateGapColumn := DateGapColumn;
end;

//----------------------------------------------------------------------------//

procedure TDatesCustomizeGap.FormCreate(Sender: TObject);
var
  binGrid : TBinDrawGrid;
  I : Integer;
  PId : TPropID;
  Pos : Integer;
  Test : string;
begin
  if m_DateGapColumn = 2 then
    CurrentDatesCustomizeRec := DatesCustomize2Rec
  else if m_DateGapColumn = 3 then
    CurrentDatesCustomizeRec := DatesCustomize3Rec;

  binGrid := FBin.GetActiveView.GetBinGrid;

  CBTimeType.Items.Add(_('Minutes'));
  CBTimeType.Items.Add(_('Hours'));
  CBTimeType.Items.Add(_('Days'));
  CBTimeType.Items.Add(_('Duration'));
  CBTimeType.ItemIndex := 0;

  CBABSVal.Items.Add(_('Yes'));
  CBABSVal.Items.Add(_('No'));
  CBABSVal.ItemIndex := 0;

  for I := low(binGrid.BinColumnSet) to high(binGrid.BinColumnSet) do
  begin
    if (binGrid.BinColumnSet[i].Field = CSC_LowStartTimeLimit) or
       (binGrid.BinColumnSet[i].Field = CSC_ProdDlvDate) or
       (binGrid.BinColumnSet[i].Field = CSC_MatArrivalDate) or
       (binGrid.BinColumnSet[i].Field = CSC_LowStartDate) or
       (binGrid.BinColumnSet[i].Field = CSC_HighEndLimit) or
       (binGrid.BinColumnSet[i].Field = CSC_SchedStart) or
       (binGrid.BinColumnSet[i].Field = CSC_SchedEnd) or
       (binGrid.BinColumnSet[i].Field = CSC_ProgStart) or
       (binGrid.BinColumnSet[i].Field = CSC_ProgEnd) or
       (binGrid.BinColumnSet[i].Field = CSC_PrvHighestDate) or
       (binGrid.BinColumnSet[i].Field = CSC_NxtLowestDate) then
       begin
         CBField1.Items.Add(binGrid.BinColumnSet[i].Title);
         CBField2.Items.Add(binGrid.BinColumnSet[i].Title);
       end;
  end;

  CBField1.Items.Add('Progress start');
  CBField1.Items.Add('Progress end');

  CBField2.Items.Add('Progress start');
  CBField2.Items.Add('Progress end');

  for I := 0 to GetPropertyCount - 1 do
  begin
    pId := GetPropFromPos(I);
   // if IsPropAlpha(pId) then continue;
    if not IsDateProp(pId) then continue;

    test := GetPropCodeFromID(Pid);

  //  if (GetLength(pId) <> 12) then continue;
    Pos := CBPropType.Items.Add(GetPropDescr(pId));
    CBPropType.Items.Objects[pos] := pId;
  end;

  if CurrentDatesCustomizeRec.TimeType <> '' then
  begin
    if CurrentDatesCustomizeRec.TimeType = 'Minutes' then
      CBTimeType.ItemIndex := 0
    else if CurrentDatesCustomizeRec.TimeType = 'Hours' then
      CBTimeType.ItemIndex := 1
    else if CurrentDatesCustomizeRec.TimeType = 'Days' then
      CBTimeType.ItemIndex := 2
    else if CurrentDatesCustomizeRec.TimeType = 'Dur' then
      CBTimeType.ItemIndex := 3
    else
      CBTimeType.ItemIndex := 0;
  end;

  if (CurrentDatesCustomizeRec.PropIdDateColumn <> nil) then
  begin
    for I := 0 to CBPropType.Items.Count - 1 do
    begin
      if CurrentDatesCustomizeRec.PropIdDateColumn = CBPropType.Items.Objects[I] then
      begin
        CBPropType.ItemIndex := I;
        Break
      end;
    end;
  end;

  if CurrentDatesCustomizeRec.SatartingDateColumn <> CSC_Non then
  begin
    if CurrentDatesCustomizeRec.SatartingDateColumn = CSC_LowStartTimeLimit then
      CBField1.ItemIndex := 0
    else if CurrentDatesCustomizeRec.SatartingDateColumn = CSC_ProdDlvDate then
      CBField1.ItemIndex := 1
    else if CurrentDatesCustomizeRec.SatartingDateColumn = CSC_MatArrivalDate then
      CBField1.ItemIndex := 2
    else if CurrentDatesCustomizeRec.SatartingDateColumn = CSC_LowStartDate then
      CBField1.ItemIndex := 3
    else if CurrentDatesCustomizeRec.SatartingDateColumn = CSC_HighEndLimit then
      CBField1.ItemIndex := 4
    else if CurrentDatesCustomizeRec.SatartingDateColumn = CSC_SchedStart then
      CBField1.ItemIndex := 5
    else if CurrentDatesCustomizeRec.SatartingDateColumn = CSC_SchedEnd then
      CBField1.ItemIndex := 6
    else if CurrentDatesCustomizeRec.SatartingDateColumn = CSC_ProgStart then
      CBField1.ItemIndex := 7
    else if CurrentDatesCustomizeRec.SatartingDateColumn = CSC_ProgEnd then
      CBField1.ItemIndex := 8
    else if CurrentDatesCustomizeRec.SatartingDateColumn = CSC_PrvHighestDate then
      CBField1.ItemIndex := 9
    else if CurrentDatesCustomizeRec.SatartingDateColumn = CSC_NxtLowestDate then
      CBField1.ItemIndex := 10
    else if CurrentDatesCustomizeRec.SatartingDateColumn = CSC_ProgStart_Ignored then
      CBField1.ItemIndex := 11
    else if CurrentDatesCustomizeRec.SatartingDateColumn = CSC_ProgEnd_Ignored then
      CBField1.ItemIndex := 12

    else CBField1.ItemIndex := -1;
  end;

  if CurrentDatesCustomizeRec.BinDateColumn <> CSC_Non then
  begin
    if CurrentDatesCustomizeRec.BinDateColumn = CSC_LowStartTimeLimit then
      CBField2.ItemIndex := 0
    else if CurrentDatesCustomizeRec.BinDateColumn = CSC_ProdDlvDate then
      CBField2.ItemIndex := 1
    else if CurrentDatesCustomizeRec.BinDateColumn = CSC_MatArrivalDate then
      CBField2.ItemIndex := 2
    else if CurrentDatesCustomizeRec.BinDateColumn = CSC_LowStartDate then
      CBField2.ItemIndex := 3
    else if CurrentDatesCustomizeRec.BinDateColumn = CSC_HighEndLimit then
      CBField2.ItemIndex := 4
    else if CurrentDatesCustomizeRec.BinDateColumn = CSC_SchedStart then
      CBField2.ItemIndex := 5
    else if CurrentDatesCustomizeRec.BinDateColumn = CSC_SchedEnd then
      CBField2.ItemIndex := 6
    else if CurrentDatesCustomizeRec.BinDateColumn = CSC_ProgStart then
      CBField2.ItemIndex := 7
    else if CurrentDatesCustomizeRec.BinDateColumn = CSC_ProgEnd then
      CBField2.ItemIndex := 8
    else if CurrentDatesCustomizeRec.BinDateColumn = CSC_PrvHighestDate then
      CBField2.ItemIndex := 9
    else if CurrentDatesCustomizeRec.BinDateColumn = CSC_NxtLowestDate then
      CBField2.ItemIndex := 10
    else if CurrentDatesCustomizeRec.BinDateColumn = CSC_ProgStart_Ignored then
      CBField2.ItemIndex := 11
    else if CurrentDatesCustomizeRec.BinDateColumn = CSC_ProgEnd_Ignored then
      CBField2.ItemIndex := 12
    else CBField2.ItemIndex := -1;
  end;


  if CurrentDatesCustomizeRec.ABSoluteValue then
     CBABSVal.ItemIndex := 0
  else CBABSVal.ItemIndex := 1;

  ReShape(Self);
{  ReShape(btnOk);
  ReShape(btnAbo);
  ReShape(Button1);
  ReShape(Button2);
  ReShape(Button3);}

end;

procedure TDatesCustomizeGap.BtnAboClick(Sender: TObject);
begin
  ModalResult := mrAbort;
  Close;
end;

//----------------------------------------------------------------------------//

procedure LoadCustomDateGapColumnInfo;
var
  tbInfo : ^TTblInfo;
  P_Id   : TPropID;
  qry: TMqmQuery;
begin
  qry := CreateQuery(Cfg_DB);

  DatesCustomize2Rec.SatartingDateColumn := CSC_Non;
  DatesCustomize2Rec.BinDateColumn := CSC_Non;
  DatesCustomize2Rec.enable := false;

  with qry do
  begin
    tbInfo := @tblInfo[btl_customizedDateGap];
    SQL.Clear;
    SQL.Add('select * from ' + tbInfo.GetTableName);
    SQL.Add( ' where ');
    SQL.Add(CreateFld(tbInfo.pfx, fli_wkstCode) + '=''' + IniAppGlobals.WkstCode + '''');
    SQL.Add( ' and ' + CreateFld(tbInfo.pfx, fli_ColumnNum) + '=' + IntToStr(2));
    SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_identifier)));
    Open;
    if not EOF then
    begin
      Application.ProcessMessages;
      if FieldByName(CreateFld(tbinfo.pfx, fli_StartingDateColumn)).AsInteger <> -1 then
      begin
        if (FieldByName(CreateFld(tbinfo.pfx, fli_StartingDateColumn)).AsInteger = 0) then
          DatesCustomize2Rec.SatartingDateColumn := CSC_LowStartTimeLimit
        else if (FieldByName(CreateFld(tbinfo.pfx, fli_StartingDateColumn)).AsInteger = 1) then
          DatesCustomize2Rec.SatartingDateColumn := CSC_ProdDlvDate
        else if (FieldByName(CreateFld(tbinfo.pfx, fli_StartingDateColumn)).AsInteger = 2) then
          DatesCustomize2Rec.SatartingDateColumn := CSC_MatArrivalDate
        else if (FieldByName(CreateFld(tbinfo.pfx, fli_StartingDateColumn)).AsInteger = 3) then
          DatesCustomize2Rec.SatartingDateColumn := CSC_LowStartDate
        else if (FieldByName(CreateFld(tbinfo.pfx, fli_StartingDateColumn)).AsInteger = 4) then
          DatesCustomize2Rec.SatartingDateColumn := CSC_HighEndLimit
        else if (FieldByName(CreateFld(tbinfo.pfx, fli_StartingDateColumn)).AsInteger = 5) then
          DatesCustomize2Rec.SatartingDateColumn := CSC_SchedStart
        else if (FieldByName(CreateFld(tbinfo.pfx, fli_StartingDateColumn)).AsInteger = 6) then
          DatesCustomize2Rec.SatartingDateColumn := CSC_SchedEnd
        else if (FieldByName(CreateFld(tbinfo.pfx, fli_StartingDateColumn)).AsInteger = 7) then
          DatesCustomize2Rec.SatartingDateColumn := CSC_ProgStart
        else if (FieldByName(CreateFld(tbinfo.pfx, fli_StartingDateColumn)).AsInteger = 8) then
          DatesCustomize2Rec.SatartingDateColumn := CSC_ProgEnd
        else if (FieldByName(CreateFld(tbinfo.pfx, fli_StartingDateColumn)).AsInteger = 9) then
          DatesCustomize2Rec.SatartingDateColumn := CSC_PrvHighestDate
        else if (FieldByName(CreateFld(tbinfo.pfx, fli_StartingDateColumn)).AsInteger = 10) then
          DatesCustomize2Rec.SatartingDateColumn := CSC_NxtLowestDate
        else if (FieldByName(CreateFld(tbinfo.pfx, fli_StartingDateColumn)).AsInteger = 11) then
          DatesCustomize2Rec.SatartingDateColumn := CSC_ProgStart_Ignored
        else if (FieldByName(CreateFld(tbinfo.pfx, fli_StartingDateColumn)).AsInteger = 12) then
          DatesCustomize2Rec.SatartingDateColumn := CSC_ProgEnd_Ignored
      end;

      if FieldByName(CreateFld(tbinfo.pfx, fli_TimeType)).AsString = '1' then
        DatesCustomize2Rec.TimeType := 'Minutes'
      else if FieldByName(CreateFld(tbinfo.pfx, fli_TimeType)).AsString = '2' then
        DatesCustomize2Rec.TimeType := 'Hours'
      else if FieldByName(CreateFld(tbinfo.pfx, fli_TimeType)).AsString = '3' then
        DatesCustomize2Rec.TimeType := 'Days'
      else if FieldByName(CreateFld(tbinfo.pfx, fli_TimeType)).AsString = '4' then
        DatesCustomize2Rec.TimeType := 'Dur';

      P_Id := GetIdFromCode(fieldByName(CreateFld(tbInfo.pfx,fli_PropertyDateColumn)).AsString);
      if (P_Id <> nil) and (DatesCustomize2Rec.SatartingDateColumn <> CSC_Non) then
      begin
        DatesCustomize2Rec.PropIdDateColumn := P_Id;
        DatesCustomize2Rec.enable := true
      end
      else
        DatesCustomize2Rec.enable := false;

      if FieldByName(CreateFld(tbinfo.pfx, fli_BinDateColumn)).AsInteger <> -1 then
      begin
        if (FieldByName(CreateFld(tbinfo.pfx, fli_BinDateColumn)).AsInteger = 0) then
          DatesCustomize2Rec.BinDateColumn := CSC_LowStartTimeLimit
        else if (FieldByName(CreateFld(tbinfo.pfx, fli_BinDateColumn)).AsInteger = 1) then
          DatesCustomize2Rec.BinDateColumn := CSC_ProdDlvDate
        else if (FieldByName(CreateFld(tbinfo.pfx, fli_BinDateColumn)).AsInteger = 2) then
          DatesCustomize2Rec.BinDateColumn := CSC_MatArrivalDate
        else if (FieldByName(CreateFld(tbinfo.pfx, fli_BinDateColumn)).AsInteger = 3) then
          DatesCustomize2Rec.BinDateColumn := CSC_LowStartDate
        else if (FieldByName(CreateFld(tbinfo.pfx, fli_BinDateColumn)).AsInteger = 4) then
          DatesCustomize2Rec.BinDateColumn := CSC_HighEndLimit
        else if (FieldByName(CreateFld(tbinfo.pfx, fli_BinDateColumn)).AsInteger = 5) then
          DatesCustomize2Rec.BinDateColumn := CSC_SchedStart
        else if (FieldByName(CreateFld(tbinfo.pfx, fli_BinDateColumn)).AsInteger = 6) then
          DatesCustomize2Rec.BinDateColumn := CSC_SchedEnd
        else if (FieldByName(CreateFld(tbinfo.pfx, fli_BinDateColumn)).AsInteger = 7) then
          DatesCustomize2Rec.BinDateColumn := CSC_ProgStart
        else if (FieldByName(CreateFld(tbinfo.pfx, fli_BinDateColumn)).AsInteger = 8) then
          DatesCustomize2Rec.BinDateColumn := CSC_ProgEnd
        else if (FieldByName(CreateFld(tbinfo.pfx, fli_BinDateColumn)).AsInteger = 9) then
          DatesCustomize2Rec.BinDateColumn := CSC_PrvHighestDate
        else if (FieldByName(CreateFld(tbinfo.pfx, fli_BinDateColumn)).AsInteger = 10) then
          DatesCustomize2Rec.BinDateColumn := CSC_NxtLowestDate
        else if (FieldByName(CreateFld(tbinfo.pfx, fli_BinDateColumn)).AsInteger = 11) then
          DatesCustomize2Rec.BinDateColumn := CSC_ProgStart_Ignored
        else if (FieldByName(CreateFld(tbinfo.pfx, fli_BinDateColumn)).AsInteger = 12) then
          DatesCustomize2Rec.BinDateColumn := CSC_ProgEnd_Ignored

      end
      else DatesCustomize2Rec.BinDateColumn := CSC_Non;

      if DatesCustomize2Rec.BinDateColumn <> CSC_Non then
         DatesCustomize2Rec.enable := true;

      if FieldByName(CreateFld(tbinfo.pfx, fli_ABSolute_Value)).AsString = '1' then
        DatesCustomize2Rec.ABSoluteValue  := true
      else
        DatesCustomize2Rec.ABSoluteValue  := false;

    end;

    SQL.Clear;
    SQL.Add('select * from ' + tbInfo.GetTableName);
    SQL.Add( ' where ');
    SQL.Add(CreateFld(tbInfo.pfx, fli_wkstCode) + '=''' + IniAppGlobals.WkstCode + '''');
    SQL.Add( ' and ' + CreateFld(tbInfo.pfx, fli_ColumnNum) + '=' + IntToStr(3));
    SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_identifier)));
    Open;
    if not EOF then
    begin
      if FieldByName(CreateFld(tbinfo.pfx, fli_StartingDateColumn)).AsInteger <> -1 then
      begin
        if (FieldByName(CreateFld(tbinfo.pfx, fli_StartingDateColumn)).AsInteger = 0) then
          DatesCustomize3Rec.SatartingDateColumn := CSC_LowStartTimeLimit
        else if (FieldByName(CreateFld(tbinfo.pfx, fli_StartingDateColumn)).AsInteger = 1) then
          DatesCustomize3Rec.SatartingDateColumn := CSC_ProdDlvDate
        else if (FieldByName(CreateFld(tbinfo.pfx, fli_StartingDateColumn)).AsInteger = 2) then
          DatesCustomize3Rec.SatartingDateColumn := CSC_MatArrivalDate
        else if (FieldByName(CreateFld(tbinfo.pfx, fli_StartingDateColumn)).AsInteger = 3) then
          DatesCustomize3Rec.SatartingDateColumn := CSC_LowStartDate
        else if (FieldByName(CreateFld(tbinfo.pfx, fli_StartingDateColumn)).AsInteger = 4) then
          DatesCustomize3Rec.SatartingDateColumn := CSC_HighEndLimit
        else if (FieldByName(CreateFld(tbinfo.pfx, fli_StartingDateColumn)).AsInteger = 5) then
          DatesCustomize3Rec.SatartingDateColumn := CSC_SchedStart
        else if (FieldByName(CreateFld(tbinfo.pfx, fli_StartingDateColumn)).AsInteger = 6) then
          DatesCustomize3Rec.SatartingDateColumn := CSC_SchedEnd
        else if (FieldByName(CreateFld(tbinfo.pfx, fli_StartingDateColumn)).AsInteger = 7) then
          DatesCustomize3Rec.SatartingDateColumn := CSC_ProgStart
        else if (FieldByName(CreateFld(tbinfo.pfx, fli_StartingDateColumn)).AsInteger = 8) then
          DatesCustomize3Rec.SatartingDateColumn := CSC_ProgEnd
        else if (FieldByName(CreateFld(tbinfo.pfx, fli_StartingDateColumn)).AsInteger = 9) then
          DatesCustomize3Rec.SatartingDateColumn := CSC_PrvHighestDate
        else if (FieldByName(CreateFld(tbinfo.pfx, fli_StartingDateColumn)).AsInteger = 10) then
          DatesCustomize3Rec.SatartingDateColumn := CSC_NxtLowestDate
        else if (FieldByName(CreateFld(tbinfo.pfx, fli_StartingDateColumn)).AsInteger = 11) then
          DatesCustomize3Rec.SatartingDateColumn := CSC_ProgStart_Ignored
        else if (FieldByName(CreateFld(tbinfo.pfx, fli_StartingDateColumn)).AsInteger = 12) then
          DatesCustomize3Rec.SatartingDateColumn := CSC_ProgEnd_Ignored
      end;

      if FieldByName(CreateFld(tbinfo.pfx, fli_TimeType)).AsString = '1' then
        DatesCustomize3Rec.TimeType := 'Minutes'
      else if FieldByName(CreateFld(tbinfo.pfx, fli_TimeType)).AsString = '2' then
        DatesCustomize3Rec.TimeType := 'Hours'
      else if FieldByName(CreateFld(tbinfo.pfx, fli_TimeType)).AsString = '3' then
        DatesCustomize3Rec.TimeType := 'Days'
      else if FieldByName(CreateFld(tbinfo.pfx, fli_TimeType)).AsString = '4' then
        DatesCustomize3Rec.TimeType := 'Dur';


      P_Id := GetIdFromCode(fieldByName(CreateFld(tbInfo.pfx,fli_PropertyDateColumn)).AsString);
      if (P_Id <> nil) and (DatesCustomize3Rec.SatartingDateColumn <> CSC_Non) then
      begin
        DatesCustomize3Rec.PropIdDateColumn := P_Id;
        DatesCustomize3Rec.enable := true;
      end
      else
        DatesCustomize3Rec.enable := false;

      if FieldByName(CreateFld(tbinfo.pfx, fli_BinDateColumn)).AsInteger <> -1 then
      begin
        if (FieldByName(CreateFld(tbinfo.pfx, fli_BinDateColumn)).AsInteger = 0) then
          DatesCustomize3Rec.BinDateColumn := CSC_LowStartTimeLimit
        else if (FieldByName(CreateFld(tbinfo.pfx, fli_BinDateColumn)).AsInteger = 1) then
          DatesCustomize3Rec.BinDateColumn := CSC_ProdDlvDate
        else if (FieldByName(CreateFld(tbinfo.pfx, fli_BinDateColumn)).AsInteger = 2) then
          DatesCustomize3Rec.BinDateColumn := CSC_MatArrivalDate
        else if (FieldByName(CreateFld(tbinfo.pfx, fli_BinDateColumn)).AsInteger = 3) then
          DatesCustomize3Rec.BinDateColumn := CSC_LowStartDate
        else if (FieldByName(CreateFld(tbinfo.pfx, fli_BinDateColumn)).AsInteger = 4) then
          DatesCustomize3Rec.BinDateColumn := CSC_HighEndLimit
        else if (FieldByName(CreateFld(tbinfo.pfx, fli_BinDateColumn)).AsInteger = 5) then
          DatesCustomize3Rec.BinDateColumn := CSC_SchedStart
        else if (FieldByName(CreateFld(tbinfo.pfx, fli_BinDateColumn)).AsInteger = 6) then
          DatesCustomize3Rec.BinDateColumn := CSC_SchedEnd
        else if (FieldByName(CreateFld(tbinfo.pfx, fli_BinDateColumn)).AsInteger = 7) then
          DatesCustomize3Rec.BinDateColumn := CSC_ProgStart
        else if (FieldByName(CreateFld(tbinfo.pfx, fli_BinDateColumn)).AsInteger = 8) then
          DatesCustomize3Rec.BinDateColumn := CSC_ProgEnd
        else if (FieldByName(CreateFld(tbinfo.pfx, fli_BinDateColumn)).AsInteger = 9) then
          DatesCustomize3Rec.BinDateColumn := CSC_PrvHighestDate
        else if (FieldByName(CreateFld(tbinfo.pfx, fli_BinDateColumn)).AsInteger = 10) then
          DatesCustomize3Rec.BinDateColumn := CSC_NxtLowestDate
        else if (FieldByName(CreateFld(tbinfo.pfx, fli_BinDateColumn)).AsInteger = 11) then
          DatesCustomize3Rec.BinDateColumn := CSC_ProgStart_Ignored
        else if (FieldByName(CreateFld(tbinfo.pfx, fli_BinDateColumn)).AsInteger = 12) then
          DatesCustomize3Rec.BinDateColumn := CSC_ProgEnd_Ignored
      end
      else DatesCustomize3Rec.BinDateColumn := CSC_Non;

      if DatesCustomize3Rec.BinDateColumn <> CSC_Non then
         DatesCustomize3Rec.enable := true;

      if FieldByName(CreateFld(tbinfo.pfx, fli_ABSolute_Value)).AsString = '1' then
        DatesCustomize3Rec.ABSoluteValue  := true
      else
        DatesCustomize3Rec.ABSoluteValue  := false;

    end;

  end;

  qry.free;
end;

//----------------------------------------------------------------------------//

function CustomDateGapInfoEnabled(Customized_column_Num : Integer; var DateColumnId  : CBinColId; var PropId : TPropId;
                                   var TimeAdd : double; var BinDateColumn : CBinColId; var IsAbs : boolean; var IsDur : boolean) : boolean;
begin
  Result := false;

  if Customized_column_Num = 2 then
    CurrentDatesCustomizeRec := DatesCustomize2Rec
  else if Customized_column_Num = 3 then CurrentDatesCustomizeRec := DatesCustomize3Rec;

  if CurrentDatesCustomizeRec.enable then
  begin
    Result := true;
    DateColumnId := CurrentDatesCustomizeRec.SatartingDateColumn;
    PropId       := CurrentDatesCustomizeRec.PropIdDateColumn;

    if (CurrentDatesCustomizeRec.TimeType = 'Minutes') or (CurrentDatesCustomizeRec.TimeType = 'Dur') then
      TimeAdd := 1/24/60
    else if CurrentDatesCustomizeRec.TimeType = 'Hours' then
      TimeAdd := 1/24
    else if (CurrentDatesCustomizeRec.TimeType = 'Days') then
      TimeAdd := 1
    else
      TimeAdd := 1/24/60;

    BinDateColumn := CurrentDatesCustomizeRec.BinDateColumn;
    IsAbs := CurrentDatesCustomizeRec.ABSoluteValue;
    IsDur := (CurrentDatesCustomizeRec.TimeType = 'Dur')

  end;

end;

end.
