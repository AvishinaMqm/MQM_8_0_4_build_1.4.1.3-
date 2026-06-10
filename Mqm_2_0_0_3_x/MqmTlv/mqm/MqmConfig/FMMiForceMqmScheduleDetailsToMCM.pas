unit FMMiForceMqmScheduleDetailsToMCM;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.StdCtrls,
  Vcl.Samples.Spin, Vcl.Buttons;

type
  TForceMqmScheduleDetailsToMCM = class(TForm)
    CBForceMqmScheduleDetails: TCheckBox;
    GBoxCopyDemndFromMqm: TGroupBox;
    SpinEdtHoursToleranceOfGapBetweenJobs: TSpinEdit;
    CBConfirmationLvlCopyFromMqm: TCheckBox;
    CBNumOfDaysCopyFromMqm: TCheckBox;
    RGConfLvl: TRadioGroup;
    PanBtn: TPanel;
    BtnOk: TBitBtn;
    BtnCanc: TBitBtn;
    procedure BtnOkClick(Sender: TObject);
    procedure UpdateFromDefault;
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  ForceMqmScheduleDetailsToMCM: TForceMqmScheduleDetailsToMCM;

implementation

{$R *.dfm}

uses DMsrvPc, UMTblDesc, UMGlobal;

procedure TForceMqmScheduleDetailsToMCM.BtnOkClick(Sender: TObject);
var
   Hour, Min, Sec, MSec: Word;
   T : TTime;
   qry : TMqmQuery;
   tbl : PTblInfo;
begin
  ModalResult := mrOk;

  qry := CreateQuery(Cfg_DB);
  qry.Transaction := CreateTransaction(Cfg_DB);
  qry.Transaction.StartTransaction;
  tbl := @tblInfo[tbl_cfg_appini];

  qry.sql.add('Delete from ' + tbl.GetTableName
    + ' where AI_WKST_CODE = ' + QuotedStr('MQMSRVLOAD')
    + ' and AI_IDENTIFIER = ' + IniAppGlobals.Identifier);

  qry.ExecSQL;

  with IniAppGlobals do
  begin


    if Self.CBForceMqmScheduleDetails.Checked then
    begin
      qry.sql.clear;
      qry.sql.add('Insert into ' + tbl.GetTableName + '(AI_WKST_CODE,AI_FIELDNAME,AI_VALUE,AI_IDENTIFIER) '
            +' Values('+ QuotedStr('MQMSRVLOAD') + ', ' + QuotedStr('CBForceMqmScheduleDetails') + ', ' + QuotedStr('1') + ', ' + QuotedStr(Identifier) + ')');
      qry.ExecSQL;

    end
    else
    begin
      qry.sql.clear;
      qry.sql.add('Insert into ' + tbl.GetTableName + '(AI_WKST_CODE,AI_FIELDNAME,AI_VALUE,AI_IDENTIFIER) '
            +' Values('+ QuotedStr('MQMSRVLOAD') + ', ' + QuotedStr('CBForceMqmScheduleDetails') + ', ' + QuotedStr('0') + ', ' + QuotedStr(Identifier) + ')');
      qry.ExecSQL;
    end;


    if CBConfirmationLvlCopyFromMqm.Checked then
    begin
      qry.sql.clear;
      qry.sql.add('Insert into ' + tbl.GetTableName + '(AI_WKST_CODE,AI_FIELDNAME,AI_VALUE,AI_IDENTIFIER) '
            +' Values('+ QuotedStr('MQMSRVLOAD') + ', ' + QuotedStr('cbCopiedSchedTypeFromMqm') + ', ' + QuotedStr('1') + ', ' + QuotedStr(Identifier) + ')');
      qry.ExecSQL;

      qry.sql.Clear;
      qry.sql.add('Insert into ' + tbl.GetTableName + '(AI_WKST_CODE,AI_FIELDNAME,AI_VALUE,AI_IDENTIFIER) '
            +' Values('+ QuotedStr('MQMSRVLOAD') + ', ' + QuotedStr('CopiedSchedTypeFromMqm') + ', ' + QuotedStr(IntToStr(RGConfLvl.ItemIndex)) + ', ' +  QuotedStr(Identifier) + ')');
      qry.ExecSQL;

    end
    else
    begin
      qry.sql.clear;
      qry.sql.add('Insert into ' + tbl.GetTableName + '(AI_WKST_CODE,AI_FIELDNAME,AI_VALUE,AI_IDENTIFIER) '
            +' Values('+ QuotedStr('MQMSRVLOAD') + ', ' + QuotedStr('cbCopiedSchedTypeFromMqm') + ', ' + QuotedStr('0') + ', ' + QuotedStr(Identifier) + ')');
      qry.ExecSQL;

      qry.sql.Clear;
      qry.sql.add('Insert into ' + tbl.GetTableName + '(AI_WKST_CODE,AI_FIELDNAME,AI_VALUE,AI_IDENTIFIER) '
            +' Values('+ QuotedStr('MQMSRVLOAD') + ', ' + QuotedStr('CopiedSchedTypeFromMqm') + ', ' + QuotedStr('0') + ', ' +  QuotedStr(Identifier) + ')');
      qry.ExecSQL;

    end;

    if CBNumOfDaysCopyFromMqm.Checked then
    begin

      qry.sql.Clear;
      qry.sql.add('Insert into ' + tbl.GetTableName + '(AI_WKST_CODE,AI_FIELDNAME,AI_VALUE,AI_IDENTIFIER) '
            +' Values('+ QuotedStr('MQMSRVLOAD') + ', ' + QuotedStr('cbCopiedBackwardFromMqmDays') + ', ' + QuotedStr('1') + ', ' +  QuotedStr(Identifier) + ')');
      qry.ExecSQL;

      qry.sql.Clear;
      qry.sql.add('Insert into ' + tbl.GetTableName + '(AI_WKST_CODE,AI_FIELDNAME,AI_VALUE,AI_IDENTIFIER) '
            +' Values('+ QuotedStr('MQMSRVLOAD') + ', ' + QuotedStr('CopiedBackwardFromMqmDays') + ', ' + QuotedStr(IntToStr(SpinEdtHoursToleranceOfGapBetweenJobs.Value)) + ', ' +  QuotedStr(Identifier) + ')');
      qry.ExecSQL;

    end
    else
    begin
      qry.sql.Clear;
      qry.sql.add('Insert into ' + tbl.GetTableName + '(AI_WKST_CODE,AI_FIELDNAME,AI_VALUE,AI_IDENTIFIER) '
            +' Values('+ QuotedStr('MQMSRVLOAD') + ', ' + QuotedStr('cbCopiedBackwardFromMqmDays') + ', ' + QuotedStr('0') + ', ' +  QuotedStr(Identifier) + ')');
      qry.ExecSQL;

      qry.sql.Clear;
      qry.sql.add('Insert into ' + tbl.GetTableName + '(AI_WKST_CODE,AI_FIELDNAME,AI_VALUE,AI_IDENTIFIER) '
            +' Values('+ QuotedStr('MQMSRVLOAD') + ', ' + QuotedStr('CopiedBackwardFromMqmDays') + ', ' + QuotedStr('0') + ', ' +  QuotedStr(Identifier) + ')');
      qry.ExecSQL;

    end;

  end;

  qry.Transaction.Commit;

  qry.Close;
  qry.Free;
end;

//----------------------------------------------------------------------------//

procedure TForceMqmScheduleDetailsToMCM.FormCreate(Sender: TObject);
begin
  UpdateFromDefault;
end;

//----------------------------------------------------------------------------//

procedure TForceMqmScheduleDetailsToMCM.UpdateFromDefault;
var
  qry : TMqmQuery;
  tbl : PTblInfo;
  CopiedSchedTypeFromMqm, CopiedBackwardFromMqmDays ,cbCopiedSchedTypeFromMqm,
  cbCopiedBackwardFromMqmDays, CBForceMqmScheduleDetails: String;
begin
  qry := CreateQuery(Cfg_DB);
  tbl := @tblInfo[tbl_cfg_appini];

  qry.SQL.Text := 'Select * from ' + tbl.getTableName + ' where AI_WKST_CODE = ' + QuotedStr('MQMSRVLOAD');
  qry.Open;

  if qry.RecordCount > 0 then
  begin
    while not qry.eof do
    begin
      if qry.FieldByName('AI_FIELDNAME').asString = 'cbCopiedSchedTypeFromMqm' then
        cbCopiedSchedTypeFromMqm := qry.FieldByName('AI_VALUE').asString
      else if qry.FieldByName('AI_FIELDNAME').asString = 'cbCopiedBackwardFromMqmDays' then
        cbCopiedBackwardFromMqmDays := qry.FieldByName('AI_VALUE').asString
      else if qry.FieldByName('AI_FIELDNAME').asString = 'CopiedSchedTypeFromMqm' then
        CopiedSchedTypeFromMqm := qry.FieldByName('AI_VALUE').asString
      else if qry.FieldByName('AI_FIELDNAME').asString = 'CopiedBackwardFromMqmDays' then
        CopiedBackwardFromMqmDays := qry.FieldByName('AI_VALUE').asString
      else if qry.FieldByName('AI_FIELDNAME').asString = 'CBForceMqmScheduleDetails' then
        CBForceMqmScheduleDetails := qry.FieldByName('AI_VALUE').asString;
      qry.Next;
    end;

    if CBCopiedSchedTypeFromMqm = '1' then
    begin
      CBConfirmationLvlCopyFromMqm.Checked := true;
      RGConfLvl.ItemIndex := StrToInt(CopiedSchedTypeFromMqm);
    end;

    if CBCopiedBackwardFromMqmDays = '1' then
    begin
      CBNumOfDaysCopyFromMqm.Checked := true;
    end;

    SpinEdtHoursToleranceOfGapBetweenJobs.Value := 0;
    if Trim(CopiedBackwardFromMqmDays) <> '' then
      SpinEdtHoursToleranceOfGapBetweenJobs.Value := StrToInt(CopiedBackwardFromMqmDays);

  end else
  begin

    if IniAppGlobals.CBCopiedSchedTypeFromMqm = '1' then
    begin
      CBConfirmationLvlCopyFromMqm.Checked := true;
      RGConfLvl.ItemIndex := StrToInt(IniAppGlobals.CopiedSchedTypeFromMqm);
    end;

    if IniAppGlobals.CBCopiedBackwardFromMqmDays = '1' then
    begin
      CBNumOfDaysCopyFromMqm.Checked := true;
    end;

    SpinEdtHoursToleranceOfGapBetweenJobs.Value := 0;
    if Trim(IniAppGlobals.CopiedBackwardFromMqmDays) <> '' then
      SpinEdtHoursToleranceOfGapBetweenJobs.Value := StrToInt(IniAppGlobals.CopiedBackwardFromMqmDays);

  end;

  if CBForceMqmScheduleDetails = '1' then
  begin
    self.CBForceMqmScheduleDetails.Checked := true;
  end;

  qry.Close;
  qry.Free;
end;

//----------------------------------------------------------------------------//

end.
