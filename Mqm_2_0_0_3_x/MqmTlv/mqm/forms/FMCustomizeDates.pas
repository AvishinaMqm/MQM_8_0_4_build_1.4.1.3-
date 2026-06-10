unit FMCustomizeDates;

interface

uses
  cxButtons, Windows, Messages, SysUtils, Variants, Classes, Graphics, UMSchedContFunc, Controls, Forms,UMCompat,
  Dialogs, StdCtrls, Buttons, UReShape, Vcl.ExtCtrls;

type

  TDatesCustomize = class(TForm)
    CBField1: TComboBox;
    CBPropType: TComboBox;
    CBTimeType: TComboBox;
    Label1: TLabel;
    Label2: TLabel;
    Label4: TLabel;
    CBOperation: TComboBox;
    BtnOk: TcxButton;
    BtnAbo: TcxButton;
    Button1: TcxButton;
    procedure FormCreate(Sender: TObject);
    procedure BtnOkClick(Sender: TObject);
    procedure Button1Click(Sender: TObject);
    procedure BtnAboClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
    constructor CreateCustomizeDate(AOwner : Tcomponent);
  end;

  procedure LoadCustomDateColumnInfo;
  function  CustomDateInfoEnabled(var PropIp_CustomDate : TPropId; var DateFieldSupport : CBinColId; var TimeAdd : double) : boolean;
//  function  GetCustomeDateInfo(var DateFieldSupport : CBinColId;

implementation

uses FMbin,UMbinGrid, Umglobal, UMBinDefault,gnugettext, DMsrvPc,UMTblDesc, UMCommon;

{$R *.dfm}

{ TDatesCustomize }

type
  TDatesCustomizeRec = record
    DateColumn : CBinColId;
    Operation  : string;
    PropType   : TPropID;
    TimeType   : String;
    enable     : boolean;
  end;

var
  DatesCustomizeRec : TDatesCustomizeRec;

//----------------------------------------------------------------------------//

procedure TDatesCustomize.BtnAboClick(Sender: TObject);
begin
  ModalResult := mrAbort;
  Close;
end;

procedure TDatesCustomize.BtnOkClick(Sender: TObject);
var
  qry: TMqmQuery;
  tbInfo : ^TTblInfo;
begin

  if (CBField1.ItemIndex = -1) then
  begin
    Showmessage(_('Please select date column'));
    exit
  end;

  if CBPropType.Items.Count = 0 then
  begin
    Showmessage(_('Please define a property'));
    exit
  end;

  if CBPropType.ItemIndex = -1 then
  begin
    Showmessage(_('Please select a property'));
    exit
  end;

  tbInfo := @tblInfo[btl_customizedDateColumn];
  qry := CreateQuery(Cfg_DB);
  Qry.Transaction := CreateTransaction(Cfg_DB);
  Qry.Transaction.StartTransaction;

  with qry.sql do
  begin
    Clear;
    Add('Delete from ' + tbInfo.GetTableName);
    Add(' Where ');
    Add(CreateFld(tbInfo.pfx, fli_wkstCode) + '=''' + IniAppGlobals.WkstCode + '''');
    Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_identifier)));
    qry.ExecSQL;

    Clear;
    Add('insert into ' + tbInfo.GetTableName + '(');
    Add(CreateFld(tbInfo.pfx,fli_identifier) + ',');
    Add(CreateFld(tbInfo.pfx,fli_wkstCode) + ',');
    Add(CreateFld(tbInfo.pfx,fli_BinColField) + ',');
    Add(CreateFld(tbInfo.pfx,fli_FiltPropCode) + ',');
    Add(CreateFld(tbInfo.pfx,fli_TypOprtion) + ',');
    Add(CreateFld(tbInfo.pfx,fli_TimeType) + ')');

    qry.SQL.Add(' values (');
    qry.SQL.Add(':' + CreateFld(tbInfo.pfx,fli_identifier) + ',');
    qry.SQL.Add(':' + CreateFld(tbInfo.pfx,fli_wkstCode) + ',');
    qry.SQL.Add(':' + CreateFld(tbInfo.pfx,fli_BinColField) + ',');
    qry.SQL.Add(':' + CreateFld(tbInfo.pfx,fli_FiltPropCode) + ',');
    qry.SQL.Add(':' + CreateFld(tbInfo.pfx,fli_TypOprtion) + ',');
    qry.SQL.Add(':' + CreateFld(tbInfo.pfx,fli_TimeType));
    qry.SQL.Add(')');

    if (CBField1.ItemIndex <> -1) then
    begin
      qry.ParamByName(CreateFld(tbInfo.pfx,fli_identifier)).AsString := IniAppGlobals.Identifier;
      qry.ParamByName(CreateFld(tbInfo.pfx,fli_wkstCode)).AsString := IniAppGlobals.WkstCode;
      qry.ParamByName(CreateFld(tbInfo.pfx,fli_BinColField)).AsInteger := CBField1.ItemIndex;

      if CBField1.ItemIndex = 0 then
         DatesCustomizeRec.DateColumn := CSC_LowStartTimeLimit;
      if CBField1.ItemIndex = 1 then
         DatesCustomizeRec.DateColumn := CSC_ProdDlvDate;
      if CBField1.ItemIndex = 2 then
         DatesCustomizeRec.DateColumn := CSC_MatArrivalDate;
      if CBField1.ItemIndex = 3 then
         DatesCustomizeRec.DateColumn := CSC_LowStartDate;
      if CBField1.ItemIndex = 4 then
         DatesCustomizeRec.DateColumn := CSC_HighEndLimit;
      if CBField1.ItemIndex = 5 then
         DatesCustomizeRec.DateColumn := CSC_SchedStart;
      if CBField1.ItemIndex = 6 then
         DatesCustomizeRec.DateColumn := CSC_SchedEnd;
      if CBField1.ItemIndex = 7 then
         DatesCustomizeRec.DateColumn := CSC_ProgStart;
      if CBField1.ItemIndex = 8 then
         DatesCustomizeRec.DateColumn := CSC_ProgEnd;
      if CBField1.ItemIndex = 9 then
         DatesCustomizeRec.DateColumn := CSC_PrvHighestDate;
      if CBField1.ItemIndex = 10 then
         DatesCustomizeRec.DateColumn := CSC_NxtLowestDate;

      qry.ParamByName(CreateFld(tbInfo.pfx,fli_FiltPropCode)).AsString := GetPropCodeFromID(CBPropType.Items.Objects[CBPropType.ItemIndex]);
      DatesCustomizeRec.PropType := CBPropType.Items.Objects[CBPropType.ItemIndex];
      if CBOperation.ItemIndex = 0 then
      begin
        qry.ParamByName(CreateFld(tbInfo.pfx,fli_TypOprtion)).AsString := '0';
        DatesCustomizeRec.Operation := '+'
      end
      else if CBOperation.ItemIndex = 1 then
      begin
        qry.ParamByName(CreateFld(tbInfo.pfx,fli_TypOprtion)).AsString := '1';
        DatesCustomizeRec.Operation := '-'
      end;
      if CBTimeType.ItemIndex = 0 then
      begin
        qry.ParamByName(CreateFld(tbInfo.pfx,fli_TimeType)).AsString := '1';
        DatesCustomizeRec.TimeType := 'Minutes'
      end
      else if CBTimeType.ItemIndex = 1 then
      begin
        qry.ParamByName(CreateFld(tbInfo.pfx,fli_TimeType)).AsString := '2';
        DatesCustomizeRec.TimeType := 'Hours'
      end
      else if CBTimeType.ItemIndex = 2 then
      begin
        qry.ParamByName(CreateFld(tbInfo.pfx,fli_TimeType)).AsString := '3';
        DatesCustomizeRec.TimeType := 'Days';
      end;
      qry.ExecSQL;
    end;
  end;

  DatesCustomizeRec.enable := true;

  if assigned(FBin) then FBin.RefreshGrid;
  Qry.transaction.Commit;
  qry.Free;
  close;
end;

//----------------------------------------------------------------------------//

procedure TDatesCustomize.Button1Click(Sender: TObject);
begin
  CBField1.ItemIndex := -1;
  DatesCustomizeRec.DateColumn := CSC_Non;
  CBPropType.ItemIndex := -1;
end;

//----------------------------------------------------------------------------//

constructor TDatesCustomize.CreateCustomizeDate(AOwner: Tcomponent);
begin
  inherited create(AOwner);
end;

//----------------------------------------------------------------------------//

procedure TDatesCustomize.FormCreate(Sender: TObject);
var
  i, Index : Integer; //PropPosition, Num    : integer;
  binGrid     : TBinDrawGrid;
//  FieldsCount : integer;
  PId : TPropID;
  Pos : Integer;
begin

  binGrid := FBin.GetActiveView.GetBinGrid;

  CBOperation.Items.add('+');
  CBOperation.Items.add('-');
  CBOperation.ItemIndex := 0;

  CBTimeType.Items.Add('Minutes');
  CBTimeType.Items.Add('Hours');
  CBTimeType.Items.Add('Days');
  CBTimeType.ItemIndex := 0;

//  CBOperation.ItemIndex := 0;

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
       CBField1.Items.Add(binGrid.BinColumnSet[i].Title);
  end;

  {FieldsCount := GetNumberFields;
  Index := 0;
  for I := 0 to high(DBAppGlobals.ShowBinPropArry) do
  begin
    if not (DBAppGlobals.ShowBinPropArry[I] = nil) then
      Index := Index + 1
    else
      break;
  end;

  PropPosition := FieldsCount + Index;
  num := -1;

  for I := FieldsCount to (PropPosition - 1) do
  begin
    case (binGrid.BinColumnSet[I].Field) of
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
      CSC_property30:  num := 29

    end;

    if (num <> -1) then
    begin
      pId := DBAppGlobals.ShowBinPropArry[num];
      if (pId <> nil) and not IsPropAlpha(pId) then
      begin
        Pos := CBPropType.Items.Add(GetPropDescr(pId));
        CBPropType.Items.Objects[pos] := pId;
        CBPropType.ItemIndex := 0;
      end;
    end;
  end; }

  for Index := 0 to GetPropertyCount - 1 do
  begin
    pId := GetPropFromPos(Index);
    //if IsPropAlpha(pId) then continue;
    if not IsDateProp(pId) then continue;
    Pos := CBPropType.Items.Add(GetPropDescr(pId));
    CBPropType.Items.Objects[pos] := pId;
  end;

//  CBPropType.ItemIndex := 0;

  if DatesCustomizeRec.TimeType <> '' then
  begin
    if DatesCustomizeRec.TimeType = 'Minutes' then
      CBTimeType.ItemIndex := 0
    else if DatesCustomizeRec.TimeType = 'Hours' then
      CBTimeType.ItemIndex := 1
    else if DatesCustomizeRec.TimeType = 'Days' then
      CBTimeType.ItemIndex := 2
    else
      CBTimeType.ItemIndex := 0;
  end;

  if (DatesCustomizeRec.PropType <> nil) then
  begin
    for I := 0 to CBPropType.Items.Count - 1 do
    begin
      if DatesCustomizeRec.PropType = CBPropType.Items.Objects[I] then
      begin
        CBPropType.ItemIndex := I;
        Break
      end;
    end;
  end;

  if DatesCustomizeRec.DateColumn <> CSC_Non then
  begin
    if DatesCustomizeRec.DateColumn = CSC_LowStartTimeLimit then
      CBField1.ItemIndex := 0
    else if DatesCustomizeRec.DateColumn = CSC_ProdDlvDate then
      CBField1.ItemIndex := 1
    else if DatesCustomizeRec.DateColumn = CSC_MatArrivalDate then
      CBField1.ItemIndex := 2
    else if DatesCustomizeRec.DateColumn = CSC_LowStartDate then
      CBField1.ItemIndex := 3
    else if DatesCustomizeRec.DateColumn = CSC_HighEndLimit then
      CBField1.ItemIndex := 4
    else if DatesCustomizeRec.DateColumn = CSC_SchedStart then
      CBField1.ItemIndex := 5
    else if DatesCustomizeRec.DateColumn = CSC_SchedEnd then
      CBField1.ItemIndex := 6
    else if DatesCustomizeRec.DateColumn = CSC_ProgStart then
      CBField1.ItemIndex := 7
    else if DatesCustomizeRec.DateColumn = CSC_ProgEnd then
      CBField1.ItemIndex := 8
    else if DatesCustomizeRec.DateColumn = CSC_PrvHighestDate then
      CBField1.ItemIndex := 9
    else if DatesCustomizeRec.DateColumn = CSC_NxtLowestDate then
      CBField1.ItemIndex := 10

  end;

  if (DatesCustomizeRec.Operation = '+') then
     CBOperation.ItemIndex := 0
  else if (DatesCustomizeRec.Operation = '-') then
     CBOperation.ItemIndex := 1;


  ReShape(Self);
//  ReShape(btnOk);
//  ReShape(btnAbo);
//  ReShape(Button1);
end;

//----------------------------------------------------------------------------//

procedure LoadCustomDateColumnInfo;
var
  tbInfo : ^TTblInfo;
  P_Id   : TPropID;
  qry: TMqmQuery;
begin
  qry := CreateQuery(Cfg_DB);
  DatesCustomizeRec.DateColumn := CSC_Non;
  DatesCustomizeRec.TimeType   := '';
  DatesCustomizeRec.enable := false;
  with qry do
  begin
    tbInfo := @tblInfo[btl_customizedDateColumn];
    SQL.Clear;
    SQL.Add('select * from ' + tbInfo.GetTableName);
    SQL.Add( ' where ');
    SQL.Add(CreateFld(tbInfo.pfx, fli_wkstCode) + '=''' + IniAppGlobals.WkstCode + '''');
    SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_identifier)));
    Open;
    if not EOF then
    begin
      if FieldByName(CreateFld(tbinfo.pfx, fli_BinColField)).AsInteger <> -1 then
      begin
        if (FieldByName(CreateFld(tbinfo.pfx, fli_BinColField)).AsInteger = 0) then
          DatesCustomizeRec.DateColumn := CSC_LowStartTimeLimit
        else if (FieldByName(CreateFld(tbinfo.pfx, fli_BinColField)).AsInteger = 1) then
          DatesCustomizeRec.DateColumn := CSC_ProdDlvDate
        else if (FieldByName(CreateFld(tbinfo.pfx, fli_BinColField)).AsInteger = 2) then
          DatesCustomizeRec.DateColumn := CSC_MatArrivalDate
        else if (FieldByName(CreateFld(tbinfo.pfx, fli_BinColField)).AsInteger = 3) then
          DatesCustomizeRec.DateColumn := CSC_LowStartDate
        else if (FieldByName(CreateFld(tbinfo.pfx, fli_BinColField)).AsInteger = 4) then
          DatesCustomizeRec.DateColumn := CSC_HighEndLimit
        else if (FieldByName(CreateFld(tbinfo.pfx, fli_BinColField)).AsInteger = 5) then
          DatesCustomizeRec.DateColumn := CSC_SchedStart
        else if (FieldByName(CreateFld(tbinfo.pfx, fli_BinColField)).AsInteger = 6) then
          DatesCustomizeRec.DateColumn := CSC_SchedEnd
        else if (FieldByName(CreateFld(tbinfo.pfx, fli_BinColField)).AsInteger = 7) then
          DatesCustomizeRec.DateColumn := CSC_ProgStart
        else if (FieldByName(CreateFld(tbinfo.pfx, fli_BinColField)).AsInteger = 8) then
          DatesCustomizeRec.DateColumn := CSC_ProgEnd
        else if (FieldByName(CreateFld(tbinfo.pfx, fli_BinColField)).AsInteger = 9) then
          DatesCustomizeRec.DateColumn := CSC_PrvHighestDate
        else if (FieldByName(CreateFld(tbinfo.pfx, fli_BinColField)).AsInteger = 10) then
          DatesCustomizeRec.DateColumn := CSC_NxtLowestDate;

      end;

      if FieldByName(CreateFld(tbinfo.pfx, fli_TypOprtion)).AsString = '0' then
        DatesCustomizeRec.Operation  := '+'
      else if FieldByName(CreateFld(tbinfo.pfx, fli_TypOprtion)).AsString = '1' then
        DatesCustomizeRec.Operation  := '-';

      if FieldByName(CreateFld(tbinfo.pfx, fli_TimeType)).AsString = '1' then
        DatesCustomizeRec.TimeType := 'Minutes'
      else if FieldByName(CreateFld(tbinfo.pfx, fli_TimeType)).AsString = '2' then
        DatesCustomizeRec.TimeType := 'Hours'
      else if FieldByName(CreateFld(tbinfo.pfx, fli_TimeType)).AsString = '3' then
        DatesCustomizeRec.TimeType := 'Days';

      P_Id := GetIdFromCode(fieldByName(CreateFld(tbInfo.pfx,fli_FiltPropCode)).AsString);
      if (P_Id <> nil) and (DatesCustomizeRec.DateColumn <> CSC_Non) then
      begin
        DatesCustomizeRec.PropType := P_Id;
        DatesCustomizeRec.enable := true;
      end;
      Application.ProcessMessages;

    end;

  end;
end;

//----------------------------------------------------------------------------//

function CustomDateInfoEnabled(var PropIp_CustomDate : TPropId; var DateFieldSupport : CBinColId; var TimeAdd : double) : boolean;
begin
  Result := false;
  TimeAdd := 0;
  if DatesCustomizeRec.enable then
  begin
    Result := true;
    PropIp_CustomDate := DatesCustomizeRec.PropType;
    DateFieldSupport  := DatesCustomizeRec.DateColumn;
    if DatesCustomizeRec.TimeType = 'Minutes' then
      TimeAdd := 1/24/60
    else if DatesCustomizeRec.TimeType = 'Hours' then
      TimeAdd := 1/24
    else if DatesCustomizeRec.TimeType = 'Days' then
      TimeAdd := 1;
    if DatesCustomizeRec.Operation = '-' then
      TimeAdd := TimeAdd * (-1);
  end;

end;


end.
