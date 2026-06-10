unit FMCapResDynamic;

interface

uses
  cxButtons, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Data.DB, UMGlobal, gnugettext,
  Vcl.Grids, Vcl.DBGrids, Vcl.DBCtrls, Vcl.ExtCtrls, Vcl.ComCtrls,
  Vcl.Menus, Vcl.StdCtrls, Vcl.Buttons, UReShape;

type

  TRecCapResDynamic = record
    ResCode        : string;
    DateBegin      : TDate;
    FromTime       : Integer;
    ToDateTimelimit : TDateTime;
    ResDetailsList  : TList;
  end;
  PTRecCapResDynamic = ^TRecCapResDynamic;

  TCapResDynamic = class(TForm)
    SGCapRes: TStringGrid;
    PanBtn: TPanel;
    PopupMenu1: TPopupMenu;
    MiInsert: TMenuItem;
    MIDelete: TMenuItem;
    MiDetails: TMenuItem;
    MiUpdate: TMenuItem;
    BtnOk: TcxButton;
    BtnAbort: TcxButton;
    procedure MiUpdateClick(Sender: TObject);
    procedure MiInsertClick(Sender: TObject);
    procedure MIDeleteClick(Sender: TObject);
    procedure SGCapResSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure FormCreate(Sender: TObject);
    procedure MiDetailsClick(Sender: TObject);
    procedure BtnOkClick(Sender: TObject);
    procedure BtnAbortClick(Sender: TObject);
  private
    m_rescode : string;
    m_RowSelected : integer;
    m_CapResList : TList;
    m_CapResListBackup : TList;
    m_Changed : boolean;
    procedure ReadCapResData;
    procedure SaveToDB;
    procedure CopyBackupList;
    procedure RefreshCapResGrid;
    procedure ClearList;
    procedure ClearBackupList;

    { Private declarations }
  public
   constructor CreateCapResDynamic(AOwner: TComponent; ResCode : string);
    { Public declarations }
  end;

var
  CapResDynamic: TCapResDynamic;

implementation

{$R *.dfm}

uses DMsrvPc, UMTblDesc, FMCapResDynamicCreate, UMCOMMON, FMCapResDynamicDetails;

{ TCapResDynamic }

procedure TCapResDynamic.SaveToDB;
var
  qry, qryDlt:    TMqmQuery;
  tbInfoPerRes, tbInfoPerDate, tbInfoPerProp : ^TTblInfo;
  SqlInsert, SqlDelete, DateBeginStr : string;
  I,J,P, Fromtime : Integer;
  Temp : currency;
  RecCapResDynamic : PTRecCapResDynamic;
  year, month, day : word;
  CapResDetailList : TList;
begin
  qry := CreateQuery(Main_DB);
  Qry.Transaction := CreateTransaction(Main_DB);

  qryDlt := CreateQuery(Main_DB);
  qryDlt.Transaction := CreateTransaction(Main_DB);

  tbInfoPerRes := @tblInfo[tbl_capRes_DynamicPerRes];
  tbInfoPerDate := @tblInfo[tbl_capRes_DynamicPerDate];
  tbInfoPerProp := @tblInfo[tbl_capRes_DynamicPerResDateProp];

  qry.SQL.Clear;
  SqlInsert := 'insert into ' + tbInfoPerRes.GetTableName + '(';
  SqlInsert := SqlInsert + CreateFld(tbInfoPerRes.pfx,fli_IDENTIFIER) + ',';
  SqlInsert := SqlInsert + CreateFld(tbInfoPerRes.pfx,fli_rsc) + ',';
  SqlInsert := SqlInsert + CreateFld(tbInfoPerRes.pfx,fli_DateBegin)    + ',';
  SqlInsert := SqlInsert + CreateFld(tbInfoPerRes.pfx,fli_fromTime) + ',';
  SqlInsert := SqlInsert + CreateFld(tbInfoPerRes.pfx,fli_ToDateLimit);
  SqlInsert := SqlInsert + ') values (';
  SqlInsert := SqlInsert + ':' + CreateFld(tbInfoPerRes.pfx,fli_IDENTIFIER) + ',';
  SqlInsert := SqlInsert + ':' + CreateFld(tbInfoPerRes.pfx,fli_rsc) + ',';
  SqlInsert := SqlInsert + ':' + CreateFld(tbInfoPerRes.pfx,fli_DateBegin) + ',';
  SqlInsert := SqlInsert + ':' + CreateFld(tbInfoPerRes.pfx,fli_fromTime) + ',';
  SqlInsert := SqlInsert + ':' + CreateFld(tbInfoPerRes.pfx,fli_ToDateLimit);
  SqlInsert := SqlInsert + ')';
  qry.sql.Text  := SqlInsert;
//  qry.Prepare;

  for I := 0 to m_CapResList.Count - 1 do
  begin
    qryDlt.Transaction.StartTransaction;
  //  DecodeDate(PTRecCapResDynamic(m_CapResList[I]).DateBegin, year, month, day);
  //  DateBeginStr := QuotedStr(IntToStr(month) + '/' + IntToStr(Day) + '/' + IntToStr(Year));

    DateBeginStr := ConvertDateFormatDb2Oracle(PTRecCapResDynamic(m_CapResList[I]).DateBegin, true, true);

    Fromtime := PTRecCapResDynamic(m_CapResList[I]).FromTime;
    SqlDelete := 'delete from ' + tbInfoPerRes.GetTableName;
    SqlDelete := SqlDelete + ' Where ' + CreateFld(tbInfoPerRes.pfx, fli_rsc) + '=''' + m_rescode + '''';
    SqlDelete := SqlDelete + ' And ' + CreateFld(tbInfoPerRes.pfx, fli_DateBegin) + '=' + DateBeginStr;
    SqlDelete := SqlDelete + ' And ' + CreateFld(tbInfoPerRes.pfx, fli_fromTime) + '=' + IntToStr(Fromtime);
    SqlDelete := SqlDelete + AND_IDF_Condition(CreateFld(tbInfoPerRes.pfx, fli_identifier));
    qryDlt.sql.Text := SqlDelete;
    qryDlt.ExecSQL;
    qryDlt.Transaction.commit;

    qry.Transaction.StartTransaction;
    qry.ParamByName(CreateFld(tbInfoPerRes.pfx,fli_IDENTIFIER)).AsString    := IniAppGlobals.Identifier;
    qry.ParamByName(CreateFld(tbInfoPerRes.pfx,fli_rsc)).AsString           := m_rescode;
    qry.ParamByName(CreateFld(tbInfoPerRes.pfx,fli_DateBegin)).AsDateTime   := PTRecCapResDynamic(m_CapResList[I]).DateBegin;
    qry.ParamByName(CreateFld(tbInfoPerRes.pfx,fli_fromTime)).AsInteger     := PTRecCapResDynamic(m_CapResList[I]).FromTime;
    qry.ParamByName(CreateFld(tbInfoPerRes.pfx,fli_ToDateLimit)).AsDateTime := PTRecCapResDynamic(m_CapResList[I]).ToDateTimelimit;
    Qry.ExecSQL;
    Qry.Transaction.Commit;
  end;

  for J := 0 to m_CapResList.Count - 1 do
  begin
    CapResDetailList := PTRecCapResDynamic(m_CapResList[J]).ResDetailsList;

    for I := 0 to CapResDetailList.Count - 1 do
    begin
      DecodeDate(PTRecCapResDetails(CapResDetailList[I]).DateBegin, year, month, day);
//      DateBeginStr := QuotedStr(IntToStr(month) + '/' + IntToStr(Day) + '/' + IntToStr(Year));
      DateBeginStr := ConvertDateFormatDb2Oracle(PTRecCapResDynamic(CapResDetailList[I]).DateBegin, true, true);

      Temp :=  PTRecCapResDetails(CapResDetailList[I]).FromTime * 24 * 60;
      Fromtime := Trunc(Temp);

      qryDlt.Transaction.StartTransaction;
      SqlDelete := 'delete from ' + tbInfoPerDate.GetTableName;
      SqlDelete := SqlDelete + ' Where ' + CreateFld(tbInfoPerDate.pfx, fli_rsc) + '=''' + m_rescode + '''';
      SqlDelete := SqlDelete + ' And ' + CreateFld(tbInfoPerDate.pfx, fli_DateBegin) + '=' + DateBeginStr;
      SqlDelete := SqlDelete + ' And ' + CreateFld(tbInfoPerDate.pfx, fli_fromTime) + '=' + IntToStr(Fromtime);
      SqlDelete := SqlDelete + ' And ' + CreateFld(tbInfoPerDate.pfx, fli_Sequence) + '=' + IntToStr(PTRecCapResDetails(CapResDetailList[I]).Sequence);
      SqlDelete := SqlDelete + AND_IDF_Condition(CreateFld(tbInfoPerDate.pfx, fli_identifier));
      qryDlt.sql.clear;
      qryDlt.sql.Text := SqlDelete;
      qryDlt.ExecSQL;
      qryDlt.Transaction.commit;

      SqlInsert := 'insert into ' + tbInfoPerDate.GetTableName + '(';
      SqlInsert := SqlInsert + CreateFld(tbInfoPerDate.pfx,fli_identifier) + ',';
      SqlInsert := SqlInsert + CreateFld(tbInfoPerDate.pfx,fli_rsc) + ',';
      SqlInsert := SqlInsert + CreateFld(tbInfoPerDate.pfx,fli_DateBegin)    + ',';
      SqlInsert := SqlInsert + CreateFld(tbInfoPerDate.pfx,fli_fromTime) + ',';
      SqlInsert := SqlInsert + CreateFld(tbInfoPerDate.pfx,fli_Sequence) + ',';
      SqlInsert := SqlInsert + CreateFld(tbInfoPerDate.pfx,fli_NumberOfHours) + ',';
      SqlInsert := SqlInsert + CreateFld(tbInfoPerDate.pfx,fli_Color) + ',';
      SqlInsert := SqlInsert + CreateFld(tbInfoPerDate.pfx,fli_CompCaseNum) + ',';
      SqlInsert := SqlInsert + CreateFld(tbInfoPerDate.pfx,fli_Comment);
      SqlInsert := SqlInsert + ') values (';
      SqlInsert := SqlInsert + ':' + CreateFld(tbInfoPerDate.pfx,fli_identifier) + ',';
      SqlInsert := SqlInsert + ':' + CreateFld(tbInfoPerDate.pfx,fli_rsc) + ',';
      SqlInsert := SqlInsert + ':' + CreateFld(tbInfoPerDate.pfx,fli_DateBegin) + ',';
      SqlInsert := SqlInsert + ':' + CreateFld(tbInfoPerDate.pfx,fli_fromTime) + ',';
      SqlInsert := SqlInsert + ':' + CreateFld(tbInfoPerDate.pfx,fli_Sequence) + ',';
      SqlInsert := SqlInsert + ':' + CreateFld(tbInfoPerDate.pfx,fli_NumberOfHours) + ',';
      SqlInsert := SqlInsert + ':' + CreateFld(tbInfoPerDate.pfx,fli_Color) + ',';
      SqlInsert := SqlInsert + ':' + CreateFld(tbInfoPerDate.pfx,fli_CompCaseNum) + ',';
      SqlInsert := SqlInsert + ':' + CreateFld(tbInfoPerDate.pfx,fli_Comment);
      SqlInsert := SqlInsert + ')';

      qry.sql.clear;
      qry.sql.Text  := SqlInsert;
//      qry.Prepare;

      qry.Transaction.StartTransaction;
      qry.ParamByName(CreateFld(tbInfoPerDate.pfx,fli_IDENTIFIER)).AsString     := IniAppGlobals.Identifier;
      qry.ParamByName(CreateFld(tbInfoPerDate.pfx,fli_rsc)).AsString            := m_rescode;
      qry.ParamByName(CreateFld(tbInfoPerDate.pfx,fli_DateBegin)).AsDateTime    := PTRecCapResDetails(CapResDetailList[I]).DateBegin;
      Temp :=  PTRecCapResDetails(CapResDetailList[I]).FromTime * 24 * 60;
      qry.ParamByName(CreateFld(tbInfoPerDate.pfx,fli_fromTime)).AsInteger      := trunc(Temp);
      qry.ParamByName(CreateFld(tbInfoPerDate.pfx,fli_Sequence)).AsInteger      := PTRecCapResDetails(CapResDetailList[I]).Sequence;
      qry.ParamByName(CreateFld(tbInfoPerDate.pfx,fli_NumberOfHours)).AsInteger := PTRecCapResDetails(CapResDetailList[I]).NumberOfDays * 24;
      qry.ParamByName(CreateFld(tbInfoPerDate.pfx,fli_Color)).AsInteger         := PTRecCapResDetails(CapResDetailList[I]).ColorDesc;
      qry.ParamByName(CreateFld(tbInfoPerDate.pfx,fli_CompCaseNum)).AsInteger   := PTRecCapResDetails(CapResDetailList[I]).CompactCase;
      qry.ParamByName(CreateFld(tbInfoPerDate.pfx,fli_Comment)).AsString        := PTRecCapResDetails(CapResDetailList[I]).Comment;
      Qry.ExecSQL;
      Qry.Transaction.Commit;
    end;

    for I := 0 to CapResDetailList.Count - 1 do
    begin
      for p := 0 to PTRecCapResDetails(CapResDetailList[I]).propertyCode.Count - 1 do
      begin
        DecodeDate(PTRecCapResDetails(CapResDetailList[I]).DateBegin, year, month, day);
//        DateBeginStr := QuotedStr(IntToStr(month) + '/' + IntToStr(Day) + '/' + IntToStr(Year));
        DateBeginStr := ConvertDateFormatDb2Oracle(PTRecCapResDynamic(CapResDetailList[I]).DateBegin, true, true);
        Temp :=  PTRecCapResDetails(CapResDetailList[I]).FromTime * 24 * 60;
        Fromtime := Trunc(Temp);

        qryDlt.Transaction.StartTransaction;
        SqlDelete := 'delete from ' + tbInfoPerProp.GetTableName;
        SqlDelete := SqlDelete + ' Where ' + CreateFld(tbInfoPerProp.pfx, fli_rsc) + '=''' + m_rescode + '''';
        SqlDelete := SqlDelete + ' And ' + CreateFld(tbInfoPerProp.pfx, fli_DateBegin) + '=' + DateBeginStr;
        SqlDelete := SqlDelete + ' And ' + CreateFld(tbInfoPerProp.pfx, fli_fromTime) + '=' + IntToStr(Fromtime);
        SqlDelete := SqlDelete + ' And ' + CreateFld(tbInfoPerProp.pfx, fli_Sequence) + '=' + IntToStr(PTRecCapResDetails(CapResDetailList[I]).Sequence);
        SqlDelete := SqlDelete + ' And ' + CreateFld(tbInfoPerProp.pfx, fli_PropertyCode) + '=' + QuotedStr(PTRecCapResDetails(CapResDetailList[I]).propertyCode.Strings[P]);
        SqlDelete := SqlDelete + AND_IDF_Condition(CreateFld(tbInfoPerProp.pfx, fli_identifier));

        qryDlt.sql.clear;
        qryDlt.sql.Text := SqlDelete;
        qryDlt.ExecSQL;
        qryDlt.Transaction.Commit;

        SqlInsert := 'insert into ' + tbInfoPerProp.GetTableName + '(';
        SqlInsert := SqlInsert + CreateFld(tbInfoPerProp.pfx,fli_IDENTIFIER) + ',';
        SqlInsert := SqlInsert + CreateFld(tbInfoPerProp.pfx,fli_rsc) + ',';
        SqlInsert := SqlInsert + CreateFld(tbInfoPerProp.pfx,fli_DateBegin)    + ',';
        SqlInsert := SqlInsert + CreateFld(tbInfoPerProp.pfx,fli_fromTime) + ',';
        SqlInsert := SqlInsert + CreateFld(tbInfoPerProp.pfx,fli_Sequence) + ',';
        SqlInsert := SqlInsert + CreateFld(tbInfoPerProp.pfx,fli_PropertyCode) + ',';
        SqlInsert := SqlInsert + CreateFld(tbInfoPerProp.pfx,fli_PropValue);
        SqlInsert := SqlInsert + ') values (';
        SqlInsert := SqlInsert + ':' + CreateFld(tbInfoPerProp.pfx,fli_IDENTIFIER) + ',';
        SqlInsert := SqlInsert + ':' + CreateFld(tbInfoPerProp.pfx,fli_rsc) + ',';
        SqlInsert := SqlInsert + ':' + CreateFld(tbInfoPerProp.pfx,fli_DateBegin) + ',';
        SqlInsert := SqlInsert + ':' + CreateFld(tbInfoPerProp.pfx,fli_fromTime) + ',';
        SqlInsert := SqlInsert + ':' + CreateFld(tbInfoPerProp.pfx,fli_Sequence) + ',';
        SqlInsert := SqlInsert + ':' + CreateFld(tbInfoPerProp.pfx,fli_PropertyCode) + ',';
        SqlInsert := SqlInsert + ':' + CreateFld(tbInfoPerProp.pfx,fli_PropValue);
        SqlInsert := SqlInsert + ')';
        qry.sql.clear;
        qry.sql.Text  := SqlInsert;
//        qry.Prepare;

        qry.Transaction.StartTransaction;
        qry.ParamByName(CreateFld(tbInfoPerProp.pfx,fli_IDENTIFIER)).AsString     := IniAppGlobals.Identifier;
        qry.ParamByName(CreateFld(tbInfoPerProp.pfx,fli_rsc)).AsString            := m_rescode;
        qry.ParamByName(CreateFld(tbInfoPerProp.pfx,fli_DateBegin)).AsDateTime    := PTRecCapResDetails(CapResDetailList[I]).DateBegin;
        Temp :=  PTRecCapResDetails(CapResDetailList[I]).FromTime * 24 * 60;
        qry.ParamByName(CreateFld(tbInfoPerProp.pfx,fli_fromTime)).AsInteger      := trunc(Temp);
        qry.ParamByName(CreateFld(tbInfoPerProp.pfx,fli_Sequence)).AsInteger      := PTRecCapResDetails(CapResDetailList[I]).Sequence;
        qry.ParamByName(CreateFld(tbInfoPerProp.pfx,fli_PropertyCode)).AsString   := PTRecCapResDetails(CapResDetailList[I]).propertyCode.Strings[P];
        qry.ParamByName(CreateFld(tbInfoPerProp.pfx,fli_PropValue)).AsString      := PTRecCapResDetails(CapResDetailList[I]).propertyValue.Strings[P];
        Qry.ExecSQL;
        Qry.Transaction.Commit;
      end;
    end;

  end;

  qryDlt.Free;
  qry.Free;
end;

//----------------------------------------------------------------------------------------------

procedure TCapResDynamic.BtnAbortClick(Sender: TObject);
begin
  ModalResult := mrAbort;
  if m_Changed then
  begin
    ClearList;
    CopyBackupList;
    SaveToDB;
    ClearBackupList;
    m_CapResList.Free;
    m_CapResListBackup.Free;
  end;
end;

//----------------------------------------------------------------------------------------------

procedure TCapResDynamic.BtnOkClick(Sender: TObject);
var
  I : integer;
begin
  ModalResult := mrOk;
  if m_CapResList.count > 0 then
    SaveToDB;
  ClearList;
  ClearBackupList;
  m_CapResList.Free;
  m_CapResListBackup.Free;
end;

//----------------------------------------------------------------------------------------------

procedure TCapResDynamic.ClearList;
var
  I, J : Integer;
  RecCapResDetails : PTRecCapResDetails;
  RecCapResDynamic : PTRecCapResDynamic;
begin
  for I := 0 to m_CapResList.Count - 1 do
  begin
    RecCapResDynamic := PTRecCapResDynamic(m_CapResList[I]);
    for J := 0 to RecCapResDynamic.ResDetailsList.Count - 1 do
    begin
      RecCapResDetails := PTRecCapResDetails(RecCapResDynamic.ResDetailsList[J]);
      RecCapResDetails.propertyCode.Free;
      RecCapResDetails.propertyValue.Free;
      Dispose(RecCapResDetails)
    end;
    Dispose(RecCapResDynamic);
  end;
  m_CapResList.clear;
end;

//----------------------------------------------------------------------------------------------

procedure TCapResDynamic.ClearBackupList;
var
  I, J : Integer;
  RecCapResDetails : PTRecCapResDetails;
  RecCapResDynamic : PTRecCapResDynamic;
begin
  for I := 0 to m_CapResListBackup.Count - 1 do
  begin
    RecCapResDynamic := PTRecCapResDynamic(m_CapResListBackup[I]);
    for J := 0 to RecCapResDynamic.ResDetailsList.Count - 1 do
    begin
      RecCapResDetails := PTRecCapResDetails(RecCapResDynamic.ResDetailsList[J]);
      RecCapResDetails.propertyCode.Free;
      RecCapResDetails.propertyValue.Free;
      Dispose(RecCapResDetails)
    end;
    Dispose(RecCapResDynamic);
  end;
  m_CapResListBackup.Clear;
end;

//----------------------------------------------------------------------------------------------

procedure TCapResDynamic.CopyBackupList;
var
  I, J, P : Integer;
  ReadDate : PTRecCapResDynamic;
  ReadDateDetails : PTRecCapResDetails;
begin
  m_CapResListBackup := TList.Create;
  for I := 0 to m_CapResListBackup.Count - 1 do
  begin
    New(ReadDate);
    ReadDate.ResCode := PTRecCapResDynamic(m_CapResListBackup[I]).ResCode;
    ReadDate.DateBegin := PTRecCapResDynamic(m_CapResListBackup[I]).DateBegin;
    ReadDate.FromTime := PTRecCapResDynamic(m_CapResListBackup[I]).FromTime;
    ReadDate.ToDateTimelimit  := PTRecCapResDynamic(m_CapResListBackup[I]).ToDateTimelimit;
    ReadDate.ResDetailsList := TList.Create;
    m_CapResList.Add(ReadDate);

    for J := 0 to PTRecCapResDynamic(m_CapResListBackup[I]).ResDetailsList.Count - 1 do
    begin
      new(ReadDateDetails);
      ReadDateDetails.rescode := PTRecCapResDetails(PTRecCapResDynamic(m_CapResListBackup[I]).ResDetailsList[J]).rescode;
      ReadDateDetails.DateBegin := PTRecCapResDetails(PTRecCapResDynamic(m_CapResListBackup[I]).ResDetailsList[J]).DateBegin;
      ReadDateDetails.ToDateLimit := PTRecCapResDetails(PTRecCapResDynamic(m_CapResListBackup[I]).ResDetailsList[J]).ToDateLimit;
      ReadDateDetails.FromTime := PTRecCapResDetails(PTRecCapResDynamic(m_CapResListBackup[I]).ResDetailsList[J]).FromTime;
      ReadDateDetails.Sequence := PTRecCapResDetails(PTRecCapResDynamic(m_CapResListBackup[I]).ResDetailsList[J]).Sequence;
      ReadDateDetails.ColorDesc := PTRecCapResDetails(PTRecCapResDynamic(m_CapResListBackup[I]).ResDetailsList[J]).ColorDesc;
      ReadDateDetails.NumberOfDays := PTRecCapResDetails(PTRecCapResDynamic(m_CapResListBackup[I]).ResDetailsList[J]).NumberOfDays;
      ReadDateDetails.CompactCase  := PTRecCapResDetails(PTRecCapResDynamic(m_CapResListBackup[I]).ResDetailsList[J]).CompactCase;
      ReadDateDetails.propertyCode := TStringList.Create;
      ReadDateDetails.propertyValue := TStringList.Create;
      ReadDate.ResDetailsList.Add(ReadDateDetails);

      for P := 0 to PTRecCapResDetails(PTRecCapResDynamic(m_CapResListBackup[I]).ResDetailsList[J]).propertyCode.Count - 1 do
      begin
        ReadDateDetails.propertyCode.Add(PTRecCapResDetails(PTRecCapResDynamic(m_CapResListBackup[I]).ResDetailsList[J]).propertyCode.Strings[p]);
        ReadDateDetails.propertyValue.Add(PTRecCapResDetails(PTRecCapResDynamic(m_CapResListBackup[I]).ResDetailsList[J]).propertyValue.Strings[p])
      end;
    end;
  end;
end;

//----------------------------------------------------------------------------------------------

constructor TCapResDynamic.CreateCapResDynamic(AOwner: TComponent; ResCode : string);
begin
  inherited Create(AOwner);
  m_Changed := false;
  m_rescode := ResCode;
  m_CapResList := TList.Create;
  caption   := 'Dynamic capacity reservation' + ' - ' + m_rescode;
end;

//----------------------------------------------------------------------------------------------

function SortByDateBegin(Item1, Item2: Pointer) : integer;
var
  RowDate1  : PTRecCapResDynamic;
  RowDate2  : PTRecCapResDynamic;
begin

  RowDate1 := PTRecCapResDynamic(Item1);
  RowDate2 := PTRecCapResDynamic(Item2);

  if RowDate1 = RowDate2 then
  begin
    Result := 0;
    Exit
  end;

  if RowDate1.DateBegin < RowDate2.DateBegin then
     Result := -1
  else if (RowDate1.DateBegin = RowDate2.DateBegin) then
  begin
    if (RowDate1.FromTime < RowDate2.FromTime) then
      Result := -1
    else if (RowDate1.FromTime = RowDate2.FromTime) then
      Result := 1
    else
      Result := 1;
  end
  else
    Result := 1;
end;

//----------------------------------------------------------------------------//

procedure TCapResDynamic.FormCreate(Sender: TObject);
begin
  ReadCapResData;
  CopyBackupList;
  if m_CapResList.Count > 0 then
    m_RowSelected := 1;
  m_CapResList.Sort(SortByDateBegin);
  RefreshCapResGrid;

  ReShape(self);
//  ReShape(BtnOk);
//  ReShape(BtnAbort);
end;

//----------------------------------------------------------------------------//

procedure TCapResDynamic.MIDeleteClick(Sender: TObject);
var
  qry:    TMqmQuery;
  tbInfo: ^TTblInfo;
  SqlDelete : string;
  year, month, day : word;
  DateBeginStr : string;
  I, Fromtime : Integer;
  RecCapResDynamic : PTRecCapResDynamic;
begin
  m_Changed := true;
  if ((m_RowSelected - 1) >= 0) and (m_CapResList.Count > 0) then
  begin
    qry := CreateQuery(Main_DB);
    Qry.Transaction := CreateTransaction(Main_DB);
    Qry.Transaction.StartTransaction;

    tbInfo := @tblInfo[tbl_capRes_DynamicPerRes];
    qry.SQL.Clear;

 //   DecodeDate(PTRecCapResDynamic(m_CapResList[m_RowSelected - 1]).DateBegin, year, month, day);
//    DateBeginStr := QuotedStr(IntToStr(month) + '/' + IntToStr(Day) + '/' + IntToStr(Year));
    DateBeginStr := ConvertDateFormatDb2Oracle(PTRecCapResDynamic(m_CapResList[m_RowSelected - 1]).DateBegin, true, true);

    Fromtime := PTRecCapResDynamic(m_CapResList[m_RowSelected - 1]).FromTime;

    SqlDelete := 'delete from ' + tbInfo.GetTableName;
    SqlDelete := SqlDelete + ' Where ' + CreateFld(tbInfo.pfx, fli_rsc) + '=''' + m_rescode + '''';
    SqlDelete := SqlDelete + ' And ' + CreateFld(tbInfo.pfx, fli_DateBegin) + '=' + DateBeginStr;
    SqlDelete := SqlDelete + ' And ' + CreateFld(tbInfo.pfx, fli_fromTime) + '=' + IntToStr(Fromtime);
    SqlDelete := SqlDelete + AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_identifier));
    qry.sql.Text := SqlDelete;
    Qry.ExecSQL;

    tbInfo := @tblInfo[tbl_capRes_DynamicPerDate];
    SqlDelete := 'delete from ' + tbInfo.GetTableName;
    SqlDelete := SqlDelete + ' Where ' + CreateFld(tbInfo.pfx, fli_rsc) + '=''' + m_rescode + '''';
    SqlDelete := SqlDelete + ' And ' + CreateFld(tbInfo.pfx, fli_DateBegin) + '=' + DateBeginStr;
    SqlDelete := SqlDelete + ' And ' + CreateFld(tbInfo.pfx, fli_fromTime) + '=' + IntToStr(Fromtime);
    SqlDelete := SqlDelete + AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_identifier));
    qry.sql.Text := SqlDelete;
    Qry.ExecSQL;
//    Qry.Transaction.Commit;

    tbInfo := @tblInfo[tbl_capRes_DynamicPerResDateProp];
    SqlDelete := 'delete from ' + tbInfo.GetTableName;
    SqlDelete := SqlDelete + ' Where ' + CreateFld(tbInfo.pfx, fli_rsc) + '=''' + m_rescode + '''';
    SqlDelete := SqlDelete + ' And ' + CreateFld(tbInfo.pfx, fli_DateBegin) + '=' + DateBeginStr;
    SqlDelete := SqlDelete + ' And ' + CreateFld(tbInfo.pfx, fli_fromTime) + '=' + IntToStr(Fromtime);
    SqlDelete := SqlDelete + AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_identifier));
    qry.sql.Text := SqlDelete;
    Qry.ExecSQL;
    Qry.Transaction.Commit;

    PTRecCapResDynamic(m_CapResList[m_RowSelected - 1]).ResDetailsList.Clear;
    m_CapResList.Delete(m_RowSelected - 1);

    m_CapResList.Sort(SortByDateBegin);
    RefreshCapResGrid;
    qry.Free;
  end;
end;

//----------------------------------------------------------------------------------------------

procedure TCapResDynamic.MiDetailsClick(Sender: TObject);
var
  CapResDynamic: TCapResDynamicDetails;
begin
  m_Changed := true;
  if ((m_RowSelected - 1) >= 0) and (m_CapResList.Count > 0) then
  begin
    CapResDynamic := TCapResDynamicDetails.CreateCapResDynamicDetails(Self, PTRecCapResDynamic(m_CapResList[m_RowSelected - 1]).ResDetailsList, m_rescode,
         PTRecCapResDynamic(m_CapResList[m_RowSelected - 1]).DateBegin,
         PTRecCapResDynamic(m_CapResList[m_RowSelected - 1]).FromTime/24/60,
         PTRecCapResDynamic(m_CapResList[m_RowSelected - 1]).ToDateTimelimit);
    if CapResDynamic.ShowModal = mrOk then
    begin
     // m_CapResDetailList := CapResDynamic.GetCapResDetailList

      PTRecCapResDynamic(m_CapResList[m_RowSelected - 1]).ResDetailsList := CapResDynamic.GetCapResDetailList;
      m_CapResList.Sort(SortByDateBegin);
      RefreshCapResGrid;

    end;
    CapResDynamic.free;
  end;
end;

//----------------------------------------------------------------------------------------------

procedure TCapResDynamic.MiInsertClick(Sender: TObject);
var
  RowDate       : PTRecCapResDynamic;
  DateBegin ,DateToLimit : TDate;
  FromTime : TTime;
//  qry:    TMqmQuery;
//  trs:    TMqmTransaction;
//  tbInfo: ^TTblInfo;
  SqlInsert : string;
  temp : currency;
  I : Integer;
  CapResDynamicCreate : TCapResDynamicCreate;
begin
  m_Changed := true;
  CapResDynamicCreate := TCapResDynamicCreate.CreateCapResDynamic(self, m_CapResList);
  if CapResDynamicCreate.ShowModal = mrOk then
  begin
//    trs := CreateTransaction(Main_DB, false);
//    qry := CreateQuery(trs, Main_DB);
//    tbInfo := @tblInfo[tbl_capRes_DynamicPerRes];
//    qry.SQL.Clear;

    CapResDynamicCreate.GetUpdatedCapResData(DateBegin,FromTime,DateToLimit);
    new(RowDate);
    RowDate.DateBegin    := DateBegin;
    Temp :=  FromTime * 24 * 60;
    RowDate.FromTime   := trunc(Temp);
    RowDate.ToDateTimelimit := DateToLimit;
    RowDate.ResDetailsList := TList.Create;
    m_RowSelected := m_CapResList.Add(RowDate) + 1;

    m_CapResList.Sort(SortByDateBegin);
    RefreshCapResGrid;

  end;
end;

//----------------------------------------------------------------------------------------------

procedure TCapResDynamic.MiUpdateClick(Sender: TObject);
var
  RowDate       : PTRecCapResDynamic;
  DateBegin ,DateToLimit : TDate;
  FromTime : TTime;
  SqlInsert : string;
  temp : currency;
  I : Integer;
  CapResDynamicCreate : TCapResDynamicCreate;
begin
  m_Changed := true;
  if not ((m_RowSelected - 1) >= 0) and (m_CapResList.Count > 0) then exit;
  CapResDynamicCreate := TCapResDynamicCreate.CreateCapResDynamicUpdate(self, m_CapResList, m_RowSelected - 1);
  if CapResDynamicCreate.ShowModal = mrOk then
  begin
    CapResDynamicCreate.GetUpdatedCapResData(DateBegin,FromTime,DateToLimit);
    PTRecCapResDynamic(m_CapResList[m_RowSelected - 1]).DateBegin := DateBegin;
    Temp :=  FromTime * 24 * 60;
    PTRecCapResDynamic(m_CapResList[m_RowSelected - 1]).FromTime   := trunc(Temp);
    PTRecCapResDynamic(m_CapResList[m_RowSelected - 1]).ToDateTimelimit := DateToLimit;
    m_CapResList.Sort(SortByDateBegin);
    RefreshCapResGrid;
  end;
end;

//----------------------------------------------------------------------------------------------

procedure TCapResDynamic.ReadCapResData;
var
  qry, QryProp :    TMqmQuery;
  tbInfo, tbInfoDate, tbInfoProp : ^TTblInfo;
  ReadDate : PTRecCapResDynamic;
  ReadDateDetails : PTRecCapResDetails;
  Temp : currency;
  I : Integer;
  TimeLocal : Integer;
  FromTime  : TTime;
  DateBegin : TDate;
  Hour, Min, Sec, MSec: Word;
  year, month, day : word;
  DateBeginStr : string;
begin
  qry := CreateQuery(Main_DB);
  QryProp := CreateQuery(Main_DB);

  tbInfo := @tblInfo[tbl_capRes_DynamicPerRes];

  qry.SQL.Clear;
  qry.SQL.Add('select * from ' + tbInfo.GetTableName);
  qry.SQL.Add(' where ' + CreateFld(tbInfo.pfx, fli_rsc) + '=''' + m_rescode + '''');
  qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_identifier)));
  qry.SQL.Add(' order by ' + CreateFld(tbInfo.pfx , fli_DateBegin) + ',' + CreateFld(tbInfo.pfx , fli_fromTime));
  qry.Open;

  while not qry.Eof do
  begin
    new(ReadDate);
    ReadDate.DateBegin       := qry.FieldByName(CreateFld(tbInfo.pfx, fli_DateBegin)).AsDateTime;
    ReadDate.ToDateTimelimit := qry.FieldByName(CreateFld(tbInfo.pfx, fli_ToDateLimit)).AsDateTime;
    ReadDate.FromTime        := qry.FieldByName(CreateFld(tbInfo.pfx, fli_fromTime)).AsInteger;
    ReadDate.ResDetailsList  := TList.Create;
    m_CapResList.Add(ReadDate);
    qry.Next;
  end;

  tbInfoDate  := @tblInfo[tbl_capRes_DynamicPerDate];
  tbInfoProp  := @tblInfo[tbl_capRes_DynamicPerResDateProp];

  for I := 0 to m_CapResList.Count - 1 do
  begin
    ReadDate := PTRecCapResDynamic(m_CapResList[I]);
   // DecodeDate(ReadDate.DateBegin, year, month, day);
    //DateBeginStr := QuotedStr(IntToStr(month) + '/' + IntToStr(Day) + '/' + IntToStr(Year));
    DateBeginStr := ConvertDateFormatDb2Oracle(ReadDate.DateBegin, true, true);
    qry.SQL.Clear;
    qry.SQL.Add('select * from ' + tbInfoDate.GetTableName);
    qry.SQL.Add(' where ' + CreateFld(tbInfoDate.pfx, fli_rsc) + '=''' + m_rescode + '''');
    qry.SQL.Add(' AND ' + CreateFld(tbInfoDate.pfx, fli_DateBegin) + '=' + DateBeginStr);
    qry.SQL.Add(' AND ' + CreateFld(tbInfoDate.pfx, fli_fromTime) + '=' + IntToStr(ReadDate.FromTime));
    qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfoDate.pfx, fli_identifier)));
    qry.SQL.Add(' order by ' + CreateFld(tbInfoDate.pfx , fli_DateBegin) + ',' + CreateFld(tbInfoDate.pfx , fli_fromTime) + ',' + CreateFld(tbInfoDate.pfx , fli_Sequence));
    qry.Open;

    while not qry.Eof do
    begin
      new(ReadDateDetails);
      ReadDateDetails.rescode         := m_rescode;
      ReadDateDetails.DateBegin       := qry.FieldByName(CreateFld(tbInfoDate.pfx, fli_DateBegin)).AsDateTime;
      DecodeTime(qry.FieldByName(CreateFld(tbInfoDate.pfx, fli_fromTime)).AsInteger/24/60, Hour, Min, Sec, MSec);
      ReadDateDetails.FromTime := EncodeTime(Hour, Min, Sec, MSec);
      ReadDateDetails.Sequence        := qry.FieldByName(CreateFld(tbInfoDate.pfx, fli_Sequence)).AsInteger;
      ReadDateDetails.ColorDesc       := qry.FieldByName(CreateFld(tbInfoDate.pfx, fli_Color)).AsInteger;
      ReadDateDetails.NumberOfDays    := Trunc(qry.FieldByName(CreateFld(tbInfoDate.pfx, fli_NumberOfHours)).AsInteger / 24);
      ReadDateDetails.CompactCase     := qry.FieldByName(CreateFld(tbInfoDate.pfx, fli_CompCaseNum)).AsInteger;
      ReadDateDetails.Comment         := qry.FieldByName(CreateFld(tbInfoDate.pfx, fli_Comment)).AsString;
      ReadDateDetails.propertyCode    := TStringList.Create;
      ReadDateDetails.propertyValue   := TStringList.Create;

      QryProp.SQL.Clear;
      QryProp.SQL.Clear;
      QryProp.SQL.Add('select * from ' + tbInfoProp.GetTableName);
      QryProp.SQL.Add(' where ' + CreateFld(tbInfoProp.pfx, fli_rsc) + '=''' + m_rescode + '''');
      QryProp.SQL.Add(' AND ' + CreateFld(tbInfoProp.pfx, fli_DateBegin) + '=' + DateBeginStr);
      QryProp.SQL.Add(' AND ' + CreateFld(tbInfoProp.pfx, fli_fromTime) + '=' + IntToStr(ReadDate.FromTime));
      QryProp.SQL.Add(' AND ' + CreateFld(tbInfoProp.pfx, fli_Sequence) + '=' + IntToStr(ReadDateDetails.Sequence));
      QryProp.SQL.Add(AND_IDF_Condition(CreateFld(tbInfoProp.pfx, fli_identifier)));
      QryProp.SQL.Add(' order by ' + CreateFld(tbInfoProp.pfx , fli_DateBegin) + ',' + CreateFld(tbInfoProp.pfx , fli_fromTime) +
                  ',' + CreateFld(tbInfoProp.pfx , fli_Sequence) + ',' + CreateFld(tbInfoProp.pfx , fli_PropertyCode));

      QryProp.open;
      while not QryProp.Eof do
      begin
        ReadDateDetails.propertyCode.Add(QryProp.FieldByName(CreateFld(tbInfoProp.pfx, fli_PropertyCode)).AsString);
        ReadDateDetails.propertyValue.Add(QryProp.FieldByName(CreateFld(tbInfoProp.pfx, fli_PropValue)).AsString);
        QryProp.Next
      end;

      ReadDate.ResDetailsList.Add(ReadDateDetails);
      qry.Next;

    end;

  end;

  qry.Free;
  QryProp.Free

end;

//----------------------------------------------------------------------------------------------

procedure TCapResDynamic.RefreshCapResGrid;
var
  I : integer;
  RowData : PTRecCapResDynamic;
begin
  with SGCapRes do
  begin

    RowCount := m_CapResList.Count + 1;
    if RowCount > 1 then FixedRows := 1;

    Cells[0, 0] := _('Date begin');
    Cells[1, 0] := _('From time');
    Cells[2, 0] := _('To date limit');

    for i:= 0 to m_CapResList.Count - 1 do
    begin
      RowData := m_CapResList.Items[i];
      Cells[0, i+1] := DateTimeToStr(RowData.DateBegin);
      Cells[1, i+1] := TimeToStr(RowData.FromTime/ 24 / 60);
      Cells[2, i+1] := DateTimeToStr(RowData.ToDateTimelimit);
    end;
  end;
end;

procedure TCapResDynamic.SGCapResSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
  m_RowSelected := Arow;
end;

//----------------------------------------------------------------------------------------------

end.
