unit FMServerStatus;

interface

uses
  cxButtons, Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, UMCommon, UReShape, Vcl.ExtCtrls;

type
  TFServerStatus = class(TForm)
    LabDateTime: TLabel;
    LabOperation: TLabel;
    LabDesc: TLabel;
    LogMemo: TMemo;
    BtnOk: TcxButton;
    constructor CreateForm(AOwner: TComponent);
    function ReadLog(deleteOld: boolean): TStringList;
    procedure BtnOkClick(Sender: TObject);
  end;

var
  FServerStatus: TFServerStatus;

implementation

{$R *.dfm}

uses UMTblDesc, DMsrvPc, gnugettext;

// -------------------------------------------------------------------------- //

constructor TFServerStatus.CreateForm(AOwner: TComponent);
begin
  inherited Create(Aowner);
  Caption              := _('Server Status');
  BtnOk.Caption        := _('OK');
  LabDateTime.Caption  := _('Date') + '/' + _('Time');
  LabDesc.Caption      := _('Description');
  LabOperation.Caption := _('Operation');
  LogMemo.Lines.Clear;
  LogMemo.Lines.AddStrings(ReadLog(true));

  ReSHape(Self);
//  ReShape(BtnOk);
end;

// -------------------------------------------------------------------------- //

function TFServerStatus.ReadLog(deleteOld: boolean): TStringList;
var
  tbInfo    : ^TTblInfo;
  qry       : TMqmQuery;
  s, logStr : String;
begin
  Result := TStringList.Create;
  qry := nil;
  try
    qry := CreateQuery(Cfg_DB);
    Qry.Transaction := CreateTransaction(Cfg_DB);

    tbInfo := @tblInfo[tbl_cfg_SrvLoad_Log];
    // Delete log records older than 24 hours
    if deleteOld then
    begin
      Qry.Transaction.StartTransaction;
      qry.SQL.Clear;
      qry.SQL.Add(SqlDeleteLog(tbInfo.GetTableName, CreateFld(tbInfo.pfx, fli_CurrDtTime)));
      qry.ExecSQL;
      Qry.Transaction.Commit
    end;
    // Read log table
    qry.Transaction.StartTransaction;
    qry.SQL.Clear;
    qry.SQL.Add('select * from ' +  tbInfo.GetTableName + WHERE_IDF_Condition(CreateFld(tbInfo.pfx, fli_identifier)) +  ' order by ' +
      CreateFld(tbInfo.pfx, fli_CurrDtTime) + ' asc');
    qry.Open;
    while not qry.Eof do
    begin
      logStr := qry.FieldByName(CreateFld(tbInfo.pfx, fli_CurrDtTime)).AsString;
      while length(logStr) < 22 do logStr := logStr + ' ';
      s := qry.FieldByName(CreateFld(tbInfo.pfx, fli_Operation)).AsString;
      while length(s) < 17 do s := s + ' ';
      logStr := logStr + s;
      s := qry.FieldByName(CreateFld(tbInfo.pfx, fli_Text)).AsString;
      logStr := logStr + s;
      Result.Add(logStr);
      qry.Next;
    end;
    qry.Close;
    qry.Transaction.Commit;
    qry.Free;
  except
    on e: Exception do
    begin
      Result.Add(e.Message);
      if assigned(qry) then qry.Free;
    end;
  end;
end;

//----------------------------------------------------------------------------//

procedure TFServerStatus.BtnOkClick(Sender: TObject);
begin
  LogMemo.Clear;
  Close;
end;

end.

