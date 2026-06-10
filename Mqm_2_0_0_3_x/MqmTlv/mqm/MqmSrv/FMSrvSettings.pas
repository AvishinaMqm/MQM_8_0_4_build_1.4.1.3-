unit FMSrvSettings;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ComCtrls, StdCtrls, Buttons, ExtCtrls, gnugettext, Vcl.Samples.Spin;

//const
//  NO_ALLIAS_EXIST = 'Please select alias for ODBC connection';

type
  TFSrvSettings = class(TForm)
    PGCset: TPageControl;
    PanBtn: TPanel;
    BtnOk: TBitBtn;
    BtnCanc: TBitBtn;
    TBOper: TTabSheet;
    TBTimings: TTabSheet;
    OpenDialog1: TOpenDialog;
    StDataPreparationName: TStaticText;
    SpeedButton1: TSpeedButton;
    EditPraperationName: TEdit;
    CBUploadDwndTillProcFinish: TCheckBox;
    GroupBox1: TGroupBox;
    RadioGroupTimeScalAuto: TRadioGroup;
    CBWaitAfterSend: TCheckBox;
    Label1: TLabel;
    TimePicker: TDateTimePicker;
    GBoxCopyDemndFromMqm: TGroupBox;
    SpinEdtHoursToleranceOfGapBetweenJobs: TSpinEdit;
    CBConfirmationLvlCopyFromMqm: TCheckBox;
    CBNumOfDaysCopyFromMqm: TCheckBox;
    RGConfLvl: TRadioGroup;
    StaticTextDaysKeepHistory: TStaticText;
    SEdtDaysToKeepHistory: TSpinEdit;
    CBForceMqmScheduleDetails: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure BtnOkClick(Sender: TObject);
    procedure SpeedButton1Click(Sender: TObject);
    procedure EditPraperationNameDblClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure SpinEditConfLvlChange(Sender: TObject);
    procedure SpinEdtHoursToleranceOfGapBetweenJobsChange(Sender: TObject);
    procedure CBWaitAfterSendClick(Sender: TObject);
    procedure CBUploadDwndTillProcFinishClick(Sender: TObject);
  private
    procedure UpdateFromDefault;
  public
    { Public declarations }
  end;


implementation

{$R *.DFM}

uses
  UMASStoredProc,
  UMGlobal,
  UMSrvConfig,
  UODBC,
  DMsrvPc,
  UMTblDesc,Winapi.ShlObj;

//----------------------------------------------------------------------------//

procedure TFSrvSettings.FormCreate(Sender: TObject);
var
  I     : Integer;
//  ODBCDriversList: TStrings;
begin
  TranslateComponent (self);

{$ifndef demo}

//  TBTimings.TabVisible := false;
{  CBTypeOp.Items.Add(_('All files'));
  CBTypeOp.Items.Add(_('Only production'));
  CBTypeOp.Items.Add(_('Only progressed'));
  ComboBoxCGFile.Items.Add(_('Include'));
  ComboBoxCGFile.Items.Add(_('Exclude'));
  CBDateFormat.Items.Add(_('yyyy mm dd hh mm'));
  CBDateFormat.Items.Add(_('Local Except Control'));
  CBDateFormat.Items.Add(_('Local Date Time'));
  CBDateFormat.Items.Add(_('DB2 Date Time'));
 }
{  ODBCDriversList := GetDSNList([dtUSER,dtSYSTEM],'');
  for I := 0 to ODBCDriversList.Count - 1 do
    ConnectionComboBox.Items.Add(ODBCDriversList.Strings[i]);   }

{  for I := 0 to ConnectionComboBox.Items.count -1 do
  begin
    if (IniAppGlobals.Alias = ConnectionComboBox.Items[I]) then
    begin
      ConnectionComboBox.ItemIndex := I;
      break;
    end;
  end; }

{$else}
  ConnectionComboBox.Items.Add(IniAppGlobals.PCAlias);
  ConnectionComboBox.ItemIndex := 0;
{$endif}
  UpdateFromDefault;

end;

procedure TFSrvSettings.FormShow(Sender: TObject);
begin
  if DBAppGlobals.License_BOTH_MQM_MCM then
  begin
    CBForceMqmScheduleDetails.Visible := true;
    GBoxCopyDemndFromMqm.Visible := true;
  end else
  begin
    GBoxCopyDemndFromMqm.Visible := false;
    CBForceMqmScheduleDetails.Visible := false;
  end;

end;

//----------------------------------------------------------------------------//

procedure TFSrvSettings.UpdateFromDefault;
var qry : TMqmQuery;
  tbl : PTblInfo;
  CopiedSchedTypeFromMqm, CopiedBackwardFromMqmDays
  ,cbCopiedSchedTypeFromMqm, cbCopiedBackwardFromMqmDays, CBForceMqmScheduleDetails: String;
begin
 { case GetTypeMode of
    TD_AllFiles : CBTypeOp.ItemIndex := 0;
    TD_OnlyProd : CBTypeOp.ItemIndex := 1;
    TD_OnlyProg : CBTypeOp.ItemIndex := 2;
  else
    CBTypeOp.ItemIndex := 0;
  end;

  if GetLoopMqmCG then
    ComboBoxCGFile.ItemIndex := 0
  else
    ComboBoxCGFile.ItemIndex := 1;  }

  case StrToInt(IniAppGlobals.TimeLoop) of
    1 : RadioGroupTimeScalAuto.ItemIndex := 0;
    2 : RadioGroupTimeScalAuto.ItemIndex := 1;
    3 : RadioGroupTimeScalAuto.ItemIndex := 2;
    4 : RadioGroupTimeScalAuto.ItemIndex := 3;
    5 : RadioGroupTimeScalAuto.ItemIndex := 4;
    6 : RadioGroupTimeScalAuto.ItemIndex := 5;
    7 : RadioGroupTimeScalAuto.ItemIndex := 6;
  end;

  if IniAppGlobals.OperateTimeLoopDnldUpload = '1' then
     CBWaitAfterSend.Checked := true;

  if IniAppGlobals.OperateWaitingTimeUploadDnld = '1' then
     CBUploadDwndTillProcFinish.Checked := true;


  //new read
  qry := CreateQuery(Cfg_DB);
  tbl := @tblInfo[tbl_cfg_appini];


  qry.SQL.Text := 'Select * from ' + tbl.getTableName + ' where AI_WKST_CODE = ' + QuotedStr('MQMSRVLOAD') + ' and AI_IDENTIFIER = ' + IniAppGlobals.Identifier;

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
     // SpinEdtHoursToleranceOfGapBetweenJobs.Value := StrToInt(IniAppGlobals.CopiedBackwardFromMqmDays);
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
     // SpinEdtHoursToleranceOfGapBetweenJobs.Value := StrToInt(IniAppGlobals.CopiedBackwardFromMqmDays);
    end;

    SpinEdtHoursToleranceOfGapBetweenJobs.Value := 0;
    if Trim(IniAppGlobals.CopiedBackwardFromMqmDays) <> '' then
      SpinEdtHoursToleranceOfGapBetweenJobs.Value := StrToInt(IniAppGlobals.CopiedBackwardFromMqmDays);


  end;


  if CBForceMqmScheduleDetails = '1' then
  begin
    Self.CBForceMqmScheduleDetails.Checked := true;
  end;

  TimePicker.Time := StrToTime(IniAppGlobals.TimePickerEndLoop);

 { case GetDateTimeFormat of
    Frm_As400 : CBDateFormat.ItemIndex := 0;
    Frm_TDateTimeExceptControl : CBDateFormat.ItemIndex := 1;
    Frm_TDateTime              : CBDateFormat.ItemIndex := 2;
    Frm_DB2                    : CBDateFormat.ItemIndex := 3
  end;   }

//  if IniAppGlobals.DaysKeepHistory = '0' then
//     IniAppGlobals.DaysKeepHistory := '21';
  SEdtDaysToKeepHistory.value := StrToInt(IniAppGlobals.DaysKeepHistory);
  EditPraperationName.Text := IniAppGlobals.PreparationExeName;

  qry.Close;
  qry.Free;
end;

//----------------------------------------------------------------------------//

procedure TFSrvSettings.BtnOkClick(Sender: TObject);
var
   Hour, Min, Sec, MSec: Word;
   T : TTime;
   qry : TMqmQuery;
   tbl : PTblInfo;
begin
  ModalResult := mrOk;
{  if (ConnectionComboBox.Items[ConnectionComboBox.ItemIndex] = '') then
  begin
    showmessage(_(NO_ALLIAS_EXIST));
    ModalResult := mrNone;
  end; }

  //new read

  case RadioGroupTimeScalAuto.ItemIndex of
    0 : IniAppGlobals.TimeLoop := '1';
    1 : IniAppGlobals.TimeLoop := '2';
    2 : IniAppGlobals.TimeLoop := '3';
    3 : IniAppGlobals.TimeLoop := '4';
    4 : IniAppGlobals.TimeLoop := '5';
    5 : IniAppGlobals.TimeLoop := '6';
    6 : IniAppGlobals.TimeLoop := '7'
  end;

  qry := CreateQuery(Cfg_DB);
  tbl := @tblInfo[tbl_cfg_appini];
  qry.Transaction := CreateTransaction(Cfg_DB);
  qry.Transaction.StartTransaction;

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

    DaysKeepHistory := IntToStr(SEdtDaysToKeepHistory.value);
  end;

  qry.Transaction.Commit;

  qry.Close;
//  qry.Free;

  GlobSaveIniValues;
  GlobLoadIniValues;

{  case CBTypeOp.ItemIndex of
    0 : SetTypeMode(TD_AllFiles);
    1 : SetTypeMode(TD_OnlyProd);
    2 : SetTypeMode(TD_OnlyProg);
  end;

  case ComboBoxCGFile.ItemIndex of
    0 : SetLoopMqmCG(true);
    1 : SetLoopMqmCG(false);
  end;

  case CBDateFormat.ItemIndex of
    0 : SetDateTimeFormat(Frm_As400);
    1 : SetDateTimeFormat(Frm_TDateTimeExceptControl);
    2 : SetDateTimeFormat(Frm_TDateTime);
    3 : SetDateTimeFormat(Frm_DB2);
  end;            }

  qry.Close;
  qry.Free;
end;

//----------------------------------------------------------------------------//

procedure TFSrvSettings.CBUploadDwndTillProcFinishClick(Sender: TObject);
begin
  if CBUploadDwndTillProcFinish.Checked then
  begin
    IniAppGlobals.OperateWaitingTimeUploadDnld := '1';
    CBWaitAfterSend.Checked := false
  end;
  if not CBUploadDwndTillProcFinish.Checked and not CBWaitAfterSend.Checked then
  begin
    IniAppGlobals.OperateTimeLoopDnldUpload := '0';
    IniAppGlobals.OperateWaitingTimeUploadDnld := '0';
  end;
end;

//----------------------------------------------------------------------------//

procedure TFSrvSettings.CBWaitAfterSendClick(Sender: TObject);
begin
  if CBWaitAfterSend.Checked then
  begin
    IniAppGlobals.OperateTimeLoopDnldUpload := '1';
    CBUploadDwndTillProcFinish.Checked := false
  end;
  if not CBUploadDwndTillProcFinish.Checked and not CBWaitAfterSend.Checked then
  begin
    IniAppGlobals.OperateTimeLoopDnldUpload := '0';
    IniAppGlobals.OperateWaitingTimeUploadDnld := '0';
  end;
end;

//----------------------------------------------------------------------------//

procedure TFSrvSettings.SpeedButton1Click(Sender: TObject);
begin
  OpenDialog1.Title := 'Open File';
  if OpenDialog1.Execute then
    EditPraperationName.Text := OpenDialog1.FileName;
  IniAppGlobals.PreparationExeName := EditPraperationName.Text;
end;

//----------------------------------------------------------------------------//

procedure TFSrvSettings.SpinEditConfLvlChange(Sender: TObject);
begin

end;

//----------------------------------------------------------------------------//

procedure TFSrvSettings.SpinEdtHoursToleranceOfGapBetweenJobsChange(
  Sender: TObject);
begin
//  if SpinEdtHoursToleranceOfGapBetweenJobs.Value > 0 then
//    CBNumOfDaysCopyFromMqm.Checked := true
//  else
//    CBNumOfDaysCopyFromMqm.Checked := false;
end;

//----------------------------------------------------------------------------//

procedure TFSrvSettings.EditPraperationNameDblClick(Sender: TObject);
begin
  EditPraperationName.Text := '';
  IniAppGlobals.PreparationExeName := '';
end;

end.
