unit FMCapResDynamicDetails;

interface

uses
  cxButtons, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.Menus, Vcl.StdCtrls, Vcl.Buttons,
  Vcl.ExtCtrls, Vcl.Grids, UReSHape;

type

  TRecCapResDetails = record
    rescode : string;
    DateBegin : TDate;
    ToDateLimit : TDate;
    FromTime    : TTime;
    Sequence       : integer;
    ColorDesc      : Integer;
    NumberOfDays   : integer;
    CompactCase    : Integer;
    Comment        : string;
    propertyCode   : TStringList;
    propertyValue  : TStringList;
  end;
  PTRecCapResDetails = ^TRecCapResDetails;

  TCapResDynamicDetails = class(TForm)
    SGCapRes: TStringGrid;
    PanBtn: TPanel;
    PopupMenu1: TPopupMenu;
    MiUpdate: TMenuItem;
    MiInsert: TMenuItem;
    MIDelete: TMenuItem;
    BtnOk: TcxButton;
    BtnAbort: TcxButton;

    procedure MiUpdateClick(Sender: TObject);
    procedure MiInsertClick(Sender: TObject);
    procedure MIDeleteClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure SGCapResSelectCell(Sender: TObject; ACol, ARow: Integer;
      var CanSelect: Boolean);
    procedure BtnOkClick(Sender: TObject);
    procedure SGCapResDblClick(Sender: TObject);
    procedure BtnAbortClick(Sender: TObject);
  private
    m_rescode : string;
    m_DateBegin : TDate;
    m_ToDateLimit : TDate;
    m_FromTime  : TTime;
    m_RowSelected : integer;
    m_CapResDetailList : TList;
    procedure ReadCapResData;
    procedure RefreshCapResGrid;
    procedure SaveToDB;
  //  procedure InsertDate
  private
    { Private declarations }
  public
    constructor CreateCapResDynamicDetails(AOwner: TComponent; CapResDetailList : TList; ResCode : string; DateBegin : TDate; FromTime : TTime; ToDateLimit : TDate);
    function    GetCapResDetailList : TList;
    { Public declarations }
  end;

implementation

{$R *.dfm}

uses FMCapResDynamicDetailChild, UGPropComp, gnugettext, DMsrvPc, UMTblDesc, UMCommon, UMGlobal;
{ TCapResDynamic }


procedure TCapResDynamicDetails.SaveToDB;
var
  qry, qryDlt:    TMqmQuery;
//  trs:    TMqmTransaction;
  tbInfo : ^TTblInfo;
  SqlInsert, SqlDelete, DateBeginStr : string;
  I,J, Fromtime : Integer;
  Temp : currency;
  RecCapResDynamic : PTRecCapResDetails;
  year, month, day : word;
begin
//  trs := CreateTransaction(Main_DB, false);
  qry := CreateQuery(Main_DB);
  Qry.Transaction := CreateTransaction(Main_DB);

  qryDlt := CreateQuery(Main_DB);
  qryDlt.Transaction := CreateTransaction(Main_DB);

  tbInfo := @tblInfo[tbl_capRes_DynamicPerDate];

  SqlInsert := 'insert into ' + tbInfo.GetTableName + '(';
  SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_IDENTIFIER) + ',';
  SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_rsc) + ',';
  SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_DateBegin)    + ',';
  SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_fromTime) + ',';
  SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_Sequence) + ',';
  SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_NumberOfHours) + ',';
  SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_Color) + ',';
  SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_CompCaseNum) + ',';
  SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_Comment);
  SqlInsert := SqlInsert + ') values (';
  SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_IDENTIFIER) + ',';
  SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_rsc) + ',';
  SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_DateBegin) + ',';
  SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_fromTime) + ',';
  SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_Sequence) + ',';
  SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_NumberOfHours) + ',';
  SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_Color) + ',';
  SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_CompCaseNum) + ',';
  SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_Comment);
  SqlInsert := SqlInsert + ')';

  qry.sql.clear;
  qry.sql.Text  := SqlInsert;
  qry.Prepare;

  tbInfo := @tblInfo[tbl_capRes_DynamicPerDate];

  for I := 0 to m_CapResDetailList.Count - 1 do
  begin
    DecodeDate(PTRecCapResDetails(m_CapResDetailList[I]).DateBegin, year, month, day);
    DateBeginStr := QuotedStr(IntToStr(month) + '/' + IntToStr(Day) + '/' + IntToStr(Year));
  //  Fromtime := PTRecCapResDetails(m_CapResDetailList[I]).FromTime;

    Temp :=  PTRecCapResDetails(m_CapResDetailList[I]).FromTime * 24 * 60;
    Fromtime := Trunc(Temp);
    //qry.ParamByName(CreateFld(tbInfo.pfx,fli_fromTime)).AsInteger      := trunc(Temp);



    SqlDelete := 'delete from ' + tbInfo.GetTableName;
    SqlDelete := SqlDelete + ' Where ' + CreateFld(tbInfo.pfx, fli_rsc) + '=''' + m_rescode + '''';
    SqlDelete := SqlDelete + ' And ' + CreateFld(tbInfo.pfx, fli_DateBegin) + '=' + DateBeginStr;
    SqlDelete := SqlDelete + ' And ' + CreateFld(tbInfo.pfx, fli_fromTime) + '=' + IntToStr(Fromtime);
    SqlDelete := SqlDelete + ' And ' + CreateFld(tbInfo.pfx, fli_Sequence) + '=' + IntToStr(PTRecCapResDetails(m_CapResDetailList[I]).Sequence);
    SqlDelete := SqlDelete + AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_identifier));
    qryDlt.sql.Text := SqlDelete;
    qryDlt.ExecSQL;

    qry.ParamByName(CreateFld(tbInfo.pfx,fli_IDENTIFIER)).AsString     := IniAppGlobals.Identifier;
    qry.ParamByName(CreateFld(tbInfo.pfx,fli_rsc)).AsString            := m_rescode;
    qry.ParamByName(CreateFld(tbInfo.pfx,fli_DateBegin)).AsDateTime    := PTRecCapResDetails(m_CapResDetailList[I]).DateBegin;
//    Temp :=  PTRecCapResDetails(m_CapResDetailList[I]).FromTime * 24 * 60;
    qry.ParamByName(CreateFld(tbInfo.pfx,fli_fromTime)).AsInteger      := Fromtime;
    qry.ParamByName(CreateFld(tbInfo.pfx,fli_Sequence)).AsInteger      := PTRecCapResDetails(m_CapResDetailList[I]).Sequence;
    qry.ParamByName(CreateFld(tbInfo.pfx,fli_NumberOfHours)).AsInteger := PTRecCapResDetails(m_CapResDetailList[I]).NumberOfDays * 24;
    qry.ParamByName(CreateFld(tbInfo.pfx,fli_Color)).AsInteger         := PTRecCapResDetails(m_CapResDetailList[I]).ColorDesc;
    qry.ParamByName(CreateFld(tbInfo.pfx,fli_CompCaseNum)).AsInteger   := PTRecCapResDetails(m_CapResDetailList[I]).CompactCase;
    qry.ParamByName(CreateFld(tbInfo.pfx,fli_Comment)).AsString        := PTRecCapResDetails(m_CapResDetailList[I]).Comment;
    Qry.ExecSQL;
    Qry.Transaction.Commit;
  end;

  tbInfo := @tblInfo[tbl_capRes_DynamicPerResDateProp];

  SqlInsert := 'insert into ' + tbInfo.GetTableName + '(';
  SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_IDENTIFIER) + ',';
  SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_rsc) + ',';
  SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_DateBegin)    + ',';
  SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_fromTime) + ',';
  SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_Sequence) + ',';
  SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_PropertyCode) + ',';
  SqlInsert := SqlInsert + CreateFld(tbInfo.pfx,fli_PropValue);
  SqlInsert := SqlInsert + ') values (';
  SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_IDENTIFIER) + ',';
  SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_rsc) + ',';
  SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_DateBegin) + ',';
  SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_fromTime) + ',';
  SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_Sequence) + ',';
  SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_PropertyCode) + ',';
  SqlInsert := SqlInsert + ':' + CreateFld(tbInfo.pfx,fli_PropValue);
  SqlInsert := SqlInsert + ')';

  qry.sql.clear;
  qry.sql.Text  := SqlInsert;
  qry.Prepare;

  for I := 0 to m_CapResDetailList.Count - 1 do
  begin
    for J := 0 to PTRecCapResDetails(m_CapResDetailList[I]).propertyCode.Count - 1 do
    begin

      DecodeDate(PTRecCapResDetails(m_CapResDetailList[I]).DateBegin, year, month, day);
      DateBeginStr := QuotedStr(IntToStr(month) + '/' + IntToStr(Day) + '/' + IntToStr(Year));
    //  Fromtime := PTRecCapResDetails(m_CapResDetailList[I]).FromTime;

//      Temp :=  PTRecCapResDetails(m_CapResDetailList[I]).FromTime * 24 * 60;
//      Fromtime := Trunc(Temp);

      SqlDelete := 'delete from ' + tbInfo.GetTableName;
      SqlDelete := SqlDelete + ' Where ' + CreateFld(tbInfo.pfx, fli_rsc) + '=''' + m_rescode + '''';
      SqlDelete := SqlDelete + ' And ' + CreateFld(tbInfo.pfx, fli_DateBegin) + '=' + DateBeginStr;
      SqlDelete := SqlDelete + ' And ' + CreateFld(tbInfo.pfx, fli_fromTime) + '=' + IntToStr(Fromtime);
      SqlDelete := SqlDelete + ' And ' + CreateFld(tbInfo.pfx, fli_Sequence) + '=' + IntToStr(PTRecCapResDetails(m_CapResDetailList[I]).Sequence);
      SqlDelete := SqlDelete + ' And ' + CreateFld(tbInfo.pfx, fli_PropertyCode) + '=' + QuotedStr(PTRecCapResDetails(m_CapResDetailList[I]).propertyCode.Strings[J]);
      SqlDelete := SqlDelete + AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_identifier));
      qryDlt.sql.Text := SqlDelete;
      qryDlt.ExecSQL;
      qryDlt.Transaction.Commit;

      qry.ParamByName(CreateFld(tbInfo.pfx,fli_IDENTIFIER)).AsString     := IniAppGlobals.Identifier;
      qry.ParamByName(CreateFld(tbInfo.pfx,fli_rsc)).AsString            := m_rescode;
      qry.ParamByName(CreateFld(tbInfo.pfx,fli_DateBegin)).AsDateTime    := PTRecCapResDetails(m_CapResDetailList[I]).DateBegin;
   //   Temp :=  PTRecCapResDetails(m_CapResDetailList[I]).FromTime * 24 * 60;
      qry.ParamByName(CreateFld(tbInfo.pfx,fli_fromTime)).AsInteger      := FromTime;
      qry.ParamByName(CreateFld(tbInfo.pfx,fli_Sequence)).AsInteger      := PTRecCapResDetails(m_CapResDetailList[I]).Sequence;
      qry.ParamByName(CreateFld(tbInfo.pfx,fli_PropertyCode)).AsString   := PTRecCapResDetails(m_CapResDetailList[I]).propertyCode.Strings[J];
      qry.ParamByName(CreateFld(tbInfo.pfx,fli_PropValue)).AsString      := PTRecCapResDetails(m_CapResDetailList[I]).propertyValue.Strings[J];
      Qry.ExecSQL;
      Qry.Transaction.Commit;
    end;
  end;

  qryDlt.Free;
  qry.Free;
end;

//----------------------------------------------------------------------------------------------

procedure TCapResDynamicDetails.BtnAbortClick(Sender: TObject);
begin
  Close;
end;

procedure TCapResDynamicDetails.BtnOkClick(Sender: TObject);
begin
  ModalResult := mrOk;
end;

//----------------------------------------------------------------------------------------------

constructor TCapResDynamicDetails.CreateCapResDynamicDetails(AOwner: TComponent; CapResDetailList : TList;
  ResCode: string; DateBegin : TDate; FromTime : TTime; ToDateLimit : TDate);
begin
  inherited Create(AOwner);
  m_CapResDetailList := CapResDetailList;
  m_rescode := ResCode;
  m_DateBegin := DateBegin;
  m_FromTime  := FromTime;
  m_ToDateLimit := ToDateLimit;
  RefreshCapResGrid ;
  ReShape(Self);
end;

//----------------------------------------------------------------------------------------------

function SortBySequence(Item1, Item2: Pointer) : integer;
var
  RowDate1  : PTRecCapResDetails;
  RowDate2  : PTRecCapResDetails;
begin
  RowDate1 := PTRecCapResDetails(Item1);
  RowDate2 := PTRecCapResDetails(Item2);

  if RowDate1 = RowDate2 then
  begin
    Result := 0;
    Exit
  end;

  if RowDate1.Sequence < RowDate2.Sequence then
     Result := -1
  else if (RowDate1.Sequence = RowDate2.Sequence) then
  begin
     Result := 0;
  end
  else
    Result := 1;
end;

//----------------------------------------------------------------------------//

procedure TCapResDynamicDetails.FormCreate(Sender: TObject);
begin
//  ReadCapResData;
  if m_CapResDetailList.Count > 0 then
    m_RowSelected := 1;
  m_CapResDetailList.Sort(SortBySequence);
  RefreshCapResGrid;
end;

//----------------------------------------------------------------------------------------------

function TCapResDynamicDetails.GetCapResDetailList: TList;
begin
  result := m_CapResDetailList
end;

//----------------------------------------------------------------------------------------------

procedure TCapResDynamicDetails.MIDeleteClick(Sender: TObject);
//var
//  qry, qryProp :    TMqmQuery;
//  trs:    TMqmTransaction;
//  tbInfo, tbInfoProp: ^TTblInfo;
//  SqlDelete : string;
//  year, month, day : word;
//  DateBeginStr : string;
//  I, Fromtime : Integer;
//  Temp : currency;
begin
  if ((m_RowSelected - 1) >= 0) and (m_CapResDetailList.Count > 0) then
  begin
{    trs := CreateTransaction(Main_DB, false);
    qry := CreateQuery(trs, Main_DB);
    qryProp := CreateQuery(trs, Main_DB);
    tbInfo := @tblInfo[tbl_capRes_DynamicPerDate];
    tbInfoProp := @tblInfo[tbl_capRes_DynamicPerResDateProp];
    qry.SQL.Clear;
    qryProp.SQL.Clear;

    DecodeDate(PTRecCapResDetails(m_CapResDetailList[m_RowSelected - 1]).DateBegin, year, month, day);
    DateBeginStr := QuotedStr(IntToStr(month) + '/' + IntToStr(Day) + '/' + IntToStr(Year));

    Temp :=  PTRecCapResDetails(m_CapResDetailList[I]).FromTime * 24 * 60;

    SqlDelete := 'delete from ' + tbInfo.PCname;
    SqlDelete := SqlDelete + ' Where ' + CreateFld(tbInfo.pfx, fli_rsc) + '=''' + m_rescode + '''';
    SqlDelete := SqlDelete + ' And ' + CreateFld(tbInfo.pfx, fli_DateBegin) + '=' + DateBeginStr;
    SqlDelete := SqlDelete + ' And ' + CreateFld(tbInfo.pfx, fli_fromTime) + '=' + IntToStr(trunc(Temp));
    SqlDelete := SqlDelete + ' And ' + CreateFld(tbInfo.pfx, fli_Sequence) + '=' + IntToStr(PTRecCapResDetails(m_CapResDetailList[m_RowSelected - 1]).Sequence);
    qry.sql.Text := SqlDelete;
    Qry.ExecSQL;
    Qry.Transaction.Commit;

    for I := 0 to PTRecCapResDetails(m_CapResDetailList[m_RowSelected - 1]).propertyCode.Count - 1 do
    begin
      SqlDelete := 'delete from ' + tbInfoProp.PCname;
      SqlDelete := SqlDelete + ' Where ' + CreateFld(tbInfoProp.pfx, fli_rsc) + '=''' + m_rescode + '''';
      SqlDelete := SqlDelete + ' And ' + CreateFld(tbInfoProp.pfx, fli_DateBegin) + '=' + DateBeginStr;
      SqlDelete := SqlDelete + ' And ' + CreateFld(tbInfoProp.pfx, fli_fromTime) + '=' + IntToStr(trunc(Temp));
      SqlDelete := SqlDelete + ' And ' + CreateFld(tbInfoProp.pfx, fli_Sequence) + '=' + IntToStr(PTRecCapResDetails(m_CapResDetailList[m_RowSelected - 1]).Sequence);
      SqlDelete := SqlDelete + ' And ' + CreateFld(tbInfoProp.pfx, fli_PropertyCode) + '=' + QuotedStr(PTRecCapResDetails(m_CapResDetailList[m_RowSelected - 1]).propertyCode[I]);
      qryProp.sql.Text := SqlDelete;
      qryProp.ExecSQL;
      QryProp.Transaction.Commit;
    end;          }

    m_CapResDetailList.Delete(m_RowSelected - 1);

    m_CapResDetailList.Sort(SortBySequence);
    RefreshCapResGrid;
 //   qry.Free;
 //   trs.Free;
  end;
end;

//----------------------------------------------------------------------------------------------

procedure TCapResDynamicDetails.MiInsertClick(Sender: TObject);
var
  ReadDate : TRecCapResDetails;
  NewRec : PTRecCapResDetails;
  PropComp: TPropComponent;
  I : Integer;
  NewSequence : integer;
begin
  if m_CapResDetailList.Count > 0 then
    NewSequence := PTRecCapResDetails(m_CapResDetailList[m_CapResDetailList.count - 1]).Sequence + 1
  else
    NewSequence := 1;
  CapResDynamicDetailChild := TCapResDynamicDetailChild.CreateNewCapResDynamicDetailChild(self,m_rescode, NewSequence, m_DateBegin, m_FromTime, m_ToDateLimit);
  if CapResDynamicDetailChild.ShowModal = mrOk then
  begin
    CapResDynamicDetailChild.GetDateDetails(ReadDate.NumberOfDays, ReadDate.Sequence, ReadDate.ColorDesc, ReadDate.CompactCase, ReadDate.Comment, PropComp);
    new(NewRec);
    NewRec.rescode     :=  m_rescode;
    NewRec.DateBegin   :=  m_DateBegin;
    NewRec.ToDateLimit :=  m_ToDateLimit;
    NewRec.FromTime    :=  m_FromTime;
    NewRec.NumberOfDays := ReadDate.NumberOfDays;
    NewRec.Sequence     := ReadDate.Sequence;
    NewRec.ColorDesc    := ReadDate.ColorDesc;
    NewRec.CompactCase := ReadDate.CompactCase;
    NewRec.Comment := ReadDate.Comment;
    NewRec.propertyCode := TStringList.Create;
    NewRec.propertyValue := TStringList.Create;

    for I := 1 to PropComp.P_RowCount - 1 do
    begin
      if PropComp.P_GetPropVal[I] <> '' then
      begin
        NewRec.propertyCode.Add(PropComp.P_GetPropVal[I]);
        NewRec.propertyValue.Add(PropComp.P_GetValTo[I]);
      end;
    end;
    m_RowSelected := m_CapResDetailList.Add(NewRec) + 1;
    m_CapResDetailList.Sort(SortBySequence);
    RefreshCapResGrid;
  end;
  CapResDynamicDetailChild.Free;
end;

//----------------------------------------------------------------------------------------------

procedure TCapResDynamicDetails.MiUpdateClick(Sender: TObject);
var
  CapResDynamicDetailChild: TCapResDynamicDetailChild;
  ReadDate : TRecCapResDetails;
  NewRec : PTRecCapResDetails;
  PropComp: TPropComponent;
  I : Integer;
begin
  if ((m_RowSelected - 1) >= 0) and (m_CapResDetailList.Count > 0) then
  begin
    ReadDate.NumberOfDays := PTRecCapResDetails(m_CapResDetailList[m_RowSelected - 1]).NumberOfDays;
    ReadDate.Sequence     := PTRecCapResDetails(m_CapResDetailList[m_RowSelected - 1]).Sequence;
    ReadDate.ColorDesc    := PTRecCapResDetails(m_CapResDetailList[m_RowSelected - 1]).ColorDesc;
    ReadDate.CompactCase  := PTRecCapResDetails(m_CapResDetailList[m_RowSelected - 1]).CompactCase;
    ReadDate.Comment      := PTRecCapResDetails(m_CapResDetailList[m_RowSelected - 1]).Comment;
    ReadDate.propertyCode := PTRecCapResDetails(m_CapResDetailList[m_RowSelected - 1]).propertyCode;
    ReadDate.propertyValue := PTRecCapResDetails(m_CapResDetailList[m_RowSelected - 1]).propertyValue;

    CapResDynamicDetailChild := TCapResDynamicDetailChild.CreateUpdateCapResDynamicDetailChild(self,m_rescode, m_DateBegin, m_FromTime, m_ToDateLimit,
                                ReadDate.NumberOfDays, ReadDate.Sequence, ReadDate.ColorDesc, ReadDate.CompactCase, ReadDate.Comment, ReadDate.propertyCode, ReadDate.propertyValue);
    if CapResDynamicDetailChild.ShowModal = mrOk then
    begin
      CapResDynamicDetailChild.GetDateDetails(ReadDate.NumberOfDays, ReadDate.Sequence, ReadDate.ColorDesc, ReadDate.CompactCase, ReadDate.Comment, PropComp);
      new(NewRec);
      NewRec.rescode     :=  m_rescode;
      NewRec.DateBegin   :=  m_DateBegin;
      NewRec.ToDateLimit :=  m_ToDateLimit;
      NewRec.FromTime    :=  m_FromTime;
      NewRec.NumberOfDays := ReadDate.NumberOfDays;
      NewRec.Sequence     := ReadDate.Sequence;
      NewRec.ColorDesc    := ReadDate.ColorDesc;
      NewRec.CompactCase := ReadDate.CompactCase;
      NewRec.Comment := ReadDate.Comment;
      NewRec.propertyCode := TStringList.Create;
      NewRec.propertyValue := TStringList.Create;
      for I := 1 to PropComp.P_RowCount - 1 do
      begin
        if PropComp.P_GetPropVal[I] <> '' then
        begin
          NewRec.propertyCode.Add(PropComp.P_GetPropVal[I]);
          NewRec.propertyValue.Add(PropComp.P_GetValTo[I]);
        end;
      end;
      m_CapResDetailList.Delete(m_RowSelected - 1);
      m_CapResDetailList.Add(NewRec);
      m_CapResDetailList.Sort(SortBySequence);
      RefreshCapResGrid;
    end;

  end;
end;

//----------------------------------------------------------------------------------------------

procedure TCapResDynamicDetails.ReadCapResData;
var
  qry, QryProp :    TMqmQuery;
  trs :    TMqmTransaction;
  tbInfo, tbInfoProp : ^TTblInfo;
  ReadDate : PTRecCapResDetails;
  Hour, Min, Sec, MSec: Word;
  year, month, day : word;
  Temp : currency;
  TimeLocal : Integer;
  DateBeginStr : string;
begin
  qry := CreateQuery(Main_DB);
  QryProp := CreateQuery(Main_DB);

  tbInfo  := @tblInfo[tbl_capRes_DynamicPerDate];
  tbInfoProp  := @tblInfo[tbl_capRes_DynamicPerResDateProp];

  Temp :=  m_FromTime * 24 * 60;
  TimeLocal   := trunc(Temp);

  DecodeDate(m_DateBegin, year, month, day);
  DateBeginStr := QuotedStr(IntToStr(month) + '/' + IntToStr(Day) + '/' + IntToStr(Year));
  qry.SQL.Clear;
  qry.SQL.Add('select * from ' + tbInfo.GetTableName);
  qry.SQL.Add(' where ' + CreateFld(tbInfo.pfx, fli_rsc) + '=''' + m_rescode + '''');
  qry.SQL.Add(' AND ' + CreateFld(tbInfo.pfx, fli_DateBegin) + '=' + DateBeginStr);
  qry.SQL.Add(' AND ' + CreateFld(tbInfo.pfx, fli_fromTime) + '=' + IntToStr(TimeLocal));
  qry.SQL.Add(AND_IDF_Condition(CreateFld(tbInfo.pfx, fli_identifier)));
  qry.SQL.Add(' order by ' + CreateFld(tbInfo.pfx , fli_DateBegin) + ',' + CreateFld(tbInfo.pfx , fli_fromTime) + ',' + CreateFld(tbInfo.pfx , fli_Sequence));
  qry.Open;

  while not qry.Eof do
  begin
    new(ReadDate);
    ReadDate.rescode         := qry.FieldByName(CreateFld(tbInfo.pfx, fli_rsc)).AsString;
    ReadDate.DateBegin       := qry.FieldByName(CreateFld(tbInfo.pfx, fli_DateBegin)).AsDateTime;
    DecodeTime(qry.FieldByName(CreateFld(tbInfo.pfx, fli_fromTime)).AsInteger/24/60, Hour, Min, Sec, MSec);
    ReadDate.FromTime := EncodeTime(Hour, Min, Sec, MSec);


    ReadDate.Sequence        := qry.FieldByName(CreateFld(tbInfo.pfx, fli_Sequence)).AsInteger;
    ReadDate.ColorDesc       := qry.FieldByName(CreateFld(tbInfo.pfx, fli_Color)).AsInteger;
    ReadDate.NumberOfDays    := Trunc(qry.FieldByName(CreateFld(tbInfo.pfx, fli_NumberOfHours)).AsInteger / 24);
    ReadDate.CompactCase     := qry.FieldByName(CreateFld(tbInfo.pfx, fli_CompCaseNum)).AsInteger;
    ReadDate.Comment         := qry.FieldByName(CreateFld(tbInfo.pfx, fli_Comment)).AsString;
    ReadDate.propertyCode    := TStringList.Create;
    ReadDate.propertyValue   := TStringList.Create;

    QryProp.SQL.Clear;
    QryProp.SQL.Clear;
    QryProp.SQL.Add('select * from ' + tbInfoProp.GetTableName);
    QryProp.SQL.Add(' where ' + CreateFld(tbInfoProp.pfx, fli_rsc) + '=''' + m_rescode + '''');
    QryProp.SQL.Add(' AND ' + CreateFld(tbInfoProp.pfx, fli_DateBegin) + '=' + DateBeginStr);
    QryProp.SQL.Add(' AND ' + CreateFld(tbInfoProp.pfx, fli_fromTime) + '=' + IntToStr(TimeLocal));
    QryProp.SQL.Add(' AND ' + CreateFld(tbInfoProp.pfx, fli_Sequence) + '=' + IntToStr(ReadDate.Sequence));
    QryProp.SQL.Add(AND_IDF_Condition(CreateFld(tbInfoProp.pfx, fli_identifier)));
    QryProp.SQL.Add(' order by ' + CreateFld(tbInfoProp.pfx , fli_DateBegin) + ',' + CreateFld(tbInfoProp.pfx , fli_fromTime) +
                ',' + CreateFld(tbInfoProp.pfx , fli_Sequence) + ',' + CreateFld(tbInfoProp.pfx , fli_PropertyCode));

    QryProp.open;
    while not QryProp.Eof do
    begin
      ReadDate.propertyCode.Add(QryProp.FieldByName(CreateFld(tbInfoProp.pfx, fli_PropertyCode)).AsString);
      ReadDate.propertyValue.Add(QryProp.FieldByName(CreateFld(tbInfoProp.pfx, fli_PropValue)).AsString);
      QryProp.Next
    end;

    m_CapResDetailList.Add(ReadDate);
    qry.Next;
  end;

  qry.Free;
  QryProp.Free;
end;

//----------------------------------------------------------------------------------------------

procedure TCapResDynamicDetails.RefreshCapResGrid;
var
  I : integer;
  RowData : PTRecCapResDetails;
begin
  with SGCapRes do
  begin

    RowCount := m_CapResDetailList.Count + 1;
    if RowCount > 1 then FixedRows := 1;

    Cells[0, 0] := _('Sequence');
    Cells[1, 0] := _('Days number');
    Cells[2, 0] := _('Case Compatability');
    Cells[3, 0] := _('Comments');

    for i:= 0 to m_CapResDetailList.Count - 1 do
    begin
      RowData := PTRecCapResDetails(m_CapResDetailList[i]);
      Cells[0, i+1] := IntToStr(RowData.Sequence);
      Cells[1, i+1] := IntToStr(RowData.NumberOfDays);
      Cells[2, i+1] := IntToStr(RowData.CompactCase);
      Cells[3, i+1] := PTRecCapResDetails(RowData).Comment;
    end;
  end;
end;

//----------------------------------------------------------------------------------------------

procedure TCapResDynamicDetails.SGCapResDblClick(Sender: TObject);
begin
//  if ((m_RowSelected - 1) >= 0) and (m_CapResDetailList.Count > 0) then
//    MiUpdate(self)
end;

//----------------------------------------------------------------------------------------------

procedure TCapResDynamicDetails.SGCapResSelectCell(Sender: TObject; ACol,
  ARow: Integer; var CanSelect: Boolean);
begin
   m_RowSelected := Arow;
end;

//----------------------------------------------------------------------------------------------

end.
